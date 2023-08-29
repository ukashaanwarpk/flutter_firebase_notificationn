import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'firebase_notifiation_service.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // notificationService.isRefreshToken();

    notificationService.requestNotificationPermission();
    notificationService.setupInteractMessage(context);
    notificationService.firebaseInit(context);
    notificationService.getDeviceToken().then((value) {
      print(" Device Token\n{$value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Notification'),
          centerTitle: true,
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              notificationService.getDeviceToken().then((value) {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {'title': 'Ukasha', 'body': 'Anwar'},
                  'data': {
                    'type': "mesg",
                    "id": '1234',
                  }
                };
                http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAAys-hgNA:APA91bE3WjP4meGcXDQQAXZxOglsI2PJJUmBuTD5_Ol36GGZbl8YrWpJYZyS43VfNtMNgXUrheN0sMt9HTQgfPNzxJ8BqvdRMPV7Y8SV-HhdaRG4uLFKXL6YDP4Jb6btCIyLpfbvrwfg'
                    });
              });
            },
            child: const Text("Send Notification"),
          ),
        ));
  }
}
