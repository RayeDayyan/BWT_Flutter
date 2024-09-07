import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as googleAuth;
import 'package:googleapis/servicecontrol/v1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_7_buddyup/models/user_model.dart';
import 'package:task_7_buddyup/views/dashboard/home_page.dart';

class UserController {
  final auth = FirebaseAuth.instance;

  final user = FirebaseAuth.instance.currentUser!.uid;

  final fireStore = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance
      .ref()
      .child('ProfilePicture/${FirebaseAuth.instance.currentUser!.uid}');

  final messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<UserModel> getUserData() async {
    final data = await fireStore.collection('users').doc(user).get();

    final userModel = UserModel.fromJson(data.data()!);

    return userModel;
  }

  Future<UserModel> getOtherUserData(String otherUserID) async {
    final data = await fireStore.collection('users').doc(otherUserID).get();

    final userModel = UserModel.fromJson(data.data()!);

    return userModel;
  }

  Future<bool> updateUser(Map<String, dynamic> updatedData) async {
    try {
      await fireStore.collection('users').doc(user).update(updatedData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePicture(XFile image) async {
    try {
      File file = File(image.path);

      await storage.putFile(file);

      final String downloadURL = await storage.getDownloadURL();

      await fireStore
          .collection('users')
          .doc(user)
          .update({'profile': downloadURL});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel?> getCreator(String creatorID) async {
    try {
      final data = await fireStore.collection('users').doc(creatorID).get();
      final user = UserModel.fromJson(data.data()!);

      return user;
    } catch (e) {
      print('error occured : $e');
      return null;
    }
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            Random.secure().nextInt(100000).toString(), 'my first channel',
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: 'my Description for channel',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails);
    });
  }

  Future<void> updateFCMToken() async {
    try {
      String? token = await messaging.getToken();

      final uid = auth.currentUser!.uid;

      if (token != null) {
        await fireStore
            .collection('users')
            .doc(uid)
            .update({'fcmToken': token});
      }
    } catch (e) {
      print('error occured $e');
    }
  }

  Future<String> getAccessKey() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "buddyup-5a71e",
      "private_key_id": "e92e245699a46f4e4b25a2d622689cfdf1e94e7a",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCiG9UU/vk3gnwD\n1lbS1IYX1x/LVkp3JoJmAQpeInPX0IkqzpIHlFhXeNc8tY5nCoUD/Aly7594EXmH\n8VS5UMfe/ulvF1PVKXxLP8d0aYmpO26BxL4cE4OEjAEbwQ6eZR/EYDWAV1YYAjeJ\nSJFBMsoUkAozO2cBTnX+cMrpg4eHXxbBKxwX+YHsTv/Pbm4HP9wUQE/3SWj/ksnf\nhsxqkigw/r4d2k/yIyODVdGF8C+IgD0ZZRKjOGIZsmrX3grUBgZ8YgQM6w+qg8ov\nlDK2eaVTbtSpsgjz0EugLv9pFzbpzQ1hPwq85pr2IwdDxrqk7Gsj1XoWyTln1Z+3\nDUUxSfeZAgMBAAECggEABd9IOrh5wp8Bawoqnvx/1wE975mynNpSQuuquno5BApT\nza8p7whaouCHu3VAMU9aPii1FurDNhA7/MarMQNSGivVvOZ1bPVRwVAQI5FnITA7\n8otz74RtcTG5II4/v1Eec3igt4NyZPA/nsN4L4ptc408MVrngk6bS5o+X3MaR7cF\nSiKECT9Bc2ntrfF4R2IYg/il+sAPeWmmAr/3/pkZfFgtjvl8fBk27018jk2WkpnK\nToVdgViG3GuBa9TofBDhIWzGIVIpGI7ovM1WUfAG3M8xOTQ2FwyHhOt1lyE5qy7c\n3i80L2ZvWinnNwY6NfjC1RWVLgBJDNo/r1mXiROYYQKBgQDav0wOT3gTSdGzWtS4\noF1U+L4UgeRVZaUlocFeOOhf+AZmNFkR/OeQ/VITrMmiizlloFznMC9GcaFgtRwJ\nyCR7mHCmAutuwrN5P+ICu22NbiQvnllar2xgpXJ1drETzaIboyYdFSa+nU1sZXGy\nv3f5PkMaErf2f7Z1aABbbl1OxQKBgQC9t0VDS35WaFNXQLc7PabMVIkjlYZ7Lfjr\nJ1gBb3FEgh5Pzt1kLR+juKbNnWUAIvrT/Q6jEcPbEbSIzi4FQThUE9TyaNylJDNi\nb8u7KnUJyXbafNmC/08m/rqK9jFteNkzMXkTw4EFC0YJMP5qASvkplX1hRh7EuZi\n24eIo1CSxQKBgArQekoa06zgcWWUj/+wreyNf5gz873lEI0TuiOWXKah9G8JF340\nKp6YZ35hhHZsu6Gyk+U6FJw+8eN+EKzLIEKb/rW2Xz1Sktzjs6C+82OSlmdkRLaf\nBZShmU8FVyvLdsA3CKNXcFrsG+/H9B8KKDxCP78CPeYJ2lNjmODsS+ChAoGBAIkh\nzIMUMsIqrvNG6Ct+KO9Ru79o+chYNrFjww1mjK1EkLyHfyhGJbSmaIv/1V3/6ucI\n6GefE79qUOECh+lsd1bu7uI6QiNsw2fH/6/OxMLKSYss69zwxzocrqJ7ysair/19\nKVPL4ZrPx1QlggEFz8B7K29JQaTUyIt0u8dcpYUxAoGAfCc7LsS8+WJr8KkM58hM\n1qovHT0Sk2RkOoy6JjqBIMX6WPMh33KG5mUc/qdBGjzvsYRuFO3i+B5r5EyWVjfi\ndEgtZfUWrARHitGOIFzhaQ0jczVDLAmNQxMu0WguPNx8Ucm9b5FbNj1Iwm+TC6lt\nCycQwcca+Bz5ZmovoP1Aan8=\n-----END PRIVATE KEY-----\n",
      "client_email": "raye-dayyan@buddyup-5a71e.iam.gserviceaccount.com",
      "client_id": "104936641538999951352",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/raye-dayyan%40buddyup-5a71e.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/datastore"
    ];

    final client = await googleAuth.clientViaServiceAccount(
        googleAuth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes);

    final accessCredentials =
        await googleAuth.obtainAccessCredentialsViaServiceAccount(
            googleAuth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return accessCredentials.accessToken.data;
  }

  void sendNotifications() async {
    try {
      final serverKey = await getAccessKey();
      String endPoint =
          'https://fcm.googleapis.com/v1/projects/buddyup-5a71e/messages:send';

      final querySnapshot = await fireStore.collection('users').get();
      List<String> tokens = [];

      for (var doc in querySnapshot.docs) {
        String? token = doc.data()['fcmToken'];
        if (token != null) {
          tokens.add(token);
        }
      }

      for (var deviceToken in tokens) {
        final Map<String, dynamic> message = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'New Post uploaded',
              'body': 'Check out this new post , you might be interested in'
            }
          }
        };

        final response = await http.post(Uri.parse(endPoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $serverKey'
            },
            body: jsonEncode(message));

        if (response.statusCode == 200) {
          print('notification sent');
        } else {
          print('error occured notifying');
        }
        ;
      }
    } catch (e) {
      print('error occured');
    }
  }
}
