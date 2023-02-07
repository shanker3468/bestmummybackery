// ignore_for_file: deprecated_member_use, non_constant_identifier_names, unnecessary_brace_in_string_interps, missing_return, must_be_immutable, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/KotSubTable.dart';
import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/GetIPAddressModel.dart';
import 'package:bestmummybackery/Model/KOTBookedModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/OfflineKotHeaderDetails.dart';
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/Model/Saleshiftmodel.dart';
import 'package:bestmummybackery/Model/StateModel.dart';
import 'package:bestmummybackery/Model/countryModel.dart';
import 'package:bestmummybackery/MyBluetoothprinter.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/_CashierDashbord.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class KOTScreenOffline extends StatefulWidget {
  //int ScreenID = 0;
  String CreationName = "";
  String TableNo = "";
  String SeatNo = "";
  int NetWorkCheckNumter=0;

  KOTScreenOffline({Key key, this.CreationName, this.TableNo, this.SeatNo, this. NetWorkCheckNumter})
      : super(key: key);

  @override
  KOTScreenOfflineState createState() => KOTScreenOfflineState();
}

class KOTScreenOfflineState extends State<KOTScreenOffline> {
  bool checkedValue = false;

  bool delstatelayout = false;
  bool delstateplace = false;
  bool delstateremarks = false;
  String colorchange = "";
  List<SalesTempItemResult> templist = new List();
  List<SalesPayment> paymenttemplist = new List();
  List<SalesSendPayment> sendpaymenttemplist = new List();
  List<SalesTempItemResultSend> sendtemplist = new List();

  TextEditingController SearchController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  TextEditingController Edt_Total = new TextEditingController();

  TextEditingController Edt_Advance = new TextEditingController();
  TextEditingController Edt_Balance = new TextEditingController();
  TextEditingController Edt_Delcharge = new TextEditingController();
  TextEditingController Edt_Disc = new TextEditingController();
  TextEditingController Edt_CustCharge = new TextEditingController();
  TextEditingController Edt_Tax = new TextEditingController();
  TextEditingController Edt_Mobile = new TextEditingController();
  TextEditingController Edt_UserLoyalty = new TextEditingController();
  TextEditingController Edt_Loyalty = new TextEditingController();
  var Edt_Adjustment = new TextEditingController();
  TextEditingController BalancePoints = new TextEditingController();
  TextEditingController Edt_Credit = new TextEditingController();
  TextEditingController Edt_CareOf = new TextEditingController();

  TextEditingController BalanceAmount = new TextEditingController();

  TextEditingController DelReceiveAmount = new TextEditingController();
  TextEditingController Edt_ReciveAmt = new TextEditingController(text: "0");
  TextEditingController Edt_BlanceBillAmt =new TextEditingController(text: "0");

  List<TextEditingController> qtycontroller = new List();
  TextEditingController Edt_PayRemarks = new TextEditingController();
  String selectedDate = "";
  KOTBookedModel bookedmodel;
  var TextClicked;
  var TotalQty=0;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  var sessionContact1 = "";
  var sessionContact2 = "";
  var MyPrintStaus="";

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
  var sessionIPAddress = '0';
  var sessionPrintStatus = '';
  var sessionIPPortNo = 0;

  var sessionKOTIPAddress = '0';
  var sessionKOTPortNo = 0;

  int updatedocno = 0;
  //int getlastno = 0;

  // Printer Varibles
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  String pathImage;
  NetworkPrinter printer;
  var BillCurrentDate;
  var BillCurrentTime;
  MyBluetoothPrinter MyPrinter;
  GetIPAddressModel RawGetIPAddressModel;
  int Bluetoothckecking = 0;
  String tdata;
  var MyBillNo;
  Timer timer;
  Saleshiftmodel RawSaleshiftmodel;
  var MyShitId=0;

  var SmsOnly=false;
  var BillOnly=false;


  @override
  void initState() {
    getStringValuesSF();

    BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    BillCurrentTime = DateFormat.jm().format(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  Future<void> NetPrinter(String iPAddress, int Port) async {
    // '192.168.0.87'-
    print(iPAddress);
    print(Port);
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(iPAddress, port: Port);
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
    double TotalCash = 0;
    double TotalCard = 0;
    double TotalUPI = 0;
    double TotalOther = 0;
    //print('akdjcbkagdvc');


    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text('Sweets & Cakes', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1,fontType: PosFontType.fontB), linesAfter: 1);

    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text('Ramnad, TN 623501', styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text('Condact Number: '+sessionContact2.toString(),styles: PosStyles(align: PosAlign.center,bold: true));

    printer.text(("12-06-2022" + "-" + "01:30 PM"), styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.text((altersalespersoname), styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.row([
      PosColumn(text: "Sale Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(
        text: 'Din-Ho',
        width: 3,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: "Bill No:" + "67/RMDBN1/01:31:28 PM/1/30",
        width: 9,
        styles: PosStyles(align: PosAlign.left),
      ),
    ]);
    printer.row([
      PosColumn(
        text: 'CusNo:' + Edt_Mobile.text,
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "TableNo:" + widget.TableNo.toString(),
        width: 3,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "SeetNo:" + widget.SeatNo.toString(),
        width: 3,
        styles: PosStyles(align: PosAlign.left),
      ),
    ]);

    printer.hr();
    printer.row([
      PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),
      ),
      PosColumn(
        text: 'Amt',
        width: 1,
        styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),
      ),
      PosColumn(
          text: 'Tax %',
          width: 1,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: 'Total',
          width: 3,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
    ]);
    for (int i = 0; i < templist.length; i++) {
      printer.row(
        [
          PosColumn(
              text: templist[i].itemName.toString() +
                  "-" +
                  templist[i].uOM.toString(),
              width: 5,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text: templist[i].qty.toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text:
                  double.parse(templist[i].price.toString()).round().toString(),
              width: 1,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text: templist[i].TaxCode.split("@")[1].toString() + "%",
              width: 1,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text: double.parse(templist[i].amount.toString())
                  .round()
                  .toString(),
              width: 3,
              styles: PosStyles(align: PosAlign.left)),
        ],
      );
    }

    printer.hr(ch: '=', linesAfter: 1);
    for (int i = 0; i < paymenttemplist.length; i++) {
      if (paymenttemplist[i].PaymentName == 'Cash') {
        TotalCash += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      if (paymenttemplist[i].PaymentName == 'Card') {
        TotalCard += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      if (paymenttemplist[i].PaymentName == 'UPI') {
        TotalUPI += double.parse(paymenttemplist[i].ReceivedAmount);
      }
      if (paymenttemplist[i].PaymentName == 'Others') {
        TotalOther += double.parse(paymenttemplist[i].ReceivedAmount);
      }
    }

    printer.row([
      PosColumn(
          text: 'Cash',
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(
          text: 'Rs.' + TotalCash.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    printer.row([
      PosColumn(
        text: 'Card',
        width: 6,
        styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2),
      ),
      PosColumn(
          text: 'Rs.' + TotalCard.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    printer.row([
      PosColumn(
          text: 'UPI',
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(
          text: 'Rs.' + TotalUPI.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    printer.row([
      PosColumn(
        text: 'Others',
        width: 6,
        styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2),
      ),
      PosColumn(
          text: 'Rs.' + TotalOther.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    printer.feed(2);

    printer.row([
      PosColumn(
        text: 'Total Amt',
        width: 6,
        styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,bold: true),
      ),
      PosColumn(
          text: 'Rs.' + Edt_Total.text.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2,bold: true)),
    ]);

    printer.row([
      PosColumn(
        text: 'Recevie Amt',
        width: 6,
        styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),
      ),
      PosColumn(
          text: 'Rs.' + Edt_ReciveAmt.text.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    printer.row([
      PosColumn(
        text: 'Balance Amt',
        width: 6,
        styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),
      ),
      PosColumn(
          text: 'Rs' + Edt_BlanceBillAmt.text.toString(),
          width: 6,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    List<MyTempTax> SMyTempTax = new List();
    SMyTempTax.clear();

    var set = Set<String>();
    List<SalesTempItemResult> selected1 =
        templist.where((element) => set.add(element.TaxCode)).toList();
    //log(jsonEncode(selected1));
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

    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('FASSI - ' + sessionContact1,styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.cut();
    ChildprintDemoReceipt(printer);

  }

  Future<void> ChildprintDemoReceipt(NetworkPrinter printer) async {

    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text('Sweets & Cakes', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1,fontType: PosFontType.fontB), linesAfter: 1);

    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center,bold: true), linesAfter: 1);
    printer.row([PosColumn(text: 'KOT Invoice - Duplicate', width: 12, styles: PosStyles(align: PosAlign.center,bold: true),),]);
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
      PosColumn(text: 'Total Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,bold: true),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text:  Edt_Total.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1,bold: true)),
    ]);

    printer.feed(2);
    printer.cut();
  }

  KOTNetPrinter(String iPAddress, int Port) async {
    // '192.168.0.87'-
    print(iPAddress);
    print(Port);
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(iPAddress, port: Port);
      if (res == PosPrintResult.success) {
        KOTprintDemoReceipt(printer);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: ${e}');
      // TODO
    }
  }

  Future<void> KOTprintDemoReceipt(NetworkPrinter printer) async {
    double TotalAmt = 0;

    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center,bold: true));

    printer.text((BillCurrentDate + "-" + BillCurrentTime), styles: PosStyles(align: PosAlign.center,bold: true), linesAfter: 1);
    printer.row([
      PosColumn(text: "Sale Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(
        text: 'KOT Screen',
        width: 4,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "Seat No:" + widget.SeatNo.toString(),
        width: 4,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: "Table No:" + widget.TableNo.toString(),
        width: 4,
        styles: PosStyles(align: PosAlign.left),
      ),
    ]);

    printer.hr();
    printer.row([
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Qty', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);
    for (int i = 0; i < templist.length; i++) {
      if (templist[i].SaveStatus == 0) {
        printer.row(
          [
            PosColumn(text: templist[i].itemName.toString(), width: 7),
            PosColumn(
                text: templist[i].qty.toString(),
                width: 2,
                styles: PosStyles(align: PosAlign.right)),
            PosColumn(
                text: templist[i].amount.toString(),
                width: 3,
                styles: PosStyles(align: PosAlign.right)),
          ],
        );
        TotalAmt += double.parse(templist[i].amount.toString());
        //TotalTaxAmt += double.parse(templist[i].tax.toString());
      }
    }

    printer.hr();

    printer.row([
      PosColumn(
          text: 'Total Amt',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,bold: true
          )),
      PosColumn(
          text: 'Rs.' + TotalAmt.toString(),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,bold:true
          )),
    ]);

    printer.feed(2);
    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));


    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.cut();


  }

  KOTNetFullPrinter(String iPAddress, int Port) async {
    // '192.168.0.87'-
    print(iPAddress);
    print(Port);
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(iPAddress, port: Port);
      if (res == PosPrintResult.success) {
        KOTFullprintDemoReceipt(printer);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: ${e}');
      // TODO
    }
  }

  Future<void> KOTFullprintDemoReceipt(NetworkPrinter printer) async {
    double TotalAmt = 0;
    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center,bold: true), linesAfter: 1);
    printer.row([
      PosColumn(text: "Bill No", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: updatedocno.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: "Sale Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: 'KOT Screen',width: 4,styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(text: "Seat No:" + widget.SeatNo.toString(),width: 4,styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(text: "Table No:" + widget.TableNo.toString(),width: 4,styles: PosStyles(align: PosAlign.left),
      ),
    ]);
    printer.hr();
    printer.row([
      PosColumn(text: 'Item', width: 7),
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(text: 'Total', width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);
    for (int i = 0; i < templist.length; i++) {
        printer.row(
          [
            PosColumn(text: templist[i].itemName.toString(), width: 7),
            PosColumn(text: templist[i].qty.toString(),width: 2,styles: PosStyles(align: PosAlign.right)),
            PosColumn(text: templist[i].amount.toString(),width: 3,styles: PosStyles(align: PosAlign.right)),
          ],
        );
        TotalAmt += double.parse(templist[i].amount.toString());
        //TotalTaxAmt += double.parse(templist[i].tax.toString());
    }
    printer.hr();
    printer.row([
      PosColumn(text: 'Total Amt', width: 6,styles: PosStyles(height: PosTextSize.size1,width: PosTextSize.size1,bold: true)),
      PosColumn(text: 'Rs.' + TotalAmt.toString(),
          width: 6,styles: PosStyles(align: PosAlign.right,height: PosTextSize.size1,width: PosTextSize.size1,bold: true)),
    ]);
    printer.feed(2);
    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp,styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.cut();
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

  double getvalue = 0;
  bool loyalcheckboxValue = false;
  bool careofcheckboxValue = false;
  OfflineKotHeaderDetails kotheadermodel;
  OfflineKotHeaderDetails kotdetailmodel;
  final pagecontroller = PageController(initialPage: 0,);

  int mainorderno = 0;
  int orderno1 = 0;
  int paymentorderno = 0;

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    var assetsImage = new AssetImage('assets/imgs/splashanim.gif');
    var image = new Image(image: assetsImage, height: MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: SafeArea(
          child: Scaffold(
              appBar: tablet?
              new AppBar(
                    title: new Text("KOT Order - Hall Name : ${widget.CreationName} - Table No : ${widget.TableNo} - Seat No :  ${widget.SeatNo}",),
                    actions: [
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(MyBillNo.toString(),
                          ),
                      ),
                    ],
                    )
                  :PreferredSize( preferredSize: Size.fromHeight(height/15), child: AppBar(
                          title: new Text("KOT Hall Name : ${widget.CreationName} - Table No : ${widget.TableNo} - Seat No :  ${widget.SeatNo}",),
                            actions: [
                             
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  MyBillNo.toString(),
                                ),
                              ),
                            ],
              ),
             ),
            body: loading
                ? Container(
                      decoration: new BoxDecoration(color: Colors.white),
                      child: new Center(
                        child: image,
                      ),
                    )
                :Center(
                  child: tablet
                       ? PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pagecontroller,
                          onPageChanged: (page) => {print(page.toString())},
                          pageSnapping: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                          Container(
                            color: Colors.white,
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        categoryitem != null
                                            ? Container(
                                                padding: EdgeInsets.all(5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      for (int cat = 0; cat < categoryitem.result.length; cat++)
                                                        Container(
                                                          margin: EdgeInsets.all(3),
                                                          child: InkWell(
                                                            onTap: () {
                                                              TextClicked = altercategoryName = categoryitem.result[cat].name;

                                                              colorchange = categoryitem.result[cat].code.toString();
                                                              onclick = 1;
                                                              altercategoryName = categoryitem.result[cat].name;
                                                              altercategorycode = categoryitem.result[cat].code.toString().isEmpty
                                                                      ? 0: categoryitem.result[cat].code.toString();

                                                              //getdetailitems(categoryitem.result[cat].code.toString().isEmpty ? 0: categoryitem.result[cat].code.toString(),onclick);
                                                              getdetailitemsonline(categoryitem.result[cat].code.toString().isEmpty ? 0: categoryitem.result[cat].code.toString(),onclick);
                                                              setState(() {});
                                                            },
                                                            child: Center(
                                                              child: Container(
                                                                  width: 100,
                                                                alignment:Alignment.center,
                                                                padding:EdgeInsets.all(2),
                                                                decoration:BoxDecoration(
                                                                  color: Colors.blue,
                                                                  borderRadius: BorderRadius.all(Radius.circular(10),),),
                                                                child: Text(
                                                                  categoryitem.result[cat].name,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextClicked == categoryitem.result[cat].name
                                                                      ? TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold)
                                                                      : TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
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
                                                    childAspectRatio: 0.7,
                                                    crossAxisCount: 5,
                                                    children: [
                                                      for (int cat = 0; cat < itemodel.result.length; cat++)
                                                          if (itemodel.result[cat].itemName.toLowerCase().contains(search.toLowerCase()))
                                                        InkWell(
                                                          onTap: () {
                                                            print(itemodel.result[cat].Varince);
                                                            print(itemodel.result[cat].uOM);
                                                            if (itemodel.result[cat].uOM == "Grams" || itemodel.result[cat].uOM == "Kgs") {
                                                              showDialog<void>(
                                                                context: context,
                                                                barrierDismissible: false,
                                                                builder: (BuildContext context) {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(50),
                                                                    ),
                                                                    elevation: 0,
                                                                    backgroundColor:Colors.transparent,
                                                                    child: MyClac(
                                                                        context,
                                                                        updatedocno,
                                                                        itemodel.result[cat].itemCode,
                                                                        itemodel.result[cat].itemName,
                                                                        itemodel.result[cat].itmsGrpCod,
                                                                        itemodel.result[cat].uOM,
                                                                        itemodel.result[cat].price,
                                                                        itemodel.result[cat].amount,
                                                                        itemodel.result[cat].itmsGrpNam,
                                                                        itemodel.result[cat].picturName,
                                                                        itemodel.result[cat].imgUrl,
                                                                        itemodel.result[cat].TaxCode.split("@")[1],
                                                                        itemodel.result[cat].onHand,
                                                                        itemodel.result[cat].Varince,
                                                                        0,
                                                                        tablet,
                                                                        itemodel.result[cat].TaxCode),
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              addItemToList(
                                                                  updatedocno,
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
                                                                  (double.parse(itemodel.result[cat].TaxCode.split("@")[1].toString()) * itemodel.result[cat].amount) /100,
                                                                  itemodel.result[cat].onHand,
                                                                  itemodel.result[cat].Varince,
                                                                  0,
                                                                  itemodel.result[cat].TaxCode);
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Card(
                                                              elevation: 5,
                                                              clipBehavior: Clip.antiAlias,
                                                              child: Stack(
                                                                alignment:Alignment.center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                                    crossAxisAlignment:CrossAxisAlignment.center,
                                                                    children: [
                                                                      Padding(
                                                                        padding:const EdgeInsets.all(2.0),
                                                                        //child: itemodel.result[cat].imgUrl !="assets/Images/"
                                                                            //? Image.asset(itemodel.result[cat].imgUrl,height:height / 10,)
                                                                              child: itemodel.result[cat].imgUrl != AppConstants.IMAGE_URL + "/"
                                                                                  ? Image.network(
                                                                                itemodel.result[cat].imgUrl,
                                                                                height: height / 10,
                                                                              )
                                                                            : CircleAvatar(
                                                                                radius:30.0,
                                                                                backgroundColor: Colors.transparent,
                                                                                child:
                                                                                    Center(
                                                                                      child:Text(
                                                                                    // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                                    itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: height/60),
                                                                                  ),
                                                                                )),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                            child:Text(itemodel.result[cat].itemName,textAlign:TextAlign.center,
                                                                              style: TextStyle(fontSize: height/60),),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "Rs.${double.parse(itemodel.result[cat].price.toString()).round()}",
                                                                                style: TextStyle(fontSize: height/70,color: Colors.green,fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Text(itemodel.result[cat].Varince,
                                                                              textAlign:TextAlign.center,
                                                                              style: TextStyle(fontSize:13,color:Colors.red),
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
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: SingleChildScrollView(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 80,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin:const EdgeInsets.symmetric(horizontal: 15),
                                                      width: double.infinity / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black12,
                                                        borderRadius:
                                                            BorderRadius.circular(15),
                                                      ),
                                                      child: TextField(
                                                        controller: editingController,
                                                        autofocus: false,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            search = val;
                                                          });
                                                        },
                                                        decoration: InputDecoration(
                                                          suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                search = "";
                                                                editingController
                                                                    .clear();
                                                              });
                                                            },
                                                            icon: Icon(Icons.clear),
                                                          ),
                                                          border: InputBorder.none,
                                                          hintText: 'Search Item...',
                                                          prefixIcon: Padding(
                                                              padding:const EdgeInsets.all(10),
                                                              child:Icon(Icons.search)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: MediaQuery.of(context).size.height / 10,
                                                      child: DropdownSearch<
                                                          String>(
                                                        mode: Mode.MENU,
                                                        showSearchBox: true,
                                                        items:salespersonlist,
                                                        label: "Sales Person",
                                                        onChanged: (val) {
                                                          print(val);
                                                          for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                            if (salespersonmodel.result[kk].name == val) {
                                                              altersalespersoname =salespersonmodel.result[kk].name;
                                                              altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                                              var EnterMobileNo;
                                                              if (Edt_Mobile.text =='') {
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
                                                                              Edt_Mobile.text =EnterMobileNo;
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
                                              padding: EdgeInsets.only(top: 2),
                                              color: Colors.white,
                                              height: height / 1.7,
                                              width: width / 2,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: templist.length == 0
                                                      ? Center(child: Text('No Data Add!'),)
                                                      : DataTable(
                                                          sortColumnIndex: 0,
                                                          sortAscending: true,
                                                          columnSpacing: 25,
                                                          dataRowHeight: 55,
                                                          headingRowHeight: 30,
                                                          headingRowColor:MaterialStateProperty.all(Colors.blue),
                                                          showCheckboxColumn: false,
                                                          columns: const <DataColumn>[
                                                            DataColumn(
                                                              label: Text('Item Name',style: TextStyle(color:Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('Qty',style: TextStyle(color:Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('Tax%',style: TextStyle(color:Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('Tax',style: TextStyle(color:Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('Amount',style: TextStyle(color:Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('Remove',style: TextStyle(color:Colors.white),),
                                                            ),
                                                            DataColumn(
                                                              label: Text('LineNo',style: TextStyle(color:Colors.white),),
                                                            ),
                                                          ],
                                                          rows: templist
                                                              .map(
                                                                (list) => DataRow(
                                                                  color: list.SaveStatus ==1
                                                                      ? MaterialStateProperty.all(Colors.greenAccent)
                                                                      : MaterialStateProperty.all(Colors.white),
                                                                  cells: [
                                                                    DataCell(
                                                                      Text(
                                                                        "${list.itemName}\n" +
                                                                            "${list.uOM}" +
                                                                            "-" +
                                                                            "Rate : ${double.parse(list.price.toString()).round()}\n" +
                                                                            list.uOM +
                                                                            "\n",
                                                                        textAlign:TextAlign.left,
                                                                        style: TextStyle(fontSize:12),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Container(
                                                                           width: 100,
                                                                            alignment:Alignment.center,
                                                                            child: Text(list.qty.toString(),),
                                                                            ),
                                                                            showEditIcon:true,
                                                                            onTap: () {
                                                                            if (list.SaveStatus ==0) {
                                                                            if (list.uOM.trim() =="Grams" ||list.uOM.trim() =="Kgs") {
                                                                            print(list.uOM);
                                                                            showDialog<void>(
                                                                              context:context,
                                                                              barrierDismissible:false,
                                                                              builder:(BuildContext context) {
                                                                                return Dialog(
                                                                                  shape:RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(50),
                                                                                  ),
                                                                                  elevation:0,
                                                                                  backgroundColor:Colors.transparent,
                                                                                  child: SubMyClac(
                                                                                      context,
                                                                                      templist.indexOf(list),
                                                                                      list.price,
                                                                                      0,
                                                                                      tablet),
                                                                                );
                                                                              },
                                                                            );
                                                                          } else {
                                                                            print(list.uOM);
                                                                            showDialog<void>(
                                                                              context:context,
                                                                              barrierDismissible:false,
                                                                              builder:(BuildContext context) {
                                                                                return Dialog(
                                                                                  shape:RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(50),
                                                                                  ),
                                                                                  elevation:0,
                                                                                  backgroundColor:Colors.transparent,
                                                                                  child: QtyMyClac(
                                                                                      context,
                                                                                      templist.indexOf(list),
                                                                                      list.price,
                                                                                      0,
                                                                                      tablet),
                                                                                );
                                                                              },
                                                                            );
                                                                          }
                                                                        } else {}
                                                                      },
                                                                    ),
                                                                    DataCell(
                                                                      Container(
                                                                        width: 60,
                                                                        child: Center(
                                                                            child: Wrap(
                                                                                direction: Axis.vertical,
                                                                                alignment: WrapAlignment.center,
                                                                                children: [
                                                                              Text(double.parse((list.tax.toString())).toString(),
                                                                                  textAlign:TextAlign.center)
                                                                            ])),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Container(
                                                                        width: 60,
                                                                        child: Center(
                                                                            child:
                                                                                Wrap(
                                                                                    direction: Axis.vertical,
                                                                                    //default
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                                  Text(list.TaxCode.toString(),
                                                                                  textAlign:TextAlign.center)
                                                                            ])),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Container(
                                                                        width: 60,
                                                                        child: Center(
                                                                          child: Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                  double.parse(list.amount.toString()).round().toString(),
                                                                                  textAlign:TextAlign.center)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Center(
                                                                        child: Center(
                                                                            child:IconButton(
                                                                              icon: Icon(Icons.cancel),
                                                                              color: Colors.red,
                                                                              onPressed:() {
                                                                            print("Pressed");

                                                                            if (list.SaveStatus ==0) {
                                                                              setState(() {
                                                                                print(list.DocNo);
                                                                                  templist.remove(list);
                                                                                  Fluttertoast.showToast(msg: "Deleted Row");
                                                                                  count();
                                                                                },
                                                                              );
                                                                            } else {
                                                                              print(list.DocNo);
                                                                            }
                                                                          },
                                                                        )),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Container(
                                                                        width: 60,
                                                                        child: Center(
                                                                          child: Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                  double.parse(list.amount.toString()).round().toString(),
                                                                                  textAlign:TextAlign.center)
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
                                            DraftMethod(context, height, width),
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
                                          child: TextField(
                                            readOnly: true,
                                            onChanged: (val) {
                                              setState(() {
                                                try {
                                                  double remaining = DelReceiveAmount.text.isEmpty
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
                                            decoration: InputDecoration(
                                                suffixIconConstraints: BoxConstraints(minHeight: 30, minWidth: 30),
                                                suffixIcon: Icon(
                                                  Icons.cancel,
                                                  size: 30,
                                                  color: Colors.grey,
                                                ),
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
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_Total,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
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
                                          child: TextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            readOnly: true,
                                            controller: Edt_Balance,
                                            decoration: InputDecoration(
                                                labelText: "Balance Amount",
                                                border: OutlineInputBorder(),
                                                fillColor: Colors.blue),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: height / 2.5,
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Denomination Details')
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                    margin: EdgeInsets.only(top: 40),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                          onPressed: () {
                                                            setState(() {
                                                              print("RupeesButton");
                                                              if(DelReceiveAmount.text==''){
                                                                Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                              }else if(DelReceiveAmount.text=="0.00"){
                                                                Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                              }else{
                                                              alterpayment = 'Cash';
                                                              paymenttemplist.add(
                                                                  SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text));
                                                              DelReceiveAmount.text = "";
                                                              Edt_Balance.text = "";
                                                              Edt_PayRemarks.text = "";
                                                              alterpayment = "Select";
                                                              getvalue = 0;
                                                              getTotalBlanceAmt();
                                                              }
                                                            });
                                                          },
                                                          child: Text(
                                                            'Cash',
                                                            style: TextStyle(
                                                                color: Colors.white),
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
                                                              alterpayment = 'Card';
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
                                                              getTotalBlanceAmt();
                                                              }
                                                            });
                                                          },
                                                          child: Text('Card', style: TextStyle(color: Colors.white),),
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

                                                              alterpayment = 'UPI';
                                                              paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text));
                                                              DelReceiveAmount.text = "";
                                                              Edt_Balance.text = "";
                                                              Edt_PayRemarks.text = "";
                                                              alterpayment = "Select";
                                                              getvalue = 0;
                                                              getTotalBlanceAmt();
                                                              }
                                                            });
                                                          },
                                                          child: Text('UPI', style: TextStyle(color: Colors.white),
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
                                                              alterpayment = 'Others';
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
                                                              }
                                                            });
                                                          },
                                                          child: Text(
                                                            'Others',
                                                            style: TextStyle(
                                                                color: Colors.white),
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
                                              height: height / 2.5,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: paymenttemplist.length == 0
                                                      ? Center(
                                                          child: Text('No Data Add!'),
                                                        )
                                                      : DataTable(
                                                          sortColumnIndex: 0,
                                                          sortAscending: true,
                                                          columnSpacing: 30,
                                                          dataRowHeight: 60,
                                                          headingRowColor:
                                                              MaterialStateProperty
                                                                  .all(Colors.blue),
                                                          showCheckboxColumn: false,
                                                          columns: <DataColumn>[
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
                                                          rows: paymenttemplist
                                                              .map(
                                                                (list) => DataRow(
                                                                  cells: [
                                                                    DataCell(
                                                                      Center(
                                                                        child: Center(
                                                                            child:
                                                                                IconButton(
                                                                                    icon: Icon(Icons.cancel),
                                                                                    color: Colors.red,
                                                                                    onPressed:() {
                                                                                    print("Pressed");
                                                                                    setState(() {
                                                                                      paymenttemplist.remove(list);
                                                                                      Fluttertoast.showToast(msg:"Deleted Row");
                                                                                      getTotalBlanceAmt();
                                                                                      //  count();
                                                                                    });
                                                                          },
                                                                        )),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Padding(
                                                                        padding:EdgeInsets.only(top: 5),
                                                                        child: Text("${list.PaymentName}",
                                                                            textAlign:TextAlign.left),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Center(
                                                                        child: Center(
                                                                          child: Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(list.BillAmount.toString(),
                                                                                  textAlign:TextAlign.center)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Center(
                                                                        child: Center(
                                                                          child: Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                  list.ReceivedAmount.toString(),
                                                                                  textAlign:TextAlign.center)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Center(
                                                                        child: Center(
                                                                            child:
                                                                                Wrap(
                                                                                    direction: Axis.vertical,
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                                    Text(
                                                                                        list.BalAmount.toString(),
                                                                                        textAlign:TextAlign.center)
                                                                            ])),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      Center(
                                                                        child: Center(
                                                                          child: Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(list.PaymentRemarks,
                                                                                  textAlign:TextAlign.center)
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
                                      SizedBox(
                                        width: 10,
                                      ),
                                      LineSeparator(color: Colors.grey),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Loyalty Points',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
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
                                                              value:loyalcheckboxValue,
                                                              activeColor:Colors.blue,
                                                              onChanged:(bool newValue) {
                                                                setState(() {
                                                                  loyalcheckboxValue = newValue;
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
                                                            controller: Edt_Mobile,
                                                            decoration:InputDecoration(
                                                              labelText: "Mobile No",
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
                                                          child: TextField(
                                                            enabled: false,
                                                            controller: Edt_Loyalty,
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
                                                          child: TextField(
                                                            enabled: false,
                                                            controller:Edt_Adjustment,
                                                            decoration:InputDecoration(
                                                              labelText: "Adjustment",
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
                                                          child: TextField(
                                                            enabled: false,
                                                            controller: BalancePoints,
                                                            decoration:InputDecoration(
                                                              fillColor: Colors.grey,
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
                                                              value:careofcheckboxValue,
                                                              activeColor:Colors.blue,
                                                              onChanged:(bool newValue) {
                                                                setState(() {
                                                                  careofcheckboxValue = newValue;
                                                                });
                                                                Text('');
                                                                print('ONCHANGE$careofcheckboxValue');
                                                              }),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: TextField(
                                                            enabled: false,
                                                            controller: Edt_Credit,
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
                                                                altercareofname =salespersonmodel.result[kk].name;
                                                                altercareofcode =salespersonmodel.result[kk].empID.toString();
                                                              }
                                                            }
                                                          },
                                                          selectedItem:altercareofname,
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
                                                            controller: Edt_ReciveAmt,
                                                            decoration:InputDecoration(
                                                              labelText: "Recive Amt",
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
                                                        child: TextField(
                                                          enabled: false,
                                                          controller:Edt_BlanceBillAmt,
                                                          decoration: InputDecoration(
                                                            labelText: "Blance Amt",
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
                                          Visibility(
                                            visible: true,
                                            child: FloatingActionButton.extended(
                                              backgroundColor: Colors.blue.shade700,
                                              icon: Icon(Icons.print),
                                              label: Text('Print & Save'),
                                              onPressed: () {
                                                settlementisclicked = 1;
                                                if (settlementisclicked == 1 && paymenttemplist.length == 0) {
                                                  Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                                } else if (double.parse(Edt_BlanceBillAmt.text) < 0) {
                                                  Fluttertoast.showToast(msg: "Get Full Amt");
                                                } else {
                                                  log(sessionIPAddress);

                                                  var BillType='';
                                                  SmsOnly = false;
                                                  BillOnly = false;
                                                  showDialog(context:context, builder: (BuildContext contex1){
                                                    return StatefulBuilder(
                                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                                        return AlertDialog(
                                                          content: SizedBox(
                                                            width: width / 4,
                                                            height: height / 5,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                        width: width / 15,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              if (SmsOnly) {
                                                                                SmsOnly = false;
                                                                                BillType='';
                                                                              } else {
                                                                                SmsOnly = true;
                                                                                BillOnly = false;
                                                                                BillType="SmsOnly";
                                                                              }
                                                                            });
                                                                          },
                                                                          icon: Icon(SmsOnly ? Icons.check_box : Icons.check_box_outline_blank),)
                                                                    ),
                                                                    Container(width: width / 10, child: Text("SMS Only"))
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                        width: width / 15,
                                                                        child:  IconButton(
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                if (BillOnly) {
                                                                                  BillOnly = false;
                                                                                  BillType="";
                                                                                } else {
                                                                                  BillOnly = true;
                                                                                  SmsOnly = false;
                                                                                  BillType="BillOnly";
                                                                                }
                                                                              });
                                                                            },
                                                                            icon:Icon(BillOnly ? Icons.check_box :Icons.check_box_outline_blank))
                                                                    ),
                                                                    Container(width: width / 10, child: Text("Bill Only"))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          title: Text("Choose Bill Type"),
                                                          actions: <Widget>[
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      child: TextButton(
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            if(BillOnly||SmsOnly){
                                                                              insertSalesHeaderServer(
                                                                                  updatedocno, formatter.format(DateTime.now()),
                                                                                  Edt_Mobile.text, formatter.format(DateTime.now()),
                                                                                  alterocccode, alteroccname, formatter.format(DateTime.now()),
                                                                                  MyShitId.toString(), altersalespersoncode, altersalespersoname,
                                                                                  checkedValue == true? "Y": "N", Edt_CustCharge.text.isEmpty? 0: double.parse(Edt_CustCharge.text),
                                                                                  Edt_Advance.text.isEmpty? 0: double.parse(Edt_Advance.text),
                                                                                  '', '', '', '', '', '',
                                                                                  Edt_Delcharge.text.isEmpty ? 0 : double.parse(Edt_Delcharge.text),
                                                                                  batchcount, Edt_Total.text.isEmpty? 0: double.parse(Edt_Total.text),
                                                                                  Edt_Tax.text.isEmpty? 0: double.parse(Edt_Tax.text),
                                                                                  Edt_Disc.text.isEmpty? 0: double.parse(Edt_Disc.text),
                                                                                  Edt_Balance.text.isEmpty? 0: double.parse(Edt_Balance.text),
                                                                                  Edt_Total.text.isEmpty? 0: double.parse(Edt_Total.text),
                                                                                  'C', 0, '', 0, '', '', '', widget.CreationName.toString(),
                                                                                  widget.TableNo, widget.SeatNo, int.parse(sessionuserID), sessionbranchcode);

                                                                              Navigator.pop(contex1, 'Ok',);
                                                                            }else{
                                                                              Fluttertoast.showToast(msg: "Select the any one...");
                                                                            }
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
                                                        );
                                                      },
                                                    );
                                                  });

                                                }
                                              },
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
                      ],
                  )
                       : PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: pagecontroller,
                            onPageChanged: (page) => {print(page.toString())},
                            pageSnapping: true,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                width: width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            categoryitem != null ?
                                                 Container(
                                        
                                                    //padding: EdgeInsets.all(2),
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                        for (int cat = 0; cat < categoryitem.result.length; cat++)
                                                        Container(
                                                          margin: EdgeInsets.all(1),
                                                          child: InkWell(
                                                            onTap: () {
                                                            TextClicked = altercategoryName = categoryitem.result[cat].name;
                                                            colorchange = categoryitem.result[cat].code.toString();
                                                            onclick = 1;
                                                            altercategoryName = categoryitem.result[cat].name;
                                                            altercategorycode = categoryitem.result[cat].code.toString().isEmpty
                                                                ? 0: categoryitem.result[cat].code.toString();

                                                            //getdetailitems(categoryitem.result[cat].code.toString().isEmpty? 0: categoryitem.result[cat].code.toString(),onclick);
                                                            getdetailitemsonline(categoryitem.result[cat].code.toString().isEmpty? 0: categoryitem.result[cat].code.toString(),onclick);
                                                            setState(() {});
                                                            },
                                                            child: Center(
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height / 25,
                                                                width: width / 4,
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.all(2),
                                                                decoration:BoxDecoration(
                                                                  color: Colors.blue,
                                                                  borderRadius: BorderRadius.all(Radius.circular(10),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  categoryitem.result[cat].name,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextClicked == categoryitem.result[cat].name
                                                                      ? TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold)
                                                                      : TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
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
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Container(
                                                        height: height / 15,
                                                          margin:const EdgeInsets.symmetric(horizontal: 15),
                                                          width: double.infinity / 2,
                                                          decoration: BoxDecoration(
                                                            color: Colors.black12,
                                                            borderRadius:
                                                            BorderRadius.circular(15),
                                                          ),
                                                          child: TextField(
                                                            controller: editingController,
                                                            autofocus: false,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                search = val;
                                                              });
                                                            },
                                                            decoration: InputDecoration(
                                                              suffixIcon: IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    search = "";
                                                                    editingController.clear();
                                                                  });
                                                                },
                                                                icon: Icon(Icons.clear,size: height/25,),
                                                              ),
                                                              border: InputBorder.none,
                                                              hintText: 'Search Item...',
                                                              prefixIcon: Padding(
                                                                  padding:const EdgeInsets.all(10),
                                                                  child:Icon(Icons.search,size: height/25,)),
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        height: height / 20,
                                                        margin:const EdgeInsets.symmetric(horizontal: 15),
                                                        width: double.infinity / 2,
                                                        child: Badge(
                                                          position: BadgePosition.topEnd(top: 0, end: 3),
                                                          animationDuration: Duration(milliseconds: 300),
                                                          animationType: BadgeAnimationType.slide,
                                                          badgeContent: Text(templist.length == 0 ? '0' : templist.length.toString(),
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                            child:IconButton(
                                                                icon: Icon(Icons.add_shopping_cart),
                                                              onPressed: () {
                                                                pagecontroller.jumpToPage(3);
                                                              },
                                                          )

                                                        ),
                                                        
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    height: height,
                                                    width: width,
                                                    child: itemodel != null
                                                    ? GridView.count(
                                                          childAspectRatio: 0.9,
                                                          crossAxisCount: 3,
                                                        children: [
                                                          for (int cat = 0; cat < itemodel.result.length; cat++)
                                                            if (itemodel.result[cat].itemName.toLowerCase().contains(search.toLowerCase()))
                                                            InkWell(
                                                              onTap: () {
                                                                print(itemodel.result[cat].Varince);
                                                                print(itemodel.result[cat].uOM);
                                                                if (itemodel.result[cat].uOM == "Grams" || itemodel.result[cat].uOM == "Kgs") {
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
                                                                        child: MyClac(
                                                                            context,
                                                                            updatedocno,
                                                                            itemodel.result[cat].itemCode,
                                                                            itemodel.result[cat].itemName,
                                                                            itemodel.result[cat].itmsGrpCod,
                                                                            itemodel.result[cat].uOM,
                                                                            itemodel.result[cat].price,
                                                                            itemodel.result[cat].amount,
                                                                            itemodel.result[cat].itmsGrpNam,
                                                                            itemodel.result[cat].picturName,
                                                                            itemodel.result[cat].imgUrl,
                                                                            itemodel.result[cat].TaxCode.split("@")[1],
                                                                            itemodel.result[cat].onHand,
                                                                            itemodel.result[cat].Varince,
                                                                            0,
                                                                            tablet,
                                                                            itemodel.result[cat].TaxCode),
                                                                      );
                                                                    },
                                                                  );
                                                                } else {
                                                                  addItemToList(
                                                                      updatedocno,
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
                                                                      (double.parse(itemodel.result[cat].TaxCode.split("@")[1]
                                                                          .toString()) * itemodel.result[cat].amount) /100,
                                                                      itemodel.result[cat].onHand,
                                                                      itemodel.result[cat].Varince,
                                                                      0,
                                                                      itemodel.result[cat].TaxCode);
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(1.0),
                                                                child: Card(
                                                                  elevation: 5,
                                                                  clipBehavior: Clip.antiAlias,
                                                                  child: Stack(
                                                                    alignment:
                                                                    Alignment.center,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                            const EdgeInsets.all(2.0),
                                                                            child: itemodel.result[cat].imgUrl !="assets/Images/"?
                                                                            Image.network(itemodel.result[cat].imgUrl,height:height / 12,)
                                                                                : CircleAvatar(
                                                                                  radius:20.0,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  child:
                                                                                  Center(
                                                                                    child:Text(
                                                                                      // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                                      itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: height / 30.0),
                                                                                    ),
                                                                                  )),
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:CrossAxisAlignment.center,
                                                                            children: [
                                                                              Center(
                                                                                child:Text(
                                                                                  itemodel.result[cat].itemName,
                                                                                  textAlign:TextAlign.center,
                                                                                  style: TextStyle(fontSize: height / 45),
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    "Rs.${double.parse(itemodel.result[cat].price.toString()).round()}",
                                                                                    style: TextStyle(fontSize: height / 45,color: Colors.green,fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Center(
                                                                                child:
                                                                                Text(itemodel.result[cat].Varince,textAlign:TextAlign.center,style: TextStyle(fontSize: height / 45,color:Colors.red),),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )],)
                                                    : Container(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: SingleChildScrollView(
                                              physics: NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: height / 10,
                                                            margin:const EdgeInsets.symmetric(horizontal: 15),
                                                            width: double.infinity / 2,
                                                            decoration: BoxDecoration(
                                                              color: Colors.black12,
                                                              borderRadius:
                                                              BorderRadius.circular(15),
                                                            ),
                                                            child: TextField(
                                                              controller: editingController,
                                                              autofocus: false,
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  search = val;
                                                                });
                                                              },
                                                              decoration: InputDecoration(
                                                                suffixIcon: IconButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      search = "";
                                                                      editingController.clear();
                                                                    });
                                                                  },
                                                                  icon: Icon(Icons.clear,size: height/25,),
                                                                ),
                                                                border: InputBorder.none,
                                                                hintText: 'Search Item...',
                                                                prefixIcon: Padding(
                                                                    padding:const EdgeInsets.all(10),
                                                                    child:Icon(Icons.search,size: height/25,)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height: MediaQuery.of(context).size.height / 10,
                                                            child: DropdownSearch<
                                                                String>(
                                                              mode: Mode.MENU,
                                                              showSearchBox: true,
                                                              items:salespersonlist,
                                                              label: "Sales Person",
                                                              onChanged: (val) {
                                                                print(val);
                                                                for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                                  if (salespersonmodel.result[kk].name == val) {
                                                                    altersalespersoname =salespersonmodel.result[kk].name;
                                                                    altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                                                    var EnterMobileNo;
                                                                    if (Edt_Mobile.text =='') {
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
                                                                                    Edt_Mobile.text =EnterMobileNo;
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
                                                    padding: EdgeInsets.only(top: 2),
                                                    color: Colors.white,
                                                    height: height /1.9,
                                                    width: width / 2,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: templist.length == 0
                                                            ? Center(child: Text('No Data Add!'),)
                                                            : DataTable(
                                                                sortColumnIndex: 0,
                                                                sortAscending: true,
                                                                columnSpacing: width/35,
                                                                dataRowHeight: height/10,
                                                                headingRowHeight: height/20,
                                                                headingRowColor:MaterialStateProperty.all(Colors.blue),
                                                                showCheckboxColumn: false,
                                                                  columns: const <DataColumn>[
                                                                    DataColumn(
                                                                      label: Text('Item Name',style: TextStyle(color:Colors.white),),
                                                                    ),
                                                                    DataColumn(
                                                                      label: Text('Qty',style: TextStyle(color:Colors.white),),
                                                                    ),
                                                                    DataColumn(
                                                                      label: Text('Tax%',style: TextStyle(color:Colors.white),),
                                                                    ),
                                                                    DataColumn(
                                                                      label: Text('Tax',style: TextStyle(color:Colors.white),),
                                                                    ),
                                                                    DataColumn(
                                                                      label: Text('Amount',style: TextStyle(color:Colors.white),),
                                                                    ),
                                                                    DataColumn(
                                                                      label: Text('Remove',style: TextStyle(color:Colors.white),),
                                                                    ),
                                                                  ],
                                                                  rows: templist
                                                                      .map(
                                                                        (list) => DataRow(
                                                                        color: list.SaveStatus ==1
                                                                            ? MaterialStateProperty.all(Colors.greenAccent)
                                                                            : MaterialStateProperty.all(Colors.white),
                                                                      cells: [
                                                                        DataCell(
                                                                          Text(
                                                                            "${list.itemName}\n" +"${list.uOM}" +"-" +"Rate : ${double.parse(list.price.toString()).round()}\n" +
                                                                                list.uOM +
                                                                                "\n",
                                                                            textAlign:TextAlign.left,
                                                                            style: TextStyle(fontSize: height/32),
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          Text(list.qty.toString(),style: TextStyle(fontSize: height/32),),
                                                                          showEditIcon:true,
                                                                          onTap: () {
                                                                            if (list.SaveStatus ==0) {
                                                                              if (list.uOM.trim() =="Grams" ||list.uOM.trim() =="Kgs") {
                                                                                print(list.uOM);
                                                                                showDialog<void>(
                                                                                  context:context,
                                                                                  barrierDismissible:false,
                                                                                  builder:(BuildContext context) {
                                                                                    return Dialog(
                                                                                      shape:
                                                                                      RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(50),
                                                                                      ),
                                                                                      elevation:0,
                                                                                      backgroundColor:Colors.transparent,
                                                                                      child: SubMyClac( context,templist.indexOf(list),list.price,0,tablet),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                print(list.uOM);
                                                                                showDialog<void>(context:context,
                                                                                  barrierDismissible:false,
                                                                                  builder:(BuildContext context) {
                                                                                    return Dialog(
                                                                                      shape:RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(50),),
                                                                                        elevation:0,
                                                                                        backgroundColor:Colors.transparent,
                                                                                        child: QtyMyClac(context,templist.indexOf(list),list.price,0,tablet),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            } else {}
                                                                          },
                                                                        ),
                                                                        DataCell(
                                                                          Wrap(
                                                                              direction: Axis.vertical,
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                                Text(double.parse((list.tax.toString())).toString(),
                                                                                    textAlign:TextAlign.center,style: TextStyle(fontSize: height/32))
                                                                              ]),
                                                                        ),
                                                                        DataCell(
                                                                          Center(
                                                                              child:Wrap(
                                                                                  direction: Axis.vertical,
                                                                                  alignment: WrapAlignment.center,
                                                                                  children: [
                                                                                    Text(list.TaxCode.toString(),
                                                                                        textAlign:TextAlign.center,style: TextStyle(fontSize: height/32))])),
                                                                        ),
                                                                        DataCell(
                                                                          Center(
                                                                            child: Wrap(
                                                                              direction:Axis.vertical,
                                                                              alignment:WrapAlignment.center,
                                                                              children: [
                                                                                Text(double.parse(list.amount.toString()).round().toString(),
                                                                                    textAlign:TextAlign.center,style: TextStyle(fontSize: height/32))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          Center(
                                                                            child: Center(
                                                                                child:
                                                                                IconButton(
                                                                                  icon: Icon(Icons.cancel,size: height/25,),
                                                                                  color: Colors.red,
                                                                                  onPressed:() {
                                                                                    print("Pressed");
                                                                                    if (list.SaveStatus ==0) {
                                                                                      setState(() {
                                                                                          templist.remove(list);
                                                                                          Fluttertoast.showToast(msg: "Deleted Row");
                                                                                          count();
                                                                                        },
                                                                                      );
                                                                                    } else {}
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
                                                  MobileDraftMethod(context, height, width),
                                                ],
                                              ),
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
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          SizedBox(width: 5,),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                                height: height/12,
                                                child: TextField(
                                                  style: TextStyle(fontSize: height/30),
                                                  onChanged: (val) {
                                                  setState(() {
                                                    try {
                                                      double remaining = DelReceiveAmount.text.isEmpty
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
                                                  decoration: InputDecoration(
                                                    suffixIconConstraints: BoxConstraints(
                                                        minHeight: 30, minWidth: 30),
                                                    suffixIcon: Icon(Icons.cancel,size: height/25,color: Colors.grey,),
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
                                                style: TextStyle(fontSize: height/30),
                                                enabled: false,
                                                controller: Edt_Total,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                                keyboardType: TextInputType.number,
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
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly
                                                ],
                                                keyboardType: TextInputType.number,
                                                readOnly: true,
                                                controller: Edt_Balance,
                                                decoration: InputDecoration(
                                                    labelText: "Balance Amount",
                                                    border: OutlineInputBorder(),
                                                    fillColor: Colors.blue),
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize:height/30),
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
                                                style: TextStyle(fontSize: height/30),
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
                                      SizedBox(
                                        height: 5,
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
                                                                  alterpayment = 'Cash';
                                                                  paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text));
                                                                  DelReceiveAmount.text ="";
                                                                  Edt_Balance.text = "";
                                                                  Edt_PayRemarks.text ="";
                                                                  alterpayment = "Select";
                                                                  getvalue = 0;
                                                                  getTotalBlanceAmt();
                                                                  }
                                                                });
                                                              },
                                                              child: Text('Cash', style: TextStyle(color: Colors.white),),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if(DelReceiveAmount.text==''){
                                                                    Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                  }else if(DelReceiveAmount.text=="0.00"){
                                                                    Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                  }else{                                                                     alterpayment = 'Card';
                                                                  paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text));
                                                                  DelReceiveAmount.text ="";
                                                                  Edt_Balance.text = "";
                                                                  Edt_PayRemarks.text ="";
                                                                  alterpayment = "Select";
                                                                  getvalue = 0;
                                                                  getTotalBlanceAmt();
                                                                  }
                                                                });
                                                              },
                                                              child: Text('Card', style: TextStyle(color: Colors.white),),
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
                                                                  alterpayment = 'UPI';
                                                                  paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text));
                                                                  DelReceiveAmount.text ="";
                                                                  Edt_Balance.text = "";
                                                                  Edt_PayRemarks.text ="";
                                                                  alterpayment = "Select";
                                                                  getvalue = 0;
                                                                  getTotalBlanceAmt();
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                'UPI',style: TextStyle(color: Colors.white),),
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
                                                                  alterpayment = 'Others';
                                                                  paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text),);
                                                                  DelReceiveAmount.text = "";
                                                                  Edt_Balance.text = "";
                                                                  Edt_PayRemarks.text = "";
                                                                  alterpayment = "Select";
                                                                  getvalue = 0;
                                                                  getTotalBlanceAmt();
                                                                  }
                                                                });
                                                              },
                                                              child: Text('Others',style: TextStyle(color: Colors.white),
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
                                                  height: height / 2.5,
                                                  width: double.infinity,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: paymenttemplist.length == 0
                                                          ? Center(child: Text('No Data Add!'),)
                                                          : DataTable(
                                                              sortColumnIndex: 0,
                                                              sortAscending: true,
                                                              columnSpacing: width/35,
                                                              dataRowHeight: height/10,
                                                              headingRowHeight: height/20,
                                                              headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                              showCheckboxColumn: false,
                                                                columns: <DataColumn>[
                                                                  DataColumn(
                                                                    label: Text('Remove',style: TextStyle(color:Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Type',style: TextStyle(color:Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Bill Amt',style: TextStyle(color:Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Rec Amt',style: TextStyle(color:Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Bal Amt',style: TextStyle(color:Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Remarks',style: TextStyle(color:Colors.white),),
                                                                  ),
                                                                ],
                                                                  rows: paymenttemplist.map((list) => DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                          Center(
                                                                            child: Center(
                                                                                child:
                                                                                IconButton(
                                                                                  icon: Icon(Icons.cancel,size: height/25,),
                                                                                  color: Colors.red,
                                                                                  onPressed:() {
                                                                                    print("Pressed");
                                                                                    setState(() {
                                                                                          paymenttemplist.remove(list);
                                                                                          Fluttertoast.showToast(msg:"Deleted Row");
                                                                                          getTotalBlanceAmt();
                                                                                          //  count();
                                                                                        });
                                                                                  },
                                                                                )),
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          Text("${list.PaymentName}",textAlign:TextAlign.left,style: TextStyle(fontSize: height/33,),),
                                                                        ),
                                                                        DataCell(
                                                                          Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(list.BillAmount.toString(),textAlign:TextAlign.center,style: TextStyle(fontSize: height/33,),)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          Wrap(
                                                                            direction:Axis.vertical,
                                                                            alignment:WrapAlignment.center,
                                                                            children: [
                                                                              Text(list.ReceivedAmount.toString(),
                                                                                  textAlign:TextAlign.center,style: TextStyle(fontSize: height/33,),)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          Wrap(
                                                                              direction: Axis.vertical,
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                    list.BalAmount.toString(),
                                                                                    textAlign:TextAlign.center,style: TextStyle(fontSize: height/33,),)
                                                                              ]),
                                                                        ),
                                                                        DataCell(
                                                                          Center(
                                                                            child: Center(
                                                                              child: Wrap(
                                                                                direction:Axis.vertical,
                                                                                alignment:WrapAlignment.center,
                                                                                children: [
                                                                                  Text(list.PaymentRemarks,textAlign:TextAlign.center)
                                                                                ],
                                                                              ),
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
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Loyalty Points', style: TextStyle(fontWeight: FontWeight.bold),)],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: Container(
                                                        height: height/12,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              child: Checkbox(
                                                                  value:loyalcheckboxValue,
                                                                  activeColor:Colors.blue,
                                                                  onChanged:(bool newValue) {
                                                                    setState(() {
                                                                      loyalcheckboxValue =newValue;
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
                                                                controller: Edt_Mobile,
                                                                decoration:
                                                                InputDecoration(
                                                                  labelText: "Mobile No",
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
                                                              child: TextField(
                                                                enabled: false,
                                                                controller: Edt_Loyalty,
                                                                decoration:
                                                                InputDecoration(
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
                                                              child: TextField(
                                                                enabled: false,
                                                                controller:Edt_Adjustment,
                                                                decoration:InputDecoration(
                                                                  labelText: "Adjustment",
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
                                                              child: TextField(
                                                                keyboardType:TextInputType.number,
                                                                controller:Edt_UserLoyalty,
                                                                decoration:InputDecoration(
                                                                  labelText:"User Amount",
                                                                  border:OutlineInputBorder(),),
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
                                                                controller: BalancePoints,
                                                                decoration:InputDecoration(
                                                                  fillColor: Colors.grey,
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
                                                                height: height/12,
                                                              child: Checkbox(
                                                                  value: careofcheckboxValue,
                                                                  activeColor:Colors.blue,
                                                                  onChanged:(bool newValue) {
                                                                    setState(() {
                                                                      careofcheckboxValue =newValue;
                                                                    });
                                                                    Text('');
                                                                    print('ONCHANGE$careofcheckboxValue');
                                                                  }),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              height: height/12,
                                                              child: TextField(
                                                                enabled: false,
                                                                controller: Edt_Credit,
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
                                                                    if (salespersonmodel.result[kk].name ==val) {
                                                                      print(salespersonmodel.result[kk].empID);
                                                                      altercareofname =salespersonmodel.result[kk].name;
                                                                      altercareofcode =salespersonmodel.result[kk].empID.toString();
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
                                                                controller: Edt_ReciveAmt,
                                                                decoration:InputDecoration(
                                                                  labelText: "Receive Amt",
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
                                                                decoration: InputDecoration(
                                                                  labelText: "Blance Amt",
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
                                              Visibility(
                                                visible: true,
                                                child: FloatingActionButton.extended(
                                                  backgroundColor: Colors.blue.shade700,
                                                  icon: Icon(Icons.print),
                                                  label: Text('Print & Save'),
                                                  onPressed: () {
                                                    settlementisclicked = 1;
                                                    if (settlementisclicked == 1 && paymenttemplist.length == 0) {
                                                      Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                                    } else if (double.parse(Edt_BlanceBillAmt.text) < 0) {
                                                      Fluttertoast.showToast(msg: "Get Full Amt");
                                                    } else {
                                                      insertSalesHeaderServer(
                                                          updatedocno,
                                                          formatter.format(DateTime.now()),
                                                          Edt_Mobile.text,
                                                          formatter.format(DateTime.now()),
                                                          alterocccode,
                                                          alteroccname,
                                                          formatter.format(DateTime.now()),
                                                          MyShitId.toString(),
                                                          altersalespersoncode,
                                                          altersalespersoname,
                                                          checkedValue == true? "Y": "N",
                                                          Edt_CustCharge.text.isEmpty? 0: double.parse(Edt_CustCharge.text),
                                                          Edt_Advance.text.isEmpty? 0: double.parse(Edt_Advance.text),
                                                          '',
                                                          '',
                                                          '',
                                                          '',
                                                          '',
                                                          '',
                                                          Edt_Delcharge.text.isEmpty? 0: double.parse(Edt_Delcharge.text),
                                                          batchcount,
                                                          Edt_Total.text.isEmpty? 0: double.parse(Edt_Total.text),
                                                          Edt_Tax.text.isEmpty? 0: double.parse(Edt_Tax.text),
                                                          Edt_Disc.text.isEmpty? 0: double.parse(Edt_Disc.text),
                                                          Edt_Balance.text.isEmpty? 0: double.parse(Edt_Balance.text),
                                                          Edt_Total.text.isEmpty? 0: double.parse(Edt_Total.text),
                                                          'C',
                                                          0,
                                                          '',
                                                          0,
                                                          '',
                                                          '',
                                                          '',
                                                          widget.CreationName.toString(),
                                                          widget.TableNo,
                                                          widget.SeatNo,
                                                          int.parse(sessionuserID),
                                                          sessionbranchcode);
                                                    }
                                                  },
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
                              Container(
                                padding: EdgeInsets.all(5),
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height / 15,
                                        child: DropdownSearch<String>(
                                          mode: Mode.MENU,
                                          showSearchBox: true,
                                          items:salespersonlist,
                                          label: "Sales Person",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                              if (salespersonmodel.result[kk].name == val) {
                                                altersalespersoname =salespersonmodel.result[kk].name;
                                                altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                                var EnterMobileNo;
                                                if (Edt_Mobile.text =='') {
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
                                                                Edt_Mobile.text =EnterMobileNo;
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
                                      SizedBox(height: height/100,),
                                      Container(
                                        height: MediaQuery.of(context).size.height / 1.5,
                                        width: width,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: templist.length == 0
                                                ? Center(child: Text('No Data Add!'),)
                                                : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    columnSpacing: width/35,
                                                    dataRowHeight: height/15,
                                                    headingRowHeight: height/20,
                                                    headingRowColor:MaterialStateProperty.all(Colors.blue),
                                                    showCheckboxColumn: false,
                                                    columns: const <DataColumn>[
                                                      DataColumn(
                                                        label: Text('Item Name',style: TextStyle(color:Colors.white),),
                                                      ),
                                                      DataColumn(
                                                        label: Text('Qty',style: TextStyle(color:Colors.white),),
                                                      ),
                                                      // DataColumn(
                                                      //   label: Text('Tax%',style: TextStyle(color:Colors.white),),
                                                      // ),
                                                      // DataColumn(
                                                      //   label: Text('Tax',style: TextStyle(color:Colors.white),),
                                                      // ),
                                                      DataColumn(
                                                        label: Text('Amount',style: TextStyle(color:Colors.white),),
                                                      ),
                                                      DataColumn(
                                                        label: Text('Remove',style: TextStyle(color:Colors.white),),
                                                      ),
                                                    ],
                                                    rows: templist.map(
                                                    (list) => DataRow(
                                                  color: list.SaveStatus ==1
                                                      ? MaterialStateProperty.all(Colors.greenAccent)
                                                      : MaterialStateProperty.all(Colors.white),
                                                  cells: [
                                                    DataCell(
                                                      Text(
                                                        "${list.itemName}\n" +"${list.uOM}" +"-" +"Rate : ${double.parse(list.price.toString()).round()}\n" +
                                                            list.uOM +
                                                            "\n",
                                                        textAlign:TextAlign.left,
                                                        style: TextStyle(fontSize: height/55),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(list.qty.toString(),style: TextStyle(fontSize: height/55),),
                                                      showEditIcon:true,
                                                      onTap: () {
                                                        if (list.SaveStatus ==0) {
                                                          if (list.uOM.trim() =="Grams" ||list.uOM.trim() =="Kgs") {
                                                            print(list.uOM);
                                                            showDialog<void>(
                                                              context:context,
                                                              barrierDismissible:false,
                                                              builder:(BuildContext context) {
                                                                return Dialog(
                                                                  shape:
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(50),
                                                                  ),
                                                                  elevation:0,
                                                                  backgroundColor:Colors.transparent,
                                                                  child: SubMyClac( context,templist.indexOf(list),list.price,0,tablet),
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            print(list.uOM);
                                                            showDialog<void>(context:context,
                                                              barrierDismissible:false,
                                                              builder:(BuildContext context) {
                                                                return Dialog(
                                                                  shape:RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(50),),
                                                                  elevation:0,
                                                                  backgroundColor:Colors.transparent,
                                                                  child: QtyMyClac(context,templist.indexOf(list),list.price,0,tablet),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        } else {}
                                                      },
                                                    ),
                                                    // DataCell(
                                                    //   Wrap(
                                                    //       direction: Axis.vertical,
                                                    //       alignment: WrapAlignment.center,
                                                    //       children: [
                                                    //         Text(double.parse((list.tax.toString())).toString(),
                                                    //             textAlign:TextAlign.center,style: TextStyle(fontSize: height/55))
                                                    //       ]),
                                                    // ),
                                                    // DataCell(
                                                    //   Center(
                                                    //       child:Wrap(
                                                    //           direction: Axis.vertical,
                                                    //           alignment: WrapAlignment.center,
                                                    //           children: [
                                                    //             Text(list.TaxCode.toString(),
                                                    //                 textAlign:TextAlign.center,style: TextStyle(fontSize: height/55))])),
                                                    // ),
                                                    DataCell(
                                                      Center(
                                                        child: Wrap(
                                                          direction:Axis.vertical,
                                                          alignment:WrapAlignment.center,
                                                          children: [
                                                            Text(double.parse(list.amount.toString()).round().toString(),
                                                                textAlign:TextAlign.center,style: TextStyle(fontSize: height/55))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Center(
                                                            child:
                                                            IconButton(
                                                              icon: Icon(Icons.cancel,size: height/55,),
                                                              color: Colors.red,
                                                              onPressed:() {
                                                                print("Pressed");
                                                                if (list.SaveStatus ==0) {
                                                                  setState(() {
                                                                    templist.remove(list);
                                                                    Fluttertoast.showToast(msg: "Deleted Row");
                                                                    count();
                                                                  },
                                                                  );
                                                                } else {}
                                                              },
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),).toList(),
                                            ),
                                          ),
                                       ),
                                      ),
                                      SizedBox(height: height/100,),
                                      

                                      MobileDraftMethod(context, height, width),



                                    ],
                                  ),
                                ),
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void>SenSms(headerdocno) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      //loading = true;
    });
    print(sessionuserID);
    final response = await http.get(Uri.parse("http://164.52.203.4:6005/api/v2/SendSMS?SenderId=BMUMMY&Is_Unicode=false&Is_Flash=false&Message=WELCOME TO BESTMUMMY BILL NO:"+headerdocno.toString() +" Link BILL AMOUNT: "+Edt_Total.text.toString()+" VISIT OUR Website THANK YOU FOR VISITING AGAIN&MobileNumbers="+Edt_Mobile.text.toString()+"&ApiKey=V2lGmQxjfD0Fx%2Bmf07VewfZBzcqJrEVXGO5l4D1LW%2F8%3D&ClientId=1694aa41-3444-4ccf-b45c-d7d54953f28d"));
    log("http://164.52.203.4:6005/api/v2/SendSMS?SenderId=BMUMMY&Is_Unicode=false&Is_Flash=false&Message=WELCOME TO BESTMUMMY BILL NO:"+headerdocno.toString() +"Link BILL AMOUNT: "+Edt_Total.text.toString()+" VISIT OUR nnn THANK YOU FOR VISITING AGAIN&MobileNumbers="+Edt_Mobile.text.toString()+"&ApiKey=V2lGmQxjfD0Fx%2Bmf07VewfZBzcqJrEVXGO5l4D1LW%2F8%3D&ClientId=1694aa41-3444-4ccf-b45c-d7d54953f28d");

    if (response.statusCode == 200) {

      log(response.toString());

      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  bool onWillPop() {
    /* print(pagecontroller.);
    if (pagecontroller.initialPage == 1)
      return true;
    else if (pagecontroller.initialPage == 2)
      return true;
    else if (pagecontroller.initialPage == 0) return false;*/
    print(pagecontroller.initialPage);
    print(pagecontroller.page.round());


   if(widget.NetWorkCheckNumter==1){


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
                     Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                             builder: (context) => CashierDashbord()));
                   }),
               ElevatedButton(
                   style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                   child: Text('No'),
                   onPressed: () => Navigator.of(context).pop(false)),
             ]));

   }

    else if (pagecontroller.initialPage == 0 && pagecontroller.page.round() == 0) {
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KOTSubTable(
                                      CreationName: widget.CreationName,
                                      TableNo: widget.TableNo)));
                        }),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ]));
      return true;
    }else if(pagecontroller.page.round() == 2) {
      setState(() {
        pagecontroller.jumpToPage(0);
      });
      
    }




    else {
      pagecontroller.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  Widget DraftMethod(BuildContext context, double height, double widh) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: height * 0.5,
      child: Column(
        children: [
          Row(
            children: [
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Mobile,
                    readOnly: true,
                    onTap: (){
                      var EnterMobileNo;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            maxLength: 10,
                            onChanged: (vvv) {
                              EnterMobileNo = vvv;
                              if (EnterMobileNo.toString().length ==10) {
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
                width: 10,
              ),
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Tax,
                    readOnly: true,
                    onSubmitted: (value) {
                      print("Onsubmit,${value}");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total Tax",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Total,
                    readOnly: true,
                    onSubmitted: (value) {
                      print("Onsubmit,${value}");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    //style: TextStyle(fontSize: height / 33),
                    decoration: InputDecoration(
                      labelText: "Total value",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: height / 18,
                width: widh / 7,
                child: FloatingActionButton.extended(
                  heroTag: "Print & Settlement",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(
                    Icons.print,
                    size: height / 45,
                  ),
                  label: Text('Print & Settlement',
                      //style: TextStyle(fontSize: height / 45)
                  ),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    } else if (altersalespersoncode=="" && altersalespersoname=="") {
                      showDialogboxWarning(context, "Choose The Sale Person....");
                    }

                    else if (Edt_Mobile.text.isEmpty) {
                      showDialogboxWarning(context, "Enter The Mobile No....");
                    } else if(Edt_Mobile.text.toString().length != 10){
                      showDialogboxWarning(context, "MobileNo Should be 10..");
                    }
                    else if(MyPrintStaus =='N'){
                      showDialogboxWarning(context, "Your Not Allowed...");
                    }
                    else {
                      int check = 0;

                      for(int i = 0 ; i < templist.length;i++){
                        if(templist[i].SaveStatus==0){
                          check =100;
                        }
                      }
                      if(check==100){
                        //showDialogboxWarning(context, "First Add To KOT..");
                      log(widget.NetWorkCheckNumter.toString());
                        if(widget.NetWorkCheckNumter==0){
                          showDialogboxWarning(context, "First Add To KOT..");
                        }else{
                          pagecontroller.jumpToPage(2);
                          getoccation(int.parse(sessionuserID),int.parse(sessionbranchcode));
                          getstate(2, sessionuserID);
                          getcountry(1, sessionuserID);
                        }

                      }else{
                      pagecontroller.jumpToPage(2);
                      getoccation(int.parse(sessionuserID),int.parse(sessionbranchcode));
                      getstate(2, sessionuserID);
                      getcountry(1, sessionuserID);
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: height / 18,
                width: widh / 9,
                child: FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.clear,size: height / 45,),
                  label:Text('Cancel',
                          //style: TextStyle(fontSize: height / 45)
                      ),
                  onPressed: () {
                    setState(() {
                      //loading = true;
                      sendtemplist.clear();
                    });
                    print('Line Serveice 1');
                    for (int i = 0; i < templist.length; i++)

                      //if(templist[i].SaveStatus == 0){

                      sendtemplist.add(SalesTempItemResultSend(
                          updatedocno,
                          0,
                          "CatName",
                          templist[i].itemCode,
                          templist[i].itemName,
                          templist[i].itmsGrpCod,
                          templist[i].itmsGrpNam,
                          templist[i].uOM,
                          double.parse(templist[i].qty.toString()),
                          double.parse(templist[i].price.toString()).round() ,
                          double.parse(templist[i].amount.toString()).round() ,
                          widget.CreationName,
                          widget.TableNo,
                          widget.SeatNo,
                          "D",
                          templist[i].picturName,
                          templist[i].imgUrl,
                          int.parse(sessionuserID),
                          i+1,
                          templist[i].TaxCode));
                    //  }
                    print("Order Delais list");
                    log(jsonEncode(sendtemplist));

                    //Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: height / 18,
                width: widh / 10,
                child: FloatingActionButton.extended(
                  heroTag: "ADD TO KOT",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(
                    Icons.check,
                    size: height / 45,
                  ),
                  label: Text(
                    'ADD to KOT',
                    //style: TextStyle(fontSize: height / 45),
                  ),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Please Enter Atleaset 1 Qty!");
                    } else if (altersalespersoncode=="" && altersalespersoname=="") {
                      showDialogboxWarning(context, "Choose The Sale Person....");
                    }
                    else if (Edt_Mobile.text == '') {
                      showDialogboxWarning(context, "Please Enter MobileNo..");
                    } else if(Edt_Mobile.text.toString().length != 10){
                      showDialogboxWarning(context, "MobileNo Should be..");
                    }
                    else {
                      print(Edt_Total.text);
                      print("batchcount"+batchcount.toString());
                      insertSalesHeaderServer(
                          updatedocno,
                          formatter.format(DateTime.now()),
                          Edt_Mobile.text,
                          formatter.format(DateTime.now()),
                          '',
                          //OccCode
                          '',
                          //OccName
                          formatter.format(DateTime.now()),
                          "0",
                          //Message
                          altersalespersoncode,
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
                          Edt_Total.text.isEmpty ? 500 : double.parse(Edt_Total.text),
                          'D',
                          0,
                          '',
                          0,
                          '',
                          '',
                          '',
                          widget.CreationName,
                          widget.TableNo,
                          widget.SeatNo,
                          int.parse(sessionuserID),
                          sessionbranchcode);


                    }
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: height / 18,
                width: widh / 10,
                child: FloatingActionButton.extended(
                  heroTag: "Print",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(
                    Icons.print,
                    size: height / 45,
                  ),
                  label: Text('Print',
                    //style: TextStyle(fontSize: height / 45)
                  ),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    } else if (altersalespersoncode=="" && altersalespersoname=="") {
                      showDialogboxWarning(context, "Choose The Sale Person....");
                    }
                    else if (Edt_Mobile.text.isEmpty) {
                      showDialogboxWarning(context, "Enter The Mobile No....");
                    } else if(Edt_Mobile.text.toString().length != 10){
                      showDialogboxWarning(context, "MobileNo Should be 10..");
                    }
                    else {
                      int check = 0;
                      for(int i = 0 ; i < templist.length;i++){
                        if(templist[i].SaveStatus==0){
                          check =100;
                        }
                      }
                      if(check==100){
                        showDialogboxWarning(context, "First Add To KOT..");
                      }else{
                        print("Printer");
                        KOTNetFullPrinter(sessionKOTIPAddress, sessionKOTPortNo);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget MobileDraftMethod(BuildContext context, double height, double widh) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 2),
      height: height * 0.5,
      child: Column(
        children: [
          Row(
            children: [
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 20,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Mobile,
                    readOnly: true,
                    onTap:(){
                      var EnterMobileNo;
                      showDialog(
                        context: context,
                        builder: (BuildContext contex1) => AlertDialog(
                          content: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            maxLength: 10,
                            onChanged: (vvv) {
                              EnterMobileNo = vvv;
                              if (EnterMobileNo.toString().length ==10) {
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
                    style: TextStyle(fontSize: height/55),
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
                width: 10,
              ),
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 20,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Tax,
                    readOnly: true,
                    style: TextStyle(fontSize: height/55),
                    onSubmitted: (value) {
                      print("Onsubmit,${value}");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total Tax",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              new Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height / 20,
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Total,
                    style: TextStyle(fontSize: height/55),
                    readOnly: true,
                    onSubmitted: (value) {
                      print("Onsubmit,${value}");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    //style: TextStyle(fontSize: height / 33),
                    decoration: InputDecoration(
                      labelText: "Total value",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height/15,
                width: widh / 5,
                child: FloatingActionButton.extended(
                  heroTag: "Print & Settlement",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(Icons.print,size: height / 45,),
                  label: Text('P & S',
                    style: TextStyle(fontSize: height / 55),
                  ),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    } else if (Edt_Mobile.text.isEmpty) {
                      showDialogboxWarning(
                          context, "Enter The Mobile No....");
                    } else if(Edt_Mobile.text.toString().length != 10){
                      showDialogboxWarning(context, "MobileNo Should be 10..");
                    }
                    else if(MyPrintStaus =='N'){
                      showDialogboxWarning(context, "Your Not Allowed...");
                    }
                    else {
                      int check = 0;

                      for(int i = 0 ; i < templist.length;i++){
                        if(templist[i].SaveStatus==0){
                          check =100;
                        }
                      }
                      if(check==100){
                        //showDialogboxWarning(context, "First Add To KOT..");
                        log(widget.NetWorkCheckNumter.toString());
                        if(widget.NetWorkCheckNumter==0){
                          showDialogboxWarning(context, "First Add To KOT..");
                        }else{
                          pagecontroller.jumpToPage(2);
                          getoccation(int.parse(sessionuserID),int.parse(sessionbranchcode));
                          getstate(2, sessionuserID);
                          getcountry(1, sessionuserID);
                        }
                      }else{
                        pagecontroller.jumpToPage(2);
                        getoccation(int.parse(sessionuserID),int.parse(sessionbranchcode));
                        getstate(2, sessionuserID);
                        getcountry(1, sessionuserID);
                      }
                    }
                  },
                ),
              ),

              Container(
                height: height/15,
                width: widh / 4,
                child: FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.clear,size: height / 45,),
                  label:Text('Cancel',style: TextStyle(fontSize: height / 55),),//style: TextStyle(fontSize: height / 45)),
                  onPressed: () {
                    //log( jsonEncode(sendtemplist));

                  },
                ),
              ),

              Container(
                height: height/15,
                width: widh / 4,
                child: FloatingActionButton.extended(
                  heroTag: "KOT",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(
                    Icons.check,
                    size: height / 45,
                  ),
                  label: Text(
                    'KOT',
                    style: TextStyle(fontSize: height / 55),
                  ),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(
                          context, "Please Enter Atleaset 1 Qty!");
                    } else if (Edt_Mobile.text == '') {
                      showDialogboxWarning(context, "Please Enter MobileNo..");
                    } else if(Edt_Mobile.text.toString().length != 10){
                      showDialogboxWarning(context, "MobileNo Should be..");
                    }
                    else {
                      print(Edt_Total.text);
                      print("batchcount"+batchcount.toString());
                      insertSalesHeaderServer(
                          updatedocno,
                          formatter.format(DateTime.now()),
                          Edt_Mobile.text,
                          formatter.format(DateTime.now()),
                          '',
                          //OccCode
                          '',
                          //OccName
                          formatter.format(DateTime.now()),
                          "0",// ShiftId
                          //Message
                          altersalespersoncode,
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
                          widget.CreationName,
                          widget.TableNo,
                          widget.SeatNo,
                          int.parse(sessionuserID),
                          sessionbranchcode);


                    }
                  },
                ),
              ),
              
              Container(
                height: height / 18,
                width: widh / 5,
                child: FloatingActionButton.extended(
                  heroTag: "Print",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(
                    Icons.print,
                    size: height / 45,
                  ),
                  label: Text('Print',
                    //style: TextStyle(fontSize: height / 45)
                  ),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    } else if (altersalespersoncode=="" && altersalespersoname=="") {
                      showDialogboxWarning(context, "Choose The Sale Person....");
                    }
                    else if (Edt_Mobile.text.isEmpty) {
                      showDialogboxWarning(context, "Enter The Mobile No....");
                    } else if(Edt_Mobile.text.toString().length != 10){
                      showDialogboxWarning(context, "MobileNo Should be 10..");
                    }
                    else {
                      int check = 0;
                      for(int i = 0 ; i < templist.length;i++){
                        if(templist[i].SaveStatus==0){
                          check =100;
                        }
                      }
                      if(check==100){
                        showDialogboxWarning(context, "First Add To KOT..");
                      }else{
                        print("Printer");
                        KOTNetFullPrinter(sessionKOTIPAddress, sessionKOTPortNo);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  MyClac(context,DocNo,itemCode,itemName,itmsGrpCod,uOM,price,amount,itmsGrpNam,
      picturName,imgUrl,tax,stock,varince,SaveStatus,tablet,TaxCode) {
    var Qty = '0';
    print('MyClac');
    return Stack(
      children: <Widget>[
        Container(
          width: tablet ? 450 : 250,
          height: tablet ? 520 : 350,
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
                height: tablet ? 420 : 250,
                width: tablet ? 420 : 250,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      //Qty = value ?? 0;
                      Qty = value.toStringAsFixed(3);
                      print(price.round() / 1 * double.parse(Qty));
                      amount = price.round() / 1 * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      print(value);
                      setState(() {
                        Qty = value.toStringAsFixed(3);
                        print(price.round() / 1 * double.parse(Qty));
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
                height: tablet ? 50 : 20,
              ),
              InkWell(
                onTap: () {
                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: "Enter The Qty");
                  } else {
                    setState(() {
                      addItemToList(
                          DocNo,
                          itemCode,
                          itemName,
                          itmsGrpCod,
                          uOM,
                          price,
                          amount,
                          Qty, //qty,
                          itmsGrpNam,
                          picturName,
                          imgUrl,
                          tax,
                          stock,
                          varince,
                          SaveStatus,
                          TaxCode);
                      // stock,
                      // varince);
                      Navigator.pop(context);
                    });
                  }
                },
                child: Container(
                  height: tablet ? 49 : 19,
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
                        style: TextStyle(
                            fontSize: tablet ? 20 : 10, color: Colors.white),
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

  SubMyClac(context, index, price, amount, tablet) {
    print("SubMyClac");
    var Qty = '0';
    return Stack(
      children: <Widget>[
        Container(
          width: tablet ? 450 : 250,
          height: tablet ? 520 : 350,
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
                height: tablet ? 420 : 250,
                width: tablet ? 420 : 250,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      //Qty = value ?? 0;
                      Qty = (value * 1).toStringAsFixed(3);
                      print(price.round() / 1 * double.parse(Qty));
                      amount = price.round() / 1 * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        // Qty = value.toStringAsFixed(3);
                        // print(price / 1 * double.parse(Qty));
                        // amount = price / 1 * double.parse(Qty);
                        // print(amount.toString());

                        Qty = (value * 1).toStringAsFixed(3);
                        print(price.round() / 1 * double.parse(Qty));
                        amount = price.round() / 1 * double.parse(Qty);
                      });
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
                height: tablet ? 50 : 20,
              ),
              InkWell(
                onTap: () {
                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: 'Enter The Qty');
                  } else {
                    setState(() {
                      templist[index].qty = Qty;
                      templist[index].amount = amount;
                      count();
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  height: tablet ? 49 : 19,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  QtyMyClac(context, index, price, amount, tablet) {
    var Qty = '0';
    print("QtyMyClac");
    return Stack(
      children: <Widget>[
        Container(
          width: tablet ? 450 : 250,
          height: tablet ? 520 : 350,
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
                height: tablet ? 420 : 250,
                width: tablet ? 420 : 250,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      //Qty = value ?? 0;
                      if ((value.round() - value) == 0) {
                        Qty = value.toStringAsFixed(1);
                        print(price.round() * double.parse(Qty));
                        amount = price.round() * double.parse(Qty);
                      } else {
                        Fluttertoast.showToast(msg: "please enter integer");
                      }
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
                height: tablet ? 50 : 20,
              ),
              InkWell(
                onTap: () {
                  print(Qty);
                  // if ((value.round() - value) == 0)
                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: 'Enter The Qty..');
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
                    Fluttertoast.showToast(msg: 'Enter The Integer Qty..');
                  }
                },
                child: Container(
                  height: tablet ? 49 : 19,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Text("Ok",style: TextStyle(fontSize: tablet ? 20 : 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  void addpaymentDatatble(String alterpayment, String ReceiveAmount,String Bill, String Balance, String Remarks) {
   // int count = 0;
    setState(() {
      paymenttemplist.add(
          SalesPayment(alterpayment, ReceiveAmount, Bill, Balance, Remarks));
      DelReceiveAmount.text = "";
      Edt_Total.text = "";
      BalanceAmount.text = "";
      Edt_PayRemarks.text = "";
    });
  }



  void count() async {
    setState(() {
      batchcount = 0;
      var batchamount = 0;
      batchamount1 = 0;
      taxamount = 0;
      double taxamount1 = 0;
      Edt_Total.text = '';
      for (int s = 0; s < templist.length; s++) {
        if (double.parse(templist[s].qty.toString()) > 0) {
          batchcount++;
          batchamount += templist[s].amount.toInt();
          batchamount1 = batchamount;

          templist[s].tax = ((double.parse(templist[s].TaxCode.split("@")[1]) *templist[s].amount) /100).round();
          taxamount1 += templist[s].tax;
        }
      }
      //taxamount = taxamount1;
      Edt_Balance.text = batchamount1.toStringAsFixed(2).toString();

      if (Edt_Disc.text.isNotEmpty) {
        Edt_Balance.text =(double.parse(Edt_Balance.text) - double.parse(Edt_Disc.text)).toString();
      }
      if (Edt_Advance.text.isNotEmpty) {
        Edt_Balance.text =(double.parse(Edt_Balance.text) - double.parse(Edt_Advance.text)).toString();
      }

      Edt_Total.text = batchamount1.toStringAsFixed(2).toString();
      Edt_Balance.text = batchamount1.toStringAsFixed(2).toString();
      Edt_Tax.text = taxamount1.round().toString();
      print("taxamount" + taxamount.toString());
      print("batchamount1" + batchamount1.toString());

      Edt_Total.text = (batchamount1).toStringAsFixed(2);
    });
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      sessionIPAddress = prefs.getString("KOTInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("KOTInvoicePort"));
      sessionKOTIPAddress = prefs.getString('KOTKitchenIP');
      sessionKOTPortNo = int.parse(prefs.getString('KOTKitchenPort'));
      sessionPrintStatus = prefs.getString('PrintStatus');
       sessionContact1 = prefs.getString("Contact1");
       sessionContact2 = prefs.getString("Contact2");
      print('USERID$sessionuserID');
      log(widget.NetWorkCheckNumter.toString());
      getShitIdCheck();
      printpermisioncheck();
      // timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //   MyBillNoMeth();
      // });
    });
  }

  Future<List> getShitIdCheck() async {
    List<Map> list = new List();
    int MapId=1;
    setState(() {
      loading = true;
      print("sessionuserID"+sessionuserID.toString());
      print("sessionPrintStatus"+sessionPrintStatus.toString());
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    if(sessionPrintStatus=="Y"){
      list = await database.rawQuery("SELECT * FROM IN_MOB_SHIFT_OPEN WHERE DocDate=DATE()  AND CounterId = '${sessionbranchcode}' And UserId = '${sessionuserID}' And Status = 'O'");
      log("{\"status\":\1\,\"result\":  ${jsonEncode(list)}}");

    }
    else if(sessionPrintStatus=="N"){
      list = await database.rawQuery("SELECT * FROM IN_MOB_SHIFT_OPEN WHERE DocDate=DATE()  AND CounterId = '${sessionbranchcode}'  And Status = 'O'");
      log("{\"status\":\1\,\"result\":  ${jsonEncode(list)}}");
    }
    else{
      setState(() {
        MapId = 100;
        print("sessionPrintStatus"+sessionPrintStatus.toString());
      });
    }


    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "Kindly Open The Shift..");
    } else if(MapId==100){
      showDialogboxWarning(this.context, "Kindly Open The Shift Or Check Sap Permision..");
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

    }
  }

  Future<http.Response> printpermisioncheck() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "UserName": sessionuserID,
      "UserPassword": sessionuserID
    };
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'login'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'login');
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        var login = jsonDecode(response.body)['status'] = 0;
        print(jsonDecode(response.body)['status'] = 0);
        if (login == false) {

        } else {
          log(response.body);
          print(jsonDecode(response.body)['result'][0]['PrintStatus']);
          MyPrintStaus = jsonDecode(response.body)['result'][0]['PrintStatus'];
          isbookingexistsOnline();
        }

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

  void MyBillNoMeth() {
    tdata = DateFormat("hh:mm:ss a").format(DateTime.now());

    MyBillNo = sessionuserID +"/" +sessionbranchname +"/" +tdata +"/" +widget.SeatNo.toString() +"/" +widget.TableNo.toString();
    setState(() {});
  }



  Future<http.Response> isbookingexistsOnline() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "CreationName": widget.CreationName,
      "TableNo": widget.TableNo,
      "OrderStatus":"D",
      "BranchID":sessionbranchcode,
      "SeatNo":widget.SeatNo
    };

    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'isbookingexists'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {

      if (jsonDecode(response.body)["status"] == 0) {
        log(response.body);
        getcategoriesOnline();

      } else {
        setState(() {
          log(response.body);
          bookedmodel = KOTBookedModel.fromJson(jsonDecode(response.body));
          updatedocno = bookedmodel.result[0].orderNo;
          print("updatedocno"+updatedocno.toString());
          headerData(updatedocno);
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> headerData(updatedocno) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"OrderNo": updatedocno};

    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'iskotheader'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {

      if (jsonDecode(response.body)["status"] == 0) {

        log(response.body);
        getcategoriesOnline();
        setState(() {
          loading = false;
        });

      } else {
        setState(() {
          print("Header Detalies Data..");
          loading = false;
          log(response.body);
          kotheadermodel = OfflineKotHeaderDetails.fromJson(jsonDecode(response.body));
          // Edt_Mobile.text = '';
          Edt_Mobile.text = kotheadermodel.header[0].customerNo.toString();
           Edt_Total.text = kotheadermodel.header[0].totAmount.toString();
          Edt_Advance.text = kotheadermodel.header[0].advanceAmount.toString();
          Edt_Balance.text = kotheadermodel.header[0].balanceDue.toString();
          Edt_Delcharge.text = kotheadermodel.header[0].delCharge.toString();
          Edt_Disc.text = kotheadermodel.header[0].reqDiscount.toString();
          Edt_CustCharge.text = kotheadermodel.header[0].custCharge.toString();
          Edt_Tax.text = kotheadermodel.header[0].taxAmount.toString();
          altersalespersoncode = kotheadermodel.header[0].shapeCode.toString();
          altersalespersoname = kotheadermodel.header[0].shapeName.toString();
         // altersalespersoname

          LineData(updatedocno);
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> LineData(updatedocno) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"HeaderDocNo": updatedocno,};

    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'iskotLine'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {

      if (jsonDecode(response.body)["status"] == 0) {
        log(response.body);
        getcategoriesOnline();
        setState(() {
          loading = false;
        });

      } else {
        setState(() {
          log("GET LINE DATA");
          log(response.body);
          loading = false;
          setState(() {
            kotdetailmodel = OfflineKotHeaderDetails.fromJson(jsonDecode(response.body));
            for (int k = 0; k < kotdetailmodel.detail.length; k++) {
              print(kotdetailmodel.detail[k].TaxCode);
              templist.add(
                SalesTempItemResult(
                    kotdetailmodel.detail[k].headerDocNo,
                    kotdetailmodel.detail[k].itemCode,
                    kotdetailmodel.detail[k].itemName,
                    kotdetailmodel.detail[k].itemGroupCode.toString() == null? 0: 1,
                    kotdetailmodel.detail[k].uom,
                    kotdetailmodel.detail[k].price,
                    kotdetailmodel.detail[k].total,
                    kotdetailmodel.detail[k].qty,
                    kotdetailmodel.detail[k].itemGroupCode,
                    kotdetailmodel.detail[k].pictureName,
                    kotdetailmodel.detail[k].pictureURL,
                    0.00,
                    '',
                    '',
                    1,
                    kotdetailmodel.detail[k].TaxCode),
              );
            }


          });



           count();
           getcategoriesOnline();

        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }



  void getcategoriesOnline() {
    setState(() {
      loading = true;
    });
    GetAllCategories(1, int.parse(sessionuserID), 0, 0).then((response) {
      print(response.body);
      setState(() {
        loading = true;
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
            loading = false;
            categoryitem = CategoriesModel.fromJson(jsonDecode(response.body));
            print('ONCLICK${onclick}');
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





  void getdetailitemsonline(String groupcode, int onclick) {
    print('va');
    print(groupcode);
    print(sessionbranchcode);
    print(sessionuserID);
    print(onclick);
    setState(() {
      loading = true;
    });


    print(sessionuserID + "-" + sessionbranchcode + "-" + groupcode);
    GetAllCategorieskot(2, int.parse(sessionuserID), sessionbranchcode, onclick == 0 ? 0 : groupcode)
        .then((response) {
      print("groupcode" + groupcode);
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

            salesPersonget(int.parse(sessionuserID), int.parse(sessionbranchcode));
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

  Future<List> insertSalesHeader(int OrderNo, String OrderDate, String CustomerNo, String DelDate, String OccCode, String OccName,
      String OccDate, String Message, String ShapeCode, String ShapeName, String DoorDelivery, double CustCharge, double AdvanceAmount,
      String DelStateCode, String DelStateName, String DelDistCode, String DelDistName, String DelPlaceCode, String DelPlaceName, double DelCharge,
      double TotQty, double TotAmount, double TaxAmount, double ReqDiscount, double BalanceDue, double OverallAmount, String OrderStatus,
      int ApproverID, String ApproverName, double ApprovedDiscount, String ApprovedStatus, String ApprovedRemarks1, String ApprovedRemarks2,
      String CreationName, String TableNo, String SeatNo, int UserID, String BranchID) async {
    setState(() {
      loading = true;
    });
    print('door $DoorDelivery');
    print('DelDate $DelDate');
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {
        if (updatedocno > 0 && paymenttemplist.length == 0) {
          print('HADERDOCNO${updatedocno}');
          await txn.rawInsert(
              "UPDATE IN_MOB_KOT_HEADER SET BillNo='${MyBillNo}',TotQty=$TotQty,TotAmount=$TotAmount,TaxAmount=$TaxAmount,"
              "OverallAmount=$OverallAmount,ModifiedBy=$sessionuserID,ModifiedDate=$OrderDate,OrderStatus='${OrderStatus}' "
              "Where OrderNo=$updatedocno");
          await txn.rawDelete("DELETE FROM IN_MOB_KOT_DETAILS Where HeaderDocNo=$updatedocno");
          var printid = await txn.rawQuery("SELECT OrderNo FROM IN_MOB_KOT_HEADER WHERE OrderNo=(SELECT max(OrderNo) FROM IN_MOB_KOT_HEADER)");
          var jsonUser = json.encode(printid[0]);
          updatedocno = json.decode(jsonUser)["OrderNo"];
          for (int i = 0; i < templist.length; i++) {
            var priint = await txn.rawInsert(
                "INSERT INTO IN_MOB_KOT_DETAILS ([HeaderDocNo] ,[DocDate] ,[CategoryCode] ,[CategoryName] ,[ItemCode] ,[ItemName] ,"
                "[ItemGroupCode] ,[Uom] ,[Qty] ,[Price] ,[Total] ,[CreationName] ,[TableNo] ,[SeatNo] ,[Status] ,[PictureName] ,"
                "[PictureURL] ,[CreatedBy] ,[CreatedDatetime] ,[ModifiedBy] ,[ModifiedDatetime] ,[LineID],[Sync],[Tax]) "
                "VALUES (${updatedocno},'${OrderDate}','${altercategorycode}','${altercategoryName}','${templist[i].itemCode}',"
                "'${templist[i].itemName}','${templist[i].itmsGrpCod}','${templist[i].itmsGrpNam}','${templist[i].qty}',"
                "'${templist[i].price}','${templist[i].amount}','${widget.CreationName}','${widget.TableNo}','${widget.SeatNo}','${OrderStatus}',"
                "'${templist[i].picturName}','${templist[i].imgUrl}',$sessionuserID ,'$OrderDate',$sessionuserID ,'$OrderDate',${i + 1},'0',"
                "'${templist[i].TaxCode}')");
            print(priint);
          }
          var printid1 = await txn.rawQuery("SELECT HeaderDocNo FROM IN_MOB_KOT_DETAILS WHERE HeaderDocNo=(SELECT max(HeaderDocNo) FROM IN_MOB_KOT_DETAILS)");
          var jsonUser1 = json.encode(printid1[0]);
          print(json.decode(jsonUser1)["HeaderDocNo"]);
          orderno1 = json.decode(jsonUser1)["HeaderDocNo"];
          print('orderno1 $orderno1');
        } else if (updatedocno > 0 && paymenttemplist.length > 0) {
          print('HADERDOCNO${updatedocno}');
          //UPDATE PUT ORDER iS CLOSE STATE
          await txn.rawInsert("UPDATE IN_MOB_KOT_HEADER SET TotQty=$TotQty,TotAmount=$TotAmount,TaxAmount=$TaxAmount,"
              "OverallAmount=$OverallAmount,ModifiedBy=$sessionuserID,ModifiedDate=$OrderDate,OrderStatus='C',"
              "BillNo='${MyBillNo}',BlanceAmt='${Edt_BlanceBillAmt.text}' Where OrderNo=$updatedocno");

          await txn.rawDelete("DELETE FROM IN_MOB_KOT_DETAILS Where HeaderDocNo=$updatedocno");

          var printid = await txn.rawQuery("SELECT OrderNo FROM IN_MOB_KOT_HEADER WHERE OrderNo=(SELECT max(OrderNo) FROM IN_MOB_KOT_HEADER)");

          var jsonUser = json.encode(printid[0]);

          updatedocno = json.decode(jsonUser)["OrderNo"];

          for (int i = 0; i < templist.length; i++) {
            var priint = await txn.rawInsert(
                "INSERT INTO IN_MOB_KOT_DETAILS ([HeaderDocNo] ,[DocDate] ,[CategoryCode] ,[CategoryName] ,[ItemCode] ,"
                "[ItemName] ,[ItemGroupCode] ,[Uom] ,[Qty] ,[Price] ,[Total] ,[CreationName] ,[TableNo] ,[SeatNo] ,"
                "[Status] ,[PictureName] ,[PictureURL] ,[CreatedBy] ,[CreatedDatetime] ,[ModifiedBy] ,[ModifiedDatetime]"
                " ,[LineID],[Sync],[Tax]) VALUES (${updatedocno},'${OrderDate}','${altercategorycode}','${altercategoryName}',"
                "'${templist[i].itemCode}','${templist[i].itemName}','${templist[i].itmsGrpCod}','${templist[i].itmsGrpNam}',"
                "'${templist[i].qty}','${templist[i].price}','${templist[i].amount}','${widget.CreationName}','${widget.TableNo}',"
                "'${widget.SeatNo}','${OrderStatus}','${templist[i].picturName}','${templist[i].imgUrl}',$sessionuserID ,'$OrderDate',$sessionuserID ,"
                "'$OrderDate',${i + 1},'0','${templist[i].TaxCode}')");
            print(priint);
          }
          var printid1 = await txn.rawQuery("SELECT HeaderDocNo FROM IN_MOB_KOT_DETAILS WHERE HeaderDocNo=(SELECT max(HeaderDocNo) FROM IN_MOB_KOT_DETAILS)");
          var jsonUser1 = json.encode(printid1[0]);
          print(json.decode(jsonUser1)["HeaderDocNo"]);
          orderno1 = json.decode(jsonUser1)["HeaderDocNo"];
          print('orderno1 $orderno1');
        } else {
          //INsert
          await txn.rawInsert(
              "INSERT INTO IN_MOB_KOT_HEADER ([OrderDate],[CustomerNo],[DeliveryDate],"
              "[OccCode],[OccName],[OccDate],[Message],[ShapeCode],[ShapeName],[DoorDelivery],"
              "[CustCharge],[AdvanceAmount],[DelStateCode],[DelStateName],[DelDistCode],[DelDistName],"
              "[DelPlaceCode],[DelPlaceName],[DelCharge],[TotQty],[TotAmount],[TaxAmount],[ReqDiscount],"
              "[BalanceDue] ,[OverallAmount],[OrderStatus],[ApproverID],[ApproverName],[ApprovedDiscount],"
              "[ApprovedStatus],[ApprovedRemarks1],[ApprovedRemarks2] ,[CreationName],"
              "[TableNo],[SeatNo],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],"
              "[BranchID],[Sync],[BillNo],[BlanceAmt] )VALUES ('$OrderDate','${CustomerNo}','${DelDate}','$OccCode','$OccName','$OccDate',"
              "'$Message','$ShapeCode','$ShapeName','$DoorDelivery','$CustCharge','$AdvanceAmount',"
              "'$DelStateCode','$DelStateName','$DelDistCode','$DelDistName','$DelPlaceCode','$DelPlaceName',"
              "'$DelCharge','$TotQty','$TotAmount','$TaxAmount','$ReqDiscount','$BalanceDue','$OverallAmount',"
              "'$OrderStatus','$ApproverID','$ApproverName','$ApprovedDiscount','$ApprovedStatus','$ApprovedRemarks1'"
              ",'$ApprovedRemarks2','${widget.CreationName}','${widget.TableNo}','${widget.SeatNo}',${int.parse(sessionuserID)},"
              "'$OrderDate',${int.parse(sessionuserID)},'$OrderDate',${int.parse(sessionbranchcode)},'0','${MyBillNo.toString()}','${Edt_BlanceBillAmt.text}')");

          var printid = await txn.rawQuery("SELECT OrderNo FROM IN_MOB_KOT_HEADER WHERE OrderNo=(SELECT max(OrderNo) FROM IN_MOB_KOT_HEADER)");

          var jsonUser = json.encode(printid[0]);

          mainorderno = json.decode(jsonUser)["OrderNo"];

          for (int i = 0; i < templist.length; i++) {
            print("Selva" + templist[i].TaxCode);
            var priint = await txn.rawInsert(
                "INSERT INTO IN_MOB_KOT_DETAILS ([HeaderDocNo] ,[DocDate] ,[CategoryCode] ,[CategoryName] ,"
                "[ItemCode] ,[ItemName] ,[ItemGroupCode] ,[Uom] ,[Qty] ,[Price] ,[Total] ,[CreationName] ,[TableNo] ,"
                "[SeatNo] ,[Status] ,[PictureName] ,[PictureURL] ,[CreatedBy] ,[CreatedDatetime] ,[ModifiedBy] ,[ModifiedDatetime] ,"
                "[LineID],[Sync],[Tax]) VALUES (${mainorderno},'${OrderDate}','${altercategorycode}','${altercategoryName}','${templist[i].itemCode}',"
                "'${templist[i].itemName}','${templist[i].itmsGrpCod}','${templist[i].itmsGrpNam}',"
                "'${templist[i].qty}','${templist[i].price}','${templist[i].amount}','${widget.CreationName}',"
                "'${widget.TableNo}','${widget.SeatNo}','${OrderStatus}','${templist[i].picturName}','${templist[i].imgUrl}',$sessionuserID ,'$OrderDate',"
                "$sessionuserID ,'$OrderDate',${i + 1},'0','${templist[i].TaxCode}')");
            print(priint);
          }
          var printid1 = await txn.rawQuery("SELECT HeaderDocNo FROM IN_MOB_KOT_DETAILS WHERE HeaderDocNo=(SELECT max(HeaderDocNo) FROM IN_MOB_KOT_DETAILS)");
          var jsonUser1 = json.encode(printid1[0]);
          print(json.decode(jsonUser1)["HeaderDocNo"]);
          orderno1 = json.decode(jsonUser1)["HeaderDocNo"];
        }
      });
    } catch (e) {
      showDialogboxWarning(this.context, e.toString());
    }
    await database.close();
    setState(() {
      loading = false;
    });
    if (orderno1 > 0 && paymenttemplist.length == 0) {
      Fluttertoast.showToast(msg: "Successfully Added.");
      Navigator.pop(this.context);
      setState(() {
        KOTNetPrinter(sessionKOTIPAddress, sessionKOTPortNo);
      });
      /* Navigator.pushReplacement(
          this.context, MaterialPageRoute(builder: (context) => PostData()));*/
    } else {
      setState(() {
        if (updatedocno > 0) {
          print('UPDATE PAYMENT');
         // insertsalesdetailspayment(updatedocno);
        } else {
          print('INSERT PAYMENT');
          //insertsalesdetailspayment(mainorderno);
        }
      });
    }
  }

  Future<List> insertsalesdetailspaymentOff(int headerdocno) async {
    setState(() {
      loading = true;
    });
    print('232323232');
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {
        var now = new DateTime.now();
        for (int i = 0; i < paymenttemplist.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO IN_MOB_KOT_PAYMENT ([HeaderDocNo] ,[DocDate] ,[LineID] ,[Type] ,[BillAmount] ,[RecvAmount] ,[BalanceAmount] ,"
              "[Remarks] ,[TransactionID] ,[CreationName] ,[TableNo],[SeatNo],[Status] ,[CreatedBy] ,[CreatedDate] ,[ModifiedBy] ,"
              "[ModifiedDate],[Sync]) VALUES ('$headerdocno','$now','${i + 1}',"
              "'${paymenttemplist[i].PaymentName}',${paymenttemplist[i].BillAmount},"
              "${paymenttemplist[i].ReceivedAmount},${paymenttemplist[i].BalAmount},'${paymenttemplist[i].PaymentRemarks}','0','${widget.CreationName}','${widget.TableNo}','${widget.SeatNo}','C',${sessionuserID},'$now',${sessionuserID},'$now','0')");
          print(priint);
        }
        Fluttertoast.showToast(msg: "Successfully Added");

        setState(() {
          NetPrinter(sessionIPAddress, sessionIPPortNo);
        });

        //Navigator.pop(this.context);

        /*Navigator.pushReplacement(
            this.context, MaterialPageRoute(builder: (context) => PostData()));*/
      });
    } catch (e) {
      print(e.toString());
      showDialogboxWarning(this.context, e.toString());
    }
    await database.close();
    setState(() {
      loading = false;
    });

    /*if (paymentorderno > 0) {

    } else {
      Fluttertoast.showToast(msg: "Something wrong Try Later");
    }*/
  }


  Future<List> insertSalesHeaderServer(int OrderNo,String OrderDate,String CustomerNo,String DelDate,String OccCode,String OccName,
      String OccDate,String Message,String ShapeCode,String ShapeName,String DoorDelivery,double CustCharge,double AdvanceAmount,
      String DelStateCode,String DelStateName,String DelDistCode,String DelDistName,String DelPlaceCode,String DelPlaceName,
      double DelCharge,double TotQty,double TotAmount,double TaxAmount,double ReqDiscount,double BalanceDue,double OverallAmount,
      String OrderStatus,int ApproverID,String ApproverName,double ApprovedDiscount,String ApprovedStatus,String ApprovedRemarks1,
      String ApprovedRemarks2,String CreationName,String TableNo,String SeatNo,int UserID,String BranchID) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
    "OrderNo":OrderNo,"OrderDate":OrderDate,"CustomerNo":CustomerNo,"DelDate":DelDate,
    "OccCode":OccCode,"OccName":OccName,"OccDate":OccDate,"Message":Message,"ShapeCode":ShapeCode,
    "ShapeName":ShapeName,"DoorDelivery":DoorDelivery,"CustCharge":CustCharge,"AdvanceAmount":AdvanceAmount,
    "DelStateCode":DelStateCode,"DelStateName":DelStateName,"DelDistCode":DelDistCode,"DelDistName":DelDistName,
    "DelPlaceCode":DelPlaceCode,"DelPlaceName":DelPlaceName,"DelCharge":DelCharge,"TotQty":TotQty,"TotAmount":TotAmount,
    "TaxAmount":TaxAmount,"ReqDiscount":ReqDiscount,"BalanceDue":BalanceDue,"OverallAmount":OverallAmount,"OrderStatus":OrderStatus,
    "ApproverID":ApproverID,"ApproverName":ApproverName,"ApprovedDiscount":ApprovedDiscount,"ApprovedStatus":ApprovedStatus,
    "ApprovedRemarks1":ApprovedRemarks1,"ApprovedRemarks2":ApprovedRemarks2,"CreationName":CreationName,"TableNo":TableNo,
    "SeatNo":SeatNo,"UserID":UserID,"BranchID":BranchID,"BlanceAmt" :Edt_BlanceBillAmt.text
    };
    print(sessionuserID);
    log(jsonEncode(body));

    final response = await http.post(Uri.parse(AppConstants.LIVE_URL + 'insertKOTHeader'),
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
        print('NoResponse');
      } else {
        log(response.body);

        updatedocno = jsonDecode(response.body)['result'][0]['DocNo'];

        print(jsonDecode(response.body)['result'][0]['DocNo']);
        insertsalesdetails(jsonDecode(response.body)['result'][0]['DocNo'],OrderStatus);
        setState(() {
          loading = false;
        });

      }
    } else {
      throw Exception('Failed to Login API');
    }

  }

  Future<http.Response> insertsalesdetails(int headerdocno,String OrderStatus) async {
    print('Line Serveice');
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
      sendtemplist.clear();
    });
    print('Line Serveice 1');
    for (int i = 0; i < templist.length; i++)

      //if(templist[i].SaveStatus == 0){

      sendtemplist.add(SalesTempItemResultSend(
          headerdocno,
          0,
          "CatName",
          templist[i].itemCode,
          templist[i].itemName,
          templist[i].itmsGrpCod,
          templist[i].itmsGrpNam,
          templist[i].uOM,
          double.parse(templist[i].qty.toString()),
          double.parse(templist[i].price.toString()).round() ,
          double.parse(templist[i].amount.toString()).round() ,
          widget.CreationName,
          widget.TableNo,
          widget.SeatNo,
          OrderStatus,
          templist[i].picturName,
          templist[i].imgUrl,
          int.parse(sessionuserID),
          i+1,
          templist[i].TaxCode));
    //  }
    print("Order Delais list");
    log(jsonEncode(sendtemplist));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertKOTDetail'),
        body: jsonEncode(sendtemplist),
        headers: headers);

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
        setState(() {
          if (paymenttemplist.length == 0) {
            log(response.body);
            setState(() {
              KOTNetPrinter(sessionKOTIPAddress, sessionKOTPortNo);
              Navigator.pushReplacement(
                this.context,
                MaterialPageRoute(builder: (context) => KOTSubTable(
                    CreationName: widget.CreationName,
                    TableNo: widget.TableNo),
                ),
              );

            });
          } else {
            print('ENTER THIRD$settlementisclicked');
            insertsalesdetailspayment(headerdocno,OrderStatus);
          }
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

// SelvaPayment
  Future<http.Response> insertsalesdetailspayment(int headerdocno,OrderStatus) async {
    print('insertsalesdetailspayment THIRD$settlementisclicked');
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
      sendpaymenttemplist.clear();
    });

    for (int i = 0; i < paymenttemplist.length; i++) {

      sendpaymenttemplist.add(SalesSendPayment(
            headerdocno,
            i+1,
            paymenttemplist[i].PaymentName,
            paymenttemplist[i].ReceivedAmount,
            paymenttemplist[i].BillAmount,
            paymenttemplist[i].BalAmount,
            paymenttemplist[i].PaymentRemarks,
            '0',
            OrderStatus,
            widget.CreationName,
            widget.TableNo,
            widget.SeatNo,
            int.parse(sessionuserID)));
    }

    print("PayMent" + jsonEncode(sendpaymenttemplist));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertKOTPayment'),
        body: jsonEncode(sendpaymenttemplist),
        headers: headers);

    setState(() {
      loading = false;
    });

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
        print("PayMentReposnce" + response.body.toString());
        setState(() {

          if(BillOnly){
            NetPrinter(sessionIPAddress, sessionIPPortNo).then((value) => {
              if(widget.NetWorkCheckNumter==0){
                Navigator.pushReplacement(this.context,
                  MaterialPageRoute(builder: (context) => KOTSubTable(
                      CreationName: widget.CreationName,
                      TableNo: widget.TableNo),
                  ),
                ),
              } else{
                Fluttertoast.showToast(msg: "Saved..."),
                Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context) => CashierDashbord(),),),
              }
            });

          }else if (SmsOnly){
            SenSms(headerdocno.toString()).then((value) =>{
              if(widget.NetWorkCheckNumter==0){
                Navigator.pushReplacement(this.context,
                  MaterialPageRoute(builder: (context) => KOTSubTable(
                      CreationName: widget.CreationName,
                      TableNo: widget.TableNo),
                  ),
                ),
              } else{
                Fluttertoast.showToast(msg: "Saved..."),
                Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context) => CashierDashbord(),),),
              }

            });
          }
        });

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
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

/*
  Future<bool> _onBackPressed() {
    print(pagecontroller.position);
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to Goback?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
*/

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
              fontSize: 16.0);
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

  Future additem( int FormID, int docno, int catcode, String catname, String itemCode, String itemName, String ItemGroupCode, String UOM,
      var Qty, double Price, double Total, int UserID, String PictureName, String PictureURL) {
    // setState(() {
    //   loading = true;
    // });
    InsertAddtoCart( FormID, docno, catcode, catname, itemCode, itemName, ItemGroupCode, UOM, Qty, Price, Total, sessionuserID, PictureName, PictureURL)
        .then((response) {
      print(response.body);
      // setState(() {
      //   loading = false;
      // });
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
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'].toString(),
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
    });
  }

  Future<String> fetchData() async {
    final String uri = AppConstants.LIVE_URL + "getOSRDOccation";
    //List data = List();
    var response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var res = await http
          .get(Uri.parse(uri), headers: {"Accept": "application/json"});

      var resBody = json.decode(res.body);

      print('Loaded Successfully' + resBody);

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  void addItemToList( var Docno, String itemCode, String itemName, int itmsGrpCod, String uOM, var price, var amount,
   var qty, String itmsGrpNam, String picturName, String imgUrl, var tax, var stock, var varince, int SaveSatus, var Taxcode) {
    var countt = 0;

    if (SaveSatus == 0) {
      for (int i = 0; i < templist.length; i++) {
        if (templist[i].itemCode == itemCode &&
            templist[i].price == price &&
            templist[i].Varince == varince &&
            templist[i].SaveStatus == 0) countt++;
      }
      if (countt == 0) {
        templist.add(
          SalesTempItemResult(Docno, itemCode, itemName, itmsGrpCod, uOM, price, amount, qty, itmsGrpNam,
              picturName, imgUrl, tax, stock, varince, SaveSatus, Taxcode),
        );
        setState(() {
          // double total = 0;
          // double totaltax = 0;
          // for (int i = 0; i < templist.length; i++) {
          //   total += templist[i].amount;
          //   total += double.parse(templist[i].tax);
          // }
          // Edt_Total.text = total.toString();
          // Edt_Tax.text = totaltax.toString();
        });
      } else {
        for (int i = 0; i < templist.length; i++) {
          if (templist[i].itemCode == itemCode &&
              templist[i].price == price &&
              templist[i].Varince == varince &&
              templist[i].SaveStatus == 0) {
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
    }
    count();
  }

  void BlutoothPrind_Demo() {
    print(bluetooth);
    print(pathImage);
    double TotalAmt = 0;
    double TotalCash = 0;
    double TotalCard = 0;
    bluetooth.printNewLine();

    bluetooth.printNewLine();

    bluetooth.printCustom("Hajiyar Complex,", 2, 0, charset: "windows-1250");

    bluetooth.printCustom(sessionbranchname, 2, 0, charset: "windows-1250");
    bluetooth.printCustom("Ramnad, TN 623501 ", 2, 0, charset: "windows-1250");
    bluetooth.printCustom("07904996060", 1, 0, charset: "windows-1250");
    bluetooth.printCustom(BillCurrentDate, 1, 0, charset: "windows-1250");
    bluetooth.printCustom(BillCurrentTime, 1, 0, charset: "windows-1250");
    bluetooth.printNewLine();
    bluetooth.printCustom("Bestmummy Sweet & Cakes", 3, 1, charset: "windows-1250");
    bluetooth.printNewLine();
    bluetooth.printCustom("PURCHASE", 3, 1);
    bluetooth.printCustom('------------------------------------------------', 3, 1,);
    bluetooth.printCustom("Ticket  :" + " - #94", 1, 0);
    bluetooth.printCustom("Recepit :" + " - f5LR", 1, 0);
    bluetooth.printCustom("FOR HERE", 3, 1);
    bluetooth.printCustom('------------------------------------------------', 3, 1,);
    for (int i = 0; i < templist.length; i++) {
      bluetooth.printCustom(
          templist[i].qty.toString() + " X " + templist[i].itemName, 1, 0);
      bluetooth.printCustom("Rs. " + templist[i].amount.toString(), 1, 2);
      TotalAmt += double.parse(templist[i].amount.toString());
    }
    bluetooth.printCustom('------------------------------------------------', 3, 1,);

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

  void getTotalBlanceAmt() {
    double reciveAmt = 0;
    for (int i = 0; i < paymenttemplist.length; i++) {
      reciveAmt += double.parse(paymenttemplist[i].ReceivedAmount);
    }
    Edt_ReciveAmt.text = reciveAmt.toString();
    Edt_BlanceBillAmt.text =(double.parse(Edt_ReciveAmt.text) - double.parse(Edt_Total.text)).toString();
  }
}

/*
class MyData extends DataTableSource {
  bool get isRowCountApproximate => false;

  int get rowCount => KOTScreenOfflineState._data1.length;

  int get selectedRowCount => 0;

  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(KOTScreenOfflineState._data1[index].itemName)),
      // DataCell(Text(KOTScreenOfflineState._data1[index].qty.toString())),
      DataCell(
        Center(
          child: Card(
            child: Row(
              children: [
                new FloatingActionButton(
                  onPressed: () {
                    print('object');
                    KOTScreenOfflineState._data1[index].qty++;
                  },
                  child: new Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                ),
                new Text(KOTScreenOfflineState._data1[index].qty.toString(),
                    style: new TextStyle(fontSize: 20.0)),
                new FloatingActionButton(
                  onPressed: () {
                    KOTScreenOfflineState._data1[index].qty--;
                  },
                  child: new Icon(Icons.remove, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      DataCell(Text(KOTScreenOfflineState._data1[index].uOM.toString())),
      DataCell(Text('')),
      DataCell(Text(KOTScreenOfflineState._data1[index].price.toString())),
      DataCell(Text(KOTScreenOfflineState._data1[index].amount.toString())),
    ]);
  }
}
*/

class SalesTempItemResult {
  var DocNo;
  String itemCode;
  String itemName;
  int itmsGrpCod;
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
  var SaveStatus;
  var TaxCode;



  SalesTempItemResult(
      this.DocNo,
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
      this.SaveStatus,
      this.TaxCode);

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
  var CreationName;
  var TableNo;
  var SeatNo;
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
      this.CreationName,
      this.TableNo,
      this.SeatNo,
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
        'CreationName': CreationName,
        'TableNo': TableNo,
        'SeatNo': SeatNo,
        'UserID': UserID,
      };
}

class SalesTempItemResultSend {
  var docno;
  var CatCode;
  String CatName;
  String itemCode;
  String itemName;
  var itmsGrpCod;
  String itmsGrpNam;
  String uOM;
  var qty;
  var price;
  var amount;
  var CreationName;
  var TableNo;
  var SeatNo;
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
      this.CreationName,
      this.TableNo,
      this.SeatNo,
      this.Status,
      this.picturName,
      this.imgUrl,
      this.UserID,
      this.LineID,this.Tax);

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
        'CreationName': CreationName,
        'TableNo': TableNo,
        'SeatNo': SeatNo,
        'Status': Status,
        'PictureName': picturName,
        'PictureURL': imgUrl,
        'UserID': UserID,
        'LineID': LineID,
        'Tax': Tax,
      };

/* Future<String> getData() async {
    var response =
        await http.get(Uri.parse(AppConstants.LIVE_URL + "getOSRDOccation"));

    final data = jsonEncode(response.body);

    if (data != null) {
      var resBody = json.decode(res.body);
    }
  }
*/

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
