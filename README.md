# verimor-whatsapp-sablon

Projenizdeki SMS ve e-posta mesajlarını WhatsApp Business şablonlarına çeviren, Verimor üzerinden Meta onayına hazırlayan bir [Claude skill'i](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview). Resmî bir Verimor ürünü değildir.

## Ne yapar?

Claude'a "bu projedeki SMS şablonlarımı WhatsApp'a çevirmek istiyorum" dersiniz. Skill:

1. Projeyi tarayıp SMS, e-posta ve doğrulama kodu mesajlarını bulur, bir envanter çıkarır.
2. Her mesajı **Hizmet (utility)** ya da **Doğrulama (OTP)** şablonu olarak sınıflandırır; kampanya ve bültenleri ayırır.
3. Metni şablona çevirir: ad, gövde, `{{1}}` değişkenleri, örnek değerler, URL butonu.
4. Metni [turkish-humanizer](https://github.com/DevVettel/turkish-humanizer) ile doğallaştırır.
5. Meta kurallarına ve "pazarlama sayılmama" ölçütlerine göre kontrol eder.
6. Şablon dosyasını ve **gönderim eşlemesini** (hangi değişken koddaki hangi alandan dolar) projenize yazar.
7. İsterseniz şablonları Verimor panelinde oluşturur; Meta onayına gönderir.

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
Şifre sıfırlama kodu için Verimor'da OTP şablonu hazırla, kod 3 dakika geçerli.
```

## Sınırlar

- Pazarlama şablonları kapsam dışı (İYS izni ve ayrı onay gerekir).
- Gönderim kodunu yazmaz; eşleme tablosunu verir.
- Panelde oluşturma için tarayıcı aracı ve Verimor'da bağlı bir WhatsApp Business hesabı gerekir.
- Şablonu Meta'ya göndermeden önce her zaman onayınızı ister.

## Lisans

MIT
