#include <esp_now.h>
#include <WiFi.h>

uint8_t broadcastAddress[] = {0x24, 0x0A, 0xC4, 0xAA, 0xE0, 0xD4};
//uint8_t broadcastAddress[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};

/********************************************************************************/
String macAddressId; 
void setup() {

  Serial.begin(115200);

  WiFi.mode(WIFI_STA);

  Serial.println();
  Serial.println(WiFi.macAddress());
  macAddressId = WiFi.macAddress();
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // register peer
  esp_now_peer_info_t peerInfo;

  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Failed to add peer");
    return;
  }

}

void loop() {
  // send data
  int x = 20;
  String dataSend = "["+macAddressId + ",macCar,0]";

  esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *)dataSend.c_str(), dataSend.length() );

  if (result == ESP_OK) {
    Serial.println("Sent with success");
  }
  else {
    Serial.println("Error sending the data");
  }
  delay(1000);


}
