#include <M5Stack.h>
#include "utility/MPU9250.h"
#include <SPI.h>
#include <SD.h>
String dataLog[6][10];
unsigned long previousMillis = 0;
unsigned long Time = 0;
int runState = 0;
int saveState = 0;
int ImuAX,ImuAY,ImuAZ,ImuGX,ImuGY,ImuGZ;
MPU9250 IMU;
unsigned long count = 0;
File myFile;

void setup() {
  Serial.begin(115200);
  M5.begin();
  Wire.begin();
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(GREEN , BLACK);
  M5.Lcd.setTextSize(2);
  IMU.initMPU9250();
  IMU.calibrateMPU9250(IMU.gyroBias, IMU.accelBias);
  Serial.print("Initializing SD card...");

  if (!SD.begin(4)) {
    Serial.println("initialization failed!");
    while (1);
  }
  Serial.println("initialization done.");

}

void loop() {
  unsigned long currentMillis = millis();
  M5.update();
  count++;
  if (IMU.readByte(MPU9250_ADDRESS, INT_STATUS) & 0x01) {
    IMU.readAccelData(IMU.accelCount);
    IMU.getAres();

    IMU.ax = (float)IMU.accelCount[0] * IMU.aRes; // - accelBias[0];
    IMU.ay = (float)IMU.accelCount[1] * IMU.aRes; // - accelBias[1];
    IMU.az = (float)IMU.accelCount[2] * IMU.aRes; // - accelBias[2];

    IMU.readGyroData(IMU.gyroCount);  // Read the x/y/z adc values
    IMU.getGres();

    IMU.gx = (float)IMU.gyroCount[0] * IMU.gRes;
    IMU.gy = (float)IMU.gyroCount[1] * IMU.gRes;
    IMU.gz = (float)IMU.gyroCount[2] * IMU.gRes;

    IMU.readMagData(IMU.magCount);  // Read the x/y/z adc values
    IMU.getMres();

    IMU.mx = (float)IMU.magCount[0] * IMU.mRes * IMU.magCalibration[0] -
             IMU.magbias[0];
    IMU.my = (float)IMU.magCount[1] * IMU.mRes * IMU.magCalibration[1] -
             IMU.magbias[1];
    IMU.mz = (float)IMU.magCount[2] * IMU.mRes * IMU.magCalibration[2] -
             IMU.magbias[2];


    if (count % 10) {
      int x = 64 + 10;
      int y = 128 + 20;
      int z = 192 + 30;
      ImuAX = (float)(1000 * IMU.ax);
      ImuAY = (float)(1000 * IMU.ay);
      ImuAZ = (float)(1000 * IMU.az);
      ImuGX = (float)(IMU.gx);
      ImuGY = (float)(IMU.gy);
      ImuGZ = (float)(IMU.gz);

      M5.Lcd.fillScreen(BLACK);
      M5.Lcd.setTextColor(GREEN , BLACK);
      M5.Lcd.setTextSize(2);
      M5.Lcd.setCursor(5, 0); M5.Lcd.print("ACCELEROMETER AND GYRO");
      M5.Lcd.setCursor(0, 32); M5.Lcd.print("x");
      M5.Lcd.setCursor(x, 32); M5.Lcd.print("y");
      M5.Lcd.setCursor(y, 32); M5.Lcd.print("z");

      M5.Lcd.setTextColor(YELLOW , BLACK);
      M5.Lcd.setCursor(0, 48 * 2); M5.Lcd.print(ImuAX);
      M5.Lcd.setCursor(x, 48 * 2); M5.Lcd.print(ImuAY);
      M5.Lcd.setCursor(y, 48 * 2); M5.Lcd.print(ImuAZ);
      M5.Lcd.setCursor(z, 48 * 2); M5.Lcd.print("mg");

      M5.Lcd.setCursor(0, 64 * 2); M5.Lcd.print(ImuGX);
      M5.Lcd.setCursor(x, 64 * 2); M5.Lcd.print(ImuGY);
      M5.Lcd.setCursor(y, 64 * 2); M5.Lcd.print(ImuGZ);
      M5.Lcd.setCursor(z, 64 * 2); M5.Lcd.print("deg/s");
    }
  }

  if (M5.BtnA.wasReleased() && runState == 0) {
    runState = 1;
    previousMillis = currentMillis;
    Time = currentMillis;
  }
  if (runState == 1) {
    M5.Lcd.setTextColor(WHITE , BLACK);
    M5.Lcd.setCursor(20, 220);
    M5.Lcd.print(Time);
    if ((currentMillis - previousMillis) >= 10000 && (currentMillis - previousMillis) <= 10000 + 1000) {
      dataLog[0][0] = ImuAX;
      dataLog[1][0] = ImuAY;
      dataLog[2][0] = ImuAZ;
      dataLog[3][0] = ImuGX;
      dataLog[4][0] = ImuGY;
      dataLog[5][0] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 15000 && (currentMillis - previousMillis) <= 15000 + 1000) {
      dataLog[0][1] = ImuAX;
      dataLog[1][1] = ImuAY;
      dataLog[2][1] = ImuAZ;
      dataLog[3][1] = ImuGX;
      dataLog[4][1] = ImuGY;
      dataLog[5][1] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 20000 && (currentMillis - previousMillis) <= 20000 + 1000) {
      dataLog[0][2] = ImuAX;
      dataLog[1][2] = ImuAY;
      dataLog[2][2] = ImuAZ;
      dataLog[3][2] = ImuGX;
      dataLog[4][2] = ImuGY;
      dataLog[5][2] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 25000 && (currentMillis - previousMillis) <= 25000 + 1000) {
      dataLog[0][3] = ImuAX;
      dataLog[1][3] = ImuAY;
      dataLog[2][3] = ImuAZ;
      dataLog[3][3] = ImuGX;
      dataLog[4][3] = ImuGY;
      dataLog[5][3] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 30000 && (currentMillis - previousMillis) <= 30000 + 1000) {
      dataLog[0][4] = ImuAX;
      dataLog[1][4] = ImuAY;
      dataLog[2][4] = ImuAZ;
      dataLog[3][4] = ImuGX;
      dataLog[4][4] = ImuGY;
      dataLog[5][4] = ImuGZ;   
    }else if((currentMillis - previousMillis) >= 35000 && (currentMillis - previousMillis) <= 35000 + 1000) {
      dataLog[0][5] = ImuAX;
      dataLog[1][5] = ImuAY;
      dataLog[2][5] = ImuAZ;
      dataLog[3][5] = ImuGX;
      dataLog[4][5] = ImuGY;
      dataLog[5][5] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 40000 && (currentMillis - previousMillis) <= 40000 + 1000) {
      dataLog[0][6] = ImuAX;
      dataLog[1][6] = ImuAY;
      dataLog[2][6] = ImuAZ;
      dataLog[3][6] = ImuGX;
      dataLog[4][6] = ImuGY;
      dataLog[5][6] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 45000 && (currentMillis - previousMillis) <= 45000 + 1000) {
      dataLog[0][7] = ImuAX;
      dataLog[1][7] = ImuAY;
      dataLog[2][7] = ImuAZ;
      dataLog[3][7] = ImuGX;
      dataLog[4][7] = ImuGY;
      dataLog[5][7] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 50000 && (currentMillis - previousMillis) <= 50000 + 1000) {
      dataLog[0][8] = ImuAX;
      dataLog[1][8] = ImuAY;
      dataLog[2][8] = ImuAZ;
      dataLog[3][8] = ImuGX;
      dataLog[4][8] = ImuGY;
      dataLog[5][8] = ImuGZ;
    }else if((currentMillis - previousMillis) >= 55000 && (currentMillis - previousMillis) <= 55000 + 1000) {
      dataLog[0][9] = ImuAX;
      dataLog[1][9] = ImuAY;
      dataLog[2][9] = ImuAZ;
      dataLog[3][9] = ImuGX;
      dataLog[4][9] = ImuGY;
      dataLog[5][9] = ImuGZ;
      runState = 2;
    }
