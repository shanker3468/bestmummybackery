// ignore_for_file: non_constant_identifier_names, missing_return, deprecated_member_use, must_be_immutable, unnecessary_statements

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/Mixboxmodel.dart';
import 'package:bestmummybackery/Masters/PriceListSyncModel.dart';
import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/GetIPAddressModel.dart';
import 'package:bestmummybackery/Model/MixBoxChild.dart';
import 'package:bestmummybackery/Model/MySaleOrderGetLIneData.dart';
import 'package:bestmummybackery/Model/MySaleOrderGetPaymentData.dart';
import 'package:bestmummybackery/Model/MyTranctionGetLineModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/Model/Saleshiftmodel.dart';
import 'package:bestmummybackery/Model/StateModel.dart';
import 'package:bestmummybackery/Model/TransportCountModel.dart';
import 'package:bestmummybackery/Model/countryModel.dart';
import 'package:bestmummybackery/MyBluetoothprinter.dart';
import 'package:bestmummybackery/RequestTransferScreen.dart';
import 'package:bestmummybackery/TransactionScreen.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class SalesInvoiceOffline extends StatefulWidget {
  int ScreenID = 0;
  String ScreenName = "";
  int OrderNo = 0;
  var isIgnore = false;
  var NetWorkCheckNumter = 0;

  SalesInvoiceOffline({Key key, this.ScreenID, this.ScreenName, this.OrderNo, this.isIgnore, this.NetWorkCheckNumter}) : super(key: key);

  @override
  SalesInvoiceOfflineState createState() => SalesInvoiceOfflineState();
}

class SalesInvoiceOfflineState extends State<SalesInvoiceOffline> {
  bool checkedValue = false;
  int mainorderno = 0;
  int orderno1 = 0;
  int paymentorderno = 0;
  bool delstatelayout = false;
  bool delstateplace = false;
  bool delstateremarks = false;
  String colorchange = "";
  Database database;
  List<SalesTempItemResult> templist = new List();
  List<SalesPayment> paymenttemplist = new List();
  List<SalesSendPayment> sendpaymenttemplist = new List();
  List<SalesTempItemResultSend> sendtemplist = new List();
  TextEditingController SearchController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  TextEditingController Edt_Total = new TextEditingController();
  TextEditingController Edt_Advance = new TextEditingController(text: "0");
  TextEditingController Edt_Balance = new TextEditingController();
  TextEditingController Edt_Delcharge = new TextEditingController(text: "0");
  TextEditingController Edt_Disc = new TextEditingController(text: "0");
  TextEditingController Edt_CustCharge = new TextEditingController(text: "0");
  TextEditingController Edt_Tax = new TextEditingController();
  TextEditingController Edt_Mobile = new TextEditingController(text: "0");
  TextEditingController Edt_UserLoyalty = new TextEditingController(text: "0");
  TextEditingController Edt_Loyalty = new TextEditingController(text: "0");
  var Edt_Adjustment = new TextEditingController();
  TextEditingController BalancePoints = new TextEditingController();
  TextEditingController Edt_Credit = new TextEditingController();
  TextEditingController Edt_CareOf = new TextEditingController();
  TextEditingController BalanceAmount = new TextEditingController();
  TextEditingController DelReceiveAmount = new TextEditingController();
  List<TextEditingController> qtycontroller = new List();
  TextEditingController Edt_PayRemarks = new TextEditingController();
  TextEditingController Edt_BlanceBillAmt = new TextEditingController();
  TextEditingController Edt_TotalBillAmt = new TextEditingController();
  TextEditingController Edt_ReciveAmt = new TextEditingController();
  TextEditingController Edt_NetTotal = new TextEditingController(text: "0");
  String selectedDate = "";

  var TextClicked;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;
  var MyBeforeDebug = '';
  var MyAterDebug = '';
  var MyShitId=0;

  bool loading = false;
  bool isSelected = false;
  String altersalespersoname = "";
  String altersalespersoncode = "";
  String alterpayment = "Select";
  String search = "";
  double batchcount = 0;
  int onclick = 0;
  OccModel models;

  //DataTableSource datalist;
  var altercountrycode = "";
  var alterstatecode = "";
  var altercareofcode = "";
  var altercareofname = "";
  Widget appBarTitle;
  // Printer Varibles
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  BluetoothDevice _device;
  String pathImage;
  NetworkPrinter printer;
  var BillCurrentDate;
  var BillCurrentTime;
  var NextBill;
  MyBluetoothPrinter MyPrinter;
  MySaleOrderGetLIneData RawMySaleOrderGetLIneData; //Line Data Returen
  MySaleOrderGetPaymentData RawMySaleOrderGetPaymentData;
  int Bluetoothckecking = 0;
  GetIPAddressModel RawGetIPAddressModel;
  Mixboxmodel RawMixboxmodel;

  // NET WORK PRINTER

  MyTranctionGetLineModel RawMyHoldGetLineModel;
  var HoldDocLine = 0;
  var MyBillNo;

  PriceListSyncModel RawPriceListSyncModel;
  TransportCountModel RawTransportCountModel;
  MixBoxChild RawMixBoxChild;
  Saleshiftmodel RawSaleshiftmodel;

  List<MyMixBoxMaster> SecMyMixBoxMaster = new List();
  List<SaveMixBoxMaster> TepmSaveMixBoxMaster = new List();
  String tdata;

  @override
  void dispose() {
    if (database.isOpen) database.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    tdata = DateFormat("hh:mm:ss a").format(DateTime.now());
    getStringValuesSF();

    initSavetoPath();
    initPlatformState();
    appBarTitle = new Text(widget.ScreenName);
    super.initState();
    BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    NextBill = DateFormat('ddMMyyyy').format(DateTime.now());
    BillCurrentTime = DateFormat.jm().format(DateTime.now());
    //print(widget.NetWorkCheckNumter.toString() + "Error 404");
  }

  NetPrinter(String iPAddress, int pORT,) async {

    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printDemoReceipt(printer);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: $e');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {
    double TotalCash = 0;
    double TotalCard = 0;
    double TotalUPI = 0;
    double TotalOther = 0;
    double TotalTaxAmt = 0;
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,), linesAfter: 1);
    printer.text((sessionbranchname),
        styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.row([PosColumn(text: 'Sale Invoice - Original', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: "Bill No", width: 2, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: MyBillNo.toString(), width: 9, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "Sale Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "CusNo", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Edt_Mobile.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
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
          PosColumn(text: templist[i].itemName.toString() + "-" + templist[i].uOM.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: templist[i].qty.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: double.parse(templist[i].price.toString()).round().toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: templist[i].TaxCode.split("@")[1].toString() + "%", width: 1, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: double.parse(templist[i].amount.toString()).round().toString(),width: 2, styles: PosStyles(align: PosAlign.right)),
        ],
      );
      TotalTaxAmt += double.parse(templist[i].tax.toString());
    }

    printer.hr(ch: '=', linesAfter: 1,len: 12);
    for (int i = 0; i < paymenttemplist.length; i++) {
      if (paymenttemplist[i].PaymentName == 'Cash') {
        TotalCash += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      else if (paymenttemplist[i].PaymentName == 'Card') {
        TotalCard += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      else if (paymenttemplist[i].PaymentName == 'UPI') {
        TotalUPI += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      else if (paymenttemplist[i].PaymentName == 'Others') {
        TotalOther += double.parse(paymenttemplist[i].ReceivedAmount);
      }
    }

    printer.row([
      PosColumn(text: 'Cash', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: TotalCash.toString(), width: 5, styles: PosStyles(align: PosAlign.right,width: PosTextSize.size1,fontType: PosFontType.fontA)),
    ]);
    printer.row([
      PosColumn(text: 'Card', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: TotalCard.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1,fontType: PosFontType.fontA)),
    ]);

    printer.row([
      PosColumn(text: 'UPI', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: TotalUPI.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1,fontType: PosFontType.fontA)),
    ]);
    printer.row([
      PosColumn(text: 'Others', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: TotalOther.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1,fontType: PosFontType.fontA)),
    ]);

    printer.feed(2);

    printer.row([
      PosColumn(text: 'Total Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text:  Edt_Total.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    printer.row([
      PosColumn(text: 'Recevie Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_ReciveAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    printer.row([
      PosColumn(text: 'Balance Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_BlanceBillAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    List<MyTempTax> SMyTempTax = new List();
    SMyTempTax.clear();
    var set = Set<String>();
    List<SalesTempItemResult> selected1 = templist.where((element) => set.add(element.TaxCode)).toList();

    for (int i = 0; i < templist.length; i++) {
      for (int j = 0; j < selected1.length; j++) {
        if (i == 0 && j == 0)
          SMyTempTax.add(MyTempTax(templist[i].TaxCode, 0, 0, 0));
        print("${selected1[j].TaxCode} == ${templist[i].TaxCode.toString()}");
        if (selected1[j].TaxCode.toString() ==
            templist[i].TaxCode.toString()) if (SMyTempTax.where(
                (element) => element.taxcode == selected1[j].TaxCode).length ==
            0) SMyTempTax.add(MyTempTax(templist[i].TaxCode, 0, 0, 0));
      }
    }
    for (int i = 0; i < templist.length; i++) {
      for (int k = 0; k < SMyTempTax.length; k++)
        if (SMyTempTax[k].taxcode == templist[i].TaxCode) {
          SMyTempTax[k].amt = SMyTempTax[k].amt + templist[i].tax;
          SMyTempTax[k].cent = SMyTempTax[k].cent + templist[i].tax / 2;
          SMyTempTax[k].sta = SMyTempTax[k].sta + templist[i].tax / 2;
        }
    }

    printer.hr(ch: '=', linesAfter: 1);
    for (int i = 0; i < SMyTempTax.length; i++) {
      printer.row(
        [
          PosColumn(
            text: SMyTempTax[i].taxcode.toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: SMyTempTax[i].sta.toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: SMyTempTax[i].cent.toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right),
          ),
        ],
      );
    }

    printer.feed(2);

    printer.text('Thank you!',styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.cut();

    ChildprintDemoReceipt(printer);
  }


  Future<void> ChildprintDemoReceipt(NetworkPrinter printer) async {
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,), linesAfter: 1);
    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.row([PosColumn(text: 'Sale Invoice - Duplicate', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: "Bill No", width: 2, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: MyBillNo.toString(), width: 9, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: "Sale Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: 'Total Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text:  Edt_Total.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    printer.feed(2);
    printer.cut();
  }

  TextMethod() {
    List<MyTempTax> SMyTempTax = new List();
    SMyTempTax.clear();

    var set = Set<String>();
    List<SalesTempItemResult> selected1 =
        templist.where((element) => set.add(element.TaxCode)).toList();
    log(jsonEncode(selected1));
    print(templist.length);
    print(selected1.length);
    for (int i = 0; i < templist.length; i++) {
      for (int j = 0; j < selected1.length; j++) {
        if (i == 0 && j == 0)
          SMyTempTax.add(MyTempTax(templist[i].TaxCode, 0, 0, 0));
        print("${selected1[j].TaxCode} == ${templist[i].TaxCode.toString()}");
        if (selected1[j].TaxCode.toString() ==
            templist[i].TaxCode.toString()) if (SMyTempTax.where(
                (element) => element.taxcode == selected1[j].TaxCode).length ==
            0) SMyTempTax.add(MyTempTax(templist[i].TaxCode, 0, 0, 0));
      }
    }
    for (int i = 0; i < templist.length; i++) {
      for (int k = 0; k < SMyTempTax.length; k++)
        if (SMyTempTax[k].taxcode == templist[i].TaxCode) {
          SMyTempTax[k].amt = SMyTempTax[k].amt + templist[i].tax;
          SMyTempTax[k].cent = SMyTempTax[k].cent + templist[i].tax / 2;
          SMyTempTax[k].sta = SMyTempTax[k].sta + templist[i].tax / 2;
        }
    }
    log(jsonEncode(
      SMyTempTax.map((e) => e.toJson()).toList(),
    ));
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'logo.jpg';
    var bytes = await rootBundle.load("assets/logo.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    print('initPlatformState Method -2');

    bool isConnected = await bluetooth.isConnected;
    try {
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {

            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
    });

    if (isConnected) {
      setState(() {
      });
    }
  }

  // _connect() {
  //   print('Connet');
  //   print(jsonEncode(_device.toMap()));
  //   if (_device == null) {
  //     //show('No device selected.');
  //     print(' if Connect');
  //   } else {
  //     print(' else Connect MyConnet');
  //     bluetooth.isConnected.then((isConnected) {
  //       if (!isConnected) {
  //         bluetooth.connect(_device).catchError((error) {
  //           setState(() => _connected = false);
  //         });
  //         setState(() => _connected = true);
  //       }
  //     });
  //   }
  // }
  //
  // void _disconnect() {
  //   bluetooth.disconnect();
  //   setState(() => _connected = false);
  // }

  void BlutoothPrindfst() {
    print('Print Mode...');
    print(jsonEncode(_device.toMap()));

    double TotalAmt = 0;
    double TotalCash = 0;
    double TotalCard = 0;
    bluetooth.printNewLine();
    // bluetooth.printImage(pathImage);
    bluetooth.printNewLine();

    bluetooth.printCustom("Hajiyar Complex,", 2, 0, charset: "windows-1250");

    bluetooth.printCustom(sessionbranchname, 2, 0, charset: "windows-1250");
    bluetooth.printCustom("Ramnad, TN 623501 ", 2, 0, charset: "windows-1250");
    bluetooth.printCustom("07904996060", 1, 0, charset: "windows-1250");
    bluetooth.printCustom(BillCurrentDate, 1, 0, charset: "windows-1250");
    bluetooth.printCustom(BillCurrentTime, 1, 0, charset: "windows-1250");
    bluetooth.printNewLine();
    bluetooth.printCustom("Bestmummy Sweet & Cakes", 3, 1,
        charset: "windows-1250");

    bluetooth.printNewLine();
    bluetooth.printCustom("PURCHASE", 3, 1);
    bluetooth.printCustom(
      '------------------------------------------------',
      3,
      1,
    );
    bluetooth.printCustom("Ticket  :" + " - #94", 1, 0);
    bluetooth.printCustom("Recepit :" + " - f5LR", 1, 0);
    bluetooth.printCustom("FOR HERE", 3, 1);
    bluetooth.printCustom(
      '------------------------------------------------',
      3,
      1,
    );
    for (int i = 0; i < templist.length; i++) {
      bluetooth.printCustom(
          templist[i].qty.toString() + " X " + templist[i].itemName, 1, 0);
      bluetooth.printCustom("Rs. " + templist[i].amount.toString(), 1, 2);
      TotalAmt += double.parse(templist[i].amount.toString());
    }
    bluetooth.printCustom(
      '------------------------------------------------',
      3,
      1,
    );

    for (int i = 0; i < paymenttemplist.length; i++) {
      if (paymenttemplist[i].PaymentName == 'Cash') {
        TotalCash += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      if (paymenttemplist[i].PaymentName == 'Card') {
        TotalCard += double.parse(paymenttemplist[i].ReceivedAmount);
      }
    }

    bluetooth.printCustom("Total     " + "Rs." + TotalAmt.toString(), 1, 2);
    bluetooth.printCustom("Cash      " + "Rs." + TotalCash.toString(), 1, 2);
    bluetooth.printCustom("Card      " + "Rs." + TotalCard.toString(), 1, 2);

    bluetooth.printNewLine();
    bluetooth.paperCut();
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  int currentIndex = 0;
  CategoriesModel categoryitem;
  SalesItemModel itemodel;
  EmpModel salespersonmodel;

  List<String> salespersonlist = new List();
  List<String> careoflist = new List();

  int rowcount = 0;

  var batchamount1 = 0;
  var taxamount = 0;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  var DelDateController = new TextEditingController();
  var OccDateController = new TextEditingController();

  OccModel occModel = new OccModel();

  countryModel countryModell = new countryModel();
  StateModel stateModel = new StateModel();

  List<String> loc = new List();
  List<String> occ = new List();

  List<String> countrylist = new List();
  List<String> statelist = new List();

  String alteroccname = "";
  String alterocccode = "";

  String altersalespersonname;
  int settlementisclicked = 0;
  int NextBillNo = 0;

  double getvalue = 0;
  bool loyalcheckboxValue = false;
  bool careofcheckboxValue = false;
  final pagecontroller = PageController(
    initialPage: 0,
  );
  var EditQRCode = new TextEditingController();

  QRCodeAddTempList(BuildContext context) {
    // addItemToList(itemCode, itemName, itmsGrpCod, uOM, price, amount, qty, itmsGrpNam, picturName, imgUrl, tax, stock)
    print(EditQRCode.text);
    var TotalAmt;
    final decode = jsonDecode(EditQRCode.text);
    print(decode[0]["ItemName"].toString());
    for (int i = 0; i < itemodel.result.length; i++) {
      if (itemodel.result[i].itemCode == decode[0]["ItemName"].toString()) {
        //TotalAmt = itemodel.result[i].amount * double.parse(decode[0]["Wight"]);
        addItemToList(
            itemodel.result[i].itemCode,
            itemodel.result[i].itemName,
            itemodel.result[i].itmsGrpCod,
            itemodel.result[i].uOM,
            itemodel.result[i].price,
            decode[0]["Price"],
            decode[0]["Wight"].toString(),
            itemodel.result[i].itmsGrpNam,
            itemodel.result[i].picturName,
            itemodel.result[i].imgUrl,
            itemodel.result[i].TaxCode.split("@")[1],
            itemodel.result[i].onHand,
            itemodel.result[i].Varince,
            itemodel.result[i].TaxCode,0);
      }
    }
    ShowDialog(context);
  }

  Future<http.Response> ShowDialog(BuildContext context) async {
    EditQRCode.text = '';

    showDialog(
      context: context,
      builder: (BuildContext contex1) => AlertDialog(
        content: TextFormField(
          autofocus: true,
          controller: EditQRCode,
          onEditingComplete: () {
            setState(() {
              Navigator.pop(context);
              QRCodeAddTempList(context);
            });
          },
        ),
        actions: <Widget>[
          Column(
            children: [
              Row(
                children: [
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(contex1,'Ok',);
                        });
                      },
                      child: const Text("Ok"),
                    ),
                  ),
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

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    var assetsImage = new AssetImage('assets/imgs/splashanim.gif');
    var image = new Image(image: assetsImage, height: MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: SafeArea(
              child: Scaffold(
                appBar: tablet?
                AppBar(
                      title: Text(widget.ScreenName +"-Ip Address Is-" +sessionIPAddress.toString() +"-Port is-" +sessionIPPortNo.toString(),style: TextStyle(fontSize: 20),),
                      actions: [
                        Badge(
                          position: BadgePosition.topEnd(top: 0, end: 3),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(RawTransportCountModel == null ? '0' : RawTransportCountModel.result.length.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          child: TextButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: MyTransportcount(context),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 100,
                              width: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.all(Radius.circular(30),),
                              ),
                              child: Text('Request',style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                        TextButton(
                          onPressed: () {
                            GetMyHoldRocord().then(
                              (value) => showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: MyHoldReocrd(context),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.all(Radius.circular(30),),),
                            child: Text('MyHold',style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                        IconButton(
                          icon: Icon(Icons.folder),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => TransactionScreen(
                                  ScreenId: 2,
                                  ScreenName: "Sales Invoices",
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 50),
                        ElevatedButton(
                          onPressed: () {
                            MyPriceListSync();
                          },
                          child: Text(
                            MyBillNo.toString(),
                          ),
                        ),
                        SizedBox(width: 50),
                        ],
                      ):
                    //Mobile AppBar
                PreferredSize(
                   preferredSize: Size.fromHeight(height/9),
                  child: AppBar(title: Text('Sale Invoice'),
                      actions: [
                        Badge(
                          position: BadgePosition.topEnd(top: 0, end: 3),
                              animationDuration: Duration(milliseconds: 300),
                              animationType: BadgeAnimationType.slide,
                              badgeContent: Text(RawTransportCountModel == null ? '0' : RawTransportCountModel.result.length.toString(),
                            style: TextStyle(color: Colors.white),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: MyTransportcount(context),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: height/15,
                                  width: width/8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Request',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                        ),
                        SizedBox(width: width/80),
                        TextButton(
                            onPressed: () {
                              GetMyHoldRocord().then((value) => showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: MyHoldReocrd(context),
                                    );
                                  },
                                ),
                              );
                            },
                              child: Container(
                                height: height/15,
                                width: width/8,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.all(Radius.circular(30),),),
                                child: Text('MyHold',style: TextStyle(color: Colors.white),
                                ),
                              ),
                        ),
                        SizedBox(width: width/80),
                        IconButton(
                                icon: Icon(Icons.folder),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => TransactionScreen(
                                        ScreenId: 2,
                                        ScreenName: "Sales Invoices",
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(width: width/80),
                        ElevatedButton(
                              onPressed: () {
                                MyPriceListSync();
                              },
                              child: Text(
                                MyBillNo.toString(),
                              ),),
                        SizedBox(width: width/80),]),
                    ),
                  body: loading
                      ? Container(
                          decoration: new BoxDecoration(color: Colors.white),
                          child: new Center(
                            child: image,
                          ),
                        )
                      : Center(
                          child: tablet
                              ? IgnorePointer(
                                  ignoring: widget.isIgnore,
                                child: PageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: pagecontroller,
                                    onPageChanged: (page) => {
                                      print(page.toString(),),
                                    },
                                    pageSnapping: true,
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      Container(
                                        color: Colors.white,
                                        width: width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 1),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    categoryitem != null
                                                        ? Container(
                                                            child: SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children: [
                                                                  for (int cat = 0; cat < categoryitem.result.length; cat++)
                                                                    Container(
                                                                      margin: EdgeInsets.all(12),
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          TextClicked = altercategoryName = categoryitem.result[cat].name;
                                                                          print("TextClicked$TextClicked");
                                                                          colorchange = categoryitem.result[cat].code.toString();
                                                                          onclick = 1;
                                                                          altercategoryName = categoryitem.result[cat].name;
                                                                          altercategorycode = categoryitem.result[cat].code.toString().isEmpty
                                                                              ? 0
                                                                              : categoryitem.result[cat].code.toString();
                                                                          print(
                                                                              'call THisITEM');
                                                                          getdetailitemsoffline(categoryitem.result[cat].code.toString().isEmpty 
                                                                              ? 0 : categoryitem.result[cat].code.toString(), onclick);

                                                                          setState(() {});
                                                                        },
                                                                        child: Center(
                                                                          child:
                                                                              Container(
                                                                                height: MediaQuery.of(context).size.height / 30,
                                                                                width: 150,
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.all(2),
                                                                                decoration: BoxDecoration(color: Colors.blue, 
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10),
                                                                                      ),
                                                                                    ),
                                                                                    child: Text(categoryitem.result[cat].name,
                                                                                      textAlign:TextAlign.center,
                                                                                      style: TextClicked ==categoryitem.result[cat].name
                                                                                  ? TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold)
                                                                                  : TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                                                                    maxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: height,
                                                        width: width,
                                                        child: itemodel != null
                                                            ? GridView.count(
                                                                childAspectRatio: 0.9,
                                                                crossAxisCount: 5,
                                                                mainAxisSpacing: 0,
                                                                children: [
                                                                  for (int cat = 0;cat <itemodel.result.length;cat++)
                                                                    if (itemodel.result[cat].itemName.toLowerCase().contains(search.toLowerCase()))
                                                                      InkWell(
                                                                        onTap: () {
                                                                          if (itemodel.result[cat].uOM == "Grams" ||itemodel.result[cat].uOM =="Kgs") {
                                                                            showDialog< void>(
                                                                              context: context, barrierDismissible: false,
                                                                              // user must tap button!
                                                                              builder: (BuildContext context) {
                                                                                return Dialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(50),
                                                                                  ),
                                                                                  elevation: 0,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  child: MyClac(
                                                                                      context,
                                                                                      itemodel.result[cat].itemCode,
                                                                                      itemodel.result[cat].itemName,
                                                                                      itemodel.result[cat].itmsGrpCod,
                                                                                      itemodel.result[cat].uOM,
                                                                                      itemodel.result[cat].price,
                                                                                      itemodel.result[cat].amount,
                                                                                      itemodel.result[cat].itmsGrpNam,
                                                                                      itemodel.result[cat].picturName,
                                                                                      itemodel.result[cat].imgUrl,
                                                                                      (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) / 100,
                                                                                      itemodel.result[cat].onHand,
                                                                                      itemodel.result[cat].Varince,
                                                                                      itemodel.result[cat].TaxCode,
                                                                                      tablet, height, width),
                                                                                );
                                                                              },
                                                                            );
                                                                          }

                                                                          else if (itemodel.result[cat].uOM == "MixBox") {
                                                                            SecMyMixBoxMaster.clear();
                                                                            double TotalQty = 0;
                                                                            int count = 0;
                                                                            for (int i = 0; i <templist.length;i++) {
                                                                              if (templist[i].itemCode ==itemodel.result[cat].itemCode)
                                                                              {
                                                                                print("mcjc");
                                                                                count=int.parse(templist[i].ComboNo.toString()) ;
                                                                                print("aaaaaaa");
                                                                               }
                                                                            }

                                                                            for (int i = 0; i < RawMixBoxChild.result.length; i++) {
                                                                              if (RawMixBoxChild.result[i].refItemCode ==
                                                                                  itemodel.result[cat].itemCode) {
                                                                                TotalQty += RawMixBoxChild.result[i].qty;
                                                                                SecMyMixBoxMaster.add(
                                                                                  MyMixBoxMaster(
                                                                                      RawMixBoxChild.result[i].refItemCode,
                                                                                      RawMixBoxChild.result[i].itemCode,
                                                                                      RawMixBoxChild.result[i].itemName,
                                                                                      RawMixBoxChild.result[i].qty,
                                                                                      RawMixBoxChild.result[i].qty,
                                                                                      RawMixBoxChild.result[i].uom,
                                                                                      count + 1,
                                                                                      0),
                                                                                );
                                                                              }
                                                                            }

                                                                            showDialog<void>(context: context,barrierDismissible: false,
                                                                              builder: (BuildContext context) {
                                                                                return Dialog(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(50),),
                                                                                    elevation: 0,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    child: MyMixBoxDilog(
                                                                                        context,
                                                                                        itemodel.result[cat].itemCode,
                                                                                        itemodel.result[cat].itemName,
                                                                                        itemodel.result[cat].itmsGrpCod,
                                                                                        itemodel.result[cat].uOM,
                                                                                        itemodel.result[cat].price,
                                                                                        itemodel.result[cat].amount,
                                                                                        itemodel.result[cat].itmsGrpNam,
                                                                                        itemodel.result[cat].picturName,
                                                                                        itemodel.result[cat].imgUrl,
                                                                                        (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) / 100,
                                                                                        itemodel.result[cat].onHand,
                                                                                        itemodel.result[cat].Varince,
                                                                                        itemodel.result[cat].TaxCode,
                                                                                        TotalQty,
                                                                                        count+1,
                                                                                        tablet,
                                                                                        height,
                                                                                        width));
                                                                              },
                                                                            );
                                                                          } else {
                                                                            print(cat);
                                                                            addItemToList(
                                                                                itemodel.result[cat].itemCode,
                                                                                itemodel.result[cat].itemName,
                                                                                itemodel.result[cat].itmsGrpCod,
                                                                                itemodel.result[cat].uOM,
                                                                                itemodel.result[cat].price,
                                                                                itemodel.result[cat].amount,
                                                                                1,
                                                                                itemodel.result[cat].itmsGrpNam,
                                                                                itemodel.result[cat].picturName,
                                                                                itemodel.result[cat].imgUrl,
                                                                                (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) / 100,
                                                                                itemodel.result[cat].onHand,
                                                                                itemodel.result[cat].Varince,
                                                                                itemodel.result[cat].TaxCode,0);
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          padding:const EdgeInsets.all(2.0),
                                                                          child: Card(
                                                                            elevation: 5,
                                                                            clipBehavior:Clip.antiAlias,
                                                                            child: Stack(
                                                                              alignment:Alignment.center,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                                                  crossAxisAlignment:CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding:const EdgeInsets.all(2.0),
                                                                                      child: itemodel.result[cat].imgUrl != "assets/Images/"
                                                                                          ? Image.asset(
                                                                                              itemodel.result[cat].imgUrl,
                                                                                              height: height / 10,
                                                                                            )
                                                                                          : CircleAvatar(
                                                                                              radius: 30.0,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                                                  itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Center(
                                                                                          child: TextField(
                                                                                            controller: TextEditingController(
                                                                                                text: "${itemodel.result[cat].itemName}\n"
                                                                                                    "Rs.${double.parse(itemodel.result[cat].price.toString()).round()}\n"
                                                                                                    "${itemodel.result[cat].Varince}\n"),
                                                                                            decoration: InputDecoration(
                                                                                              border: InputBorder.none,
                                                                                              contentPadding: EdgeInsets.all(0),),
                                                                                            minLines: 3,
                                                                                            maxLines: 3,
                                                                                            enabled: false,
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontSize: 12),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Positioned(
                                                                                  right:0,
                                                                                  top: 0,
                                                                                  child:
                                                                                      InkWell(
                                                                                          onTap:() {
                                                                                              print('ok');
                                                                                              print('FLAGG${itemodel.result[cat].flag}');
                                                                                        },
                                                                                                child: Center(),
                                                                                  ),
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
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 0.0),
                                                  child: SingleChildScrollView(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 70,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                                                  width:double.infinity / 2,
                                                                  decoration:BoxDecoration(
                                                                    color: Colors.black12,
                                                                    borderRadius:BorderRadius.circular(15),),
                                                                  child: TextField(
                                                                    controller:editingController,
                                                                    autofocus: false,
                                                                    onChanged: (val) {
                                                                      setState(() {
                                                                        search = val;
                                                                      });
                                                                    },
                                                                    decoration:InputDecoration(
                                                                      suffixIcon:IconButton(
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            search = "";
                                                                            editingController.clear();
                                                                          });
                                                                        },
                                                                        icon: Icon(Icons.clear),),
                                                                      border: InputBorder.none,
                                                                      hintText:'Search Item...',
                                                                      prefixIcon: Padding(
                                                                        padding:const EdgeInsets.all(1),
                                                                        child: Icon(Icons.search),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: MediaQuery.of(context).size.height /15,
                                                                  child: DropdownSearch<String>(
                                                                    mode: Mode.MENU,
                                                                    showSearchBox: true,
                                                                    items:salespersonlist,
                                                                    label: "Sales Person",
                                                                    onChanged: (val) {
                                                                      print(val);
                                                                      for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                                        if (salespersonmodel.result[kk].name ==val) {
                                                                          altersalespersoname =salespersonmodel.result[kk].name;
                                                                          altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                                                          var EnterMobileNo;
                                                                          if (Edt_Mobile.text =='0') {
                                                                            showDialog(
                                                                              context:context,
                                                                              builder: (BuildContext contex1) =>
                                                                                  AlertDialog(
                                                                                    content:TextFormField(
                                                                                    keyboardType:TextInputType.number,
                                                                                    maxLength:10,
                                                                                    autofocus:true,
                                                                                    onChanged:(vvv) {
                                                                                    EnterMobileNo = vvv;
                                                                                    if (EnterMobileNo.toString().length ==10) {
                                                                                      Edt_Mobile.text =
                                                                                          EnterMobileNo;
                                                                                      Navigator.pop(contex1);
                                                                                      }
                                                                                    },
                                                                                    ),
                                                                                      title: Text("Enter Mobile no"),
                                                                                      actions: <Widget>[
                                                                                      Column(
                                                                                          children: [
                                                                                          Row(
                                                                                            children: [
                                                                                                Container(
                                                                                                    child: TextButton(
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          Edt_Mobile.text = EnterMobileNo;
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
                                                                        }
                                                                      }
                                                                    },
                                                                    selectedItem:altersalespersoname,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:EdgeInsets.only(top: 0),
                                                          color: Colors.white,
                                                          height: height * 0.5,
                                                          width: width,
                                                          child: SingleChildScrollView(
                                                            scrollDirection:Axis.vertical,
                                                            child: SingleChildScrollView(
                                                              scrollDirection:Axis.horizontal,
                                                              child: templist.length == 0
                                                                  ? Center(
                                                                      child: Text('No Data Add!'),)
                                                                  : DataTable(
                                                                      sortColumnIndex: 0,
                                                                      sortAscending: true,
                                                                      columnSpacing: 25,
                                                                      dataRowHeight: 55,
                                                                      headingRowHeight:30,
                                                                      headingRowColor:MaterialStateProperty.all(Colors.blue),
                                                                      showCheckboxColumn:false,
                                                                      columns: const <DataColumn>[
                                                                        DataColumn(
                                                                          label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text('Qty',style: TextStyle(color: Colors.white),),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text('Amount',style: TextStyle(color: Colors.white),),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text('TAx',style: TextStyle(color: Colors.white),),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text('TAX %',style: TextStyle(color: Colors.white),),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text('Romove',style: TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                      rows: templist.where((element) => element
                                                                              .itemName.toLowerCase()
                                                                              .contains(search.toLowerCase()))
                                                                          .map(
                                                                            (list) =>
                                                                                DataRow(
                                                                              cells: [
                                                                                DataCell(
                                                                                  Text(
                                                                                    "${list.itemName}\n" +
                                                                                        "${list.uOM}" +
                                                                                        "-" +"Rate : ${double.parse(list.price.toString()).round()}\n" +
                                                                                        list.uOM+list.ComboNo.toString() +
                                                                                        "\n",
                                                                                    textAlign:TextAlign.left,
                                                                                    style:TextStyle(fontSize: 12),
                                                                                  ),
                                                                                ),
                                                                                DataCell(
                                                                                    Container(width: 100,
                                                                                      alignment:Alignment.center,
                                                                                      child: Text(list.qty.toString(),),),
                                                                                      showEditIcon: true,
                                                                                        onTap: () {
                                                                                  if (list.uOM.trim() == "Grams" || list.uOM.trim() == "Kgs") {
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (BuildContext context) {
                                                                                        return Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: SubMyClac(context, templist.indexOf(list), list.price, 0,tablet, height, width),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                  else if (list.uOM.trim() == "MixBox") {
                                                                                    double TotalQty = 0 ;
                                                                                    for(int i = 0 ; i < TepmSaveMixBoxMaster.length; i ++){
                                                                                      if(TepmSaveMixBoxMaster[i].refItemCode == list.itemCode && TepmSaveMixBoxMaster[i].ComboNo==list.ComboNo ){

                                                                                        TotalQty +=double.parse(TepmSaveMixBoxMaster[i].qty.toString());
                                                                                      }
                                                                                    }
                                                                                    print(TotalQty);
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (BuildContext context) {
                                                                                        return Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          //child: SubMyClac(context, templist.indexOf(list), list.price, 0),
                                                                                          child: EditMyMixBoxEditDilog(context, templist.indexOf(list), list.price, list.qty,
                                                                                              list.itemCode,list.ComboNo,TotalQty,list.itemName,tablet, height, width),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                  else {
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (BuildContext context) {
                                                                                        return Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: QtyMyClac(context, templist.indexOf(list), list.price, 0,tablet, height, width),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                }),
                                                                                DataCell(
                                                                                  Container(
                                                                                    width:60,
                                                                                    child: Center(
                                                                                        child: Wrap(
                                                                                            direction: Axis.vertical,
                                                                                            alignment: WrapAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                              double.parse(list.amount.toString()).round().toString(),
                                                                                              textAlign: TextAlign.center,
                                                                                          )
                                                                                        ])),
                                                                                  ),
                                                                                ),
                                                                                DataCell(
                                                                                  Container(
                                                                                    width:60,
                                                                                    child:
                                                                                        Wrap(
                                                                                            direction: Axis.vertical,
                                                                                            alignment: WrapAlignment.center,
                                                                                            children: [
                                                                                          Text(list.TaxCode.toString(), textAlign: TextAlign.center)
                                                                                        ]),
                                                                                  ),
                                                                                ),
                                                                                DataCell(
                                                                                  Container(
                                                                                    width:60,
                                                                                    child: Wrap(
                                                                                        direction: Axis.vertical,
                                                                                        alignment: WrapAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            list.tax.toStringAsFixed(2),
                                                                                            textAlign: TextAlign.center,
                                                                                          )
                                                                                        ]),
                                                                                  ),
                                                                                ),
                                                                                DataCell(
                                                                                  Center(
                                                                                    child: Center(child: IconButton(
                                                                                      icon:Icon(Icons.cancel),
                                                                                      color:Colors.red,
                                                                                      onPressed:() {
                                                                                        print("Pressed");
                                                                                        setState(() {
                                                                                          print(TepmSaveMixBoxMaster.length);
                                                                                          for(int i =0 ;i<TepmSaveMixBoxMaster.length; i++ ){
                                                                                            if(TepmSaveMixBoxMaster[i].ComboNo == list.ComboNo){
                                                                                              print(i);
                                                                                              setState(() {
                                                                                                TepmSaveMixBoxMaster.removeWhere((element) => element.ComboNo ==list.ComboNo);
                                                                                              });
                                                                                            }else{
                                                                                            }
                                                                                          }
                                                                                          templist.remove(list);
                                                                                          Fluttertoast.showToast(msg: "Deleted Row");
                                                                                          count();
                                                                                        });
                                                                                      },
                                                                                    )),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                        DraftMethod(context, height),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 50,
                                                      child: TextField(

                                                        onChanged: (val) {
                                                          setState(() {
                                                            try {
                                                              double remaining =DelReceiveAmount.text.isEmpty
                                                                      ? 0
                                                                      : (double.parse(DelReceiveAmount.text) -double.parse(Edt_Total.text));
                                                              if (DelReceiveAmount.text.isEmpty) {
                                                                Edt_Balance.text = "0.00";
                                                              } else {
                                                                Edt_Balance.text =remaining.toStringAsFixed(2);
                                                              }
                                                              print(remaining);
                                                            } catch (Exception) {}
                                                          });
                                                        },
                                                        controller: DelReceiveAmount,
                                                          readOnly:true,
                                                        decoration: InputDecoration(
                                                            suffixIconConstraints:BoxConstraints(minHeight: 30,minWidth: 30),
                                                            suffixIcon: Icon(Icons.cancel,size: 30,color: Colors.grey,),
                                                            border: OutlineInputBorder()),
                                                        onTap: () {
                                                          DelReceiveAmount.text = "0.00";
                                                          getvalue = 0;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 50,
                                                      child: TextField(
                                                        enabled: false,
                                                        controller: Edt_Total,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.digitsOnly
                                                        ],
                                                        keyboardType:TextInputType.number,
                                                        decoration: InputDecoration(
                                                          labelText: "Bill Amount",
                                                          border: OutlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 50,
                                                      child: TextField(
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.digitsOnly
                                                        ],
                                                        keyboardType:TextInputType.number,
                                                        readOnly: true,
                                                        controller: Edt_Balance,
                                                        decoration: InputDecoration(labelText: "Balance Amount",border: OutlineInputBorder(),fillColor: Colors.blue),
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 50,
                                                      child: TextField(
                                                        keyboardType: TextInputType.text,
                                                        enabled: true,
                                                        controller: Edt_PayRemarks,
                                                        decoration: InputDecoration(labelText: "Remarks",border: OutlineInputBorder(),),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    child: Visibility(
                                                      visible: false,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (alterpayment == "Select") {
                                                            showDialogboxWarning(context,"Please Choose Card Type");
                                                          } else {
                                                            setState(() {
                                                              paymenttemplist.add(
                                                                  SalesPayment(
                                                                      alterpayment,
                                                                      DelReceiveAmount.text,
                                                                      Edt_Total.text,
                                                                      Edt_Balance.text,
                                                                      Edt_PayRemarks.text));
                                                              DelReceiveAmount.text = "";
                                                              Edt_Balance.text = "";
                                                              Edt_PayRemarks.text = "";
                                                              alterpayment = "Select";
                                                              getvalue = 0;
                                                            });
                                                          }
                                                        },
                                                        child: Text('Add'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: height / 3,
                                                          width: double.infinity,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [Text('Denomination Details')],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  RupeesButton(context, "2000", 0),
                                                                  RupeesButton(context, "1000", 0),
                                                                  RupeesButton(context, "1500", 0),
                                                                  RupeesButton(context, "500", 1),
                                                                  RupeesButton(context, "200", 2),
                                                                  RupeesButton(context, "100", 3),
                                                                  ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  RupeesButton(context, "50", 4),
                                                                  RupeesButton(context, "20", 5),
                                                                  RupeesButton(context, "10", 6),
                                                                  RupeesButton(context, "5", 7),
                                                                  RupeesButton(context, "2", 8),
                                                                  RupeesButton(context, "1", 9),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(top: 40),
                                                                child: Row(
                                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if(DelReceiveAmount.text==''){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else if(DelReceiveAmount.text=="0.00"){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else{
                                                                          alterpayment ='Cash';
                                                                          paymenttemplist.add(SalesPayment(
                                                                              alterpayment,
                                                                              DelReceiveAmount.text,
                                                                              Edt_Total.text,
                                                                              Edt_Balance.text,
                                                                              Edt_PayRemarks.text));
                                                                          DelReceiveAmount.text = "";
                                                                          Edt_Balance.text = "";
                                                                          Edt_PayRemarks.text = "";
                                                                          alterpayment ="Select";
                                                                          getvalue = 0;
                                                                          getTotalBlanceAmt();
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Text('Cash',style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                                      onPressed: () {
                                                                        setState(() {

                                                                          if(DelReceiveAmount.text==''){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else if(DelReceiveAmount.text=="0.00"){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else{
                                                                          alterpayment ='Card';
                                                                          paymenttemplist.add(SalesPayment(
                                                                              alterpayment,
                                                                              DelReceiveAmount.text,
                                                                              Edt_Total.text,
                                                                              Edt_Balance.text,
                                                                              Edt_PayRemarks.text));
                                                                          DelReceiveAmount.text = "";
                                                                          Edt_Balance.text = "";
                                                                          Edt_PayRemarks.text = "";
                                                                          alterpayment ="Select";
                                                                          getvalue = 0;
                                                                          getTotalBlanceAmt();
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Text('Card',style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if(DelReceiveAmount.text==''){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else if(DelReceiveAmount.text=="0.00"){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else{
                                                                          alterpayment ='UPI';
                                                                          paymenttemplist.add(SalesPayment(
                                                                              alterpayment,
                                                                              DelReceiveAmount.text,
                                                                              Edt_Total.text,
                                                                              Edt_Balance.text,
                                                                              Edt_PayRemarks.text));
                                                                          DelReceiveAmount.text = "";
                                                                          Edt_Balance.text = "";
                                                                          Edt_PayRemarks.text = "";
                                                                          alterpayment ="Select";
                                                                          getvalue = 0;
                                                                          getTotalBlanceAmt();
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Text('UPI',style: TextStyle(color: Colors.white),),
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if(DelReceiveAmount.text==''){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else if(DelReceiveAmount.text=="0.00"){
                                                                            Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                          }else{
                                                                          alterpayment ='Others';
                                                                          paymenttemplist
                                                                              .add(
                                                                            SalesPayment(
                                                                                alterpayment,
                                                                                DelReceiveAmount.text,
                                                                                Edt_Total.text,
                                                                                Edt_Balance.text,
                                                                                Edt_PayRemarks.text),
                                                                          );
                                                                          DelReceiveAmount.text = "";
                                                                          Edt_Balance.text = "";
                                                                          Edt_PayRemarks.text = "";
                                                                          alterpayment ="Select";
                                                                          getvalue = 0;
                                                                          getTotalBlanceAmt();
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                        'Others',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          height: height / 2,
                                                          width: double.infinity,
                                                          child: SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child:
                                                                  paymenttemplist
                                                                              .length ==
                                                                          0
                                                                      ? Center(
                                                                          child: Text(
                                                                              'No Data Add!'),
                                                                        )
                                                                      : DataTable(
                                                                          sortColumnIndex:
                                                                              0,
                                                                          sortAscending:
                                                                              true,
                                                                          columnSpacing:
                                                                              30,
                                                                          dataRowHeight:
                                                                              60,
                                                                          headingRowColor:
                                                                              MaterialStateProperty
                                                                                  .all(Colors
                                                                                      .blue),
                                                                          showCheckboxColumn:
                                                                              false,
                                                                          columns: <
                                                                              DataColumn>[
                                                                            DataColumn(
                                                                              label: Text(
                                                                                'Remove',
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.white),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: Text(
                                                                                'Type',
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.white),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: Text(
                                                                                'Bill Amount',
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.white),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: Text(
                                                                                'Received Amount',
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.white),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: Text(
                                                                                'Balance Amount',
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.white),
                                                                              ),
                                                                            ),
                                                                            DataColumn(
                                                                              label: Text(
                                                                                'Remarks',
                                                                                style: TextStyle(
                                                                                    color:
                                                                                        Colors.white),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          rows:
                                                                              paymenttemplist
                                                                                  .map(
                                                                                    (list) =>
                                                                                        DataRow(
                                                                                      cells: [
                                                                                        DataCell(
                                                                                          Center(
                                                                                            child: Center(
                                                                                                child: IconButton(
                                                                                              icon: Icon(Icons.cancel),
                                                                                              color: Colors.red,
                                                                                              onPressed: () {
                                                                                                print("Pressed");
                                                                                                setState(() {
                                                                                                  paymenttemplist.remove(list);
                                                                                                  Fluttertoast.showToast(msg: "Deleted Row");
                                                                                                  getTotalBlanceAmt();
                                                                                                  //  count();
                                                                                                });
                                                                                              },
                                                                                            )),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(top: 5),
                                                                                            child: Text("${list.PaymentName}", textAlign: TextAlign.left),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          Center(
                                                                                            child: Center(
                                                                                              child: Wrap(
                                                                                                direction: Axis.vertical,
                                                                                                //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [
                                                                                                  Text(list.BillAmount.toString(), textAlign: TextAlign.center)
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          Center(
                                                                                            child: Center(
                                                                                              child: Wrap(
                                                                                                direction: Axis.vertical,
                                                                                                //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [
                                                                                                  Text(list.ReceivedAmount.toString(), textAlign: TextAlign.center)
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          Center(
                                                                                            child: Center(
                                                                                                child: Wrap(
                                                                                                    direction: Axis.vertical,
                                                                                                    //default
                                                                                                    alignment: WrapAlignment.center,
                                                                                                    children: [Text(list.BalAmount.toString(), textAlign: TextAlign.center)])),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          Center(
                                                                                            child: Center(
                                                                                              child: Wrap(
                                                                                                direction: Axis.vertical,
                                                                                                //default
                                                                                                alignment: WrapAlignment.center,
                                                                                                children: [
                                                                                                  Text(list.PaymentRemarks, textAlign: TextAlign.center)
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                  .toList(),
                                                                        ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  LineSeparator(color: Colors.grey),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Loyalty Points',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 6,
                                                            child: Container(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Container(
                                                                      child: Checkbox(
                                                                          value:
                                                                              loyalcheckboxValue,
                                                                          activeColor:
                                                                              Colors.blue,
                                                                          onChanged: (bool
                                                                              newValue) {
                                                                            setState(() {
                                                                              loyalcheckboxValue =
                                                                                  newValue;
                                                                            });
                                                                            Text('');
                                                                            print(
                                                                                'ONCHANGE$loyalcheckboxValue');
                                                                          }),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            Edt_Mobile,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Mobile No",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            Edt_Loyalty,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "LoyaltyPoints",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            Edt_Adjustment,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Adjustment",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        keyboardType:
                                                                            TextInputType
                                                                                .number,
                                                                        controller:
                                                                            Edt_UserLoyalty,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "User Amount",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            BalancePoints,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          fillColor:
                                                                              Colors.grey,
                                                                          labelText:
                                                                              "Balance Pts",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      LineSeparator(color: Colors.grey),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 6,
                                                            child: Container(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Container(
                                                                      child: Checkbox(
                                                                          value:
                                                                              careofcheckboxValue,
                                                                          activeColor:
                                                                              Colors.blue,
                                                                          onChanged: (bool
                                                                              newValue) {
                                                                            setState(() {
                                                                              careofcheckboxValue =
                                                                                  newValue;
                                                                            });
                                                                            Text('');
                                                                            print(
                                                                                'ONCHANGE$careofcheckboxValue');
                                                                          }),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            Edt_Credit,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Credit Amount",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: DropdownSearch<
                                                                        String>(
                                                                      mode: Mode.MENU,
                                                                      showSearchBox: true,
                                                                      items: careoflist,
                                                                      label: "C/O",
                                                                      onChanged: (val) {
                                                                        print(val);
                                                                        for (int kk = 0;
                                                                            kk <
                                                                                salespersonmodel
                                                                                    .result
                                                                                    .length;
                                                                            kk++) {
                                                                          if (salespersonmodel
                                                                                  .result[
                                                                                      kk]
                                                                                  .name ==
                                                                              val) {
                                                                            print(salespersonmodel
                                                                                .result[
                                                                                    kk]
                                                                                .empID);
                                                                            altercareofname =
                                                                                salespersonmodel
                                                                                    .result[
                                                                                        kk]
                                                                                    .name;
                                                                            altercareofcode =salespersonmodel.result[kk].empID.toString();
                                                                          }
                                                                        }
                                                                      },
                                                                      selectedItem:
                                                                          altercareofname,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            Edt_Total,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Total Bill Amt",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(
                                                                      child: TextField(
                                                                        enabled: false,
                                                                        controller:
                                                                            Edt_ReciveAmt,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              "Recive Amt",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: TextField(
                                                                      enabled: false,
                                                                      controller:Edt_BlanceBillAmt,
                                                                      decoration:InputDecoration(
                                                                        labelText:"Blance Amt",
                                                                        border:OutlineInputBorder(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      ElevatedButton(
                                                        child: Text(
                                                          "Save And Print",
                                                        ),
                                                        onPressed: () {
                                                          settlementisclicked = 1;
                                                          if (altersalespersoncode.isEmpty) {
                                                            Fluttertoast.showToast(msg:"Please Choose Sales Person");
                                                          } else if (settlementisclicked ==1 && paymenttemplist.length ==0) {
                                                            Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                                          } else if (double.parse(Edt_BlanceBillAmt.text) <0) {
                                                            Fluttertoast.showToast(
                                                                msg: "Get Full Amt");
                                                          } else {
                                                            print(sessionIPAddress);
                                                            insertSalesHeader(
                                                              HoldDocLine,
                                                              formatter.format(DateTime.now()),
                                                              Edt_Mobile.text,
                                                              formatter.format(DateTime.now()),
                                                              alterocccode,
                                                              alteroccname,
                                                              formatter.format(DateTime.now()),
                                                              'Message',
                                                              altersalespersoncode.toString(),
                                                              altersalespersoname,
                                                              checkedValue == true ? "Y" : "N",
                                                              Edt_CustCharge.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                                                              Edt_Advance.text.isEmpty ? 0 : double.parse(Edt_Advance.text),
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              '',
                                                              Edt_Delcharge.text.isEmpty ? 0 : double.parse(Edt_Delcharge.text),
                                                              batchcount,
                                                              Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                                                              Edt_Tax.text.isEmpty ? 0 : double.parse(Edt_Tax.text),
                                                              Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_Disc.text),
                                                              Edt_Balance.text.isEmpty ? 0 : double.parse(Edt_Balance.text),
                                                              Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                                                              'C',
                                                              0,
                                                              '',
                                                              0,
                                                              '',
                                                              '',
                                                              '',
                                                              widget.ScreenID,
                                                              widget.ScreenName,
                                                              int.parse(sessionuserID),
                                                            );
                                                            NetPrinter(sessionIPAddress, sessionIPPortNo);

                                                          }
                                                          // }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : IgnorePointer(
                                  ignoring: widget.isIgnore,
                                    child: PageView(
                                        physics: NeverScrollableScrollPhysics(),
                                        controller: pagecontroller,
                                        onPageChanged: (page) => {
                                          print(
                                            page.toString(),
                                          ),
                                        },
                                      pageSnapping: true,
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        Container(
                                          color: Colors.white,
                                          width: width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 1),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    children: [
                                                      categoryitem != null
                                                          ? Container(
                                                        child: SingleChildScrollView(
                                                          scrollDirection:Axis.horizontal,
                                                          child: Row(
                                                            children: [for (int cat = 0; cat < categoryitem.result.length; cat++)
                                                              Container(margin: EdgeInsets.all(5),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    TextClicked = altercategoryName = categoryitem.result[cat].name;
                                                                    print("TextClicked$TextClicked");
                                                                    colorchange = categoryitem.result[cat].code.toString();
                                                                    onclick = 1;
                                                                    altercategoryName =categoryitem.result[cat].name;
                                                                    altercategorycode = categoryitem.result[cat].code.toString().isEmpty
                                                                        ? 0
                                                                        : categoryitem.result[cat].code.toString();
                                                                    print('call THisITEM');
                                                                    getdetailitemsoffline(
                                                                        categoryitem.result[cat].code.toString().isEmpty
                                                                            ? 0
                                                                            : categoryitem.result[cat].code.toString(), onclick);

                                                                    setState(() {});
                                                                  },
                                                                  child: Center(
                                                                    child:Container(
                                                                      height: MediaQuery.of(context).size.height / 28,
                                                                      width: width/16,
                                                                      alignment: Alignment.center,
                                                                      padding: EdgeInsets.all(1),
                                                                      decoration: BoxDecoration(color: Colors.blue,
                                                                        borderRadius: BorderRadius.all(Radius.circular(10),),),
                                                                      child: Text(categoryitem.result[cat].name,
                                                                        textAlign: TextAlign.center,
                                                                        style: TextClicked == categoryitem.result[cat].name
                                                                            ? TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold,fontSize: height/40)
                                                                            : TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: height/40),
                                                                        maxLines: 1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                          : Container(),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          height: height,
                                                          width: width,
                                                          child: itemodel != null
                                                              ? GridView.count(
                                                            childAspectRatio: 0.9,
                                                            crossAxisCount: 5,
                                                            mainAxisSpacing: 0,
                                                            children: [
                                                              for (int cat = 0; cat < itemodel.result.length; cat++)
                                                                if (itemodel.result[cat].itemName.toLowerCase().contains(search.toLowerCase()))
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (itemodel.result[cat].uOM == "Grams" ||itemodel.result[cat].uOM =="Kgs") {
                                                                        showDialog< void>(
                                                                          context: context, barrierDismissible: false,
                                                                          // user must tap button!
                                                                          builder: (BuildContext context) {
                                                                            return Dialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(50),
                                                                              ),
                                                                              elevation: 0,
                                                                              backgroundColor: Colors.transparent,
                                                                              child: MyClac(
                                                                                  context,
                                                                                  itemodel.result[cat].itemCode,
                                                                                  itemodel.result[cat].itemName,
                                                                                  itemodel.result[cat].itmsGrpCod,
                                                                                  itemodel.result[cat].uOM,
                                                                                  itemodel.result[cat].price,
                                                                                  itemodel.result[cat].amount,
                                                                                  itemodel.result[cat].itmsGrpNam,
                                                                                  itemodel.result[cat].picturName,
                                                                                  itemodel.result[cat].imgUrl,
                                                                                  (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) / 100,
                                                                                  itemodel.result[cat].onHand,
                                                                                  itemodel.result[cat].Varince,
                                                                                  itemodel.result[cat].TaxCode,tablet, height, width),
                                                                            );
                                                                          },
                                                                        );
                                                                      }

                                                                      else if (itemodel.result[cat].uOM == "MixBox") {
                                                                        SecMyMixBoxMaster.clear();
                                                                        double TotalQty = 0;
                                                                        int count = 0;
                                                                        for (int i = 0; i <templist.length;i++) {
                                                                          if (templist[i].itemCode ==itemodel.result[cat].itemCode)
                                                                          {
                                                                            count=templist[i].ComboNo;
                                                                          }
                                                                        }

                                                                        for (int i = 0; i < RawMixBoxChild.result.length; i++) {
                                                                          if (RawMixBoxChild.result[i].refItemCode ==
                                                                              itemodel.result[cat].itemCode) {
                                                                            TotalQty += RawMixBoxChild.result[i].qty;
                                                                            SecMyMixBoxMaster.add(
                                                                              MyMixBoxMaster(
                                                                                  RawMixBoxChild.result[i].refItemCode,
                                                                                  RawMixBoxChild.result[i].itemCode,
                                                                                  RawMixBoxChild.result[i].itemName,
                                                                                  RawMixBoxChild.result[i].qty,
                                                                                  RawMixBoxChild.result[i].qty,
                                                                                  RawMixBoxChild.result[i].uom,
                                                                                  count + 1,
                                                                                  0),
                                                                            );
                                                                          }
                                                                        }

                                                                        showDialog<void>(
                                                                          context: context,
                                                                          barrierDismissible: false,
                                                                          // user must tap button!
                                                                          builder: (BuildContext context) {
                                                                            return Dialog(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(50),),
                                                                                elevation: 0,
                                                                                backgroundColor: Colors
                                                                                    .transparent,
                                                                                child: MyMixBoxDilog(
                                                                                    context,
                                                                                    itemodel.result[cat].itemCode,
                                                                                    itemodel.result[cat].itemName,
                                                                                    itemodel.result[cat].itmsGrpCod,
                                                                                    itemodel.result[cat].uOM,
                                                                                    itemodel.result[cat].price,
                                                                                    itemodel.result[cat].amount,
                                                                                    itemodel.result[cat].itmsGrpNam,
                                                                                    itemodel.result[cat].picturName,
                                                                                    itemodel.result[cat].imgUrl,
                                                                                    (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) / 100,
                                                                                    itemodel.result[cat].onHand,
                                                                                    itemodel.result[cat].Varince,
                                                                                    itemodel.result[cat].TaxCode,
                                                                                    TotalQty,
                                                                                    count+1,tablet, height, width));
                                                                          },
                                                                        );
                                                                      } else {
                                                                        print(cat);
                                                                        addItemToList(
                                                                            itemodel.result[cat].itemCode,
                                                                            itemodel.result[cat].itemName,
                                                                            itemodel.result[cat].itmsGrpCod,
                                                                            itemodel.result[cat].uOM,
                                                                            itemodel.result[cat].price,
                                                                            itemodel.result[cat].amount,
                                                                            1,
                                                                            itemodel.result[cat].itmsGrpNam,
                                                                            itemodel.result[cat].picturName,
                                                                            itemodel.result[cat].imgUrl,
                                                                            (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) /
                                                                                100,
                                                                            itemodel.result[cat].onHand,
                                                                            itemodel.result[cat].Varince,
                                                                            itemodel.result[cat].TaxCode,0);
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(1.0),
                                                                      child: Card(
                                                                        elevation: 5,
                                                                        clipBehavior: Clip.antiAlias,
                                                                        child: Stack(
                                                                          alignment: Alignment.center,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding:
                                                                                  const EdgeInsets.all(1.0),
                                                                                  child: itemodel.result[cat].imgUrl != "assets/Images/"
                                                                                      ? Image.asset(itemodel.result[cat].imgUrl, height: height / 13,
                                                                                  )
                                                                                      : CircleAvatar(
                                                                                    radius: height/25,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                                        itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: height/20),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Center(
                                                                                      child: TextField(
                                                                                        controller: TextEditingController(
                                                                                            text: "${itemodel.result[cat].itemName}\n"
                                                                                                "Rs.${double.parse(itemodel.result[cat].price.toString()).round()}\n"
                                                                                                "${itemodel.result[cat].Varince}\n"),
                                                                                        decoration: InputDecoration(
                                                                                          border: InputBorder.none,
                                                                                          contentPadding: EdgeInsets.all(0),
                                                                                        ),
                                                                                        minLines: 3,
                                                                                        maxLines: 3,
                                                                                        enabled: false,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontSize: 10),
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
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0.0),
                                                    child: SingleChildScrollView(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      scrollDirection: Axis.vertical,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: height/10,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                    width: double.infinity / 2,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: Colors.black12,
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    child: TextField(
                                                                      controller:
                                                                      editingController,
                                                                      autofocus: false,
                                                                      onChanged: (val) {
                                                                        setState(() {
                                                                          search = val;
                                                                        });
                                                                      },
                                                                      decoration:
                                                                      InputDecoration(
                                                                        suffixIcon:
                                                                        IconButton(
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              search = "";
                                                                              editingController
                                                                                  .clear();
                                                                            });
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.clear,size: height/25,),
                                                                        ),
                                                                        border: InputBorder
                                                                            .none,
                                                                        hintText: 'Search Item...',
                                                                        prefixIcon: Padding(padding: const EdgeInsets.all(1),
                                                                          child: Icon(
                                                                            Icons.search,size: height/25,),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                    height: MediaQuery.of(context).size.height /10,
                                                                    child: DropdownSearch<String>(
                                                                      mode: Mode.MENU,
                                                                      showSearchBox: true,
                                                                      items:salespersonlist,
                                                                      label: "Sales Person",
                                                                      dropdownSearchBaseStyle: TextStyle(fontSize: 2),
                                                                      onChanged: (val) {
                                                                        print(val);
                                                                        for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                                          if (salespersonmodel.result[kk].name ==val) {
                                                                            altersalespersoname =salespersonmodel.result[kk].name;
                                                                            altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                                                            var EnterMobileNo;
                                                                            if (Edt_Mobile.text =='0') {
                                                                              showDialog(
                                                                                context:context,
                                                                                builder: (BuildContext contex1) =>
                                                                                    AlertDialog(
                                                                                      content:TextFormField(
                                                                                        keyboardType:TextInputType.number,
                                                                                        maxLength:10,
                                                                                        autofocus:true,
                                                                                        onChanged:(vvv) {
                                                                                          EnterMobileNo = vvv;
                                                                                          if (EnterMobileNo.toString().length ==10) {
                                                                                            Edt_Mobile.text =
                                                                                                EnterMobileNo;
                                                                                            Navigator.pop(contex1);
                                                                                          }
                                                                                        },
                                                                                      ),
                                                                                      title: Text("Enter Mobile no"),
                                                                                      actions: <Widget>[
                                                                                        Column(
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Container(
                                                                                                  child: TextButton(
                                                                                                    onPressed: () {
                                                                                                      setState(() {
                                                                                                        Edt_Mobile.text = EnterMobileNo;
                                                                                                        Navigator.pop(
                                                                                                          contex1,
                                                                                                          'Ok',
                                                                                                        );
                                                                                                      });
                                                                                                    },
                                                                                                    child: const Text("Ok"),
                                                                                                  ),
                                                                                                ),
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
                                                                          }
                                                                        }
                                                                      },
                                                                      selectedItem: altersalespersoname,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                            EdgeInsets.only(top: 1),
                                                            color: Colors.white,
                                                            height: height/2.2,
                                                            width: width,
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.vertical,
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: templist.length == 0
                                                                    ? Center(
                                                                        child: Text('No Data Add!'),)
                                                                    : DataTable(
                                                                        sortColumnIndex: 0,
                                                                        sortAscending: true,
                                                                        columnSpacing: width/35,
                                                                        dataRowHeight: height/10,
                                                                        headingRowHeight: height/20,
                                                                        headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                                        showCheckboxColumn: true,
                                                                        columns: const <DataColumn>[
                                                                        DataColumn(
                                                                          label: Text(
                                                                            'Item Name',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                            'Qty',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                            'Amount',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                            'TAx',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                            'TAX %',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ),
                                                                        DataColumn(
                                                                          label: Text(
                                                                            'Romove',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                        ),
                                                                        ],
                                                                      rows: templist.where((element) => element.itemName.toLowerCase().contains(search.toLowerCase()))
                                                                      .map(
                                                                        (list) =>
                                                                        DataRow(
                                                                          cells: [
                                                                            DataCell(
                                                                              Text(
                                                                                "${list.itemName}\n" +
                                                                                    "${list.uOM}" +
                                                                                    "-" +
                                                                                    "Rate : ${double.parse(list.price.toString()).round()}\n" +
                                                                                    list.uOM+list.ComboNo.toString() +
                                                                                    "\n",
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: height/35),
                                                                              ),
                                                                            ),
                                                                            DataCell(
                                                                                Text(list.qty.toString(),style: TextStyle(fontSize: height/30),),
                                                                                showEditIcon: true,
                                                                                onTap: () {
                                                                                  if (list.uOM.trim() == "Grams" || list.uOM.trim() == "Kgs") {
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (BuildContext context) {
                                                                                        return Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: SubMyClac(context, templist.indexOf(list), list.price, 0,tablet, height, width),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                  else if (list.uOM.trim() == "MixBox") {
                                                                                    double TotalQty = 0 ;
                                                                                    print(SecMyMixBoxMaster.length);
                                                                                    for(int i = 0 ; i < SecMyMixBoxMaster.length; i ++){

                                                                                      print(SecMyMixBoxMaster[i].qty);

                                                                                      if(SecMyMixBoxMaster[i].refItemCode == list.itemCode){
                                                                                        TotalQty +=double.parse(SecMyMixBoxMaster[i].qty.toString());
                                                                                      }

                                                                                    }
                                                                                    print(TotalQty);

                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (BuildContext context) {
                                                                                        return Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          //child: SubMyClac(context, templist.indexOf(list), list.price, 0),
                                                                                          child: EditMyMixBoxEditDilog(context, templist.indexOf(list), list.price, list.qty,
                                                                                              list.itemCode,list.ComboNo,TotalQty,list.itemName,tablet, height, width),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                  else {
                                                                                    showDialog<void>(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (BuildContext context) {
                                                                                        return Dialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          child: QtyMyClac(context, templist.indexOf(list), list.price, 0,tablet, height, width),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                }),
                                                                            DataCell(
                                                                              Center(
                                                                                  child: Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          double.parse(list.amount.toString()).round().toString(),
                                                                                          textAlign: TextAlign.center,style: TextStyle(fontSize: height/32),
                                                                                        )
                                                                                      ])),
                                                                            ),
                                                                            DataCell(
                                                                              Wrap(
                                                                                  direction: Axis.vertical,
                                                                                  //default
                                                                                  alignment: WrapAlignment.center,
                                                                                  children: [
                                                                                    Text(list.TaxCode.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: height/32))
                                                                                  ]),
                                                                            ),
                                                                            DataCell(
                                                                              Text(
                                                                                  list.tax.toStringAsFixed(2),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: height/32)
                                                                              ),
                                                                            ),
                                                                            DataCell(
                                                                              IconButton(
                                                                                icon: Icon(Icons.cancel,size: height/25,),
                                                                                color: Colors.red,
                                                                                onPressed: () {
                                                                                  print("Pressed");
                                                                                  setState(() {
                                                                                    print(TepmSaveMixBoxMaster.length);
                                                                                    for(int i =0 ;i<TepmSaveMixBoxMaster.length; i++ ){
                                                                                      if(TepmSaveMixBoxMaster[i].ComboNo == list.ComboNo){
                                                                                        print(i);
                                                                                        setState(() {
                                                                                          TepmSaveMixBoxMaster.removeWhere((element) => element.ComboNo ==list.ComboNo);
                                                                                        });
                                                                                      }else{
                                                                                      }
                                                                                    }
                                                                                    templist.remove(list);
                                                                                    Fluttertoast.showToast(msg: "Deleted Row");
                                                                                    count();
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  )
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          MobileDraftMethod(context, height,width),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        height: height/12,
                                                        child: TextField(
                                                          style: TextStyle(fontSize: height/30),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              try {
                                                                double remaining =
                                                                DelReceiveAmount.text.isEmpty ? 0
                                                                    : (double.parse(DelReceiveAmount.text) - double.parse(Edt_Total.text));
                                                                if (DelReceiveAmount.text.isEmpty) {
                                                                  Edt_Balance.text = "0.00";
                                                                } else {
                                                                  Edt_Balance.text = remaining.toStringAsFixed(2);
                                                                }
                                                                print(remaining);
                                                              } catch (Exception) {}
                                                            });
                                                          },
                                                          controller: DelReceiveAmount,
                                                          decoration: InputDecoration(
                                                              suffixIconConstraints:
                                                              BoxConstraints(minHeight: 30, minWidth: 30),
                                                              suffixIcon: Icon(Icons.cancel, size: height/25, color: Colors.grey,),
                                                              border: OutlineInputBorder()),
                                                          onTap: () {
                                                            DelReceiveAmount.text = "0.00";
                                                            getvalue = 0;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        height: height/12,
                                                        child: TextField(
                                                          enabled: false,
                                                          controller: Edt_Total,
                                                          style: TextStyle(fontSize: height/30),
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          keyboardType:
                                                          TextInputType.number,
                                                          decoration: InputDecoration(
                                                            labelText: "Bill Amount",
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        height: height/12,
                                                        child: TextField(
                                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                          keyboardType: TextInputType.number,
                                                          readOnly: true,
                                                          controller: Edt_Balance,
                                                          decoration: InputDecoration(
                                                              labelText: "Balance Amount",
                                                              border: OutlineInputBorder(),
                                                              fillColor: Colors.blue),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: height/30),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        height: height/12,
                                                        child: TextField(
                                                          keyboardType: TextInputType.text,
                                                          enabled: true,
                                                          controller: Edt_PayRemarks,
                                                          decoration: InputDecoration(
                                                            labelText: "Remarks",
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: height / 2.4,
                                                            width: double.infinity,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    RupeesButton( context, "2000", 0),
                                                                    RupeesButton(
                                                                        context, "1000", 0),
                                                                    RupeesButton(
                                                                        context, "1500", 0),
                                                                    RupeesButton(
                                                                        context, "500", 1),
                                                                    RupeesButton(
                                                                        context, "200", 2),
                                                                    RupeesButton(
                                                                        context, "100", 3),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    RupeesButton(context, "50", 4),
                                                                    RupeesButton(context, "20", 5),
                                                                    RupeesButton(context, "10", 6),
                                                                    RupeesButton(context, "5", 7),
                                                                    RupeesButton(context, "2", 8),
                                                                    RupeesButton(context, "1", 9),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(top: 0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                            primary: Colors
                                                                                .pinkAccent),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            alterpayment =
                                                                            'Cash';
                                                                            paymenttemplist.add(SalesPayment(
                                                                                alterpayment,
                                                                                DelReceiveAmount
                                                                                    .text,
                                                                                Edt_Total
                                                                                    .text,
                                                                                Edt_Balance
                                                                                    .text,
                                                                                Edt_PayRemarks
                                                                                    .text));
                                                                            DelReceiveAmount
                                                                                .text = "";
                                                                            Edt_Balance
                                                                                .text = "";
                                                                            Edt_PayRemarks
                                                                                .text = "";
                                                                            alterpayment =
                                                                            "Select";
                                                                            getvalue = 0;
                                                                            getTotalBlanceAmt();
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                          'Cash',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                            primary: Colors
                                                                                .pinkAccent),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            alterpayment =
                                                                            'Card';
                                                                            paymenttemplist.add(SalesPayment(
                                                                                alterpayment,
                                                                                DelReceiveAmount
                                                                                    .text,
                                                                                Edt_Total
                                                                                    .text,
                                                                                Edt_Balance
                                                                                    .text,
                                                                                Edt_PayRemarks
                                                                                    .text));
                                                                            DelReceiveAmount
                                                                                .text = "";
                                                                            Edt_Balance
                                                                                .text = "";
                                                                            Edt_PayRemarks
                                                                                .text = "";
                                                                            alterpayment =
                                                                            "Select";
                                                                            getvalue = 0;
                                                                            getTotalBlanceAmt();
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                          'Card',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                            primary: Colors
                                                                                .pinkAccent),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            alterpayment =
                                                                            'UPI';
                                                                            paymenttemplist.add(SalesPayment(
                                                                                alterpayment,
                                                                                DelReceiveAmount
                                                                                    .text,
                                                                                Edt_Total
                                                                                    .text,
                                                                                Edt_Balance
                                                                                    .text,
                                                                                Edt_PayRemarks
                                                                                    .text));
                                                                            DelReceiveAmount
                                                                                .text = "";
                                                                            Edt_Balance
                                                                                .text = "";
                                                                            Edt_PayRemarks
                                                                                .text = "";
                                                                            alterpayment =
                                                                            "Select";
                                                                            getvalue = 0;
                                                                            getTotalBlanceAmt();
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                          'UPI',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                            primary: Colors
                                                                                .pinkAccent),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            alterpayment =
                                                                            'Others';
                                                                            paymenttemplist.add(
                                                                              SalesPayment(
                                                                                  alterpayment,
                                                                                  DelReceiveAmount.text,
                                                                                  Edt_Total.text,
                                                                                  Edt_Balance.text,
                                                                                  Edt_PayRemarks.text),
                                                                            );
                                                                            DelReceiveAmount.text = "";
                                                                            Edt_Balance.text = "";
                                                                            Edt_PayRemarks.text = "";
                                                                            alterpayment = "Select";
                                                                            getvalue = 0;
                                                                            getTotalBlanceAmt();
                                                                          });
                                                                        },
                                                                        child: Text('Others',style: TextStyle(color: Colors.white),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: height / 2.4,
                                                            margin: EdgeInsets.only(top: 2),
                                                            width: double.infinity,
                                                            child: SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.vertical,
                                                              child: SingleChildScrollView(
                                                                scrollDirection:
                                                                Axis.horizontal,
                                                                child:
                                                                paymenttemplist.length == 0
                                                                    ? Center(
                                                                  child: Text('No Data Add!'),)
                                                                    : DataTable(
                                                                  sortColumnIndex: 0,
                                                                  sortAscending: true,
                                                                  showCheckboxColumn: false,
                                                                  columnSpacing: width/35,
                                                                  dataRowHeight: height/10,
                                                                  headingRowHeight: height/20,
                                                                  headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                                  columns: <DataColumn>[
                                                                    DataColumn(label: Text('Remove',style: TextStyle(color:Colors.white),),),
                                                                    DataColumn(label: Text('Type',style: TextStyle(color:Colors.white),),),
                                                                    DataColumn(label: Text('Bill Am',style: TextStyle(color:Colors.white),),),
                                                                    DataColumn(label: Text('Rec Amt',style: TextStyle(color:Colors.white),),),
                                                                    DataColumn( label: Text('Bal Amt',style: TextStyle(color:Colors.white),),),
                                                                    DataColumn(label: Text('Remarks',style: TextStyle(color:Colors.white),),),
                                                                  ],
                                                                  rows:paymenttemplist.map((list) =>
                                                                      DataRow(
                                                                        cells: [
                                                                          DataCell(
                                                                            Center(
                                                                                child: IconButton(
                                                                                  icon: Icon(Icons.cancel,size: height/25,),
                                                                                  color: Colors.red,
                                                                                  onPressed: () {
                                                                                    print("Pressed");
                                                                                    setState(() {
                                                                                      paymenttemplist.remove(list);
                                                                                      Fluttertoast.showToast(msg: "Deleted Row");
                                                                                      getTotalBlanceAmt();
                                                                                      //  count();
                                                                                    });
                                                                                  },
                                                                                )),
                                                                          ),
                                                                          DataCell(
                                                                            Text("${list.PaymentName}", textAlign: TextAlign.left,style: TextStyle(fontSize: height/33,),),
                                                                          ),
                                                                          DataCell(
                                                                            Center(
                                                                              child: Wrap(
                                                                                direction: Axis.vertical,
                                                                                //default
                                                                                alignment: WrapAlignment.center,
                                                                                children: [
                                                                                  Text(list.BillAmount.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: height/33,),)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataCell(
                                                                            Center(
                                                                              child: Wrap(
                                                                                direction: Axis.vertical,
                                                                                //default
                                                                                alignment: WrapAlignment.center,
                                                                                children: [
                                                                                  Text(list.ReceivedAmount.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: height/33,),)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataCell(
                                                                            Center(
                                                                              child: Text(list.BalAmount.toString(),
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: height/33,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          DataCell(
                                                                            Center(
                                                                              child: Wrap(
                                                                                direction: Axis.vertical,
                                                                                //default
                                                                                alignment: WrapAlignment.center,
                                                                                children: [
                                                                                  Text(list.PaymentRemarks, textAlign: TextAlign.center)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),)
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),

                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Loyalty Points',style: TextStyle(fontWeight:FontWeight.bold),)
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 6,
                                                              child: Container(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: Checkbox(
                                                                            value:loyalcheckboxValue,
                                                                            activeColor:Colors.blue,
                                                                            onChanged: (bool newValue) {
                                                                              setState(() {
                                                                                loyalcheckboxValue = newValue;
                                                                              });
                                                                              Text('');
                                                                              print('ONCHANGE$loyalcheckboxValue');
                                                                            }),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_Mobile,
                                                                          decoration:InputDecoration(
                                                                            labelText:"Mobile No",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_Loyalty,
                                                                          decoration:InputDecoration(
                                                                            labelText:"LoyaltyPoints",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_Adjustment,
                                                                          decoration:InputDecoration(
                                                                            labelText:"Adjustment",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          keyboardType:TextInputType.number,
                                                                          controller:Edt_UserLoyalty,
                                                                          decoration:InputDecoration(
                                                                            labelText:"User Amount",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:BalancePoints,
                                                                          decoration:InputDecoration(
                                                                            fillColor:Colors.grey,
                                                                            labelText:"Balance Pts",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 6,
                                                              child: Container(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: Checkbox(
                                                                            value:
                                                                            careofcheckboxValue,
                                                                            activeColor:
                                                                            Colors.blue,
                                                                            onChanged: (bool newValue) {
                                                                              setState(() {
                                                                                careofcheckboxValue =newValue;
                                                                              });
                                                                              Text('');
                                                                              print(
                                                                                  'ONCHANGE$careofcheckboxValue');
                                                                            }),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_Credit,
                                                                          decoration:InputDecoration(
                                                                            labelText:"Credit Amount",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: DropdownSearch<String>(
                                                                          mode: Mode.MENU,
                                                                          showSearchBox: true,
                                                                          items: careoflist,
                                                                          label: "C/O",
                                                                          onChanged: (val) {
                                                                            print(val);
                                                                            for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                                              if (salespersonmodel.result[kk].name == val) {
                                                                                print(salespersonmodel.result[kk].empID);
                                                                                altercareofname = salespersonmodel.result[kk].name;
                                                                                altercareofcode = salespersonmodel.result[kk].empID.toString();
                                                                              }
                                                                            }
                                                                          },
                                                                          selectedItem:altercareofname,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_Total,
                                                                          decoration:InputDecoration(
                                                                            labelText:"Total Bill Amt",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_ReciveAmt,
                                                                          decoration:InputDecoration(
                                                                            labelText:"Recive Amt",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: Container(
                                                                        height: height/12,
                                                                        child: TextField(
                                                                          enabled: false,
                                                                          controller:Edt_BlanceBillAmt,
                                                                          decoration:InputDecoration(
                                                                            labelText:"Blance Amt",
                                                                            border:OutlineInputBorder(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        ElevatedButton(
                                                          child: Text(
                                                            "Save And Print",
                                                          ),
                                                          onPressed: () {
                                                            settlementisclicked = 1;
                                                            if (altersalespersoncode.isEmpty) {
                                                              Fluttertoast.showToast(msg:"Please Choose Sales Person");
                                                            } else if (settlementisclicked ==1 &&paymenttemplist.length ==0) {
                                                              Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                                            } else if (double.parse(Edt_BlanceBillAmt.text) < 0) {
                                                              Fluttertoast.showToast(msg: "Get Full Amt");
                                                            } else {
                                                              print(sessionIPAddress);
                                                              insertSalesHeader(
                                                                HoldDocLine,
                                                                formatter.format(DateTime.now()),
                                                                Edt_Mobile.text,
                                                                formatter.format(DateTime.now()),
                                                                alterocccode,
                                                                alteroccname,
                                                                formatter.format(DateTime.now()),
                                                                'Message',
                                                                altersalespersoncode.toString(),
                                                                altersalespersoname,
                                                                checkedValue == true ? "Y" : "N",
                                                                Edt_CustCharge.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                                                                Edt_Advance.text.isEmpty ? 0 : double.parse(Edt_Advance.text),
                                                                '',
                                                                '',
                                                                '',
                                                                '',
                                                                '',
                                                                '',
                                                                Edt_Delcharge.text.isEmpty ? 0 : double.parse(Edt_Delcharge.text),
                                                                batchcount,
                                                                Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                                                                Edt_Tax.text.isEmpty ? 0 : double.parse(Edt_Tax.text),
                                                                Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_Disc.text),
                                                                Edt_Balance.text.isEmpty ? 0 : double.parse(Edt_Balance.text),
                                                                Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                                                                'C',
                                                                0,
                                                                '',
                                                                0,
                                                                '',
                                                                '',
                                                                '',
                                                                widget.ScreenID,
                                                                widget.ScreenName,
                                                                int.parse(sessionuserID),
                                                              );
                                                              NetPrinter(sessionIPAddress, sessionIPPortNo);
                                                            }
                                                            // }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                            ),

                          ),
                        ),
        ),
      ),
    );
  }

  MyClac(context, itemCode, itemName, itmsGrpCod, uOM, price, amount,
      itmsGrpNam, picturName, imgUrl, tax, stock, varince, taxcode,tablet,double height,double width) {
    print("MyClac");
    var Qty = '0';
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width/2,
          height: tablet?520:height/1.5,
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
                height: tablet?420:height/1.8,
                width: tablet?420:width/2.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      Qty = (value * 1).toStringAsFixed(3);
                      print(price / 1 * double.parse(Qty));
                      amount = price.round() / 1 * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      print(value);
                      setState(() {
                        Qty = (value * 1).toStringAsFixed(3);
                        print(price / 1 * double.parse(Qty));
                        amount = price.round() / 1 * double.parse(Qty);
                      });
                      print(amount.toString());
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      setState(() {
                        Navigator.pop(context);
                      });
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
                height: tablet?50:10
              ),
              InkWell(
                onTap: () {
                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: 'Enter The Qty....');
                  } else {
                    int counttt=0;
                    for(int i = 0 ;i < templist.length;i++){
                      if(templist[i].itemCode == itemCode){
                        counttt++;
                      }
                    }
                    if(counttt==0){
                    setState(() {
                      addItemToList(
                          itemCode,
                          itemName,
                          itmsGrpCod,
                          uOM,
                          price,
                          amount,
                          Qty,
                          //qty,
                          itmsGrpNam,
                          picturName,
                          imgUrl,
                          tax,
                          stock,
                          varince,
                          taxcode,
                          0);
                    });
                    }else{
                      setState(() {
                        print(itemCode);
                        double a=0;
                        double btotal=0;
                        for(int kk = 0 ;kk < templist.length;kk++){
                         a= double.parse(templist[kk].qty.toString());
                          if(templist[kk].itemCode == itemCode){
                            a+=double.parse(Qty.toString());
                            templist[kk].qty=a.toStringAsFixed(3).toString();
                            btotal = price.round() / 1 * double.parse(a.toString());
                            templist[kk].amount = btotal;
                            count();
                          }
                        }
                      });
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  height: tablet?50:height/15,
                  decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {},
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: tablet?20:height/50, color: Colors.white),
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

  SubMyClac(context, index, price, amount,tablet,double height,double width) {
    var Qty = '0';
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width/2,
          height: tablet?520:height/1.5,
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
                height: tablet?420:height/1.8,
                width: tablet?420:width/2.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      //Qty = value ?? 0;
                      Qty = (value * 1).toStringAsFixed(3);
                      print(price / 1 * double.parse(Qty));
                      amount = price.round() / 1 * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        //Qty = value ?? 0;
                        Qty = (value * 1).toStringAsFixed(3);
                        print(price.round() / 1 * double.parse(Qty));
                        amount = price.round() / 1 * double.parse(Qty);
                        print(amount.toString());
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      //Qty = value ?? 0;
                      setState(() {
                        Navigator.pop(context);
                      });
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
                  height: tablet?50:10
              ),
              InkWell(
                onTap: () {
                  print(Qty);
                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: 'Enter The Qty....');
                  } else {
                    setState(() {
                      templist[index].qty = Qty;
                      templist[index].amount = amount;
                      count();
                    });

                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  height: tablet?50:height/15,
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
                        style: TextStyle(fontSize: tablet?20:height/50, color: Colors.white),
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

  QtyMyClac(context, index, price, amount,tablet,double height,double width) {
    var Qty = '0';
    print("QtyMyClac");
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width/2,
          height: tablet?520:height/1.5,
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
                height: tablet?420:height/1.8,
                width: tablet?420:width/2.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      //Qty = value ?? 0;
                      Qty = value.toStringAsFixed(1);
                      print(price.round() * double.parse(Qty));
                      amount = price.round() * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        Qty = value.toStringAsFixed(1);
                        print(price.round() * double.parse(Qty));
                        amount = price.round() * double.parse(Qty);
                      });

                      // print(amount.toString());
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    if (kDebugMode) {
                      setState(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  theme: const CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 1,
                    displayColor: Colors.white,
                    displayStyle: TextStyle(fontSize: 15, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle: TextStyle(fontSize: 15, color: Colors.black54),
                    operatorColor: Colors.white,
                    operatorStyle: TextStyle(fontSize: 15, color: Colors.deepOrange),
                    commandColor: Colors.white,
                    commandStyle: TextStyle(fontSize: 15, color: Colors.deepOrange),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                  height: tablet?50:10
              ),
              InkWell(
                onTap: () {
                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: 'Enter The Qty....');
                  } else if ((double.parse(Qty).round() -
                          double.parse(Qty.toString())) ==
                      0) {
                    setState(() {
                      templist[index].qty = Qty;
                      templist[index].amount = amount;
                      count();
                    });
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      Fluttertoast.showToast(msg: 'Enter The Integer Qty..');
                    });
                  }
                },
                child: Container(
                  height: tablet?50:height/15,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: tablet?20:height/50, color: Colors.white),
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

  MyTransportcount(context) {
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
                        itemCount: RawTransportCountModel.result.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "Req No - " +
                                    RawTransportCountModel
                                        .result[index].headDocNo
                                        .toString() +
                                    "\n" +
                                    "Req Loc -" +
                                    RawTransportCountModel.result[index].toloc
                                        .toString() +
                                    "\n" +
                                    "ItemName -" +
                                    RawTransportCountModel
                                        .result[index].itemName
                                        .toString() +
                                    "\n" +
                                    "Qty -" +
                                    RawTransportCountModel.result[index].qty
                                        .toString() +
                                    "\n",
                              ),
                              onTap: () {
                                print('ouhvouvh');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RequestTransferScreen(
                                      id: 1,
                                      DocNo: RawTransportCountModel
                                          .result[index].headDocNo,
                                    ),
                                  ),
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
                        itemCount: RawMyHoldGetLineModel.testdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                    "Order No - " + RawMyHoldGetLineModel.testdata[index].orderNo.toString() + "\n" +
                                    "Cus No -" + RawMyHoldGetLineModel.testdata[index].CustomerNo.toString() + "\n" +
                                    "Order Amt -" + RawMyHoldGetLineModel.testdata[index].totAmount.toString() + "\n",
                              ),
                              onTap: () {
                                setState(() {
                                  HoldDocLine = RawMyHoldGetLineModel
                                      .testdata[index].orderNo;

                                  GetMyHoldLineRocord();
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

  MyMixBoxDilog(context, itemCode,itemName,itmsGrpCod,uOM,price,amount,itmsGrpNam,picturName,imgUrl,
      tax,stock,varince,taxcode,TotalQty,count,tablet,double height,double width) {
    var Qty = 1;
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {

      return Stack(
        children: <Widget>[
          Container(
            width: 550,
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
            child: SecMyMixBoxMaster.length == 0
                ? Center(
                    child: Text('No Data Add!'),
                  )
                : Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: 450,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "ItemName - " + itemName.toString(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 450,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Price - " + price.toString(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 450,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "TotalQty - " + TotalQty.toString(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                if(Qty == 1){}else{
                                setState(() {
                                  Qty-=1;
                                });}

                              }, icon: Icon(Icons.exposure_minus_1,size: 20,color: Colors.red,),),
                              SizedBox(width: 25,),
                              Text(
                                "Qty - " + Qty.toString(),
                              ),
                              SizedBox(width: 25,),
                              IconButton(onPressed: (){
                                setState(() {
                                 Qty+=1;
                                });

                              }, icon: Icon(Icons.exposure_plus_1,size: 20,color: Colors.green),)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        DataTable(
                          sortColumnIndex: 0,
                          sortAscending: true,
                          columnSpacing: 25,
                          dataRowHeight: 42,
                          headingRowHeight: 30,
                          headingRowColor: MaterialStateProperty.all(Colors.blue),
                          showCheckboxColumn: false,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Combo No',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Item Name',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Uom',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Actual Qty',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows: SecMyMixBoxMaster.where((element) => element
                                  .itemName
                                  .toLowerCase()
                                  .contains(search.toLowerCase()))
                              .map(
                                (list) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(list.ComboNo.toString()),
                                    ),
                                    DataCell(
                                      Text(list.itemName),
                                    ),
                                    DataCell(
                                      Text(list.Uom),
                                    ),
                                    DataCell(
                                      Text(
                                        list.qty.toString(),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        list.ActualQty.toString(),
                                      ),
                                      showEditIcon: true,
                                      onTap: () {
                                        var EnterMobileNo;
                                        showDialog(
                                          context: context, builder: (BuildContext contex1) => AlertDialog(
                                            content: TextFormField(keyboardType: TextInputType.number,
                                              autofocus: true, onChanged: (vvv) {EnterMobileNo = vvv;},),
                                            title: Text("Enter Mobile no"),
                                            actions: <Widget>[
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              list.ActualQty = EnterMobileNo;
                                                              Navigator.pop(contex1, 'Ok',);
                                                            });
                                                          },
                                                          child: const Text("Ok"),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(contex1, 'Cancel'),
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
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {

                            double ActQty = 0 ;
                            for(int i = 0 ; i < SecMyMixBoxMaster.length;i++){
                              ActQty += double.parse(SecMyMixBoxMaster[i].ActualQty.toString()) ;
                            }
                          print(ActQty);

                            if(TotalQty != ActQty){

                              Fluttertoast.showToast(msg: 'The Qty Is Mismatched....');

                            }

                            else {
                              setState(() {
                                addItemToList(
                                    itemCode,
                                    itemName,
                                    itmsGrpCod,
                                    uOM,
                                    price,
                                    Qty*amount,
                                    Qty,
                                    //qty,
                                    itmsGrpNam,
                                    picturName,
                                    imgUrl,
                                    tax,
                                    stock,
                                    varince,
                                    taxcode,count);
                              });
                              for(int i = 0 ; i < SecMyMixBoxMaster.length;i++){
                              TepmSaveMixBoxMaster.add(
                                  SaveMixBoxMaster(
                                      SecMyMixBoxMaster[i].refItemCode,
                                      SecMyMixBoxMaster[i].itemCode,
                                      SecMyMixBoxMaster[i].itemName,
                                      SecMyMixBoxMaster[i].qty,
                                      SecMyMixBoxMaster[i].ActualQty,
                                      SecMyMixBoxMaster[i].Uom,
                                      SecMyMixBoxMaster[i].ComboNo,
                                      SecMyMixBoxMaster[i].SqlRefNo),);
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            height: 45,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius:BorderRadius.circular(Constants.padding),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Ok",style:TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    },
  );


  }


  EditMyMixBoxEditDilog(context,index,price, qty,itemCode,ComboNo,TotalQty,itemName,tablet,double height,double width) {
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
      return Stack(
        children: <Widget>[
          Container(
            width: 550,
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
            child: TepmSaveMixBoxMaster.length == 0
                ? Center(
                      child: Text('No Data Add!'),
            )
                : Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: 450,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "ItemName - " + itemName.toString(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 450,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Price - " + price.toString(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 450,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "TotalQty - " + TotalQty.toString(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 350,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                IconButton(onPressed: (){
                                  if(qty == 1){}else{
                                    setState(() {
                                      qty-=1;
                                    });}

                                }, icon: Icon(Icons.exposure_minus_1,size: 20,color: Colors.red,),),
                                SizedBox(width: 25,),
                                Text(
                                  "Qty - " + qty.toString(),
                                ),
                                SizedBox(width: 25,),
                                IconButton(onPressed: (){
                                  setState(() {
                                    qty+=1;
                                  });

                                }, icon: Icon(Icons.exposure_plus_1,size: 20,color: Colors.green),)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          DataTable(
                            sortColumnIndex: 0,
                            sortAscending: true,
                            columnSpacing: 25,
                            dataRowHeight: 42,
                            headingRowHeight: 30,
                            headingRowColor: MaterialStateProperty.all(Colors.blue),
                            showCheckboxColumn: false,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Combo No',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Item Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Uom',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Qty',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Actual Qty',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            rows: TepmSaveMixBoxMaster.where((element) => element
                                .ComboNo.toString()
                                .toLowerCase()
                                .contains(ComboNo.toString().toLowerCase()) &&element.refItemCode.toString().toLowerCase().contains(itemCode.toString().toLowerCase()) )
                                .map((list) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(list.ComboNo.toString()),
                                  ),
                                  DataCell(
                                    Text(list.itemName),
                                  ),
                                  DataCell(
                                    Text(list.Uom),
                                  ),
                                  DataCell(
                                    Text(
                                      list.qty.toString(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      list.ActualQty.toString(),
                                    ),
                                    showEditIcon: true,
                                    onTap: () {
                                      var EnterMobileNo;
                                      showDialog(context: context, builder: (BuildContext contex1) => AlertDialog(
                                          content: TextFormField(keyboardType: TextInputType.number,
                                          autofocus: true, onChanged: (vvv) {EnterMobileNo = vvv;},),
                                          title: Text("Enter Mobile no"),
                                          actions: <Widget>[
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          list.ActualQty = EnterMobileNo;
                                                          Navigator.pop(contex1, 'Ok',);
                                                        });
                                                      },
                                                      child: const Text("Ok"),
                                                    ),
                                                  ),
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
                                    },
                                  ),
                                ],
                              ),
                            )
                                .toList(),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          InkWell(
                            onTap: () {
                              double ActQty = 0 ;
                              for(int i = 0 ; i < TepmSaveMixBoxMaster.length;i++){
                                if(TepmSaveMixBoxMaster[i].ComboNo == ComboNo && TepmSaveMixBoxMaster[i].refItemCode==itemCode){
                                  ActQty+= double.parse(TepmSaveMixBoxMaster[i].ActualQty.toString()) ;
                                }
                              }
                              print(TotalQty);
                              print(ActQty);

                              if(TotalQty != ActQty){
                                Fluttertoast.showToast(msg: "Qty Mismatched...");
                              }else{
                                setState(() {
                                  templist[index].qty = qty;
                                  templist[index].amount = qty*price;
                                  count();
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(Constants.padding),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Ok", style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                ],
              ),
            ),
          ),
        ],
      );



    },);


  }


  bool onWillPop() {
    print('ROUND ${pagecontroller.page.round()}');
    print('INITIAL ${pagecontroller.initialPage}');

    if (pagecontroller.initialPage == 0 && pagecontroller.page.round() == 0) {
      showDialog(
        context: this.context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure you want to go Back?'),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false)),
          ],
        ),
      );
      return true;
    } else {
      print("Payment List");
      pagecontroller.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      setState(() {
        paymenttemplist.clear();
      });
      return false;
    }
  }

  Widget DraftMethod(BuildContext context, double height) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Column(
        children: [
          Row(
            children: [
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Mobile,
                    enabled: true,
                    onTap: () {
                      var EnterMobileNo;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            autofocus: true,
                            onChanged: (vvv) {
                              EnterMobileNo = vvv;
                              if (EnterMobileNo.toString().length == 10) {
                                Edt_Mobile.text = EnterMobileNo;
                                Navigator.pop(contex1);
                              }
                            },
                          ),
                          title: Text("Enter Mobile no"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Mobile.text = EnterMobileNo;
                                            Navigator.pop(contex1, 'Ok',);
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
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
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cus.MobileNo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_CustCharge,
                    readOnly: true,
                    onTap: () {
                      var EnterEdtCustCharge;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtCustCharge = vvv;
                            },
                          ),
                          title: Text("Enter Customer Charge"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_CustCharge.text = EnterEdtCustCharge;
                                            MyLocCount();
                                            Navigator.pop(contex1, 'Ok',);
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
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
                    },
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cust.Charge",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Disc,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    onTap: () {
                      var EnterEdtDisc;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtDisc = vvv;
                            },
                          ),
                          title: Text("Enter Discount Amt"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Disc.text = EnterEdtDisc;
                                            MyLocCount();
                                            Navigator.pop(contex1, 'Ok',);
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
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
                    },
                    decoration: InputDecoration(
                      labelText: "Appr.Disc%/Rup",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
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
          Row(
            children: [
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    readOnly: true,
                    controller: Edt_Tax,
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Tax",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    controller: Edt_Total,
                    enabled: false,
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    decoration: InputDecoration(
                      labelText: "Total.Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Advance,
                    readOnly: true,
                    onTap: () {
                      var EnterEdtAdvance;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtAdvance = vvv;
                            },
                          ),
                          title: Text("Enter Advanced Amt"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Advance.text = EnterEdtAdvance;
                                            MyLocCount();
                                            Navigator.pop(contex1, 'Ok',);
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.pop(contex1, 'Cancel'),
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
                    decoration: InputDecoration(
                      labelText: "Advance",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
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
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Balance,
                    enabled: false,
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    decoration: InputDecoration(
                      labelText: "Bal.Due",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Delcharge,
                    readOnly: true,
                    onTap: () {
                      var EnterEdtDelcharge;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtDelcharge = vvv;
                            },
                          ),
                          title: Text("Enter Delivery Amt"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Delcharge.text = EnterEdtDelcharge;
                                            MyLocCount();
                                            Navigator.pop(contex1, 'Ok',);
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
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
                    },
                    decoration: InputDecoration(
                      labelText: "Del.Charge",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    controller: Edt_NetTotal,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Net Total",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 45,
                  child: FloatingActionButton.extended(
                    heroTag: "Print & Settlement",
                    backgroundColor: Colors.blue,
                    icon: Icon(Icons.print),
                    label: Text('Print & Settlement'),
                    onPressed: () {
                      if (Edt_Total.text.isEmpty) {
                        showDialogboxWarning(
                            context, "Total Should Not Left Empty!");
                      } else if (Edt_CustCharge.text.isEmpty) {
                        showDialogboxWarning(
                            context, "Customer Charge Should Not Left Empty!");
                      } else if (Edt_Delcharge.text.isEmpty) {
                        showDialogboxWarning(
                            context, "DelCharge Charge Should Not Left Empty!");
                      } else if (altersalespersoncode.isEmpty) {
                        showDialogboxWarning(
                            context, "Please Choose Sales person!");
                      } else if (Edt_Mobile.text.toString().length != 10) {
                        showDialogboxWarning(
                            context, "The Cus Mobile No Should Be 10..");
                      }
                      else {
                        pagecontroller.jumpToPage(2);

                        getoccation(int.parse(sessionuserID), int.parse(sessionbranchcode));
                        getstate(2, sessionuserID);
                        getcountry(1, sessionuserID);
                      }
                    },
                  ),
                ),
                // RaisedButton(
                //     onPressed: () {
                //       if (Edt_Total.text.isEmpty) {
                //         showDialogboxWarning(
                //             context, "Total Should Not Left Empty!");
                //       } else if (Edt_CustCharge.text.isEmpty) {
                //         showDialogboxWarning(
                //             context, "Customer Charge Should Not Left Empty!");
                //       } else if (Edt_Delcharge.text.isEmpty) {
                //         showDialogboxWarning(
                //             context, "DelCharge Charge Should Not Left Empty!");
                //       } else if (altersalespersoncode.isEmpty) {
                //         showDialogboxWarning(
                //             context, "Please Choose Sales person!");
                //       } else {
                //         pagecontroller.jumpToPage(2);
                //         getoccation(int.parse(sessionuserID),
                //             int.parse(sessionbranchcode));
                //         getstate(2, sessionuserID);
                //         getcountry(1, sessionuserID);
                //       }
                //     },
                //     child: Text('Print&Settlement')),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(
                          context, "Total Should Not Left Empty!");
                    } else if (Edt_CustCharge.text.isEmpty) {
                      showDialogboxWarning(
                          context, "Customer Charge Should Not Left Empty!");
                    } else if (Edt_Delcharge.text.isEmpty) {
                      showDialogboxWarning(
                          context, "DelCharge Charge Should Not Left Empty!");
                    } else if (altersalespersoncode.isEmpty) {
                      showDialogboxWarning(
                          context, "Please Choose Sales person!");
                    } else {
                      settlementisclicked = 0;
                      insertSalesHeader(
                          HoldDocLine,
                          formatter.format(DateTime.now()),
                          Edt_Mobile.text,
                          formatter.format(DateTime.now()),
                          '',
                          //OccCode
                          '',
                          //OccName
                          formatter.format(DateTime.now()),
                          '',
                          //Message
                          altersalespersoncode.toString(),
                          //ShapeCode
                          altersalespersoname,
                          //ShapeName
                          'N',
                          Edt_CustCharge.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                          Edt_Advance.text.isEmpty ? 0 : double.parse(Edt_Advance.text),
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          Edt_Delcharge.text.isEmpty ? 0 : double.parse(Edt_Delcharge.text),
                          batchcount,
                          Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                          Edt_Tax.text.isEmpty ? 0 : double.parse(Edt_Tax.text),
                          Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_Disc.text),
                          Edt_Balance.text.isEmpty ? 0 : double.parse(Edt_Balance.text),
                          Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                          'D',
                          0,
                          '',
                          0,
                          '',
                          '',
                          '',
                          widget.ScreenID,
                          widget.ScreenName,
                          int.parse(sessionuserID));
                    }
                  },
                  child: Text('Hold'),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(onPressed: () {}, child: Text('Dis.Appr')),
                SizedBox(
                  width: 5,
                ),

                SizedBox(
                  width: 5,
                ),
                Visibility(
                  visible: true,
                  child: ElevatedButton(
                    onPressed: () {

                      //log(jsonEncode(TepmSaveMixBoxMaster));
                      MyPriceListSync();

                    },
                    child: Text('Check'),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget  MobileDraftMethod(BuildContext context, double height,double width) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            children: [
              new Expanded(
                flex: 4,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Mobile,
                    style: TextStyle(fontSize: height/30),
                    enabled: true,
                    onTap: () {
                      var EnterMobileNo;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            autofocus: true,
                            onChanged: (vvv) {
                              EnterMobileNo = vvv;
                              if (EnterMobileNo.toString().length == 10) {
                                Edt_Mobile.text = EnterMobileNo;
                                Navigator.pop(contex1);
                              }
                            },
                          ),
                          title: Text("Enter Mobile no"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Mobile.text = EnterMobileNo;
                                            Navigator.pop(
                                              contex1,
                                              'Ok',
                                            );
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.pop(contex1, 'Cancel'),
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cus.MobileNo",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0),),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              new Expanded(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_CustCharge,
                    readOnly: true,
                    style: TextStyle(fontSize: height/30),
                    onTap: () {
                      var EnterEdtCustCharge;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtCustCharge = vvv;
                            },
                          ),
                          title: Text("Enter Customer Charge"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_CustCharge.text = EnterEdtCustCharge;
                                            MyLocCount();
                                            Navigator.pop(
                                              contex1,
                                              'Ok',
                                            );
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.pop(contex1, 'Cancel'),
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
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cust.Charge",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Disc,
                    style: TextStyle(fontSize: height/35),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    onTap: () {
                      var EnterEdtDisc;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtDisc = vvv;
                            },
                          ),
                          title: Text("Enter Discount Amt"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Disc.text = EnterEdtDisc;
                                            MyLocCount();
                                            Navigator.pop(
                                              contex1,
                                              'Ok',
                                            );
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.pop(contex1, 'Cancel'),
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
                    decoration: InputDecoration(
                      labelText: "Appr.Disc%/Rup",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              new Expanded(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    readOnly: true,
                    controller: Edt_Tax,
                    style: TextStyle(fontSize: height/35),
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Tax",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              new Expanded(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    style: TextStyle(fontSize: height/35, fontWeight: FontWeight.bold),
                    controller: Edt_Total,
                    enabled: false,
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    decoration: InputDecoration(
                      labelText: "Total.Amount",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Advance,
                    readOnly: true,
                    style: TextStyle(fontSize: height/35),
                    onTap: () {
                      var EnterEdtAdvance;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (vvv) {
                              EnterEdtAdvance = vvv;
                            },
                          ),
                          title: Text("Enter Advanced Amt"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Advance.text = EnterEdtAdvance;
                                            MyLocCount();
                                            Navigator.pop(
                                              contex1,
                                              'Ok',
                                            );
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.pop(contex1, 'Cancel'),
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
                    decoration: InputDecoration(
                      labelText: "Advance",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Balance,
                    enabled: false,
                    style: TextStyle(fontSize: height/35),
                    onSubmitted: (value) {
                      print("Onsubmit,$value");
                    },
                    decoration: InputDecoration(
                      labelText: "Bal.Due",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
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
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Delcharge,
                    readOnly: true,
                    onTap: () {
                      var EnterEdtDelcharge;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: height/35),
                            onChanged: (vvv) {
                              EnterEdtDelcharge = vvv;
                            },
                          ),
                          title: Text("Enter Delivery Amt"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            Edt_Delcharge.text = EnterEdtDelcharge;
                                            MyLocCount();
                                            Navigator.pop(
                                              contex1,
                                              'Ok',
                                            );
                                          });
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.pop(contex1, 'Cancel'),
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
                    decoration: InputDecoration(
                      labelText: "Del.Charge",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  color: Colors.white,
                  child: new TextField(
                    style: TextStyle(fontSize: height/35, fontWeight: FontWeight.bold),
                    controller: Edt_NetTotal,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Net Total",
                      labelStyle: TextStyle(fontSize: height/30),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                height: height/12,
                child: FloatingActionButton.extended(
                  heroTag: "Print & Settlement",
                  backgroundColor: Colors.blue,
                  icon: Icon(Icons.print,size: height/30,),
                  label: Text('Print & Settlement',style: TextStyle(fontSize: height/30),),
                  onPressed: () {

                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(
                          context, "Total Should Not Left Empty!");
                    } else if (Edt_CustCharge.text.isEmpty) {
                      showDialogboxWarning(
                          context, "Customer Charge Should Not Left Empty!");
                    } else if (Edt_Delcharge.text.isEmpty) {
                      showDialogboxWarning(
                          context, "DelCharge Charge Should Not Left Empty!");
                    } else if (altersalespersoncode.isEmpty) {
                      showDialogboxWarning(
                          context, "Please Choose Sales person!");
                    } else if (Edt_Mobile.text.toString().length != 10) {
                      showDialogboxWarning(
                          context, "The Cus Mobile No Should Be 10..");
                    }
                    else {
                      pagecontroller.jumpToPage(2);

                      getoccation(int.parse(sessionuserID), int.parse(sessionbranchcode));
                      getstate(2, sessionuserID);
                      getcountry(1, sessionuserID);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: height/12,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel',style: TextStyle(fontSize: height/30))),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: height/12,
                child: ElevatedButton(
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    } else if (Edt_CustCharge.text.isEmpty) {
                      showDialogboxWarning(context, "Customer Charge Should Not Left Empty!");
                    } else if (Edt_Delcharge.text.isEmpty) {
                      showDialogboxWarning(context, "DelCharge Charge Should Not Left Empty!");
                    } else if (altersalespersoncode.isEmpty) {
                      showDialogboxWarning(context, "Please Choose Sales person!");
                    } else {
                      settlementisclicked = 0;
                      insertSalesHeader(
                          HoldDocLine,
                          formatter.format(DateTime.now()),
                          Edt_Mobile.text,
                          formatter.format(DateTime.now()),
                          '',
                          //OccCode
                          '',
                          //OccName
                          formatter.format(DateTime.now()),
                          '',
                          //Message
                          altersalespersoncode.toString(),
                          //ShapeCode
                          altersalespersoname,
                          //ShapeName
                          'N',
                          Edt_CustCharge.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                          Edt_Advance.text.isEmpty ? 0 : double.parse(Edt_Advance.text),
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          Edt_Delcharge.text.isEmpty ? 0 : double.parse(Edt_Delcharge.text),
                          batchcount,
                          Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                          Edt_Tax.text.isEmpty ? 0 : double.parse(Edt_Tax.text),
                          Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_Disc.text),
                          Edt_Balance.text.isEmpty ? 0 : double.parse(Edt_Balance.text),
                          Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                          'D',
                          0,
                          '',
                          0,
                          '',
                          '',
                          '',
                          widget.ScreenID,
                          widget.ScreenName,
                          int.parse(sessionuserID));
                    }
                  },
                  child: Text('Hold'),
                ),
              ),

            ],
          ),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }

  Widget RupeesButton(BuildContext context, String Name, int Position) {
    return ElevatedButton(
        onPressed: () {
          _onClick(Name);
        },
        child: Text(Name));
  }

  void _onClick(String value) {
    print(value);
    getvalue += double.parse(value);
    print(getvalue);
    DelReceiveAmount.text = "";
    DelReceiveAmount.text = getvalue.toStringAsFixed(2);
    double remaining = DelReceiveAmount.text.isEmpty
        ? 0 : (double.parse(DelReceiveAmount.text) - double.parse(Edt_Total.text));
    if (DelReceiveAmount.text.isEmpty) {
      Edt_Balance.text = "0.00";
    } else {
      Edt_Balance.text = remaining.toStringAsFixed(2);
    }
  }

  void addpaymentDatatble(String alterpayment, String ReceiveAmount, String Bill, String Balance, String Remarks) {
    int count = 0;
    setState(() {
      paymenttemplist.add(
        SalesPayment(alterpayment, ReceiveAmount, Bill, Balance, Remarks),
      );
      DelReceiveAmount.text = "";
      Edt_Total.text = "";
      BalanceAmount.text = "";
      Edt_PayRemarks.text = "";
    });
  }

  void decrement(int index) {
    setState(() {
      if (double.parse(templist[index].qty.toString()) <= 1) {
        Fluttertoast.showToast(msg: "You Cannot put less than 0");
        return;
      } else {
        templist[index].qty--;
        double qq = double.parse(templist[index].qty.toString());
        templist[index].amount = templist[index].qty * templist[index].price;
        /* qtycontroller.text = templist[index].qty--;*/
        //qtycontroller[index].text = qq.toString();
        count();
      }
    });
  }

  void increment(int index) {
    setState(() {
      print(templist[index].stock);
      print(templist[index].qty);
      if (double.parse(templist[index].qty.toString()) == 100) {
        Fluttertoast.showToast(msg: "You Cannot more than 100 Qty");
      }
      /* if (double.parse(templist[index].qty.toString()) >=
          double.parse(templist[index].stock.toString())) {
        Fluttertoast.showToast(msg: "You Cannot more than Stock Qty");
      }*/
      else {
        templist[index].qty++;
        double qq = double.parse(templist[index].qty.toString());
        templist[index].amount = templist[index].qty * templist[index].price;
        //  qtycontroller[index].text = qq.toString();
        count();
      }
    });
  }

  void count() async {
    setState(() {
      batchcount = 0;
      double batchamount = 0;
      batchamount1 = 0;
      taxamount = 0;
      var taxamount1 = 0;
      Edt_Total.text = '';
      for (int s = 0; s < templist.length; s++) {
        if (double.parse(templist[s].qty.toString()) > 0) {
          batchcount++;
          batchamount += double.parse(templist[s].amount.toString());
          if (widget.OrderNo == 0) {
            templist[s].tax = ((double.parse(templist[s].TaxCode.split("@")[1]) *templist[s].amount) /100).round();
            taxamount1 += templist[s].tax;
          } else {
            templist[s].tax = ((double.parse(templist[s].TaxCode.split("@")[1]) *templist[s].amount) /100).round();
            taxamount1 += templist[s].tax;
          }
        }
      }
      Edt_Balance.text = batchamount1.toStringAsFixed(2).toString();

      if (Edt_Disc.text.isNotEmpty) {
        Edt_Balance.text =(double.parse(Edt_Balance.text) - double.parse(Edt_Disc.text)).toString();
      }
      if (Edt_Advance.text.isNotEmpty) {
        Edt_Balance.text = (double.parse(Edt_Balance.text) - double.parse(Edt_Advance.text)).toString();
      }

      Edt_Total.text = batchamount.round().toString();
      Edt_Balance.text = batchamount.toStringAsFixed(2).toString();
      Edt_Tax.text = taxamount1.round().toString();
      Edt_Total.text = batchamount.round().toString();
      Edt_NetTotal.text = (batchamount + taxamount).toStringAsFixed(2);
    });

    MyLocCount();

  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('getStringValuesSF');
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      sessionIPAddress = prefs.getString("SaleInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));
      print('USERID$sessionuserID');
      print("sesse" + sessionbranchname.toString());
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
              MyPriceListSync();
              getTranportcount();
              getcategoriesoffline();

              if (widget.OrderNo == 0) {
              print("FromDashBoard");
              } else {
              print("FromTranctionScreen");
              GetMyUpdateTablRecord();
              GetMyUpdatePayMentTablRecord();
              }
            });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<List> getShitIdCheck() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "SELECT * FROM IN_MOB_SHIFT_OPEN WHERE DocDate=DATE()  AND CounterId = '$sessionbranchcode' And UserId = '$sessionuserID' And Status = 'O'");
    log("{\"status\":\1\,\"result\":  ${jsonEncode(list)}}");
    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "Kindly Open The Shift..");
    } else {
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
        MyPriceListSync();
        getTranportcount();
        getcategoriesoffline();
        if (widget.OrderNo == 0) {
          print("FromDashBoard");
        } else {
          print("FromTranctionScreen");
          GetMyUpdateTablRecord();
          GetMyUpdatePayMentTablRecord();
        }
      });

    }
  }

  Future<http.Response> getTranportcount() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "LocCode": int.parse(sessionbranchcode),
    };
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getTransferDatacount'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            loading = false;
          });
        } else {
          setState(() {
            log(response.body);
            RawTransportCountModel =
                TransportCountModel.fromJson(jsonDecode(response.body));

            loading = false;
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    } on SocketException {
      setState(() {
        loading = false;
      });
      throw Exception('Internet is down');
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

  // Future<http.Response> GetIpAddress() async {
  //   var headers = {"Content-Type": "application/json"};
  //   setState(() {
  //     loading = true;
  //     print('Selva - IP Address');
  //     print('Selva - IP' + sessionbranchname.toString());
  //     //SecMyPricelistMasterSubTab2Model.clear();
  //   });
  //   var body = {
  //     "FromId": 5,
  //     "ScreenId": 0,
  //     "DocNo": 1,
  //     "DocEntry": 10,
  //     "Status": sessionbranchname.toString(),
  //     "FromDate": "FromDate",
  //     "ToDate": "ToDate"
  //   };
  //   print(sessionuserID);
  //
  //   final response = await http.post(
  //       Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
  //       headers: headers,
  //       body: jsonEncode(body));
  //   setState(() {
  //     loading = false;
  //   });
  //   print(jsonDecode(response.body)["result"]);
  //   if (response.statusCode == 200) {
  //     final decode = jsonDecode(response.body);
  //     if (decode["testdata"].toString() == '[]') {
  //       setState(() {
  //         loading = false;
  //         RawGetIPAddressModel = null;
  //       });
  //       print('NoResponse');
  //     } else {
  //       RawGetIPAddressModel = null;
  //       print('YesResponce');
  //       print(response.body);
  //       RawGetIPAddressModel =
  //           GetIPAddressModel.fromJson(jsonDecode(response.body));
  //       for (int i = 0; i < RawGetIPAddressModel.testdata.length; i++);
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to Login API');
  //   }
  // }

  void categoriesonline() {
    setState(() {
      loading = true;
      print('Online Data');
    });
    GetAllCategories(1, int.parse(sessionuserID), 0, 0).then((response) {
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
          categoryitem.result.clear();
        } else {
          setState(() {
            categoryitem = CategoriesModel.fromJson(jsonDecode(response.body));
            print('ONCLICK$onclick');
            if (onclick == 0) {
              getdetailitemsonline("0", 0);
            }
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

  Future<http.Response> GetMyUpdateTablRecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print("OrderNo" + widget.OrderNo.toString());
    });
    var body = {
      "FromId": 3,
      "ScreenId": 0,
      "DocNo": widget.OrderNo,
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
          RawMySaleOrderGetLIneData == null;
        });
        print('Selva-TabctionScreen + NoResponse');
      } else {
        RawMySaleOrderGetLIneData == null;
        print('YesResponce');
        print(response.body);
        setState(() {
          RawMySaleOrderGetLIneData = MySaleOrderGetLIneData.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawMySaleOrderGetLIneData.testdata.length; i++) {
            templist.add(
              SalesTempItemResult(
                  RawMySaleOrderGetLIneData.testdata[i].itemCode,
                  RawMySaleOrderGetLIneData.testdata[i].itemName,
                  RawMySaleOrderGetLIneData.testdata[i].itemGroupCode,
                  RawMySaleOrderGetLIneData.testdata[i].uom,
                  RawMySaleOrderGetLIneData.testdata[i].price,
                  RawMySaleOrderGetLIneData.testdata[i].amount,
                  RawMySaleOrderGetLIneData.testdata[i].qty,
                  RawMySaleOrderGetLIneData.testdata[i].itemGropName,
                  RawMySaleOrderGetLIneData.testdata[i].pictureName,
                  RawMySaleOrderGetLIneData.testdata[i].pictureURL,
                  RawMySaleOrderGetLIneData.testdata[i].taxAmount,
                  '',
                  'varince',
                  RawMySaleOrderGetLIneData.testdata[i].taxAmount,0),
            );
            altersalespersoname = RawMySaleOrderGetLIneData.testdata[i].FirstName;
            altersalespersoncode = RawMySaleOrderGetLIneData.testdata[i].EmpId.toString();
          }
          count();
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetMyUpdatePayMentTablRecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print("OrderNo" + widget.OrderNo.toString());
    });
    var body = {
      "FromId": 4,
      "ScreenId": 0,
      "DocNo": widget.OrderNo,
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
          //RawMySaleOrderGetLIneData == null;
        });
        print('Selva-PayMent + NoResponse');
      } else {
        //RawMySaleOrderGetLIneData == null;
        print('Selva-PayMent + YesResponce');
        print(response.body);
        setState(() {
          RawMySaleOrderGetPaymentData =
              MySaleOrderGetPaymentData.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawMySaleOrderGetPaymentData.testdata.length; i++)
            paymenttemplist.add(
              SalesPayment(
                  RawMySaleOrderGetPaymentData.testdata[i].payType,
                  RawMySaleOrderGetPaymentData.testdata[i].recvAmt,
                  RawMySaleOrderGetPaymentData.testdata[i].billAmt,
                  RawMySaleOrderGetPaymentData.testdata[i].balanceAmt,
                  RawMySaleOrderGetPaymentData.testdata[i].remarks),
            );
          count();
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  void getdetailitemsonline(String groupcode, int onclick) {
    setState(() {
      loading = true;
      print('Online Data getdetailitemsonline');
      print("sessionuserID" + sessionuserID);
      print("groupcode" + groupcode);
      print("sessionbranchcode" + sessionbranchcode);
    });
    GetAllCategories(2, int.parse(sessionuserID), sessionbranchcode,
            onclick == 0 ? '0' : groupcode)
        .then((response) {
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
          itemodel.result.clear();
        } else {
          setState(() {
            itemodel = SalesItemModel.fromJson(jsonDecode(response.body));

            salesPersonget(
                int.parse(sessionuserID), int.parse(sessionbranchcode));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void salesPersonget(int USERID, int BRANCHID) {
    setState(() {
      loading = true;
      print('Online Data salesPersonget');
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

  Future<List> getMixBoxoffline() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "SELECT A.ItemCode As RefItemCode,   B.ItemCode As ItemCode ,B.ItemName As ItemName,B.Qty As Qty,C.InvntryUom As Uom FROm IN_MOB_MIXBOX_MASTER A INNER JOIN  IN_MOB_MIXBOXCHILD B ON A.DocNo = B.DocNo INNER JOIN OITM C ON B.ItemCode = C.ItemCode");
    log("{\"status\":\1\,\"result\":  ${jsonEncode(list)}}");
    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      //showDialogboxWarning(this.context, "No Data");
    } else {
      try {
        setState(() {
          RawMixBoxChild = MixBoxChild.fromJson(
              jsonDecode("{\"status\":\1\,\"result\": ${jsonEncode(list)}}"));
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List> getcategoriesoffline() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "Select Code,Name,Imgurl from(Select  ItmsTypCod'Code',ItmsGrpNam'Name',''as Imgurl from OITG UNION Select '99' as 'Code','Favourites' as 'Name',''as Imgurl)X  LIMIT 8");
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
          categoryitem = CategoriesModel.fromJson(
              jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
          print('ONCLICK$onclick');
          if (onclick == 0) {
            getdetailitemsoffline("0", 0);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List> getdetailitemsoffline(String groupcode, int onclick) async {
    print('va');
    print(groupcode);
    print(sessionbranchcode);
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list;
    print(groupcode);
    print(onclick);
    if (onclick == 0) {
      print(sessionbranchcode);
      log("selva If00");
      list = await database.rawQuery(
          "SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup1 = 'Y' And E.ItmsTypCod ='1' AND P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName,('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup2 = 'Y' And E.ItmsTypCod ='2' AND P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup3 = 'Y' And E.ItmsTypCod ='3' And P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup4 = 'Y' And E.ItmsTypCod ='4' AND P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup5 = 'Y' And E.ItmsTypCod ='5' AND P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup6 = 'Y' And E.ItmsTypCod ='6' AND P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup7 = 'Y' And E.ItmsTypCod ='7' AND P.Location in ('$sessionbranchcode',0) UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup8 = 'Y' And E.ItmsTypCod ='8' AND P.Location in ('$sessionbranchcode',0)UNION ALL SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)ItmsGrpCod,C.InvntryUom as 'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName, ('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE QryGroup10 = 'Y' And E.ItmsTypCod ='10' AND P.Location in ('$sessionbranchcode',0)");
      print(jsonEncode(list));
    } else {
      print(" selva ELSE PART");
      list = await database.rawQuery(
          "SELECT IFNULL(P.ItemNos,'') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)'ItmsGrpCod',C.InvntryUom as'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Rate/100)+ P.Rate As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName,('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN (SELECT  A.ItemCode, A.Location,B.ItemNos,A.Rate FROM  IN_MOB_PRICELISTMASTER A LEFT JOIN IN_MOB_VARIANCE_MASTER_LIN B ON A.ItemCode = B.ItemCode and A.variance = B.ItemVariance WHERE A.Active = 'Y') As P ON C.ItemCode = P.ItemCode WHERE (QryGroup$groupcode)= 'Y' And E.ItmsTypCod ='$groupcode' AND P.Location in ('$sessionbranchcode',0)	 UNION ALL SELECT IFNULL('','') As Variance,C.Flag,C.OnHand,IFNULL(X1.TaxCode,'')TaxCode,C.ItemCode, C.ItemName,CAST(C.ItmsGrpCod as INT)'ItmsGrpCod',C.InvntryUom as'UOM',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Qty/100)+ P.Qty as 'Price',(substr(X1.TaxCode, instr(X1.TaxCode,'@')+1, length(X1.TaxCode))*P.Qty/100)+ P.Qty As 'Amount',0 as 'Qty',D.ItmsGrpNam,E.ItmsGrpNam,IFNULL(C.PicturName,'')PicturName,('assets/Images/'||C.PicturName)as'ImgUrl',C.OnHand As OnHand FROM OITM C LEFT JOIN OITB D ON C.ItmsGrpCod=D.ItmsGrpCod LEFT JOIN TCD2 X On X.KeyFld_1_V=C.ItemCode LEFT JOIN TCD3 X1 On X.AbsId=X1.AbsId CROSS JOIN OITG E INNER JOIN IN_MOB_MIXBOX_MASTER P ON C.ItemCode = P.ItemCode WHERE (QryGroup$groupcode)= 'Y' And E.ItmsTypCod ='$groupcode' AND P.Location in ('$sessionbranchcode',0)");
    }

    List<Map> listl =await database.rawQuery("SELECT NextNo FROM IN_MOB_DocNoSeries");
    print(jsonEncode(listl));
    print("LENGTH${list.length}");

    var num = jsonEncode(listl);

    setState(() {
      final decode = jsonDecode(num);
      print(decode[0]["NextNo"]);
      NextBillNo = decode[0]["NextNo"];
      print('NextBillNo' + NextBillNo.toString());
      print(sessionbranchname + "/" + NextBill + "/" + NextBillNo.toString());

      MyBillNo = sessionuserID +
          "/" +
          sessionbranchname +
          "/" +
          NextBill +
          "/" +
          tdata +
          "/" +
          NextBillNo.toString();
      getMixBoxoffline();
    });

    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "No Data");
      getsalesPersonoffline();
    } else {
      try {
        setState(() {
          itemodel = SalesItemModel.fromJson(
            jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"),
          );
          print(
            jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"),
          );
          getsalesPersonoffline();
        });
      } catch (e) {
        showDialogboxWarning(this.context, e.toString());
      }
    }
  }

  Future<List> getsalesPersonoffline() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "Select Code As empID,(firstName||lastName)as Name from OHEM where Active='Y'");
    print(jsonEncode(list));
    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "No Data Emp Ofline");
    } else {
      try {
        setState(() {
          salespersonmodel = EmpModel.fromJson(
              jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
          print(salespersonmodel.result.length);
          careoflist.clear();
          salespersonlist.clear();

          for (int k = 0; k < salespersonmodel.result.length; k++) {
            salespersonlist.add(salespersonmodel.result[k].name);
            careoflist.add(salespersonmodel.result[k].name);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  GetMyHoldRocord() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {
        List<Map> list = await txn.rawQuery(
            "select DISTINCT A.CustomerNo As CustomerNo,A.OrderNo AS OrderNo,A.OrderDate AS OrderDate,A.TotQty,A.TotAmount,A.BalanceDue,A.OrderStatus As 'Status',A.ScreenID As ScreenID,'' As ScreenName from IN_MOB_SALES_INV_HEADER A INNER JOIN IN_MOB_SALES_INV_DETAILS B ON A.OrderNo=B.HeaderDocNo WHERE A.OrderStatus ='D'");
        print(jsonEncode(list));
        RawMyHoldGetLineModel = MyTranctionGetLineModel.fromJson(
            jsonDecode("{\"testdata\": ${json.encode(list)}}"));

        for (int i = 0; i < RawMyHoldGetLineModel.testdata.length; i++) {
          print(RawMyHoldGetLineModel.testdata[i].orderNo);
        }
      });
    } catch (Excetion) {
      print(Excetion);
    }
  }

  GetMyHoldLineRocord() async {
    templist.clear();
    RawMySaleOrderGetLIneData == null;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {
        List<Map> list = await txn.rawQuery(
            "select  A.ReqDiscount As ApprovedDiscount,A.DelCharge As DelCharge,A.AdvanceAmount As AdvanceAmount,A.CustCharge AS CustCharge,A.CustomerNo As CustomerNo,CategoryName As CategoryName,B.HeaderDocNo As HeaderDocNo,B.ItemCode,B.ItemName,B.ItemGroupCode,B.Uom,B.Price ,B.Qty, "
                    "B.Total As Amount,0 AS ItemGropName,B.PictureName,B.PictureURL,Tax As TaxCode,'SaleInvoice' As 'SCName',"
                    "'' As ItemGropName,A.ShapeCode As EmpId,D.firstName As FirstName,A.OrderStatus As Status,A.TaxAmount As TaxAmount,"
                    "A.TotAmount As TotAmount,B.ItemComboNo As ItemComboNo from IN_MOB_SALES_INV_HEADER A INNER JOIN IN_MOB_SALES_INV_DETAILS B ON A.OrderNo=B.HeaderDocNo "
                    "INNER JOIN OHEM D ON A.ShapeCode = D.Code WHERE B.HeaderDocNo=" +
                HoldDocLine.toString());
        print(jsonEncode(list));

        List<Map> mixlist = await txn.rawQuery("SELECT * FROM IN_MOB_SALES_INV_MIXMASTER WHERE SqlRefNo=" + HoldDocLine.toString());
        log("{\"testdata\": ${json.encode(mixlist)}}");

        RawMySaleOrderGetLIneData = MySaleOrderGetLIneData.fromJson(jsonDecode("{\"testdata\": ${json.encode(list)}}"));
        for (int i = 0; i < RawMySaleOrderGetLIneData.testdata.length; i++) {
          print("SelvaUOM iS : - >" + RawMySaleOrderGetLIneData.testdata[i].uom);
          setState(() {
            templist.add(
              SalesTempItemResult(
                  RawMySaleOrderGetLIneData.testdata[i].itemCode,
                  RawMySaleOrderGetLIneData.testdata[i].itemName,
                  RawMySaleOrderGetLIneData.testdata[i].itemGroupCode,
                  RawMySaleOrderGetLIneData.testdata[i].uom,
                  RawMySaleOrderGetLIneData.testdata[i].price,
                  RawMySaleOrderGetLIneData.testdata[i].amount,
                  RawMySaleOrderGetLIneData.testdata[i].qty,
                  RawMySaleOrderGetLIneData.testdata[i].itemGropName,
                  RawMySaleOrderGetLIneData.testdata[i].pictureName,
                  RawMySaleOrderGetLIneData.testdata[i].pictureURL,
                  0.00,
                  '',
                  '',
                  RawMySaleOrderGetLIneData.testdata[i].TaxCode,
                  RawMySaleOrderGetLIneData.testdata[i].ItemComboNo),
            );

            RawMixboxmodel = Mixboxmodel.fromJson(jsonDecode("{\"testdata\": ${json.encode(mixlist)}}"));
            TepmSaveMixBoxMaster.clear();
            for(int m = 0 ; m< RawMixboxmodel.testdata.length;m++){
            TepmSaveMixBoxMaster.add(SaveMixBoxMaster(
                RawMixboxmodel.testdata[m].refItemCode,
                RawMixboxmodel.testdata[m].itemCode,
                RawMixboxmodel.testdata[m].itemName,
                RawMixboxmodel.testdata[m].qty,
                RawMixboxmodel.testdata[m].actualQty,
                RawMixboxmodel.testdata[m].uom,
                RawMixboxmodel.testdata[m].comboNo,
                RawMixboxmodel.testdata[m].sqlRefNo));
            }


            // templist.add(SalesTempItemResult(itemCode, itemName, itmsGrpCod, uOM, price, amount, qty, itmsGrpNam,
            //     picturName, imgUrl, tax, stock, Varince, TaxCode))

            altersalespersoname = RawMySaleOrderGetLIneData.testdata[i].FirstName;
            altersalespersoncode = RawMySaleOrderGetLIneData.testdata[i].EmpId.toString();
            Edt_Tax.text = RawMySaleOrderGetLIneData.testdata[i].Totltaxamt.toString();
            Edt_Total.text = RawMySaleOrderGetLIneData.testdata[i].totalamt.toString();
            Edt_Mobile.text = RawMySaleOrderGetLIneData.testdata[i].CustomerNo.toString();

            //
            Edt_Delcharge.text = RawMySaleOrderGetLIneData.testdata[i].DelCharge.toString();
            Edt_CustCharge.text = RawMySaleOrderGetLIneData.testdata[i].CustCharge.toString();
            Edt_Disc.text = RawMySaleOrderGetLIneData.testdata[i].ApprovedDiscount.toString();
            //
            count();
          });
        }
      });
    } catch (Excetion) {
      print(Excetion);
    }
  }

  Future<List> MyPriceListSync() async {
    setState(() {
      print('MyPriceListSync');
    });

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {

        // await txn.rawDelete("DELETE FROM IN_MOB_SALES_INV_HEADER");
        // await txn.rawDelete("DELETE FROM IN_MOB_SALES_INV_DETAILS");
        // await txn.rawUpdate("DELETE FROM IN_MOB_SALES_INV_PAYMENT");
        // await txn.rawUpdate("DELETE FROM IN_MOB_SALES_INV_MIXMASTER");

        List<Map> list = await txn.rawQuery("SELECT NextNo FROM IN_MOB_DocNoSeries");
        print(jsonEncode(list));
        print("LENGTH${list.length}");

        var num = jsonEncode(list);

        setState(() {
          final decode = jsonDecode(num);
          print(decode[0]["NextNo"]);
          NextBillNo = decode[0]["NextNo"];

          print(
              sessionbranchname + "/" + NextBill + "/" + NextBillNo.toString());

          MyBillNo = sessionuserID +
              "/" +
              sessionbranchname +
              "/" +
              NextBill +
              "/" +
              tdata +
              "/" +
              NextBillNo.toString();
        });

        //log(jsonEncode(list));
      });
      await database.close();
    } catch (Excetion) {
      print(Excetion);
    }
  }

  PriceListSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM IN_MOB_PRICELISTMASTER");

        for (int i = 0; i < RawPriceListSyncModel.testdata.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO IN_MOB_PRICELISTMASTER ([DocNo] ,[ItemCode] ,[ItemName], [ItemUOM] ,[Location] ,[LocationName],[variance] ,[OccCode] ,[OccName] ,[Rate],"
              "[DocDate] ,[CreateBy] ,[TapIndex] ,[Sync],[Active]) VALUES ("
              "${RawPriceListSyncModel.testdata[i].docNo},"
              "'${RawPriceListSyncModel.testdata[i].itemCode}',"
              "'${RawPriceListSyncModel.testdata[i].itemName}',"
              "'${RawPriceListSyncModel.testdata[i].itemUOM}',"
              "'${RawPriceListSyncModel.testdata[i].location}',"
              "'${RawPriceListSyncModel.testdata[i].locationName}',"
              "'${RawPriceListSyncModel.testdata[i].variance}',"
              "'${RawPriceListSyncModel.testdata[i].occCode}',"
              "'${RawPriceListSyncModel.testdata[i].occName}',"
              "'${RawPriceListSyncModel.testdata[i].rate}',"
              "'${RawPriceListSyncModel.testdata[i].docDate}',"
              "'${RawPriceListSyncModel.testdata[i].createBy}',"
              "'${RawPriceListSyncModel.testdata[i].tapIndex}',"
              "'${RawPriceListSyncModel.testdata[i].sync}','${RawPriceListSyncModel.testdata[i].active}')");
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

  Future<http.Response> GetMyHoldLineRocordOnline() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();
      RawMySaleOrderGetLIneData == null;
    });
    var body = {
      "FromId": 7,
      "ScreenId": 0,
      "DocNo": int.parse(sessionuserID),
      "DocEntry": int.parse(HoldDocLine.toString()),
      "Status": "D",
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
    var nodata = jsonDecode(response.body)['status'] == 0;
    print(response.body);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          //RawMyHoldGetLineModel == '';
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        RawMySaleOrderGetLIneData =
            MySaleOrderGetLIneData.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawMySaleOrderGetLIneData.testdata.length; i++) {
          setState(() {
            templist.add(
              SalesTempItemResult(
                  RawMySaleOrderGetLIneData.testdata[i].itemCode,
                  RawMySaleOrderGetLIneData.testdata[i].itemName,
                  RawMySaleOrderGetLIneData.testdata[i].itemGroupCode,
                  RawMySaleOrderGetLIneData.testdata[i].uom,
                  RawMySaleOrderGetLIneData.testdata[i].price,
                  RawMySaleOrderGetLIneData.testdata[i].amount,
                  RawMySaleOrderGetLIneData.testdata[i].qty,
                  RawMySaleOrderGetLIneData.testdata[i].itemGropName,
                  RawMySaleOrderGetLIneData.testdata[i].pictureName,
                  RawMySaleOrderGetLIneData.testdata[i].pictureURL,
                  RawMySaleOrderGetLIneData.testdata[i].taxAmount,
                  '',
                  '',
                  'Tax@123',0),
            );
            altersalespersoname =
                RawMySaleOrderGetLIneData.testdata[i].FirstName;
            altersalespersoncode =
                RawMySaleOrderGetLIneData.testdata[i].EmpId.toString();
            Edt_Tax.text =
                RawMySaleOrderGetLIneData.testdata[i].Totltaxamt.toString();
            Edt_Total.text =
                RawMySaleOrderGetLIneData.testdata[i].totalamt.toString();
            // Edt_Advance.text =
            //     RawMySaleOrderGetLIneData.testdata[i].S.toString();
          });
        }
        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<List> insertSalesHeader(
      int OrderNo, String OrderDate, String CustomerNo, String DelDate, String OccCode, String OccName, String OccDate,
      String Message, String ShapeCode, String ShapeName, String DoorDelivery, double CustCharge, double AdvanceAmount,
      String DelStateCode, String DelStateName, String DelDistCode, String DelDistName, String DelPlaceCode, String DelPlaceName,
      double DelCharge, double TotQty, double TotAmount, double TaxAmount, double ReqDiscount, double BalanceDue, double OverallAmount,
      String OrderStatus, int ApproverID, String ApproverName, double ApprovedDiscount, String ApprovedStatus, String ApprovedRemarks1,
      String ApprovedRemarks2, int ScreenID, String ScreenName, int UserID) async {
    setState(() {
      loading = true;
    });

    print('door $DoorDelivery');
    print('DelDate $DelDate');
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    var now = new DateTime.now();
    try {
      await database.transaction((txn) async {
        var prinddelet = await txn.rawDelete(
          "DELETE  FROM IN_MOB_SALES_INV_HEADER WHERE OrderNo=" + OrderNo.toString(),
        );
        //rawDelete
        await txn.rawInsert(
            "INSERT INTO IN_MOB_SALES_INV_HEADER ([OrderDate],[CustomerNo],[DeliveryDate],[OccCode],[OccName],"
            "[OccDate],[Message],[ShapeCode],[ShapeName],[DoorDelivery],[CustCharge],[AdvanceAmount],"
            "[DelStateCode],[DelStateName],[DelDistCode],[DelDistName],[DelPlaceCode],[DelPlaceName],"
            "[DelCharge],[TotQty],[TotAmount],[TaxAmount],[ReqDiscount],[BalanceDue] ,[OverallAmount],"
            "[OrderStatus],[ApproverID],[ApproverName],[ApprovedDiscount],[ApprovedStatus],[ApprovedRemarks1],"
            "[ApprovedRemarks2] ,[ScreenID],[ScreenName],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],"
            "[BranchID],[BillNo],[BlanceAmt],[ShiftId])"
            "VALUES ('$OrderDate','$CustomerNo','$DelDate','$OccCode','$OccName',"
            "'$OccDate','$Message','$ShapeCode','$ShapeName','$DoorDelivery','$CustCharge',"
            "'$AdvanceAmount','$DelStateCode','$DelStateName','$DelDistCode','$DelDistName','$DelPlaceCode',"
            "'$DelPlaceName','$DelCharge','$TotQty','$TotAmount','$TaxAmount','$ReqDiscount','$BalanceDue',"
            "'$OverallAmount','$OrderStatus','$ApproverID','$ApproverName','$ApprovedDiscount','$ApprovedStatus',"
            "'$ApprovedRemarks1','$ApprovedRemarks2',${int.parse(widget.ScreenID.toString())},'Sales Invoice',"
            "${int.parse(sessionuserID)},'$OrderDate',${int.parse(sessionuserID)},'$OrderDate',"
            "${int.parse(sessionbranchcode)},'$MyBillNo' ,'${Edt_BlanceBillAmt.text}','${MyShitId.toString()}')");
        // await txn.rawInsert(
        //     "INSERT INTO IN_MOB_SALES_INV_HEADER ([OrderDate],[CustomerNo],[DeliveryDate],[OccCode],[OccName],[OccDate],[Message],[ShapeCode],[ShapeName],[DoorDelivery],[CustCharge],[AdvanceAmount],[DelStateCode],[DelStateName],[DelDistCode],[DelDistName],[DelPlaceCode],[DelPlaceName],[DelCharge],[TotQty],[TotAmount],[TaxAmount],[ReqDiscount],[BalanceDue] ,[OverallAmount],[OrderStatus],[ApproverID],[ApproverName],[ApprovedDiscount],[ApprovedStatus],[ApprovedRemarks1],[ApprovedRemarks2] ,[ScreenID],[ScreenName],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[BranchID])VALUES ('2022-02-04','0','2022-02-04','0','0','2022-02-04','0','0','0','N','0.0','0.0','0','0','0','0','0','0','0.0','2.0','200.0','0.0','0.0','200.0','200.0','D','0','','0.0','0','0','0',2,'Sales Invoice',3,'2022-02-04',3,'2022-02-04',4)");

        var printid = await txn.rawQuery(
            "SELECT OrderNo FROM IN_MOB_SALES_INV_HEADER WHERE OrderNo=(SELECT max(OrderNo) FROM IN_MOB_SALES_INV_HEADER)");

        var jsonUser = json.encode(printid[0]);

        mainorderno = json.decode(jsonUser)["OrderNo"];

        print("mainorderno"+mainorderno.toString());

        for (int i = 0; i < templist.length; i++) {
          var prinddelet = await txn.rawDelete(
              "DELETE  FROM IN_MOB_SALES_INV_DETAILS WHERE HeaderDocNo=" +
                  '"${OrderNo.toString()}"' +
                  "and ItemCode = " +
                  '"${templist[i].itemCode.toString()}"' +
                  "and Price=" +
                  '"${templist[i].price.toString()}"');
          var priint = await txn.rawInsert(
              "INSERT INTO IN_MOB_SALES_INV_DETAILS ([HeaderDocNo] ,[DocDate] ,[CategoryCode] ,[CategoryName] ,"
              "[ItemCode] ,[ItemName] ,[ItemGroupCode] ,[Uom] ,[Qty] ,[Price] ,[Total] ,[ScreenID] ,[ScreenName] ,"
              "[Status] ,[PictureName] ,[PictureURL] ,[CreatedBy] ,[CreatedDatetime] ,[ModifiedBy] ,[ModifiedDatetime] ,"
              "[LineID],[Tax],[ItemComboNo]) VALUES ($mainorderno,'$OrderDate','$altercategorycode','${templist[i].tax.toString()}',"
              "'${templist[i].itemCode}','${templist[i].itemName}','${templist[i].itmsGrpCod}','${templist[i].uOM}',"
              "'${templist[i].qty}','${templist[i].price}','${templist[i].amount}',2,'Sales Invoice','$OrderStatus',"
              "'${templist[i].picturName}','${templist[i].imgUrl}',$sessionuserID ,'${templist[i].tax}',$sessionuserID ,"
              "'$OrderDate',${i + 1},'${templist[i].TaxCode}','${templist[i].ComboNo}')");

          print(priint);
        }


        for(int k = 0 ; k < TepmSaveMixBoxMaster.length;k++){
          var prinddeletee = await txn.rawDelete(
              "DELETE  FROM IN_MOB_SALES_INV_MIXMASTER WHERE SqlRefNo=" +
                  '"${mainorderno.toString()}"' +
                  "and RefItemCode = " +
                  '"${TepmSaveMixBoxMaster[k].itemCode.toString()}"' +
                  "and ItemCode=" +
                  '"${TepmSaveMixBoxMaster[k].itemCode.toString()}"');


          var priint1 = await txn.rawInsert("INSERT INTO IN_MOB_SALES_INV_MIXMASTER ([RefItemCode] ,[ItemCode] ,[ItemName] ,[Qty] ,[ActualQty] ,[Uom] ,[ComboNo] ,[SqlRefNo] ,[BillNumber],[Status] ) VALUES "
              "('${TepmSaveMixBoxMaster[k].refItemCode}',"
              "'${TepmSaveMixBoxMaster[k].itemCode}','${TepmSaveMixBoxMaster[k].itemName}','${TepmSaveMixBoxMaster[k].qty}','${TepmSaveMixBoxMaster[k].ActualQty}',"
              "'${TepmSaveMixBoxMaster[k].Uom}','${TepmSaveMixBoxMaster[k].ComboNo}','$mainorderno',"
              "'$MyBillNo','$OrderStatus')");
          print(priint1);
        }

        var printid1 = await txn.rawQuery(
            "SELECT HeaderDocNo FROM IN_MOB_SALES_INV_DETAILS WHERE HeaderDocNo=(SELECT max(HeaderDocNo) FROM IN_MOB_SALES_INV_DETAILS)");

        var jsonUser1 = json.encode(printid1[0]);

        print(json.decode(jsonUser1)["HeaderDocNo"]);
        orderno1 = json.decode(jsonUser1)["HeaderDocNo"];
        print('orderno1 $orderno1');
      });
    } catch (e) {
      //log.('SelvaCatch' + e.toString());
      log('data: $e');
      showDialogboxWarning(this.context, e.toString());
    }
    await database.close();

    setState(() {
      loading = false;
    });

    if (orderno1 > 0 && paymenttemplist.length == 0) {
      Fluttertoast.showToast(msg: "Hold Added.");
      Navigator.pushReplacement(
        this.context,
        MaterialPageRoute(
          builder: (context) => SalesInvoiceOffline(
              ScreenID: widget.ScreenID,
              ScreenName: widget.ScreenName,
              OrderNo: 0,
              isIgnore: false),
        ),
      );
      /* Navigator.pushReplacement(
          this.context, MaterialPageRoute(builder: (context) => PostData()));*/
    } else {
      setState(() {
        insertsalesdetailspayment(mainorderno);
      });
    }
  }

  Future<List> insertsalesdetailspayment(int headerdocno) async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {
        var now = new DateTime.now();
        for (int i = 0; i < paymenttemplist.length; i++) {
          print("paymenttemplist-headerdocno"+headerdocno.toString());
          print("paymenttemplist-" + paymenttemplist[i].PaymentName);
          var priint = await txn.rawInsert("INSERT INTO IN_MOB_SALES_INV_PAYMENT ([HeaderDocNo] ,[DocDate] ,[LineID] ,[Type] ,[BillAmount] ,[RecvAmount] ,[BalanceAmount] ,[Remarks] ,[TransactionID] ,[ScreenID] ,[ScreenName] ,[Status] ,[CreatedBy] ,[CreatedDate] ,[ModifiedBy] ,[ModifiedDate]) VALUES ('$headerdocno','$now','${i + 1}','${paymenttemplist[i].PaymentName}',${paymenttemplist[i].BillAmount},${paymenttemplist[i].ReceivedAmount},${paymenttemplist[i].BalAmount},'${paymenttemplist[i].PaymentRemarks}','0',1,'Sales InVoice','C',$sessionuserID,'$now',$sessionuserID,'$now')");
          print(priint);
        }

        var Update = await txn.rawUpdate("UPDATE   IN_MOB_DocNoSeries  SET   NextNo =${NextBillNo + 1} ");
        print(Update);
        Fluttertoast.showToast(msg: "Successfully Added");
      print("Sent NetWok");
        setState(() {
          Navigator.pushReplacement(
            this.context,
            MaterialPageRoute(
              builder: (context) => SalesInvoiceOffline(
                  ScreenID: widget.ScreenID,
                  ScreenName: widget.ScreenName,
                  OrderNo: 0,
                  isIgnore: false),
            ),
          );


        });
      });
    } catch (e) {
      print(e.toString());
      showDialogboxWarning(this.context, e.toString());
    }
    await database.close();
    setState(() {
      loading = false;
    });

  }

  Future getcountry(int formID, String UserID) {
    GETCOUNTRYAPI(formID, UserID).then((response) {
      print(response.body);
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
          countryModell.result.clear();
        } else {
          countryModell = countryModel.fromJson(jsonDecode(response.body));
          countrylist.clear();
          for (int k = 0; k < countryModell.result.length; k++) {
            countrylist.add(countryModell.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getstate(int formID, String UserID) {
    GETCOUNTRYAPI(formID, UserID).then((response) {
      print(response.body);
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
          stateModel.result.clear();
        } else {
          stateModel = StateModel.fromJson(jsonDecode(response.body));
          statelist.clear();
          for (int k = 0; k < stateModel.result.length; k++) {
            statelist.add(stateModel.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getoccation(int UserID, int BranchID) {
    GETOCCATIONAPI(UserID, BranchID).then((response) {
      print(response.body);
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
              fontSize: 16.0,);
          occModel.result.clear();
        } else {
          occModel = OccModel.fromJson(jsonDecode(response.body));
          occ.clear();
          for (int k = 0; k < occModel.result.length; k++) {
            occ.add(occModel.result[k].occName);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<String> fetchData() async {
    final String uri = AppConstants.LIVE_URL + "getOSRDOccation";
    List data = List();
    var response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      var res = await http.get(Uri.parse(uri), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
      print('Loaded Successfully' + resBody);
      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  void addItemToList(
      String itemCode,
      String itemName,
      int itmsGrpCod,
      String uOM,
      var price,
      var amount,
      var qty,
      String itmsGrpNam,
      String picturName,
      String imgUrl,
      var tax,
      var stock,
      var varince,
      var TaxCode,var CompoNo) {
    var countt = 0;
    print('Add List');

    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == itemCode &&
          templist[i].price == price &&
          templist[i].Varince == varince &&
          templist[i].uOM != 'MixBox') countt++;
    }
    print(stock);
    if (countt == 0) {
      templist.add(SalesTempItemResult(
          itemCode,
          itemName,
          itmsGrpCod,
          uOM,
          price,
          amount,
          qty,
          itmsGrpNam,
          picturName,
          imgUrl,
          tax,
          stock,
          varince,
          TaxCode,CompoNo));
      setState(() {});
    } else {
      for (int i = 0; i < templist.length; i++) {
        if (templist[i].itemCode == itemCode &&
            templist[i].price == price &&
            templist[i].Varince == varince &&
            templist[i].uOM != 'MixBox') {
          setState(() {
            var Qty;
            //var Tax;
            Qty = templist[i].qty += 1;
            //Tax = templist[i].tax += tax;
            templist[i].amount =
                Qty * double.parse(templist[i].price.toString()).round();
            //templist[i].tax = Tax;
          });
        }
      }
    }
    count();
  }

  void getTotalBlanceAmt() {
    double reciveAmt = 0;
    for (int i = 0; i < paymenttemplist.length; i++) {
      reciveAmt += double.parse(paymenttemplist[i].ReceivedAmount).round();
    }
    Edt_ReciveAmt.text = reciveAmt.round().toString();

    Edt_BlanceBillAmt.text = (double.parse(Edt_ReciveAmt.text) - double.parse(Edt_Total.text)).round().toString();
  }

  void MyLocCount() {
      double batchamount = 0;
      //Edt_Total.text = batchamount.round().toString();
      batchamount = (double.parse(Edt_NetTotal.text) - double.parse(Edt_Disc.text) + double.parse(Edt_CustCharge.text));
      Edt_Total.text = (batchamount+double.parse(Edt_Delcharge.text)).round().toString();
      Edt_Balance.text = (double.parse(Edt_Total.text) - double.parse(Edt_Advance.text)).toString();
      DelReceiveAmount.text = Edt_Advance.text;

  }
}

class MyTempTax1 {
  var taxcode;
  var sta;
  var cent;

  MyTempTax1(this.taxcode, this.sta, this.cent);
}

class MyTempTax {
  var taxcode;
  var amt;
  var sta;
  var cent;

  MyTempTax(this.taxcode, this.amt, this.sta, this.cent);

  Map toJson() => {
        'taxcode': taxcode,
        'amt': amt,
        'sta': sta,
        'cent': cent,
      };
}

/*
class MyData extends DataTableSource {
  bool get isRowCountApproximate => false;

  int get rowCount => SalesOrderState._data1.length;

  int get selectedRowCount => 0;

  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(SalesOrderState._data1[index].itemName)),
      // DataCell(Text(SalesOrderState._data1[index].qty.toString())),
      DataCell(
        Center(
          child: Card(
            child: Row(
              children: [
                new FloatingActionButton(
                  onPressed: () {
                    print('object');
                    SalesOrderState._data1[index].qty++;
                  },
                  child: new Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                ),
                new Text(SalesOrderState._data1[index].qty.toString(),
                    style: new TextStyle(fontSize: 20.0)),
                new FloatingActionButton(
                  onPressed: () {
                    SalesOrderState._data1[index].qty--;
                  },
                  child: new Icon(Icons.remove, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      DataCell(Text(SalesOrderState._data1[index].uOM.toString())),
      DataCell(Text('')),
      DataCell(Text(SalesOrderState._data1[index].price.toString())),
      DataCell(Text(SalesOrderState._data1[index].amount.toString())),
    ]);
  }
}
*/

class SalesTempItemResult {
  String itemCode;
  String itemName;
  var itmsGrpCod;
  String uOM;
  var price;
  var amount;
  var qty;
  String itmsGrpNam;
  String picturName;
  String imgUrl;
  var tax;
  var stock;
  var Varince;
  var TaxCode;
  var ComboNo;

  SalesTempItemResult(
      this.itemCode,
      this.itemName,
      this.itmsGrpCod,
      this.uOM,
      this.price,
      this.amount,
      this.qty,
      this.itmsGrpNam,
      this.picturName,
      this.imgUrl,
      this.tax,
      this.stock,
      this.Varince,
      this.TaxCode,this.ComboNo);

  Map<String, dynamic> toJson() => {
        'DocNo': itemCode,
        'LineID': itemName,
        'Type': itmsGrpCod,
        'BillAmount': uOM,
        'RecvAmount': price,
        'BalanceAmount': amount,
        'PaymentRemarks': qty,
        'TransactionID': itmsGrpNam,
        'Status': picturName,
        'ScreenID': imgUrl,
        'ScreenName': tax,
        'UserID': stock,
        'UserID': Varince,
        'UserID': TaxCode,
      };
}

class SalesPayment {
  String PaymentName;
  var ReceivedAmount;
  var BillAmount;
  var BalAmount;
  String PaymentRemarks;

  SalesPayment(this.PaymentName, this.ReceivedAmount, this.BillAmount,
      this.BalAmount, this.PaymentRemarks);
}

class SalesSendPayment {
  var docno;
  int LineID;
  String PaymentName;
  var ReceivedAmount;
  var BillAmount;
  var BalAmount;
  String PaymentRemarks;
  String TransactionID;
  String Status;
  var ScreenID;
  var ScreenName;
  var UserID;

  SalesSendPayment(
      this.docno,
      this.LineID,
      this.PaymentName,
      this.ReceivedAmount,
      this.BillAmount,
      this.BalAmount,
      this.PaymentRemarks,
      this.TransactionID,
      this.Status,
      this.ScreenID,
      this.ScreenName,
      this.UserID);

  Map<String, dynamic> toJson() => {
        'DocNo': docno,
        'LineID': LineID,
        'Type': PaymentName,
        'BillAmount': BillAmount,
        'RecvAmount': ReceivedAmount,
        'BalanceAmount': BalAmount,
        'PaymentRemarks': PaymentRemarks,
        'TransactionID': TransactionID,
        'Status': Status,
        'ScreenID': ScreenID,
        'ScreenName': ScreenName,
        'UserID': UserID,
      };
}

class SalesTempItemResultSend {
  var docno;
  String CatCode;
  String CatName;
  String itemCode;
  String itemName;
  var itmsGrpCod;
  String itmsGrpNam;
  String uOM;
  var qty;
  var price;
  var amount;
  var ScreenID;
  var ScreenName;
  var Status;
  String picturName;
  String imgUrl;
  var UserID;
  var LineID;
  var Tax;

  SalesTempItemResultSend(
      this.docno,
      this.CatCode,
      this.CatName,
      this.itemCode,
      this.itemName,
      this.itmsGrpCod,
      this.itmsGrpNam,
      this.uOM,
      this.qty,
      this.price,
      this.amount,
      this.ScreenID,
      this.ScreenName,
      this.Status,
      this.picturName,
      this.imgUrl,
      this.UserID,
      this.LineID,
      this.Tax);

  Map<String, dynamic> toJson() => {
        'DocNo': docno,
        'CatCode': CatCode,
        'CatName': CatName,
        'ItemCode': itemCode,
        'ItemName': itemName,
        'ItemGroupCode': itmsGrpCod,
        'ItemGroupName': itmsGrpNam,
        'UOM': uOM,
        'Qty': qty,
        'Price': price,
        'Total': amount,
        'ScreenID': ScreenID,
        'ScreenName': ScreenName,
        'Status': Status,
        'PictureName': picturName,
        'PictureURL': imgUrl,
        'UserID': UserID,
        'LineID': LineID,
        'Tax': Tax
      };
}

class DrawDottedhorizontalline extends CustomPainter {
  Paint _paint;

  DrawDottedhorizontalline() {
    _paint = Paint();
    _paint.color = Colors.black; //dots color
    _paint.strokeWidth = 2; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = -300; i < 300; i = i + 15) {
      // 15 is space between dots
      if (i % 3 == 0)
        canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class MyMixBoxMaster {
  String refItemCode;
  String itemCode;
  String itemName;
  var qty;
  var ActualQty;
  var Uom;
  var ComboNo;
  var SqlRefNo;

  MyMixBoxMaster(this.refItemCode, this.itemCode, this.itemName, this.qty,
      this.ActualQty, this.Uom, this.ComboNo, this.SqlRefNo);
}

class SaveMixBoxMaster {
  String refItemCode;
  String itemCode;
  String itemName;
  var qty;
  var ActualQty;
  var Uom;
  var ComboNo;
  var SqlRefNo;

  SaveMixBoxMaster(this.refItemCode, this.itemCode, this.itemName, this.qty,
      this.ActualQty, this.Uom, this.ComboNo, this.SqlRefNo);
  Map<String, dynamic> toJson() => {
    'refItemCode': refItemCode,
    'itemCode': itemCode,
    'itemName': itemName,
    'qty': qty,
    'ActualQty': ActualQty,
    'Uom': Uom,
    'ComboNo': ComboNo,
    'SqlRefNo': SqlRefNo,

  };
}
