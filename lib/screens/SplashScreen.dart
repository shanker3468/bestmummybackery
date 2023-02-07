import 'dart:async';
//import 'package:bestmummybackery/PostData.dart';
import 'package:bestmummybackery/screens/Dashboard.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  var islogged = false;
  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
            builder: (BuildContext context) => islogged == true ? Dashboard() : LoginPage()
            )
        )
    );
    var assetsImage = new AssetImage(
        'assets/imgs/splashanim.gif'); //<- Creates an object that fetches an image.
    var image = new Image(
        image: assetsImage,
        height: MediaQuery.of(context)
            .size
            .height); //<- Creates a widget that displays an image.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(
            child: image,
          ),
        ), //<- place where the image appears
      ),
    );
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      islogged = prefs.getBool('LoggedIn');
    });
  }
}
