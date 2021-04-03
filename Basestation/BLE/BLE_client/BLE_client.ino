#define M5STACK_MPU9250
#include "BLEDevice.h"
#include "BLEScan.h"
#include <M5Stack.h>
#include <base64.h>

String deviceID = "001";

static BLEUUID serviceUUID("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
static BLEUUID charUUID("beb5483e-36e1-4688-b7f5-ea07361b26a8");

static boolean doConnect = false;
static boolean connected = false;
static boolean doScan = false;
static BLERemoteCharacteristic *pRemoteCharacteristic;
static BLEAdvertisedDevice *myDevice;
static BLEClient *pClient;

static void notifyCallback(BLERemoteCharacteristic *pBLERemoteCharacteristic,
                           

                           uint8_t *pData, size_t length, bool isNotify) {
  Serial.print("Notify callback for characteristic ");
  Serial.print(pBLERemoteCharacteristic->getUUID().toString().c_str());
  Serial.print(" of data length ");
  Serial.println(length);
  Serial.print("data: ");
  Serial.println((char *)pData);
}

class MyClientCallback : public BLEClientCallbacks {
  void onConnect(BLEClient *pclient) {
    M5.Lcd.fillScreen(GREEN);
    M5.Lcd.setTextColor(WHITE);
    M5.Lcd.setTextSize(2);
    M5.Lcd.setCursor(0, 160);
    M5.Lcd.printf("  Connect BLE !");
    connected = true;
  }

  void onDisconnect(BLEClient *pclient) {
    M5.Lcd.fillScreen(RED);
    M5.Lcd.setTextColor(WHITE);
    M5.Lcd.setTextSize(2);
    M5.Lcd.setCursor(0, 160);
    M5.Lcd.printf("  Disconnect BLE !");
    Serial.println("onDisconnect");
    connected = false;
  }
};

class MyAdvertisedDeviceCallbacks : public BLEAdvertisedDeviceCallbacks {

  void onResult(BLEAdvertisedDevice advertisedDevice) {

    Serial.print("BLE Advertised Device found: ");
    Serial.print(advertisedDevice.toString().c_str());
    Serial.println(advertisedDevice.getRSSI());
    if (advertisedDevice.haveServiceUUID() &&
        advertisedDevice.isAdvertisingService(serviceUUID)) {
      BLEDevice::getScan()->stop();
      myDevice = new BLEAdvertisedDevice(advertisedDevice);
      doConnect = true;
      doScan = true;
    }
  }
};

unsigned long previousMillis = 0;
unsigned long previousMillis_sendData = 0;
unsigned long previousMillis_readData = 0;

float accX = 0.0F;
float accY = 0.0F;
float accZ = 0.0F;
float temp = 0.0F;

float defaultMinX = -4;
float defaultMaxX = 2;

float liftMinY = -4;
float liftMaxY = 4;
float accXvalue, accYvalue, accZvalue;
String carStatusText = "Default";
int carStatusCode = 1;
int sendStatus = 0;
int oldCarStatusCode = 1;
String dataSend = "";
            

String encoded = "";
double mapf(double val, double in_min, double in_max, double out_min,

            double out_max) {
  return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void setup() {
  M5.begin();
  M5.Power.begin();
  M5.IMU.Init();

  Serial.println("Initialization done.");

 
  }

  BLEDevice::init("");
  BLEScan *pBLEScan = BLEDevice::getScan();
  pBLEScan->setAdvertisedDeviceCallbacks(new MyAdvertisedDeviceCallbacks());
  pBLEScan->setInterval(1349);
  pBLEScan->setWindow(449);
  pBLEScan->setActiveScan(true);
  
}

void loop() {
  unsigned long currentMillis = millis();
  if (doConnect == true) {
    if (connectToServer()) {
      Serial.println("We are now connected to the BLE Server.");
    } else {
      Serial.println("We have failed to connect to the server; there is nothin "
                     "more we will do.");
    }
    doConnect = false;
  }

  if (connected) {
    M5.update();
    if ((currentMillis - previousMillis_readData) >= 1000) {
    M5.IMU.getAccelData(&accX, &accY, &accZ);
    M5.IMU.getTempData(&temp);
    
    accXvalue = mapf(accX, -1, 1, -10, 10);
    accYvalue = mapf(accY, -1, 1, -10, 10);
    accZvalue = mapf(accZ, -1, 1, -10, 10);
    previousMillis_readData = currentMillis;
    }
    if ((accXvalue >= defaultMinX && accXvalue <= defaultMaxX) &&
        (accYvalue >= liftMinY && accYvalue <= liftMaxY)) {
      carStatusText = "Default";
      carStatusCode = 1;
      dataSend = String(deviceID + "11");
    } else if ((accXvalue < defaultMinX || accXvalue > defaultMaxX) &&
               (accYvalue >= liftMinY && accYvalue <= liftMaxY)) {
      carStatusText = "Crashdown";
      carStatusCode = 2;
      dataSend = String(deviceID + "12");
    } else if ((accXvalue >= defaultMinX && accXvalue <= defaultMaxX) &&
               (accYvalue < liftMinY || accYvalue > liftMaxY)) {
      carStatusText = "Lift";
      carStatusCode = 3;
      dataSend = String(deviceID + "13");
    } else if ((accXvalue < defaultMinX || accXvalue > defaultMaxX) &&
               (accYvalue < liftMinY || accYvalue > liftMaxY)) {
      carStatusText = "Lift";
      carStatusCode = 3;
      dataSend = String(deviceID + "13");
    }

    if ((currentMillis - previousMillis) >= 700) {

      previousMillis = currentMillis;
    }
    if ((currentMillis - previousMillis_sendData) >= 500) {

        if(sendStatus == 0){
            pRemoteCharacteristic->writeValue(dataSend.c_str(), dataSend.length());
            Serial.println("Send data : \"" + dataSend+ "\"");
            oldCarStatusCode = carStatusCode;
            sendStatus = 1;
        }
      previousMillis_sendData = currentMillis;
    }

    if(oldCarStatusCode != carStatusCode){
    sendStatus = 0;
  }
  } else if (doScan) {
    BLEDevice::getScan()->start(0);
  }


   
}
