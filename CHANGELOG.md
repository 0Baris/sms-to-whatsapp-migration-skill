# Değişiklik günlüğü

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
