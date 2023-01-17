#include <FirebaseESP8266.h>
#include <ESP8266WiFi.h>
#include <DallasTemperature.h>
#include <OneWire.h>
#include <Servo.h>

#define FIREBASE_HOST "https://auto-fish-feeder-iot2022-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "2hVuV3Hxg58NHmpABWmGYUPOmP3Sz0aEYUKbOo9T"
#define WIFI_SSID "Realme7Pro"
#define WIFI_PASSWORD "bdjb98bg"
FirebaseData firebaseData;

#define ONE_WIRE_BUS 5 //GPIO PIN
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature ds18b20(&oneWire);

String zero = "0", one = "1";
String Servo_Stat;
float n = 0;
int pos = 0;

const int servoPin = 4;
Servo servo;

void setup(){

	Serial.begin(115200);
	
	WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
	Serial.print("connecting");
	while (WiFi.status() != WL_CONNECTED){
		Serial.print(".");
		delay(500);
	}
	Serial.println();
	Serial.print("Connected with IP: ");
	Serial.println(WiFi.localIP());
	Serial.println();

	Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
	ds18b20.begin();  

}

void baca_suhu(){

	ds18b20.requestTemperatures();
	int t = ds18b20.getTempCByIndex(0);
	Serial.println("Temperature is: ");
	Serial.println(ds18b20.getTempCByIndex(0));
	delay(500);
	
	if (Firebase.setFloat(firebaseData, "/Dt_Sensor/suhu", t)){
    Serial.println("Suhu terkirim");
  }
  else{
    Serial.println("Suhu tidak terkirim, " + firebaseData.errorReason());
  }
}

void baca_jadwal(){



}

void buka_servo(){

	servo.attach(servoPin, 500, 2400);
	
	Firebase.getString(firebaseData, "/Dt_Sensor/Status_Servo");
	Servo_Stat = firebaseData.stringData(); Serial.print('\n');
	if (Servo_Stat == one){
    for (pos = 0; pos <= 180; pos += 1){
		servo.write(pos);
		delay(10);
    }
    for (pos = 180; pos >= 0; pos -= 1){
		servo.write(pos);
		delay(10);
    }
    Firebase.setFloat(firebaseData, "/Dt_Sensor/Status_Servo", n);
	}
  else{
		Serial.println("Command Error!");
  }
}

void fuzzyfikasi(){



}

void loop(){



}