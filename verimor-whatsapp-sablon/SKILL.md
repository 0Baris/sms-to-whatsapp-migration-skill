---
name: verimor-whatsapp-sablon
description: Bir projedeki mevcut SMS ve e-posta mesajlarını WhatsApp Business şablonlarına çevirir ve Verimor üzerinden Meta onayına hazırlar. Projeyi tarayıp mesajları bulur, her birini Hizmet (utility) ya da Doğrulama (OTP) şablonuna dönüştürür, metni turkish-humanizer ile doğallaştırır, Meta kurallarına ve pazarlama sayılmama ölçütlerine göre kontrol eder, şablon dosyası ve gönderim eşlemesi üretir, istenirse Verimor panelinde oluşturur. "SMS şablonlarımı WhatsApp'a çevir", "e-postalarımı WhatsApp şablonu yap", "Verimor WhatsApp şablonu oluştur", "utility / OTP şablonu" denince kullan.
---

# SMS ve e-postadan Verimor WhatsApp şablonuna

Kullanıcı "bu projedeki SMS (ya da e-posta) mesajlarımı WhatsApp'a taşımak istiyorum" der. Bu skill projedeki mesajları bulur, her birini Meta'nın onaylayacağı bir WhatsApp şablonuna çevirir ve Verimor'da oluşturulacak hâle getirir.

İşletmenin başlattığı her WhatsApp mesajı onaylı bir şablonla gider. Şablonun metni sabittir, yalnız `{{1}}`, `{{2}}` gibi değişkenler gönderimde dolar. Bu yüzden iş, serbest SMS/e-posta metnini kurallı bir şablona çevirmektir.

## Gerekenler

- **turkish-humanizer** skill'i: https://github.com/DevVettel/turkish-humanizer
  - Claude Code: repodaki `turkish-humanizer/` klasörünü `~/.claude/skills/` altına kopyala.
  - claude.ai: `dist/turkish-humanizer.zip` dosyasını Ayarlar → Yetenekler → Skills'ten yükle.
  - Yüklü değilse kullanıcıya söyle ve kurmasını iste. Kurulmadan devam etmen gerekirse `references/meta-kurallari.md` içindeki kısa yazım kurallarıyla çalış ve raporda belirt.
- Verimor'da bağlı bir WhatsApp Business hesabı (OİM → Entegrasyonlar → WhatsApp Business "Kurulu").

## Akış

1. **Envanter:** projedeki mesajları bul (aşağıda).
2. **Sınıflandır:** her mesaj için Hizmet / Doğrulama / kapsam dışı.
3. **Dönüştür:** şablon adı, gövde, değişken eşlemesi, örnek değerler, buton.
4. **Doğallaştır:** turkish-humanizer, tür "Gündelik".
5. **Kontrol et:** `references/meta-kurallari.md` listesi.
6. **Çıktı:** şablon dosyası + gönderim eşlemesi, kullanıcıya özet.
7. **Oluştur (isteğe bağlı, kullanıcı onayıyla):** Verimor paneli, `references/verimor-panel.md`.

Her adımın sonunda kullanıcıya kısa bilgi ver. Şablonu Meta'ya göndermek dışa açık bir işlemdir: metinleri kullanıcı onaylamadan gönderme.

## 1. Envanter: mesajları bul

Projenin dilini ve yapısını öğren, sonra mesajların durduğu yerleri ara. Metin araması için `rg` kullan.

| Nerede | Ne ara |
|---|---|
| SMS gönderimi | `sms`, `sendSms`, `send_sms`, Verimor/Netgsm/İleti Merkezi/Twilio istemcileri, `msgs`, `message` alanlı HTTP çağrıları |
| E-posta | `sendMail`, `sendEmail`, `mailer`, şablon klasörleri (`templates/`, `emails/`, `mail/`), `.mjml`, `.hbs`, `.ejs`, React Email bileşenleri |
| Çeviri dosyaları | `locales/`, `messages/`, `i18n/`, `*.json`/`*.yml` içinde `sms.`, `email.`, `mail.`, `notification.` anahtarları |
| Bildirim katmanı | `notify`, `notification`, `push` ile mesaj türlerini sayan enum'lar |
| Doğrulama kodları | `otp`, `verificationCode`, `resetCode`, `twoFactor`, kod süresi sabitleri (`TTL`, `expires`) |

Her mesaj için bir satır çıkar:

- **Kimlik:** dosya:satır ya da çeviri anahtarı
- **Tetikleyici:** hangi olayda gidiyor (kayıt, davet, ödeme günü, iptal)
- **Alıcı:** müşteri, üye, veli, personel
- **Değişkenler:** metindeki yer tutucular (`${name}`, `{{amount}}`, `%s`) ve anlamları
- **Bağlantı:** varsa hangi sayfaya gidiyor, token içeriyor mu
- **Kod süresi:** doğrulama mesajıysa koddaki geçerlilik süresi

Envanteri kullanıcıya tablo olarak göster ve hangilerinin taşınacağını sor. Varsayılan öneri: kullanıcıyı bir işlem yapmaya çağıran ya da durumunu bildiren mesajlar önce; bülten ve kampanya hariç.

## 2. Sınıflandır

| Kategori (Verimor / Meta) | Hangi mesajlar |
|---|---|
| **Hizmet / UTILITY** | Kullanıcının başlattığı ya da hesabıyla ilgili belli bir işleme bağlı: davet, onay isteği, randevu/etkinlik bilgisi ve değişikliği, sipariş, ödeme hatırlatması, başvuru sonucu, durum değişikliği |
| **Doğrulama / AUTHENTICATION** | Tek kullanımlık kod: kayıt doğrulama, giriş, şifre sıfırlama, 2FA |
| **Kapsam dışı** | Kampanya, indirim, bülten, genel duyuru, "uygulamamızı deneyin". Bunlar Pazarlama kategorisidir, İYS izni ve ayrı onay ister. Kullanıcıya söyle, dönüştürme. |

Pazarlama sayılmama ölçütleri `references/meta-kurallari.md` içinde. Sınırda kalan bir mesajı (ör. "etkinlik iptal edildi" duyurusu) Hizmet olarak yazabilirsin; tek işleme bağla ve tanıtım dili kullanma.

## 3. Dönüştür

Her mesaj için:

1. **Şablon adı:** olaydan türet, küçük harf + alt çizgi, Türkçe karakter yok (`randevu_hatirlatma`, `sifre_sifirlama`).
2. **Gövde:** kaynak metnin söylediğini kısa, tek amaçlı bir bildirime indir.
   - E-postanın uzun açıklamaları gövdeye girmez; ayrıntı bağlantının arkasında kalır.
   - SMS'teki kısaltmalar ("Sn.", "bilg.", "tikla") açılır, Türkçe karakterler düzelir.
   - Selamlama ve imza: "Merhaba," ile başla; marka adı alt bilgiye.
3. **Değişkenler:** kaynak yer tutucuları sırayla `{{1}}`, `{{2}}`... yap ve bir eşleme tablosu tut (`{{1}}` ← `club.name`). Gerekmeyen değişkeni at, en az bilgiyle yaz.
4. **Örnek değerler:** her değişken için gerçekçi ama uydurma değer.
5. **Buton:** kaynakta bağlantı varsa URL butonu yap. Sabit kısım alan adı ve yol; değişen kısım (token, id) sonda tek değişken: `https://alanadi.com/davet/{{1}}`. Bağlantının sorgu parametreleri varsa son eke dahil et.
6. **Doğrulama mesajları:** gövdeyi Meta üretir. Yalnız güvenlik uyarısını, kod süresini ve Kodu Kopyala butonunu ayarla. Süreyi koddaki süreyle eşitle; kod süresi uzunsa (10–15 dk) kullanıcıya kısaltmayı öner (3–5 dk).

Hitap projenin diline uysun (sen ya da siz) ve tüm şablonlarda aynı kalsın.

## 4. Doğallaştır

Her gövdeyi turkish-humanizer ile geçir. Tür: **Gündelik**. Sonra şunları kontrol et:

- Değişkenlerin sayısı ve sırası değişmedi.
- Gövde hâlâ değişkenle başlamıyor ve bitmiyor.
- Metin kısaldıysa anlam kaybolmadı.

## 5. Kontrol

`references/meta-kurallari.md` içindeki listeyi her şablon için tek tek işaretle. Takılan şablonu düzelt; düzeltemiyorsan nedenini rapora yaz.

## 6. Çıktı

Proje içinde, kullanıcının uygun gördüğü yere (varsayılan `docs/whatsapp-sablonlari.md`) şunları yaz:

- Her şablon için: ad, kategori, dil, gövde, alt bilgi, buton, örnek değerler, kaynak mesaj (dosya:satır / anahtar).
- **Gönderim eşlemesi:** şablon değişkenlerinin koddaki hangi alandan dolacağı (`{{1}}` ← `user.firstName`). Kod tarafını yazacak geliştirici bunu kullanır.
- Dönüştürülmeyen mesajlar ve nedeni.

Kullanıcı isterse aynı içeriği JSON olarak da ver (ad, kategori, dil, bileşenler); Verimor API'si ya da başka bir araçla toplu oluşturmak için işe yarar. Gönderim kodunu yazmak bu skill'in işi değil; kullanıcı isterse ayrı bir iş olarak ele al.

## 7. Verimor'da oluştur (isteğe bağlı)

Kullanıcı metinleri onayladıysa ve tarayıcı aracın varsa panelde oluşturabilirsin. Adımlar, alan sınırları ve sık hatalar: `references/verimor-panel.md`. Kullanıcı kaç tane istiyorsa o kadar oluştur; hepsini birden gönderme zorunluluğu yok.

## Çocuk ve kişisel veri

- Alıcı veli ya da mesaj bir çocukla ilgiliyse çocuğun adı yalnız "Ad S." biçiminde geçsin. Doğum tarihi, sağlık, adres, kimlik numarası şablona girmez.
- Örnek değerlere gerçek kişi adı, telefon, e-posta yazma.
- Hassas ayrıntıyı bağlantının arkasındaki oturumlu ya da tokenlı sayfaya bırak.

## Yapma

- Kullanıcı onaylamadan şablonu Meta'ya gönderme.
- Pazarlama mesajını Hizmet kategorisine sokmaya çalışma; Meta kategoriyi değiştirir, hesap kalitesi düşer.
- Kaynak mesajda olmayan bilgi, vaat ya da tutar ekleme.
- Hesap ayarlarını, ödeme yöntemini, entegrasyonu değiştirme.
- Projenin kodunu (gönderim katmanı) kullanıcı istemeden değiştirme.
