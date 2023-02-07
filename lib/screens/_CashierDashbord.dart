// ignore_for_file: deprecated_member_use, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/GetInvoiceModel.dart';
import 'package:bestmummybackery/Model/MyTranctionGetLineModel.dart';
import 'package:bestmummybackery/PostData.dart';
import 'package:bestmummybackery/screens/KOTScreenOffline.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:bestmummybackery/screens/_SalesInvoiceOnline.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class CashierDashbord extends StatefulWidget {
  const CashierDashbord({Key key}) : super(key: key);

  @override
  _CashierDashbordState createState() => _CashierDashbordState();
}

class _CashierDashbordState extends State<CashierDashbord> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;
  var sessionContact1 = "";
  var sessionContact2 = "";
  var sessionPrintStatus = '';
  bool loading = false;
  var sessionDayEndCheck='';

  List<GetSaleInvoice> secGetSaleInvoice=[];
  List<GetSaleInvoice> secGetKOTInvoice=[];
  List<GetSaleInvoice> secGetSOInvoice=[];
  List<TranctionGet> secTranctionGet=[];

  MyTranctionGetLineModel RawMyTranctionGetLineModel;
  GetInvoiceModel rawGetInvoiceModel;
  GetInvoiceModel rawGetKOTModel;
  GetInvoiceModel rawGetSOModel;


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getStringValuesSF();
    });
    super.initState();
    setState(() {});
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      sessionDayEndCheck = prefs.getString("DayEndClsg");
      getsaleinvoice();
      getKOTinvoice();
      getSaleOrderinvoice();

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
    return tablet ? Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Cashier Panel"),),
          body: !loading ?
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width/3.1,
                      height: height/20,
                      alignment: Alignment.center,
                      child: Text("Sales Invoice",style: TextStyle(fontSize: height/20,color: Colors.green.shade900),),
                    ),
                    Container(
                      width: width/3.1,
                      height: height/20,
                      alignment: Alignment.center,
                      child: Text("KOT Invoice",style: TextStyle(fontSize: height/20,color: Colors.pink.shade900),),
                    ),
                    Container(
                      width: width/3.1,
                      height: height/20,
                      alignment: Alignment.center,
                      child: Text("Sales Order",style: TextStyle(fontSize: height/20,color: Colors.purple.shade900),),
                    )
                  ],
                ),
                SizedBox(height: height/60,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width/3.1,
                      height: height/1.3,
                      color: Colors.greenAccent,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: secGetSaleInvoice.length == 0 ?
                        Center(
                          child: Text('No Data Add!'),
                        ) :
                        DataTable(
                          sortColumnIndex: 0,
                          sortAscending: true,
                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                          showCheckboxColumn: false,
                          headingRowHeight: !tablet? height/20: height/20,
                          dataRowHeight: !tablet? height/20:height/20,
                          columnSpacing: width/20,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('BillNo',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Total Amt',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Status',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                          rows: secGetSaleInvoice.map((list) =>
                              DataRow(cells: [
                                DataCell(
                                  Text(list.OrderNo.toString(),style: TextStyle(fontSize: !tablet? height/55:height/40),textAlign: TextAlign.center),
                                ),
                                DataCell(
                                  Text("Rs."+list.TotAmount.toString(),style: TextStyle(fontSize: !tablet? height/55:height/40),textAlign: TextAlign.center),
                                ),
                                DataCell(
                                  IconButton(
                                      icon: Icon(Icons.payment,size: !tablet? height/40:height/30,),
                                      color: Colors.red,
                                      onPressed: () {
                                        print("Pressed");
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context, MaterialPageRoute(builder: (context) =>
                                            SalesInvoiceOnline(
                                              ScreenID: 2,
                                              ScreenName:"Sales Invoices",
                                              OrderNo: int.parse(list.OrderNo.toString()),
                                              isIgnore: false,
                                              NetWorkCheckNumter: 1,
                                            ),
                                        ),
                                        );
                                      },
                                    ),
                                ),
                              ]),
                          )
                              .toList(),
                        ),
                      ),

                    ),
                    Container(
                      width: width/3.1,
                      height: height/1.3,
                      color: Colors.lightGreenAccent,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: secGetKOTInvoice.length == 0 ?
                        Center(
                          child: Text('No Data Add!'),
                        ) :
                        DataTable(
                          sortColumnIndex: 0,
                          sortAscending: true,
                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                          showCheckboxColumn: false,
                          headingRowHeight: !tablet? height/20: height/20,
                          dataRowHeight: !tablet? height/20:height/20,
                          columnSpacing: width/20,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('BillNo',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Total Amt',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Status',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                          rows: secGetKOTInvoice.map((list) =>
                              DataRow(cells: [
                                DataCell(
                                  Text(list.OrderNo.toString(),style: TextStyle(fontSize: !tablet? height/55:height/40),textAlign: TextAlign.center),
                                ),
                                DataCell(
                                  Text("Rs."+list.TotAmount.toString(),style: TextStyle(fontSize: !tablet? height/55:height/40),textAlign: TextAlign.center),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.payment,size: !tablet? height/40:height/30,),
                                    color: Colors.red,
                                    onPressed: () {
                                      print("Pressed");
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KOTScreenOffline(
                                            CreationName: "${list.creationName}",
                                            TableNo: list.tableNo,
                                            SeatNo: "${list.seatNo.toString()}",
                                            NetWorkCheckNumter: 1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]),
                          )
                              .toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: width/3.1,
                      height: height/1.3,
                      color: Colors.orangeAccent,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: secTranctionGet.length == 0 ?
                        Center(
                          child: Text('No Data Add!'),
                        ) :
                        DataTable(
                          sortColumnIndex: 0,
                          sortAscending: true,
                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                          showCheckboxColumn: false,
                          headingRowHeight: !tablet? height/20: height/20,
                          dataRowHeight: !tablet? height/20:height/20,
                          columnSpacing: width/20,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('BillNo',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Total Amt',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Status',style: TextStyle(color: Colors.white),),
                            ),
                          ],
                          rows: secTranctionGet.map((list) =>
                              DataRow(cells: [
                                DataCell(
                                  Text(list.orderNo.toString(),style: TextStyle(fontSize: !tablet? height/55:height/40),textAlign: TextAlign.center),
                                ),
                                DataCell(
                                  Text("Rs."+list.totAmount.toString(),style: TextStyle(fontSize: !tablet? height/55:height/40),textAlign: TextAlign.center),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.payment,size: !tablet? height/40:height/30,),
                                    color: Colors.red,
                                    onPressed: () {
                                      print("Pressed");
                                      Navigator.pop(context);
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
                                ),
                              ]),
                          )
                              .toList(),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ) :
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                  onPressed: () {
                    getsaleinvoice();
                    getKOTinvoice();
                    getSaleOrderinvoice();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    )
        : Container();
  }


  Future<http.Response> getsaleinvoice() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      secGetSaleInvoice.clear();
    });

    var body ={
      "FormId":1,
      "Docdate":"0",
      "BranchId":sessionbranchcode.toString(),
      "Status":"PM",
      "UserId":sessionuserID.toString()
    };

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'cashierdashboard'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
      log(response.body);
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          rawGetInvoiceModel=null;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        setState(() {
          rawGetInvoiceModel = GetInvoiceModel.fromJson(jsonDecode(response.body));
          for(int i = 0;i<rawGetInvoiceModel.testdata.length;i++){
            secGetSaleInvoice.add(
                GetSaleInvoice(
                    rawGetInvoiceModel.testdata[i].orderNo.toString(),
                    rawGetInvoiceModel.testdata[i].customerNo.toString(),
                    rawGetInvoiceModel.testdata[i].totAmount.toString(),
                    rawGetInvoiceModel.testdata[i].orderStatus.toString(),"","","",""));
          }
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getKOTinvoice() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      secGetKOTInvoice.clear();
    });

    var body ={
      "FormId":2,
      "Docdate":"0",
      "BranchId":sessionbranchcode.toString(),
      "Status":"D",
      "UserId":sessionuserID.toString()
    };

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'cashierdashboard'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
      log(response.body);
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          rawGetKOTModel=null;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        setState(() {
          rawGetKOTModel = GetInvoiceModel.fromJson(jsonDecode(response.body));
          for(int i = 0;i<rawGetKOTModel.testdata.length;i++){
            secGetKOTInvoice.add(
                GetSaleInvoice(
                    rawGetKOTModel.testdata[i].orderNo.toString(),
                    rawGetKOTModel.testdata[i].customerNo.toString(),
                    rawGetKOTModel.testdata[i].totAmount.toString(),
                    rawGetKOTModel.testdata[i].orderStatus.toString(),
                    rawGetKOTModel.testdata[i].creationName.toString(),
                    rawGetKOTModel.testdata[i].tableNo.toString(),
                    rawGetKOTModel.testdata[i].branchID.toString(),
                    rawGetKOTModel.testdata[i].seatNo.toString(),
                ),);
          }
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<http.Response> getSaleOrderinvoice() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      secGetSOInvoice.clear();
    });

    var body ={
      "FormId":3,
      "Docdate":"0",
      "BranchId":sessionbranchcode.toString(),
      "Status":"C",
      "UserId":sessionuserID.toString()
    };

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'cashierdashboard'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
      log(response.body);
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        setState(() {
          RawMyTranctionGetLineModel = MyTranctionGetLineModel.fromJson(jsonDecode(response.body));
          for(int i=0;i<RawMyTranctionGetLineModel.testdata.length;i++) {
            secTranctionGet.add(TranctionGet(
                RawMyTranctionGetLineModel.testdata[i].orderNo,
                RawMyTranctionGetLineModel.testdata[i].orderDate,
                RawMyTranctionGetLineModel.testdata[i].totQty,
                RawMyTranctionGetLineModel.testdata[i].totAmount,
                RawMyTranctionGetLineModel.testdata[i].balanceDue,
                RawMyTranctionGetLineModel.testdata[i].status,
                RawMyTranctionGetLineModel.testdata[i].screenName,
                RawMyTranctionGetLineModel.testdata[i].CustomerNo),
            );
          }

          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }


}



class GetSaleInvoice {
  var OrderNo;
  var CustomerNo;
  var TotAmount;
  var OrderStatus;
  var creationName;
  var tableNo;
  var branchID;
  var seatNo;
  GetSaleInvoice(this.OrderNo,this.CustomerNo,this.TotAmount,this.OrderStatus,this.creationName,this.tableNo,this.branchID,this.seatNo);
}



class TranctionGet {
  var orderNo;
  String orderDate;
  var totQty;
  var totAmount;
  var balanceDue;
  String status;
  var screenID;
  var screenName;
  var CustomerNo;

  TranctionGet(
      this.orderNo,
        this.orderDate,
        this.totQty,
        this.totAmount,
        this.balanceDue,
        this.status,
        this.screenName,this.CustomerNo);
}


