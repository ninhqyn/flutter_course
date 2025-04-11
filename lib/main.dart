import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();

  runApp(
    App(sf: sf),
  );

}

