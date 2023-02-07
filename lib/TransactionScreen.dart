// ignore_for_file: non_constant_identifier_names, deprecated_member_use, must_be_immutable, missing_return, unrelated_type_equality_checks, unnecessary_statements

import 'dart:convert';
import 'dart:io';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/MyScreenListModel.dart';
import 'package:bestmummybackery/Model/MyTranctionGetLineModel.dart';
//import 'package:bestmummybackery/Model/ScreenModel.dart';
import 'package:bestmummybackery/Model/TransactionModel.dart';
import 'package:bestmummybackery/screens/Dashboard.dart';
//import 'package:bestmummybackery/screens/EditSalesOrder.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:bestmummybackery/screens/_SalesInvoiceOnline.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key key, this.ScreenId, this.ScreenName})
      : super(key: key);
  int ScreenId = 0;
  var ScreenName = '';
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
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
    setState(() {
      getStringValuesSF();
    super.initState();
    });
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
                    child: Text('Transaction Screen'),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (SelectScreenId == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SalesOrder(
                                  ScreenID: 1,
                                  ScreenName: "SalesOrder",
                                  OrderNo: 0),
                            ),
                          );
                        }
                        if (SelectScreenId == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SalesInvoiceOnline(
                                      ScreenID: 2,
                                      ScreenName: "Sales Invoices",
                                      OrderNo: 0,
                                      isIgnore: true),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: !loading
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Container(
                                width: width / 2,
                                height: 80,
                                child:  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Card(
                                    child:  ListTile(
                                      leading:  Icon(Icons.search),
                                      title:  TextField(
                                        controller: editingController,
                                        decoration: new InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none),
                                        onChanged: (val) {
                                          setState(() {
                                            search = val;
                                          });
                                          print(val);
                                        },
                                      ),
                                      trailing:  IconButton(
                                        icon:  Icon(Icons.cancel),
                                        onPressed: () {
                                          search = "";
                                          editingController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                width: width / 2,
                                child: DropdownSearch<String>(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  label: "Select Screen",
                                  items: SecScreenListModel,
                                  onChanged: (val) {
                                    print(val);
                                    for (int kk = 0; kk < RawMyScreenListModel.testdata.length; kk++) {
                                      if (RawMyScreenListModel.testdata[kk].screenName == val) {
                                        SelectScreenName = RawMyScreenListModel.testdata[kk].screenName;
                                        SelectScreenId = RawMyScreenListModel.testdata[kk].screenId.toString();
                                        setState(() {
                                          print(SelectScreenId);
                                          GetMyTablRecord();
                                        });
                                      }
                                    }
                                  },
                                  selectedItem: SelectScreenName,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: width,
                            height: height / 1.5,
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
                                            'ScreenName',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
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
                                            'Balance',
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
                                          // .where((element) => (element
                                          //         .screenName
                                          //         .toLowerCase()
                                          //         .contains(
                                          //             search.toLowerCase()) ||
                                          //     element.orderNo
                                          //         .toString()
                                          //         .toLowerCase()
                                          //         .contains(
                                          //             search.toLowerCase())))
                                          .map(
                                            (list) => DataRow(cells: [
                                              DataCell(
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.open_in_new,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      list.screenName
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  //print(list.screenID.toString() +"-" + list.orderNo.toString() + '-' + list.screenName.toString());
                                                  // 1	Sales Order,2	Sales Invoice,3	Sales Return,4	Sales Incentive
                                                  // 5	KOT,6	Wastage Entry,7	Wastage Transfer,8	Closing Entry
                                                  // 9	Stock Request,10	Stock Transfer,11	Stock Receive,12	Stock IPO
                                                  // 13	Book Expense,14	Despatch,15	Purchase Request,16	Goods Receipt PO
                                                  // 17	QR Code Generator,18	Production Entry

                                                  if (list.screenID == 1) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            SalesOrder(
                                                                ScreenID: list
                                                                    .screenID,
                                                                ScreenName: list
                                                                    .screenName,
                                                                OrderNo: list
                                                                    .orderNo),
                                                      ),
                                                    );
                                                  }
                                                  if (list.screenID == 2) {
                                                    var bool = false;

                                                    if (list.status == 'C') {
                                                      setState(() {
                                                        bool = true;
                                                      });
                                                    }

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            SalesInvoiceOnline(
                                                                ScreenID: list.screenID,
                                                                ScreenName: list.screenName,
                                                                OrderNo: list.orderNo,
                                                                isIgnore: true
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              DataCell(
                                                Text(list.orderNo.toString(),
                                                    textAlign: TextAlign.left),
                                              ),
                                              DataCell(
                                                Text(list.orderDate.toString(),
                                                    textAlign: TextAlign.left),
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
                                                Text(list.status.toString(),
                                                    textAlign: TextAlign.left),
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
        : Container(
          child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(height/9),
                child: AppBar(
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
                    child: Text('Transaction Screen'),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (SelectScreenId == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SalesOrder(
                                  ScreenID: 1,
                                  ScreenName: "SalesOrder",
                                  OrderNo: 0),
                            ),
                          );
                        }
                        if (SelectScreenId == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SalesInvoiceOnline(
                                      ScreenID: 2,
                                      ScreenName: "Sales Invoices",
                                      OrderNo: 0,
                                      isIgnore: true
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              body: !loading
                  ? Column(
                    children: [
                      Row(
                        children: [
                          new Container(
                            width: width / 2,
                            child: new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Card(
                                child: new ListTile(
                                  leading: new Icon(Icons.search),
                                  title: new TextField(
                                    controller: editingController,
                                    decoration: new InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none),
                                    onChanged: (val) {
                                      setState(() {
                                        search = val;
                                      });
                                      print(val);
                                    },
                                  ),
                                  trailing: new IconButton(
                                    icon: new Icon(Icons.cancel),
                                    onPressed: () {
                                      search = "";
                                      editingController.clear();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: width / 2,
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              label: "Select Screen",
                              items: SecScreenListModel,
                              onChanged: (val) {
                                print(val);
                                for (int kk = 0; kk < RawMyScreenListModel.testdata.length; kk++) {
                                  if (RawMyScreenListModel.testdata[kk].screenName == val) {
                                    SelectScreenName = RawMyScreenListModel.testdata[kk].screenName;
                                    SelectScreenId = RawMyScreenListModel.testdata[kk].screenId.toString();
                                    setState(() {
                                      print(SelectScreenId);
                                      GetMyTablRecord();
                                    });
                                  }
                                }
                              },
                              selectedItem: SelectScreenName,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: width,
                        height: height / 1.5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: RawMyTranctionGetLineModel != null
                              ? DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                headingRowColor:
                                MaterialStateProperty.all(Pallete.mycolor),
                                showCheckboxColumn: false,
                                  columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                            'ScreenName',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
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
                                            'Balance',
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
                                  // .where((element) => (element
                                  //         .screenName
                                  //         .toLowerCase()
                                  //         .contains(
                                  //             search.toLowerCase()) ||
                                  //     element.orderNo
                                  //         .toString()
                                  //         .toLowerCase()
                                  //         .contains(
                                  //             search.toLowerCase())))
                                      .map((list) => DataRow(cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.open_in_new,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              list.screenName.toString(),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          //print(list.screenID.toString() +"-" + list.orderNo.toString() + '-' + list.screenName.toString());
                                          // 1	Sales Order,2	Sales Invoice,3	Sales Return,4	Sales Incentive
                                          // 5	KOT,6	Wastage Entry,7	Wastage Transfer,8	Closing Entry
                                          // 9	Stock Request,10	Stock Transfer,11	Stock Receive,12	Stock IPO
                                          // 13	Book Expense,14	Despatch,15	Purchase Request,16	Goods Receipt PO
                                          // 17	QR Code Generator,18	Production Entry

                                          if (list.screenID == 1) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                    SalesOrder(
                                                        ScreenID: list.screenID,
                                                        ScreenName: list.screenName,
                                                        OrderNo: list.orderNo),
                                              ),
                                            );
                                          }
                                          if (list.screenID == 2) {
                                            var bool = false;

                                            if (list.status == 'C') {
                                              setState(() {
                                                bool = true;
                                              });
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                context) =>
                                                    SalesInvoiceOnline(
                                                        ScreenID: list.screenID,
                                                        ScreenName: list.screenName,
                                                        OrderNo: list.orderNo,
                                                        isIgnore: true),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      DataCell(
                                        Text(list.orderNo.toString(),
                                            textAlign: TextAlign.left),
                                      ),
                                      DataCell(
                                        Text(list.orderDate.toString(),
                                            textAlign: TextAlign.left),
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
                                        Text(list.status.toString(),
                                            textAlign: TextAlign.left),
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

      if (widget.ScreenId == 0) {
        GetScreenList();
      } else {
        SelectScreenId = widget.ScreenId;
        SelectScreenName = widget.ScreenName;
        GetScreenList();
        GetMyTablRecord();
      }
    });
  }

  Future<http.Response> GetScreenList() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;

      //SecMyPricelistMasterSubTab2Model.clear();
    });
    var body = {
      "FromId": 1,
      "ScreenId": 0,
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
    //var nodata = jsonDecode(response.body)['status'] == 0;
    print(response.body);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          SecScreenListModel.clear();
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        setState(() {
          RawMyScreenListModel =
              MyScreenListModel.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawMyScreenListModel.testdata.length; i++)
            SecScreenListModel.add(RawMyScreenListModel.testdata[i].screenName);
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetMyTablRecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print("MyScreenId" + SelectScreenId.toString());
    });
    var body = {
      "FromId": 0,
      "ScreenId": SelectScreenId,
      "DocNo": int.parse(sessionbranchcode.toString()),
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
          RawMyTranctionGetLineModel = null;
        });
        print('NoResponse');
      } else {
        RawMyTranctionGetLineModel = null;
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

  Future<http.Response> getpendingtransaction() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "UserID": sessionuserID,
      "BranchID": sessionbranchcode,
      "ScreenID": 0,
    };
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'GetTransaction'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'GetTransaction');
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
          detailitems.result.clear();
        } else {
          detailitems = TransactionModel.fromJson(jsonDecode(response.body));

          print(detailitems);
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
