

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  fontFamily: 'Cabin'
);

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Cabin'
);