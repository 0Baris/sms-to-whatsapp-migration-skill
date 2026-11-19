# verimor-whatsapp-sablon

Projeniz için WhatsApp Business şablonları tasarlayan, mevcut SMS ve e-postalarınızı taşıyan ya da WhatsApp'a özgü yeni senaryolar (butonla cevap, belge, sohbet açan bildirim) üreten ve bunları Verimor üzerinden Meta onayına hazırlayan bir [Claude skill'i](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview). Resmî bir Verimor ürünü değildir.

## Ne yapar?

Claude'a "bu projedeki SMS şablonlarımı WhatsApp'a çevirmek istiyorum" ya da "WhatsApp'ı bu projede nasıl kullanabiliriz?" dersiniz. Skill:

1. Projeyi tarayıp SMS, e-posta ve doğrulama kodu mesajlarını, ayrıca onay bekleyen kayıtlar, son tarihler, hatırlatmalar gibi olayları bulur.
   - Taşımada her mesajın WhatsApp'ta nasıl daha iyi olacağını önerir.
   - Yeni senaryo modunda iki yönlü akışlar önerir: "Geliyorum / Gelemiyorum", "Ödedim", belge başlıklı makbuz, sohbet açan bildirim.
2. Her mesajı **Hizmet (utility)**, **Doğrulama (OTP)** ya da **Pazarlama (marketing)** şablonu olarak sınıflandırır.
3. Metni şablona çevirir: ad, gövde, `{{1}}` değişkenleri, örnek değerler, URL butonu; pazarlamada izin ve çıkış yolunu ekler.
4. Metni [turkish-humanizer](https://github.com/DevVettel/turkish-humanizer) ile doğallaştırır.
5. Meta kurallarına göre kontrol eder; işlem mesajlarının pazarlama sayılmamasına dikkat eder.
6. Şablon dosyasını ve **gönderim eşlemesini** (hangi değişken koddaki hangi alandan dolar) projenize yazar.
7. Hazırladığı şablonların tamamını size gösterir ve **onayınızı ister**.
8. Onayladıklarınızı Verimor panelinde oluşturup Meta onayına gönderir.

## Kurulum

Önce turkish-humanizer'ı kurun: https://github.com/DevVettel/turkish-humanizer

### Claude Code

Bu repodaki `verimor-whatsapp-sablon/` klasörünü `~/.claude/skills/` altına kopyalayın:

```bash
git clone https://github.com/0Baris/verimor-whatsapp-sablon.git
cp -r verimor-whatsapp-sablon/verimor-whatsapp-sablon ~/.claude/skills/
```

### Claude (claude.ai, masaüstü, mobil)

[`dist/verimor-whatsapp-sablon.zip`](dist/verimor-whatsapp-sablon.zip) dosyasını indirin (açmayın), **Ayarlar → Yetenekler → Skills → Skill yükle** ile yükleyin.

## Kullanım

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

- Pazarlama şablonlarını hazırlar, ama göndermek için alıcıların ticari ileti izni (İYS, WhatsApp opt-in) sizin sisteminizde olmalı.
- Gönderim kodunu yazmaz; eşleme tablosunu verir.
- Panelde oluşturma için tarayıcı aracı ve Verimor'da bağlı bir WhatsApp Business hesabı gerekir.
- Şablonu Meta'ya göndermeden önce her zaman onayınızı ister.

## Lisans

MIT
