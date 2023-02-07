import 'dart:convert';
import 'dart:developer';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/KotSubTable.dart';
import 'package:bestmummybackery/Model/KOTtableModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/_SalesInvoiceOnline.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class KOTTableWise extends StatefulWidget {
  String DiningName = "";
  KOTTableWise({Key key, this.DiningName}) : super(key: key);
  @override
  _KOTTableWiseState createState() => _KOTTableWiseState();
}

class _KOTTableWiseState extends State<KOTTableWise> {
  bool loading = false;
  KotTableModel model;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var status = 0;
  @override
  void initState() {
    // TODO: implement initState
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('KOT Table'),
        actions: [
          SizedBox(width: 20),

        ],
      ),
      body: !loading
          ? Center(
              child: SingleChildScrollView(
                child: Container(
                  height: height,
                  width: width,
                  child: model != null
                      ? GridView.count(
                          childAspectRatio: 1.5,
                          crossAxisCount: !tablet?2:4,
                          children: [
                            if (model.result.length > 0)
                              for (int cat = 0;
                                  cat < model.result.length;
                                  cat++)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => KOTSubTable(
                                                CreationName:
                                                    "${widget.DiningName}",
                                                TableNo:
                                                    "${model.result[cat].tableNo.toString()}")));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: status == 0
                                          ? Colors.blue
                                          : Colors.red,
                                      elevation: 5,
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Center(
                                                  child: Text(
                                                    widget.DiningName+"-Table",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      model.result[cat].tableNo.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          ],
                        )
                      : Container(),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      print('USERID$sessionuserID');
      //gettablevalues();
      gettablevaluesnet();
      print(widget.DiningName);
      // check().then((value) {
      //   if (value) {
      //     print("MobileSatus  Net Irukku");
      //     setState(() {
      //       gettablevaluesnet();
      //     });
      //   }else{
      //     print("MobileSatus No Net");
      //     setState(() {
      //       gettablevalues();
      //     });
      //   }
      // });



    });
  }

  Future<List> gettablevalues() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "Select DISTINCT  TableNo from IN_MOB_TABLE_MASTER where Location in (${sessionbranchcode},0) and Active='Y' and CreationName='${widget.DiningName}'");
    print(jsonEncode(list));
    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "No Data");
    } else {
      try {
        setState(() {
          /*  categoryitem = CategoriesModel.fromJson(
              jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
          print('ONCLICK${onclick}');*/
          model = KotTableModel.fromJson(
              jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
          print(json.encode(list));
        });
      } catch (e) {
        print(e);
      }
    }
  }
   Future<http.Response> gettablevaluesnet() async {
    var headers = {"Content-Type": "application/json"};
    var body = {"LocCode": sessionbranchcode, "CreationName": widget.DiningName};

    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getKOTTableName1'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
    log(response.body);
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        model.result = null;
      } else {
        setState(() {
          print(jsonDecode(response.body)["result"]);
          model = KotTableModel.fromJson(jsonDecode(response.body));
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
