// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_brace_in_string_interps, missing_return, unused_local_variable, unrelated_type_equality_checks, equal_keys_in_map, camel_case_types, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/GetItemMasterModel.dart';
import 'package:bestmummybackery/Model/Getvehiclemodel.dart';
import 'package:bestmummybackery/Model/ProductionTblModel.dart';
import 'package:bestmummybackery/Model/PurchaseIndentheaderModel.dart';
import 'package:bestmummybackery/Model/SalesOrderModel.dart';
import 'package:bestmummybackery/Model/WhsModel.dart';
import 'package:bestmummybackery/Model/getQRModel.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class DespatchScreen extends StatefulWidget {
   DespatchScreen({Key key, this. DocNo, this. DocType}) : super(key: key);
  var DocType="";
  var DocNo="";
  @override
  _DespatchScreenState createState() => _DespatchScreenState();
}

class _DespatchScreenState extends State<DespatchScreen> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionContact1 = "";
  var sessionIPPortNo = 0;
  String alterwhscode = "";
  String alterwhsname = "";
  bool loading = false;
  String chvalue;
  bool typevisible = false;
  bool typevisible1 = false;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController toWhsspinner = TextEditingController();
  final TextEditingController EdtDocNo = TextEditingController();
  final TextEditingController EdtDocDate = TextEditingController();
  final TextEditingController ItemController = TextEditingController();
  final TextEditingController Searchcontroller = TextEditingController();
  final TextEditingController Edt_SoDate = TextEditingController();
  final TextEditingController Edt_SoDelDate = TextEditingController();
  final TextEditingController QRCodeController = TextEditingController();
  final TextEditingController Edt_SapRefNo = TextEditingController(text: '0');
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
  var alterdocentry = "0";
  var alterdocnum = "0";
  var alterdocdate = "";
  var alterdeldate = "";
  var alterprodentry = "0";
  ProductionTblModel RawProductionTblModel;
  EmpModel salespersonmodel;
  List<String> salespersonlist = new List();
  List<String> careoflist = new List();
  String altersalespersoname = "";
  String altersalespersoncode = "";
  Getvehiclemodel RawGetvehiclemodel;
  List<String> vehiclelist = new List();
  String altervehiclename = "";
  String altervehiclecode = "";
  LocationModel locationModel = new LocationModel();
  List<String> loc = new List();
  var alterloccode = '0';
  var alterlocname = '';
  NetworkPrinter printer;
  var alterDocType = '';
  PurchaseIndentheaderModel RawPurchaseIndentheaderModel;
  List<PurchaseIndent> SecPurchaseIndent = new List();
  List<PurchaseIndent> SecIPOIndent = new List();
  List<DispatcheDrafmode> SecDispatcheDrafmode = new List();
  bool CheckIndent = false;
  GetItemMasterModel rawGetItemMasterModel;
  List<String> secItemMaster=[];
  var alterItemCode ="";
  var alterItemName ="";
  var alterUOM ="";
  var alterStock ="";
  int delectcont=0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var ScreenName ='';
  int DispatchDocEntry=0;
  bool Holdbtn = true;
  bool QrCodeAutoFocus=false;
  bool Reprint=false;

  @override
  void initState() {
    getStringValuesSF();
    QrFocusNode = FocusNode();
      alterdocnum = "0";
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      setState(() {});
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      final decode = jsonDecode(barcodeScanRes);
      print("Out" + decode[0]["OrderNo"].toString());
      getSaleslist(decode[0]["OrderNo"].toString());
      ScreenName = "SaleOrder";

    });
  }

  @override
  void dispose() {
    QrFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      //log("true tablet");
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      //log("false tablet");
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return Container(
      child: !tablet?
           SafeArea(
              child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(!tablet? height/15 :height/9),
                    child: new AppBar(
                      title: Text('Despatch'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            getDispatchReprint().then((value) => {
                              showDialog<void>(context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: DespatchReocrdReprint(context),
                                  );
                                },
                              )
                            });
                          },
                          child: Container(
                            height: !tablet? height/15 :height/10,
                            width: !tablet? width/20 :width/7,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(height/20),),),
                            child: Icon(Icons.print,color: Colors.white,),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            getDispatchHold().then((value) => {
                              showDialog<void>(context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: DespatchReocrd(context),
                                  );
                                },
                              )
                            });
                          },
                          child: Container(
                            height: !tablet? height/15 :height/10,
                            width: !tablet? width/10 :width/7,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.shade400,
                              borderRadius: BorderRadius.all(Radius.circular(height/20),),),
                            child: Text('Hold',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            getIPOIdent().then((value) => {
                                  showDialog<void>(context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/20),),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: IPOReocrd(context),
                                      );
                                    },
                                  )
                                });
                          },
                          child: Container(
                            height: !tablet? height/15 :height/10,
                            width: !tablet? width/10 :width/7,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.all(Radius.circular(height/20),),),
                            child: Text('PR',style: TextStyle(color: Colors.white,fontSize: !tablet? height/50 :height/30),),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              scanQR();
                            },
                            child: Icon(Icons.camera_alt),
                        )
                      ],
                    ),
                  ),
                  backgroundColor: Colors.white,
                  body: !loading
                      ? SingleChildScrollView(
                          padding: EdgeInsets.all(5.0),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Visibility(
                                visible: false,
                                child: Row(
                                  children: [
                                    //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                    Expanded(
                                      flex: 5,
                                      child: DropdownSearch<String>(
                                        mode: Mode.MENU,
                                        showSearchBox: true,
                                        items: salesordernolist,
                                        label: "Customer Sales Order No",
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            for (int kk = 0;kk < salesordermodel.result.length;kk++) {
                                              if (salesordermodel.result[kk].prodEntry.toString() + "-" +salesordermodel.result[kk].ShopName.toString().toString() ==val) {
                                                alterdocentry = salesordermodel.result[kk].docEntry.toString();
                                                alterdocnum = salesordermodel.result[kk].docNum.toString();
                                                alterdocdate = salesordermodel.result[kk].docDate.toString();
                                                alterdeldate = salesordermodel.result[kk].docDueDate.toString();
                                                alterprodentry = salesordermodel.result[kk].prodEntry.toString();
                                                Edt_SoDate.text =alterdocdate.substring(0, 10);
                                                Edt_SoDelDate.text =alterdeldate.substring(0, 10);
                                                Edt_SapRefNo.text = alterdocentry;
                                                alterDocType = 'CusSaleOrder';
                                                CheckIndent = false;
                                                getDataTableRecord(int.parse(Edt_SapRefNo.text), 12);
                                              }
                                            }
                                          });
                                        },
                                        selectedItem: alterdocnum,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                        child: new TextField(
                                          controller: Edt_SoDate,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,${value}");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "SO.Date",
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
                                          controller: EdtDocNo,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,${value}");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "PE.No",
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
                                          controller: EdtDocDate,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,${value}");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Despatch Date",
                                            border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: false,
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  child: DropdownSearch<String>(
                                    mode: Mode.MENU,
                                    showSearchBox: true,
                                    items: salesordernolist,
                                    label: "Customer Sales Order No",
                                    onChanged: (val) {
                                      print(val);
                                      for (int kk = 0;kk < salesordermodel.result.length;kk++) {
                                        if (salesordermodel.result[kk].prodEntry.toString() +
                                            "-" +salesordermodel.result[kk].ShopName.toString().toString() ==val) {
                                          alterdocentry = salesordermodel.result[kk].docEntry.toString();
                                          alterdocnum = salesordermodel.result[kk].docNum.toString();
                                          alterdocdate = salesordermodel.result[kk].docDate.toString();
                                          alterdeldate = salesordermodel.result[kk].docDueDate.toString();
                                          alterprodentry = salesordermodel.result[kk].prodEntry.toString();
                                          Edt_SoDate.text =alterdocdate.substring(0, 10);
                                          Edt_SoDelDate.text =alterdeldate.substring(0, 10);
                                          Edt_SapRefNo.text = alterdocentry;
                                          alterDocType = 'CusSaleOrder';
                                          CheckIndent = false;
                                          ScreenName = "SaleOrder";
                                          getDataTableRecord(int.parse(Edt_SapRefNo.text), 12);
                                        }
                                      }
                                    },
                                    selectedItem: alterdocnum,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: new Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                        child: new TextField(
                                          controller: Edt_SoDelDate,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,${value}");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "SO.Del.Date",
                                            border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: new TextField(
                                        controller: Edt_FromWHS,
                                        readOnly: true,
                                        style: TextStyle(fontSize: !tablet? height/55:height/30),
                                        onSubmitted: (value) {
                                          print("Onsubmit,${value}");
                                        },
                                        decoration: InputDecoration(
                                          labelText: "From Whs",
                                          contentPadding:  EdgeInsets.only(top:height/ 50, bottom: height/ 100, left:width/ 20, right: width/ 20),
                                          border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: new Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                        child: new TextField(
                                          controller: Edt_SapRefNo,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,${value}");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Sap Ref.No",
                                            border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                          ),
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
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: new TextField(
                                        keyboardType: TextInputType.text,
                                        controller: QRCodeController,
                                        focusNode: QrFocusNode,
                                        showCursor: true,
                                        //autofocus: true,
                                        enabled: true,
                                        style: TextStyle(fontSize: !tablet? height/55:height/30),
                                        onSubmitted: (value) {
                                          //print("Onsubmit,${value}");
                                          setState(() {
                                            var Qty='0';
                                            var s = value;
                                            log(value);
                                            var taxcode='';
                                            var price='';
                                            var amount='';
                                            if(value.toString().isEmpty){
                                              setState(() {
                                                Fluttertoast.showToast(msg: "No Data read");
                                                QrFocusNode.requestFocus();
                                              });
                                            }else {
                                              var kv = s.substring(0, s.length - 1).substring(1).split(",");
                                              final Map<String, String> pairs = {};
                                              for (int i = 0; i < kv.length; i++) {
                                                var thisKV = kv[i].split(":");
                                                pairs[thisKV[0]] = thisKV[1].trim();
                                              }
                                              var encoded = json.encode(pairs);
                                              log(encoded);
                                              final decode = jsonDecode(encoded);
                                              setState(() {
                                                for (int kk = 0; kk < rawGetItemMasterModel.result.length; kk++) {
                                                  if (rawGetItemMasterModel.result[kk].itemCode == decode["ItemCode"].toString()) {
                                                    alterItemCode = rawGetItemMasterModel.result[kk].itemCode;
                                                    alterItemName = rawGetItemMasterModel.result[kk].itemName;
                                                    alterUOM = rawGetItemMasterModel.result[kk].invntryUom;
                                                    alterStock = rawGetItemMasterModel.result[kk].stock.toString();

                                                    taxcode =rawGetItemMasterModel.result[kk].taxcode.toString();
                                                    price =rawGetItemMasterModel.result[kk].price.toString();
                                                    amount =rawGetItemMasterModel.result[kk].amount.toString();
                                                  }
                                                }
                                              });
                                              Qty = (double.parse(decode["Qty"].toString()) * 1).toStringAsFixed(3);
                                              delectcont = 0;
                                              int validation =0;
                                              if(alterUOM=="Grams" || alterUOM =="Kgs"){
                                                log("selva groms 2");
                                                for(int i=0;i<templist.length;i++){
                                                  if(templist[i].box.toString()==decode["RowId"].toString()){
                                                    validation=100;
                                                  }
                                                }
                                              }else{

                                              }

                                              if(validation==0) {
                                                amount = (double.parse(price.toString()).round() / 1 * double.parse(Qty)).round().toString();
                                                log(amount);
                                                addmyRow(0, '', '0', '0',
                                                    alterItemCode, alterItemName, alterUOM, decode["RowId"].toString(), '',
                                                  alterStock, 0, 'qRCode',
                                                    Qty, sessionbranchcode, '',1,taxcode,
                                                    price,
                                                    amount,
                                                    (double.parse(taxcode.split("@")[1]) *
                                                        double.parse(amount.toString()) / 100).round().toString(),
                                                );
                                              }else{
                                                Fluttertoast.showToast(msg: "This Item Alrwady Added...");
                                                delectcont = 1;
                                                QrFocusNode.requestFocus();
                                                QRCodeController.clear();
                                                showDialogboxWarning(context,"This QR Already Scaned..");
                                              }

                                            }
                                          });
                                          //getitemlist(value.toString());
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Scan QR Code M",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  new Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items:secItemMaster,
                                        label: "Select Item",
                                        onChanged: (val) {
                                          print(val);
                                          var Qty='0';
                                          setState(() {
                                            var taxcode='';
                                            var price='';
                                            var amount='';
                                            for (int kk = 0;kk <rawGetItemMasterModel.result.length;kk++) {
                                              if (rawGetItemMasterModel.result[kk].itemName ==val) {
                                                alterItemCode =rawGetItemMasterModel.result[kk].itemCode;
                                                alterItemName =rawGetItemMasterModel.result[kk].itemName;
                                                alterUOM =rawGetItemMasterModel.result[kk].invntryUom;
                                                alterStock =rawGetItemMasterModel.result[kk].stock.toString();

                                                taxcode =rawGetItemMasterModel.result[kk].taxcode.toString();
                                                price =rawGetItemMasterModel.result[kk].price.toString();
                                                amount =rawGetItemMasterModel.result[kk].amount.toString();
                                              }
                                            }
                                            delectcont=0;
                                            if(alterUOM == "Grams" || alterUOM == "Kgs"){
                                              showDialog(
                                                context:context,
                                                builder: (BuildContext contex1) => AlertDialog(
                                                  content:TextFormField(
                                                    keyboardType:TextInputType.number,
                                                    maxLength:10,
                                                    autofocus:true,
                                                    onChanged:(vvv) {
                                                      setState(() {
                                                        Qty = (double.parse(vvv.toString())* 1).toStringAsFixed(3);
                                                      });
                                                    },
                                                  ),
                                                  title: Text("Enter The Grms & Kg"),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    //Qty.toStringAsFixed(3);
                                                                    print(double.parse(price.toString()).round() / 1 * double.parse(Qty));
                                                                    amount = (double.parse(price.toString()).round() / 1 * double.parse(Qty)).round().toString();
                                                                    log(amount);
                                                                    addmyRow(0, '', '0', '0',
                                                                        alterItemCode, alterItemName, alterUOM, '', '', alterStock, 0, 'qRCode',
                                                                        Qty, sessionbranchcode, '',0,
                                                                        taxcode,
                                                                        price,
                                                                        amount,
                                                                        (double.parse(taxcode.split("@")[1]) * double.parse(amount.toString()) / 100).round().toString());
                                                                    Navigator.pop(contex1,'Ok',);
                                                                  });
                                                                },
                                                                child: const Text("Ok"),),),
                                                            Container(
                                                              child: TextButton(
                                                                onPressed: () => Navigator.pop(contex1, 'Cancel'),
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
                                            }
                                            else{
                                              addmyRow(0, '', '0', '0',
                                                  alterItemCode, alterItemName, alterUOM, '', '', alterStock, 0, 'qRCode',
                                                  1, sessionbranchcode, '',0,taxcode,price,amount,
                                                  (double.parse(taxcode.split("@")[1]) * double.parse(amount.toString()) / 100).round().toString()
                                              );
                                            }
                                          });
                                        },
                                        selectedItem:alterItemName,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: loc,
                                        label: "Select Location",
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
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width/2,
                                    height: MediaQuery.of(context).size.height / 15,
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
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: width/2.20,
                                    height: MediaQuery.of(context).size.height / 15,
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
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: templist.length == 0
                                    ? Center(
                                        child: Text('No Data Add!'),
                                      )
                                    : DataTable(
                                        sortColumnIndex: 0,
                                        sortAscending: true,
                                        headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                        showCheckboxColumn: false,
                                        headingRowHeight: !tablet? height/20: height/11,
                                        dataRowHeight: !tablet? height/20:height/12,
                                        columnSpacing: width/20,
                                        columns: const <DataColumn>[

                                          DataColumn(
                                            label: Text('S.No',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Send Qty',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Order Qty',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Local Stock',style: TextStyle(color: Colors.white),),
                                          ),

                                          DataColumn(
                                            label: Text('UOM',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Tax%',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Price',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Amt',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('TaxAmt',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Remove',style: TextStyle(color: Colors.white),),
                                          ),
                                        ],
                                        rows: templist.map((list) =>
                                            DataRow(cells: [

                                                DataCell(
                                                  Center(
                                                    child: Center(
                                                      child: Wrap(
                                                          direction:Axis.vertical, //default
                                                          alignment:WrapAlignment.center,
                                                          children: [
                                                            Text(
                                                                (templist.indexOf(list) +1).toString(),
                                                                textAlign:TextAlign.center,style: TextStyle(fontSize: !tablet? height/55:height/30),)
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(list.itemName,textAlign: TextAlign.left,style: TextStyle(fontSize: !tablet? height/55:height/30),),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Wrap(
                                                      direction:Axis.vertical, //default
                                                      alignment: WrapAlignment.center,
                                                      children: [
                                                        Text(list.qty.toString(),style: TextStyle(fontSize: !tablet? height/55:height/30),textAlign:TextAlign.center)
                                                      ],
                                                    ),
                                                  ),
                                                  showEditIcon: true, onTap: () {
                                                if (CheckIndent == true) {
                                                  if (list.uom == "Grams" || list.uom == "Kgs") {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder:(BuildContext context) {
                                                        return Dialog(
                                                          shape:RoundedRectangleBorder(
                                                            borderRadius:BorderRadius.circular(50),),
                                                          elevation: 0,
                                                          backgroundColor:Colors.transparent,
                                                          child: SubMyClac(
                                                              context,
                                                              templist.indexOf(list),list.packetType,tablet,height,width,
                                                              list.price,list.amount
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder:(BuildContext context) {
                                                        return Dialog(
                                                          shape:RoundedRectangleBorder(
                                                            borderRadius:BorderRadius.circular(50),),
                                                          elevation: 0,
                                                          backgroundColor:Colors.transparent,
                                                          child: QtyMyClac(context,templist.indexOf(list),list.packetType,tablet,height,width,list.price,list.amount),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {}
                                              }),
                                                DataCell(
                                                  Center(
                                                      child: Wrap(
                                                          direction:Axis.vertical, //default
                                                          alignment:WrapAlignment.center,
                                                          children: [
                                                        Text(list.weight.toString(), style: TextStyle(fontSize: !tablet? height/55:height/30),textAlign: TextAlign.center)
                                                      ])),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Center(
                                                          child: Wrap(
                                                              direction: Axis.vertical, //default
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                            Text(list.packetType.toString(),style: TextStyle(fontSize: !tablet? height/55:height/30),textAlign: TextAlign.center)
                                                      ]))),
                                                ),

                                                DataCell(
                                                Center(
                                                    child: Wrap(
                                                        direction:Axis.vertical, //default
                                                        alignment:WrapAlignment.center,
                                                        children: [
                                                          Text(list.uom.toString(),style: TextStyle(fontSize: !tablet? height/55:height/30),textAlign: TextAlign.center)
                                                        ])),
                                              ),
                                                DataCell(
                                                  Text(list.taxcode.toString(),style: TextStyle(fontSize: !tablet? height/55:height/30),textAlign: TextAlign.center),
                                                ),
                                                DataCell(
                                                  Text(list.price.toString(),
                                                      style: TextStyle(fontSize: !tablet? height/55:height/30),
                                                      textAlign: TextAlign.center),
                                                ),
                                                DataCell(
                                                Text(list.amount.toString(),
                                                    style: TextStyle(fontSize: !tablet? height/55:height/30),
                                                    textAlign: TextAlign.center),
                                              ),
                                                DataCell(
                                                Text(list.totaltaxamt.toString(),
                                                    style: TextStyle(fontSize: !tablet? height/55:height/30),
                                                    textAlign: TextAlign.center),
                                              ),
                                                DataCell(
                                                Center(
                                                  child: Center(
                                                      child: IconButton(
                                                        icon: Icon(Icons.cancel,size: !tablet? height/40:height/25,),
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          print("Pressed");
                                                          setState(() {
                                                            if (CheckIndent == true) {
                                                              templist.remove(list);
                                                              Fluttertoast.showToast(msg: "Deleted Row");
                                                            } else {}
                                                          });
                                                        },
                                                      )),
                                                ),
                                              ),
                                              ]),
                                            )
                                            .toList(),
                                      ),
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                persistentFooterButtons: [
                  Container(
                    height: height/22,
                    child: Reprint?
                    Row(
                            children: [
                              FloatingActionButton.extended(
                                heroTag: "Print",
                                backgroundColor: Colors.blue.shade700,
                                icon: Icon(Icons.clear,size: height/50,),
                                label: Text('Print',style: TextStyle(fontSize: height/60),),
                                onPressed: () {

                                  NetPrinter(sessionIPAddress, sessionIPPortNo, DispatchDocEntry);
                                  },
                        ),
                            ],
                          )
                        : Row(
                            children: [
                              Visibility(
                                visible: Holdbtn,
                                child: FloatingActionButton.extended(
                                  heroTag: "Hold",
                                  backgroundColor: Colors.pinkAccent,
                                  icon: Icon(Icons.accessible_rounded,size: height/50,),
                                  label: Text('Hold',style: TextStyle(fontSize: height/60),),
                                  onPressed: () {
                                    postdataheader("Hold",DispatchDocEntry,0);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: width/50,
                              ),
                              FloatingActionButton.extended(
                                heroTag: "Cancel",
                                backgroundColor: Colors.red,
                                icon: Icon(Icons.clear,size: height/50,),
                                label: Text('Cancel',style: TextStyle(fontSize: height/60),),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: width/50,
                              ),
                              FloatingActionButton.extended(
                                heroTag: "Save",
                                backgroundColor: Colors.blue.shade700,
                                icon: Icon(Icons.clear,size: height/50,),
                                label: Text('Save',style: TextStyle(fontSize: height/60),),
                                onPressed: () {
                                  String StockItem='';
                                  if (altervehiclename == '') {
                                    Fluttertoast.showToast(msg: "Choose Vechicle");
                                  } else {
                                    if (templist.isEmpty) {
                                      showDialogboxWarning(context, "Scan Atleast 1 Entry");
                                    }  else {
                                        int check=0;
                                      // for(int i = 0; i < templist.length;i++){
                                      //   if(double.parse(templist[i].qty.toString())<=double.parse(templist[i].packetType.toString())){}
                                      //   else{
                                      //     StockItem = templist[i].itemName.toString();
                                      //     check++;
                                      //   }
                                      // }
                                      if(check==0){
                                        postdataheader("Save",DispatchDocEntry,1);
                                      }else{
                                        Fluttertoast.showToast(msg: "No Stock Of This ItemName - "+StockItem.toString());
                                      }
                                    }
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ],
        ),
      )
          :SafeArea(
            child: Scaffold(
              appBar: new AppBar(
                title: Text('Despatch'),
                actions: [
                  TextButton(
                    onPressed: () {
                      getDispatchHold().then((value) => {
                        showDialog<void>(context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: DespatchReocrd(context),
                            );
                          },
                        )
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.all(Radius.circular(30),),),
                      child: Text('My Hold',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      getIPOIdent().then((value) => {
                        showDialog<void>(context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: IPOReocrd(context),
                            );
                          },
                        )
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.all(Radius.circular(30),),),
                      child: Text('IPO Indent',style: TextStyle(color: Colors.white),),
                    ),
                  ),

                ],
              ),
              backgroundColor: Colors.white,
              body: !loading
                  ? SingleChildScrollView(
                    padding: EdgeInsets.all(5.0),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                            Expanded(
                              flex: 5,
                              child: DropdownSearch<String>(
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                items: loc,
                                label: "Select Location",
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
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 5,
                              // child: DropdownSearch<String>(
                              //   mode: Mode.MENU,
                              //   showSearchBox: true,
                              //   items: salesordernolist,
                              //   label: "Customer Sales Order No",
                              //   onChanged: (val) {
                              //     print(val);
                              //     for (int kk = 0;kk < salesordermodel.result.length;kk++) {
                              //       if (salesordermodel.result[kk].prodEntry.toString() +
                              //           "-" +salesordermodel.result[kk].ShopName.toString().toString() ==val) {
                              //         alterdocentry = salesordermodel.result[kk].docEntry.toString();
                              //         alterdocnum = salesordermodel.result[kk].docNum.toString();
                              //         alterdocdate = salesordermodel.result[kk].docDate.toString();
                              //         alterdeldate = salesordermodel.result[kk].docDueDate.toString();
                              //         alterprodentry = salesordermodel.result[kk].prodEntry.toString();
                              //         Edt_SoDate.text =alterdocdate.substring(0, 10);
                              //         Edt_SoDelDate.text =alterdeldate.substring(0, 10);
                              //         Edt_SapRefNo.text = alterdocentry;
                              //         alterDocType = 'CusSaleOrder';
                              //         CheckIndent = false;
                              //         getDataTableRecord(int.parse(Edt_SapRefNo.text), 12);
                              //       }
                              //     }
                              //   },
                              //   selectedItem: alterdocnum,
                              // ),
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
                            SizedBox(
                              width: 5,
                            ),
                            new Expanded(
                              flex: 5,
                              child: Container(
                                color: Colors.white,
                                child: new TextField(
                                  controller: EdtDocNo,
                                  enabled: false,
                                  onSubmitted: (value) {
                                    print("Onsubmit,${value}");
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Despatch No",
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
                                  controller: EdtDocDate,
                                  enabled: false,
                                  onSubmitted: (value) {
                                    print("Onsubmit,${value}");
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Despatch Date",
                                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            new Expanded(
                              flex: 5,
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
                            SizedBox(
                              width: 5,
                            ),
                            new Expanded(
                              flex: 5,
                              child: Container(
                                color: Colors.white,
                                child: new TextField(
                                  controller: Edt_FromWHS,
                                  enabled: false,
                                  onSubmitted: (value) {
                                    print("Onsubmit,${value}");
                                  },
                                  decoration: InputDecoration(
                                    labelText: "From Whs",
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
                                child: DropdownSearch<String>(
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  items:secItemMaster,
                                  label: "Select Item",
                                  onChanged: (val) {
                                    print(val);
                                    var Qty;
                                    setState(() {
                                      for (int kk = 0;kk <rawGetItemMasterModel.result.length;kk++) {
                                        if (rawGetItemMasterModel.result[kk].itemName ==val) {
                                          alterItemCode =rawGetItemMasterModel.result[kk].itemCode;
                                          alterItemName =rawGetItemMasterModel.result[kk].itemName;
                                          alterUOM =rawGetItemMasterModel.result[kk].invntryUom;
                                          alterStock =rawGetItemMasterModel.result[kk].stock.toString();
                                        }
                                      }
                                      delectcont=0;



                                      if(alterUOM == "Grams" || alterUOM == "Kgs"){

                                        showDialog(
                                          context:context,
                                          builder: (BuildContext contex1) => AlertDialog(
                                            content:TextFormField(
                                              keyboardType:TextInputType.number,
                                              maxLength:10,
                                              autofocus:true,
                                              onChanged:(vvv) {
                                                Qty = vvv;
                                                //Qty.toStringAsFixed(3);
                                              },
                                            ),
                                            title: Text("Enter The Grms & Kg"),
                                            actions: <Widget>[
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              //Qty.toStringAsFixed(3);
                                                              // addmyRow(0, '', '0', '0',
                                                              //     alterItemCode, alterItemName, alterUOM, '', '', '', 0, 'qRCode',
                                                              //     Qty, sessionbranchcode, '',0);
                                                              Navigator.pop(contex1,'Ok',);
                                                            });
                                                          },
                                                          child: const Text("Ok"),),),
                                                      Container(
                                                        child: TextButton(
                                                          onPressed: () => Navigator.pop(contex1, 'Cancel'),
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


                                      }
                                      else{

                                        // addmyRow(0, '', '0', '0',
                                        //     alterItemCode, alterItemName, alterUOM, '', '', alterStock, 0, 'qRCode',
                                        //     1, sessionbranchcode, '',0);

                                      }



                                    });
                                  },
                                  selectedItem:alterItemName,
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
                                  keyboardType: TextInputType.text,
                                  controller: QRCodeController,
                                  focusNode: QrFocusNode,
                                  showCursor: true,
                                  onSubmitted: (value) {
                                    print("Onsubmit,${value}");
                                    setState(() {
                                      var Qty;
                                      var s = value;
                                      if(value.toString().isEmpty){
                                        setState(() {
                                          Fluttertoast.showToast(msg: "No Data read");
                                          //QrCodeAutoFocus=true;
                                          QrFocusNode.requestFocus();
                                        });
                                      }else {
                                        var kv = s.substring(0, s.length - 1).substring(1).split(",");
                                        final Map<String, String> pairs = {};
                                        for (int i = 0; i < kv.length; i++) {
                                          var thisKV = kv[i].split(":");
                                          pairs[thisKV[0]] = thisKV[1].trim();
                                        }
                                        var encoded = json.encode(pairs);
                                        log(encoded);
                                        final decode = jsonDecode(encoded);
                                        for (int kk = 0; kk < rawGetItemMasterModel.result.length; kk++) {
                                          if (rawGetItemMasterModel.result[kk].itemCode == decode["ItemCode"].toString()) {
                                            alterItemCode = rawGetItemMasterModel.result[kk].itemCode;
                                            alterItemName = rawGetItemMasterModel.result[kk].itemName;
                                            alterUOM = rawGetItemMasterModel.result[kk].invntryUom;
                                            alterStock = rawGetItemMasterModel.result[kk].stock.toString();
                                          }
                                        }
                                        print("Out" + decode["ItemCode"].toString());
                                        print("Out" + decode["Qty"].toString());
                                        Qty = (double.parse(decode["Qty"].toString()) * 1).toStringAsFixed(3);
                                        delectcont = 0;
                                        int validation =0;
                                        if(alterUOM=="Grams" || alterUOM =="Kgs"){
                                          for(int i=0;i<templist.length;i++){
                                            if(templist[i].box.toString()==decode["RowId"].toString()){
                                              validation=100;
                                            }
                                          }
                                        }else{

                                        }
                                        if(validation==0) {
                                          // addmyRow(0, '', '0', '0',
                                          //     alterItemCode, alterItemName, alterUOM,decode["RowId"].toString(), '', alterStock, 0, 'qRCode',
                                          //     Qty, sessionbranchcode, '',1);
                                        }else{
                                          Fluttertoast.showToast(msg: "This Item Alrwady Added...");
                                          delectcont = 1;
                                          QrFocusNode.requestFocus();
                                          QRCodeController.clear();
                                          showDialogboxWarning(context,"This QR Already Scaned..");
                                        }
                                      }
                                    });
                                    //getitemlist(value.toString());
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Scan QR Code tab",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: templist.length == 0
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
                                    label: Text('Remove',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('S.No',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('UOM',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Order Qty',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Local Stock',style: TextStyle(color: Colors.white),),
                                  ),
                                  // DataColumn(
                                  //   label: Text(
                                  //     'Send Qty',
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // ),
                                  DataColumn(
                                    label: Text(
                                      'Box',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text('Send Qty',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Remarks',style: TextStyle(color: Colors.white),),
                                  ),
                                 ],
                                  rows: templist.map((list) =>
                                DataRow(cells: [
                                DataCell(
                                  Center(
                                    child: Center(
                                        child: IconButton(
                                          icon: Icon(Icons.cancel),
                                          color: Colors.red,
                                          onPressed: () {
                                            print("Pressed");
                                            setState(() {
                                              if (CheckIndent == true) {
                                                templist.remove(list);
                                                Fluttertoast.showToast(msg: "Deleted Row");
                                              } else {}
                                            });
                                          },
                                        )),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Center(
                                      child: Wrap(
                                          direction:Axis.vertical, //default
                                          alignment:WrapAlignment.center,
                                          children: [
                                            Text(
                                                (templist.indexOf(list) +1).toString(),
                                                textAlign:TextAlign.center)
                                          ]),
                                    ),
                                  ),
                                ),
                                DataCell(Wrap(
                                    direction: Axis.vertical, //default
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(list.itemName,textAlign: TextAlign.left)])),
                                DataCell(
                                  Center(
                                      child: Wrap(
                                          direction:Axis.vertical, //default
                                          alignment:WrapAlignment.center,
                                          children: [
                                            Text(list.uom.toString(),textAlign: TextAlign.center)
                                          ])),
                                ),
                                DataCell(
                                  Center(
                                      child: Wrap(
                                          direction:Axis.vertical, //default
                                          alignment:WrapAlignment.center,
                                          children: [
                                            Text(list.weight.toString(),textAlign: TextAlign.center)
                                          ])),
                                ),
                                DataCell(
                                  Center(
                                      child: Center(
                                          child: Wrap(
                                              direction: Axis.vertical, //default
                                              alignment:WrapAlignment.center,
                                              children: [
                                                Text(list.packetType.toString(),textAlign: TextAlign.center)
                                              ]))),
                                ),
                                DataCell(
                                  Center(
                                      child: Center(
                                          child: Wrap(
                                              direction: Axis
                                                  .vertical, //default
                                              alignment:
                                                  WrapAlignment.center,
                                              children: [
                                        Text(list.box.toString(),
                                            textAlign: TextAlign.center)
                                      ]))),
                                ),
                                // DataCell(
                                //   Center(
                                //       child: Center(
                                //           child: Wrap(
                                //               direction: Axis
                                //                   .vertical, //default
                                //               alignment:
                                //                   WrapAlignment.center,
                                //               children: [
                                //         Text(list.tray.toString(),
                                //             textAlign: TextAlign.center)
                                //       ]))),
                                // ),
                                DataCell(
                                    Center(
                                      child: Wrap(
                                        direction:Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.qty.toString(),textAlign:TextAlign.center)
                                        ],
                                      ),
                                    ),
                                    showEditIcon: true, onTap: () {
                                  if (CheckIndent == true) {
                                    if (list.uom == "Grams" || list.uom == "Kgs") {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:(BuildContext context) {
                                          return Dialog(
                                            shape:RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(50),),
                                            elevation: 0,
                                            backgroundColor:Colors.transparent,
                                            child: SubMyClac(
                                                context,templist.indexOf(list),list.packetType,tablet,height,width,
                                                 list.price,list.amount
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:(BuildContext context) {
                                          return Dialog(
                                            shape:RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(50),),
                                            elevation: 0,
                                            backgroundColor:Colors.transparent,
                                            child: QtyMyClac(context,templist.indexOf(list),list.packetType,tablet,height,width,list.price,list.amount),
                                          );
                                        },
                                      );
                                    }
                                  } else {}
                                }),
                                DataCell(
                                  Center(
                                      child: Center(
                                          child: Wrap(
                                              direction: Axis.vertical, //default
                                              alignment:WrapAlignment.center,
                                              children: [
                                                Text(
                                                    list.remarks.toString() ==null
                                                        ? ""
                                                        : list.remarks.toString(),textAlign: TextAlign.center)
                                              ]))),
                                ),
                              ]),
                            )
                                .toList(),
                          ),
                        )
                      ],
                    ),
              )
                  : Center(
                      child: CircularProgressIndicator(),
              ),
              persistentFooterButtons: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      height: MediaQuery.of(context).size.height / 15,
                      color: Colors.white,
                      child: new TextField(
                        controller: Edt_SapRefNo,
                        enabled: false,
                        onSubmitted: (value) {
                          print("Onsubmit,${value}");
                        },
                        decoration: InputDecoration(
                          labelText: "Sap Ref.No",
                          border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: MediaQuery.of(context).size.height / 15,
                      color: Colors.white,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          controller: Edt_SoDate,
                          enabled: false,
                          onSubmitted: (value) {
                            print("Onsubmit,${value}");
                          },
                          decoration: InputDecoration(
                            labelText: "SO.Date",
                            border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 250,
                      height: MediaQuery.of(context).size.height / 15,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          controller: Edt_SoDelDate,
                          enabled: false,
                          onSubmitted: (value) {
                            print("Onsubmit,${value}");
                          },
                          decoration: InputDecoration(
                            labelText: "SO.Del.Date",
                            border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 250,
                      height: MediaQuery.of(context).size.height / 15,
                      // child: DropdownSearch<String>(
                      //   mode: Mode.DIALOG,
                      //   showSearchBox: true,
                      //   items: vehiclelist,
                      //   label: "Vechicle Number",
                      //   onChanged: (val) {
                      //     print(val);
                      //     for (int kk = 0;kk < RawGetvehiclemodel.testdata.length;kk++) {
                      //       if (RawGetvehiclemodel.testdata[kk].vehicleNo == val) {
                      //         altervehiclename =RawGetvehiclemodel.testdata[kk].vehicleNo;
                      //         altervehiclecode =RawGetvehiclemodel.testdata[kk].docNo.toString();
                      //       }
                      //     }
                      //   },
                      //   selectedItem: altervehiclename,
                      // ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Visibility(
                      visible: Holdbtn,
                      child: FloatingActionButton.extended(
                        heroTag: "Hold",
                        backgroundColor: Colors.pinkAccent,
                        icon: Icon(Icons.accessible_rounded),
                        label: Text('Hold'),
                        onPressed: () {
                          setState(() {
                            postdataheader("Hold",DispatchDocEntry,0);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
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
                    SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "Save",
                      backgroundColor: Colors.blue.shade700,
                      icon: Icon(Icons.check),
                      label: Text('Save'),
                      onPressed: () {
                        if (altervehiclename == '') {
                          Fluttertoast.showToast(msg: "Choose Vechicle");
                        }else if (altersalespersoname=='') {
                          Fluttertoast.showToast(msg: "Choose Sales Person");
                        }
                        else {
                          if (templist.isEmpty) {
                            showDialogboxWarning(context, "Scan Atleast 1 Entry");
                          }  else {
                            String StockItem='';
                            int check=0;
                            // for(int i = 0; i < templist.length;i++){
                            //   if(double.parse(templist[i].qty.toString())<=double.parse(templist[i].packetType.toString())){}
                            //   else{
                            //     StockItem = templist[i].itemName.toString();
                            //     check++;
                            //   }
                            // }
                            if(check==0){
                              postdataheader("Save",DispatchDocEntry,1);
                            }else{
                              Fluttertoast.showToast(msg: "No Stock Of This ItemName - "+StockItem.toString());
                            }
                          }
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

  SubMyClac(context, index, packetType,tablet,height,width,price,amount) {
    var Qty;
    log("Grams");
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width,
          height: tablet?520:height/2,
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
                height: tablet?420:height/2.5,
                width: tablet?420:width/1.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {

                      Qty = (value * 1).toStringAsFixed(3);
                      Qty = (value * 1).toStringAsFixed(3);
                      //print(price.round() / 1 * double.parse(Qty));
                      amount =  (double.parse(price.toString()).round() / 1 * double.parse(Qty)).round().toString();
                      print(amount.toString());
                    });
                    if (kDebugMode) {
                      setState(() {
                        Qty = (value * 1).toStringAsFixed(3);
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
                height: tablet?50:height/50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    templist[index].qty = Qty.toString();
                    templist[index].amount = amount;
                    countval();
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  height:height/30,
                  width: width/2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Text(
                    "Ok",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  QtyMyClac(context, index, packetType,tablet,height,width,price,amount) {
    var Qty;
    log("Pcs");
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width,
          height: tablet?520:height/2,
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
                height: tablet?420:height/2.5,
                width: tablet?420:width/1.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      Qty = value ?? 0;
                      Qty = (value * 1).toStringAsFixed(3);
                      amount = double.parse(price.toString()).round()* double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = (value * 1).toStringAsFixed(3);
                        amount = double.parse(price.toString()).round()* double.parse(Qty);
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
                height: tablet?50:height/50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    templist[index].qty = double.parse(Qty.toString()) ;
                    templist[index].amount = amount;
                    countval();
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  height:height/30,
                  width: width/2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Text(
                    "Ok",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  MyHoldReocrd(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {});
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search',
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecPurchaseIndent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "Pur Indent - " +
                                    SecPurchaseIndent[index].DocNo.toString() +
                                    "\n" +
                                    "Pur Date - " +
                                    SecPurchaseIndent[index]
                                        .DocDate
                                        .toString() +
                                    "\n",
                              ),
                              subtitle: Text(SecIPOIndent[index].LocName.toString()),
                              onTap: () {
                                setState(() {
                                  alterdocnum = '0';
                                  Edt_SapRefNo.text = '0';
                                  Edt_SoDate.text = SecPurchaseIndent[index].DocDate.toString();
                                  Edt_SapRefNo.text = SecPurchaseIndent[index].DocNo.toString();
                                  alterprodentry = SecPurchaseIndent[index].DocNo.toString();
                                  alterDocType = "PurchaseIndent";
                                  alterloccode = SecPurchaseIndent[index].LocCode.toString();
                                  alterlocname = SecPurchaseIndent[index].LocName.toString();
                                  CheckIndent = true;
                                  getDataTableRecord(SecPurchaseIndent[index].DocNo, 14);
                                });
                                //getPerSonalDetalisChek();
                                Navigator.pop(context,);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  IPOReocrd(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {});
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search',
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecIPOIndent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "IPO Indent - " +
                                    SecIPOIndent[index].DocNo.toString() +
                                    "\n" +
                                    "IPO Date - " +
                                    SecIPOIndent[index].DocDate.toString() +
                                    "\n",
                              ),
                              subtitle: Text(SecIPOIndent[index].LocName.toString()),
                              onTap: () {
                                setState(() {
                                  alterdocnum = '0';
                                  Edt_SapRefNo.text = '0';
                                  Edt_SoDate.text = SecIPOIndent[index].DocDate.toString();
                                  Edt_SapRefNo.text = SecIPOIndent[index].DocNo.toString();
                                  alterprodentry = SecIPOIndent[index].DocNo.toString();
                                  alterDocType = "PORW";
                                  alterloccode = SecIPOIndent[index].LocCode.toString();
                                  alterlocname = SecIPOIndent[index].LocName.toString();
                                  CheckIndent = true;
                                  ScreenName = "IPO";
                                  DispatchDocEntry=0;
                                  Holdbtn = false;
                                  Reprint = false;
                                  getDataTableRecord(SecIPOIndent[index].DocNo, 28);
                                });

                                //getPerSonalDetalisChek();
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  DespatchReocrd(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {});
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search',
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecDispatcheDrafmode.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "IPO Indent - " + SecDispatcheDrafmode[index].DocNo.toString() + "\n" +
                                 "IPO Date - " + SecDispatcheDrafmode[index].DocDate.toString() + "\n",
                              ),
                              subtitle: Text(SecDispatcheDrafmode[index].LocName.toString()),
                              onTap: () {
                                setState(() {
                                  alterdocnum = '0';
                                  Edt_SapRefNo.text = '0';
                                  Edt_SoDate.text = SecDispatcheDrafmode[index].DocDate.toString();
                                  Edt_SapRefNo.text = SecDispatcheDrafmode[index].DocNo.toString();
                                  alterprodentry = SecDispatcheDrafmode[index].DocNo.toString();
                                  EdtDocNo.text = SecDispatcheDrafmode[index].DocNo.toString();
                                  alterDocType = "IOP";
                                  alterloccode = SecDispatcheDrafmode[index].LocCode.toString();
                                  alterlocname = SecDispatcheDrafmode[index].LocName.toString();
                                  altervehiclecode = SecDispatcheDrafmode[index].vehicleCode.toString();
                                  altervehiclename = SecDispatcheDrafmode[index].vehicleName.toString();

                                  altersalespersoncode = SecDispatcheDrafmode[index].empId.toString();
                                  altersalespersoname = SecDispatcheDrafmode[index].empName.toString();

                                  DispatchDocEntry = int.parse(SecDispatcheDrafmode[index].DocNo.toString());
                                  CheckIndent = true;
                                  ScreenName = "Open";
                                  Holdbtn = true;
                                  Reprint = false;
                                  getDataTableRecord(SecDispatcheDrafmode[index].DocNo, 26);
                                });

                                //getPerSonalDetalisChek();
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  DespatchReocrdReprint(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {});
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search',
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecDispatcheDrafmode.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "IPO Indent - " + SecDispatcheDrafmode[index].DocNo.toString() + "\n" +
                                    "IPO Date - " + SecDispatcheDrafmode[index].DocDate.toString() + "\n",
                              ),
                              subtitle: Text(SecDispatcheDrafmode[index].LocName.toString()),
                              onTap: () {
                                setState(() {
                                  alterdocnum = '0';
                                  Edt_SapRefNo.text = '0';
                                  Edt_SoDate.text = SecDispatcheDrafmode[index].DocDate.toString();
                                  Edt_SapRefNo.text = SecDispatcheDrafmode[index].DocNo.toString();
                                  alterprodentry = SecDispatcheDrafmode[index].DocNo.toString();
                                  EdtDocNo.text = SecDispatcheDrafmode[index].DocNo.toString();
                                  alterDocType = "IOP";
                                  alterloccode = SecDispatcheDrafmode[index].LocCode.toString();
                                  alterlocname = SecDispatcheDrafmode[index].LocName.toString();
                                  altervehiclecode = SecDispatcheDrafmode[index].vehicleCode.toString();
                                  altervehiclename = SecDispatcheDrafmode[index].vehicleName.toString();

                                  altersalespersoncode = SecDispatcheDrafmode[index].empId.toString();
                                  altersalespersoname = SecDispatcheDrafmode[index].empName.toString();

                                  DispatchDocEntry = int.parse(SecDispatcheDrafmode[index].DocNo.toString());
                                  CheckIndent = false;
                                  ScreenName = "Open";
                                  Holdbtn = false;
                                  Reprint=true;
                                  getDataTableRecord(SecDispatcheDrafmode[index].DocNo, 26);
                                });

                                //getPerSonalDetalisChek();
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<http.Response> postdataheader(DisStatus,DocNo,printstatus) async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "SoEntry": int.parse(Edt_SapRefNo.text),
      "SoNum": int.parse(alterdocnum),
      "SoDate": Edt_SoDate.text,
      "SoDelDate": Edt_SoDelDate.text,
      "PoEntry": int.parse(alterprodentry),
      "WhsCode": alterwhscode,
      "WhsName": alterwhsname,
      "Remarks": altervehiclecode,
      "RefNo": int.parse(altersalespersoncode),
      "UserID": int.parse(sessionuserID),
      "Location": int.parse(alterloccode),
      "Type": alterDocType,
      "DisStatus":DisStatus,
      "DocNo":DocNo
    };
    log(jsonEncode(body));
    print(sessionuserID);
    setState(() {
      loading = true;
    });

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertdespodheader'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'][0]['STATUSNAME']);
          //postdatadetail(jsonDecode(response.body)["docNo"]);
          print(jsonDecode(response.body)['result'][0]['DocNo']);
          postdatadetails(jsonDecode(response.body)['result'][0]['DocNo'],printstatus);
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> postdatadetails(int headerdocno,printstatus) async {
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      //loading = true;
    });
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(
        SendItemTemp(
            headerdocno,
            headerdocno,
            templist[i].itemCode,
            templist[i].itemName,
            templist[i].uom,
            templist[i].qRCode,
            templist[i].packetType,
            templist[i].box,
            templist[i].tray,
            templist[i].weight == null ? 0 : templist[i].weight,
            templist[i].qty,
            templist[i].remarks == null ? "-" : templist[i].remarks,
            templist[i].docNo.toString(),
            '${sessionuserID}',
            alterwhscode,
            templist[i].taxcode.toString(),
            templist[i].price.toString(),
            templist[i].amount.toString(),
            templist[i].totaltaxamt.toString(),
        ),
      );
    print(json.encode(sendtemplist));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertdesdDetail'),
        headers: headers,
        body: jsonEncode(sendtemplist));

    setState(() {
      loading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["status"]);
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        if(printstatus==1){
          NetPrinter(sessionIPAddress, sessionIPPortNo, headerdocno);
         }
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DespatchScreen(),
            ),
          );
        });
      }
      return response;
    } else {
      showDialogboxWarning(context, 'Failed to Login API');
    }
  }

  NetPrinter(String iPAddress, int pORT, int headerdocno,) async {
    log(iPAddress);
    log(pORT.toString());
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

  Future<void> printDemoReceipt(NetworkPrinter printer,headerdocno) async {
    double TotalTaxAmt = 0;
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,), linesAfter: 1);
    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text("OrderDate - " + Edt_SoDelDate.text, styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    printer.row([PosColumn(text: 'Delivery Chalan', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: "Dis No", width: 2, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: headerdocno.toString(), width: 9, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "Transporter Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "Vech No", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altervehiclename.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: "To Location", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: alterlocname.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "Sale OrderNo", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: alterdocnum.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'Item', width: 5, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1),),
      PosColumn(text: 'Amt', width: 2, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1),),
      PosColumn(text: 'Tax %', width: 1, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);
    printer.hr(len: 12);
    for (int i = 0; i < templist.length; i++) {
      printer.row(
        [
          PosColumn(text: templist[i].itemName.toString() + "-" + templist[i].uom.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: templist[i].qty.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: double.parse(templist[i].price.toString()).round().toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: templist[i].taxcode.split("@")[1].toString() + "%", width: 1, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: double.parse(templist[i].amount.toString()).round().toString(),width: 2, styles: PosStyles(align: PosAlign.right)),
        ],
      );
      TotalTaxAmt += double.parse(templist[i].amount.toString());
    }

    printer.hr(ch: '=', linesAfter: 1,len: 12);


    printer.row([
      PosColumn(text: 'Total Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text:  TotalTaxAmt.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);


    List<MyTempTax> SMyTempTax = new List();
    SMyTempTax.clear();

    var set = Set<String>();
    List<getQRModelTemp> selected1 = templist.where((element) => set.add(element.taxcode)).toList();

    for (int i = 0; i < templist.length; i++) {
      for (int j = 0; j < selected1.length; j++) {
        if (i == 0 && j == 0)
          SMyTempTax.add(MyTempTax(templist[i].taxcode, 0, 0, 0));
        //print("${selected1[j].taxcode} == ${templist[i].taxcode.toString()}");
        if (selected1[j].taxcode.toString() ==
            templist[i].taxcode.toString()) if (SMyTempTax.where(
                (element) => element.taxcode == selected1[j].taxcode).length ==
            0) SMyTempTax.add(MyTempTax(templist[i].taxcode, 0, 0, 0));
      }
    }
    for (int i = 0; i < templist.length; i++) {
      for (int k = 0; k < SMyTempTax.length; k++)
        if (SMyTempTax[k].taxcode == templist[i].taxcode) {
          SMyTempTax[k].amt = (double.parse(SMyTempTax[k].amt.toString())+double.parse(templist[i].totaltaxamt.toString())).toString();
          SMyTempTax[k].cent = (double.parse(SMyTempTax[k].cent.toString())+double.parse(templist[i].totaltaxamt.toString()) / 2).toString();
          SMyTempTax[k].sta = (double.parse(SMyTempTax[k].sta.toString()) + double.parse(templist[i].totaltaxamt.toString())/ 2).toString();
        }
    }

    printer.hr(ch: '=', linesAfter: 1);
    log(jsonEncode(SMyTempTax));
    log(0.0.toStringAsFixed(2));
    for (int i = 0; i < SMyTempTax.length; i++) {
      printer.row(
        [
          PosColumn(
            text: SMyTempTax[i].taxcode.toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text:  double.parse(SMyTempTax[i].sta.toString()).toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: double.parse(SMyTempTax[i].cent.toString()).toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right),
          ),
        ],
      );
    }

    printer.feed(2);

    printer.text('Thank you!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('FASSI - ' + sessionContact1,styles: PosStyles(align: PosAlign.center, bold: true));

    printer.feed(1);
    //printer.cut();
    log('OK');
    log(sessionContact1);
    ChildprintDemoReceipt(printer,headerdocno);
  }

  Future<void> ChildprintDemoReceipt(NetworkPrinter printer, headerdocno) async {
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
    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501', styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime), styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.text("Delivery No - " + headerdocno.toString(), styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    printer.text("OrderDate - " + Edt_SoDelDate.text, styles: PosStyles(align: PosAlign.left), linesAfter: 1);

    printer.hr();
    List<ProQrGenerateJson> SecQrGenerateJson=[];
    SecQrGenerateJson.clear();
    var json;
    SecQrGenerateJson.add(
      ProQrGenerateJson(
          headerdocno.toString(),
          ScreenName),
    );
    json = jsonEncode(SecQrGenerateJson.map((e) => e.toJson()).toList());
    print(json);


    printer.feed(2);
    printer.qrcode(json);
    printer.feed(2);
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));

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
        RawProductionTblModel = ProductionTblModel.fromJson(jsonDecode(response.body));
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
                RawProductionTblModel.testdata[i].Stock, //packetType - Stock Qty
                RawProductionTblModel.testdata[i].quantity, //weight OrderQty
                "qRCode",
                RawProductionTblModel.testdata[i].quantity, //Qty ORder Same Qty Aginst Customer
                '',
                '',
                0,
                RawProductionTblModel.testdata[i].taxcode,
                RawProductionTblModel.testdata[i].price,
                RawProductionTblModel.testdata[i].amt,
                RawProductionTblModel.testdata[i].taxamt,
            ),
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
      sessionContact1 = prefs.getString("Contact1");
      _typeAheadController.text = "Open";
      getlocation();
      salesPersonget(1, 1);
      getVEHICLERecord();
      getlocationval();
      //getproductionIdent();
      getItemMaster();

      if(widget.DocType=="IPO"){
        getIPOIdent();

      }else if(widget.DocType=="Sale Order"){

      }

    });
  }

  addmyRow(docNo,docDate,itemGroupCode,itemGroupName,itemCode,itemName,uom,box,tray,packetType,weight,qRCode,qty,
      branchID,remarks,AddType, taxcode, price, amount, totaltaxamt,){
    setState(() {
      CheckIndent=true;
      delectcont=1;
      double totalQty=0;
      double rawtotalQty=0;
      int count=0;
      for(int i = 0 ; i < templist.length;i++){
        if(uom=="Grams"||uom=="Kgs"){
          if(templist[i].itemCode==itemCode.toString() && templist[i].box==box){
            count++;
          }
        }else{
          if(templist[i].itemCode==itemCode.toString()){
            count++;
          }
        }
      }
      if(count==0){

        templist.add(
          getQRModelTemp(
              docNo, docDate, itemGroupCode, itemGroupName, itemCode, itemName, //itemName,
              uom, box, tray, packetType, //packetType - Stock Qty
              weight, //weight OrderQty
              "qRCode", qty.toString(), //Qty ORder Same Qty Aginst Customer
              '', '', 0,taxcode,price,amount,totaltaxamt),
        );

      }else{
        for(int kk = 0 ;kk < templist.length;kk++){
          if(templist[kk].itemCode == itemCode){
            rawtotalQty += double.parse(templist[kk].qty.toString());
            totalQty = double.parse(qty.toString());
            log((rawtotalQty+totalQty).toString());
            if(templist[kk].uom == "Grams" || templist[kk].uom  == "Kgs"){
              templist[kk].qty = (rawtotalQty+totalQty).toStringAsFixed(3);
            }else{
              templist[kk].qty = (rawtotalQty+totalQty).toString();
              templist[kk].amount = (double.parse(templist[kk].price.toString()) * (rawtotalQty+totalQty)).round().toString();
            }
          }
        }
      }
      log("Selva S");
    log(AddType.toString());
      log("Selva E");

      if(AddType==1){
        QrFocusNode.requestFocus();
        QRCodeController.clear();
        log("Focus");
      }else{
        QrCodeAutoFocus = false;
        //QrFocusNode.dispose();

      }
      countval();

    });

  }

  void countval() async {
    setState(() {

      for (int s = 0; s < templist.length; s++) {
        if (double.parse(templist[s].qty.toString()) > 0) {

          if (Edt_SapRefNo.text == '0') {
            templist[s].totaltaxamt = ((double.parse(templist[s].taxcode.split("@")[1]) * double.parse(templist[s].amount.toString())) /100).round();

          } else {
            templist[s].totaltaxamt = ((double.parse(templist[s].taxcode.split("@")[1]) *double.parse(templist[s].amount.toString())) /100).round();

          }
        }
      }

    });


  }

  Future getItemMaster() {
    GetAllMaster(19,0,0).then((response) {

      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          setState(() {
            whsModel = null;
            loading= false;
            //getdocno();
          });
        } else {
          setState(() {
            log(response.body);
            rawGetItemMasterModel = GetItemMasterModel.fromJson(jsonDecode(response.body));
            for(int i = 0 ; i<rawGetItemMasterModel.result.length;i++ ){
              secItemMaster.add(rawGetItemMasterModel.result[i].itemName);
            }

            loading= false;
            //getdocno();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getproductionIdent() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      //templist.clear();
    });
    var body = {
      "FromId": 15,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": 0,
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
        RawPurchaseIndentheaderModel =
            PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++) {
          SecPurchaseIndent.add(
            PurchaseIndent(RawPurchaseIndentheaderModel.testdata[i].docNo,
                RawPurchaseIndentheaderModel.testdata[i].docDate, RawPurchaseIndentheaderModel.testdata[i].LocCode,
                RawPurchaseIndentheaderModel.testdata[i].LocName),
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

  Future<http.Response> getIPOIdent() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecIPOIndent.clear();
    });
    var body = {
      "FromId": 29,
      "ScreenId": 0,
      "DocNo": 0,
      "DocEntry": 0,
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
        RawPurchaseIndentheaderModel = PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++)
        {
          SecIPOIndent.add(
            PurchaseIndent(
              RawPurchaseIndentheaderModel.testdata[i].docNo,
              RawPurchaseIndentheaderModel.testdata[i].docDate,
              RawPurchaseIndentheaderModel.testdata[i].LocCode,
              RawPurchaseIndentheaderModel.testdata[i].LocName,
            ),
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

  Future<http.Response> getDispatchHold() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecDispatcheDrafmode.clear();
    });
    var body = {
      "FromId": 25,
      "ScreenId": 0,
      "DocNo": 0,
      "DocEntry": 0,
      "Status": "Hold",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
   log(jsonEncode(body));

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
        RawPurchaseIndentheaderModel = PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++)
        {
          SecDispatcheDrafmode.add(
            DispatcheDrafmode(
              RawPurchaseIndentheaderModel.testdata[i].docNo,
              RawPurchaseIndentheaderModel.testdata[i].docDate,
              RawPurchaseIndentheaderModel.testdata[i].LocCode,
              RawPurchaseIndentheaderModel.testdata[i].LocName,
              RawPurchaseIndentheaderModel.testdata[i].vehicleCode.toString(),
              RawPurchaseIndentheaderModel.testdata[i].vehicleName,
              RawPurchaseIndentheaderModel.testdata[i].empId.toString(),
              RawPurchaseIndentheaderModel.testdata[i].empName,
              RawPurchaseIndentheaderModel.testdata[i].fassi,
            ),
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

  Future<http.Response> getDispatchReprint() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecDispatcheDrafmode.clear();
    });
    var body = {
      "FromId": 27,
      "ScreenId": 0,
      "DocNo": 0,
      "DocEntry": 0,
      "Status": "Save",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    log(jsonEncode(body));

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
        RawPurchaseIndentheaderModel = PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++)
        {
          SecDispatcheDrafmode.add(
            DispatcheDrafmode(
              RawPurchaseIndentheaderModel.testdata[i].docNo,
              RawPurchaseIndentheaderModel.testdata[i].docDate,
              RawPurchaseIndentheaderModel.testdata[i].LocCode,
              RawPurchaseIndentheaderModel.testdata[i].LocName,
              RawPurchaseIndentheaderModel.testdata[i].vehicleCode.toString(),
              RawPurchaseIndentheaderModel.testdata[i].vehicleName,
              RawPurchaseIndentheaderModel.testdata[i].empId.toString(),
              RawPurchaseIndentheaderModel.testdata[i].empName,
              RawPurchaseIndentheaderModel.testdata[i].fassi,
            ),
          );

        }
        setState(() {
          loading = false;
          log("Selva");
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
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
    //print(sessionuserID);

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
    var body = {"UserID": "${sessionuserID}", "FormID": 11};
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
          EdtDocDate.text = "";
          EdtDocNo.text = "";
        } else {
          setState(() {
            EdtDocDate.text = "";
            EdtDocNo.text = "";
            print(response.body);
            print(jsonDecode(response.body)['result'][0]['PURDate']);
            EdtDocDate.text = jsonDecode(response.body)['result'][0]['PURDate'].toString();
            EdtDocNo.text = jsonDecode(response.body)['result'][0]['PURDocNo'].toString();
            //EdtDocNo.text = jsonDecode(response.body)['result']['PURDocNo'];
            getWhs();
            loading = false;
          });
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
          loading = false;
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getSaleslist(docno) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"OrderNo": docno};
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

          for (int i = 0; i < salesordermodel.result.length; i++)
          alterdocentry = salesordermodel.result[0].docEntry.toString(); // Sap DocEntry
          alterdocnum = salesordermodel.result[0].docNum.toString(); //MobDocNo
          alterdocdate = salesordermodel.result[0].docDate.toString(); //
          alterdeldate = salesordermodel.result[0].docDueDate.toString();
          alterprodentry = salesordermodel.result[0].prodEntry.toString();
          Edt_SoDate.text = alterdocdate.substring(0, 10);
          Edt_SoDelDate.text = alterdeldate.substring(0, 10);
          Edt_SapRefNo.text = alterdocentry;
          alterloccode = salesordermodel.result[0].BranchID.toString();
          alterlocname = salesordermodel.result[0].Branch.toString();
          alterDocType = 'CusSaleOrder';
          CheckIndent = false;
          Reprint = false;

          //OpenProductionLayout = false;
          getDataTableRecord(int.parse(Edt_SapRefNo.text), 11);
          loading = false;
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

            log(response.body);

            whsModel = WhsModel.fromJson(jsonDecode(response.body));

            alterwhscode = whsModel.result[2].whsCode;
            alterwhsname = whsModel.result[2].whsName;
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
        });
      }
      return response;
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

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes = "";
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;
  //
  //   setState(() {
  //     print(barcodeScanRes);
  //   });
  // }
}

class PurchaseIndent {
  var DocNo;
  var DocDate;
  var LocCode;
  var LocName;
  PurchaseIndent(this.DocNo, this.DocDate, this.LocCode, this.LocName);
}

class DispatcheDrafmode {
  var DocNo;
  var DocDate;
  var LocCode;
  var LocName;
  var vehicleCode;
  var vehicleName;
  var empId;
  var empName;
  var fassi;
  DispatcheDrafmode(this.DocNo, this.DocDate, this.LocCode, this.LocName,this.vehicleCode,
      this.vehicleName,this.empId,this.empName,this.fassi);
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
  var taxcode;
  var price;
  var amount;
  var totaltaxamt;

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
      this.Status,this.taxcode, this. price, this. amount, this. totaltaxamt);
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
  var TaxCode;
  var Price;
  var Amt;
  var TaxAmt;

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
      this.WhsCode,
      this.TaxCode,
      this.Price,
      this.Amt,
      this.TaxAmt);

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
        'WhsCode': WhsCode,
        'TaxCode':TaxCode,
        'Price':Price,
        'Amt':Amt,
        'TaxAmt':TaxAmt
      };
}

class ProQrGenerateJson {
  var OrderNo;
  var type;
  ProQrGenerateJson(this.OrderNo, this.type);
  Map toJson() => {
    'OrderNo': OrderNo,
    'Type': type,
  };
}


class MyTempTax {
  var taxcode;
  var amt;
  var sta;
  var cent;
  MyTempTax(this.taxcode, this.amt, this.sta, this.cent);

  Map<String, dynamic> toJson() => {
    'taxcode': taxcode,
    'amt': amt,
    'sta': sta,
    'cent': cent
  };

}