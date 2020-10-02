#include <M5Stack.h>
#include "utility/MPU9250.h"

MPU9250 IMU;
unsigned long count = 0;

void setup() {

  M5.begin();
  Wire.begin();
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextColor(GREEN , BLACK);
  M5.Lcd.setTextSize(2);
  IMU.initMPU9250();
  IMU.calibrateMPU9250(IMU.gyroBias, IMU.accelBias);
}

void loop() {
  M5.update();

  count++;

  // If intPin goes high, all data registers have new data
  // On interrupt, check if data ready interrupt
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

      M5.Lcd.fillScreen(BLACK);
      M5.Lcd.setTextColor(GREEN , BLACK);
      M5.Lcd.setTextSize(2);
      M5.Lcd.setCursor(5, 0); M5.Lcd.print("ACCELEROMETER AND GYRO");
      M5.Lcd.setCursor(0, 32); M5.Lcd.print("x");
      M5.Lcd.setCursor(x, 32); M5.Lcd.print("y");
      M5.Lcd.setCursor(y, 32); M5.Lcd.print("z");

      M5.Lcd.setTextColor(YELLOW , BLACK);
      M5.Lcd.setCursor(0, 48 * 2); M5.Lcd.print((int)(1000 * IMU.ax));
      M5.Lcd.setCursor(x, 48 * 2); M5.Lcd.print((int)(1000 * IMU.ay));
      M5.Lcd.setCursor(y, 48 * 2); M5.Lcd.print((int)(1000 * IMU.az));
      M5.Lcd.setCursor(z, 48 * 2); M5.Lcd.print("mg");

      M5.Lcd.setCursor(0, 64 * 2); M5.Lcd.print((int)(IMU.gx));
      M5.Lcd.setCursor(x, 64 * 2); M5.Lcd.print((int)(IMU.gy));
      M5.Lcd.setCursor(y, 64 * 2); M5.Lcd.print((int)(IMU.gz));
      M5.Lcd.setCursor(z, 64 * 2); M5.Lcd.print("deg/s");

    }
    delay (500);
  }

}