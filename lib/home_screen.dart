import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel("sample.android.sdk");

  Future<int?> getSdkVersion() async {
    try {
      // To get the SDK version , we use platform Channel and invoke a method
      // getSdkLevel to get the sdk level.
      final result = await platform.invokeMethod<int>("getSdkLevel");
      return result;
    } on PlatformException catch (e) {
      log("$e");
      return null;
    }
  }

  void requestPermission() async {
    if (Platform.isAndroid) {
      // We can get the device sdk version using DeviceInFo Plugin
      // var deviceData = await DeviceInfoPlugin().androidInfo;
      // We the Sdk Version of Android using Method Channel
      var sdkVersion = await getSdkVersion();
      if (sdkVersion! >= 33) {
        // Check the storage Permission's  request statues
        var status = await Permission.photos.request();
        // For other permissions ,use this
        // var status = await Permission.audio.request();
        // var status = await Permission.videos.request();

        if (status.isGranted) {
          log('Permission Granted');
          Fluttertoast.showToast(
              msg: "Permission Granted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // Storage  Permission is granted here we can proceed for next methods.
        } else if (status.isDenied) {
          // Storage Permission is denied by the user we need to request again
          await Permission.photos.request();
        } else if (status.isPermanentlyDenied) {
          //if  Storage Permission is Permanently denied by the user ,we need to
          // openAppSetting() to manually user allow permission for storage and
          // others
          openAppSettings();
        } else {
          await Permission.photos.request();
        }
      } else {
        var status = await Permission.storage.request();

        if (status.isGranted) {
          Fluttertoast.showToast(
              msg: "Permission Granted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          log('Permission Granted');
          // Storage  Permission is granted here we can proceed for next methods.
        } else if (status.isDenied) {
          // Storage Permission is denied by the user we need to request again
          await Permission.storage.request();
        } else if (status.isPermanentlyDenied) {
          //if  Storage Permission is Permanently denied by the user ,we need to
          // openAppSetting() to manually user allow permission for storage and
          // others
          openAppSettings();
        } else {
          await Permission.storage.request();
        }
      }
    }
    if (Platform.isIOS) {
      // Check the storage Permission's  request statues
      var status = await Permission.photos.request();

      if (status.isGranted) {
        Fluttertoast.showToast(
            msg: "Permission Granted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // Storage  Permission is granted here we can proceed for next methods.
      } else if (status.isDenied) {
        // Storage Permission is denied by the user we need to request again
        await Permission.photos.request();
      } else if (status.isPermanentlyDenied) {
        //if  Storage Permission is Permanently denied by the user ,we need to
        // openAppSetting() to manually user allow permission for storage and
        // others
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: requestPermission,
            child: const Text('Request Storage Permission')),
      ),
    );
  }
}
