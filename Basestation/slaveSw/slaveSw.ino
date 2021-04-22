#include <BLE2902.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <SoftwareSerial.h>
// BLE Configuration
BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
int countConnect = 0;
String data;
int statusGetData = 0;
int readySendStatus = 0;
std::string text;

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


// swSerial Configuration
#define D8 (5)
#define D7 (23)
#define RX (3)
#define TX (1)
#define BAUD_RATE 9600
#undef SWAPSERIAL

#ifndef SWAPSERIAL
auto &usbSerial = Serial;
SoftwareSerial swSerial;
#else
SoftwareSerial usbSerial;
auto &swSerial = Serial;
#endif

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
     text = pCharacteristic->getValue();
  }
};

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    deviceConnected = true;
    countConnect += 1;
    Serial.print("Connected :");
    Serial.println(countConnect);
    BLEDevice::startAdvertising();
  };

  void onDisconnect(BLEServer *pServer) {
    countConnect -= 1;
    Serial.print("Disconnected :");
    Serial.println(countConnect);
    deviceConnected = false;
  }
};

void setup() {
#ifndef SWAPSERIAL
  usbSerial.begin(9600);
  swSerial.begin(BAUD_RATE, SWSERIAL_8N1, D7, D8, false, 95, 11);
#else
  swSerial.begin(9600);
  swSerial.setDebugOutput(false);
  swSerial.swap();
  usbSerial.begin(BAUD_RATE, SWSERIAL_8N1, RX, TX, false, 95);
#endif
  usbSerial.println(PSTR("\nSoftware serial started"));

  // Create the BLE Device
  BLEDevice::init("ESP32");
  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());
  // Create a Callbacks
  pCharacteristic->setCallbacks(new MyCallbacks());
  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to BLE Server");
}

void loop() {
  if (deviceConnected) {
if (text.length() > 0 && readySendStatus == 0) {
        Serial.print("getData : ");
        for (int i = 0; i < text.length(); i++){
            Serial.print(text[i]);
            swSerial.write(text[i]);
        }
        Serial.print(" ---> Send : ");
        Serial.print(text.c_str());
        text = "";
        Serial.print(" ---> Success");
        Serial.println("");
        readySendStatus = 1;
      }
  }
  while(swSerial.available() > 0 && readySendStatus == 1){
      char inChar = swSerial.read();
      if(inChar == '0'){
        readySendStatus = 0;
        Serial.println("Status : Ready Send ------ ");
      }
  }
  if (!deviceConnected && oldDeviceConnected) {
    delay(200); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("Start advertising");
    oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    Serial.println("Start Connect");
    oldDeviceConnected = deviceConnected;
  }
}
