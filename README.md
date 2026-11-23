# verimor-whatsapp-migration-skill

**English summary:** An unofficial Claude skill (in Turkish) that turns a project's SMS and e-mail messages into WhatsApp Business templates, or designs new WhatsApp scenarios, for the Verimor platform.
It classifies each template (utility, authentication, marketing), checks it against Meta's rules and creates it in the Verimor panel only after you approve.
It can also write the sending code. Not affiliated with Verimor, Meta or WhatsApp.

Projeniz için WhatsApp Business şablonları tasarlayan, mevcut SMS ve e-postalarınızı taşıyan ya da WhatsApp'a özgü yeni senaryolar (butonla cevap, belge, sohbet açan bildirim) üreten ve bunları Verimor üzerinden Meta onayına hazırlayan bir [Claude skill'i](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview). Resmî bir Verimor ürünü değildir.

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

## Kurulum

Önerilir: [turkish-humanizer](https://github.com/DevVettel/turkish-humanizer) skill'ini kurun (kurulum için o reponun README'sine bakın). Kurulu değilse skill kısa yazım kurallarıyla çalışır.

Hangi özellik neye ihtiyaç duyar:

- **Claude Code:** projeyi taramak ve gönderim kodunu yazmak için.
- **Tarayıcı aracı:** şablonları Verimor panelinde sizin yerinize oluşturmak için. Yoksa skill her şablon için panel alan sırasında kopyala-yapıştır kartı verir, siz elle oluşturursunuz.
- Projeniz yoksa mesajlarınızı yapıştırmanız yeter.

### Claude Code: tek satırda

```bash
curl -fsSL https://raw.githubusercontent.com/0Baris/verimor-whatsapp-migration-skill/main/install.sh | bash
```

turkish-humanizer'ı da birlikte kurmak için:

```bash
curl -fsSL https://raw.githubusercontent.com/0Baris/verimor-whatsapp-migration-skill/main/install.sh | bash -s -- --with-humanizer
```

Script skill'i `~/.claude/skills/verimor-whatsapp` altına kurar, eski kurulum varsa yedekler. Yalnız bir projede kullanmak için o projenin klasöründe `--project` ekleyin; belirli bir sürüm için `--ref v1.1.0`. Git gerekmez, yalnız `curl` ve `tar`. Kurduktan sonra yeni oturum açın.

### Claude Code: elle

```bash
git clone https://github.com/0Baris/verimor-whatsapp-migration-skill.git
mkdir -p ~/.claude/skills
cp -r verimor-whatsapp-migration-skill/verimor-whatsapp ~/.claude/skills/
```

### Claude (claude.ai, masaüstü, mobil)

[Son sürümdeki](https://github.com/0Baris/verimor-whatsapp-migration-skill/releases/latest) `verimor-whatsapp.zip` dosyasını indirin (açmayın), **Ayarlar → Yetenekler → Skills → Skill yükle** ile yükleyin (menü adları sürüme göre değişebilir; Settings → Capabilities → Skills). Kod yürütme (code execution) açık olmalıdır.

## Yapay zekâ ajanları için hazır prompt

Aşağıdakilerden birini kopyalayıp ajanınıza yapıştırın.

**Claude Code** (skill'i kurar ve çalıştırır):

```text
verimor-whatsapp skill'ini kur ve bu projede kullan.
1. Şu komutu çalıştır: curl -fsSL https://raw.githubusercontent.com/0Baris/verimor-whatsapp-migration-skill/main/install.sh | bash -s -- --project
2. Skill'in talimatlarını oku: .claude/skills/verimor-whatsapp/SKILL.md ve references/ altındaki dosyalar.
3. Projedeki SMS, e-posta ve doğrulama kodu mesajlarını bul, WhatsApp şablonu adaylarını tablo olarak göster.
4. Hiçbir şablonu Verimor'da oluşturmadan ya da Meta'ya göndermeden önce bana tam listeyi göster ve açık onayımı al.
```

**Skill desteği olmayan ajanlar** (Cursor, Codex, Gemini CLI, Windsurf ve benzerleri):

```text
WhatsApp Business şablonları hazırlamak için şu talimatları kullan ve bu projeye uygula:
https://raw.githubusercontent.com/0Baris/verimor-whatsapp-migration-skill/main/verimor-whatsapp/SKILL.md
Talimatın yönlendirdiği referans dosyalarını da oku (aynı adresteki references/ klasörü: verimor-panel.md, meta-kurallari.md, senaryolar.md).
Adımları sırayla izle: ön kontrol, mesaj envanteri, sınıflandırma, dönüştürme, kontrol listesi.
Şablonları önce bana göster; açık onayım olmadan Verimor panelinde oluşturma, Meta'ya gönderme, proje kodunu değiştirme.
Verimor API ayrıntılarını ezberden yazma, https://docs.verimor.com.tr/llms.txt adresindeki güncel dokümana bak.
```

## Kullanım

Claude Code'da doğrudan çağırın:

```
/verimor-whatsapp
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

Gayriresmî topluluk aracıdır. Verimor, Meta ve WhatsApp ile bağlantısı, onayı ya da sponsorluğu yoktur; adlar sahiplerinin markalarıdır ve yalnız uyumluluğu belirtmek için kullanılır. KVKK, İYS ve Meta politikalarıyla ilgili ifadeler genel bilgidir, hukuki tavsiye değildir; kurallar değişir. Son doğrulama: 23 Kasım 2026.

## Lisans

MIT
