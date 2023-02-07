import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/KOTBookedModel.dart';
import 'package:bestmummybackery/Model/KOTSubTableModel.dart';
import 'package:bestmummybackery/screens/KOTScreenOffline.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/_SalesInvoiceOnline.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class KOTSubTable extends StatefulWidget {
  String CreationName = "";
  String TableNo = "";

  KOTSubTable({Key key, this.CreationName, this.TableNo}) : super(key: key);

  @override
  _KOTSubTableState createState() => _KOTSubTableState();
}

class _KOTSubTableState extends State<KOTSubTable> {
  bool loading = false;
  KOTSubTableModel model;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  KOTBookedModel bookedmodel;
  List<DataList> flag = new List();
  List<String> amount = new List();

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
        title: Text('KOT Table No : ${widget.TableNo}'),
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
                            for (int cat = 0; cat < model.result.length; cat++)
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KOTScreenOffline(
                                        CreationName: "${widget.CreationName}",
                                        TableNo: widget.TableNo,
                                        SeatNo: "${model.result[cat].seatNo.toString()}",
                                        NetWorkCheckNumter: 0,
                                      ),
                                    ),
                                  );
                                  print(flag[cat].enable);
                                  print(flag[cat].seatno);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: flag.length != 0
                                        ? flag[cat].enable == 1
                                            ? Colors.red
                                            : Colors.blue
                                        : Colors.blue,
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
                                              padding: const EdgeInsets.all(2.0),
                                              child: Center(
                                                child: Text(
                                                  'Seat No',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: !tablet?height/45:25.0,
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
                                                    model.result[cat].seatNo
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: !tablet?height/30:30.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                flag.length != 0
                                                    ? flag[cat].enable == 1
                                                        ? Center(
                                                            child: Text(
                                                              'Rs.${flag[cat].amount.toString()}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: !tablet?height/30:30.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )
                                                        : Container()
                                                    : Container(),
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
      gettablevaluesold();
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
        "Select DISTINCT SeatNo from IN_MOB_TABLE_MASTER  where Location in(${sessionbranchcode},0) and Active='Y' and CreationName='${widget.CreationName}' and TableNo = '${widget.TableNo}'");
    print(jsonEncode(list));
    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "No Data");
      //isbooking();
    } else {
      try {
        setState(() {
          model = KOTSubTableModel.fromJson(
              jsonDecode("{\"status\":\1\,\"result\": ${json.encode(list)}}"));

          isbooking();
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<http.Response> gettablevaluesold() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "LocCode": sessionbranchcode,
      "CreationName": widget.CreationName,
      "TableNo":widget.TableNo
    };
    setState(() {
      loading = true;
      log(jsonEncode(body));
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getSubKOTTable'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["status"]);
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          model = KOTSubTableModel.fromJson(jsonDecode(response.body));
          isbookingOnline();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> isbookingOnline() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });

    var body = {
      "CreationName": widget.CreationName,
      "TableNo": widget.TableNo,
      "BranchID": sessionbranchcode
    };
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getIsTableBooked'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          bookedmodel = KOTBookedModel.fromJson(jsonDecode(response.body));

          flag.clear();
          List<String> cnt = [];
          for (int i = 0; i < model.result.length; i++) {
            flag.add(DataList(model.result[i].seatNo.toString(),
                model.result[i].seatNo.toString(), 0));
          }
          //slog(json.encode(flag));
          for (int i = 0; i < model.result.length; i++) {
            for (int j = 0; j < bookedmodel.result.length; j++) {
              if (model.result[i].seatNo == bookedmodel.result[j].seatNo) {
                flag[i].amount = bookedmodel.result[j].totAmount.toString();
                flag[i].enable = 1;
              }
            }
          }
          log(json.encode(flag));


        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<List> isbooking() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    setState(() {
      loading = false;
    });
    List<Map> list = await database.rawQuery(
        "Select SUM(TotAmount)'TotAmount',SUM(OverallAmount)'OverallAmount',OrderNo,SeatNo,CreationName,TableNo from IN_MOB_KOT_HEADER where CreationName='${widget.CreationName}' and TableNo='${widget.TableNo}' and OrderStatus='D' and BranchID='${sessionbranchcode}' GRoup By OrderNo,SeatNo,CreationName,TableNo");
    await database.close();

    if (list.length == 0) {
      // gettablevalues();
      print("True");
    } else {
      print("false");
      try {
        setState(() {
          bookedmodel = KOTBookedModel.fromJson(jsonDecode("{\"status\":\1\,\"result\": ${json.encode(list)}}"));


          flag.clear();
          List<String> cnt = [];
          for (int i = 0; i < model.result.length; i++) {
            flag.add(DataList(model.result[i].seatNo.toString(),
                model.result[i].seatNo.toString(), 0));
          }
          //slog(json.encode(flag));
          for (int i = 0; i < model.result.length; i++) {
            for (int j = 0; j < bookedmodel.result.length; j++) {
              if (model.result[i].seatNo == bookedmodel.result[j].seatNo) {
                flag[i].amount = bookedmodel.result[j].totAmount.toString();
                flag[i].enable = 1;
              }
            }
          }
          log(json.encode(flag));

        });
      } catch (e) {
        print(e);
      }
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

class DataList {
  String amount;
  String seatno;
  int enable;

  DataList(this.amount, this.seatno, this.enable);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Amount'] = this.amount;
    data['SeatNo'] = this.seatno;
    data['Enable'] = this.enable;

    return data;
  }
}
