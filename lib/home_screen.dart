import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/sensor_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _edtSuhuController = TextEditingController();
  final TextEditingController _edtServoController = TextEditingController();
  final TextEditingController _edtJam1Controller = TextEditingController();
  final TextEditingController _edtMenit1Controller = TextEditingController();

  List<Sensor> sensorList = [];

  bool updateSensor = false;

  @override
  void initState() {
    super.initState();

    retrieveSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IOT"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < sensorList.length; i++)
              sensorWidget(sensorList[i])
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _edtSuhuController.text = "";
          _edtServoController.text = "";
          _edtJam1Controller.text = "";
          _edtMenit1Controller.text = "";

          updateSensor = false;
          sensorDialog();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void sensorDialog({String? key}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _edtSuhuController,
                    decoration: const InputDecoration(helperText: "Suhu"),
                  ),
                  TextField(
                      controller: _edtServoController,
                      decoration: const InputDecoration(helperText: "Servo")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: _edtJam1Controller,
                      decoration: const InputDecoration(helperText: "Jam1")),
                  TextField(
                      controller: _edtMenit1Controller,
                      decoration: const InputDecoration(helperText: "Menit1")),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> data = {
                          "suhu": _edtSuhuController.text.toString(),
                          "servo": _edtServoController.text.toString(),
                          "jam1": _edtMenit1Controller.text.toString(),
                          "menit1": _edtJam1Controller.text.toString(),
                        };

                        if (updateSensor) {
                          dbRef
                              .child("data_sensor")
                              .child(key!)
                              .update(data)
                              .then((value) {
                            int index = sensorList
                                .indexWhere((element) => element.key == key);
                            sensorList.removeAt(index);
                            sensorList.insert(
                                index,
                                Sensor(
                                    key: key,
                                    sensorData: SensorData.fromJson(data)));
                            setState(() {});
                            Navigator.of(context).pop();
                          });
                        } else {
                          dbRef
                              .child("data_sensor")
                              .push()
                              .set(data)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: Text(updateSensor ? "Beri Pakan" : "Beri Pakan"))
                ],
              ),
            ),
          );
        });
  }

  void retrieveSensorData() {
    dbRef.child("data_sensor").onChildAdded.listen((data) {
      SensorData sensorData = SensorData.fromJson(data.snapshot.value as Map);
      Sensor sensor = Sensor(key: data.snapshot.key, sensorData: sensorData);
      sensorList.add(sensor);
      setState(() {});
    });
  }

  Widget sensorWidget(Sensor sensor) {
    return InkWell(
      onTap: () {
        _edtSuhuController.text = sensor.sensorData!.suhu!;
        _edtServoController.text = sensor.sensorData!.servo!;
        _edtJam1Controller.text = sensor.sensorData!.jam1!;
        _edtMenit1Controller.text = sensor.sensorData!.menit1!;
        updateSensor = true;
        sensorDialog(key: sensor.key);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SUHU"),
                Text(sensor.sensorData!.suhu!),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Servo"),
                Text(sensor.sensorData!.servo!),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Menit1"),
                Text(sensor.sensorData!.menit1!),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jam1"),
                Text(sensor.sensorData!.jam1!),
              ],
            ),
            InkWell(
                onTap: () {
                  dbRef
                      .child("data_sensor")
                      .child(sensor.key!)
                      .remove()
                      .then((value) {
                    int index = sensorList
                        .indexWhere((element) => element.key == sensor.key!);
                    sensorList.removeAt(index);
                    setState(() {});
                  });
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
