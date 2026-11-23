# Meta şablon kuralları ve kontrol listesi

## Metin

- **Şablon adı:** küçük harf, rakam, alt çizgi. Türkçe karakter ve boşluk yok.
- **Gövde:** en fazla 1024 karakter.
- **Gövde değişkenle başlayamaz ve bitemez.** Başa sabit bir giriş ("Merhaba,"), sona sabit bir cümle koy.
- **Değişkenler** `{{1}}`, `{{2}}`... sırayla, atlamadan. İki değişken yan yana gelmesin.
- Değişken sayısı metne oranla az olsun; neredeyse tamamı değişken olan gövde reddedilir.
- **Başlık** (isteğe bağlı) ve **alt bilgi** (isteğe bağlı): en fazla 60 karakter.
- **Alt bilgiye değişken girmez.** Metin başlığında en fazla bir değişken olur; emoji, satır sonu ve biçimlendirme olmaz.
- **Aynı içerik reddedilir:** aynı dilde, gövdesi ve alt bilgisi mevcut bir şablonla aynı olan şablon reddedilir. Bir olayın hem SMS hem e-posta sürümünü çevirirken sık olur; birini seç ya da metni ayır.
- Gövdede arka arkaya ikiden fazla satır sonu, sekme ya da 4 ve daha fazla ardışık boşluk olmaz.
- **Her değişkene örnek değer** zorunlu.
- Emoji, ünlem yığını, büyük harfle bağırma yok.

## Butonlar

- En fazla 10 buton; en fazla 2 URL, 1 telefon, 1 Kodu Kopyala.
- Buton metni en fazla 25 karakter.
- URL butonunda değişken yalnız sonda olabilir: `https://alanadi.com/yol/{{1}}`. Ayrıca örnek tam adres istenir.
- Şablon API ile gönderilecekse, buton değişkenini API'nin doldurup dolduramadığını Verimor dokümanından kontrol et (SKILL.md adım 9). Dolduramıyorsa sabit URL kullan.
- Hızlı yanıt butonları gelen cevabı işleyecek bir webhook ister. Yoksa URL butonu kullan.
- URL butonunda link kısaltıcı ve wa.me bağlantısı olmaz; işletmenin kendi alan adını kullan.
- Hızlı yanıt ve eylem (URL, telefon) butonları gruplu durur, iç içe karışmaz.

## İçerik politikası

- Şablonda kart numarası, banka hesap numarası ya da T.C. kimlik no istenmez.
- Tehditkâr tahsilat dili reddedilir.
- Kumar, alkol, tütün, uyuşturucu, silah, yetişkin içeriği, bazı sağlık ve kripto sektörleri reddedilebilir ya da hesabın kısıtlanmasına yol açabilir.

## Pazarlama sayılmama (Hizmet şablonu)

Meta metni okuyup kategoriyi Pazarlama'ya çevirebilir. Hizmet olarak kalması için:

- Mesaj **tek ve belli bir işleme** bağlı: "{{1}} siparişin", "{{2}} tarihli randevun", "{{3}} dönemi ödemen".
- **Tek eylem**, o işlemle ilgili ("Siparişi gör", "Cevap ver").
- Şunlar olmasın: indirim, fırsat, kampanya, "hemen", "kaçırma", "yeni", ürün/özellik tanıtımı, birden fazla ürün, genel uygulama daveti.
- Ödeme hatırlatmasında baskı dili yok: tutar, dönem, son gün, "ödemeyi yaptıysan dikkate alma".
- **Meta'nın Pazarlama'ya çektiği gerçek örnekler** (Hizmet olarak gönderildi, kategori değişti):
  - "Yeni duyuru: {{1}} üyelerine bir duyuru yayımladı." Tek bir işleme bağlı değil, herkese giden genel duyuru.
  - "Yeni sezon: {{1}}, {{2}} sezonunda devam edip etmeyeceğinizi soruyor." Mevcut bir işlemin bildirimi değil, kişiyi tutmaya yönelik soru.
  Bu tür mesajları baştan Pazarlama say ya da belli bir işleme bağla ("{{1}} tarihli kayıt yenileme başvurun alındı").

## Buton ve metin uyumu

- Butonsuz şablonda "aşağıdaki bağlantıdan", "butona dokun" deme. Metin yolu kendisi söylesin ("MaçBul'dan yanıtlayabilirsiniz") ya da URL butonu ekle.
- Gövde bir eylem istiyorsa (cevap ver, onayla) o eylemin yolu ya buton ya da metinde açıkça yazılı olsun.

## Pazarlama

- Alıcının ticari ileti izni olmalı: Türkiye'de ticari ileti için genellikle İYS kaydı gerekir (kendi durumunuzu hukuk danışmanınıza doğrulatın), ayrıca WhatsApp opt-in.
- Meta kişi başına pazarlama sıklığını sınırlar; bazı mesajlar sessizce teslim edilmeyebilir.
- Çıkış yolu olsun: "DUR yaz" metni ya da "Abonelikten çık" hızlı yanıt butonu.
- Başlıkta görsel/video kullanılabilir.
- Tarih ve koşul net olsun; abartı, baskı, uydurma indirim yok.
- Çocuğa yönelik pazarlama yok; çocuk adı girmez.

## Doğrulama (OTP)

- **Ön koşul: Meta işletme doğrulaması.** Doğrulanmamış hesapta Doğrulama şablonu oluşmaz (Verimor'da `META_019`, Meta'da "şablon oluşturma iznine sahip değil"). Hizmet şablonları bundan etkilenmez.
- **Kodu Hizmet şablonuna koyma.** Meta kod içeren Hizmet şablonunu anında reddeder ve ad kilitlenir (silinse bile aynı dilde 30 gün kullanılamaz). İşletme doğrulanana kadar bekle.
- Gövdeyi Meta üretir ("{{1}} doğrulama kodunuzdur."). Başlık, URL, medya, emoji yok.
- Kod parametresi en fazla 15 karakter; içinde URL ve emoji olmaz.
- Ayarlanabilen: güvenlik uyarısı, kod geçerlilik süresi (1–90 dk), Kodu Kopyala butonu (zorunlu).
- Kod süresi uygulamadaki süreyle aynı olsun; kısa tut (3–5 dk).
- Meta tarafında "mesaj geçerlilik süresi" ayrı bir ayardır, kod süresinden uzun olmasın.

## Kısa yazım kuralları (turkish-humanizer yoksa)

- "-mektedir/-maktadır" yerine "-iyor" ya da geniş zaman.
- "tarafınıza", "ilgili", "söz konusu", "bu bağlamda" gibi bürokratik kalıpları at.
- Şart ekinden (-sa, -se) sonra virgül koyma.
- Cümle içinde uzun çizgi (—) kullanma.
- Bağlaç "de/da" ayrı, bulunma eki bitişik yazılır.

## Opt-in (her kategori)

WhatsApp Business politikası işletmenin başlattığı her mesaj için opt-in ister, yalnız pazarlama için değil. SMS için toplanan numara WhatsApp opt-in'i sayılmaz. Alıcıyı SMS'ten WhatsApp'a taşımak yeni bir işleme kanalıdır; aydınlatma metni bunu kapsamalı (hukuki tavsiye değildir). İşletme doğrulaması olmayan hesap 24 saatte yaklaşık 250 farklı alıcıyla sohbet başlatabilir.

## Kontrol listesi (her şablon)

- [ ] Alıcının bu numarada WhatsApp mesajı almayı kabul ettiği ve kaydın nerede tutulduğu belli (her kategori)
- [ ] Dil metinle uyuşuyor; aynı ad farklı dilde ayrı çeviridir
- [ ] Aynı dilde, gövdesi ve alt bilgisi aynı olan başka şablon yok
- [ ] Alt bilgide değişken yok; metin başlığında en fazla bir değişken, emoji ve biçim yok
- [ ] Gövdede ikiden fazla art arda satır sonu, sekme ya da 4+ boşluk yok
- [ ] URL butonu kısaltıcı ya da wa.me değil, kendi alan adı; hızlı yanıt ve eylem butonları gruplu
- [ ] Kart, hesap ya da T.C. kimlik no istenmiyor; tehditkâr tahsilat dili ve kısıtlı sektör içeriği yok
- [ ] OTP ise kod parametresi ≤ 15 karakter, URL ve emoji yok
- [ ] Kategori doğru: Hizmet ise pazarlama ölçütlerinden hiçbiri yok, genel duyuru ya da tutma sorusu değil; Pazarlama ise izin durumu ve çıkış yolu var
- [ ] Doğrulama şablonuysa işletme doğrulaması tamam; Hizmet şablonunda kod yok
- [ ] Ad kurallı ve çakışmıyor (şablon varken ad kilitli, silinse bile 30 gün aynı dilde kullanılamaz)
- [ ] Butonsuz şablonda "aşağıdaki bağlantı/buton" geçmiyor
- [ ] Gövde değişkenle başlamıyor/bitmiyor; değişkenler sıralı, yan yana değil
- [ ] Her değişkenin örnek değeri var; örneklerde gerçek kişisel veri yok
- [ ] Başlık/alt bilgi ≤ 60, gövde ≤ 1024, buton metni ≤ 25 karakter
- [ ] URL değişkeni sonda, örnek tam adres var
- [ ] Hitap tüm şablonlarda aynı
- [ ] Hassas veri yok; çocuk adı geçiyorsa kısaltılmış (öneri: "Ad S.")
- [ ] Gönderim eşlemesi (değişken ← kod alanı) yazıldı
- [ ] Kullanıcı bu şablonu göndermeyi açıkça onayladı (SKILL.md adım 7)
