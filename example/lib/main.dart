import 'package:dartusbhid/usb_device.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:dartusbhid/dartusbhid.dart' as dartusbhid;
import 'package:dartusbhid/enumerate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Hello world";

  @override
  void initState() {
    super.initState();
  }

  Future<List<USBDeviceInfo>> getDevices() async {
    var devices = await enumerateDevices(0, 0);
    return devices;
    // for (var device in devices) {
    //   print(device.manufacturerString);
    //   print(device.productString);
    //   print(device.productId);
    //   print(device.vendorId);
    // }
    // var openDevice = await devices[0].open();
    // print(devices[0].manufacturerString);
    // while (true) {
    //   var report = await openDevice.readReport();
    //   setState(() {
    //     text = report.toString();
    //   });
    // }
    // await openDevice.close();
    // print(devices[0]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<USBDeviceInfo>>(
            future: getDevices(),
            builder: (BuildContext context,
                AsyncSnapshot<List<USBDeviceInfo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text('Refreshing usb devices'));
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var device = snapshot.data![index];
                        return Container(
                          height: 50,
                          margin: const EdgeInsets.all(2),
                          child: Center(
                              child: Text(
                            '${device.productString} (${device.manufacturerString})',
                            style: const TextStyle(fontSize: 18),
                          )),
                        );
                      });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
