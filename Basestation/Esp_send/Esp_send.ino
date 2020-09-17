#include <WiFi.h>
#include <esp_now.h>

void OnDataRecv(const uint8_t * mac, const uint8_t *incomingData, int len) {
  String dataIn;
  for (int i = 0; i < len; i++) {
    dataIn += (char)incomingData[i];
  }

  Serial.print("Data in: ");
  Serial.println(dataIn);
}

void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_STA);

  esp_now_init();
  esp_now_register_recv_cb(OnDataRecv);

  static esp_now_peer_info_t peerInfo;
  memcpy(peerInfo.peer_addr, new uint8_t[6] { 0x24, 0x0A, 0xC4, 0xAA, 0x14, 0x94 }, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;
  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Failed to add peer");
    return;
  }
}

void loop() {
  // put your main code here, to run repeatedly:

}
