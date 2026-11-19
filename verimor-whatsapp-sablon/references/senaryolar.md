# WhatsApp'a özgü senaryolar

WhatsApp, SMS'in pahalı bir kopyası olarak kullanılırsa boşa gider. Farkı **iki yönlü** olmasında: kullanıcı butonla cevap verir, sohbet açılır, işlem mesajın içinde biter. Yeni senaryo tasarlarken bu bölümdeki yapı taşlarından seç.

## Yapı taşları

| Araç | Ne işe yarar | Gereken |
|---|---|---|
| **Hızlı yanıt butonu** (en fazla 10) | "Geliyorum / Gelemiyorum", "Onayla / Ertele", "Evet / Hayır" gibi tek dokunuşla cevap | Gelen cevabı işleyen webhook (Verimor gelen mesaj bildirimi) ve cevabı kayda yazan kod |
| **URL butonu** (en fazla 2) | Ayrıntı, ödeme, form, belge sayfası | Tokenlı ya da oturumlu sayfa |
| **Telefon butonu** | Tek dokunuşla arama (kulüp, destek) | Sabit numara |
| **Kodu Kopyala** | OTP | Doğrulama şablonu |
| **Medya başlığı** (görsel, video, belge) | Makbuz PDF'i, etkinlik afişi, maç kadrosu görseli | Gönderimde medya bağlantısı |
| **Carousel** (2–10 kart) | Birden fazla seçenek: haftanın etkinlikleri, ürünler | Pazarlama ya da uygun Hizmet kullanımı |
| **24 saat penceresi** | Kullanıcı cevap verince 24 saat boyunca şablonsuz, serbest mesaj atılabilir | Gelen mesajı işleyen kod ve gerekirse insan temsilci |
| **WhatsApp Flows / form** | Mesajın içinde çok adımlı form (kayıt, anket) | Sağlayıcı desteği; Verimor'da varlığını kontrol et, yoksa URL butonuyla web formu |

## Senaryo kalıpları

### 1. Onay isteyen hatırlatma (iki yönlü)
SMS: "Yarın 10.00'da randevunuz var."
WhatsApp: "Merhaba, {{1}} tarihli randevun yaklaşıyor. Gelebilecek misin?" + [Geliyorum] [Gelemiyorum] [Başka saat]
Kazanç: cevap doğrudan sisteme düşer, "gelemiyorum" diyene otomatik yeni saat önerilir.

### 2. Durum değişikliği + tek eylem
"{{1}} siparişin kargoya verildi." + [Kargoyu takip et]
"{{1}} tarihli antrenman iptal edildi." + [Yeni programı gör]

### 3. Belge ile bildirim
Makbuz, fatura, sözleşme, maç kadrosu: belge başlıklı Hizmet şablonu. E-postadaki ek WhatsApp'ta mesajın kendisi olur.

### 4. Eksik bilgi / onay toplama
"{{1}} için eksik belge var: {{2}}." + [Belgeyi yükle] (URL) ya da [Yarın yüklerim] (hızlı yanıt, hatırlatma kurar)

### 5. Ödeme hatırlatması + kolay yol
"{{1}} dönemi ödemen {{2}} TL, son gün {{3}}." + [Ödemeyi gör] [Ödedim] (Ödedim cevabı yöneticiye kontrol bildirimi düşer)

### 6. Geri bildirim / memnuniyet
İşlem bittikten sonra: "Bugünkü {{1}} nasıldı?" + [İyi] [Orta] [Kötü]. Kötü cevabına 24 saat penceresinde insan yanıt verir.
Not: genel anket Pazarlama sayılabilir; belli bir işleme bağla.

### 7. Sohbeti açan bildirim (24 saat penceresi)
Şablon yalnız konuşmayı açar: "{{1}} hakkında bir sorun var mı? Cevap yazarsan ekip yardımcı olur." Kullanıcı yazınca destek sohbeti serbest mesajla sürer.

### 8. Pazarlama (izinli kitleye)
Etkinlik duyurusu (görsel başlık + [Kayıt ol]), sezon kaydı açıldı, yeni hizmet. Çıkış yolu ([Abonelikten çık]) zorunlu.

## Tasarım soruları (kullanıcıya sor ya da koddan çıkar)

1. Hangi olaylarda kullanıcıdan **cevap** bekliyorsunuz? Bugün bu cevap nasıl toplanıyor (link, telefon, hiç)?
2. Hangi bildirimden sonra kullanıcı genelde **arıyor ya da yazıyor**? Orası sohbet açan şablon adayıdır.
3. E-postada **ek** olarak giden belge var mı?
4. Gelen cevapları işleyecek bir **webhook** var mı, kim yazacak?
5. Cevaplara **insan** bakacak mı, yoksa tamamen otomatik mi?

## Koddan senaryo çıkarma

- Durum makineleri (`status`, `state`, `pending → confirmed`), onay bekleyen kayıtlar, son tarih alanları (`dueOn`, `expiresAt`), hatırlatma cron'ları, "tekrar gönder" butonları: her biri iki yönlü bir WhatsApp senaryosuna aday.
- Bir kaydı "onaylandı / reddedildi" yapan her uç nokta, hızlı yanıt butonunun arkasına bağlanabilir.

## Teknik not

- Hızlı yanıt cevabı, butonun metni ya da tanımlı yükü (payload) olarak gelir. Hangi mesaja cevap verildiğini bilmek için gönderimde mesaj kimliğini kaydedin.
- Hiçbir cevabı işlemeyecekseniz hızlı yanıt kullanmayın; URL butonu koyun. Cevapsız kalan buton kullanıcıyı kızdırır.
