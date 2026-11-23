# Arduino Non-Blocking Ultrasonic Radar

`millis()` tabanlı durum makinesi (state machine) mimarisiyle çalışan, kesintisiz (non-blocking) ultrasonik radar sistemi ve canlı Processing radar görselleştirme arayüzü. Geleneksel `delay()` ve bloke edici `pulseIn()` bekleme sürelerini ortadan kaldırarak aynı anda servo taraması, mesafe ölçümü, I2C LCD ekran güncellemesi ve gerçek zamanlı PC arayüzü veri akışı sağlar.

## Öne Çıkan Özellikler ve Mimari

* **Non-Blocking Servo Tarama (`30 ms`):** `for` döngüleri ve `delay(30)` yerine `millis()` tabanlı adım kontrolü ile 15°–165° aralığında akıcı ve kesintisiz tarama.
* **PulseIn Timeout Koruması (`200 cm`):** Açık alanda yankı dönmediğinde işlemcinin 1 saniye boyunca kilitlenmesini önlemek için `MAX_CM * 59UL` zaman aşımı sınırı.
* **Ayrık I2C LCD Zamanlayıcısı (`120 ms`):** Ekran titremesini (flicker) ve I2C veri yolu gecikmesini önlemek için servo hareketinden bağımsız ekran yenileme döngüsü.
* **Canlı Processing Radar Arayüzü:** `9600 baud` hızında `"Açı,Mesafe."` formatında seri veri okuyarak 200 cm menzil halkaları, hareket izi (motion blur) efekti ve kırmızı hedef işaretlemesiyle gerçek zamanlı görselleştirme.
* **Türkçe Windows Yerel Ayar Uyumluluğu:** Processing'in `int()` fonksiyonunda oluşan `parseİnt` derleme hatasını önlemek için doğrudan Java standart `Integer.valueOf()` dönüşümü ve paket koruma (`try-catch`) mekanizması.

## Proje Yapısı

```text
arduino-non-blocking-radar/
├── radar/
│   └── radar.ino                  # Arduino millis() tabanlı gömülü sistem yazılımı
├── radar_ui/radar_ui/
│   └── radar_ui.pde               # Processing canlı radar görselleştirme arayüzü
├── .gitignore                     # Gereksiz sistem dosyalarını hariç tutma kuralları
├── LICENSE                        # MIT Lisansı
└── README.md                      # Proje dokümantasyonu
