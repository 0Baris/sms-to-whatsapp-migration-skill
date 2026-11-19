# Meta şablon kuralları ve kontrol listesi

## Metin

- **Şablon adı:** küçük harf, rakam, alt çizgi. Türkçe karakter ve boşluk yok.
- **Gövde:** en fazla 1024 karakter.
- **Gövde değişkenle başlayamaz ve bitemez.** Başa sabit bir giriş ("Merhaba,"), sona sabit bir cümle koy.
- **Değişkenler** `{{1}}`, `{{2}}`... sırayla, atlamadan. İki değişken yan yana gelmesin.
- Değişken sayısı metne oranla az olsun; neredeyse tamamı değişken olan gövde reddedilir.
- **Başlık** (isteğe bağlı) ve **alt bilgi** (isteğe bağlı): en fazla 60 karakter.
- **Her değişkene örnek değer** zorunlu.
- Emoji, ünlem yığını, büyük harfle bağırma yok.

## Butonlar

- En fazla 10 buton; en fazla 2 URL, 1 telefon, 1 Kodu Kopyala.
- Buton metni en fazla 25 karakter.
- URL butonunda değişken yalnız sonda olabilir: `https://alanadi.com/yol/{{1}}`. Ayrıca örnek tam adres istenir.
- Hızlı yanıt butonları gelen cevabı işleyecek bir webhook ister. Yoksa URL butonu kullan.

## Pazarlama sayılmama (Hizmet şablonu)

Meta metni okuyup kategoriyi Pazarlama'ya çevirebilir. Hizmet olarak kalması için:

- Mesaj **tek ve belli bir işleme** bağlı: "{{1}} siparişin", "{{2}} tarihli randevun", "{{3}} dönemi ödemen".
- **Tek eylem**, o işlemle ilgili ("Siparişi gör", "Cevap ver").
- Şunlar olmasın: indirim, fırsat, kampanya, "hemen", "kaçırma", "yeni", ürün/özellik tanıtımı, birden fazla ürün, genel uygulama daveti.
- Ödeme hatırlatmasında baskı dili yok: tutar, dönem, son gün, "ödemeyi yaptıysan dikkate alma".

## Doğrulama (OTP)

- Gövdeyi Meta üretir ("{{1}} doğrulama kodunuzdur."). Başlık, URL, medya, emoji yok.
- Ayarlanabilen: güvenlik uyarısı, kod geçerlilik süresi (1–90 dk), Kodu Kopyala butonu (zorunlu).
- Kod süresi uygulamadaki süreyle aynı olsun; kısa tut (3–5 dk).
- Meta tarafında "mesaj geçerlilik süresi" ayrı bir ayardır, kod süresinden uzun olmasın.

## Kısa yazım kuralları (turkish-humanizer yoksa)

- "-mektedir/-maktadır" yerine "-iyor" ya da geniş zaman.
- "tarafınıza", "ilgili", "söz konusu", "bu bağlamda" gibi bürokratik kalıpları at.
- Şart ekinden (-sa, -se) sonra virgül koyma.
- Cümle içinde uzun çizgi (—) kullanma.
- Bağlaç "de/da" ayrı, bulunma eki bitişik yazılır.

## Kontrol listesi (her şablon)

- [ ] Kategori doğru; pazarlama ölçütlerinden hiçbiri yok
- [ ] Ad kurallı
- [ ] Gövde değişkenle başlamıyor/bitmiyor; değişkenler sıralı, yan yana değil
- [ ] Her değişkenin örnek değeri var; örneklerde gerçek kişisel veri yok
- [ ] Başlık/alt bilgi ≤ 60, gövde ≤ 1024, buton metni ≤ 25 karakter
- [ ] URL değişkeni sonda, örnek tam adres var
- [ ] Hitap tüm şablonlarda aynı
- [ ] Çocuk adı "Ad S."; hassas veri yok
- [ ] Gönderim eşlemesi (değişken ← kod alanı) yazıldı
- [ ] Kullanıcı metni onayladı
