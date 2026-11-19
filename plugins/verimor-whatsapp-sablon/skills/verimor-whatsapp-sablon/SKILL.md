---
name: verimor-whatsapp-sablon
description: Verimor Online İşlem Merkezi (OİM) üzerinden WhatsApp Business mesaj şablonu (Hizmet/utility, Doğrulama/OTP) yazar ve oluşturur. Metni turkish-humanizer ile doğallaştırır, Meta kurallarına ve "pazarlama sayılmama" ölçütlerine göre kontrol eder, panelde adım adım girer. "WhatsApp şablonu oluştur", "Verimor şablon", "utility şablon", "OTP şablonu" denince kullan.
---

# Verimor WhatsApp şablon oluşturma

WhatsApp Business'ta işletmenin başlattığı her mesaj, Meta'nın onayladığı bir şablonla gider. Bu skill şablonun metnini yazar, doğallaştırır, kurallara göre kontrol eder ve Verimor panelinde oluşturur.

## Ne zaman

- Kullanıcı yeni bir WhatsApp şablonu istiyor (bildirim, davet, hatırlatma, doğrulama kodu).
- Var olan bir e-posta ya da SMS akışını WhatsApp'a taşıyor.
- Meta bir şablonu reddetti ya da kategorisini değiştirdi.

## Önce sor (bir kerede, kısa)

1. Mesaj hangi olayda gidiyor? (davet, onay isteği, randevu, ödeme hatırlatması, kod)
2. Alıcı kim? (müşteri, veli, üye) Çocuk verisi var mı?
3. Mesajdaki değişken bilgiler neler? (ad, tarih, tutar, bağlantı)
4. Buton gerekiyor mu, gidecek adres ne? (sabit alan adı + değişken son ek)

Kampanya, indirim, duyuru istiyorsa bu skill'in kapsamı dışında kalır: Pazarlama kategorisi ayrı onay ve İYS izni ister. Kullanıcıya söyle.

## 1. Kategori seç

| Verimor adı | Meta adı | Ne için |
|---|---|---|
| Hizmet | UTILITY | Kullanıcının başlattığı ya da hesabıyla ilgili belirli bir işleme bağlı bilgi: davet, onay isteği, randevu, sipariş, ödeme hatırlatması, durum değişikliği |
| Doğrulama | AUTHENTICATION | Tek kullanımlık kod (OTP) |
| Pazarlama | MARKETING | Tanıtım, kampanya, genel duyuru. Bu skill'de yok. |

### Pazarlama sayılmama ölçütleri (Hizmet şablonu)

Meta, metni okuyup kategoriyi kendisi değiştirebilir. Hizmet olarak kalması için:

- Mesaj **tek ve belli bir işleme** bağlı olsun: "{{1}} için davet", "{{2}} tarihli antrenman", "{{3}} dönemi aidatı".
- **Tek eylem**, o işlemle ilgili: "Daveti aç", "Cevap ver", "Ödemeyi gör".
- Şunlar olmasın: indirim, fırsat, "hemen", "kaçırma", "yeni özellik", ünlem, emoji, genel uygulama tanıtımı, birden fazla ürün.
- "Duyuru" türü (kulüp duyurusu, bülten) çoğu zaman pazarlama sayılır. Ancak belli bir işleme bağlıysa (iptal edilen etkinlik gibi) Hizmet olabilir.
- Ödeme hatırlatmasında baskı dili yok: tutar, dönem, son gün ve "ödemeyi yaptıysan dikkate alma" yeter.

## 2. Metni yaz

Kurallar (Meta + Verimor paneli):

- **Şablon adı:** küçük harf, rakam ve alt çizgi (`veli_davet`, `yoklama_sorusu`). Türkçe karakter yok.
- **Gövde:** en fazla 1024 karakter. Değişkenler `{{1}}`, `{{2}}` ... sırayla.
- **Gövde değişkenle başlayamaz ve bitemez.** "Merhaba, {{1}} ..." gibi bir girişle başla, sabit bir cümleyle bitir.
- İki değişken yan yana gelmesin, araya sabit metin koy.
- Değişken sayısı metne oranla az olsun. Neredeyse tamamı değişken olan gövde reddedilir.
- **Başlık** (isteğe bağlı) ve **alt bilgi** (isteğe bağlı) en fazla 60 karakter. Alt bilgiye marka adını yazmak yeterli.
- **Her değişken için örnek değer** zorunlu. Gerçekçi ama uydurma değer ver; kişisel veri koyma. Kişi adı gerekiyorsa "Ali Y." gibi kısaltılmış biçim kullan.
- **Butonlar:** en fazla 10; en fazla 2 URL, 1 telefon, 1 Kodu Kopyala. Buton metni en fazla 25 karakter.
- **URL butonu:** sabit alan adı + sonda tek değişken: `https://ornek.com/davet/{{1}}`. Örnek tam adres de istenir: `https://ornek.com/davet/abc123`. Değişken yalnız sonda olabilir.
- Hitap tutarlı olsun (sen ya da siz). Hepsinde aynısını kullan.

### Çocuk ve kişisel veri

- Çocuk adı varsa yalnız "Ad S." biçiminde gitsin. Doğum tarihi, sağlık, adres gibi bilgiler şablona girmez.
- Ayrıntı bağlantının arkasında, oturum ya da token korumalı sayfada dursun. Mesajın kendisi en az bilgiyi taşısın.

## 3. Doğallaştır (turkish-humanizer)

Metni yazınca `turkish-humanizer` skill'ini çağır. Tür: **Gündelik** (kısa bildirim). Özellikle:

- "-mektedir", "tarafınıza", "ilgili", "söz konusu" gibi bürokratik dili temizle.
- "Sadece ... değil, aynı zamanda ..." ve benzeri çeviri kalıplarını at.
- Şart ekinden sonra virgül koyma (TDK).
- Uzun çizgi (—) kullanma.

Humanizer metni kısaltabilir. Değişkenlerin (`{{n}}`) sırasını ve sayısını değiştirmediğini kontrol et.

## 4. Kontrol listesi (göndermeden önce)

- [ ] Kategori doğru (Hizmet/Doğrulama), pazarlama ölçütlerinden hiçbiri yok
- [ ] Gövde değişkenle başlamıyor, bitmiyor; değişkenler sıralı ve yan yana değil
- [ ] Her değişkenin örnek değeri var, kişisel veri yok
- [ ] Buton metni ≤ 25 karakter, URL değişkeni sonda, örnek URL girilmiş
- [ ] Ad, karakter sınırları, hitap tutarlı
- [ ] Çocuk adı "Ad S.", hassas veri yok
- [ ] Kullanıcı metni onayladı (şablonu Meta'ya göndermek dışa açık bir işlem)

## 5. Verimor panelinde oluştur

Yol: **OİM → WhatsApp → Şablonlar → Yeni Şablon** (`https://oim.verimor.com.tr/whatsapp_templates`). Pencere üç adımlı; sağda canlı önizleme var.

1. **Temel Bilgiler:** Şablon Adı, Kategori (Hizmet / Doğrulama), Dil (Türkçe), Şablon Türü (Standart). Devam Et.
2. **İçerik:** Başlık (isteğe bağlı), Mesaj İçeriği, değişkenler yazılınca altta açılan **örnek değer** alanları, Alt Bilgi. Panel hatayı kırmızı yazıyla gösterir ("Mesaj içeriği değişkenle başlayamaz" gibi). Devam Et.
3. **Butonlar:** Buton Ekle → tür (URL / Telefon / Hızlı Yanıt), metin, adres, örnek tam adres. Şablon Oluştur.

Oluşan şablon listede **Beklemede** görünür; Meta onayı genelde birkaç saat ile 1 gün sürer. Onaydan sonra **Onaylı** olur. Reddedilen şablon "Düzenle" ile düzeltilip yeniden gönderilir; düzenlemede boş bırakılan başlık ve alt bilgi silinir.

Tarayıcı aracıyla dolduruyorsan her adımdan sonra ekran görüntüsü al: alanların yeri değişken sayısına göre kayar.

### Doğrulama (OTP) şablonu

- Metni Meta sabit üretir ("{{1}} doğrulama kodunuzdur."); başlık, URL, medya ve emoji yok.
- Ayarlanabilenler: "Güvenliğiniz için bu kodu kimseyle paylaşmayın" uyarısı, kodun geçerlilik süresi (1–90 dk) ve Kodu Kopyala butonu (zorunlu).
- Süre, uygulamadaki kod süresiyle aynı olsun (kısa tut: 3–5 dk).
- Meta'da "mesaj geçerlilik süresi" ayrı bir ayardır; kod süresinden uzun olmasın.

## Sık hatalar

| Hata | Anlamı | Ne yap |
|---|---|---|
| `Mesaj içeriği değişkenle başlayamaz` | Gövde `{{1}}` ile başlıyor | Başa sabit giriş ekle |
| `APPLICATION_004 … cx_app_id` | Verimor'un entegrasyon kaydında iş ortağı uygulama kimliği eksik | Kullanıcı Verimor desteğine bildirsin; panelden düzelmez |
| `META_019 … 403 Forbidden` | İş ortağı uygulamasının bu şablon türünü (çoğu zaman Doğrulama) açma izni yok | Verimor/iş ortağı desteği; Hizmet şablonları ayrıca denenebilir |
| Meta: "Bu WhatsApp Business hesabı, mesaj şablonu oluşturma iznine sahip değil" | Hesap bir iş ortağı (BSP) üzerinden bağlı; şablonlar yalnız iş ortağı panelinden açılır | Meta WhatsApp Yöneticisi yerine Verimor panelini kullan |
| Kategori Pazarlama'ya çevrildi | Metin tanıtım gibi okunuyor | Pazarlama ölçütlerini temizle, tek işleme bağla, yeniden gönder |

## Örnek (Hizmet)

```
Ad: yoklama_sorusu   Kategori: Hizmet   Dil: Türkçe
Gövde: Merhaba, {{1}} takımının {{2}} antrenmanı için katılım bilgisi isteniyor. {{3}} bu antrenmana gelecek mi? Cevabını aşağıdaki bağlantıdan verebilirsin.
Örnekler: {{1}} U12 B · {{2}} 22 Kasım Cumartesi 10.00 · {{3}} Ali Y.
Alt bilgi: <Marka>
Buton (URL): "Cevap ver" → https://ornek.com/katilim/{{1}}   örnek: https://ornek.com/katilim/abc123
```

## Yapma

- Kullanıcı onaylamadan şablonu Meta'ya gönderme.
- Pazarlama içeriğini Hizmet kategorisine sokmaya çalışma; hesap kalitesi düşer.
- Örnek değerlere gerçek kişi adı, telefon, e-posta yazma.
- Hesap ayarlarını, ödeme yöntemini, entegrasyonu değiştirme; skill yalnız şablon oluşturur.
