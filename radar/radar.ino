#include <Servo.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// I2C LCD Tanımlaması (0x27 veya 0x3F)
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Pin Tanımlamaları
const int trigPin = 9;
const int echoPin = 10;
const int servoPin = 11;
const int ledPin = 12;

const int MAX_CM = 200;                                // kullanmak istediğin maksimum menzil
const unsigned long ECHO_TIMEOUT_US = MAX_CM * 59UL;   // gidiş-dönüş ~58.2 µs/cm + küçük pay
const unsigned long SERVO_MS = 30;                     // servonun yerleşme süresi (eski delay(30))
const unsigned long LCD_MS = 120;                      // LCD yenileme aralığı

Servo radarServo;
int aci = 15;
int adim = 2;      // +2 ileri, -2 geri
int mesafe = 0;    // 0 = menzil dışı / yankı yok
unsigned long tServo = 0;
unsigned long tLcd = 0;

// Mesafe Ölçüm Fonksiyonu (timeout dolarsa pulseIn 0 döner)
int mesafeOlc() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  return pulseIn(echoPin, HIGH, ECHO_TIMEOUT_US) * 0.034 / 2;
}

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(ledPin, OUTPUT);

  // Seri Haberleşme (Processing için standart 9600 baud)
  Serial.begin(9600);

  // LCD Başlatma
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("RADAR SISTEMI");
  lcd.setCursor(0, 1);
  lcd.print("BASLATILIYOR...");

  radarServo.attach(servoPin);
  radarServo.write(aci);
  delay(1000);
  lcd.clear();
}

void loop() {
  unsigned long now = millis();

  // Servo adımı: önceki yazımdan beri 30 ms geçtiyse ölç, gönder, bir sonraki açıya geç
  if (now - tServo >= SERVO_MS) {
    tServo = now;
    mesafe = mesafeOlc();

    // Processing için özel veri formatı: "Açı,Mesafe."
    Serial.print(aci);
    Serial.print(",");
    Serial.print(mesafe);
    Serial.print(".");

    // Engel 20 cm altındaysa LED yak
    digitalWrite(ledPin, mesafe > 0 && mesafe < 20);

    aci += adim;
    if (aci > 165 || aci < 15) {   // uçta yön değiştir, uç açıyı tekrar ölçme
      adim = -adim;
      aci += 2 * adim;
    }
    radarServo.write(aci);
  }

  // LCD ayrı zamanlayıcıda: servo adımını her seferinde I2C yazımıyla geciktirmez
  if (now - tLcd >= LCD_MS) {
    tLcd = now;
    lcd.setCursor(0, 0);
    lcd.print("Aci: ");
    lcd.print(aci);
    lcd.print(" deg   ");
    lcd.setCursor(0, 1);
    lcd.print("Mesafe: ");
    lcd.print(mesafe);
    lcd.print(" cm  ");
  }
}
