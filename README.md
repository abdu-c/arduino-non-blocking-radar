# Arduino Non-Blocking Ultrasonic Radar

`millis()` tabanlı durum makinesi (state machine) mimarisiyle çalışan, kesintisiz (non-blocking) ultrasonik radar sistemi. Geleneksel `delay()` ve bloke edici `pulseIn()` döngüleri kaldırılarak servo taraması, mesafe ölçümü ve I2C LCD ekran güncellemeleri birbirinden bağımsız zamanlayıcılara ayrılmıştır.

## Mimari İyileştirmeler

* **Non-Blocking Servo Tarama (`30 ms`):** `for` döngüleri ve `delay(30)` yerine `millis()` tabanlı adım kontrolü ile 15°–165° aralığında kesintisiz tarama.
* **PulseIn Timeout Koruması (`200 cm`):** Açık alanda yankı dönmediğinde işlemcinin 1 saniye kilitlenmesini önlemek için `MAX_CM * 59UL` zaman aşımı sınırı.
* **Ayrık I2C LCD Zamanlayıcısı (`120 ms`):** Ekran titremesini (flicker) ve I2C veri yolu gecikmesini önlemek için bağımsız ekran yenileme döngüsü.
* **Processing Uyumlu Seri Çıktı:** `9600 baud` hızında `"Açı,Mesafe."` formatında gerçek zamanlı veri akışı.

## Donanım ve Pin Bağlantıları

| Bileşen | Pin / Adres | Arduino Bağlantısı |
| :--- | :--- | :--- |
| **HC-SR04 Trig** | `D9` | Dijital Çıkış |
| **HC-SR04 Echo** | `D10` | Dijital Giriş |
| **SG90 Servo Sinyal** | `D11` | PWM Çıkış |
| **Uyarı LED'i** | `D12` | 220Ω–330Ω Direnç ile Dijital Çıkış |
| **16x2 I2C LCD** | `0x27` (veya `0x3F`) | `SDA -> A4`, `SCL -> A5`, `VCC -> 5V`, `GND -> GND` |

## Kurulum ve Çalıştırma

1. Depoyu klonlayın:
   ```bash
   git clone [https://github.com/abdu-c/arduino-non-blocking-radar.git](https://github.com/abdu-c/arduino-non-blocking-radar.git)
