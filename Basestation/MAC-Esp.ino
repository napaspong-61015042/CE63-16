#include <WiFi.h>

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.print("MAC Address is ");
  Serial.println(WiFi.macAddress());
}

void loop() {

}
