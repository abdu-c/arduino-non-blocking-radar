# Arduino Non-Blocking Ultrasonic Radar

`millis()` tabanlı durum makinesi (state machine) mimarisiyle çalışan, kesintisiz (non-blocking) ultrasonik radar sistemi.

## Pin Bağlantıları
* **HC-SR04:** Trig -> `D9`, Echo -> `D10`
* **SG90 Servo:** Sinyal -> `D11`
* **Uyarı LED'i:** `D12` (220Ω-330Ω direnç ile)
* **16x2 I2C LCD (`0x27`):** `SDA -> A4`, `SCL -> A5`
