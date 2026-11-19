# Verimor panelinde şablon oluşturma

Yol: **OİM → WhatsApp → Şablonlar → Yeni Şablon** (`https://oim.verimor.com.tr/whatsapp_templates`). Pencere üç adımlı; sağda canlı önizleme var. Resmî rehber: https://docs.verimor.com.tr/help/hizmetler/whatsapp-business/sablon-olusturma

## Adımlar

1. **Temel Bilgiler:** Şablon Adı, Kategori (Pazarlama / Hizmet / Doğrulama), Dil (Türkçe), Şablon Türü (Standart). Devam Et.
2. **İçerik:**
   - Hizmet: Başlık (isteğe bağlı), Mesaj İçeriği, değişkenler yazılınca altta açılan **örnek değer** alanları, Alt Bilgi.
   - Doğrulama: metin sabit; "Güvenlik tavsiyesi ekle" anahtarı ve Kod Geçerlilik Süresi (dakika).
   - Panel kural hatasını alanın altında kırmızı yazıyla gösterir ("Mesaj içeriği değişkenle başlayamaz").
   - Devam Et.
3. **Butonlar:** Buton Ekle → tür (URL / Telefon / Hızlı Yanıt), metin, adres, örnek tam adres. Doğrulamada Kodu Kopyala zorunlu ve tek buton. **Şablon Oluştur.**

Oluşan şablon listede **Beklemede** görünür. Meta onayı genelde birkaç saat ile 1 gün sürer, sonra **Onaylı** olur. Reddedilen şablon listedeki **Düzenle** ile düzeltilip yeniden gönderilir. Düzenlemede tüm içerik yeniden gönderilir; boş bırakılan başlık ve alt bilgi silinir.

## Tarayıcı aracıyla doldururken

- Alanların yeri değişken sayısına göre kayar: her adımdan sonra ekran görüntüsü al, koordinatı yeniden oku.
- Örnek değer alanları gövdeye değişken yazıldıktan sonra açılır.
- Her şablondan sonra listede "Beklemede" satırını ve başarı bildirimini doğrula.
- Kullanıcı istediği kadar şablon oluştur, sonra dur.

## Sık hatalar

| Hata | Anlamı | Ne yapılır |
|---|---|---|
| `Mesaj içeriği değişkenle başlayamaz` | Gövde `{{1}}` ile başlıyor | Başa sabit giriş ekle |
| `APPLICATION_004 … cx_app_id` | Verimor'un entegrasyon kaydında iş ortağı uygulama kimliği eksik | Kullanıcı Verimor desteğine bildirsin; panelden düzelmez |
| `META_019 … 403 Forbidden` | İş ortağı uygulamasının bu şablon türünü (çoğu zaman Doğrulama) açma izni yok | Verimor desteği; Hizmet şablonlarına devam edilebilir |
| Meta: "Bu WhatsApp Business hesabı, mesaj şablonu oluşturma iznine sahip değil" | Hesap bir iş ortağı (BSP) üzerinden bağlı; şablon yalnız iş ortağı panelinden açılır | Meta WhatsApp Yöneticisi yerine Verimor panelini kullan |
| Kategori Pazarlama'ya çevrildi | Metin tanıtım gibi okunuyor | Pazarlama ölçütlerini temizle, tek işleme bağla, yeniden gönder |
| Şablon Reddedildi | Meta kuralı (değişken oranı, belirsiz içerik, yanlış kategori) | Red nedenini oku, kontrol listesini yeniden uygula |

## Örnek

```
Kaynak (SMS): "Sn. ${name}, ${date} tarihli randevunuz onaylanmistir. Detay: ${url}"

Ad: randevu_onayi   Kategori: Hizmet   Dil: Türkçe
Gövde: Merhaba, {{1}} tarihli randevun onaylandı. Ayrıntıları aşağıdaki bağlantıda görebilirsin.
Örnek: {{1}} 22 Kasım Cumartesi 10.00
Alt bilgi: <Marka>
Buton (URL): "Randevuyu gör" → https://alanadi.com/randevu/{{1}}   örnek: https://alanadi.com/randevu/abc123
Eşleme: gövde {{1}} ← appointment.date (biçim: "22 Kasım Cumartesi 10.00"), buton {{1}} ← appointment.token
Not: kaynaktaki ad bilgisi gövdeye alınmadı (gereksiz kişisel veri).
```
