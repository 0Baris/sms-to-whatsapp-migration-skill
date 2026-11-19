# Verimor WhatsApp şablon skill'i

Verimor Online İşlem Merkezi (OİM) üzerinden WhatsApp Business mesaj şablonu oluşturan Claude skill'i (resmî değildir).

- **Hizmet (utility)** ve **Doğrulama (OTP)** şablonları; pazarlama kapsam dışı.
- Metni [turkish-humanizer](https://github.com/0Baris/turkish-humanizer) ile doğallaştırır.
- Meta kurallarını (değişken, örnek değer, buton, karakter sınırı) ve "pazarlama sayılmama" ölçütlerini kontrol eder.
- Paneldeki adımları ve sık hataları (APPLICATION_004, META_019, BSP izin hatası) anlatır.

## Kurulum (Claude Code)

```
/plugin marketplace add 0Baris/turkish-humanizer
/plugin install turkish-humanizer@turkish-humanizer
/plugin marketplace add 0Baris/verimor-whatsapp-sablon
/plugin install verimor-whatsapp-sablon@verimor-whatsapp-sablon
```

Sonra: "Verimor'da veli daveti için WhatsApp şablonu oluştur".

## Lisans

MIT
