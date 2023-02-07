// ignore_for_file: non_constant_identifier_names, missing_return, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/KOTModel.dart';
import 'package:bestmummybackery/Model/Saleshiftmodel.dart';
import 'package:bestmummybackery/helper/DbHelper.dart';
import 'package:bestmummybackery/screens/KOTTableWise.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/_SalesInvoiceOnline.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class KOTHallName extends StatefulWidget {
  const KOTHallName({Key key}) : super(key: key);

  @override
  KOTHallNameState createState() => KOTHallNameState();
}

class KOTHallNameState extends State<KOTHallName> {
  bool loading = false;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var PrintStatus = "";
  KOTModel model;
  DbHelper dbHelper = new DbHelper();
  Saleshiftmodel RawSaleshiftmodel;
  var MyShitId=0;
  @override
  void initState() {
    // TODO: implement initState
    // dbHelper.initDb();
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
                child: model != null
                    ? Container(
                        height: height,
                        width: width,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.result.length == null? 0: model.result.length,
                          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.5,
                            crossAxisCount: 4,
                          ),
                          itemBuilder: (contxt, indx) {
                            return InkWell(
                              onTap: () {
                                print(model.result[indx].creationName);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KOTTableWise(
                                        DiningName:"${model.result[indx].creationName}"),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.all(4.0),
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0, top: 6.0, bottom: 2.0),
                                  child: Center(
                                      child: Text(model.result[indx].creationName.toString(),
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                  )),
                                ),
                              ),
                            );
                          },
                        ))
                    : Container(),
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
      PrintStatus = prefs.getString('PrintStatus');
      print('USERID$sessionuserID');
      print('USERID$sessionbranchcode');
      print('PrintStatus$PrintStatus');
      //gettablevalues();
      //getPendingListChecking();
      getShitIdCheck();

    });
  }

  Future<http.Response> getPendingListChecking() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": 7,
      "DocNo": 0,
      "ScreenId": 0,
      "OpeningAmt": 0.0,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": 0,
      "UserID": int.parse(sessionuserID),
      "Status": 'O'
      //FormID,:DocNo,:ScreenId,:OpeningAmt,:CounterId,:DeviceId,:UserID,:Status
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_OEPN_SP'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        showDialogboxWarning(this.context, "Enter The Opening Amt");
      } else {
        log(response.body);
        setState(() {
          //gettablevalues();
          gettablevaluesnet();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<List> getShitIdCheck() async {
    print(sessionbranchcode);
    List<Map> list = new List();
    int MapId=1;
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);


    if(PrintStatus=="Y"){
      list = await database.rawQuery("SELECT * FROM IN_MOB_SHIFT_OPEN WHERE DocDate=DATE()  AND CounterId = '${sessionbranchcode}' And UserId = '${sessionuserID}' And Status = 'O'");
      log("{\"status\":\1\,\"result\":  ${jsonEncode(list)}}");
    }
    else if(PrintStatus=="N"){
      list = await database.rawQuery("SELECT * FROM IN_MOB_SHIFT_OPEN WHERE DocDate=DATE()  AND CounterId = '${sessionbranchcode}'  And Status = 'O'");
      log("{\"status\":\1\,\"result\":  ${jsonEncode(list)}}");
    }
    else{
      setState(() {
        MapId = 100;
      });
    }

    await database.close();
    setState(() {
      loading = false;
    });

    if (list.length == 0) {
      showDialogboxWarning(this.context, "Kindly Open The Shit..");
    } else if(MapId==100){
      showDialogboxWarning(this.context, "Kindly Open The Shit Or Check Sap Permision..");
    }
    else {
      try {
        setState(() {
          RawSaleshiftmodel = Saleshiftmodel.fromJson(jsonDecode("{\"status\":\1\,\"result\": ${jsonEncode(list)}}"));
          print(RawSaleshiftmodel.result[0].docNo);
          MyShitId=RawSaleshiftmodel.result[0].docNo;
          print("MyShitId IS - "+MyShitId.toString());
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        gettablevaluesnet();
      });

    }
  }

  Future<List> gettablevaluesttttttttt() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "Select Distinct CreationName as CreationName from IN_MOB_TABLE_MASTER where Location in (${sessionbranchcode},0) and Active='Y'");
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
          model = KOTModel.fromJson(
              jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
          print(json.encode(list));
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void gettablevaluesnet() {
    setState(() {
      loading = true;
    });
    GetAllMaster(13, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          showDialogboxWarning(this.context, "No Data");
        } else {
          setState(() {

            loading = false;
            log(response.body);
            model = KOTModel.fromJson(jsonDecode(response.body));

          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
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
