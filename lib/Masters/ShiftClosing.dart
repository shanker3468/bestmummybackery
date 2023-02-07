// ignore_for_file: non_constant_identifier_names, deprecated_member_use, missing_return

import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/Masters/ShiftMasterHomePage.dart';
import 'package:bestmummybackery/Model/getSalesClosingAmt.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class ShiftClosingMaster extends StatefulWidget {
  const ShiftClosingMaster({Key key}) : super(key: key);

  @override
  _ShiftClosingMasterState createState() => _ShiftClosingMasterState();
}

class _ShiftClosingMasterState extends State<ShiftClosingMaster> {
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
  var _SystemSaleamount = new TextEditingController();
  var _Salesamount = new TextEditingController();
  var _Difference = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  List<DenominationList> SecDenomination = new List();
  //String kljl = [];
  var EditAmt = 0.0;
  var Layout = false;
  var _OpeningAmt = new TextEditingController(text: "0");
  var _OpeningTime = new TextEditingController(text: "");
  var _SalesamountOne = new TextEditingController(text: "0");
  var _SaleInvAmt = new TextEditingController(text: "0");
  var _SaleOrderAmt = new TextEditingController(text: "0");
  var _PettyCashAmt = new TextEditingController(text: "0");

  //
  var _ClosingAmt = new TextEditingController(text: "0");
  var _DiffrenceAmt = new TextEditingController(text: "0");
  var _ClosingDate = new TextEditingController(text: "0");
  var UpdateDocNo = 0;
  //
  GetSalesClosingAmt RawGetSalesClosingAmt;
  GetSalesClosingAmt RawGetSalesOrderClosingAmt;

  //
  NetworkPrinter printer;
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;

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
            decoration:BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xff3A9BDC),
                          Color(0xff3A9BDC)
                        ]
                    )
            ),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(title: Text("Shift Closing"),),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 8.1,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: height / 8,
                                      width: width / 8.2,
                                      child: TextField(
                                        controller: _OpeningAmt,
                                        enabled: false,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            //fontSize: 12,
                                            ),
                                        decoration: InputDecoration(
                                            hintText: 'Opening Amount',
                                            labelText: 'Opening Amount',
                                            labelStyle: TextStyle(
                                                color:Colors.grey.shade600),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 8.1,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: height / 8,
                                      width: width / 8.2,
                                      child: TextField(
                                        controller: _OpeningTime,
                                        enabled: false,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          //fontSize: 12,
                                        ),
                                        decoration: InputDecoration(
                                            hintText: 'Opening Time',
                                            labelText: 'Opening Time',
                                            labelStyle: TextStyle(
                                                color:Colors.grey.shade600),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 6.1,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: height / 8,
                                      width: width / 6.2,
                                      child: TextField(
                                        controller: _PettyCashAmt,
                                        enabled: false,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          //fontSize: 12,
                                        ),
                                        decoration: InputDecoration(
                                            hintText: 'Opening Sales Amt',
                                            labelText: 'Opening Sales Amt',
                                            labelStyle: TextStyle(color:Colors.grey.shade600),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Container(
                                      width: width / 4.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 4.2,
                                        child: TextField(
                                          controller: _SalesamountOne,
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              //fontSize: 12,
                                              ),
                                          decoration: InputDecoration(
                                              hintText: 'Sale Amount',
                                              labelText: 'Sale Amount',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 4.1,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: height / 8,
                                      width: width / 4.2,
                                      child: TextField(
                                        controller: _ClosingDate,
                                        enabled: true,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            //fontSize: 12,
                                            ),
                                        decoration: InputDecoration(
                                            hintText: 'Colsing Amt',
                                            labelText: 'Colsing Amt',
                                            labelStyle: TextStyle(color: Colors.grey.shade600),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ), //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                ],
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: width / 3,
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SecDenomination.toString() =="null"
                                              ? Center(
                                                  child: Text('Add ItemCode Line Table'),
                                                )
                                              : DataTable(
                                                  sortColumnIndex: 0,
                                                  sortAscending: true,
                                                  headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                  showCheckboxColumn: false,
                                                  columns: const <DataColumn>[
                                                    DataColumn(
                                                      label: Text('Denomination',style: TextStyle(color:Colors.white),),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Cal',style: TextStyle(color:Colors.white),),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Edit',style: TextStyle(color:Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Total',style: TextStyle(color:Colors.white),),),
                                                    ],
                                                  rows: SecDenomination.map((list) => DataRow(cells: [
                                                      DataCell(
                                                        Text(list.Denomin.toString(),textAlign:TextAlign.left),
                                                      ),
                                                      DataCell(
                                                        Text(list.Name.toString(),textAlign:TextAlign.left),
                                                      ),
                                                      DataCell(
                                                        Text(list.Amt.toString(),textAlign:TextAlign.left),
                                                        showEditIcon: true,
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext contex) =>
                                                                AlertDialog(
                                                                  content:TextFormField(
                                                                    keyboardType:TextInputType.number,
                                                                      onChanged:(vvv) {
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
                                                                                    child:TextButton(
                                                                                          onPressed:() {
                                                                                            var totalCal = 0.0;
                                                                                            setState(() {
                                                                                            list.Amt = EditAmt;
                                                                                            list.Total = list.Denomin * list.Amt;
                                                                                            for (int i = 0; i < SecDenomination.length; i++) {
                                                                                            totalCal += SecDenomination[i].Total;
                                                                                            }

                                                                                            TotalValue = totalCal;
                                                                                            countclosingAmt();
                                                                                            });
                                                                                            Navigator.pop(context,'Ok',);
                                                                                          },
                                                                                            child:const Text("Ok"),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    child:TextButton(
                                                                                          onPressed: () =>
                                                                                            Navigator.pop(context, 'Cancel'),
                                                                                            child:const Text('Cancel'),
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
                                                        Text(list.Total.toString(),textAlign:TextAlign.left),
                                                      ),
                                                    ]),
                                                  ).toList(),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 1.7,
                                    height: height / 1.5,
                                    margin: EdgeInsets.only(left: width / 20),
                                    child: Visibility(
                                      visible: false,
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: height / 1.5,
                                            width: width / 3.5,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    height: height / 10,
                                                    width: width / 3.5,
                                                    child: TextField(
                                                      controller: _ClosingAmt,
                                                      enabled: false,
                                                      keyboardType:TextInputType.number,
                                                      style: TextStyle(
                                                          //fontSize: 12,
                                                          ),
                                                      decoration: InputDecoration(
                                                        hintText: 'Closing Amount',
                                                        labelText: 'Closing Amount',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade600),
                                                      ),
                                                    ),
                                                  ),
                                                  RawGetSalesClosingAmt == null
                                                      ? Center(child: Text('Add ItemCode Line Table'),)
                                                      : SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                        child: DataTable(
                                                            sortColumnIndex: 0,
                                                            sortAscending: true,
                                                            headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                            showCheckboxColumn: false,
                                                            columns: const <DataColumn>[
                                                              DataColumn(
                                                                label: Text('ScreenName',style: TextStyle(color: Colors.white),),
                                                              ),
                                                              DataColumn(
                                                                label: Text('Type',style: TextStyle(color: Colors.white),),
                                                              ),
                                                              DataColumn(
                                                                label: Text('RecvAmount',style: TextStyle(color: Colors.white),),
                                                              ),

                                                            ],
                                                            rows:RawGetSalesClosingAmt.testdata.map((list) => DataRow(
                                                                  color: list.status ==1
                                                                  ? MaterialStateProperty.all(Colors.orange)
                                                                  : MaterialStateProperty.all(Colors.white),
                                                              cells: [
                                                                DataCell(
                                                                  Text(list.screenName.toString(),textAlign:TextAlign.left),
                                                                ),
                                                                DataCell(
                                                                  Text(list.type.toString(),textAlign:TextAlign.left),
                                                                ),
                                                                DataCell(
                                                                  Text(list.recvAmount.toString(),textAlign:TextAlign.left),
                                                                ),

                                                              ]),
                                                        ).toList(),),
                                                      ),
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 10,
                                                          width: width / 3.5,
                                                          child: TextField(
                                                            controller: _SaleInvAmt,
                                                            enabled: false,
                                                            keyboardType:TextInputType.number,
                                                            style: TextStyle(
                                                                //fontSize: 12,
                                                                ),
                                                            decoration: InputDecoration(
                                                              hintText: 'Sale Inv Amount',
                                                              labelText:'Sale Inv Amount',
                                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: height / 1.5,
                                            width: width / 3.5,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                        Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: height / 8,
                                                            width: width / 3.5,
                                                            child: TextField(
                                                                  controller: _DiffrenceAmt,
                                                                  enabled: false,
                                                                  keyboardType:TextInputType.number,
                                                                  style: TextStyle(
                                                                      //fontSize: 12,
                                                                      ),
                                                                  decoration: InputDecoration(
                                                                    hintText:'Diffrence Amount',
                                                                    labelText:'Diffrence Amount',
                                                                    labelStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey.shade600),
                                                                  ),
                                                                ),
                                                            ),
                                                        RawGetSalesOrderClosingAmt == null
                                                        ? Center(
                                                          child: Text('Add ItemCode Line Table'),
                                                        )
                                                        : DataTable(
                                                          sortColumnIndex: 0,
                                                          sortAscending: true,
                                                          headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                          showCheckboxColumn: false,
                                                          columns: const <DataColumn>[
                                                            DataColumn(
                                                              label: Text('ScreenName',style: TextStyle(color: Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('Type',style: TextStyle(color: Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('RecvAmount',style: TextStyle(color: Colors.white),),
                                                            ),
                                                          ],
                                                          rows:RawGetSalesOrderClosingAmt.testdata.map((list) => DataRow(
                                                              color: list.status ==1
                                                              ? MaterialStateProperty.all(Colors.redAccent)
                                                              : MaterialStateProperty.all(Colors.white),
                                                              cells: [
                                                                DataCell(
                                                                  Text(list.screenName.toString(),textAlign:TextAlign.left),
                                                                ),
                                                                DataCell(
                                                                  Text(list.type.toString(),textAlign:TextAlign.left),
                                                                ),
                                                                DataCell(
                                                                  Text(list.recvAmount.toString(),textAlign:TextAlign.left),
                                                                ),
                                                              ]),
                                                           ).toList(),
                                                        ),
                                                        Container(
                                                            alignment: Alignment.centerLeft,
                                                            height: height / 8,
                                                            width: width / 3.5,
                                                            child: TextField(
                                                                controller: _SaleOrderAmt,
                                                                enabled: false,
                                                                keyboardType:TextInputType.number,
                                                                style: TextStyle(
                                                                    //fontSize: 12,
                                                                    ),
                                                                  decoration: InputDecoration(
                                                                    hintText:'Sale Order Amount',
                                                                    labelText:'Sale Order Amount',
                                                                    labelStyle: TextStyle(color: Colors.grey.shade600),
                                                                  ),
                                                               ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                        onPressed: () {
                          double sicash=0;
                          double sitotalcash=0;
                          double sicard = 0;
                          double siupi = 0;
                          double siothers=0;
                          double sireturnamt=0;
                          double socash=0;
                          double sototalcash=0;
                          double socard = 0;
                          double soupi = 0;
                          double soothers=0;
                          double soreturnamt=0;
                          double saleamt=0;
                          double kotamt=0;
                          double salereturnamt=0;
                          double kotretuenamt=0;
                          double totalcash=0;
                          double totalcard=0;
                          double upi=0;
                          double  totalothers =0;
                          // Sale Invoice card,cash,upi,others
                          for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
                            if (RawGetSalesClosingAmt.testdata[i].type == 'Cash') {
                              sicash += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].type == 'Card') {
                              sicard += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].type == 'UPI') {
                              siupi += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].type == 'Others') {
                              siothers += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].type == 'Return Amt') {
                              sireturnamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                          }
                      // cal sale invoice amt and Kot amt
                          for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
                            if (RawGetSalesClosingAmt.testdata[i].ScreenId == 100) {
                              saleamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 200) {
                              kotamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 101) {
                              salereturnamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 201) {
                              kotretuenamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                            }

                          }
                          // Sale Order card,cash,upi,others
                          for (int i = 0; i < RawGetSalesOrderClosingAmt.testdata.length; i++) {
                            if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Cash') {
                              socash += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Card') {
                              socard += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'UPI') {
                              soupi += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Others') {
                              soothers += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                            }
                            else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Return Amt') {
                              soreturnamt += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                            }
                          }





                           sitotalcash=sicash-sireturnamt;
                           sototalcash=socash - soreturnamt;
                           totalcash=sitotalcash+sototalcash;
                           totalcard=sicard+socard;
                           upi=siupi+soupi;
                           totalothers =siothers+soothers;

                           print("totalcash"+totalcash.toString());
                           print("totalcard"+totalcard.toString());
                           print("upi"+upi.toString());
                           print("totalothers"+totalothers.toString());
                           print("Saleamt"+(saleamt-salereturnamt).toString());
                           print("KotAmt"+(kotamt-kotretuenamt).toString());
                           print("Sale Order Amt"+_SaleOrderAmt.text.toString());


                           //print(double.parse(_PettyCashAmt.text)-double.parse(_OpeningAmt.text));

                        },
                      ),
                      Visibility(
                        visible: false,
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.pink,
                          icon: Icon(Icons.print,
                              color: Colors.black45),
                          label: Text(
                            'Test Print',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            if (_OpeningAmt.text == '0') {
                              Fluttertoast.showToast(msg: "Opening Amt Not Load..");
                            } else if (_ClosingAmt.text == '0') {
                              Fluttertoast.showToast(msg: "Closing Amt Not Load..");
                            } else if (_SaleInvAmt.text == '') {
                              Fluttertoast.showToast(msg: "Sale Amt Not Load..");
                            } else {
                              setState(() {
                                InsertFormId = 1;
                              });
                              NetPrinter(sessionIPAddress, sessionIPPortNo);
                            }

                          },
                        ),
                      ),
                      SizedBox(
                        width: width / 2.5,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.greenAccent,
                        icon: Icon(Icons.refresh,
                            color: Colors.black45),
                        label: Text(
                          'Refresh',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          getPendingListChecking();
                        },
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
                          if (_OpeningAmt.text == '0') {
                            Fluttertoast.showToast(
                                msg: "Opening Amt Not Load..");
                          } else if (_ClosingAmt.text == '0') {
                            Fluttertoast.showToast(
                                msg: "Closing Amt Not Load..");
                          } else if (_SaleInvAmt.text == '') {
                            Fluttertoast.showToast(msg: "Sale Amt Not Load..");
                          } else {
                            setState(() {
                              InsertFormId = 1;
                            });
                            postdataheader(UpdateDocNo, "O", 1);
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
              decoration:BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff3A9BDC),
                        Color(0xff3A9BDC)
                      ]
                )
            ),
              child: SafeArea(
                child: Scaffold(
                  appBar:
                  PreferredSize(
                    preferredSize: Size.fromHeight(height/9),
                    child: AppBar(title: Text('Shift Closing'),),
                  ),
                  body: !loading
                      ? SingleChildScrollView(
                          padding: EdgeInsets.all(5.0),
                          scrollDirection: Axis.vertical,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: width / 8.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 8.2,
                                        child: TextField(
                                          controller: _OpeningAmt,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Opening Amount',
                                              labelText: 'Opening Amount',
                                              labelStyle: TextStyle(
                                                  color:Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 8.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 8.2,
                                        child: TextField(
                                          controller: _OpeningTime,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Opening Time',
                                              labelText: 'Opening Time',
                                              labelStyle: TextStyle(
                                                  color:Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 6.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 6.2,
                                        child: TextField(
                                          controller: _PettyCashAmt,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Opening Sales Amt',
                                              labelText: 'Opening Sales Amt',
                                              labelStyle: TextStyle(color:Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 4.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 4.2,
                                        child: TextField(
                                          controller: _SalesamountOne,
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Sale Amount',
                                              labelText: 'Sale Amount',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 4.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 4.2,
                                        child: TextField(
                                          controller: _ClosingDate,
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Colsing Date',
                                              labelText: 'Colsing Date',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ), //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: height / 1.5,
                                      width: width / 3,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SecDenomination.toString() =="null"
                                                ? Center(
                                                        child: Text('Add ItemCode Line Table'),
                                            )
                                                : DataTable(
                                                  sortColumnIndex: 0,
                                                  sortAscending: true,
                                                  dataRowHeight:20,
                                                  headingRowHeight:15,
                                                  headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                  showCheckboxColumn: false,
                                                  columns: const <DataColumn>[
                                                  DataColumn(
                                                      label: Text('Denomination',style: TextStyle(color:Colors.white),),
                                                    ),
                                                  DataColumn(
                                                    label: Text('Cal',style: TextStyle(color:Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Edit',style: TextStyle(color:Colors.white),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                  label: Text('Total',
                                                    style: TextStyle(color:Colors.white),
                                                   ),
                                                  ),
                                                  ],
                                                  rows: SecDenomination.map((list) => DataRow(cells: [
                                                      DataCell(
                                                        Text(list.Denomin.toString(),textAlign:TextAlign.left),
                                                      ),
                                                      DataCell(
                                                        Text(list.Name.toString(),textAlign:TextAlign.left),
                                                      ),
                                                      DataCell(
                                                        Text(list.Amt.toString(),textAlign:TextAlign.left),
                                                        showEditIcon: true,
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext contex) =>
                                                                AlertDialog(
                                                                  content:TextFormField(
                                                                    keyboardType:TextInputType.number,
                                                                    onChanged:(vvv) {
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
                                                                              child:TextButton(
                                                                                onPressed:() {
                                                                                  var totalCal = 0.0;
                                                                                  setState(() {
                                                                                    list.Amt = EditAmt;
                                                                                    list.Total = list.Denomin * list.Amt;
                                                                                    for (int i = 0; i < SecDenomination.length; i++) {
                                                                                      totalCal += SecDenomination[i].Total;
                                                                                    }

                                                                                    TotalValue = totalCal;
                                                                                    countclosingAmt();
                                                                                  });
                                                                                  Navigator.pop(context,'Ok',);
                                                                                },
                                                                                child:const Text("Ok"),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child:TextButton(
                                                                                onPressed: () =>
                                                                                    Navigator.pop(context, 'Cancel'),
                                                                                child:const Text('Cancel'),
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
                                                        Text(list.Total.toString(),textAlign:TextAlign.left),
                                                      ),
                                              ]),
                                              ).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 1.7,
                                      height: height / 1.5,
                                      margin: EdgeInsets.only(left: width / 20),
                                      child: Visibility(
                                        visible: false,
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: height / 1.5,
                                              width: width / 3.5,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      height: height / 8,
                                                      width: width / 3.5,
                                                      child: TextField(
                                                        controller: _ClosingAmt,
                                                        enabled: false,
                                                        keyboardType:TextInputType.number,
                                                        style: TextStyle(
                                                          //fontSize: 12,
                                                        ),
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.only(
                                                              top: 3, bottom: 2, left: 10, right: 10),
                                                          hintText: 'Closing Amount',
                                                          labelText: 'Closing Amount',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .grey.shade600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      height: height / 8,
                                                      width: width / 3.5,
                                                      child: TextField(
                                                        controller: _SaleInvAmt,
                                                        enabled: false,
                                                        keyboardType:TextInputType.number,
                                                        style: TextStyle(
                                                          //fontSize: 12,
                                                        ),
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.only(
                                                              top: 3, bottom: 2, left: 10, right: 10),
                                                          hintText: 'Sale Inv Amount',
                                                          labelText:'Sale Inv Amount',
                                                          labelStyle: TextStyle(color: Colors.grey.shade600),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: height / 1.5,
                                              width: width / 3.5,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      height: height / 8,
                                                      width: width / 3.5,
                                                      child: TextField(
                                                        controller: _DiffrenceAmt,
                                                        enabled: false,
                                                        keyboardType:TextInputType.number,
                                                        style: TextStyle(
                                                          //fontSize: 12,
                                                        ),
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.only(
                                                              top: 3, bottom: 2, left: 10, right: 10),
                                                          hintText:'Diffrence Amount',
                                                          labelText:'Diffrence Amount',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .grey.shade600),
                                                        ),
                                                      ),
                                                    ),

                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      height: height / 8,
                                                      width: width / 3.5,
                                                      child: TextField(
                                                        controller: _SaleOrderAmt,
                                                        enabled: false,
                                                        keyboardType:TextInputType.number,
                                                        style: TextStyle(
                                                          //fontSize: 12,
                                                        ),
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.only(
                                                              top: 3, bottom: 2, left: 10, right: 10),
                                                          hintText:'Sale Order Amount',
                                                          labelText:'Sale Order Amount',
                                                          labelStyle: TextStyle(color: Colors.grey.shade600),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                        Container(
                          height: height/12,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.orangeAccent,
                            icon: Icon(Icons.attach_money_outlined,
                                color: Colors.black45),
                            label: Text(
                              TotalValue.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              double sicash=0;
                              double sitotalcash=0;
                              double sicard = 0;
                              double siupi = 0;
                              double siothers=0;
                              double sireturnamt=0;
                              double socash=0;
                              double sototalcash=0;
                              double socard = 0;
                              double soupi = 0;
                              double soothers=0;
                              double soreturnamt=0;
                              double saleamt=0;
                              double kotamt=0;
                              double salereturnamt=0;
                              double kotretuenamt=0;
                              double totalcash=0;
                              double totalcard=0;
                              double upi=0;
                              double  totalothers =0;
                              // Sale Invoice card,cash,upi,others
                              for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
                                if (RawGetSalesClosingAmt.testdata[i].type == 'Cash') {
                                  sicash += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].type == 'Card') {
                                  sicard += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].type == 'UPI') {
                                  siupi += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].type == 'Others') {
                                  siothers += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].type == 'Return Amt') {
                                  sireturnamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                              }
                              // cal sale invoice amt and Kot amt
                              for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
                                if (RawGetSalesClosingAmt.testdata[i].ScreenId == 100) {
                                  saleamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 200) {
                                  kotamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 101) {
                                  salereturnamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 201) {
                                  kotretuenamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
                                }

                              }
                              // Sale Order card,cash,upi,others
                              for (int i = 0; i < RawGetSalesOrderClosingAmt.testdata.length; i++) {
                                if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Cash') {
                                  socash += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Card') {
                                  socard += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'UPI') {
                                  soupi += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Others') {
                                  soothers += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                                }
                                else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Return Amt') {
                                  soreturnamt += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
                                }
                              }





                              sitotalcash=sicash-sireturnamt;
                              sototalcash=socash - soreturnamt;
                              totalcash=sitotalcash+sototalcash;
                              totalcard=sicard+socard;
                              upi=siupi+soupi;
                              totalothers =siothers+soothers;

                              print("totalcash"+totalcash.toString());
                              print("totalcard"+totalcard.toString());
                              print("upi"+upi.toString());
                              print("totalothers"+totalothers.toString());
                              print("Saleamt"+(saleamt-salereturnamt).toString());
                              print("KotAmt"+(kotamt-kotretuenamt).toString());
                              print("Sale Order Amt"+_SaleOrderAmt.text.toString());


                              //print(double.parse(_PettyCashAmt.text)-double.parse(_OpeningAmt.text));

                            },
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            height: height/12,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.pink,
                              icon: Icon(Icons.print,
                                  color: Colors.black45),
                              label: Text(
                                'Test Print',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_OpeningAmt.text == '0') {
                                  Fluttertoast.showToast(msg: "Opening Amt Not Load..");
                                } else if (_ClosingAmt.text == '0') {
                                  Fluttertoast.showToast(msg: "Closing Amt Not Load..");
                                } else if (_SaleInvAmt.text == '') {
                                  Fluttertoast.showToast(msg: "Sale Amt Not Load..");
                                } else {
                                  setState(() {
                                    InsertFormId = 1;
                                  });
                                  NetPrinter(sessionIPAddress, sessionIPPortNo);
                                }

                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 2.5,
                        ),
                        Container(
                          height: height/12,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.greenAccent,
                            icon: Icon(Icons.refresh,
                                color: Colors.black45),
                            label: Text(
                              'Refresh',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              getPendingListChecking();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: height/12,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.blue.shade700,
                            icon: Icon(Icons.check),
                            label: Text('Save'),
                            onPressed: () {
                              if (_OpeningAmt.text == '0') {
                                Fluttertoast.showToast(
                                    msg: "Opening Amt Not Load..");
                              } else if (_ClosingAmt.text == '0') {
                                Fluttertoast.showToast(
                                    msg: "Closing Amt Not Load..");
                              } else if (_SaleInvAmt.text == '') {
                                Fluttertoast.showToast(msg: "Sale Amt Not Load..");
                              } else {
                                setState(() {
                                  InsertFormId = 1;
                                });
                                postdataheader(UpdateDocNo, "O", 1);
                              }
                            },
                          ),
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
      sessionIPAddress = prefs.getString("SaleInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));
      getPendingListChecking();
    });
  }

  Future<http.Response> getPendingListChecking() async {
    log("getPendingListChecking");
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID' + InsertFormId.toString());
      print('CounterId' + sessionbranchcode.toString());
      print('UserID' + sessionuserID.toString());
    });
    var body = {
      "FormID": 2,
      "DocNo": 0,
      "ScreenId": 0,
      "OpeningAmt": 0.0,
      "SaleAmt": 0.00,
      "SystemSaleAmt": 0.00,
      "SaleAmtTwo": 0.00,
      "DiffrenceAmt": 0.00,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": "Div0120",
      "UserID": int.parse(sessionuserID),
      "Status": 'O'
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_CLOSE_SP'),
        headers: headers,
        body: jsonEncode(body));

    log(jsonEncode(body));
    // setState(() {
    //   loading = false;
    // });
    if (response.statusCode == 200) {
      //print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "Enter The Opening Amt Or Enter The Perty Cash Amt...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        showDialogboxWarning(this.context, 'Enter The Opening Amt Or Enter The Perty Cash Amt...');
      } else {
        log(response.body);
        _OpeningAmt.text = decode["testdata"][0]["OpeningAmt"].toString();
        _ClosingDate.text = decode["testdata"][0]["DocDateD"].toString();
         UpdateDocNo = decode["testdata"][0]["DocNo"];
        _OpeningTime.text = decode["testdata"][0]["OpenTime"];
        _PettyCashAmt.text = decode["testdata"][0]["PettyCashAmt"].toString();

        getSalesAmt(UpdateDocNo);
        setState(() {
          loading = false;
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getSalesAmt(int updateDocNo) async {
    log("getSalesAmt");
    print("SaleOrder");
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID' + InsertFormId.toString());
    });
    var body = {
      "FormID": 3,
      "DocNo": updateDocNo,
      "ScreenId": 0,
      "OpeningAmt": 0.0,
      "SaleAmt": 0.00,
      "SystemSaleAmt": 0.00,
      "SaleAmtTwo": 0.00,
      "DiffrenceAmt": 0.00,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": _ClosingDate.text,
      "UserID": int.parse(sessionuserID),
      "Status": 'O'
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_CLOSE_SP'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      log(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "No Sale Invoice Data...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        getSalesOrderAmt(updateDocNo);
        count();
      } else {
        log(response.body);

        RawGetSalesClosingAmt = GetSalesClosingAmt.fromJson(
          jsonDecode(response.body),
        );

        //_OpeningAmt.text = decode["testdata"][0]["OpeningAmt"].toString();

        setState(() {
          loading = false;
          getSalesOrderAmt(updateDocNo);
          count();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getSalesOrderAmt(updateDocNo) async {
    log("getSalesOrderAmt");
    var headers = {"Content-Type": "application/json"};
    setState(() {
      //loading = true;
      log("getSalesOrderAmt 1");
      //print('FormID' + InsertFormId.toString());
    });
    var body = {
      "FormID": 5,
      "DocNo": updateDocNo,
      "ScreenId": 0,
      "OpeningAmt": 0.0,
      "SaleAmt": 0.00,
      "SystemSaleAmt": 0.00,
      "SaleAmtTwo": 0.00,
      "DiffrenceAmt": 0.00,
      "CounterId": int.parse(sessionbranchcode.toString()),
      "DeviceId": _ClosingDate.text,
      "UserID": int.parse(sessionuserID.toString()),
      "Status": 'O'
    };
    log("getSalesOrderAmt 2");
   log(jsonEncode(body));
   log(AppConstants.LIVE_URL + 'SHIFT_CLOSE_SP');

    final response = await http.post(Uri.parse(AppConstants.LIVE_URL + 'SHIFT_CLOSE_SP'),
        headers: headers,
        body: jsonEncode(body));
    log("getSalesOrderAmt 3");
    setState(() {
      log("getSalesOrderAmt-123");
      loading = false;
    });

    if (response.statusCode == 200) {
      //print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "Enter The Opening Amt...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
        log(response.body);
        RawGetSalesOrderClosingAmt = GetSalesClosingAmt.fromJson(jsonDecode(response.body),);


          loading = false;
          print('cont....');
          count();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
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
      "SaleAmt": _SalesamountOne.text,
      "SystemSaleAmt": _SaleInvAmt.text,
      "SaleAmtTwo": _SaleOrderAmt.text,
      "DiffrenceAmt": _DiffrenceAmt.text,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": "Div0120",
      "UserID": sessionuserID,
      "Status": status
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_CLOSE_SP'),
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
            await  LineTblDataInsert(i);
            }

            await  InsertOffline(HeaderDocNo,UpdateDocNo);
            NetPrinter(sessionIPAddress, sessionIPPortNo);
            Navigator.pop(this.context);
            Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) =>ShiftHomeMaster()));
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
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_CLOSE_Line_SP'),
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

  void count() {
    print('cont');
    double TotalInvSale = 0;
    double TotalInvReturn = 0;
    double TotalSaleOrderAmt = 0;
    double TotalSaleOrderReturn = 0;

    if(RawGetSalesClosingAmt==null){

    }else{
        for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
          if (RawGetSalesClosingAmt.testdata[i].status == 0) {
            TotalInvSale += RawGetSalesClosingAmt.testdata[i].recvAmount;
          } else if (RawGetSalesClosingAmt.testdata[i].status == 1) {
            TotalInvReturn += RawGetSalesClosingAmt.testdata[i].recvAmount;
          }
        }
  }

    if (RawGetSalesOrderClosingAmt == null) {
      print('true');
    } else {
      print('false');
      for (int i = 0; i < RawGetSalesOrderClosingAmt.testdata.length; i++) {
        if (RawGetSalesOrderClosingAmt.testdata[i].status == 0) {
          TotalSaleOrderAmt +=RawGetSalesOrderClosingAmt.testdata[i].recvAmount;
        } else if (RawGetSalesOrderClosingAmt.testdata[i].status == 1) {
          TotalSaleOrderReturn += RawGetSalesOrderClosingAmt.testdata[i].recvAmount;
        }
      }
    }

    print(TotalSaleOrderAmt);
    print(TotalSaleOrderReturn);
    _SaleInvAmt.text = (TotalInvSale - TotalInvReturn).toString();
    _SaleOrderAmt.text = (TotalSaleOrderAmt - TotalSaleOrderReturn).toString();

    _SalesamountOne.text =((TotalInvSale - TotalInvReturn) + (TotalSaleOrderAmt-TotalSaleOrderReturn)).round().toString();
  }

  void countclosingAmt() {
    double closingAmt = 0;
    double DifferanceAmt = 0;

    for (int i = 0; i < SecDenomination.length; i++) {
      closingAmt += SecDenomination[i].Total;
    }
    _ClosingAmt.text = closingAmt.round().toString();
    _DiffrenceAmt.text =
        (double.parse(_SalesamountOne.text) - double.parse(_ClosingAmt.text))
            .round()
            .toString();
  }

  Future<http.Response> InsertOffline(int headerDocNo,UpdateDocNo) async {
    print("Seva - Print - headerDocNo-"+headerDocNo.toString());
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM IN_MOB_SHIFT_CLOSE");
        await txn.rawDelete("DELETE  FROM IN_MOB_SHIFT_CLOSE_LIN");
        await txn.rawUpdate(" UPDATE IN_MOB_SHIFT_OPEN SET Status = 'C' WHERE DocNo = '${UpdateDocNo}'");

        await txn.rawInsert(
            "INSERT INTO IN_MOB_SHIFT_CLOSE ([DocNo],[OpeningAmt],[SaleAmt],[SystemSaleAmt],[SaleAmtTwo],[DiffrenceAmt],[CounterId],[DeviceId],[CreateBy],[DocDate],[ShiftOpenDocNo])"
                "VALUES(${headerDocNo},'${_OpeningAmt.text}','${_SalesamountOne.text}','${_SaleInvAmt.text}','${_SaleOrderAmt.text}','${_DiffrenceAmt.text}','${sessionbranchcode}','Div0120','${sessionuserID}',DATE(),'${UpdateDocNo}')");

        for (int i = 0; i < SecDenomination.length; i++) {
          print("Count -->"+SecDenomination[i].Amt.toString());
          print("Total -->"+SecDenomination[i].Total.toString());
          var priint = await txn.rawInsert(
              "INSERT INTO IN_MOB_SHIFT_CLOSE_LIN ([DocNo],[Amt],[Count],[LineTotal]) VALUES ("
                  "${headerDocNo},"
                  "'${SecDenomination[i].Denomin}',"
                  "'${SecDenomination[i].Amt}','${SecDenomination[i].Total}')");
          print(priint);
        }
        setState(() {

          loading = false;
        });
      });
    } catch (Excetion) {
      print(Excetion);
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
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  NetPrinter(String iPAddress,int pORT,) async {
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      //print('SDGVIUGSV' + iPAddress + 'pORT' + pORT.toString());
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printDemoReceipt(printer);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: ${e}');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {

    double sicash=0;
    double sitotalcash=0;
    double sicard = 0;
    double siupi = 0;
    double siothers=0;
    double sireturnamt=0;
    double socash=0;
    double sototalcash=0;
    double socard = 0;
    double soupi = 0;
    double soothers=0;
    double soreturnamt=0;
    double saleamt=0;
    double kotamt=0;
    double salereturnamt=0;
    double kotretuenamt=0;
    double totalcash=0;
    double totalcard=0;
    double upi=0;
    double  totalothers =0;
    // Sale Invoice card,cash,upi,others
    for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
      if (RawGetSalesClosingAmt.testdata[i].type == 'Cash') {
        sicash += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].type == 'Card') {
        sicard += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].type == 'UPI') {
        siupi += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].type == 'Others') {
        siothers += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].type == 'Return Amt') {
        sireturnamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
    }
    // cal sale invoice amt and Kot amt
    for (int i = 0; i < RawGetSalesClosingAmt.testdata.length; i++) {
      if (RawGetSalesClosingAmt.testdata[i].ScreenId == 100) {
        saleamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 200) {
        kotamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 101) {
        salereturnamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesClosingAmt.testdata[i].ScreenId == 201) {
        kotretuenamt += double.parse(RawGetSalesClosingAmt.testdata[i].recvAmount.toString());
      }

    }
    // Sale Order card,cash,upi,others
    for (int i = 0; i < RawGetSalesOrderClosingAmt.testdata.length; i++) {
      if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Cash') {
        socash += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Card') {
        socard += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'UPI') {
        soupi += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Others') {
        soothers += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
      }
      else if (RawGetSalesOrderClosingAmt.testdata[i].type == 'Return Amt') {
        soreturnamt += double.parse(RawGetSalesOrderClosingAmt.testdata[i].recvAmount.toString());
      }
    }
    sitotalcash=sicash-sireturnamt;
    sototalcash=socash - soreturnamt;
    totalcash=sitotalcash+sototalcash;
    totalcard=sicard+socard;
    upi=siupi+soupi;
    totalothers =siothers+soothers;

    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text('Sweets & Cakes', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.row([PosColumn(text: 'Shift Closing', width: 12, styles: PosStyles(align: PosAlign.center),),]);

    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'Shift Id', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: UpdateDocNo.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Shift Open', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _OpeningTime.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Shift Close', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: BillCurrentTime.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
        PosColumn(text: 'User Person', width: 4, styles: PosStyles(align: PosAlign.left,)),
        PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
        PosColumn(text: sessionName.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
      ],);
    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'System Opening Amt', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _PettyCashAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Manual Opening Amt', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _OpeningAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.row([
      PosColumn(text: 'Opening Diff Amt', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: (double.parse(_PettyCashAmt.text)-double.parse(_OpeningAmt.text)).toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.hr(len: 12);

    double manulsashdiff=0;
    manulsashdiff = double.parse(_ClosingAmt.text.toString())-totalcash;
    printer.row([
      PosColumn(text: 'Manual Cash Amt', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _ClosingAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn(text: "System Cash Sales", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: totalcash.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);

    printer.row([
      PosColumn(text: "Diffrent", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: manulsashdiff.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);



    printer.hr(len: 12);



    printer.row([
      PosColumn(text: "Cash Sales", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: totalcash.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);

    printer.row([
      PosColumn(text: "Card Sales", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: totalcard.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);

    printer.row([
      PosColumn(text: "UPI Sales", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: upi.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);
    printer.row([
      PosColumn(text: "Others Sale", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: totalothers.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);
    printer.row([
      PosColumn(text: 'Total Sales', width: 6, styles: PosStyles(align: PosAlign.left,bold: true)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _SalesamountOne.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right,bold: true )),
    ]);
    // printer.row([
    //   PosColumn(text: "Diffrence Amt", width: 6, styles: PosStyles(align: PosAlign.left),),
    //   PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
    //   PosColumn(text: _DiffrenceAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    // ]);

    printer.hr(len: 12);
    printer.row([
      PosColumn(text: "Sale Inv Amt", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: (saleamt-salereturnamt).toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);

    printer.row([
      PosColumn(text: "Sale Order Amt", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _SaleOrderAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);

    printer.row([
      PosColumn(text: "KOT invoice Amt", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: (kotamt-kotretuenamt).toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    ]);
    printer.hr(len: 12);

    for (int i = 0; i < SecDenomination.length; i++) {
      printer.row(
        [
          PosColumn(text: SecDenomination[i].Denomin.toString(), width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: SecDenomination[i].Name.toString(), width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: SecDenomination[i].Amt.toString(), width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: SecDenomination[i].Total.toString(), width: 3, styles: PosStyles(align: PosAlign.left)),
        ],
      );

    }
    printer.row([
      PosColumn(text: 'Total Amt', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _ClosingAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right)),
    ]);

    printer.feed(2);
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));
    printer.feed(1);
    printer.cut();


  }


}

class DenominationList {
  var Denomin;
  String Name;
  var Amt;
  var Total;
  DenominationList(this.Denomin, this.Name, this.Amt, this.Total);
}
