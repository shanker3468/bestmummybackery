// ignore_for_file: deprecated_member_use, missing_return, non_constant_identifier_names, unnecessary_brace_in_string_interps, camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/Getvehiclemodel.dart';
import 'package:bestmummybackery/Model/ProductionTblModel.dart';
import 'package:bestmummybackery/Model/PurchaseIndentheaderModel.dart';
import 'package:bestmummybackery/Model/Purchaseitemmodel.dart';
import 'package:bestmummybackery/Model/SalesOrderModel.dart';
import 'package:bestmummybackery/Model/TrackAssetModel.dart';
import 'package:bestmummybackery/Model/WhsModel.dart';
import 'package:bestmummybackery/Model/getQRModel.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TrackAsset extends StatefulWidget {
  const TrackAsset({Key key}) : super(key: key);

  @override
  _TrackAssetState createState() => _TrackAssetState();
}

class _TrackAssetState extends State<TrackAsset> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;
  String alterwhscode = "";
  String alterwhsname = "";
  bool loading = false;
  String chvalue;
  String alterassetcode="";
  String alterassetname="";
  bool typevisible = false;
  bool typevisible1 = false;
  int _value = 1;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController toWhsspinner = TextEditingController();
  final TextEditingController Edt_DocDate = TextEditingController();
  final TextEditingController Edt_MobileNo = TextEditingController();
  final TextEditingController ItemController = TextEditingController();
  final TextEditingController Searchcontroller = TextEditingController();
  final TextEditingController Edt_DocNo = TextEditingController();
  final TextEditingController Edt_SoDelDate = TextEditingController();
  final TextEditingController QRCodeController = TextEditingController();
  final TextEditingController Edt_SapRefNo = TextEditingController();
  final TextEditingController Edt_FromWHS = TextEditingController();
  WhsModel whsModel;

  List<DataItems1> details = new List();
  List<SearchResult> searchmodel = new List();
  var items = List<Result>();
  List<String> salesordernolist = new List();
  List<SendItemTemp> sendtemplist = new List();
  SalesOrderModel salesordermodel;
  getQRModel itemmodel;
  FocusNode QrFocusNode;
  List<getQRModelTemp> templist = new List();
  var alterdocentry = "";
  var alterdocnum = "";
  var alterdocdate = "";
  var alterdeldate = "";
  var alterprodentry = "";
  ProductionTblModel RawProductionTblModel;
  EmpModel salespersonmodel;
  List<String> salespersonlist = new List();
  List<String> careoflist = new List();
  String altersalespersoname = "";
  String altersalespersoncode = "";
  // vehiclemodel
  Getvehiclemodel RawGetvehiclemodel;
  List<String> vehiclelist = new List();

  String altervehiclename = "";
  String altervehiclecode = "";
  // End
  // Location
  LocationModel locationModel = new LocationModel();
  List<String> loc = new List();
  var alterloccode = '';
  var alterlocname = '';
  var altertoloccode = '';
  var altertolocname = '';
  //Printer
  NetworkPrinter printer;
  var alterDocType = '';
  PurchaseIndentheaderModel RawPurchaseIndentheaderModel;
  List<PurchaseIndent> SecPurchaseIndent = new List();
  List<PurchaseIndent> SecIPOIndent = new List();
  bool CheckIndent = false;

  TrackAssetModel RawTrackAssetModel;
  List<String> itemList = new List();
  List<ScreenTbl> SecScreenTbl = new List();
  var alterLinestatus =100;

  @override
  void initState() {
    getStringValuesSF();
    QrFocusNode = FocusNode();
    setState(() {
      alterdocnum = "0";
    });
    super.initState();
  }

  @override
  void dispose() {
    QrFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Track Asset'),
          ),
          backgroundColor: Colors.white,
          body: !loading
              ? SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  child: new TextField(
                                    controller: Edt_DocNo,
                                    enabled: false,
                                    onSubmitted: (value) {
                                      print("Onsubmit,${value}");
                                    },
                                    decoration: InputDecoration(
                                      labelText: "DocNo",
                                      border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              new Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  child: new TextField(
                                    controller: Edt_DocDate,
                                    enabled: false,
                                    onSubmitted: (value) {
                                      print("Onsubmit,${value}");
                                    },
                                    decoration: InputDecoration(
                                      labelText: "DocDate",
                                      border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              new Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  child: new TextField(
                                    controller: Edt_MobileNo,
                                    enabled: true,
                                    onSubmitted: (value) {
                                      print("Onsubmit,${value}");
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Mobile No",
                                      border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: DropdownSearch<String>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    items: salespersonlist,
                                    label: "Select Transporter Name",
                                    onChanged: (val) {
                                      print(val);
                                      for (int kk = 0;kk < salespersonmodel.result.length;kk++) {
                                        if (salespersonmodel.result[kk].name == val) {
                                          print(salespersonmodel.result[kk].empID);
                                          altersalespersoname = salespersonmodel.result[kk].name;
                                          altersalespersoncode = salespersonmodel.result[kk].empID.toString();
                                        }
                                      }
                                    },
                                    selectedItem: altersalespersoname,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: DropdownSearch<String>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    items: vehiclelist,
                                    label: "Vechicle Number",
                                    onChanged: (val) {
                                      print(val);
                                      for (int kk = 0;kk < RawGetvehiclemodel.testdata.length;kk++) {
                                        if (RawGetvehiclemodel.testdata[kk].vehicleNo == val) {
                                          altervehiclename =RawGetvehiclemodel.testdata[kk].vehicleNo;
                                          altervehiclecode =RawGetvehiclemodel.testdata[kk].docNo.toString();
                                        }
                                      }
                                    },
                                    selectedItem: altervehiclename,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  child: DropdownSearch<String>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    items: loc,
                                    label: "From Location",
                                    onChanged: (val) {
                                      print(val);
                                      for (int kk = 0; kk < locationModel.result.length; kk++) {
                                        if (locationModel.result[kk].name == val) {
                                          print(locationModel.result[kk].code);
                                          alterlocname = locationModel.result[kk].name;
                                          alterloccode =locationModel.result[kk].code.toString();
                                        }
                                      }
                                    },
                                    selectedItem: alterlocname,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 5,
                                ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: loc,
                                      label: "To Location",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0; kk < locationModel.result.length; kk++) {
                                          if (locationModel.result[kk].name == val) {
                                            print(locationModel.result[kk].code);
                                            altertolocname = locationModel.result[kk].name;
                                            altertoloccode =locationModel.result[kk].code.toString();
                                          }
                                        }
                                      },
                                      selectedItem: altertolocname,
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  child: DropdownSearch<String>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    items: itemList,
                                    label: "Choose Asset Name",
                                    onChanged: (val) {
                                      for (int kk = 0; kk < RawTrackAssetModel.testdata.length; kk++) {
                                        if (RawTrackAssetModel.testdata[kk].itemName == val) {
                                          alterassetname = RawTrackAssetModel.testdata[kk].itemName.toString();
                                          alterassetcode =RawTrackAssetModel.testdata[kk].itemCode.toString();
                                          alterLinestatus= RawTrackAssetModel.testdata[kk].linestatus;
                                        }
                                      }
                                    },
                                    selectedItem: alterassetname,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 5,
                                ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: ElevatedButton(onPressed: () {  
                                      AddSacreenTbl(alterassetcode,alterassetname,alterLinestatus);
                                      
                                    }, child: Text('Add'),),
                                  ),
                                ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/1.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SecScreenTbl.length == 0
                                      ? Center(
                                            child: Text('No Data Add!'),
                                  )
                                      : DataTable(
                                                sortColumnIndex: 0,
                                                sortAscending: true,
                                                headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                                showCheckboxColumn: false,
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text('S.No',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Asset Code',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Asset Name',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Line Status',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Remove',style: TextStyle(color: Colors.white),),
                                                  ),


                                                ],
                                              rows: SecScreenTbl.map(
                                              (list) => DataRow(
                                                color: list.LineStatus==1?MaterialStateProperty.all(Colors.orangeAccent)
                                                  :list.LineStatus==0?MaterialStateProperty.all(Colors.greenAccent)
                                                    :MaterialStateProperty.all(Colors.white),
                                                  cells: [
                                                DataCell(
                                                  Center(
                                                    child: Center(
                                                      child: Wrap(
                                                          direction:Axis.vertical, //default
                                                          alignment:WrapAlignment.center,
                                                          children: [
                                                            Text(
                                                                (SecScreenTbl.indexOf(list) +1).toString(),
                                                                textAlign:TextAlign.center)
                                                          ]),
                                                    ),
                                                  ),
                                                ),

                                                DataCell(
                                                  Wrap(
                                                    direction: Axis.vertical, //default
                                                    alignment: WrapAlignment.center,
                                                    children: [
                                                      Text(list.AssetCode,textAlign: TextAlign.left)]
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Wrap(
                                                          direction:Axis.vertical, //default
                                                          alignment:WrapAlignment.center,
                                                          children: [
                                                            Text(list.AssetName.toString(),textAlign: TextAlign.center)
                                                          ])),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Wrap(
                                                          direction:Axis.vertical, //default
                                                          alignment:WrapAlignment.center,
                                                          children: [
                                                            Text(list.LineStatus.toString(),textAlign: TextAlign.center)
                                                          ])),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Center(
                                                        child: IconButton(
                                                          icon: Icon(Icons.cancel),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            print("Pressed");
                                                            setState(() {
                                                              SecScreenTbl.remove(list);
                                                              Fluttertoast.showToast(msg: "Deleted Row");
                                                            });
                                                          },
                                                        )),
                                                  ),
                                                ),
                                          ]),
                                        )
                                            .toList(),
                                      ),
                                ),
                              ),
                              SizedBox(width: 50,),
                              Container(
                                width: 300,
                                height: 150,
                                color: Colors.grey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.white,),
                                        SizedBox(width: 30,),
                                        Text('New Item Only Allow For Save Out'),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.greenAccent,),
                                        SizedBox(width: 30,),
                                        Text('Item Only Allow For Save Out'),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.orangeAccent,),
                                        SizedBox(width: 30,),
                                        Text('Item Only Allow For Save In'),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.orangeAccent,),
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.greenAccent,),
                                        SizedBox(width: 15,),
                                        Text('Allow For Save In Or Save Out'),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.white,),
                                        SizedBox(width: 5,),
                                        Container(height: 10,width: 10,color: Colors.greenAccent,),
                                        SizedBox(width: 15,),
                                        Text('Allow For  Save Out'),
                                      ],
                                    ),
                                  ],
                                ),


                              ),
                            ],
                          )
              ],
            ),
          )
              : Center(
                    child: CircularProgressIndicator(),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  heroTag: "Save",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(Icons.check),
                  label: Text('Save Out'),
                  onPressed: () {
                    if (altervehiclename == '') {
                      Fluttertoast.showToast(msg: "Choose Vechicle");
                    } else {
                      int check =0;
                      for(int i = 0 ; i< SecScreenTbl.length;i++){
                        if(SecScreenTbl[i].LineStatus==1){
                          check=100;
                        }
                      }
                      if(check==100){
                        showDialogboxWarning(this.context, "The Orange Color Items Only Allow For Save In...  ");
                      }else{
                      postdataheader(1);
                      }
                    }

                  },
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  heroTag: "Save IN",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(Icons.check),
                  label: Text('Save IN'),
                  onPressed: () {
                    if (altervehiclename == '') {
                      Fluttertoast.showToast(msg: "Choose Vechicle");
                    } else {
                      int check =0;
                      for(int i = 0 ; i< SecScreenTbl.length;i++){
                        if(SecScreenTbl[i].LineStatus==0||SecScreenTbl[i].LineStatus ==2){
                          check=100;
                        }
                      }
                      if(check==100){
                        showDialogboxWarning(this.context, "The Orange Color Items Only Allow For Save Out...  ");
                      }else{
                      postdataheader(0);

                      }
                    }

                  },
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.clear),
                  label: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SubMyClac(context, index, packetType) {
    var Qty;
    return Stack(
      children: <Widget>[
        Container(
          width: 450,
          height: 520,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              //color: Color.fromRGBO(117, 191, 255, 0.40),
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            children: <Widget>[
              Container(
                height: 420,
                width: 420,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      Qty = value ?? 0;
                      Qty = value.toStringAsFixed(1);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = value.toStringAsFixed(1);
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      templist[index].qty = 0;
                      Navigator.pop(context);
                    }
                  },
                  theme: const CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 1,
                    displayColor: Colors.white,
                    displayStyle:TextStyle(fontSize: 20, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle:TextStyle(fontSize: 15, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle:TextStyle(fontSize: 15, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle:TextStyle(fontSize: 15, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    templist[index].qty = Qty;
                    //templist[index].amount = amount;
                    //count();
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {},
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  QtyMyClac(context, index, packetType) {
    var Qty;
    return Stack(
      children: <Widget>[
        Container(
          width: 450,
          height: 520,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              //color: Color.fromRGBO(117, 191, 255, 0.40),
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            children: <Widget>[
              Container(
                height: 420,
                width: 420,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      Qty = value ?? 0;
                      Qty = value.toStringAsFixed(1);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = value.toStringAsFixed(1);
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      Navigator.pop(context);
                    }
                  },
                  theme: const CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 1,
                    displayColor: Colors.white,
                    displayStyle:
                    TextStyle(fontSize: 20, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle:
                    TextStyle(fontSize: 15, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle:
                    TextStyle(fontSize: 15, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle:
                    TextStyle(fontSize: 15, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    templist[index].qty = Qty;
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {},
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  NetPrinter(String iPAddress, int pORT, int headerdocno,) async {
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      //print('SDGVIUGSV' + iPAddress + 'pORT' + pORT.toString());
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printDemoReceipt(printer, headerdocno);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: ${e}');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer, headerdocno) async {
    double TotalAmt = 0;
    double TotalCash = 0;
    double TotalCard = 0;
    double TotalTaxAmt = 0;
    print('akdjcbkagdvc');
    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());

    printer.text('BESTMUMMY',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.text((sessionbranchname),
        styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',
        styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.text("Delivery No - " + headerdocno.toString(),
        styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    printer.text("OrderDate - " + Edt_SoDelDate.text,
        styles: PosStyles(align: PosAlign.left), linesAfter: 1);

    printer.hr();
    printer.row([
      PosColumn(text: 'S.no', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Order Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Send Qty', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    for (int i = 0; i < templist.length; i++) {
      printer.row(
        [
          PosColumn(text: i.toString(), width: 1),
          PosColumn(text: templist[i].itemName.toString(), width: 7),
          PosColumn(
              text: templist[i].qty.toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right)),
          PosColumn(
              text: templist[i].weight.toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right)),
        ],
      );
      TotalAmt += double.parse(templist[i].weight.toString());
      TotalTaxAmt += double.parse(templist[i].qty.toString());
    }

    printer.hr();

    printer.row([
      PosColumn(
          text: 'Location',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: alterlocname.toString(),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    printer.row([
      PosColumn(
          text: 'Transporter Name',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: altersalespersoname.toString(),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    printer.row([
      PosColumn(
          text: 'Vechile No',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: altervehiclename.toString(),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    printer.feed(2);
    printer.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.feed(1);
    printer.cut();
  }

  Future<http.Response> getDataTableRecord(DocEntry, FormId) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();
    });
    var body = {
      "FromId": FormId,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": DocEntry,
      "Status": "D",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    //print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    //var nodata = jsonDecode(response.body)['status'] == 0;
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        RawProductionTblModel =
            ProductionTblModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawProductionTblModel.testdata.length; i++) {
          //templist.add(getQRModelTemp(docNo, docDate, itemGroupCode, itemGroupName, itemCode, itemName, uom, box, tray, packetType, weight, qRCode, qty, branchID, remarks))

          templist.add(
            getQRModelTemp(
                0,
                '',
                '0',
                '0',
                RawProductionTblModel.testdata[i].itemCode,
                RawProductionTblModel.testdata[i].itemName, //itemName,
                RawProductionTblModel.testdata[i].invntryUom,
                RawProductionTblModel.testdata[i].box,
                RawProductionTblModel.testdata[i].tray,
                RawProductionTblModel
                    .testdata[i].Stock, //packetType - Stock Qty
                RawProductionTblModel.testdata[i].quantity, //weight OrderQty
                "qRCode",
                RawProductionTblModel
                    .testdata[i].quantity, //Qty ORder Same Qty Aginst Customer
                '',
                '',
                0),
          );
        }
        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  void filterSearchResults(String query) {
    // List<Result> dummySearchList = List<Result>();
    // // dummySearchList.addAll(detailitems);
    // if (query.isNotEmpty) {
    //   for (int k = 0; k < ItemList.result.length; k++)
    //     if (ItemList.result[k].itemCode
    //             .toLowerCase()
    //             .contains(Searchcontroller.text) ||
    //         (ItemList.result[k].itemCode
    //             .toLowerCase()
    //             .contains(Searchcontroller.text)))
    //       dummySearchList.add(Result(
    //           ItemList.result[k].itemCode,
    //           ItemList.result[k].itemName,
    //           ItemList.result[k].uOM,
    //           ItemList.result[k].minLevel,
    //           ItemList.result[k].maxLevel,
    //           stock,
    //           qty));
    // } else {
    //   setState(() {
    //     items.clear();
    //     items.addAll(detailitems);
    //   });
    // }
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
      _typeAheadController.text = "Open";
      getlocation();
      salesPersonget(1, 1);
      getVEHICLERecord();
      getlocationval();

    });
  }

  void salesPersonget(int USERID, int BRANCHID) {
    setState(() {
      loading = true;
    });
    GetAllSalesPerson(USERID, BRANCHID).then((response) {
      print(response.body);
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print(response.body);

        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          salespersonmodel.result.clear();
        } else {
          setState(() {
            salespersonmodel = EmpModel.fromJson(jsonDecode(response.body));
            print(salespersonmodel.result.length);
            careoflist.clear();
            salespersonlist.clear();

            for (int k = 0; k < salespersonmodel.result.length; k++) {
              salespersonlist.add(salespersonmodel.result[k].name);
              careoflist.add(salespersonmodel.result[k].name);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getVEHICLERecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();
    });
    var body = {
      "FromId": 13,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": 10,
      "Status": "D",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    var nodata = jsonDecode(response.body)['status'] == 0;
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        setState(() {
          RawGetvehiclemodel =
              Getvehiclemodel.fromJson(jsonDecode(response.body));
          print(RawGetvehiclemodel.testdata.length);
          vehiclelist.clear();

          for (int k = 0; k < RawGetvehiclemodel.testdata.length; k++) {
            vehiclelist.add(RawGetvehiclemodel.testdata[k].vehicleNo);
          }
        });
      }
      setState(() {
        loading = false;
      });
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getdocno() async {
    var headers = {"Content-Type": "application/json"};
    var body = {"UserID": "${sessionuserID}", "FormID": 10};
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getdateandno'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getdateandno');

      setState(() {
        loading = false;
      });
      print('REPOSD  ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        int login = jsonDecode(response.body)['status'];

        if (login == 0) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          Edt_MobileNo.text = "";
          Edt_DocDate.text = "";
        } else {
          Edt_MobileNo.text = "";
          Edt_DocDate.text = "";
          print(response.body);

          Edt_DocNo.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
          Edt_DocDate.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
          //EdtDocNo.text = jsonDecode(response.body)['result']['PURDocNo'];
          getWhs();
        }
        // showDialogbox(context, response.body);

      } else {
        showDialogboxWarning(context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
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

  Future<http.Response> getWhs() async {
    var headers = {"Content-Type": "application/json"};

    setState(() {
      loading = true;
    });

    print(AppConstants.LIVE_URL + 'getWhs');

    final response = await http.get(Uri.parse(AppConstants.LIVE_URL + 'getWhs'),
        headers: headers);
    setState(() {
      loading = false;
    });
    print("API Loated Sucess: ${response.body}");

    if (response.statusCode == 200) {
      print("API Loated Sucess: ${response.body}");

      //var nodata = jsonDecode(response.body)['status'] == 0;
      var nodata = jsonDecode(response.body)['status'] == 0;
      print('nodata${nodata}');
      if (nodata == true) {
        setState(() {
          whsModel = null;
        });
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          whsModel = WhsModel.fromJson(jsonDecode(response.body));
          getSaleslist();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getSaleslist() async {
    var headers = {"Content-Type": "application/json"};
    var body = {"UserID": sessionuserID};
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getSalesorderNo'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == '0';
      print('$login');
      if (login == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        salesordermodel = null;
      } else {
        setState(() {
          //dailymodel = WhsDailyModel.fromJson(jsonDecode(response.body));
          salesordermodel = SalesOrderModel.fromJson(jsonDecode(response.body));
          salesordernolist.clear();

          for (int i = 0; i < salesordermodel.result.length; i++) {
            salesordernolist.add(
                salesordermodel.result[i].prodEntry.toString() +
                    "-" +
                    salesordermodel.result[i].ShopName.toString());
          }
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      showDialogboxWarning(context, "Sales Drop Down Failed to Login API");
    }
  }

  Future getlocation() {
    GetAllWhs(sessionbranchcode).then((response) {
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print('sessioncode${sessionbranchcode}');
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            whsModel = null;
            getdocno();
          });
        } else {
          setState(() {
            whsModel = WhsModel.fromJson(jsonDecode(response.body));

            alterwhscode = whsModel.result[1].whsCode;
            alterwhsname = whsModel.result[1].whsName;
            Edt_FromWHS.text = alterwhsname;
            getdocno();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getlocationval() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(AppConstants.LIVE_URL + 'getLocation'),
        headers: headers);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var nodata = jsonDecode(response.body)['status'] == 0;

      if (nodata == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        locationModel.result.clear();
        loc.clear();
      } else {
        print("Location Responce" + response.body);
        setState(() {
          locationModel = LocationModel.fromJson(jsonDecode(response.body));
          loc.clear();
          for (int k = 0; k < locationModel.result.length; k++) {
            loc.add(locationModel.result[k].name);
          }
          loading = false;
          getItemmaster();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getItemmaster() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FromID":3,
      "DocNo":0,
      "DocDate":"",
      "MobileNo":"",
      "DriverCode":0,
      "DriverName":"",
      "VechicleCode":0,
      "VechicleName":"",
      "FromLocation":0,
      "FromLocationCode":"",
      "ToLocation":"",
      "ToLocationCode":0,
      "Satus":"",
      "LineId":0,
      "Itemcode":"",
      "ItemName":"",
      "LineStatus":0,
      "BranchId":int.parse(sessionbranchcode.toString()),
      "CreateBy":int.parse(sessionuserID.toString())
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'inserttrackasset'),
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
        });
      } else {
          log(response.body);
          RawTrackAssetModel = TrackAssetModel.fromJson(jsonDecode(response.body));
          itemList.clear();
          for(int i = 0 ; i < RawTrackAssetModel.testdata.length;i++){
            itemList.add(RawTrackAssetModel.testdata[i].itemName);
          }
          setState(() {
            loading = false;
          });
        }

    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<http.Response> postdataheader(lineststus) async {
    int docno = 0;
    print(altervehiclecode);
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FromID":1,
      "DocNo":0,
      "DocDate":"",
      "MobileNo":Edt_MobileNo.text,
      "DriverCode":int.parse(altersalespersoncode.toString()),
      "DriverName":altersalespersoname,
      "VechicleCode":int.parse(altervehiclecode.toString()),
      "VechicleName":altervehiclename,
      "FromLocation":  alterlocname.toString(),
      "FromLocationCode":int.parse(alterloccode.toString()),
      "ToLocation":altertolocname.toString(),
      "ToLocationCode":int.parse(altertoloccode.toString()),
      "Satus":"O",
      "LineId":0,
      "Itemcode":"",
      "ItemName":"",
      "LineStatus":0,
      "BranchId":int.parse(sessionbranchcode.toString()),
      "CreateBy":int.parse(sessionuserID.toString())
    };
    print(sessionuserID);
    print(body);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'inserttrackasset'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
      } else {
        log(response.body);

        print(decode["testdata"][0]['DocNo']);
        docno=decode["testdata"][0]['DocNo'];
        for(int i = 0 ; i < SecScreenTbl.length;i++){
          postdatadetails(docno,i,lineststus);
        }
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) =>TrackAsset(),
          ),
        );
        setState(() {
          loading = false;
        });
      }

    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<http.Response> postdatadetails(int headerdocno, int index,lineststus) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      //loading = true;
    });
    var body = {
      "FromID":2,
      "DocNo":headerdocno,
      "DocDate":"",
      "MobileNo":"",
      "DriverCode":0,
      "DriverName":"",
      "VechicleCode":0,
      "VechicleName":"",
      "FromLocation":0,
      "FromLocationCode":"",
      "ToLocation":"",
      "ToLocationCode":0,
      "Satus":"",
      "LineId":index,
      "Itemcode":SecScreenTbl[index].AssetCode,
      "ItemName":SecScreenTbl[index].AssetName,
      "LineStatus":lineststus,
      "BranchId":int.parse(sessionbranchcode.toString()),
      "CreateBy":int.parse(sessionuserID.toString())
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'inserttrackasset'),
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
        });
      } else {
        log(response.body);
        setState(() {
          loading = false;
        });
      }

    } else {
      throw Exception('Failed to Login API');
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

   void AddSacreenTbl(assetCode, assetName, linestatus) {
    int count = 0;
    for(int i =0;i<SecScreenTbl.length;i++){
      if(SecScreenTbl[i].AssetCode ==assetCode ){
        count++;
      }
    }
    setState(() {
      if(count==0){
        SecScreenTbl.add(ScreenTbl(0, assetCode, assetName, linestatus));
      }else{
        Fluttertoast.showToast(msg: "This Asset Code Already Added..");
      }
    });

  }


}

class PurchaseIndent {
  var DocNo;
  var DocDate;
  var LocCode;
  var LocName;
  PurchaseIndent(this.DocNo, this.DocDate, this.LocCode, this.LocName);
}

/*class BackendService {
  static Future<List> getSuggestions(String query) async {
    // ignore: deprecated_member_use
    List<WhsFillModel> my = new List();
    if (_DespatchScreenState.whsModel.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _DespatchScreenState.whsModel.result.length; a++)
        if (_DespatchScreenState.whsModel.result[a].whsName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(WhsFillModel(_DespatchScreenState.whsModel.result[a].whsCode,
              _DespatchScreenState.whsModel.result[a].whsName));
      return my;
    }
  }
}*/

class Result {
  String itemCode;
  String itemName;
  String uOM;
  int minLevel;
  int maxLevel;
  int stock;
  int qty;

  Result(this.itemCode, this.itemName, this.uOM, this.minLevel, this.maxLevel,
      this.stock, this.qty);
}

class WhsFillModel {
  String WhsCode;
  String WhsName;

  WhsFillModel(this.WhsCode, this.WhsName);
}

class DataItems1 {
  var DOCNO;
  var ITEMCODE;
  var ITEMNAME;
  var QTY;
  var UOM;
  var Stock;
  var Max;
  var Min;
  var Qty;
  var USERID;
  var USERID1;

  DataItems1(this.DOCNO, this.ITEMCODE, this.ITEMNAME, this.QTY, this.UOM,
      this.Stock, this.Max, this.Min, this.Qty, this.USERID, this.USERID1);

  Map<String, dynamic> toJson() => {
    'DocNo': DOCNO,
    'ItemCode': ITEMCODE,
    'ItemName': ITEMNAME,
    'QTY': QTY,
    'UOM': UOM,
    'Stock': Stock,
    'Max': Max,
    'Min': Min,
    'Qty': Qty,
    'UserID': USERID,
    'UserID': USERID1,
  };
}

class SearchResult {
  String itemCode;
  String itemName;
  String uOM;
  int stock;
  int minLevel;
  int maxLevel;
  int qty;

  SearchResult(this.itemCode, this.itemName, this.uOM, this.stock,
      this.minLevel, this.maxLevel, this.qty);
}

class getQRModelTemp {
  var docNo;
  String docDate;
  String itemGroupCode;
  String itemGroupName;
  String itemCode;
  String itemName;
  String uom;
  String box;
  String tray;
  var packetType;
  var weight;
  String qRCode;
  var qty;
  var branchID;
  var remarks;
  var Status;

  getQRModelTemp(
      this.docNo,
      this.docDate,
      this.itemGroupCode,
      this.itemGroupName,
      this.itemCode,
      this.itemName,
      this.uom,
      this.box,
      this.tray,
      this.packetType,
      this.weight,
      this.qRCode,
      this.qty,
      this.branchID,
      this.remarks,
      this.Status);
}

class SendItemTemp {
  var DOCNO;
  var LineID;
  var ITEMCODE;
  var ITEMNAME;
  var UOM;
  var QrCode;
  var PacketType;
  var Box;
  var Tray;
  var Weight;
  var Qty;
  var Remarks;
  var RefNo;
  var UserID;
  var WhsCode;

  SendItemTemp(
      this.DOCNO,
      this.LineID,
      this.ITEMCODE,
      this.ITEMNAME,
      this.UOM,
      this.QrCode,
      this.PacketType,
      this.Box,
      this.Tray,
      this.Weight,
      this.Qty,
      this.Remarks,
      this.RefNo,
      this.UserID,
      this.WhsCode);

  Map<String, dynamic> toJson() => {
    'DocNo': DOCNO,
    'LineID': LineID,
    'ItemCode': ITEMCODE,
    'ItemName': ITEMNAME,
    'Uom': UOM,
    'QRCode': QrCode,
    'PacketType': PacketType,
    'Box': Box,
    'Tray': Tray,
    'Weight': Weight,
    'Qty': Qty,
    'Remarks': Remarks,
    'RefNo': RefNo,
    'UserID': UserID,
    'WhsCode': WhsCode
  };
}



class ScreenTbl{
  var LinId;
  var AssetCode;
  var AssetName;
  var LineStatus;

  ScreenTbl(this.LinId,this.AssetCode,this.AssetName,this.LineStatus);
}
