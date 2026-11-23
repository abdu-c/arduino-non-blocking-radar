# Arduino Non-Blocking Ultrasonic Radar

`millis()` tabanlı durum makinesi (state machine) mimarisiyle çalışan, kesintisiz (non-blocking) ultrasonik radar sistemi ve canlı Processing radar görselleştirme arayüzü. Geleneksel `delay()` ve bloke edici `pulseIn()` bekleme sürelerini ortadan kaldırarak aynı anda servo taraması, mesafe ölçümü, I2C LCD ekran güncellemesi ve gerçek zamanlı PC arayüzü veri akışı sağlar.

## Öne Çıkan Özellikler ve Mimari

* **Non-Blocking Servo Tarama (`30 ms`):** `for` döngüleri ve `delay(30)` yerine `millis()` tabanlı adım kontrolü ile 15°–165° aralığında akıcı ve kesintisiz tarama.
* **PulseIn Timeout Koruması (`200 cm`):** Açık alanda yankı dönmediğinde işlemcinin 1 saniye boyunca kilitlenmesini önlemek için `MAX_CM * 59UL` zaman aşımı sınırı.
* **Ayrık I2C LCD Zamanlayıcısı (`120 ms`):** Ekran titremesini (flicker) ve I2C veri yolu gecikmesini önlemek için servo hareketinden bağımsız ekran yenileme döngüsü.
* **Canlı Processing Radar Arayüzü:** `9600 baud` hızında `"Açı,Mesafe."` formatında seri veri okuyarak 200 cm menzil halkaları, hareket izi (motion blur) efekti ve kırmızı hedef işaretlemesiyle gerçek zamanlı görselleştirme.
* **Türkçe Windows Yerel Ayar Uyumluluğu:** Processing'in `int()` fonksiyonunda oluşan `parseİnt` derleme hatasını önlemek için doğrudan Java standart `Integer.valueOf()` dönüşümü ve paket koruma (`try-catch`) mekanizması.

## Proje Yapısı

    arduino-non-blocking-radar/
    ├── radar/
    │   └── radar.ino                  # Arduino millis() tabanlı gömülü sistem yazılımı
    ├── radar_ui/radar_ui/
    │   └── radar_ui.pde               # Processing canlı radar görselleştirme arayüzü
    ├── .gitignore                     # Gereksiz sistem dosyalarını hariç tutma kuralları
    ├── LICENSE                        # MIT Lisansı
    └── README.md                      # Proje dokümantasyonu

## Donanım Bileşenleri ve Pin Bağlantıları

| Bileşen | Pin / Adres | Arduino Bağlantısı | Açıklama |
| :--- | :--- | :--- | :--- |
| **HC-SR04 Trig** | `D9` | Dijital Çıkış | Ultrasonik tetikleme sinyali |
| **HC-SR04 Echo** | `D10` | Dijital Giriş | Yankı süresi ölçümü (`timeout` korumalı) |
| **SG90 Servo Sinyal** | `D11` | PWM Çıkış | 15°–165° tarama kontrolü |
| **Uyarı LED'i** | `D12` | Dijital Çıkış | 220Ω–330Ω direnç üzerinden yakın nesne uyarısı |
| **16x2 I2C LCD** | `0x27` | `SDA -> A4`, `SCL -> A5` | Canlı açı ve mesafe bilgisi ekranı |
| **Harici Güç (Önerilen)** | `5V / GND` | Ortak Şase (`GND`) | Servo VCC harici 5V kaynağa bağlanarak voltaj çökmesi önlenir |

## Kurulum ve Çalıştırma

### 1. Depoyu İndirme (Klonlama)
Projeyi bilgisayarınıza indirmek için terminali açıp aşağıdaki komutları çalıştırın:

    git clone https://github.com/abdu-c/arduino-non-blocking-radar.git
    cd arduino-non-blocking-radar

### 2. Arduino Donanım Yazılımı (`radar.ino`)
1. Arduino IDE ile `radar/radar.ino` dosyasını açın.
2. **Sketch > Include Library > Manage Libraries** menüsünden **LiquidCrystal_I2C** kütüphanesinin yüklü olduğunu doğrulayın.
3. **Tools > Board** kısmından **Arduino Uno** kartını ve bağlı olduğu portu (örn. `COM9`) seçip **Upload** butonuna basın.

### 3. Processing Görselleştirme Arayüzü (`radar_ui.pde`)
1. [Processing IDE](https://processing.org/download) uygulamasını kurun ve `radar_ui/radar_ui/radar_ui.pde` dosyasını açın.
2. `setup()` bloğu içerisindeki seri port satırını kendi bilgisayarınızdaki port numarasıyla güncelleyin:

       myPort = new Serial(this, "COM9", 9600);

3. Seri port çakışmasını önlemek için Arduino IDE'deki **Seri Port Ekranı (Serial Monitor)** penceresini kapatın.
4. Processing IDE sol üst köşesindeki **Run (▶)** butonuna basarak radar ekranını başlatın.

## Seri Haberleşme Protokolü

Arduino ve Processing arasında `9600 baud` hızında aşağıdaki metin tabanlı paket yapısı kullanılır:

    <Açı>,<Mesafe>.
    Örnek: 90,45.

* **`,` (Virgül):** Açı (derece) ve mesafe (cm) değerlerini ayırır.
* **`.` (Nokta):** Paket sonu belirtecidir (`myPort.bufferUntil('.')` ile kesintisiz okuma sağlar).

## Lisans

Bu proje [MIT Lisansı](LICENSE) altında açık kaynak olarak sunulmaktadır.
