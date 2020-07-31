import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  String serverToken =
      'AAAAJGnT0rA:APA91bEH1BT3R2nQrFmamOlKwz82wF2pCI0JY6qM5DfzQtN-TDrT1Fj_keaqtx-3Urx7jOsAZd0553_0_-rC6Td6J4HeHmm5s0SqcgzEHT8WwSFnB_6rXCWoc3EQzpHPBFsYuMj2imTD';

  NotificationHandler._();
  String token;
  factory NotificationHandler() => instance;
  static final NotificationHandler instance = NotificationHandler._();
  final FirebaseMessaging fcm = FirebaseMessaging();
  bool initialized = false;

  Future<String> init(context) async {
    if (!initialized) {
      fcm.requestNotificationPermissions();
      fcm.configure(
          onMessage: (message) async {
          },
          onResume: (message) async {});

      // For testing purposes print the Firebase Messaging token
      token = await fcm.getToken();
      initialized = true;
    }
    return token;
  }

  Future<void> sendMessage(title, body, nt) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': nt,
        },
      ),
    );
  }
}
