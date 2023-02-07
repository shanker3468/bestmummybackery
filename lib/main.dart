import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/screens/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(primarySwatch: Pallete.mycolor),
    home: SplashScreen(),
  ));
}
