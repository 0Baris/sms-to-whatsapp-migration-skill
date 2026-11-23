# SMS to WhatsApp Migration Skill for Claude (Verimor)

**Migrate SMS and e-mail notifications to WhatsApp Business templates with Claude.** This Claude skill scans your project, turns SMS, e-mail and OTP messages into WhatsApp templates (utility, authentication, marketing), checks them against Meta's template rules and creates them in the [Verimor](https://www.verimor.com.tr) panel after you approve. It can also design two-way WhatsApp flows (quick-reply buttons, documents) and write the sending code. Works with Claude Code, Claude in Chrome and other AI agents. The skill itself is in Turkish. Not an official Verimor product; not affiliated with Meta or WhatsApp.

**SMS'ten WhatsApp'a geçiş için Claude skill'i.** Projenizdeki SMS ve e-posta bildirimlerini WhatsApp Business şablonlarına taşır ya da WhatsApp'a özgü yeni senaryolar (butonla cevap, belge, sohbet açan bildirim) üretir. Şablonları Meta kurallarına göre kontrol eder ve Verimor üzerinden Meta onayına hazırlar. Komut: `/whatsapp-migration`. Resmî bir Verimor ürünü değildir.

## Ne yapar?

Claude'a "bu projedeki SMS şablonlarımı WhatsApp'a çevirmek istiyorum" ya da "WhatsApp'ı bu projede nasıl kullanabiliriz?" dersiniz. Skill:

1. Projeyi tarayıp SMS, e-posta ve doğrulama kodu mesajlarını, ayrıca onay bekleyen kayıtlar, son tarihler, hatırlatmalar gibi olayları bulur.
   - Taşımada her mesajın WhatsApp'ta nasıl daha iyi olacağını önerir.
   - Yeni senaryo modunda iki yönlü akışlar önerir: "Geliyorum / Gelemiyorum", "Ödedim", belge başlıklı makbuz, sohbet açan bildirim.
2. Her mesajı **Hizmet (utility)**, **Doğrulama (OTP)** ya da **Pazarlama (marketing)** şablonu olarak sınıflandırır.
3. Metni şablona çevirir: ad, gövde, `{{1}}` değişkenleri, örnek değerler, URL butonu; pazarlamada izin ve çıkış yolunu ekler.
4. Türkçe metni [turkish-humanizer](https://github.com/DevVettel/turkish-humanizer) ile doğallaştırır (önerilir, şart değil).
5. Meta kurallarına göre kontrol eder; işlem mesajlarının pazarlama sayılmamasına dikkat eder.
6. Şablon dosyasını ve **gönderim eşlemesini** (hangi değişken koddaki hangi alandan dolar) projenize yazar.
7. Hazırladığı şablonların tamamını size gösterir ve **onayınızı ister**.
8. Onayladıklarınızı Verimor panelinde oluşturup Meta onayına gönderir.
9. İsterseniz gönderim kodunu da yazar: Verimor'un güncel dokümanını ([llms.txt](https://docs.verimor.com.tr/llms.txt), [WhatsApp API](https://docs.verimor.com.tr/developer/whatsapp/giris), [OpenAPI](https://docs.verimor.com.tr/openapi/whatsapp.yaml)) okuyup projenizin bildirim katmanına bağlar.

## Gerekenler

| Ne | Neden | Bağlantı |
|---|---|---|
| **Facebook hesabı ve WhatsApp Business** | Şablonlar Meta'da onaylanır; WhatsApp Business hesabınız bir Facebook (Meta Business) hesabına bağlı olmalı. Doğrulama (OTP) şablonu için ayrıca Meta işletme doğrulaması gerekir. | [business.facebook.com](https://business.facebook.com) |
| **Verimor hesabı** | Şablonlar Verimor paneli (OİM) üzerinden açılır ve gönderilir. Hızlı başvuruda 2000 ücretsiz SMS kampanyası var (koşullar Verimor'da). | [Hızlı başvuru](https://oim.verimor.com.tr/abonelik-basvurusu) |
| **Claude Code** | Projeyi tarar, şablonları hazırlar, isterseniz gönderim kodunu yazar. | [claude.com/claude-code](https://claude.com/claude-code) |
| **Claude in Chrome** | Şablonları Verimor panelinde sizin yerinize oluşturur. Yoksa skill her şablon için kopyala-yapıştır kartı verir, siz elle oluşturursunuz. | [claude.com/chrome](https://claude.com/chrome) |

Projeniz yoksa mesajlarınızı yapıştırmanız yeter. Metinleri doğallaştırmak için [turkish-humanizer](https://github.com/DevVettel/turkish-humanizer) kullanılır; aşağıdaki kurulum onu da kurar.

## Sıfırdan başlıyorsanız (yeni Meta ve Verimor hesabı)

Hesaplarınız hazırsa bu bölümü atlayın.

1. **Verimor hesabını açın ve bakiye yükleyin.** [Hızlı başvuru](https://oim.verimor.com.tr/abonelik-basvurusu) ile hesap açın, OİM'den bakiye yükleyin. Bakiye hem WhatsApp mesajları hem de 2. adımdaki yönlendirme araması için gerekir; bakiye yoksa yönlendirme çalışmaz.
2. **Numarayı doğrulamaya hazırlayın.** WhatsApp, numarayı doğrulama kodunu **telefonla arayarak** iletir. Verimor numaranızı kullanacaksanız OİM → Ses Hizmeti → **Akıllı Yönlendirme**'de şartı "Her zaman yönlendir" yapın ve kendi cep numaranızı listeye ekleyin. Ayar yaklaşık 3 dakikada devreye girer; doğrulama araması cebinize düşer. Yönlendirilen arama tarifenize göre bakiyeden düşer. İşiniz bitince yönlendirmeyi kapatabilirsiniz. ([Akıllı Yönlendirme rehberi](https://docs.verimor.com.tr/help/ses-hizmeti/akilli-yonlendirme))
3. **Meta (Facebook) hesabınızı hazırlayın.** İşletme Yöneticisi'nde (Business Manager) yönetici olan bir Facebook hesabı gerekir. **Hesap yeni açıldıysa yaklaşık bir hafta bekleyin:** bu sürede profil ve işletme bilgilerini tamamlayın, hesabı normal kullanın. Yeni açılmış bir hesapla hemen WhatsApp Business bağlayıp şablon göndermek Meta'nın otomatik incelemesine takılabilir ve hesap kısıtlanabilir.
4. **WhatsApp Business'ı Verimor'a bağlayın.** OİM → [Entegrasyonlar](https://oim.verimor.com.tr/integrations) → WhatsApp Business → **Kur** → **WhatsApp'ı Bağla**. Açılan Meta penceresinde numaranızı girip gelen doğrulama kodunu yazın. ([Kurulum](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/kurulum) · [Meta hesabını bağlama](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/meta-hesabi-baglama))
5. **Doğrulama (OTP) şablonu gerekecekse işletme doğrulamasını başlatın.** Meta Business Suite → Ayarlar → Güvenlik Merkezi → İşletme Doğrulaması (şirket belgesi ister, 1–3 iş günü). Hizmet ve Pazarlama şablonları bunu beklemeden oluşur.
6. **Skill'i kurun** (aşağıda) ve Claude Code'da `/whatsapp-migration` yazın.

## Verimor dokümanları

| Konu | Bağlantı |
|---|---|
| WhatsApp Business'a genel bakış | https://docs.verimor.com.tr/help/hizmetler/whatsapp-business |
| Kurulum ve Meta hesabını bağlama | [kurulum](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/kurulum) · [meta-hesabi-baglama](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/meta-hesabi-baglama) |
| Mesaj şablonları ve şablon oluşturma | [mesaj-sablonlari](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/mesaj-sablonlari) · [sablon-olusturma](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/sablon-olusturma) |
| Kampanya, işletme profili, API anahtarları | [kampanyasi-olusturma](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/kampanyasi-olusturma) · [isletme-profili](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/isletme-profili) · [api-anahtarlari](https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/api-anahtarlari) |
| Sorun çözümleri | https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/sorun-cozumleri |
| Geliştirici: WhatsApp API | [giriş](https://docs.verimor.com.tr/developer/whatsapp/giris) · [API referansı](https://docs.verimor.com.tr/developer/api-reference/whatsapp) · [llms.txt](https://docs.verimor.com.tr/llms.txt) |

## Kurulum

### Claude Code: tek satırda

```bash
curl -fsSL https://raw.githubusercontent.com/0Baris/sms-to-whatsapp-migration-skill/main/install.sh | bash
```

Script `whatsapp-migration` ile birlikte turkish-humanizer'ı da `~/.claude/skills/` altına kurar, eski kurulum varsa yedekler. Seçenekler (`... | bash -s -- <seçenek>`):

- `--project`: yalnız içinde bulunduğunuz projeye kurar (`.claude/skills/`).
- `--no-humanizer`: turkish-humanizer'ı kurmaz.
- `--ref v1.2.0`: belirli bir sürümü kurar.

Git gerekmez, yalnız `curl` ve `tar`. Kurduktan sonra yeni oturum açın.

### Claude Code: elle

```bash
git clone https://github.com/0Baris/sms-to-whatsapp-migration-skill.git
mkdir -p ~/.claude/skills
cp -r sms-to-whatsapp-migration-skill/whatsapp-migration ~/.claude/skills/
```

### Claude (claude.ai, masaüstü, mobil)

[Son sürümdeki](https://github.com/0Baris/sms-to-whatsapp-migration-skill/releases/latest) `whatsapp-migration.zip` dosyasını indirin (açmayın), **Ayarlar → Yetenekler → Skills → Skill yükle** ile yükleyin (menü adları sürüme göre değişebilir; Settings → Capabilities → Skills). Kod yürütme (code execution) açık olmalıdır.

## Yapay zekâ ajanları için hazır prompt

Aşağıdakilerden birini kopyalayıp ajanınıza yapıştırın.

**Claude Code** (skill'i kurar ve çalıştırır):

```text
whatsapp-migration skill'ini kur ve bu projede kullan.
1. Şu komutu çalıştır: curl -fsSL https://raw.githubusercontent.com/0Baris/sms-to-whatsapp-migration-skill/main/install.sh | bash -s -- --project
2. Skill'in talimatlarını oku: .claude/skills/whatsapp-migration/SKILL.md ve references/ altındaki dosyalar.
3. Projedeki SMS, e-posta ve doğrulama kodu mesajlarını bul, WhatsApp şablonu adaylarını tablo olarak göster.
4. Hiçbir şablonu Verimor'da oluşturmadan ya da Meta'ya göndermeden önce bana tam listeyi göster ve açık onayımı al.
```

**Skill desteği olmayan ajanlar** (Cursor, Codex, Gemini CLI, Windsurf ve benzerleri):

```text
WhatsApp Business şablonları hazırlamak için şu talimatları kullan ve bu projeye uygula:
https://raw.githubusercontent.com/0Baris/sms-to-whatsapp-migration-skill/main/whatsapp-migration/SKILL.md
Talimatın yönlendirdiği referans dosyalarını da oku (aynı adresteki references/ klasörü: verimor-panel.md, meta-kurallari.md, senaryolar.md).
Adımları sırayla izle: ön kontrol, mesaj envanteri, sınıflandırma, dönüştürme, kontrol listesi.
Şablonları önce bana göster; açık onayım olmadan Verimor panelinde oluşturma, Meta'ya gönderme, proje kodunu değiştirme.
Verimor API ayrıntılarını ezberden yazma, https://docs.verimor.com.tr/llms.txt adresindeki güncel dokümana bak.
```

## Kullanım

Claude Code'da doğrudan çağırın:

```
/whatsapp-migration
```

Ya da ne istediğinizi yazın, skill kendiliğinden devreye girer:

```
Bu projedeki SMS mesajlarını WhatsApp şablonuna çevir.
```

```
E-posta bildirimlerimizden WhatsApp'a taşınabilecekleri çıkar, ilk üçünü Verimor'da oluştur.
```

```
Bu projede WhatsApp'ı SMS'ten farklı nasıl kullanabiliriz? Butonla cevap alınabilecek senaryolar öner.
```

```
Şifre sıfırlama kodu için Verimor'da OTP şablonu hazırla, kod 3 dakika geçerli.
```

## Sınırlar

- Her kategoride (Hizmet, Doğrulama, Pazarlama) alıcının bu numarada WhatsApp mesajı almayı kabul ettiği kaydı sizin sisteminizde olmalı. SMS için toplanan numara WhatsApp opt-in'i sayılmaz. Pazarlamada ayrıca ticari ileti izni (genellikle İYS) gerekir.
- API ayrıntılarını ezberlemez; her seferinde Verimor dokümanına bakar. API değişirse skill güncellenmeden çalışmaya devam eder.
- Panelde oluşturma için tarayıcı aracı gerekir; yoksa kopyala-yapıştır kartları verilir. Her iki durumda Verimor'da bağlı bir WhatsApp Business hesabı şart.
- Şablonu Meta'ya göndermeden önce her zaman onayınızı ister.

## Başlamadan bilinmesi gerekenler

- **Doğrulama (OTP) şablonu için Meta işletme doğrulaması şarttır.** Doğrulanmamış hesapta Verimor `META_019` hatası verir, Meta da "Bu WhatsApp Business hesabı, mesaj şablonu oluşturma iznine sahip değil" der. Hizmet ve Pazarlama şablonları bundan etkilenmez. Doğrulama: Meta Business Suite → Ayarlar → Güvenlik Merkezi → İşletme Doğrulaması (şirket belgesi, 1–3 iş günü).
- **Şablon adı kilitlidir.** Şablon varken ad alınmıştır, silinse de aynı dilde 30 gün yeniden kullanılamaz. Pratikte reddedileni Düzenle ile düzeltin ya da yeni ad seçin.
- **Meta kategoriyi değiştirebilir.** Genel duyurular ve "devam edecek misiniz" gibi sorular Hizmet olarak gönderilse de Pazarlama'ya çekilebilir. Bildirimde yazan süre içinde itiraz edebilirsiniz (WhatsApp Yöneticisi → Kategori güncellemeleri).
- **Doğrulanmamış işletme sınırı.** İşletme doğrulaması olmayan hesap 24 saatte yaklaşık 250 farklı alıcıyla sohbet başlatabilir.

## Sorumluluk reddi

Resmî bir Verimor ürünü değildir. Meta ve WhatsApp ile bağlantısı, onayı ya da sponsorluğu yoktur; adlar sahiplerinin markalarıdır ve yalnız uyumluluğu belirtmek için kullanılır. KVKK, İYS ve Meta politikalarıyla ilgili ifadeler genel bilgidir, hukuki tavsiye değildir; kurallar değişir. Son doğrulama: 23 Kasım 2026.

## Lisans

MIT
