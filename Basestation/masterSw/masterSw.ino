#include <SoftwareSerial.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "OHMS"
#define WIFI_PASSWORD "Ohm12515"
//#define WIFI_SSID "'Dome"
//#define WIFI_PASSWORD "dome2541"

/* 2. Define the Firebase project host name and API Key */
#define FIREBASE_HOST "trackingandalarmsystem-ea828.firebaseio.com"
#define API_KEY "AIzaSyDJZANS1pwPhbtgCwdNKXpv4BX_bDMPTF8"

/* 3. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "61015042@kmitl.ac.th"
#define USER_PASSWORD "61015042"

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

FirebaseJson json;

String path = "/device";
String Path;
String data;
String dataSend;
void printResult(FirebaseData &data);


#define D8 (5)
#define D7 (23)
#define RX (3)
#define TX (1)
#define BAUD_RATE 9600
#undef SWAPSERIAL

#ifndef SWAPSERIAL
auto& usbSerial = Serial;
SoftwareSerial swSerial;
#else
SoftwareSerial usbSerial;
auto& swSerial = Serial;
#endif

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
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  usbSerial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    usbSerial.print(".");
    delay(300);
  }
  usbSerial.println();
  usbSerial.print("Connected with IP: ");
  usbSerial.println(WiFi.localIP());
  usbSerial.println();

  /* Assign the project host and api key (required) */
  config.host = FIREBASE_HOST;
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  Serial.println("Getting Ready Start RTDB --------- ");
  delay(5000);

  //Set the size of HTTP response buffers in the case where we want to work with large data.
  fbdo.setResponseSize(1024);

  //Set database read timeout to 1 minute (max 15 minutes)
  Firebase.RTDB.setReadTimeout(&fbdo, 1000 * 60);
  //tiny, small, medium, large and unlimited.
  //Size and its write timeout e.g. tiny (1s), small (10s), medium (30s) and large (60s).
  Firebase.RTDB.setwriteSizeLimit(&fbdo, "tiny");

  //optional, set the decimal places for float and double data to be stored in database
  Firebase.setFloatDigits(2);
  Firebase.setDoubleDigits(6);

  /*
    This option allows get and delete functions (PUT and DELETE HTTP requests) works for device connected behind the
    Firewall that allows only GET and POST requests.

    Firebase.enableClassicRequest(fbdo, true);
  */
  Serial.println("------------------------------------");
  Serial.println("Ready ...");
}

void loop() {
  while (swSerial.available() > 0) {
    char inChar = swSerial.read();
    data += inChar;
    if(data.length() == 5){
      Serial.println(data);
      break;
    }
  }
  if (data.length() == 5) {
    
    dataSend  = data;
    data = "";
  }
  if (dataSend.length() > 0) {
    
    Serial.println(dataSend);
    String deviceID = dataSend.substring(0, 3);
    Path = path + "/device_" + deviceID;
    int deviceStatus = dataSend.substring(4, 5).toInt();
    json.set("device_status", deviceStatus);
    json.set("device_connect", WiFi.macAddress());
    if (Firebase.RTDB.updateNode(&fbdo, Path.c_str(), &json))
    {
      Path = path + "/device_" + deviceID + "/device_status_uptime";
      if (Firebase.RTDB.setTimestamp(&fbdo, Path.c_str())) {
        Path = path + "/device_" + deviceID + "/history";
        json.clear().add("device_status", deviceStatus);
        if (Firebase.RTDB.pushJSON(&fbdo, Path.c_str(), &json))
        {
          Path = path + "/device_" + deviceID + "/history/" + fbdo.pushName() + "/device_status_uptime";
          if (Firebase.RTDB.setTimestamp(&fbdo, Path.c_str()))
          {
            Serial.println("SUCCESS");
            swSerial.write('0');
            dataSend = "";
          } else {
            Serial.println("FAILED");
            swSerial.write('0');
            dataSend = "";
          }

        } else {
          Serial.println("FAILED");
          swSerial.write('0');
          dataSend = "";
        }
      } else {
        Serial.println("FAILED");
        Serial.println("REASON: " + fbdo.errorReason());
        Serial.println("------------------------------------");
        Serial.println();
        swSerial.write('0');
        dataSend = "";
      }
    }
    else
    {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
      Serial.println("------------------------------------");
      Serial.println();
      Serial.println("FAILED");
      swSerial.write('0');
      dataSend = "";
    }
  }
}

void printResult(FirebaseData &data)
{

  if (data.dataType() == "json")
  {
    Serial.println();
    FirebaseJson &json = data.jsonObject();
    //Print all object data
    Serial.println("Pretty printed JSON data:");
    String jsonStr;
    json.toString(jsonStr, true);
    Serial.println(jsonStr);
    Serial.println();
    Serial.println("Iterate JSON data:");
    Serial.println();
    size_t len = json.iteratorBegin();
    String key, value = "";
    int type = 0;
    for (size_t i = 0; i < len; i++)
    {
      json.iteratorGet(i, type, key, value);
      Serial.print(i);
      Serial.print(", ");
      Serial.print("Type: ");
      Serial.print(type == FirebaseJson::JSON_OBJECT ? "object" : "array");
      if (type == FirebaseJson::JSON_OBJECT)
      {
        Serial.print(", Key: ");
        Serial.print(key);
      }
      Serial.print(", Value: ");
      Serial.println(value);
    }
    json.iteratorEnd();
  } else
  {
    Serial.println(data.payload());
  }
}
