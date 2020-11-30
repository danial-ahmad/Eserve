import 'package:Eserve/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  var app = MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedSplashScreen(),
  );
  runApp(app);
}
