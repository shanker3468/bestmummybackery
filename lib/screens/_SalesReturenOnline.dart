// ignore_for_file: non_constant_identifier_names, must_be_immutable, deprecated_member_use, missing_return, unnecessary_statements

import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/Mixboxmodel.dart';
import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/MixBoxChild.dart';
import 'package:bestmummybackery/Model/MySaleOrderGetLIneData.dart';
import 'package:bestmummybackery/Model/MySaleOrderGetPaymentData.dart';
import 'package:bestmummybackery/Model/MyTranctionGetLineModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/OccNameMaster.dart';
import 'package:bestmummybackery/Model/PlaceModel.dart';
import 'package:bestmummybackery/Model/SalesReturnModel.dart';
import 'package:bestmummybackery/Model/Saleshiftmodel.dart';
import 'package:bestmummybackery/Model/StateModel.dart';
import 'package:bestmummybackery/Model/countryModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
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

class SalesReturn extends StatefulWidget {
  SalesReturn(
      {Key key,
        this.ScreenID,
        this.ScreenName,
        this.OrderNo,
        this.OrderDate,
        this.DeliveryDate})
      : super(key: key);
  int ScreenID = 0;
  int OrderNo = 0;
  String ScreenName = "";
  String OrderDate = "";
  String DeliveryDate = "";

  @override
  SalesReturnState createState() => SalesReturnState();
}

class SalesReturnState extends State<SalesReturn> {
  bool checkedValue = false;

  bool delstatelayout = false;
  bool delstateplace = false;
  bool delstateremarks = false;
  String colorchange = "";
  List<SalesTempItemResult> templist = new List();


  List<SalesTempItemResultSend> sendtemplist = new List();
  List<QrGenerateJson> SecQrGenerateJson = new List();

  TextEditingController SearchController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  TextEditingController Edt_Total = new TextEditingController();
  TextEditingController Edt_NetTotal = new TextEditingController(text: "0");

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
  TextEditingController SaleOrderQrCode = new TextEditingController();

  TextEditingController BalanceAmount = new TextEditingController();

  TextEditingController DelReceiveAmount = new TextEditingController();

  List<TextEditingController> qtycontroller = new List();
  TextEditingController Edt_PayRemarks = new TextEditingController();
  TextEditingController Edt_ReciveAmt = new TextEditingController();
  TextEditingController Edt_BlanceBillAmt = new TextEditingController();
  TextEditingController Edt_Message = new TextEditingController();
  TextEditingController DocNoController = new TextEditingController();

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
  var alterdelverytime = '';
  var sessionContact1 = "";
  var sessionContact2 = "";
  var sessionPrintStatus="";

  bool loading = false;
  bool isSelected = false;
  String altersalespersoname = "";
  String altersalespersoncode = "";
  String alterpayment = "Select";
  bool SaleFrezeMode = false;

  String search = "";
  double batchcount = 0;
  int onclick = 0;
  var sessionDisdountPercentage='';

  OccModel models;
  int mainorderno = 0;
  int orderno1 = 0;
  //DataTableSource datalist;
  String alterShaCode;
  String alterShaName;

  var alterdistrictcode = "";
  var alterdistrictName = "";

  var alterstatecode = "";
  var alterstateName = "";

  var alterdeliveryplacecode="";
  var alterdeliveryplaceName="";


  var altercareofcode = "";
  var altercareofname = "";
  var HoldDocLine = 0;
  var json;
  var TransactionID='';




  MySaleOrderGetLIneData RawMySaleOrderGetLIneData;

  MyTranctionGetLineModel RawMyHoldGetLineModel;
  MySaleOrderGetPaymentData RawMySaleOrderGetPaymentData;

  OccNameMaster RawOccNameMaster;
  OccNameMaster RawShapeNameMaster;
  Saleshiftmodel RawSaleshiftmodel;
  var MyShitId=0;


  List<MyMixBoxMaster> SecMyMixBoxMaster = new List();
  List<SaveMixBoxMaster> TepmSaveMixBoxMaster = new List();

  Mixboxmodel RawMixboxmodel;
  MixBoxChild RawMixBoxChild;

  @override
  void initState() {
    print("OrderNo-" + widget.OrderNo.toString());
    getStringValuesSF();

    super.initState();
  }

  int currentIndex = 0;
  CategoriesModel categoryitem;
  SalesReturnModel itemodel;
  EmpModel salespersonmodel;

  List<String> salespersonlist = new List();
  List<String> careoflist = new List();

  int rowcount = 0;

  var batchamount1 = 0;
  var taxamount = 0;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  var DelDateController = new TextEditingController();
  var OccDateController = new TextEditingController();
  var OredersStatus='';

  OccModel occModel = new OccModel();

  countryModel countryModell = new countryModel();
  StateModel districtModel = new StateModel();
  PlaceModel placeModel = new PlaceModel();

  List<String> loc = new List();
  List<String> occ = new List();
  List<String> Shap = new List();

  List<String> countrylist = new List();
  List<String> district = new List();
  List<String> placelist = new List();

  String alteroccname = "";
  String alterocccode = "";

  String altersalespersonname;
  int settlementisclicked = 0;

  double getvalue = 0;
  bool loyalcheckboxValue = false;
  bool careofcheckboxValue = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay picked = TimeOfDay.now();
  NetworkPrinter printer;
  final pagecontroller = PageController(
    initialPage: 0,
  );

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
      print('Print result: $e');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {
    double TotalAmt = 0;
    double TotalCash = 0;
    double TotalCard = 0;
    double TotalUPI = 0;
    double TotalOther = 0;
    double TotalTaxAmt = 0;
    double GrassTotal=0;
    print('akdjcbkagdvc');
    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());

    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text('Sweets & Cakes', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1,fontType: PosFontType.fontB), linesAfter: 1);

    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text('Condact Number: '+sessionContact2.toString(),styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center,bold: true), linesAfter: 1);
    printer.row([PosColumn(text: 'Sale Return - Original', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: 'Sale Return', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: HoldDocLine.toString(), width: 7, styles: PosStyles(align: PosAlign.left),

      ),
    ]);

    printer.hr(len: 12);
    printer.row(
      [
        PosColumn(text: 'Sales Person', width: 4, styles: PosStyles(align: PosAlign.left,)),
        PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
        PosColumn(text: altersalespersoname.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
      ],
    );
    printer.row([
      PosColumn(text: 'Occation Name', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: alteroccname.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Delivery Date', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: DelDateController.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Doc Date', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: OccDateController.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.row([
      PosColumn(text: "CusNo", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Edt_Mobile.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'Item', width: 5, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: 'Amt', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: 'Tax %', width: 1, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(text: 'Total', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
    ]);

    for (int i = 0; i < templist.length; i++) {
      printer.row(
        [
          PosColumn(text: templist[i].itemName.toString() + "-" + templist[i].uOM.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: templist[i].qty.toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: double.parse(templist[i].price.toString()).round().toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: templist[i].TaxCode.split("@")[1].toString() + "%", width: 1, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: double.parse(templist[i].amount.toString()).round().toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
        ],
      );
      TotalAmt += double.parse(templist[i].amount.toString());
      TotalTaxAmt += double.parse(templist[i].tax.toString());
    }

    printer.hr();

    printer.row([
      PosColumn(text: 'Net Total', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,bold: true),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_NetTotal.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1,bold: true)),

    ]);

    printer.row([
      PosColumn(text: 'Cus Charge', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: double.parse(Edt_CustCharge.text).toString(), width: 5, styles: PosStyles(align: PosAlign.right),
      ),
    ]);

    printer.row([
      PosColumn(text: 'Del Charge', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: double.parse(Edt_Delcharge.text).toString(), width: 5, styles: PosStyles(align: PosAlign.right),
      ),
    ]);

    printer.hr(len: 12);
    GrassTotal= double.parse(Edt_NetTotal.text.toString())+double.parse(Edt_CustCharge.text.toString())+double.parse(Edt_Delcharge.text.toString());

    printer.row([
      PosColumn(text: 'Gross Total', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: GrassTotal.toString(), width: 5, styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.row([
      PosColumn( text: 'Dis Amt',width: 4,styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_Disc.text + ".00".toString(),width: 5,styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.hr(len: 12);

    printer.row([
      PosColumn(text: 'Final Net Amt', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_Total.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn( text: 'Advance Amt',width: 4,styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_Advance.text + ".00".toString(),width: 5,styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.hr(len: 12);
    double orderbalance=0;
    double retuenblance=0;
    double totacashrecive=0;
    if(double.parse(Edt_Total.text.toString())-totacashrecive==0){

    }else if(double.parse(Edt_Total.text.toString())-totacashrecive>0){
      setState(() {
        orderbalance = double.parse(Edt_Total.text.toString())-totacashrecive;
      });
    }
    else if(double.parse(Edt_Total.text.toString())-totacashrecive<0){
      setState(() {
        retuenblance = double.parse(Edt_Total.text.toString())-totacashrecive;
      });
    }
    printer.row([
      PosColumn(text: 'Order Balnce Amount', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: orderbalance.toString(), width: 5, styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.row([
      PosColumn(text: 'Return Balnce Amount', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,)),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: retuenblance.toString(), width: 5, styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    printer.hr(ch: '=', linesAfter: 1,len: 12);



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

    List<MyTempTax> SMyTempTax = new List();
    SMyTempTax.clear();

    var set = Set<String>();
    List<SalesTempItemResult> selected1 =templist.where((element) => set.add(element.TaxCode)).toList();
    //log(jsonEncode(selected1));
    print(templist.length);
    print(selected1.length);
    for (int i = 0; i < templist.length; i++) {
      for (int j = 0; j < selected1.length; j++) {
        if (i == 0 && j == 0)
          SMyTempTax.add(MyTempTax(templist[i].TaxCode, 0, 0, 0));
        print("${selected1[j].TaxCode} == ${templist[i].TaxCode.toString()}");
        if (selected1[j].TaxCode.toString() == templist[i].TaxCode.toString())
          if (SMyTempTax.where((element) => element.taxcode == selected1[j].TaxCode).length == 0)
            SMyTempTax.add(MyTempTax(templist[i].TaxCode, 0, 0, 0));
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

    printer.hr(ch: '=', linesAfter: 1,len: 12);
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
    printer.hr();

    printer.row([
      PosColumn(text: 'Message', width: 3, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: Edt_Message.text, width: 9, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.feed(2);

    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('FASSI - ' + sessionContact1,styles: PosStyles(align: PosAlign.center, bold: true));


    SecQrGenerateJson.add(QrGenerateJson(HoldDocLine, OccDateController.text, DelDateController.text));
    json = jsonEncode(SecQrGenerateJson.map((e) => e.toJson()).toList());
    print(json);

    printer.qrcode(json);

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
    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center,bold: true));
    printer.row([PosColumn(text: 'Sale Return - Duplicate', width: 12, styles: PosStyles(align: PosAlign.center,bold: true),),]);
    printer.row([
      PosColumn(text: 'Sale Return', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: HoldDocLine.toString(), width: 7, styles: PosStyles(align: PosAlign.left),
      ),
    ]);
    printer.row([
      PosColumn(text: 'Sales Person', width: 4, styles: PosStyles(align: PosAlign.left,)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname.toString(), width: 7, styles: PosStyles(align: PosAlign.left)
      ),
    ]);
    printer.row([
      PosColumn(text: 'Final Net Amt', width: 4, styles: PosStyles(align: PosAlign.left,bold: true),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: Edt_Total.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right,bold: true)),
    ]);
    printer.feed(1);
    printer.cut();
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
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
            title: new Text(widget.ScreenName),
            actions: [
              Container(
                width: width/5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10),),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: DocNoController,
                  onSubmitted: (value) {
                    print("Onsubmit,${value}");
                    templist.clear();
                    count();
                    getdetailitems(4,DocNoController.text.toString(), 1);
                  },
                  decoration: InputDecoration(
                    labelText: "Sale Invoice No",
                    hintText: "Sale Invoice No",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                    ),
                  ),
                ),

              ),
            ],

          ) :PreferredSize(
            preferredSize: Size.fromHeight(height/9),
            child: AppBar(
              title: new Text(widget.ScreenName),

            ),
          ),
          body: loading ? Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: new Center(child: image,),)
              : Center(
                child: tablet ? PageView(
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
                                              for (int cat = 0;cat <categoryitem.result.length;cat++)
                                                Container(
                                                  margin:
                                                  EdgeInsets.all(5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      TextClicked = altercategoryName =categoryitem.result[cat].name;
                                                      print("TextClicked${TextClicked}");
                                                      colorchange =categoryitem.result[cat].code.toString();
                                                      onclick = 1;
                                                      altercategoryName = categoryitem.result[cat].name;
                                                      altercategorycode = categoryitem.result[cat].code.toString().isEmpty ? 0 : categoryitem.result[cat].code.toString();
                                                      print(categoryitem.result[cat].code.toString());

                                                      setState(() {});
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height / 30,
                                                        width: 150,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          categoryitem.result[cat].name,
                                                          textAlign: TextAlign.center,
                                                          style: TextClicked == categoryitem.result[cat].name
                                                              ? TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)
                                                              : TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
                                        child: IgnorePointer(
                                          ignoring: SaleFrezeMode,
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
                                                                child: MyClac(context,
                                                                    itemodel.result[cat].itemCode,
                                                                    itemodel.result[cat].itemName,
                                                                    itemodel.result[cat].itmsGrpCod,
                                                                    itemodel.result[cat].uOM,
                                                                    itemodel.result[cat].price,
                                                                    itemodel.result[cat].amount,
                                                                    itemodel.result[cat].itmsGrpNam,
                                                                    itemodel.result[cat].picturName,
                                                                    itemodel.result[cat].imgUrl,
                                                                    (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) /
                                                                        100,
                                                                    itemodel.result[cat].onHand,
                                                                    itemodel.result[cat].Varince,
                                                                    itemodel.result[cat].TaxCode,
                                                                    tablet, height, width,
                                                                    itemodel.result[cat].qty),
                                                              );
                                                            },
                                                          );
                                                        }



                                                        else {
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
                                                              itemodel.result[cat].TaxCode,
                                                              0,itemodel.result[cat].qty);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.all(2.0),
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
                                                                    padding: const EdgeInsets.all(2.0),
                                                                    child: itemodel.result[cat].imgUrl != AppConstants.IMAGE_URL + "/"
                                                                        ? Image.network(
                                                                      itemodel.result[cat].imgUrl,
                                                                      height: height / 15,
                                                                    )
                                                                        : CircleAvatar(
                                                                      radius: 30.0,
                                                                      backgroundColor: Colors.transparent,
                                                                      child: Center(
                                                                        child: Text(
                                                                          itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.center,
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
                                                                          style: TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: TextField(
                                                                          controller: TextEditingController(
                                                                              text: "Billed Qty\n"
                                                                                  "${itemodel.result[cat].qty}\n"),
                                                                          decoration: InputDecoration(
                                                                            border: InputBorder.none,
                                                                            contentPadding: EdgeInsets.all(0),
                                                                          ),
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
                                                                right: 0,
                                                                top: 0,
                                                                child:
                                                                InkWell(
                                                                  onTap: () {
                                                                    print('ok');
                                                                    print('FLAGG${itemodel.result[cat].flag}');
                                                                  },
                                                                  child: Center(

                                                                  ),
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
                                          IgnorePointer(
                                            ignoring: SaleFrezeMode,
                                            child: Container(
                                              height: 80,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                                      width: double.infinity / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black12,
                                                        borderRadius: BorderRadius.circular(15),
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
                                                            icon: Icon(Icons.clear),
                                                          ),
                                                          border: InputBorder.none,
                                                          hintText: 'Search Item...',
                                                          prefixIcon: Padding(padding: const EdgeInsets.all(10), child: Icon(Icons.search)),
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
                                                        items:
                                                        salespersonlist,
                                                        label: "Sales Person",
                                                        onChanged: (val) {
                                                          print(val);
                                                          for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                            if (salespersonmodel.result[kk].name == val) {
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
                                          ),
                                          IgnorePointer(
                                            ignoring: SaleFrezeMode,
                                            child: Container(
                                              padding: EdgeInsets.only(top: 0),
                                              height: height / 2.4,
                                              width: width / 2,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: templist.length == 0
                                                      ? Center(
                                                    child: Text(
                                                        'No Data Add!'),
                                                  )
                                                      : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    columnSpacing: 25,
                                                    dataRowHeight: 55,
                                                    headingRowHeight: 30,
                                                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                    showCheckboxColumn: false,
                                                    columns: const <
                                                        DataColumn>[
                                                      DataColumn(label: Text('Item Name', style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Qty', style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Amount', style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Tax %',style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('TaxCode',style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('BaseQty',style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Romove',style: TextStyle(color: Colors.white),),),

                                                    ],
                                                    rows: templist .map((list) =>
                                                        DataRow(cells: [
                                                          DataCell(
                                                            Text(
                                                              "${list.itemName}\n" +
                                                                  "${list.uOM}" +
                                                                  "-" +
                                                                  "Rate : ${double.parse(list.price.toString()).round()}\n" +
                                                                  list.uOM + list.ComboNo.toString() ,
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                          ),
                                                          DataCell(
                                                              Container(
                                                                width: 100,
                                                                alignment: Alignment.center,
                                                                child: Text(list.qty.toString(),),
                                                              ),
                                                              showEditIcon:true,
                                                              onTap:() {
                                                                if (list.uOM.trim() == "Grams" || list.uOM.trim() == "Kgs") {
                                                                  showDialog<void>(
                                                                    context: context,
                                                                    barrierDismissible: false,
                                                                    builder: (BuildContext context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),
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
                                                              width: 60,
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
                                                              width: 60,
                                                              child:Wrap(
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
                                                              child:Wrap(
                                                                  direction: Axis.vertical,
                                                                  alignment: WrapAlignment.center,
                                                                  children: [
                                                                    Text(list.tax.toString(), textAlign: TextAlign.center)
                                                                  ]),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                                child: Text(list.baseQty.toString())),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: Center(
                                                                  child: IconButton(
                                                                    icon: Icon(Icons.cancel),
                                                                    color: Colors.red,
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
                            padding: const EdgeInsets.only(top: 1),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      categoryitem != null
                                          ? Container(
                                        padding: EdgeInsets.all(2),
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
                                                      print("TextClicked${TextClicked}");
                                                      colorchange = categoryitem.result[cat].code.toString();
                                                      onclick = 1;
                                                      altercategoryName =categoryitem.result[cat].name;
                                                      altercategorycode = categoryitem.result[cat].code.toString().isEmpty
                                                          ? 0 : categoryitem.result[cat].code.toString();
                                                      print(categoryitem.result[cat].code.toString());
                                                      getdetailitems(4,DocNoController.text.toString() , onclick);
                                                      setState(() {});
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height / 25,
                                                        width: width / 13,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.all(2),
                                                        decoration:
                                                        BoxDecoration(color: Colors.blue,
                                                          borderRadius: BorderRadius.all(Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          categoryitem.result[cat].name,
                                                          textAlign: TextAlign.center,
                                                          style: TextClicked == categoryitem.result[cat].name
                                                              ? TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)
                                                              : TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                                          ),
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
                                        child: IgnorePointer(
                                          ignoring: SaleFrezeMode,
                                          child: Container(
                                            height: height,
                                            width: width,
                                            child: itemodel != null
                                                ? GridView.count(
                                              childAspectRatio: 0.9,
                                              crossAxisCount: 5,
                                              children: [
                                                for (int cat = 0;cat <itemodel.result.length;cat++)
                                                  InkWell(
                                                    onTap: () {
                                                      print("Stock" + itemodel.result[cat].onHand.toString());
                                                      print(itemodel.result[cat].imgUrl);

                                                      if (itemodel.result[cat].uOM == "Grams" || itemodel.result[cat].uOM == "Kgs") {
                                                        showDialog<void>(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (BuildContext context) {
                                                            return Dialog(
                                                              shape:RoundedRectangleBorder(
                                                                borderRadius:BorderRadius.circular(50),
                                                              ),
                                                              elevation:
                                                              0,
                                                              backgroundColor:
                                                              Colors.transparent,
                                                              child: MyClac(context,
                                                                  itemodel.result[cat].itemCode,
                                                                  itemodel.result[cat].itemName,
                                                                  itemodel.result[cat].itmsGrpCod,
                                                                  itemodel.result[cat].uOM,
                                                                  itemodel.result[cat].price,
                                                                  itemodel.result[cat].amount,
                                                                  itemodel.result[cat].itmsGrpNam,
                                                                  itemodel.result[cat].picturName,
                                                                  itemodel.result[cat].imgUrl,
                                                                  (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) * itemodel.result[cat].amount) /
                                                                      100,
                                                                  itemodel.result[cat].onHand,
                                                                  itemodel.result[cat].Varince,
                                                                  itemodel.result[cat].TaxCode,tablet, height, width,itemodel.result[cat].qty),
                                                            );
                                                          },
                                                        );
                                                      }


                                                      else {
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
                                                            itemodel.result[cat].TaxCode,
                                                            0,
                                                            itemodel.result[cat].qty,
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:const EdgeInsets.all(1.0),
                                                      child: Card(
                                                        elevation: 5,
                                                        clipBehavior: Clip.antiAlias,
                                                        child: Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              crossAxisAlignment:CrossAxisAlignment.center,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.all(1.0),
                                                                  child: itemodel.result[cat].imgUrl != AppConstants.IMAGE_URL + "/"
                                                                      ? Image.network(itemodel.result[cat].imgUrl,height: height / 15,)
                                                                      : CircleAvatar(
                                                                    radius: 20.0,
                                                                    backgroundColor: Colors.transparent,
                                                                    child: Center(
                                                                      child: Text(
                                                                        // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                        itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: height / 30.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
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
                                                                        style: TextStyle(fontSize: height / 45),
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
                                      child: Column(
                                        children: [
                                          IgnorePointer(
                                            ignoring: SaleFrezeMode,
                                            child: Container(
                                              height: height / 10,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: double.infinity / 2,
                                                      decoration:BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(15),
                                                      ),
                                                      child: TextField(
                                                        controller: editingController,
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
                                                                editingController.clear();
                                                              });
                                                            },
                                                            icon: Icon(Icons.clear,size: height/25,),
                                                          ),
                                                          border: InputBorder.none,
                                                          hintText: 'Search Item...',
                                                          prefixIcon: Padding(
                                                              padding:const EdgeInsets.all(10),
                                                              child: Icon(Icons.search,size: height/25,)),
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
                                                        items: salespersonlist,
                                                        label: "Sales Person",
                                                        onChanged: (val) {
                                                          print(val);
                                                          for (int kk = 0; kk < salespersonmodel.result.length; kk++) {
                                                            if (salespersonmodel.result[kk].name == val) {
                                                              print(salespersonmodel.result[kk].empID);
                                                              altersalespersoname = salespersonmodel.result[kk].name;
                                                              altersalespersoncode = salespersonmodel.result[kk].empID.toString();
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
                                          ),
                                          IgnorePointer(
                                            ignoring: SaleFrezeMode,
                                            child: Container(
                                              padding:
                                              EdgeInsets.only(top: 1),
                                              height: height / 2.2,
                                              width: width ,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                Axis.vertical,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                  Axis.horizontal,
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
                                                      DataColumn(label: Text('Item Name',style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Qty', style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Amount', style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Tax %',style: TextStyle( color: Colors.white),),),
                                                      DataColumn(label: Text('TaxCode',style: TextStyle(color: Colors.white),),),
                                                      DataColumn(label: Text('Romove',style: TextStyle(color: Colors.white),),),
                                                    ],
                                                    rows: templist.where((element) => element.itemName.toLowerCase().contains(search.toLowerCase())).map((list) =>
                                                        DataRow(
                                                          cells: [
                                                            DataCell(
                                                              Text(
                                                                "${list.itemName}\n" + "${list.uOM}" + "-" + "Rate : ${double.parse(list.price.toString()).round()}\n" + list.uOM + "\n",
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontSize: height/35),),),
                                                            DataCell(
                                                                Text(list.qty.toString(),style: TextStyle(fontSize: height/30),),
                                                                showEditIcon: true,
                                                                onTap: () {
                                                                  if (list.uOM.trim() =="Grams" ||list.uOM.trim() =="Kgs") {
                                                                    showDialog<void>(
                                                                      context: context,
                                                                      barrierDismissible: false,
                                                                      builder: (BuildContext context) {
                                                                        return Dialog(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
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
                                                                    showDialog<void>(context: context,
                                                                      barrierDismissible: false,
                                                                      builder: (BuildContext context) {
                                                                        return Dialog(
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(50),
                                                                          ),
                                                                          elevation: 0,
                                                                          backgroundColor: Colors.transparent,
                                                                          child: EditMyMixBoxEditDilog(context, templist.indexOf(list), list.price, list.qty,
                                                                              list.itemCode,list.ComboNo,TotalQty,list.itemName,tablet, height, width),
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                  else {
                                                                    showDialog<void>(context: context,
                                                                      barrierDismissible: false,
                                                                      builder: (BuildContext context) {
                                                                        return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                                                          elevation: 0,
                                                                          backgroundColor: Colors.transparent,
                                                                          child: QtyMyClac(context, templist.indexOf(list), list.price, 0,tablet, height, width),
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }),
                                                            DataCell(Text(double.parse(list.amount.toString()).round().toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: height/32)),),
                                                            DataCell(Text(list.TaxCode.toString(), textAlign:TextAlign.center,style: TextStyle(fontSize: height/32)),),
                                                            DataCell(Text(list.tax.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: height/32)),),
                                                            DataCell(IconButton(icon: Icon(Icons.cancel,size: height/25,),color: Colors.red,
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
                                                            ),),
                                                          ],
                                                        ),
                                                    )
                                                        .toList(),
                                                  ),
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

  MyClac(context, itemCode, itemName, itmsGrpCod, uOM, price, amount,
      itmsGrpNam, picturName, imgUrl, tax, stock, varince, taxcode,tablet,double height,double width,baseqty) {
    var Qty = '0';
    var EnterQty = '0';
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
                      print(price.round() / 1 * double.parse(Qty));
                      amount = price.round() / 1 * double.parse(Qty);
                      print(amount);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        //EnterQty = value.toString();
                        Qty = (value * 1).toStringAsFixed(3);
                        print(price.round() / 1 * double.parse(Qty));
                        amount = price.round() / 1 * double.parse(Qty);
                        print(amount);
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
                        if(double.parse(baseqty.toString())>=double.parse(Qty.toString())){
                          addItemToList(
                              itemCode, itemName, itmsGrpCod, uOM, price, amount, Qty,
                              //qty,
                              itmsGrpNam, picturName, imgUrl, tax, stock, varince, taxcode, 0, baseqty);
                          Navigator.of(context).pop();
                        }else{
                          Fluttertoast.showToast(msg: "Qty Exceed..");
                        }

                      });
                    }else{
                      setState(() {
                        print(itemCode);
                        double a=0;
                        double btotal=0;
                        for(int kk = 0 ;kk < templist.length;kk++){
                          a= double.parse(templist[kk].qty.toString());
                          if(templist[kk].itemCode == itemCode){
                            double Qty1=0;
                            Qty1 = double.parse(templist[kk].qty.toString());
                            Qty1 += double.parse(Qty.toString());
                            if(double.parse(templist[kk].baseQty.toString())>=Qty1){
                              a+=double.parse(Qty.toString());
                              templist[kk].qty=a.toStringAsFixed(3).toString();
                              btotal = price.round() / 1 * double.parse(a.toString());
                              templist[kk].amount = btotal;
                              count();
                              Navigator.of(context).pop();
                            }else{
                              Fluttertoast.showToast(msg: "Qty Exceed..");
                            }
                          }
                        }
                      });
                    }


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
                      Qty = (value * 1).toStringAsFixed(3);
                      print(price / 1 * double.parse(Qty));
                      amount = price.round() / 1 * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        Qty = (value * 1).toStringAsFixed(3);
                        print(price / 1 * double.parse(Qty));
                        amount = price.round() / 1 * double.parse(Qty);
                        print(amount.toString());
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
                    Fluttertoast.showToast(msg: 'Enter The Qty..');
                  } else {
                    setState(() {
                      if(double.parse(templist[index].baseQty.toString()) >= double.parse(Qty.toString())){
                        templist[index].qty = Qty;
                        templist[index].amount = amount;
                        count();
                        Navigator.of(context).pop();
                      }else{
                        Fluttertoast.showToast(msg: 'Qty Exceed....');
                      }


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

  QtyMyClac(context, index, price, amount,tablet,double height,double width) {
    var Qty = '0';
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
                      Qty = value.toStringAsFixed(1);
                      print(price * double.parse(Qty));
                      amount = price.round() * double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = value.toStringAsFixed(1);
                        print(price * double.parse(Qty));
                        amount = price.round() * double.parse(Qty);
                        print(amount.toString());
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
                  print('kjdcbwidcwiuchc');
                  print(Qty);

                  if (double.parse(Qty) <= 0) {
                    Fluttertoast.showToast(msg: 'Enter The Qty....');
                  } else if ((double.parse(Qty).round() - double.parse(Qty.toString())) == 0) {
                    setState(() {
                      if(double.parse(templist[index].baseQty.toString()) >= double.parse(Qty.toString())){
                        templist[index].qty = Qty;
                        templist[index].amount = amount;
                        count();
                        Navigator.of(context).pop();
                      }else{
                        Fluttertoast.showToast(msg: "Qty Exeecd..");
                      }

                    });

                  } else {
                    setState(() {
                      Fluttertoast.showToast(msg: 'Enter The Integer Qty..');
                    });
                  }
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
    print(pagecontroller.initialPage);
    print(pagecontroller.page.round());
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
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
      return true;
    } else {
      pagecontroller.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      setState(() {
      });
      return false;
    }
  }

  Widget DraftMethod(BuildContext context, double height) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 30),
      height: height * 0.5,
      child: Column(
        children: [
          IgnorePointer(
            ignoring: SaleFrezeMode,
            child: Row(
              children: [
                new Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: 150,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Mobile,
                      readOnly: true,
                      onTap: () {
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
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Advance,
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_Advance;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_Advance = vvv;
                              },
                            ),
                            title: Text("Enter Advance Amt"),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Edt_Advance.text = EnterEdt_Advance;
                                              MyLocCount();
                                              Navigator.pop(context);
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
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Disc,
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_Disc;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_Disc = vvv;
                              },
                            ),
                            title: Text("Enter Discount percentage"),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              double disamt=0;

                                              if(int.parse(EnterEdt_Disc.toString())>8 ){

                                                Fluttertoast.showToast(msg: "Not Allowed...");

                                              }else {
                                                sessionDisdountPercentage = EnterEdt_Disc.toString();

                                                disamt = double.parse(Edt_NetTotal.text.toString()) * double.parse(EnterEdt_Disc.toString()) / 100.round();

                                                Edt_Disc.text = disamt.round().toString();
                                                MyLocCount();
                                                Navigator.pop(contex1, 'Ok',);
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
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Appr.Disc%",
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
          ),
          SizedBox(
            height: 10,
          ),
          IgnorePointer(
            ignoring: SaleFrezeMode,
            child: Row(
              children: [
                new Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      readOnly: true,
                      controller: Edt_Tax,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Tax",
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
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      controller: Edt_Total,
                      enabled: false,
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
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_CustCharge,
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_CustCharge;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_CustCharge = vvv;
                              },
                            ),
                            title: Text("Enter Customer Charges"),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Edt_CustCharge.text =EnterEdt_CustCharge;
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          IgnorePointer(
            ignoring: SaleFrezeMode,
            child: Row(
              children: [
                new Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Balance,
                      enabled: false,
                      onSubmitted: (value) {
                        print("Onsubmit,${value}");
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
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Delcharge,
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_Delcharge;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_Delcharge = vvv;
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
                                              Edt_Delcharge.text = EnterEdt_Delcharge;
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    color: Colors.white,
                    child: new TextField(
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 45,
                width: 180,
                child: FloatingActionButton.extended(
                  heroTag: "Save & Return",
                  backgroundColor: Colors.blue,
                  icon: Icon(Icons.print),
                  label: Text('Save & Return'),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    }  else if (altersalespersoncode.isEmpty) {
                      showDialogboxWarning(context, "Please Choose Sales person!");
                    }
                    else {
                      if (int.parse(Edt_Mobile.text) == 0) {
                        showDialogboxWarning(context, "Please Enter the Cus Mobile No");
                      }
                      else if (Edt_Mobile.text.toString().length != 10) {
                        showDialogboxWarning(context, "The Cus Mobile No Should Be 10..");
                      }
                      else if(sessionPrintStatus =='N'){
                        showDialogboxWarning(context, "Your Not Allowed...");
                      }
                      else {
                        insertSalesHeader(
                            int.parse(DocNoController.text.toString(),),
                            formatter.format(DateTime.now()),
                            Edt_Mobile.text,
                            DelDateController.text,
                            alterocccode,
                            alteroccname,
                            OccDateController.text,
                            Edt_Message.text,
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
                            Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                            Edt_Balance.text.isEmpty ? 0 : double.parse(Edt_Balance.text),
                            Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                            'C',
                            0,
                            '',
                            Edt_Disc.text.isEmpty? 0: double.parse(Edt_Disc.text),
                            '',
                            '',
                            '',
                            widget.ScreenID,
                            widget.ScreenName,
                            int.parse(sessionuserID),
                            alterShaCode,
                            alterShaName,
                            Edt_BlanceBillAmt.text,
                            int.parse(sessionbranchcode),
                            alterdelverytime
                        );

                      }

                      //print(pagecontroller.initialPage);

                    }
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              IgnorePointer(
                ignoring: SaleFrezeMode,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ),
              SizedBox(
                width: 2,
              ),



            ],
          ),
        ],
      ),
    );
  }

  Widget MobileDraftMethod(BuildContext context, double height, double width) {
    return Container(
      child: Column(
        children: [
          IgnorePointer(
            ignoring: SaleFrezeMode,
            child: Row(
              children: [
                new Expanded(
                  flex: 6,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: 150,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Mobile,
                      style: TextStyle(fontSize: height/30),
                      readOnly: true,
                      onTap: () {
                        var EnterMobileNo;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              onChanged: (vvv) {
                                EnterMobileNo = vvv;
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
                  flex: 3,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Advance,
                      readOnly: true,
                      style: TextStyle(fontSize: height/30),
                      onTap: () {
                        var EnterEdt_Advance;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_Advance = vvv;
                              },
                            ),
                            title: Text("Enter Advance Amt"),
                            actions: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Edt_Advance.text = EnterEdt_Advance;
                                              MyLocCount();
                                              Navigator.pop(context);
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
                      style: TextStyle(fontSize: height/30),
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_Disc;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_Disc = vvv;
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
                                              Edt_Disc.text = EnterEdt_Disc;
                                              MyLocCount();
                                              Navigator.pop(contex1,'Ok',);
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
                      style: TextStyle(fontSize: height/30),
                      controller: Edt_Tax,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Tax",
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
                  flex: 3,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    color: Colors.white,
                    child: new TextField(
                      style: TextStyle(fontSize: height / 30, fontWeight: FontWeight.bold),
                      controller: Edt_Total,
                      enabled: false,
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
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          IgnorePointer(
            ignoring: SaleFrezeMode,
            child: Row(
              children: [
                new Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_CustCharge,
                      style: TextStyle(fontSize: height/30,),
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_CustCharge;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_CustCharge = vvv;
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
                                              Edt_CustCharge.text = EnterEdt_CustCharge;
                                              MyLocCount();
                                              Navigator.pop(contex1,'Ok',);
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
                new Expanded(
                  flex: 5,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    color: Colors.white,
                    child: new TextField(
                      controller: Edt_Balance,
                      enabled: false,
                      style: TextStyle(fontSize: height/30,),
                      onSubmitted: (value) {
                        print("Onsubmit,${value}");
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
                      style: TextStyle(fontSize: height/30,),
                      readOnly: true,
                      onTap: () {
                        var EnterEdt_Delcharge;
                        showDialog(
                          context: context,
                          builder: (BuildContext contex1) => AlertDialog(
                            content: TextFormField(
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (vvv) {
                                EnterEdt_Delcharge = vvv;
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
                                              Edt_Delcharge.text = EnterEdt_Delcharge;
                                              MyLocCount();
                                              Navigator.pop(contex1,'Ok',);
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
                      style: TextStyle(fontSize: height / 30, fontWeight: FontWeight.bold),
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
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                height: height/12,
                width: width / 5,
                child: FloatingActionButton.extended(
                  heroTag: "Print & Settlement",
                  backgroundColor: Colors.blue,
                  icon: Icon(
                    Icons.print,
                    size: height / 45,
                  ),
                  label: Text(
                    'Print & Settlement',
                    style: TextStyle(fontSize: height / 30),
                  ),
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
                      if (int.parse(Edt_Mobile.text) == 0) {
                        showDialogboxWarning(context, "Please Enter the Cus Mobile No");
                      } else if (Edt_Mobile.text.toString().length != 10) {
                        showDialogboxWarning(context, "The Cus Mobile No Should Be 10..");
                      }
                      else if(sessionPrintStatus =='N'){
                        showDialogboxWarning(context, "Your Not Allowed...");
                      }
                      else {
                        pagecontroller.jumpToPage(1);
                      }

                      //print(pagecontroller.initialPage);

                    }
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: height/12,
                child: IgnorePointer(
                  ignoring: SaleFrezeMode,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',style: TextStyle(fontSize: height/30) )),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: height/12,
                child: IgnorePointer(
                  ignoring: SaleFrezeMode,
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
                        } else if (Edt_Mobile.text.toString().length != 10) {
                          showDialogboxWarning(context, "The Cus Mobile No Should Be 10..");
                        }
                        else {
                          settlementisclicked = 0;
                          insertSalesHeader(
                              int.parse(HoldDocLine.toString()),
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
                              Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_Disc.text),
                              '',
                              '',
                              '',
                              widget.ScreenID,
                              widget.ScreenName,
                              int.parse(sessionuserID),
                              alterShaCode,
                              alterShaName,
                              Edt_BlanceBillAmt.text,
                              int.parse(sessionbranchcode),
                              alterdelverytime
                          );
                        }
                      },
                      child: Text('Hold',style: TextStyle(fontSize: height/30) )),
                ),
              ),
              SizedBox(width: 5,),
            ],
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
    double remaining = DelReceiveAmount.text.isEmpty ? 0 : (double.parse(DelReceiveAmount.text) - double.parse(Edt_Total.text));
    if (DelReceiveAmount.text.isEmpty) {
      Edt_Balance.text = "0.00";
    } else {
      Edt_Balance.text = remaining.toStringAsFixed(2);
    }
  }

  void count() async {
    setState(() {
      batchcount = 0;
      double batchamount = 0;
      batchamount1 = 0;
      taxamount = 0;
      double taxamount1 = 0;
      Edt_Total.text = '';
      for (int s = 0; s < templist.length; s++) {
        if (double.parse(templist[s].qty.toString()) > 0) {
          batchcount++;
          batchamount += double.parse(templist[s].amount.toString()).round();
          if (widget.OrderNo == 0) {
            templist[s].tax = ((double.parse(templist[s].TaxCode.split("@")[1]) * templist[s].amount) / 100).round();
            taxamount1 += templist[s].tax;
          } else {
            templist[s].tax = ((double.parse(templist[s].TaxCode.split("@")[1]) * templist[s].amount) / 100).round();
            taxamount1 += templist[s].tax;
          }

        }
      }
      Edt_Balance.text = batchamount1.toStringAsFixed(2).toString();
      print(batchamount);
      print(taxamount);
      if (Edt_Disc.text.isNotEmpty) {
        Edt_Balance.text = (double.parse(Edt_Balance.text) - double.parse(Edt_Disc.text)).toString();
      }
      if (Edt_Advance.text.isNotEmpty) {
        Edt_Balance.text = (double.parse(Edt_Balance.text) - double.parse(Edt_Advance.text)).toString();
      }
      Edt_Total.text = batchamount.toStringAsFixed(2).toString();
      Edt_Balance.text = batchamount.toStringAsFixed(2).toString();
      Edt_Tax.text = taxamount1.round().toString();
      Edt_Total.text = batchamount.round().toString();
      Edt_NetTotal.text = (batchamount + taxamount).toStringAsFixed(2);
      MyLocCount();
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
      sessionIPAddress = prefs.getString("SaleInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));
      sessionContact1 = prefs.getString("Contact1");
      sessionContact2 = prefs.getString("Contact2");
      sessionPrintStatus = prefs.getString('PrintStatus');
      print('USERID$sessionuserID');
      getShitIdCheck1();
    });
  }

  Future<List> getShitIdCheck() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery("SELECT * FROM IN_MOB_SHIFT_OPEN WHERE DocDate=DATE()  AND CounterId = '${sessionbranchcode}' And UserId = '${sessionuserID}' And Status = 'O'");
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
        getcategories();
      });

    }
  }

  Future<List> getShitIdCheck1() async {
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
      setState(() {
        getcategories();
      });
    }
  }

  void getcategories() {
    setState(() {
      loading = true;
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
            print('ONCLICK${onclick}');
            if (onclick == 0) {
              getdetailitems(2,"0", 0);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getdetailitems( int fromid ,String groupcode, int onclick) {
    print('va');
    print(groupcode);
    print(sessionbranchcode);
    print(sessionuserID);
    print(onclick);
    setState(() {
      loading = true;
    });


    print(sessionuserID + "-" + sessionbranchcode + "-" + groupcode);
    GetAllCategories(fromid, int.parse(sessionuserID), sessionbranchcode, onclick == 0 ? 0 : groupcode)
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
            itemodel = SalesReturnModel.fromJson(jsonDecode(response.body));
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


  void insertSalesHeader(int OrderNo,String OrderDate,String CustomerNo,String DelDate,String OccCode,String OccName,
      String OccDate,String Message,String ShapeCode,String ShapeName,String DoorDelivery,double CustCharge,double AdvanceAmount,
      String DelStateCode,String DelStateName,String DelDistCode,String DelDistName,String DelPlaceCode,String DelPlaceName,
      double DelCharge,double TotQty,double TotAmount,double TaxAmount,double ReqDiscount,double BalanceDue,double OverallAmount,
      String OrderStatus,int ApproverID,String ApproverName,double ApprovedDiscount,String ApprovedStatus,String ApprovedRemarks1,
      String ApprovedRemarks2,int ScreenID,String ScreenName,int UserID,String ShaCode,String ShaName,String BlanceAmt,
      int BranchId,DeliveryTime) {

    InsertSalesReturnHeader(OrderNo,OrderDate,CustomerNo,DelDate,OccCode,OccName,OccDate,Message,ShapeCode,ShapeName,DoorDelivery,
        CustCharge == null ? 0 : CustCharge,AdvanceAmount == null ? 0 : AdvanceAmount,DelStateCode,DelStateName,DelDistCode,
        DelDistName,DelPlaceCode,DelPlaceName,DelCharge,TotQty,TotAmount,TaxAmount,ReqDiscount,BalanceDue,OverallAmount,OrderStatus,
        ApproverID,ApproverName,ApprovedDiscount,ApprovedStatus,ApprovedRemarks1,ApprovedRemarks2,ScreenID,ScreenName,UserID,ShaCode,
        ShaName,BlanceAmt,BranchId,MyShitId.toString(),DeliveryTime)
        .then((response) async {
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print("Insert Responce" + response.body);
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "Insert Failed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result'][0]['DocNo'].toString(), toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
          HoldDocLine = jsonDecode(response.body)['result'][0]['DocNo'];

          if(jsonDecode(response.body)['result'][0]['STATUSID']=="2"){

            showDialogboxWarning(this.context, "This Invoice Already Returened..");

          }else{
            await insertsalesdetails(jsonDecode(response.body)['result'][0]['DocNo']);
          }

        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }




  Future<http.Response> insertsalesdetails(int headerdocno) async {
    print('Line Serveice');
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
    });
    print('Line Serveice 1');
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(
        SalesTempItemResultSend(
            headerdocno,
            altercategorycode.isEmpty ? "0" : altercategorycode,
            templist[i].TaxCode,
            templist[i].itemCode,
            templist[i].itemName,
            templist[i].itmsGrpCod,
            templist[i].itmsGrpNam,
            templist[i].uOM,
            templist[i].qty,
            templist[i].price,
            templist[i].amount,
            widget.ScreenID.toString(),
            widget.ScreenName,
            '',
            templist[i].picturName,
            templist[i].imgUrl,
            '$sessionuserID',
            0,
            templist[i].tax,
            templist[i].ComboNo),
      );
    log(jsonEncode(sendtemplist));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertSalesreturnDetail'),
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
        NetPrinter(sessionIPAddress, sessionIPPortNo);
        setState(() {
            Navigator.pushReplacement(
              this.context,
              MaterialPageRoute(
                builder: (context) => SalesReturn(
                    ScreenID: widget.ScreenID,
                    ScreenName: widget.ScreenName,
                    OrderNo: 0,
                    OrderDate: "",
                    DeliveryDate: ""),
              ),
            );
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }




  void addItemToList(
      String itemCode, String itemName, int itmsGrpCod, String uOM, var price,
      var amount, var qty, String itmsGrpNam, String picturName,String imgUrl,
      var tax, var stock, var varince, TaxCode,var CompoNo,var baseqty) {
    var countt = 0;

    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == itemCode &&
          templist[i].price == price &&
          templist[i].Varince == varince &&
          templist[i].uOM != 'MixBox') countt++;
    }
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
          TaxCode,
          CompoNo,baseqty));
      setState(() {});
    } else {
      for (int i = 0; i < templist.length; i++) {
        if (templist[i].itemCode == itemCode && templist[i].price == price && templist[i].Varince == varince) {
          setState(() {
            var Qty=0;
            Qty = templist[i].qty;
            Qty += qty;
            if(double.parse(templist[i].baseQty.toString())>=Qty){
              Qty = templist[i].qty += qty;
              templist[i].amount = Qty * double.parse(templist[i].price.toString()).round();
            }else{
              showDialogboxWarning(this.context, "Qty Exceed...");
            }
          });
        }
      }
    }
    count();
  }



  void getTotalBlanceAmt(Status) {
    print(Status);
    double reciveAmt = 0;
    Edt_ReciveAmt.text = reciveAmt.toString();
    print("Edt_Total"+Edt_Total.text.toString());

    Edt_BlanceBillAmt.text =(double.parse(Edt_ReciveAmt.text) - double.parse(Edt_Total.text)).roundToDouble().toString();
  }

  void MyLocCount() {
    double batchamount = 0;
    batchamount = (double.parse(Edt_NetTotal.text) - double.parse(Edt_Disc.text) + double.parse(Edt_CustCharge.text));
    Edt_Total.text = (batchamount+double.parse(Edt_Delcharge.text)).round().toString();
    Edt_Balance.text = (double.parse(Edt_Total.text) - double.parse(Edt_Advance.text)).toString();
    DelReceiveAmount.text = Edt_Advance.text;
  }
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
  var baseQty;

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
      this.TaxCode,
      this.ComboNo,this.baseQty);
}

class SalesPayment {
  String PaymentName;
  var ReceivedAmount;
  var BillAmount;
  var BalAmount;
  String PaymentRemarks;
  int status = 0;
  SalesPayment(this.PaymentName, this.ReceivedAmount, this.BillAmount, this.BalAmount, this.PaymentRemarks, this.status);
}

class SalesSendPayment {
  var docno;
  int LineID;
  String PaymentName;
  String ReceivedAmount;
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
  var ItemComboNo;

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
      this.Tax,
      this.ItemComboNo

      );

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
    'Tax': Tax,
    'ItemComboNo': ItemComboNo
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

class QrGenerateJson {
  var OrderNo;
  var OccDate;
  var DeliveryDate;
  QrGenerateJson(this.OrderNo, this.OccDate, this.DeliveryDate);
  Map toJson() => {
    'OrderNo': OrderNo,
    'OccDate': OccDate,
    'DeliveryDate': DeliveryDate
  };
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


