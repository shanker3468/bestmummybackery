// ignore_for_file: deprecated_member_use, non_constant_identifier_names, missing_return, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/LoginModel.dart';
import 'package:bestmummybackery/helper/DbHelper.dart';
import 'package:bestmummybackery/screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  TextEditingController EdtUsername = new TextEditingController();
  TextEditingController EdtPassword = new TextEditingController();
  bool _obscureText = true;
  LoginModel loginModel;
  DbHelper dbHelper = new DbHelper();

  @override
  void initState() {
    dbHelper.initDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff3A9BDC),
              Color(0xff3A9BDC),
            ],
          ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: !loading
              ? ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: WaveClipper2(),
                          child: Container(
                            child: Column(),
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Color(0xff9acef0),
                              Color(0xff9acef0)
                            ])),
                          ),
                        ),
                        ClipPath(
                          clipper: WaveClipper3(),
                          child: Container(
                            child: Column(),
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Color(0xff9acef0),
                              Color(0xff9acef0)
                            ])),
                          ),
                        ),
                        ClipPath(
                          clipper: WaveClipper1(),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Color(0xff3188c1),
                              Color(0xff3188c1)
                            ])),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Container(
                            child: TextField(
                              onChanged: (String value) {},
                              cursorColor: Colors.deepOrange,
                              controller: EdtUsername,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "User Name",
                                  prefixIcon: Material(
                                    elevation: 0,
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          controller: EdtPassword,
                          obscureText: _obscureText,
                          onChanged: (String value) {},
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              prefixIcon: Material(
                                elevation: 0,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.blue,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        child: ElevatedButton(
                          //style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                          child: Text(
                            "Login", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            /*      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));*/

                            if (EdtUsername.text.isEmpty) {
                              showDialogboxWarning(context, "Enter User Name");
                            } else if (EdtPassword.text.isEmpty) {
                              showDialogboxWarning(context, "Enter Password");
                            } else {
                              print('click');
                              postRequest1();
                              //loginget();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "FORGOT PASSWORD ?",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an Account ? ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                        Text("Sign Up ",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                decoration: TextDecoration.underline)),
                      ],
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  Future<List> loginget() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "Select A.empID,A.firstName,A.branch as 'BranchCode', B.Name 'BranchName',A.dept DeptCode,C.Name as 'DeptName' from OHEM A LEFT JOIN OUBR B on A.branch=B.Code LEFT JOIN OUDP C on A.dept=C.Code WHERE A.Active='Y' and A.empID='${EdtUsername.text}' and A.empID='${EdtPassword.text}'");
    print(list);
    // await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "Invalid Username and Password");
    } else {
      // showDialogboxWarning(this.context, "Ok");

      // loginModel = LoginModel.fromJson(jsonDecode(response.body));
      setState(() {
        loginModel = LoginModel.fromJson(
            jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
      });
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

      final SharedPreferences prefs = await _prefs;
      prefs.setString("UserID", loginModel.result[0].empID.toString());
      prefs.setString("FirstName", loginModel.result[0].firstName.toString());
      prefs.setString("BranchCode", loginModel.result[0].branchCode.toString());
      prefs.setString("BranchName", loginModel.result[0].branchName.toString());
      prefs.setString("DeptCode", loginModel.result[0].deptCode.toString());
      prefs.setString("DeptName", loginModel.result[0].deptName.toString());

      prefs.setBool("LoggedIn", true);
      Navigator.pushReplacement(
          this.context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  Future<http.Response> postRequest1() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "UserName": "${EdtUsername.text}",
      "UserPassword": "${EdtPassword.text}"
    };
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'login'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'login');
      setState(() {
        loading = false;
      });
      print('REPOSD  ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var login = jsonDecode(response.body)['status'] = 0;
        print(jsonDecode(response.body)['status'] = 0);
        if (login == false) {
          Fluttertoast.showToast(
              msg: "Login failed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          loginModel = LoginModel.fromJson(jsonDecode(response.body));

          print(jsonDecode(response.body));

          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

          final SharedPreferences prefs = await _prefs;
          prefs.setString("UserID", loginModel.result[0].empID.toString());
          prefs.setString("FirstName", loginModel.result[0].firstName.toString());
          prefs.setString("BranchCode", loginModel.result[0].branchCode.toString());
          prefs.setString("BranchName", loginModel.result[0].branchName.toString());
          prefs.setString("DeptCode", loginModel.result[0].deptCode.toString());
          prefs.setString("DeptName", loginModel.result[0].deptName.toString());
          prefs.setString("PrintStatus", loginModel.result[0].PrintStatus.toString());
          prefs.setString("DayEndClsg", loginModel.result[0].DayEndClsg.toString());
          prefs.setString("DayDash", loginModel.result[0].DayDash.toString());
          prefs.setString("Contact1", loginModel.result[0].Contact1.toString());
          prefs.setString("Contact2", loginModel.result[0].Contact2.toString());

          prefs.setBool("LoggedIn", true);

          print(loginModel.result[0].branchCode.toString());
          Navigator.pushReplacement(
            this.context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        }
        // showDialogbox(context, response.body);

      } else {
        showDialogboxWarning(this.context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: this.context,
            builder: (_) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  "No Response!..",
                  style: TextStyle(color: Colors.purple),
                ),
                content: Text(
                  "Slow Server Response or Internet connection",
                  style: TextStyle(color: Colors.white),
                )));
      });
      throw Exception('Internet is down');
    }
  }
}

Future showDialogboxWarning(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
