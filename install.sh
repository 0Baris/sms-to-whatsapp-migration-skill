#!/usr/bin/env bash
# sms-to-whatsapp-migration-skill kurulumu (resmî değildir).
#
#   curl -fsSL https://raw.githubusercontent.com/0Baris/sms-to-whatsapp-migration-skill/main/install.sh | bash
#
# Seçenekler (curl ... | bash -s -- <seçenek>):
#   --project           ~/.claude/skills yerine bu dizindeki .claude/skills altına kurar
#   --dir <yol>         skills klasörünü elle seçer
#   --no-humanizer      turkish-humanizer'ı kurmaz (varsayılan olarak birlikte kurulur)
#   --ref <dal|etiket>  belirli bir sürümü kurar (varsayılan: main)
#   -h, --help          bu yardımı gösterir
set -euo pipefail

REPO="0Baris/sms-to-whatsapp-migration-skill"
SKILL="whatsapp-migration"
HUMANIZER_REPO="DevVettel/turkish-humanizer"
HUMANIZER_SKILL="turkish-humanizer"

ref="main"
dir="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
with_humanizer=1

usage() {
  cat <<'EOF'
sms-to-whatsapp-migration-skill kurulumu (resmî değildir).

  curl -fsSL https://raw.githubusercontent.com/0Baris/sms-to-whatsapp-migration-skill/main/install.sh | bash

Seçenekler (curl ... | bash -s -- <seçenek>):
  --project           ~/.claude/skills yerine bu dizindeki .claude/skills altına kurar
  --dir <yol>         skills klasörünü elle seçer
  --no-humanizer      turkish-humanizer'ı kurmaz (varsayılan olarak birlikte kurulur)
  --ref <dal|etiket>  belirli bir sürümü kurar (varsayılan: main)
  -h, --help          bu yardımı gösterir
EOF
}
fail() { printf 'Hata: %s\n' "$1" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --project) dir="$PWD/.claude/skills" ;;
    --dir) [ $# -ge 2 ] || fail "--dir bir yol ister"; dir="$2"; shift ;;
    --no-humanizer) with_humanizer=0 ;;
    --with-humanizer) with_humanizer=1 ;; # eski seçenek, artık varsayılan
    --ref) [ $# -ge 2 ] || fail "--ref bir dal ya da etiket ister"; ref="$2"; shift ;;
    -h | --help) usage; exit 0 ;;
    *) fail "bilinmeyen seçenek: $1 (yardım için --help)" ;;
  esac
  shift
done

command -v curl >/dev/null 2>&1 || fail "curl bulunamadı"
command -v tar >/dev/null 2>&1 || fail "tar bulunamadı"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Bir GitHub reposunun arşivini indirir, içindeki skill klasörünü hedefe kopyalar.
install_skill() {
  local repo="$1" skill="$2" gitref="$3"
  local work="$tmp/$skill"
  mkdir -p "$work"
  printf '→ %s indiriliyor (%s)...\n' "$repo" "$gitref"
  curl -fsSL "https://codeload.github.com/$repo/tar.gz/$gitref" -o "$work/src.tar.gz" ||
    fail "$repo indirilemedi ($gitref var mı?)"
  tar -xzf "$work/src.tar.gz" -C "$work"
  local src
  src="$(find "$work" -mindepth 2 -maxdepth 2 -type d -name "$skill" | head -n 1)"
  [ -n "$src" ] && [ -f "$src/SKILL.md" ] || fail "$repo içinde $skill/SKILL.md bulunamadı"

  mkdir -p "$dir"
  if [ -e "$dir/$skill" ]; then
    local backup="$dir/.$skill.yedek-$(date +%Y%m%d%H%M%S)"
    mv "$dir/$skill" "$backup"
    printf '  eski kurulum yedeklendi: %s\n' "$backup"
  fi
  cp -R "$src" "$dir/$skill"
  printf '✓ %s kuruldu: %s\n' "$skill" "$dir/$skill"
}

install_skill "$REPO" "$SKILL" "$ref"

if [ "$with_humanizer" -eq 1 ]; then
  install_skill "$HUMANIZER_REPO" "$HUMANIZER_SKILL" "main"
fi

printf '\nBitti. Claude Code'"'"'da yeni bir oturum açın ve şunu yazın:\n'
printf '  /whatsapp-migration\n'
printf 'ya da doğrudan isteyin: "Bu projedeki SMS mesajlarını WhatsApp şablonuna çevir."\n'
