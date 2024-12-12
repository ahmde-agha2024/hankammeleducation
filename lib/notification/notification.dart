import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hankammeleducation/notification/fb_notifications.dart';

class DeviceInfoScreen extends StatefulWidget {
  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen>with FbNotifications {
  String tokenDevice = '';
  String deviceType = '';
  String deviceName = '';
  String osVersion = '';

  @override
  void initState() {
    super.initState();
    fetchDeviceInfo();
    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
  }

  Future<void> fetchDeviceInfo() async {
    try {
      // 1. الحصول على Firebase Token
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        tokenDevice = token ?? 'No Token Available';
      });

      // 2. الحصول على معلومات الجهاز
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceType = 'android';
          deviceName = androidInfo.model ?? 'Unknown';
          osVersion = androidInfo.version.release ?? 'Unknown';
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceType = 'iOS';
          deviceName = iosInfo.utsname.machine ?? 'Unknown';
          osVersion = iosInfo.systemVersion ?? 'Unknown';
        });
      }
    } catch (error) {
      print('Error fetching device info: $error');
    }
  }

  // Future<void> sendRequest() async {
  //   final url = Uri.parse('https://your-api-endpoint.com'); // ضع رابط الخادم هنا
  //   final data = {
  //     "data": {
  //       "token_id": tokenDevice,
  //       "device_type": deviceType,
  //       "device_name": deviceName,
  //       "os_version": osVersion,
  //     }
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(data),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: Text("Success"),
  //           content: Text("Response: $responseData"),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text("OK"),
  //             )
  //           ],
  //         ),
  //       );
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: Text("Error"),
  //           content: Text("Failed to send data. Status code: ${response.statusCode}"),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text("OK"),
  //             )
  //           ],
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text("Error"),
  //         content: Text("An error occurred: $error"),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("OK"),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(tokenDevice);
    print(deviceType);
    print(deviceName);
    print(osVersion);
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Token Device: $tokenDevice"),
            Text("Device Type: $deviceType"),
            Text("Device Name: $deviceName"),
            Text("OS Version: $osVersion"),
            SizedBox(height: 20),
            const ElevatedButton(
              onPressed: null,
              child: Text("Send Request"),
            ),
          ],
        ),
      ),
    );
  }
}
