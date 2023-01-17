class Sensor {
  String? key;
  SensorData? sensorData;

  Sensor({this.key, this.sensorData});
}

class SensorData {
  String? suhu;
  String? servo;
  String? jam1;
  String? menit1;

  SensorData({
    this.suhu,
    this.servo,
    this.jam1,
    this.menit1,
  });

  SensorData.fromJson(Map<dynamic, dynamic> json) {
    suhu = json["suhu"];
    servo = json["servo"];
    jam1 = json["jam1"];
    menit1 = json["menit1"];
  }
}
