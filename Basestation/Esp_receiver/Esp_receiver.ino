#include <esp_now.h>
#include <WiFi.h>

void onReceiveData(const uint8_t *mac, const uint8_t *Indata, int len) {

  Serial.print("Received from MAC: ");

  for (int i = 0; i < 6; i++) {

    Serial.printf("%02X", mac[i]);
    if (i < 5)Serial.print(":");
  }

  Serial.println();
  String dataIn;
  for (int i = 0; i < len; i++) {
    dataIn += (char)Indata[i];
  }
  Serial.print("Datain: ");
  Serial.println(dataIn);

}

void setup() {
  Serial.begin(115200);

  WiFi.mode(WIFI_STA);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  esp_now_register_recv_cb(onReceiveData);
}

void loop() {}
