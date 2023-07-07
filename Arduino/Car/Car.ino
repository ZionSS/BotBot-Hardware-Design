#include <WiFi.h>
#include <WiFiServer.h>

const char* ssid = "HardwareLab";
const char* password = "hwlab504";
int receiverPort = 1234;  // Port number to receive data

WiFiServer server(receiverPort);
WiFiClient client;

  IPAddress local_IP(192, 168, 1, 112);
// Set your Gateway IP address
  IPAddress gateway(192, 168, 1, 1);

  IPAddress subnet(255, 255, 0, 0);
void setup() {
  Serial.begin(2400);
  pinMode(2,OUTPUT);
  digitalWrite(2,LOW);
  if (!WiFi.config(local_IP, gateway, subnet)) {
    Serial.println("STA Failed to configure");
  }
  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to Wi-Fi");

  Serial.println(WiFi.localIP());
  // Start the server
  server.begin();
  Serial.println("Server started");
  
}

void loop() {
  char data[6];
  byte sendData = 0x00;
  // Check if a client has connected
  client = server.available();
  if (client) {
    while (client.connected()) {
      // Read data from the client
      if (client.available()) {
        String receivedData = client.readStringUntil('\n');
        Serial.println("Received data from the sender:");
        digitalWrite(2,HIGH);
         if  (receivedData.indexOf("Up") != -1) {
      sendData = 0xAA;
      Serial.println(receivedData);
    }
    else if (receivedData.indexOf("Left") != -1){
      sendData = 0xBB;
      Serial.println(receivedData);
    }
    else if (receivedData.indexOf("Right") != -1){
      sendData = 0xCC;
      Serial.println(receivedData);
    }
    else if (receivedData.indexOf("Down") != -1){
      sendData = 0xDD;
      Serial.println(receivedData);
    }
    else if (receivedData.indexOf("Neutral") != -1){
      sendData = 0xEE;
      Serial.println(receivedData);
    }
    Serial.println(receivedData);
    Serial.write(sendData);
    Serial.println(sendData,BIN);
    Serial.println(sendData);
      }
    }
   client.stop();
   digitalWrite(2,LOW);
  }
}

    

   
