import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {      
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  static late ColorScheme colorScheme;
  static Future initColor() async {
    colorScheme = await ColorScheme.fromImageProvider(provider: const AssetImage('asset/color.png'));
  }
}