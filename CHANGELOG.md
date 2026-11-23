# Değişiklik günlüğü

## 1.2.0 (2026-11-23)

- Skill'in adı `whatsapp-migration` oldu (`/whatsapp-migration`), repo adı `sms-to-whatsapp-migration-skill`. `verimor-whatsapp` adıyla kurduysanız eski klasörü silin, kurulum scriptini yeniden çalıştırın.
- Kurulum scripti turkish-humanizer'ı varsayılan olarak birlikte kurar; istemeyen `--no-humanizer` kullanır.
- README'ye "Gerekenler" tablosu: WhatsApp Business bağlı Facebook hesabı, Verimor hızlı başvuru (2000 ücretsiz SMS kampanyası), Claude Code, Claude in Chrome.
- README'ye Verimor WhatsApp Business yardım ve geliştirici dokümanlarının listesi.
- Kurulum sonu mesajı `/whatsapp-migration` komutunu gösterir.
- README'ye "Sıfırdan başlıyorsanız" bölümü: bakiye yükleme, WhatsApp doğrulama araması için Akıllı Yönlendirme, yeni Meta hesabında bir hafta bekleme, Verimor'a bağlama, işletme doğrulaması. Skill'in ön kontrolü yeni hesapları bu sıraya yönlendirir.

## 1.1.0 (2026-11-23)

- Skill'in adı `verimor-whatsapp` oldu (`/verimor-whatsapp` ile çağrılır). Eski ad `verimor-whatsapp-sablon` idi; elle kurduysanız eski klasörü silip yenisini kurun.
- Tek satırlık kurulum scripti: `install.sh` (`--project`, `--with-humanizer`, `--ref`, eski kurulumu yedekler).
- Repo adı `sms-to-whatsapp-migration-skill`; claude.ai zip'i `verimor-whatsapp.zip`.

## 1.0.0 (2026-11-23)

İlk sürüm.

- SMS ve e-posta mesajlarını WhatsApp şablonuna taşıma; projenin olaylarından yeni WhatsApp senaryoları üretme.
- Hizmet, Doğrulama ve Pazarlama sınıflandırması, Meta kurallarına göre kontrol listesi, gönderim eşlemesi.
- Onay alındıktan sonra Verimor panelinde oluşturma; tarayıcı aracı yoksa kopyala-yapıştır kartları.
- İsteğe bağlı gönderim kodu: Verimor dokümanından doğrulayarak, yeni bağımlılık eklemeden.

Bu sürümde işlenen dersler:

- Doğrulama (OTP) şablonu için Meta işletme doğrulaması gerekir (`META_019`).
- Şablon adı varken kilitlidir; silinse de aynı dilde 30 gün yeniden kullanılamaz.
- Meta Hizmet şablonunu Pazarlama'ya çevirebilir; bildirimde yazan süre içinde itiraz edilebilir.
- Panel ipuçları: alan kayması, örnek değer alanları, Düzenle sınırları (24 saatte 1, 30 günde 10).
- Opt-in her kategori için gerekir; SMS izni WhatsApp opt-in'i sayılmaz.
- Ek Meta kuralları: aynı içerik, alt bilgide değişken, boşluk ve satır sonu sınırı, link kısaltıcı, buton gruplama, içerik politikası, OTP kod uzunluğu.
