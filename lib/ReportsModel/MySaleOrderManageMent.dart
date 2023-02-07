// ignore_for_file: deprecated_member_use, must_be_immutable, non_constant_identifier_names, missing_return

import 'dart:convert';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/MyScreenListModel.dart';
import 'package:bestmummybackery/Model/MyTranctionGetLineModel.dart';
import 'package:bestmummybackery/Model/TransactionModel.dart';
import 'package:bestmummybackery/screens/Dashboard.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MySaleOrderManageMent extends StatefulWidget {
  MySaleOrderManageMent({Key key, this.ScreenId, this.ScreenName})
      : super(key: key);
  int ScreenId = 0;
  var ScreenName = '';
  @override
  _MySaleOrderManageMentState createState() => _MySaleOrderManageMentState();
}

class _MySaleOrderManageMentState extends State<MySaleOrderManageMent> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  bool loading = false;
  String search = "";

  var SelectScreenId;
  var SelectScreenName;
  MyScreenListModel RawMyScreenListModel;
  List<String> SecScreenListModel = new List();
  MyTranctionGetLineModel RawMyTranctionGetLineModel;

  TransactionModel detailitems;
  TextEditingController editingController = new TextEditingController();

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
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
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Dashboard(),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  title: InkWell(
                    onTap: () {
                      print(SelectScreenId);
                    },
                    child: Text(widget.ScreenName),
                  ),
                  actions: [],
                ),
                body: !loading
                    ? Column(
                        children: [
                          Container(
                            width: width,
                            height: height / 1.2,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: RawMyTranctionGetLineModel != null
                                  ? DataTable(
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      headingRowColor: MaterialStateProperty.all(Pallete.mycolor),
                                      showCheckboxColumn: false,
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                            'Order No',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Order Date',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Delivery Date',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'TotQty',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Total Amount',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Advanced',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: RawMyTranctionGetLineModel.testdata
                                          .map(
                                            (list) => DataRow(cells: [
                                              DataCell(
                                                Text(list.orderNo.toString(),
                                                    textAlign: TextAlign.left),
                                                onTap: () {
                                                  print(list.orderNo);
                                                  print(list.balanceDue);
                                                  Navigator.push(context, MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          SalesOrder(
                                                              ScreenID: list.balanceDue,
                                                              ScreenName: "SaleOrder",
                                                              OrderNo: list.orderNo,
                                                              OrderDate: list.orderDate,
                                                              DeliveryDate: list.screenName),
                                                    ),
                                                  );
                                                },
                                              ),
                                              DataCell(
                                                Text(list.orderDate.toString(),
                                                    textAlign: TextAlign.left),
                                              ),
                                              DataCell(
                                                Text(
                                                  list.screenName.toString(),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              DataCell(
                                                Text(list.totQty.toString(),
                                                    textAlign: TextAlign.left),
                                              ),
                                              DataCell(
                                                Text(list.totAmount.toString(),
                                                    textAlign: TextAlign.left),
                                              ),
                                              DataCell(
                                                Text(list.balanceDue.toString(),
                                                    textAlign: TextAlign.left),
                                              ),
                                              DataCell(
                                                // Text(list.status.toString(),
                                                //     textAlign: TextAlign.left),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if(list.status == 'C'){
                                                      return showDialog(
                                                        context: context, builder: (ctx) =>
                                                          AlertDialog(
                                                            title: Text("Do You Want Processing "),
                                                            content: Text("The Sale Order - " + list.orderNo.toString(),),
                                                              actions: <Widget>[
                                                                  ElevatedButton(
                                                                   style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                                   onPressed: () {
                                                                    UpdateStatusMyTablRecord(list.orderNo, 'P');
                                                                    Navigator.of(ctx).pop();
                                                                   },
                                                                    child: Text("Process"),
                                                                ),
                                                                  ElevatedButton(
                                                                   style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                                   onPressed: () {
                                                                    Navigator.of(ctx).pop();
                                                                   },
                                                                   child: Text("Cancel"),
                                                                ),
                                                              ],
                                                      ),
                                                    );
                                                    }else{
                                                      Fluttertoast.showToast(msg: 'This Orders Already Processed...');
                                                    }
                                                  },
                                                  child: Text(
                                                      list.status == 'C'
                                                      ?'Pending':
                                                      list.status == 'Pr'?"Production":
                                                      list.status == 'Ds'?"Despatched":
                                                      list.status == 'Re'?'Recived':
                                                      list.status == 'CO'?'Closed'
                                                      : 'Processing'),
                                                  style: ElevatedButton.styleFrom(
                                                      primary: list.status == 'C' ? Colors.grey:
                                                      list.status == 'P'? Colors.pinkAccent:
                                                      list.status == 'Pr'? Colors.orangeAccent:
                                                      list.status == 'Ds'? Colors.lightBlueAccent : Colors.green),
                                                ),
                                              ),
                                            ]),
                                          )
                                          .toList(),
                                    )
                                  : Container(
                                      child: Text('No Data!'),
                                    ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          )
        : Container();
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      GetMyTablRecord();
    });
  }

  Future<http.Response> GetMyTablRecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print("MyScreenId" + SelectScreenId.toString());
    });
    var body = {
      "FromId": 8,
      "ScreenId": int.parse(sessionuserID),
      "DocNo": 1,
      "DocEntry": 10,
      "Status": "10",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          RawMyTranctionGetLineModel == null;
        });
        print('NoResponse');
      } else {
        RawMyTranctionGetLineModel == null;
        print('YesResponce');
        print(response.body);
        setState(() {
          RawMyTranctionGetLineModel = MyTranctionGetLineModel.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawMyTranctionGetLineModel.testdata.length; i++)
            print(RawMyTranctionGetLineModel.testdata[i].screenName);
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> UpdateStatusMyTablRecord(orderNo, orderStatus) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print(int.parse(sessionuserID));
      print(orderNo);
    });
    var body = {
      "FromId": 9,
      "ScreenId": int.parse(sessionuserID),
      "DocNo": orderNo,
      "DocEntry": 10,
      "Status": orderStatus,
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          GetMyTablRecord();
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        setState(() {
          loading = false;
          GetMyTablRecord();
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }
}
