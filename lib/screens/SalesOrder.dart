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
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/Model/Saleshiftmodel.dart';
import 'package:bestmummybackery/Model/StateModel.dart';
import 'package:bestmummybackery/Model/countryModel.dart';
import 'package:bestmummybackery/ReportsModel/MySaleOrderManageMent.dart';
import 'package:bestmummybackery/TransactionScreen.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SalesOrder extends StatefulWidget {
  SalesOrder(
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
  SalesOrderState createState() => SalesOrderState();
}

class SalesOrderState extends State<SalesOrder> {
  bool checkedValue = false;

  bool delstatelayout = false;
  bool delstateplace = false;
  bool delstateremarks = false;
  String colorchange = "";
  List<SalesTempItemResult> templist = new List();
  List<SalesPayment> paymenttemplist = new List();
  List<SalesSendPayment> sendpaymenttemplist = new List();
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
  DataTableSource _data;
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
  List<SendMixBoxMaster> sendMixBoxMaster = new List();
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




  _SelectDelivery(BuildContext context) async {

    int hour=0;
    var minits='';
    var session='';

    picked = await showTimePicker(
        initialTime: selectedTime,
        context: context);
    if(picked != null){
      selectedTime = picked;
     // print(selectedTime.minute);
      print(selectedTime.hour);
      // print(selectedTime.hour);
      if(selectedTime.hour>=12){
        setState(() {
          hour = int.parse(selectedTime.hour .toString()) - 12;
          minits = selectedTime.minute .toString();
          session = 'PM';
          print(hour.toString()+":"+minits.toString()+"-"+session.toString());
          alterdelverytime  = hour.toString()+":"+minits.toString()+"-"+session.toString();
        });

      }else if (selectedTime.hour<12){
        setState(() {
          hour = selectedTime.hour;
          minits = selectedTime.minute .toString();
          session = 'AM';
          print(hour.toString()+":"+minits.toString()+"-"+session.toString());
          alterdelverytime  = hour.toString()+":"+minits.toString()+"-"+session.toString();
        });

      }else{
        setState(() {
          alterdelverytime ='';
        });
      }
    }

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
    printer.row([PosColumn(text: 'Sale Order - Original', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: 'Sale Order', width: 4, styles: PosStyles(align: PosAlign.left),),
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
    for (int i = 0; i < paymenttemplist.length; i++) {
        totacashrecive += double.parse(paymenttemplist[i].ReceivedAmount);
    }
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

    printChildOne(printer);
  }
  Future<void> printChildOne(NetworkPrinter printer) async {
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
    printer.row([PosColumn(text: 'Sale Order - Original', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: 'Sale Order', width: 4, styles: PosStyles(align: PosAlign.left),),
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
    for (int i = 0; i < paymenttemplist.length; i++) {
      totacashrecive += double.parse(paymenttemplist[i].ReceivedAmount);
    }
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

    printChildTwo(printer);
  }
  Future<void> printChildTwo(NetworkPrinter printer) async {
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
    printer.row([PosColumn(text: 'Sale Order - Original', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: 'Sale Order', width: 4, styles: PosStyles(align: PosAlign.left),),
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
    for (int i = 0; i < paymenttemplist.length; i++) {
      totacashrecive += double.parse(paymenttemplist[i].ReceivedAmount);
    }
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
    printer.row([PosColumn(text: 'Sale Order - Duplicate', width: 12, styles: PosStyles(align: PosAlign.center,bold: true),),]);
    printer.row([
      PosColumn(text: 'Sale Order', width: 4, styles: PosStyles(align: PosAlign.left),),
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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MySaleOrderManageMent(
                          ScreenId: 0, ScreenName: "My Orders Management"),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Text(
                    'My Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  GetMyHoldRecordeOnline().then(
                    (value) => showDialog<void>(
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Text(
                    'MyHold',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.folder),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TransactionScreen(
                        ScreenId: 1,
                        ScreenName: "Sales Order",
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 5),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  var EnterMobileNo;
                  showDialog(
                    context: context,
                    builder: (BuildContext contex1) => AlertDialog(
                      content: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onSubmitted: (vvv) {
                          setState(() {
                            EnterMobileNo = vvv;
                            SaleOrderQrCode.text = EnterMobileNo;
                            widget.OrderNo = int.parse(SaleOrderQrCode.text);
                            Navigator.pop(contex1);
                            GetMyUpdateTablRecord();
                            GetMyUpdatePayMentTablRecord();
                          });
                        },
                      ),
                      title: Text("Scan your Bill"),
                      actions: <Widget>[
                        Column(
                          children: [
                            Row(
                              children: [
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
              )
            ],
          )
              :PreferredSize(
                    preferredSize: Size.fromHeight(height/9),
                      child: AppBar(
                          title: new Text(widget.ScreenName),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MySaleOrderManageMent(
                                        ScreenId: 0, ScreenName: "My Orders Management"),
                                  ),
                                );
                              },
                              child: Container(
                                height: 100,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'My Orders',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                GetMyHoldRecordeOnline().then(
                                      (value) => showDialog<void>(
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'MyHold',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.folder),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => TransactionScreen(
                                      ScreenId: 1,
                                      ScreenName: "Sales Order",
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 5),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                var EnterMobileNo;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext contex1) => AlertDialog(
                                    content: TextField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      onSubmitted: (vvv) {
                                        setState(() {
                                          EnterMobileNo = vvv;
                                          SaleOrderQrCode.text = EnterMobileNo;
                                          widget.OrderNo = int.parse(SaleOrderQrCode.text);
                                          Navigator.pop(contex1);
                                          GetMyUpdateTablRecord();
                                          GetMyUpdatePayMentTablRecord();
                                        });
                                      },
                                    ),
                                    title: Text("Scan your Bill"),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          Row(
                                            children: [
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
                            )
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
              : Center(
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
                                                                getdetailitems(categoryitem.result[cat].code.toString().isEmpty ? 0 : categoryitem.result[cat].code.toString(), onclick);
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
                                                        childAspectRatio: 0.9,
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
                                                                      count=int.parse(templist[i].ComboNo.toString()) ;
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
                                                                      (double.parse(itemodel.result[cat].TaxCode.split("@")[1]) *
                                                                              itemodel.result[cat].amount) / 100,
                                                                      itemodel.result[cat].onHand,
                                                                      itemodel.result[cat].Varince,
                                                                      itemodel.result[cat].TaxCode,
                                                                      0);
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(2.0),
                                                                child: Card(
                                                                  elevation: 5,
                                                                  clipBehavior: Clip
                                                                      .antiAlias,
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
                            Container(
                              padding:
                                  EdgeInsets.only(left: 5, right: 5, top: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        new Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: TextField(
                                                controller: Edt_Mobile,
                                                decoration: InputDecoration(
                                                  labelText: "Customer No",
                                                  border: OutlineInputBorder(),
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
                                          child: InkWell(
                                            onTap: () {
                                              if (SaleFrezeMode == true) {
                                              } else {
                                                _selectDate(context);
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: TextField(
                                                enabled: false,
                                                controller: DelDateController,
                                                decoration: InputDecoration(
                                                  labelText: "Delivery Date",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      //Use of SizedBox
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        new Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: DropdownSearch<String>(
                                                mode: Mode.DIALOG,
                                                showSearchBox: true,
                                                items: occ,
                                                label: "Choose Occation",
                                                onChanged: (val) {
                                                  for (int kk = 0;kk <RawOccNameMaster.testdata.length;
                                                      kk++) {
                                                    if (RawOccNameMaster.testdata[kk].occName == val) {
                                                      print(RawOccNameMaster.testdata[kk].occCode);
                                                      alterocccode =RawOccNameMaster.testdata[kk].occCode.toString();
                                                      alteroccname =RawOccNameMaster.testdata[kk].occName;
                                                    }
                                                  }
                                                },
                                                selectedItem: alteroccname,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        new Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              if (SaleFrezeMode == true) {
                                              } else {
                                                _selectDate1(context);
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: TextField(
                                                enabled: false,
                                                controller: OccDateController,
                                                decoration: InputDecoration(
                                                  labelText: "Occution Date",
                                                  border: OutlineInputBorder(),
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
                                          flex: 1,
                                          child: InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: TextField(
                                                controller: Edt_Message,
                                                maxLength: 100,
                                                decoration: InputDecoration(
                                                  labelText: "Message",
                                                  border: OutlineInputBorder(),
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
                                          child: InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: DropdownSearch<String>(
                                                mode: Mode.DIALOG,
                                                showSearchBox: true,
                                                items: Shap,
                                                label: "Choose Shape",
                                                onChanged: (val) {
                                                  for (int kk = 0;kk <RawShapeNameMaster.testdata.length;
                                                      kk++) {
                                                    if (RawShapeNameMaster.testdata[kk].occName ==val) {
                                                      print(RawShapeNameMaster.testdata[kk].occCode);
                                                      alterShaCode =RawShapeNameMaster.testdata[kk].occCode.toString();
                                                      alterShaName =RawShapeNameMaster.testdata[kk].occName;
                                                    }
                                                  }
                                                },
                                                selectedItem: alterShaName,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        new Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                labelText: "Sales Person",
                                                border: OutlineInputBorder(),
                                              ),
                                              controller: TextEditingController(
                                                  text: altersalespersoname),
                                              readOnly: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print(checkedValue);
                                        if (checkedValue == true) {
                                          delstatelayout = true;
                                          delstateplace = true;
                                          delstateremarks = true;
                                        } else {
                                          delstatelayout = false;
                                          delstateplace = false;
                                          delstateremarks = false;
                                        }
                                      },
                                      child: SizedBox(
                                        width: 300,
                                        child: CheckboxListTile(
                                          title:
                                              Text("Do You Want Door Delivery?"),
                                          // autofocus: false,
                                          activeColor: Colors.blue,
                                          checkColor: Colors.green,
                                          selected: checkedValue,
                                          value: checkedValue,
                                          onChanged: (bool value) {
                                            setState(() {
                                              checkedValue = value;
                                              print(checkedValue);
                                              if (checkedValue == true) {
                                                delstatelayout = true;
                                                delstateplace = true;
                                                delstateremarks = true;
                                              } else {
                                                delstatelayout = false;
                                                delstateplace = false;
                                                delstateremarks = false;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: delstatelayout,
                                      child: Row(
                                        children: [
                                          new Expanded(
                                            flex: 5,
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: DropdownSearch<String>(
                                                  mode: Mode.BOTTOM_SHEET,
                                                  showSearchBox: true,
                                                  items: countrylist,
                                                  label: "Delivery State",
                                                  onChanged: (val) {
                                                    for (int kk = 0;kk <countryModell.result.length;
                                                        kk++) {
                                                      if (countryModell.result[kk].name == val) {
                                                        print(countryModell.result[kk].code);
                                                        alterstatecode =countryModell.result[kk].code.toString();
                                                        alterstateName =countryModell.result[kk].name.toString();
                                                      }
                                                    }
                                                  },
                                                  selectedItem: alterstateName,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          new Expanded(
                                            flex: 5,
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: DropdownSearch<String>(
                                                  mode: Mode.BOTTOM_SHEET,
                                                  showSearchBox: true,
                                                  items: district,
                                                  label: "Delivery District",
                                                  onChanged: (val) {
                                                    for (int kk = 0;kk <districtModel.result.length;kk++) {
                                                      if (districtModel.result[kk].name == val) {
                                                        print(districtModel.result[kk].code);
                                                        alterdistrictcode =districtModel.result[kk].code.toString();
                                                        alterdistrictName =districtModel.result[kk].name.toString();
                                                      }
                                                    }
                                                  },
                                                  selectedItem: alterdistrictName,
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
                                    Visibility(
                                      visible: delstateplace,
                                      child: Row(
                                        children: [
                                          new Expanded(
                                            flex: 5,
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: DropdownSearch<String>(
                                                  mode: Mode.BOTTOM_SHEET,
                                                  showSearchBox: true,
                                                  label: "Delivery Place",
                                                  items: placelist,
                                                  onChanged: (val) {
                                                    for (int kk = 0;kk <placeModel.result.length;kk++) {
                                                      if (placeModel.result[kk].name == val) {
                                                        print(districtModel.result[kk].code);
                                                        alterdeliveryplacecode =placeModel.result[kk].code.toString();
                                                        alterdeliveryplaceName =placeModel.result[kk].name.toString();
                                                      }
                                                    }
                                                  },
                                                  selectedItem: alterdeliveryplaceName,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          new Expanded(
                                            flex: 5,
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: TextField(
                                                  controller: Edt_Delcharge,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    labelText: "Delivery Charge",
                                                    border: OutlineInputBorder(),
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
                                    Visibility(
                                      visible: delstateremarks,
                                      child: Row(
                                        children: [
                                          new Expanded(
                                            flex: 5,
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: TextField(
                                                  maxLength: 200,
                                                  decoration: InputDecoration(
                                                    labelText: "Remarks",
                                                    border: OutlineInputBorder(),
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
                                    LineSeparator(color: Colors.grey),
                                    ElevatedButton(
                                      onPressed: () {

                                        if(DelDateController.text==''){
                                          Fluttertoast.showToast(msg: 'Select The Delivery Date..');
                                        }
                                        else if(alterocccode=='' && alteroccname==''){
                                          Fluttertoast.showToast(msg: 'Choose Occation..');
                                        }
                                        else if(OccDateController.text==''){
                                          Fluttertoast.showToast(msg: 'Select The Occation Date..');
                                        }


                                        else{
                                          Fluttertoast.showToast(msg: 'Settlement Page..');
                                          pagecontroller.jumpToPage(2);
                                        }
                                      },
                                      child: Text('Next'),
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
                                                    double remaining =
                                                        DelReceiveAmount
                                                                .text.isEmpty
                                                            ? 0
                                                            : (double.parse(
                                                                    DelReceiveAmount
                                                                        .text) -
                                                                double.parse(
                                                                    Edt_Total
                                                                        .text));
                                                    if (DelReceiveAmount
                                                        .text.isEmpty) {
                                                      Edt_Balance.text = "0.00";
                                                    } else {
                                                      Edt_Balance.text = remaining
                                                          .toStringAsFixed(2);
                                                    }
                                                    print(remaining);
                                                  } catch (Exception) {}
                                                });
                                              },
                                              controller: DelReceiveAmount,
                                              readOnly:true,
                                              decoration: InputDecoration(
                                                  suffixIconConstraints:
                                                      BoxConstraints(
                                                          minHeight: 30,
                                                          minWidth: 30),
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
                                            height: 50,
                                            child: TextField(
                                              enabled: false,
                                              controller: Edt_Total,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
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
                                            height: 50,
                                            child: TextField(
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
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
                                            height: 50,
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
                                        // Container(
                                        //   child: ElevatedButton(
                                        //     onPressed: () {
                                        //       if (alterpayment == "Select") {
                                        //         showDialogboxWarning(
                                        //             context, "Please Choose Card Type");
                                        //       } else {
                                        //         setState(() {
                                        //           paymenttemplist.add(SalesPayment(
                                        //               alterpayment,
                                        //               DelReceiveAmount.text,
                                        //               Edt_Total.text,
                                        //               Edt_Balance.text,
                                        //               Edt_PayRemarks.text));
                                        //           DelReceiveAmount.text = "";
                                        //           Edt_Balance.text = "";
                                        //           Edt_PayRemarks.text = "";
                                        //           alterpayment = "Select";
                                        //           getvalue = 0;
                                        //         });
                                        //       }
                                        //     },
                                        //     child: Text('Add'),
                                        //   ),
                                        // ),
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
                                                height: height / 2,
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                if(DelReceiveAmount.text==''){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details1");
                                                                }else if(DelReceiveAmount.text=="0.00"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else if(DelReceiveAmount.text=="0"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else{
                                                                  alterpayment = 'Cash';
                                                                  paymenttemplist.add(
                                                                      SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                                  DelReceiveAmount.text = "";
                                                                  Edt_Balance.text = "";
                                                                  Edt_PayRemarks.text = "";
                                                                  alterpayment = "Select";
                                                                  getvalue = 0;
                                                                  getTotalBlanceAmt("Cash");
                                                                }

                                                              });
                                                            },
                                                            child: Text('Cash', style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                            onPressed: () {
                                                              setState(() {

                                                                if(DelReceiveAmount.text==''){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details1");
                                                                }else if(DelReceiveAmount.text=="0.00"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else if(DelReceiveAmount.text=="0"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else{
                                                                alterpayment = 'Card';
                                                                paymenttemplist.add(
                                                                    SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                                DelReceiveAmount.text = "";
                                                                Edt_Balance.text = "";
                                                                Edt_PayRemarks.text = "";
                                                                alterpayment = "Select";
                                                                getvalue = 0;
                                                                getTotalBlanceAmt("Card");
                                                                }
                                                              });
                                                            },
                                                            child: Text('Card', style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                            onPressed: () {
                                                              setState(() {
                                                                if(DelReceiveAmount.text==''){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details1");
                                                                }else if(DelReceiveAmount.text=="0.00"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else if(DelReceiveAmount.text=="0"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else{
                                                                alterpayment = 'UPI';
                                                                paymenttemplist.add(
                                                                    SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                                DelReceiveAmount.text = "";
                                                                Edt_Balance.text = "";
                                                                Edt_PayRemarks.text = "";
                                                                alterpayment = "Select";
                                                                getvalue = 0;
                                                                getTotalBlanceAmt("UPI");
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
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details1");
                                                                }else if(DelReceiveAmount.text=="0.00"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else if(DelReceiveAmount.text=="0"){
                                                                  Fluttertoast.showToast(msg: "Choose The Denomination Details");
                                                                }else{
                                                                alterpayment =
                                                                'Others';
                                                                paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                                DelReceiveAmount.text = "";
                                                                Edt_Balance.text = "";
                                                                Edt_PayRemarks.text = "";
                                                                alterpayment = "Select";
                                                                getvalue = 0;
                                                                getTotalBlanceAmt("Others");
                                                                }
                                                              });
                                                            },
                                                            child: Text('Others', style: TextStyle(color: Colors.white),
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
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: height / 2,
                                                width: double.infinity,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: paymenttemplist.length == 0
                                                            ? Center(child: Text('No Data Add!'),)
                                                            : DataTable(
                                                                sortColumnIndex:0,
                                                                sortAscending:true,
                                                                columnSpacing: 30,
                                                                dataRowHeight: 60,
                                                                headingRowColor:MaterialStateProperty.all(Colors.blue),
                                                                showCheckboxColumn:false,
                                                                columns: <DataColumn>[
                                                                  DataColumn(
                                                                    label: Text('Remove', style: TextStyle(color: Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Type', style: TextStyle(color: Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Bill Amount', style: TextStyle(color: Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Received Amount',style: TextStyle(color: Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Balance Amount', style: TextStyle(color: Colors.white),),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text('Remarks', style: TextStyle(color: Colors.white),),
                                                                  ),
                                                                ],
                                                                rows: paymenttemplist.map((list) =>
                                                                              DataRow(cells: [
                                                                                DataCell(
                                                                                  IconButton(
                                                                                    icon: Icon(Icons.cancel),
                                                                                    color: Colors.red,
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        if (list.status == 0) {
                                                                                          paymenttemplist.remove(list);
                                                                                          getTotalBlanceAmt("Deleted");
                                                                                          Fluttertoast.showToast(msg: "Deleted Row");
                                                                                        } else {}
                                                                                    //  count();
                                                                                  });
                                                                                      },
                                                                                  ),
                                                                                ),
                                                                                DataCell(
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(top: 5),
                                                                                      child: Text("${list.PaymentName}", textAlign: TextAlign.left),), onTap: () {
                                                                                      print(list.status);
                                                                                    }),
                                                                                DataCell(
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [Text(list.BillAmount.toString(), textAlign: TextAlign.center)]),
                                                                                ),
                                                                                DataCell(
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [Text(list.ReceivedAmount.toString(), textAlign: TextAlign.center,)]),
                                                                                ),
                                                                                DataCell(
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [Text(list.BalAmount.toString(), textAlign: TextAlign.center)]),
                                                                                ),
                                                                                DataCell(
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [Text(list.PaymentRemarks, textAlign: TextAlign.center)]),
                                                                                ),
                                                                              ]),
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Loyalty Points', style: TextStyle(fontWeight: FontWeight.bold),)
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
                                                            height: 50,
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
                                                            height: 50,
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
                                                            height: 50,
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
                                                            height: 50,
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
                                                            height: 50,
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
                                                            height: 50,
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
                                                            height: 50,
                                                            child: Checkbox(
                                                                value:careofcheckboxValue,
                                                                activeColor:Colors.blue,
                                                                onChanged: (bool newValue) {
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
                                                            height: 50,
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
                                                            height: 50,
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
                                            Visibility(
                                              visible: OredersStatus=='Ds'||OredersStatus=='Re'?false:true,
                                              child: ElevatedButton(
                                                child: Text(
                                                  "Savee",
                                                ),
                                                onPressed: () {
                                                  settlementisclicked = 1;
                                                  if (altersalespersoncode.isEmpty) {
                                                    Fluttertoast.showToast(msg:"Please Choose Sales Person");
                                                  } else if (settlementisclicked == 1 && paymenttemplist.length == 0) {
                                                    Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                                  }
                                                  else {
                                                    print("save");
                                                    TransactionID='C';
                                                    insertSalesHeader(
                                                      int.parse(HoldDocLine.toString(),),
                                                      formatter.format(DateTime.now()),
                                                      Edt_Mobile.text,
                                                      DelDateController.text,
                                                      alterocccode,
                                                      alteroccname,
                                                      OccDateController.text,
                                                      Edt_Message.text,
                                                      altersalespersoncode.toString(),
                                                      altersalespersoname,
                                                      checkedValue == true? "Y": "N",
                                                      Edt_CustCharge.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                                                      Edt_Advance.text.isEmpty ? 0 : double.parse(Edt_Advance.text),
                                                      alterstatecode,
                                                      alterstateName,
                                                      alterdistrictcode,
                                                      alterdistrictName,
                                                      alterdeliveryplacecode,
                                                      alterdeliveryplaceName,
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
                                                    Fluttertoast.showToast(msg: "Ok");
                                                  }
                                                },
                                              ),
                                            ),
                                            Visibility(
                                              visible: OredersStatus=='Ds'||OredersStatus=='Re'?true:false,
                                              child: ElevatedButton(
                                                child: Text(
                                                  "Delivery And Print",
                                                ),
                                                style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                onPressed: () {
                                                  settlementisclicked = 1;
                                                  if (altersalespersoncode.isEmpty) {
                                                    Fluttertoast.showToast(msg:"Please Choose Sales Person");
                                                  } else if (settlementisclicked == 1 && paymenttemplist.length == 0) {
                                                    Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                                  }else if (OredersStatus== 'Ds') {
                                                    Fluttertoast.showToast(msg:"Kindkly Recevie The Orders");
                                                  }
                                                  else {
                                                    print("save");
                                                    TransactionID='CO';
                                                    insertSalesHeader(
                                                        int.parse(HoldDocLine.toString(),),
                                                        formatter.format(DateTime.now()),
                                                        Edt_Mobile.text,
                                                        DelDateController.text,
                                                        alterocccode,
                                                        alteroccname,
                                                        OccDateController.text,
                                                        Edt_Message.text,
                                                        altersalespersoncode.toString(),
                                                        altersalespersoname,
                                                        checkedValue == true? "Y": "N",
                                                        Edt_CustCharge.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                                                        Edt_Advance.text.isEmpty ? 0 : double.parse(Edt_Advance.text),
                                                        alterstatecode,
                                                        alterstateName,
                                                        alterdistrictcode,
                                                        alterdistrictName,
                                                        alterdeliveryplacecode,
                                                        alterdeliveryplaceName,
                                                        Edt_Delcharge.text.isEmpty ? 0 : double.parse(Edt_Delcharge.text),
                                                        batchcount,
                                                        Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                                                        Edt_Tax.text.isEmpty ? 0 : double.parse(Edt_Tax.text),
                                                        Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_CustCharge.text),
                                                        Edt_Balance.text.isEmpty ? 0 : double.parse(Edt_Balance.text),
                                                        Edt_Total.text.isEmpty ? 0 : double.parse(Edt_Total.text),
                                                        'CO',
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
                                                    Fluttertoast.showToast(msg: "Ok");
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
                                                    getdetailitems(categoryitem.result[cat].code.toString().isEmpty ? 0 : categoryitem.result[cat].code.toString(), onclick);
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
                                                          count=int.parse(templist[i].ComboNo.toString()) ;
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
                                                                  count+1,
                                                                  tablet,
                                                                  height,
                                                                  width));
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
                                                          itemodel.result[cat].TaxCode,0
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
                        Container(
                          padding:EdgeInsets.only(left: 5, right: 5, top: 2),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                            children: [
                              Row(
                                children: [
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height / 10,
                                        color: Colors.white,
                                        child: TextField(
                                          controller: Edt_Mobile,
                                          style: TextStyle(fontSize: height/30),
                                          decoration: InputDecoration(
                                            labelText: "Customer No",
                                            border: OutlineInputBorder(),
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
                                    child: InkWell(
                                      onTap: () {
                                        if (SaleFrezeMode == true) {
                                        } else {
                                          _selectDate(context);
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height / 12,
                                        color: Colors.white,
                                        child: TextField(
                                          enabled: false,
                                          style: TextStyle(fontSize: height/30),
                                          controller: DelDateController,
                                          decoration: InputDecoration(
                                            labelText: "Delivery Date",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Row(
                                children: [
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height / 12,
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: occ,
                                          label: "Choose Occation",
                                          onChanged: (val) {
                                            setState(() {
                                              for (int kk = 0;kk <RawOccNameMaster.testdata.length;kk++) {
                                                if (RawOccNameMaster.testdata[kk].occName ==val) {
                                                  print(RawOccNameMaster.testdata[kk].occCode);
                                                  alterocccode =RawOccNameMaster.testdata[kk].occCode.toString();
                                                  alteroccname =RawOccNameMaster.testdata[kk].occName.toString();
                                                }
                                              }
                                            });
                                          },
                                          selectedItem: alteroccname,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () {
                                        if (SaleFrezeMode == true) {
                                        } else {
                                          _selectDate1(context);
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height / 12,
                                        color: Colors.white,
                                        child: TextField(
                                          enabled: false,
                                          style: TextStyle(fontSize: height/30),
                                          controller: OccDateController,
                                          decoration: InputDecoration(
                                            labelText: "Occution Date",
                                            border: OutlineInputBorder(),
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
                                    flex: 1,
                                    child: InkWell(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height / 7,
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: TextField(
                                          controller: Edt_Message,
                                          style: TextStyle(fontSize: height/30),
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                            labelText: "Message",
                                            border: OutlineInputBorder(),
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
                                    child: InkWell(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height / 12,
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: Shap,
                                          label: "Choose Shape",
                                          onChanged: (val) {
                                            for (int kk = 0;kk <RawShapeNameMaster.testdata.length; kk++) {
                                              if (RawShapeNameMaster.testdata[kk].occName ==val) {
                                                print(RawShapeNameMaster.testdata[kk].occCode);
                                                alterShaCode =RawShapeNameMaster.testdata[kk].occCode.toString();
                                                alterShaName =RawShapeNameMaster.testdata[kk].occName;
                                              }
                                            }
                                          },
                                          selectedItem: alterShaName,
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
                                      height: MediaQuery.of(context).size.height / 12,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Sales Person",
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: TextEditingController(text: altersalespersoname),
                                        readOnly: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  print(checkedValue);
                                  if (checkedValue == true) {
                                    delstatelayout = true;
                                    delstateplace = true;
                                    delstateremarks = true;
                                  } else {
                                    delstatelayout = false;
                                    delstateplace = false;
                                    delstateremarks = false;
                                  }
                                },
                                child: SizedBox(
                                  width: 300,
                                  child: CheckboxListTile(
                                    title:
                                    Text("Do You Want Door Delivery?",style: TextStyle(fontSize: height/30),),
                                    activeColor: Colors.blue,
                                    checkColor: Colors.green,
                                    selected: checkedValue,
                                    value: checkedValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        checkedValue = value;
                                        print(checkedValue);
                                        if (checkedValue == true) {
                                          delstatelayout = true;
                                          delstateplace = true;
                                          delstateremarks = true;
                                        } else {
                                          delstatelayout = false;
                                          delstateplace = false;
                                          delstateremarks = false;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: delstatelayout,
                                child: Row(
                                  children: [
                                    new Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.BOTTOM_SHEET,
                                            showSearchBox: true,
                                            items: countrylist,
                                            label: "Delivery Country",
                                            onChanged: (val) {
                                              for (int kk = 0;kk <countryModell.result.length;kk++) {
                                                if (countryModell.result[kk].name ==val) {
                                                  print(countryModell.result[kk].code);
                                                  alterstatecode =countryModell.result[kk].code.toString();
                                                  alterstateName =countryModell.result[kk].name.toString();
                                                }
                                              }
                                            },
                                            selectedItem: alteroccname,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    new Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.BOTTOM_SHEET,
                                            showSearchBox: true,
                                            items: district,
                                            label: "Delivery State",
                                            onChanged: (val) {
                                              for (int kk = 0;kk <districtModel.result.length;kk++) {
                                                if (districtModel.result[kk].name ==val) {
                                                  print(districtModel.result[kk].code);
                                                  alterstatecode =districtModel.result[kk].code;
                                                }
                                              }
                                            },
                                            selectedItem: alteroccname,
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
                              Visibility(
                                visible: delstateplace,
                                child: Row(
                                  children: [
                                    new Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.BOTTOM_SHEET,
                                            showSearchBox: true,
                                            label: "Delivery Place",
                                            items: placelist,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    new Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: TextField(
                                            controller: Edt_Delcharge,
                                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                            keyboardType:TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: "Delivery Charge",
                                              border: OutlineInputBorder(),
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
                              Visibility(
                                visible: delstateremarks,
                                child: Row(
                                  children: [
                                    new Expanded(
                                      flex: 5,
                                      child: InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: TextField(
                                            maxLength: 200,
                                            decoration: InputDecoration(
                                              labelText: "Remarks",
                                              border: OutlineInputBorder(),
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
                              Container(
                                height: MediaQuery.of(context).size.height / 12,
                                child: ElevatedButton(
                                  onPressed: () {

                                    if(DelDateController.text==''){
                                      Fluttertoast.showToast(msg: 'Select The Delivery Date..');
                                    }
                                    else if(alterocccode=='' && alteroccname==''){
                                      Fluttertoast.showToast(msg: 'Choose Occation..');
                                    }
                                    else if(OccDateController.text==''){
                                      Fluttertoast.showToast(msg: 'Select The Occation Date..');
                                    }

                                    else{
                                      Fluttertoast.showToast(msg: 'Settlement Page..');
                                      pagecontroller.jumpToPage(2);
                                    }
                                  },
                                  child: Text('Next'),
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
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    SizedBox(width: 5,),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: height/12,
                                        child: TextField(style: TextStyle(fontSize: height/30), onChanged: (val) {
                                          setState(() {
                                            try {
                                              double remaining =
                                              DelReceiveAmount.text.isEmpty ? 0: (double.parse(DelReceiveAmount.text) - double.parse(Edt_Total.text));
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
                                          readOnly:true,
                                          decoration: InputDecoration(
                                              suffixIconConstraints: BoxConstraints(minHeight: 30,minWidth: 30),
                                              suffixIcon: Icon(Icons.cancel, size: height/25, color: Colors.grey,),
                                              border: OutlineInputBorder()), onTap: () {
                                                DelReceiveAmount.text = "0.00";
                                                getvalue = 0;
                                            },
                                      ),
                                    ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: height/12,
                                      child: TextField(
                                        style: TextStyle(fontSize: height/30),
                                        enabled: false,
                                        controller: Edt_Total,
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number,
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
                                        height: height / 12,
                                        child: TextField(
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        controller: Edt_Balance,
                                        decoration: InputDecoration(
                                            labelText: "Balance Amount",
                                            border: OutlineInputBorder(),
                                            fillColor: Colors.blue),
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: height/30),
                                      ),
                                    ),
                                  ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: height / 12,
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
                                    SizedBox(width: 5,),
                                ],
                              ),
                                SizedBox(height: 5,),
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
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
                                                margin: EdgeInsets.only(top: 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                      onPressed: () {
                                                        setState(() {
                                                          alterpayment = 'Cash';
                                                          paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                          DelReceiveAmount.text = "";
                                                          Edt_Balance.text = "";
                                                          Edt_PayRemarks.text = "";
                                                          alterpayment = "Select";
                                                          getvalue = 0;
                                                          getTotalBlanceAmt("Cash");
                                                        });
                                                      },
                                                      child: Text('Cash', style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                      onPressed: () {
                                                        setState(() {
                                                          alterpayment = 'Card';
                                                          paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                          DelReceiveAmount.text = "";
                                                          Edt_Balance.text = "";
                                                          Edt_PayRemarks.text = "";
                                                          alterpayment = "Select";
                                                          getvalue = 0;
                                                          getTotalBlanceAmt("Card");
                                                        });
                                                      },
                                                      child: Text('Card', style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                      onPressed: () {
                                                        setState(() {
                                                          alterpayment = 'UPI';
                                                          paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                          DelReceiveAmount.text = "";
                                                          Edt_Balance.text = "";
                                                          Edt_PayRemarks.text = "";
                                                          alterpayment = "Select";
                                                          getvalue = 0;
                                                          getTotalBlanceAmt("UPI");
                                                        });
                                                      },
                                                      child: Text('UPI', style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                                                      onPressed: () {
                                                        setState(() {
                                                          alterpayment = 'Others';
                                                          paymenttemplist.add(SalesPayment(alterpayment, DelReceiveAmount.text, Edt_Total.text, Edt_Balance.text, Edt_PayRemarks.text, 0));
                                                          DelReceiveAmount.text = "";
                                                          Edt_Balance.text = "";
                                                          Edt_PayRemarks.text = "";
                                                          alterpayment = "Select";
                                                          getvalue = 0;
                                                          getTotalBlanceAmt("Others");
                                                        });
                                                      },
                                                      child: Text('Others', style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: height / 2,
                                          width: double.infinity,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: paymenttemplist.length == 0
                                                  ? Center(
                                                      child: Text('No Data Add!'),)
                                                  : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    columnSpacing: width/35,
                                                    dataRowHeight: height/10,
                                                    headingRowHeight: height/20,
                                                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                    showCheckboxColumn: false,
                                                    columns: <DataColumn>[
                                                    DataColumn(label: Text('Remove', style: TextStyle(color: Colors.white),),),
                                                    DataColumn(label: Text('Type', style: TextStyle(color: Colors.white),),),
                                                    DataColumn(label: Text('Bill Amt', style: TextStyle(color: Colors.white),),),
                                                    DataColumn(label: Text('Rec Amt', style: TextStyle(color: Colors.white),),),
                                                    DataColumn(label: Text('Bal Amt', style: TextStyle(color: Colors.white),
                                                          ),
                                                      ),],
                                                    rows:paymenttemplist.map((list) =>
                                                      DataRow(
                                                          cells: [
                                                            DataCell(
                                                              IconButton(
                                                                icon: Icon(Icons.cancel,size: height/25,),
                                                                color: Colors.red,
                                                                onPressed: () {
                                                                  print("Pressed");
                                                                  setState(() {
                                                                    if (list.status == 0) {
                                                                      paymenttemplist.remove(list);
                                                                      getTotalBlanceAmt("Deleted");
                                                                      Fluttertoast.showToast(msg: "Deleted Row");
                                                                    } else {}
                                                                    //  count();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            DataCell(Text("${list.PaymentName}", textAlign: TextAlign.left,style: TextStyle(fontSize: height/33,),), onTap: () {
                                                              print(list.status);
                                                            }),
                                                            DataCell(
                                                              Text(list.BillAmount.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: height/33,),),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                list.ReceivedAmount.toString(),
                                                                textAlign: TextAlign.center,style: TextStyle(fontSize: height/33,),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(list.BalAmount.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: height/33,),),
                                                            ),
                                                          ]),).toList(),
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
                                          Text(
                                            'Loyalty Points',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold),
                                          )
                                        ],
                                      ),
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
                                                          value:loyalcheckboxValue,
                                                          activeColor:Colors.blue,
                                                          onChanged: (bool
                                                          newValue) {
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
                                                          activeColor: Colors.blue,
                                                          onChanged: (bool newValue) {
                                                            setState(() {
                                                              careofcheckboxValue = newValue;
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
                                                      height: MediaQuery.of(context).size.height / 12,
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
                                                      height: MediaQuery.of(context).size.height / 12,
                                                      child: TextField(
                                                        enabled: false,
                                                        style: TextStyle(fontSize: height/30),
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
                                                        style: TextStyle(fontSize: height/30),
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
                                                        controller: Edt_BlanceBillAmt,
                                                        style: TextStyle(fontSize: height/30),
                                                        decoration: InputDecoration(
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
                                          "Save",
                                        ),
                                        onPressed: () {
                                          settlementisclicked = 1;
                                          if (altersalespersoncode.isEmpty) {
                                            Fluttertoast.showToast(msg:"Please Choose Sales Person");
                                          } else if (settlementisclicked ==1 &&paymenttemplist.length == 0) {
                                            Fluttertoast.showToast(msg:"Please Enter Payment Details");
                                          } else {
                                            print("save");
                                            insertSalesHeader(
                                              int.parse(HoldDocLine.toString(),),
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
                                            Fluttertoast.showToast(msg: "Ok");
                                          }
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
    );
  }

  MyClac(context, itemCode, itemName, itmsGrpCod, uOM, price, amount,
      itmsGrpNam, picturName, imgUrl, tax, stock, varince, taxcode,tablet,double height,double width) {
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
                          setState(() {


                          });
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
                          return RawMyHoldGetLineModel != null
                              ? Card(
                                  elevation: 10,
                                  child: ListTile(
                                    title: Text(
                                          "Order No - " + RawMyHoldGetLineModel.testdata[index].orderNo.toString() + "\n" +
                                          "Cus No -" + RawMyHoldGetLineModel.testdata[index].CustomerNo.toString() + "\n" +
                                          "Order Amt - Rs." + RawMyHoldGetLineModel.testdata[index].totAmount.toString() + "\n",
                                    ),
                                    onTap: () {
                                      setState(() {
                                        HoldDocLine = RawMyHoldGetLineModel.testdata[index].orderNo;
                                        Edt_Advance.text = RawMyHoldGetLineModel.testdata[index].screenName.toString();
                                        Edt_Balance.text = RawMyHoldGetLineModel.testdata[index].balanceDue.toString();
                                        DelReceiveAmount.text = RawMyHoldGetLineModel.testdata[index].screenName.toString();
                                        print(Edt_Advance.text);
                                        GetMyHoldLineRocordOnline();
                                        SaleFrezeMode = false;
                                      });
                                      //getPerSonalDetalisChek();
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                  ),
                                )
                              : Container();
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
          if (widget.OrderNo == 0) {
            paymenttemplist.clear();
          }else{

          }
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
                  heroTag: "Print & Settlement",
                  backgroundColor: Colors.blue,
                  icon: Icon(Icons.print),
                  label: Text('Print & Settlement'),
                  onPressed: () {
                    if (Edt_Total.text.isEmpty) {
                      showDialogboxWarning(context, "Total Should Not Left Empty!");
                    } else if (Edt_CustCharge.text.isEmpty) {
                      showDialogboxWarning(context, "Customer Charge Should Not Left Empty!");
                    } else if (Edt_Delcharge.text.isEmpty) {
                      showDialogboxWarning(context, "DelCharge Charge Should Not Left Empty!");
                    } else if (altersalespersoncode.isEmpty) {
                      showDialogboxWarning(context, "Please Choose Sales person!");
                    }
                    else if (alterdelverytime=='') {

                      _SelectDelivery(context);
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
                        pagecontroller.jumpToPage(1);
                        getoccation(int.parse(sessionuserID),int.parse(sessionbranchcode));
                        getstate(2, sessionuserID);
                        getdistrict(1, sessionuserID);
                        getplace(3, sessionuserID);
                      }

                      //print(pagecontroller.initialPage);

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
              //         pagecontroller.jumpToPage(1);
              //         getoccation(int.parse(sessionuserID),
              //             int.parse(sessionbranchcode));
              //         getstate(2, sessionuserID);
              //         getcountry(1, sessionuserID);
              //       }
              //     },
              //     child: Text('Print&Settlement')),
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
              IgnorePointer(
                ignoring: SaleFrezeMode,
                child: ElevatedButton(
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
                          Edt_BlanceBillAmt.text, int.parse(sessionbranchcode),
                          alterdelverytime
                        );
                      }
                    },
                    child: Text('Holdd')),
              ),
              SizedBox(
                width: 2,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Dis.Appr'),
              ),
              SizedBox(
                width: 2,
              ),
              ElevatedButton(
                onPressed: () {
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
                    log(jsonEncode(SMyTempTax));


                 //  log(jsonEncode(sendtemplist));
                },
                child: Text('Copy'),
              ),
              SizedBox(
                width: 2,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _SelectDelivery(context);
                  });
                },
                child: Text( alterdelverytime==''?'Time':alterdelverytime.toString()),
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
                        getoccation(int.parse(sessionuserID),int.parse(sessionbranchcode));
                        getstate(2, sessionuserID);
                        getdistrict(1, sessionuserID);
                        getplace(3, sessionuserID);
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
    double remaining = DelReceiveAmount.text.isEmpty
        ? 0
        : (double.parse(DelReceiveAmount.text) - double.parse(Edt_Total.text));
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
      GetOccName();
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
        if (widget.OrderNo == 0) {
          getcategories();
          print('FromDashBoard');
        } else {
          getcategories();
          GetMyUpdateTablRecord();
          GetMyUpdatePayMentTablRecord();
          GetMyUpdateMixBox(widget.OrderNo);
          print('FromTanctionScreen' + widget.OrderNo.toString());
        }
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
        if (widget.OrderNo == 0) {
          getcategories();
          print('FromDashBoard');
        } else {
          getcategories();
          GetMyUpdateTablRecord();
          GetMyUpdatePayMentTablRecord();
          GetMyUpdateMixBox(widget.OrderNo);
          print('FromTanctionScreen' + widget.OrderNo.toString());
        }
      });


    }
  }

  Future<http.Response> GetMyUpdateTablRecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FromId": 7,
      "ScreenId": 0,
      "DocNo": widget.OrderNo,
      "DocEntry": widget.OrderNo,
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
        print('NoResponse');
      } else {
        RawMySaleOrderGetLIneData == null;
        print('YesResponce from Sale Oded');
        log(response.body);
        setState(() {
          templist.clear();
          RawMySaleOrderGetLIneData = MySaleOrderGetLIneData.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawMySaleOrderGetLIneData.testdata.length; i++) {
            //templist.add(value)
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
                  RawMySaleOrderGetLIneData.testdata[i].TaxCode,
                  '100'),
            );
            altersalespersoname = RawMySaleOrderGetLIneData.testdata[i].FirstName;
            altersalespersoncode = RawMySaleOrderGetLIneData.testdata[i].EmpId.toString();
            Edt_Tax.text = RawMySaleOrderGetLIneData.testdata[i].Totltaxamt.toString();
            Edt_Total.text = RawMySaleOrderGetLIneData.testdata[i].totalamt.toString();
            Edt_Advance.text = widget.ScreenID.toString();
            Edt_Balance.text = (double.parse(Edt_Total.text) - double.parse(Edt_Advance.text)).toString();
            OccDateController.text = widget.OrderDate.toString();
            DelDateController.text = widget.DeliveryDate.toString();
            Edt_Mobile.text = RawMySaleOrderGetLIneData.testdata[i].CustomerNo.toString();
            Edt_Disc.text = RawMySaleOrderGetLIneData.testdata[i].ApprovedDiscount.toString();
            Edt_CustCharge.text = RawMySaleOrderGetLIneData.testdata[i].CustCharge.toString();
            Edt_Delcharge.text = RawMySaleOrderGetLIneData.testdata[i].DelCharge.toString();
            alterocccode = RawMySaleOrderGetLIneData.testdata[i].OccCode.toString();
            alteroccname = RawMySaleOrderGetLIneData.testdata[i].OccName.toString();
            Edt_Message.text = RawMySaleOrderGetLIneData.testdata[i].Message.toString();
            Edt_BlanceBillAmt.text = RawMySaleOrderGetLIneData.testdata[i].BlanceAmt.toString();
            alterShaCode =  RawMySaleOrderGetLIneData.testdata[i].ShaCode.toString();
            alterShaName =  RawMySaleOrderGetLIneData.testdata[i].ShaName.toString();
            alterdelverytime = RawMySaleOrderGetLIneData.testdata[i].DeliveryTime.toString();
            OredersStatus = RawMySaleOrderGetLIneData.testdata[i].orderstatus.toString();
            count();
            loading = false;
            SaleFrezeMode = true;
          }
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetMyUpdateMixBox(int orderNo) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      RawMixboxmodel=null;
      TepmSaveMixBoxMaster.clear();
    });
    var body = {
      "FromId": 22,
      "ScreenId": 0,
      "DocNo": orderNo,
      "DocEntry": orderNo,
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
        print('NoResponse');
      } else {
        RawMySaleOrderGetLIneData == null;
        print('YesResponce from Mix Box');
        log(response.body);
        setState(() {
          RawMixboxmodel = Mixboxmodel.fromJson(jsonDecode(response.body));

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
      "FromId": 10,
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
        print('Selva-PayMent + YesResponce');
        print(response.body);
        setState(() {
          paymenttemplist.clear();
          RawMySaleOrderGetPaymentData = MySaleOrderGetPaymentData.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawMySaleOrderGetPaymentData.testdata.length; i++)
            paymenttemplist.add(
              SalesPayment(
                  RawMySaleOrderGetPaymentData.testdata[i].payType,
                  RawMySaleOrderGetPaymentData.testdata[i].recvAmt.toString() + ".00".toString(),
                  RawMySaleOrderGetPaymentData.testdata[i].billAmt,
                  RawMySaleOrderGetPaymentData.testdata[i].balanceAmt,
                  RawMySaleOrderGetPaymentData.testdata[i].remarks,
                  1),
            );
          HoldDocLine = widget.OrderNo;
          //count();
          getTotalBlanceAmt("PayMent");
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetOccName() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FromId": 21,
      "ScreenId": int.parse(sessionbranchcode),
      "DocNo": widget.OrderNo,
      "DocEntry": widget.OrderNo,
      "Status": "O",
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
        });
        print('NoResponse');
      } else {
        print('YesResponce OccName');
        RawOccNameMaster = OccNameMaster.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawOccNameMaster.testdata.length; i++) {
          occ.add(RawOccNameMaster.testdata[i].occName);
        }

        print(response.body);
        GetShapeName();
        setState(() {});
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetShapeName() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FromId": 21,
      "ScreenId": int.parse(sessionbranchcode),
      "DocNo": widget.OrderNo,
      "DocEntry": widget.OrderNo,
      "Status": "S",
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
        });
        print('NoResponse');
      } else {
        print('YesResponce ShapeName');
        RawShapeNameMaster = OccNameMaster.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawShapeNameMaster.testdata.length; i++) {
          Shap.add(RawShapeNameMaster.testdata[i].occName);
        }

        print(response.body);
        setState(() {});
      }
    } else {
      throw Exception('Failed to Login API');
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
              getdetailitems("0", 0);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void addfavourite(int sessionuserID, int BRANCH, String ItemCode, int FLAG,
      int Pos, int itmsGrpCod) {
    print(ItemCode);
    setState(() {
      loading = true;
    });
    AddFavourite(sessionuserID, BRANCH, ItemCode, FLAG).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print(jsonDecode(response.body));

        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() {
            /*var nodata =
                jsonDecode(response.body)['status'] == "Updated";
            if (nodata == true) {

            } else {
              itemodel.result[Pos].flag = 0;
            }*/
            print('FLAG${FLAG}');

            if (itmsGrpCod == 0) {
              itemodel.result[Pos].flag = FLAG;
            } else {
              itemodel.result[Pos].flag = FLAG;
              getdetailitems(itmsGrpCod.toString(), 0);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getdetailitems(String groupcode, int onclick) {
    print('va');
    print(groupcode);
    print(sessionbranchcode);
    print(sessionuserID);
    print(onclick);
    setState(() {
      loading = true;
    });
    

    print(sessionuserID + "-" + sessionbranchcode + "-" + groupcode);
    GetAllCategories(2, int.parse(sessionuserID), sessionbranchcode,
            onclick == 0 ? 0 : groupcode)
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

            getMixBoxoffline(int.parse(sessionuserID), int.parse(sessionbranchcode));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getMixBoxoffline(int USERID, int BRANCHID) {
    setState(() {
      loading = true;
    });
    GetAllMaster(16,USERID, BRANCHID).then((response) {
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
          //salespersonmodel.result.clear();
        } else {
          setState(() {
            log("MiXbox Master");
            log(response.body);
            RawMixBoxChild = MixBoxChild.fromJson(jsonDecode(response.body));
            loading = false;


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

  GetMyHoldRocord() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      await database.transaction((txn) async {
        List<Map> list = await txn.rawQuery(
            "select DISTINCT A.OrderNo AS OrderNo,A.OrderDate AS OrderDate,A.TotQty,A.TotAmount,A.BalanceDue,A.OrderStatus As 'Status',A.ScreenID As ScreenID,'' As ScreenName from IN_MOB_SALES_INV_HEADER A INNER JOIN IN_MOB_SALES_INV_DETAILS B ON A.OrderNo=B.HeaderDocNo");
        print(jsonEncode(list));
        // RawMyHoldGetLineModel = MyTranctionGetLineModel.fromJson(
        //     jsonDecode("{\"testdata\": ${json.encode(list)}}"));
        //
        // for (int i = 0; i < RawMyHoldGetLineModel.testdata.length; i++) {
        //   print(RawMyHoldGetLineModel.testdata[i].orderNo);
        // }
      });
    } catch (Excetion) {
      print(Excetion);
    }
  }

  Future<http.Response> GetMyHoldRecordeOnline() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      RawMyHoldGetLineModel == null;
      //SecMyPricelistMasterSubTab2Model.clear();
    });
    var body = {
      "FromId": 6,
      "ScreenId": 0,
      "DocNo": int.parse(sessionuserID),
      "DocEntry": 10,
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
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        setState(() {
          RawMyHoldGetLineModel = MyTranctionGetLineModel.fromJson(jsonDecode(response.body));

          for (int i = 0; i < RawMyHoldGetLineModel.testdata.length; i++) {
            print(RawMyHoldGetLineModel.testdata[i].orderNo);
          }
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
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
                  RawMySaleOrderGetLIneData.testdata[i].TaxCode,
                  RawMySaleOrderGetLIneData.testdata[i].ItemComboNo),
            );
            altersalespersoname = RawMySaleOrderGetLIneData.testdata[i].FirstName;
            altersalespersoncode = RawMySaleOrderGetLIneData.testdata[i].EmpId.toString();
            Edt_Tax.text = RawMySaleOrderGetLIneData.testdata[i].Totltaxamt.toString();
            Edt_Total.text = RawMySaleOrderGetLIneData.testdata[i].totalamt.toString();
            Edt_Disc.text = RawMySaleOrderGetLIneData.testdata[i].ApprovedDiscount.toString();
            Edt_Mobile.text = RawMySaleOrderGetLIneData.testdata[i].CustomerNo.toString();
            Edt_CustCharge.text = RawMySaleOrderGetLIneData.testdata[i].CustCharge.toString();
            Edt_Delcharge.text = RawMySaleOrderGetLIneData.testdata[i].DelCharge.toString();

            count();
          });
        }
        setState(() {
          loading = false;
          GetMyUpdateMixBox(int.parse(HoldDocLine.toString()));
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  void insertSalesHeader(int OrderNo,String OrderDate,String CustomerNo,String DelDate,String OccCode,String OccName,
 String OccDate,String Message,String ShapeCode,String ShapeName,String DoorDelivery,double CustCharge,double AdvanceAmount,
 String DelStateCode,String DelStateName,String DelDistCode,String DelDistName,String DelPlaceCode,String DelPlaceName,
 double DelCharge,double TotQty,double TotAmount,double TaxAmount,double ReqDiscount,double BalanceDue,double OverallAmount,
 String OrderStatus,int ApproverID,String ApproverName,double ApprovedDiscount,String ApprovedStatus,String ApprovedRemarks1,
 String ApprovedRemarks2,int ScreenID,String ScreenName,int UserID,String ShaCode,String ShaName,String BlanceAmt,int BranchId,DeliveryTime) {

InsertSalesOrder(OrderNo,OrderDate,CustomerNo,DelDate,OccCode,OccName,OccDate,Message,ShapeCode,ShapeName,DoorDelivery,
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
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'][0]['DocNo'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          HoldDocLine = jsonDecode(response.body)['result'][0]['DocNo'];
          await insertsalesdetails(jsonDecode(response.body)['result'][0]['DocNo']);
          await insertmixbox(jsonDecode(response.body)['result'][0]['DocNo']);
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }


  Future<http.Response> insertmixbox(int headerdocno) async {
    print('Mix Box Master');
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
      sendMixBoxMaster.clear();
    });
    print('Mix Box Master');
    print(TepmSaveMixBoxMaster.length);
    for (int i = 0; i < TepmSaveMixBoxMaster.length; i++)
      sendMixBoxMaster.add(
        SendMixBoxMaster(
            TepmSaveMixBoxMaster[i].refItemCode,
            TepmSaveMixBoxMaster[i].itemCode,
            TepmSaveMixBoxMaster[i].itemName,
            TepmSaveMixBoxMaster[i].qty,
            TepmSaveMixBoxMaster[i].ActualQty,
            TepmSaveMixBoxMaster[i].Uom,
            TepmSaveMixBoxMaster[i].ComboNo,
            headerdocno.toString(),
            headerdocno.toString(),
            headerdocno.toString())
      );
    log(jsonEncode(sendMixBoxMaster));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertSalesMixbox'),
        body: jsonEncode(sendMixBoxMaster),
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
          loading=false;
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
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
        Uri.parse(AppConstants.LIVE_URL + 'insertSalesDetail1'),
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
            Navigator.pushReplacement(
              this.context,
              MaterialPageRoute(
                builder: (context) => SalesOrder(
                    ScreenID: widget.ScreenID,
                    ScreenName: widget.ScreenName,
                    OrderNo: 0,
                    OrderDate: "",
                    DeliveryDate: ""),
              ),
            );
          } else {
            print('ENTER THIRD$settlementisclicked');
            insertsalesdetailspayment(headerdocno);
          }
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> insertsalesdetailspayment(int headerdocno) async {
    print('insertsalesdetailspayment THIRD$settlementisclicked');
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
    });

    for (int i = 0; i < paymenttemplist.length; i++) {
      if (paymenttemplist[i].status == 0) {
        sendpaymenttemplist.add(SalesSendPayment(
            headerdocno,
            0,
            paymenttemplist[i].PaymentName,
            paymenttemplist[i].ReceivedAmount,
            paymenttemplist[i].BillAmount,
            paymenttemplist[i].BalAmount,
            paymenttemplist[i].PaymentRemarks,
            TransactionID,
            'C',
            widget.ScreenID,
            widget.ScreenName,
            '${sessionuserID}'));
        print("PayName" + paymenttemplist[i].PaymentName);
      }
      print("PayName1" +
          paymenttemplist[i].PaymentName +
          paymenttemplist[i].status.toString());
    }

    print("PayMent" + jsonEncode(sendpaymenttemplist));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertSalesPayment'),
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
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);


        setState(() {
          NetPrinter(sessionIPAddress, sessionIPPortNo);
        });
        Navigator.pushReplacement(
          this.context,
          MaterialPageRoute(
            builder: (context) => SalesOrder(
                ScreenID: widget.ScreenID,
                ScreenName: widget.ScreenName,
                OrderNo: 0,
                OrderDate: "",
                DeliveryDate: ""),
          ),
        );
 }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future getdistrict(int formID, String UserID) {
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
        print("getstate");
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          districtModel.result.clear();
        } else {
          districtModel = StateModel.fromJson(jsonDecode(response.body));
          district.clear();
          for (int k = 0; k < districtModel.result.length; k++) {
            district.add(districtModel.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getplace(int formID, String UserID) {
    GETCOUNTRYAPI(formID, UserID).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print(response.body);
        print("getplace");
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          placeModel.result.clear();
        } else {
          placeModel = PlaceModel.fromJson(jsonDecode(response.body));
          placelist.clear();
          for (int k = 0; k < placeModel.result.length; k++) {
            placelist.add(placeModel.result[k].name);
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

  Future additem( int FormID,int docno,int catcode,
      String catname,String itemCode,String itemName,String ItemGroupCode,String UOM,
      var Qty,double Price,double Total,int UserID,String PictureName,String PictureURL) {
    // setState(() {
    //   loading = true;
    // });
    InsertAddtoCart( FormID, docno, catcode, catname, itemCode, itemName, ItemGroupCode,
            UOM, Qty, Price, Total, sessionuserID, PictureName, PictureURL)
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
          itemodel.result.clear();
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
    List data = List();
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

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: this.context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(1),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return new Container(
            height: MediaQuery.of(this.context).size.height,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: DraftMethod(this.context,
                    MediaQuery.of(this.context).size.height - 350)),
          );
        });
  }

  void addItemToList(
      String itemCode, String itemName, int itmsGrpCod, String uOM, var price,
      var amount, var qty, String itmsGrpNam, String picturName,String imgUrl,
      var tax, var stock, var varince, TaxCode,var CompoNo) {
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
          CompoNo));
      setState(() {});
    } else {
      for (int i = 0; i < templist.length; i++) {
        if (templist[i].itemCode == itemCode &&
            templist[i].price == price &&
            templist[i].Varince == varince) {
          setState(() {
            var Qty;
            Qty = templist[i].qty += 1;
            templist[i].amount =
                Qty * double.parse(templist[i].price.toString()).round();
          });
        }
      }
    }
    count();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        selectedDate = new DateFormat("yyyy-MM-dd").format(d);
        DelDateController.text = selectedDate;
      });
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        selectedDate = new DateFormat("yyyy-MM-dd").format(d);
        OccDateController.text = selectedDate;
      });
  }

  void getTotalBlanceAmt(Status) {
    print(Status);

    double reciveAmt = 0;
    double blanceAmt = 0;
    for (int i = 0; i < paymenttemplist.length; i++) {
      reciveAmt += double.parse(paymenttemplist[i].ReceivedAmount);
    }
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
      this.ComboNo);
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

class SendMixBoxMaster {
  String refItemCode;
  String itemCode;
  String itemName;
  var qty;
  var ActualQty;
  var Uom;
  var ComboNo;
  var SqlRefNo;
  var BillNumber;
  var SaleInvNo;

  SendMixBoxMaster(this.refItemCode, this.itemCode, this.itemName, this.qty,
      this.ActualQty, this.Uom, this.ComboNo, this.SqlRefNo,this.BillNumber,this.SaleInvNo);
  Map<String, dynamic> toJson() => {
    'RefItemCode': refItemCode,
    'ItemCode': itemCode,
    'ItemName': itemName,
    'Qty': qty,
    'ActualQty': ActualQty,
    'Uom': Uom,
    'ComboNo': ComboNo,
    'SqlRefNo': SqlRefNo,
    'BillNumber': BillNumber,
    'SaleInvNo': SaleInvNo,

  };
}
