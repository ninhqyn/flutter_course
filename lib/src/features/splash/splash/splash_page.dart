import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget{
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFC1E6F3),
      body: Center(
            child: Text('COURSE APP',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35
            ),),
          ),
    );
  }
}