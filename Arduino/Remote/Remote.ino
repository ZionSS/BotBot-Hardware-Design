#include <WiFi.h>

const char* ssid = "HardwareLab";
const char* password = "hwlab504";
IPAddress receiverIP(192, 168, 1, 112);  // IP address of the receiver ESP32 board
int receiverPort = 1234;  // Port number to send data

const int threshold = 100;
WiFiClient client;
IPAddress local_IP(192, 168, 1, 113);
// Set your Gateway IP address
  IPAddress gateway(192, 168, 1, 1);

  IPAddress subnet(255, 255, 0, 0);
void setup() {
  Serial.begin(115200);
 if (!WiFi.config(local_IP, gateway, subnet)) {
    Serial.println("STA Failed to configure");
  }
  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
Serial.println(WiFi.localIP());
  Serial.println("Connected to Wi-Fi");
}

void loop() {
  // Read joystick X and Y values
  int joystickX = analogRead(36);
  int joystickY = analogRead(39);

  // Read button states (A-F)
  bool buttonA = digitalRead(2);
  bool buttonB = digitalRead(3);
  bool buttonC = digitalRead(4);
  bool buttonD = digitalRead(5);

  // Create data packet
  char data[6];
  data[0] = joystickX;
  data[1] = joystickY;
  data[2] = buttonA;
  data[3] = buttonB;
  data[4] = buttonC;
  data[5] = buttonD;
  String direction;

  if (joystickX < threshold) {
    direction = "Left";
  } else if (joystickX > 4095 - threshold) {
    direction = "Right";
  } else if (joystickY < threshold) {
    direction = "Down";
  } else if (joystickY > 4095 - threshold) {
    direction = "Up";
  } else {
    direction = "Neutral";
  }
  Serial.print(joystickX);
  Serial.print(" ");
  Serial.println(joystickY);
  Serial.println("Direction: " + direction);
  // Send data to the receiver
  if (client.connect(receiverIP, receiverPort)) {
    client.println(direction);
    Serial.println("Sent data to the receiver");
    client.stop();
  } else {
    Serial.println("Failed to connect to the receiver");
  }
 Serial.println(data[0]);
  Serial.println(data[1]);
  delay(100);
}
