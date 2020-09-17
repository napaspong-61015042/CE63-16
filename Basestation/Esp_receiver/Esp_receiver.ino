#include <WiFi.h>
#include <esp_now.h>

void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  if (status == ESP_NOW_SEND_SUCCESS) {
    Serial.println("OK");
  } else {
    Serial.println("Fail");
  }
}

void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_STA);

  esp_now_init();
  esp_now_register_send_cb(OnDataSent);

  static esp_now_peer_info_t peerInfo;
  memcpy(peerInfo.peer_addr, new uint8_t[6] { 0x24, 0x0A, 0xC4, 0xAA, 0x10, 0xD4 }, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;
  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Failed to add peer");
  }
}

void loop() {
  String data = "Hello";
  Serial.print("Sending... ");
  esp_err_t result = esp_now_send(new uint8_t[6] { 0x24, 0x0A, 0xC4, 0xAA, 0x10, 0xD4 }, (uint8_t*)data.c_str(), data.length());
  if (result != ESP_OK) {
    Serial.println("Send error");
  }
  delay(1000);
}
