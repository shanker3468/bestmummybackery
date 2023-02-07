// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_brace_in_string_interps, missing_return

import 'dart:convert';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/ShiftMasterHomePage.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ShiftMaster extends StatefulWidget {
  const ShiftMaster({Key key}) : super(key: key);

  @override
  _ShiftMasterState createState() => _ShiftMasterState();
}

class _ShiftMasterState extends State<ShiftMaster> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var alteritemcode = "";
  var alteritemName = "";
  var alteritemuom = "";
  var alteritemqty = "";
  var alterstock = "";
  int InsertFormId = 0;
  int HeaderDocNo = 0;
  int GetDocNUm = 0;
  bool loading = false;
  bool UpdateMode = false;
  int SecreeId = 0;
  var TotalValue = 0.0;
  final formKey = new GlobalKey<FormState>();
  List<DenominationList> SecDenomination = new List();
  //String kljl = [];
  var EditAmt = 0.0;
  var _OpeningAmt = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    setState(() {
      SecDenomination.addAll(
        [
          DenominationList(2000, "X", 0.0, 0.0),
          DenominationList(500, "X", 0.0, 0.0),
          DenominationList(200, "X ", 0.0, 0.0),
          DenominationList(100, "X", 0.0, 0.0),
          DenominationList(50, "X", 0.0, 0.0),
          DenominationList(20, "X", 0.0, 0.0),
          DenominationList(10, "X", 0.0, 0.0),
          DenominationList(5, "X", 0.0, 0.0),
          DenominationList(1, "COINS", 0.0, 0.0)
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return tablet
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Shift Opening"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 2.1,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: height / 8,
                                          width: width / 2.2,
                                          child: TextField(
                                            controller: _OpeningAmt,
                                            enabled: true,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                //fontSize: 12,
                                                ),
                                            decoration: InputDecoration(
                                                hintText: 'Opening Amount',
                                                labelText: 'Opening Amount',
                                                labelStyle: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width / 2.1,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: height / 10,
                                          width: width / 2.2,
                                        ),
                                      ],
                                    ),
                                  ), //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecDenomination.toString() == "null"
                                          ? Center(child: Text('Add ItemCode Line Table'),)
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text('Denomination',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Cal',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Edit',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Total',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: SecDenomination.map(
                                                (list) => DataRow(cells: [
                                                  DataCell(
                                                    Text(
                                                        list.Denomin.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(list.Name.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(list.Amt.toString(),
                                                        textAlign:TextAlign.left),
                                                    showEditIcon: true,
                                                    onTap: () {
                                                      showDialog(context: context,builder: (BuildContext contex) =>
                                                            AlertDialog(
                                                              content:
                                                              TextFormField(
                                                              keyboardType:TextInputType.number,
                                                                onChanged: (vvv) {
                                                                EditAmt = double.parse(vvv);
                                                                print(EditAmt);
                                                                },),
                                                              title: Text("Enter Your Amt"),
                                                              actions: <Widget>[
                                                              Column(
                                                               children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          TextButton(
                                                                            onPressed:() {
                                                                            var totalCal = 0.0;
                                                                            setState(() {
                                                                            list.Amt =EditAmt;
                                                                            list.Total =list.Denomin * list.Amt;
                                                                            for (int i = 0;i < SecDenomination.length;i++) {
                                                                              totalCal += SecDenomination[i].Total;
                                                                            }

                                                                                TotalValue = totalCal;
                                                                                });
                                                                                Navigator.pop(context,'Ok',);
                                                                            },
                                                                              child: const Text("Ok"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          TextButton(
                                                                            onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'Cancel'),
                                                                                child: const Text('Cancel'),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  DataCell(
                                                    Text(list.Total.toString(),
                                                        textAlign:
                                                            TextAlign.left),
                                                  ),
                                                ]),
                                              ).toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: Colors.orangeAccent,
                        icon: Icon(Icons.attach_money_outlined,
                            color: Colors.black45),
                        label: Text(
                          TotalValue.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.red,
                        icon: Icon(Icons.clear),
                        label: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.blue.shade700,
                        icon: Icon(Icons.check),
                        label: Text('Save'),
                        onPressed: () {
                          print(_OpeningAmt.text);
                          InsertFormId = 1;
                          print(TotalValue);
                          if (double.parse(_OpeningAmt.text) == TotalValue) {
                             postdataheader(1, "O", 1);
                            //InsertOffline();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Not Value Match",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
                child: SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text("Shift Opening"),
                    ),
                    body: !loading
                        ? SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width / 2.1,
                                          margin: EdgeInsets.only(left: 0),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: height / 8,
                                                width: width / 2.2,
                                                child: TextField(
                                                  controller: _OpeningAmt,
                                                  enabled: true,
                                                  keyboardType: TextInputType.number,
                                                  style: TextStyle(
                                                    //fontSize: 12,
                                                  ),
                                                  decoration: InputDecoration(
                                                      hintText: 'Opening Amount',
                                                      labelText: 'Opening Amount',
                                                      contentPadding: EdgeInsets.only(
                                                          top: 3, bottom: 2, left: 10, right: 10),
                                                      labelStyle: TextStyle(
                                                          color:
                                                          Colors.grey.shade600),
                                                      border: OutlineInputBorder()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: width / 2.1,
                                          margin: EdgeInsets.only(left: 0),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: height / 10,
                                                width: width / 2.2,
                                              ),
                                            ],
                                          ),
                                        ), //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SecDenomination.toString() == "null"
                                                ? Center(child: Text('Add ItemCode Line Table'),)
                                                : DataTable(
                                                  sortColumnIndex: 0,
                                                  sortAscending: true,
                                                  headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                  dataRowHeight: 17,
                                                  headingRowHeight: 17,
                                                  showCheckboxColumn: false,
                                                    columns: const <DataColumn>[
                                                      DataColumn(
                                                        label: Text('Denomination',style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text('Cal',style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text('Edit',style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text('Total',style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  rows: SecDenomination.map(
                                                    (list) => DataRow(cells: [
                                                  DataCell(
                                                    Text(
                                                        list.Denomin.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(list.Name.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(list.Amt.toString(),
                                                        textAlign:TextAlign.left),
                                                    showEditIcon: true,
                                                    onTap: () {
                                                      showDialog(context: context,builder: (BuildContext contex) =>
                                                          AlertDialog(
                                                            content:
                                                            TextFormField(
                                                              keyboardType:TextInputType.number,
                                                              onChanged: (vvv) {
                                                                EditAmt = double.parse(vvv);
                                                                print(EditAmt);
                                                              },),
                                                            title: Text("Enter Your Amt"),
                                                            actions: <Widget>[
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                        TextButton(
                                                                          onPressed:() {
                                                                            var totalCal = 0.0;
                                                                            setState(() {
                                                                              list.Amt =EditAmt;
                                                                              list.Total =list.Denomin * list.Amt;
                                                                              for (int i = 0;i < SecDenomination.length;i++) {
                                                                                totalCal += SecDenomination[i].Total;
                                                                              }

                                                                              TotalValue = totalCal;
                                                                            });
                                                                            Navigator.pop(context,'Ok',);
                                                                          },
                                                                          child: const Text("Ok"),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Cancel'),
                                                                          child: const Text('Cancel'),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                      );
                                                    },
                                                  ),
                                                  DataCell(
                                                    Text(list.Total.toString(),
                                                        textAlign:
                                                        TextAlign.left),
                                                  ),
                                                ]),
                                              ).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    )
                        : Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    persistentFooterButtons: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            backgroundColor: Colors.orangeAccent,
                            icon: Icon(Icons.attach_money_outlined,
                                color: Colors.black45),
                            label: Text(
                              TotalValue.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.red,
                            icon: Icon(Icons.clear),
                            label: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.blue.shade700,
                            icon: Icon(Icons.check),
                            label: Text('Save'),
                            onPressed: () {
                              print(_OpeningAmt.text);
                              InsertFormId = 1;
                              print(TotalValue);
                              if (double.parse(_OpeningAmt.text) == TotalValue) {
                                postdataheader(1, "O", 1);
                                //InsertOffline();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Not Value Match",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
      getPendingListChecking();
    });
  }

  Future<http.Response> postdataheader(docNo, status, Screenid) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID' + InsertFormId.toString());
    });
    var body = {
      "FormID": InsertFormId,
      "DocNo": docNo,
      "ScreenId": Screenid,
      "OpeningAmt": _OpeningAmt.text,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": 1000,
      "UserID": sessionuserID,
      "Status": "O"
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
      //print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        if (InsertFormId == 1) {
          if (decode["testdata"].toString() == '[]') {
            setState(() {
              loading = false;
            });
            print('NoResponse');
          } else {
            print(response.body);
            setState(() {
              print('Hai');
              loading = false;
            });
            decode["testdata"][0]["STATUSNAME"].toString();
            HeaderDocNo = decode["testdata"][0]["DocNo"];
            Fluttertoast.showToast(
              msg: decode["testdata"][0]["STATUSNAME"].toString(),
            );
            for (int i = 0; i < SecDenomination.length; i++) {
              LineTblDataInsert(i).then((value) => {
                          InsertOffline(HeaderDocNo),
                  });
            }
          }
        } else {
          setState(() {
            loading = false;
          });
        }
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> LineTblDataInsert(index) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID' + InsertFormId.toString());
    });
    var body = {
      "FormID": 1,
      "DocNo": HeaderDocNo,
      "ScreenId": 1,
      "Amt": SecDenomination[index].Denomin,
      "Count": SecDenomination[index].Amt,
      "LineTotal": SecDenomination[index].Total
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_OEPN_Line_SP'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      //print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        if (InsertFormId == 1) {
          if (decode["testdata"].toString() == '[]') {
            setState(() {
              loading = false;
            });
            print('NoResponse');
          } else {
            print(response.body);
            setState(() {
              print('Hai');
              loading = false;
            });
            //decode["testdata"][0]["STATUSNAME"].toString();
            //HeaderDocNo = decode["testdata"][0]["DocNo"];
          }
        } else {
          setState(() {
            loading = false;
          });
        }
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getPendingListChecking() async {
    print('getPendingListChecking');
    var headers = {"Content-Type": "application/json"};
    print('1');
    setState(() {
      loading = true;
      print('2');
    });
    var body = {
      "FormID": 2,
      "DocNo": 1,
      "ScreenId": 1,
      "OpeningAmt": 0.0,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": 1000,
      "UserID": sessionuserID,
      "Status": "O"
    };
    //print(sessionuserID);
    print('2');

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_OEPN_SP'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    //print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
      } else {
        loading = true;
        showDialogboxWarning(this.context, "Close The Previous Shift");
        Fluttertoast.showToast(
            msg: "Close Previous Shift",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }


// Going To Ofline

  Future<http.Response> InsertOffline(int headerDocNo) async {
    print("headerDocNo-"+headerDocNo.toString());
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
         await txn.rawDelete("DELETE  FROM IN_MOB_SHIFT_OPEN");
         await txn.rawDelete("DELETE  FROM IN_MOB_SHIFT_OPEN_LIN");

        await txn.rawInsert(
            "INSERT INTO IN_MOB_SHIFT_OPEN ([DocNo],[OpeningAmt],[DocDate],[CounterId],[DeviceId],[UserId],[Status] )VALUES(${headerDocNo},'${_OpeningAmt.text}',DATE(),'${sessionbranchcode}','1000','${sessionuserID}','O')");

        for (int i = 0; i < SecDenomination.length; i++) {
          print("Count -->"+SecDenomination[i].Amt.toString());
          print("Total -->"+SecDenomination[i].Total.toString());
          var priint = await txn.rawInsert(
              "INSERT INTO IN_MOB_SHIFT_OPEN_LIN ([DocNo],[Amt],[Count],[LineTotal]) VALUES ("
                  "${headerDocNo},"
                  "'${SecDenomination[i].Denomin}',"
                  "'${SecDenomination[i].Amt}','${SecDenomination[i].Total}')");
          print(priint);
        }


        // _OpeningAmt.text = '';
        setState(() {

          Navigator.pop(this.context);

          Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) =>ShiftHomeMaster()));

          // SecDenomination.clear();
          // SecDenomination.addAll(
          //   [
          //     DenominationList(2000, "X", 0.0, 0.0),
          //     DenominationList(500, "X", 0.0, 0.0),
          //     DenominationList(200, "X ", 0.0, 0.0),
          //     DenominationList(100, "X", 0.0, 0.0),
          //     DenominationList(50, "X", 0.0, 0.0),
          //     DenominationList(20, "X", 0.0, 0.0),
          //     DenominationList(10, "X", 0.0, 0.0),
          //     DenominationList(5, "X", 0.0, 0.0),
          //     DenominationList(1, "COINS", 0.0, 0.0)
          //   ],
          // );
          // Fluttertoast.showToast(
          //   msg: "Saved Data Success Fully......",
          // );
          loading = false;
        });
      });
    } catch (Excetion) {
      print(Excetion);
    }
  }

}

class DenominationList {
  var Denomin;
  String Name;
  var Amt;
  var Total;
  DenominationList(this.Denomin, this.Name, this.Amt, this.Total);
}
