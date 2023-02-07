import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/Mixboxmodel.dart';
import 'package:bestmummybackery/Model/DocModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

List<SalesinvHeader> senduploadlist = new List();
List<SalesinvDetail> senddetailuploadlist = new List();
List<SalesinvPayment> senddetailpaymentlist = new List();
List<SalesinvMixbox> senddetailMixboxlist = new List();

SalesHeaderList headerupload;
SalesDetailList detailupload;
SalesPaymentList paymentupload;
Mixboxmodel mixboxupload;

List<String> deletelist = new List();
DocModel docModel;
var sessionName = "";
var sessionuserID = "";
var sessionbranchcode = "";
var sessionbranchname = "";
var sessiondeptcode = "";
Database database;
Timer timer;

class PostData extends StatefulWidget {
  const PostData({Key key}) : super(key: key);

  @override
  PostDataState createState() => PostDataState();
}

class PostDataState extends State<PostData> {
//  List<DocModel> docModel = new List<DocModel>();

  @override
  void initState() {

    super.initState();
    docModel = new DocModel();
    getStringValuesSF();
  }

  /*Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  static Future<void> checkForNewSharedLists() async {
    print('OKConnected');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sessionuserID = prefs.getString('UserID');
    sessionName = prefs.getString('FirstName');
    sessiondeptcode = prefs.getString('DeptCode');
    sessionbranchcode = prefs.getString('BranchCode');
    sessionbranchname = prefs.getString('BranchName');
    // prefs.setInt("DocNo", 1);
    await insertsalesinvheader();
    //await insertKOTinvheader();
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      //int lastdocno = prefs.getInt("DocNo");
      insertsalesinvheader();

    });
  }
}

Future<http.Response> insertsalesinvheader() async {
  var headers = {"Content-Type": "application/json"};
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bestmummy.db');
  database = await openDatabase(path, version: 1);

  List<Map> list = await database.rawQuery("SELECT * FROM IN_MOB_SALES_INV_HEADER where Sync=0 and OrderStatus='C'");

  //print(json.encode(list));

  if (list.length == 0) {
  } else {
    headerupload = SalesHeaderList.fromJson(jsonDecode(json.encode(list)));
    senduploadlist.clear();
    deletelist.clear();
    for (int i = 0; i <headerupload.details.length; i++) {
      senduploadlist.clear();
      print('Length ${headerupload.details[i].BillNo}');
      senduploadlist.add(
        SalesinvHeader(
          0,
          headerupload.details[i].orderDate.toString(),
          headerupload.details[i].customerNo,
          headerupload.details[i].DelDate,
          headerupload.details[i].occCode,
          headerupload.details[i].occName,
          headerupload.details[i].occDate,
          headerupload.details[i].message,
          headerupload.details[i].shapeCode,
          headerupload.details[i].shapeName,
          headerupload.details[i].doorDelivery,
          headerupload.details[i].custCharge,
          headerupload.details[i].advanceAmount,
          headerupload.details[i].delStateCode,
          headerupload.details[i].delStateName,
          headerupload.details[i].delDistCode,
          headerupload.details[i].delDistName,
          headerupload.details[i].delPlaceCode,
          headerupload.details[i].delPlaceName,
          headerupload.details[i].delCharge,
          headerupload.details[i].totQty,
          headerupload.details[i].totAmount,
          headerupload.details[i].taxAmount,
          headerupload.details[i].reqDiscount,
          headerupload.details[i].balanceDue,
          headerupload.details[i].overallAmount,
          headerupload.details[i].orderStatus,
          headerupload.details[i].approverID,
          headerupload.details[i].approverName,
          headerupload.details[i].approvedDiscount,
          headerupload.details[i].approvedStatus,
          headerupload.details[i].approvedRemarks1,
          headerupload.details[i].approvedRemarks2,
          headerupload.details[i].screenID,
          headerupload.details[i].screenName,
          int.parse(sessionuserID),
          headerupload.details[i].orderNo,
          "Post From Mobile",
          int.parse(sessionbranchcode),
          headerupload.details[i].BillNo,
          headerupload.details[i].BlanceAmt,
          headerupload.details[i].ShiftId,
        ),
      );
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'offinsertSalesinvHeader'),
          body: jsonEncode(senduploadlist),
          headers: headers);
      if (response.statusCode == 200) {
        //print(jsonDecode(response.body)["status"]);
        if (jsonDecode(response.body)["status"] == 0) {
          print('Nodatat');
          dbclear();
        } else {
          log(response.body);
            docModel = DocModel.fromJson(jsonDecode(response.body));
           for(int i = 0 ; i< docModel.result.length;i++){
             deletelist.add(docModel.result[0].sqliteRefNo.toString());
          }
           if(docModel.result[0].sqliteRefNo==0){
             print("Header IF");
              dbclearalreadyexists('${docModel.result[0].Refno.toString()}');
           }else{
             print("Header ELSE SALEDETALIES");
             insertsalesinvdetails(docModel.result[0].orderNo, docModel.result[0].sqliteRefNo);
           }

        }
        print("FroLoob1");
      } else {
        throw Exception('Failed to Login API');
      }
      print("FroLoob");
    }

  }
}

Future<List> dbclearalreadyexists(String OrderNo) async {
  print("DB CLEAR alredy exists");
  try {
    await database.transaction((txn) async {
     // for (int i = 0; i < deletelist.length; i++) {
        //print('delete doc no ${deletelist[i]}');
        await txn.rawDelete("DELETE FROM IN_MOB_SALES_INV_HEADER where OrderNo in('${OrderNo}')");
        await txn.rawDelete("DELETE FROM IN_MOB_SALES_INV_DETAILS where HeaderDocNo in('${OrderNo}')");
        await txn.rawUpdate("DELETE FROM IN_MOB_SALES_INV_PAYMENT where HeaderDocNo in('${OrderNo}')");
        await txn.rawUpdate("DELETE FROM IN_MOB_SALES_INV_MIXMASTER where SqlRefNo in('${OrderNo}')");
      //}
    });
  } catch (e) {
    e.toString();
  }
  await database.close();
}

Future<List> dbclear() async {
  print("DB CLEAR");
  try {
    await database.transaction((txn) async {
      for (int i = 0; i < deletelist.length; i++) {
        print('delete doc no ${deletelist[i]}');
        await txn.rawDelete("DELETE FROM IN_MOB_SALES_INV_HEADER where OrderNo in('${deletelist[i]}')");
        await txn.rawDelete("DELETE FROM IN_MOB_SALES_INV_DETAILS where HeaderDocNo in('${deletelist[i]}')");
        await txn.rawUpdate("DELETE FROM IN_MOB_SALES_INV_PAYMENT where HeaderDocNo in('${deletelist[i]}')");
        await txn.rawUpdate("DELETE FROM IN_MOB_SALES_INV_MIXMASTER where SqlRefNo in('${deletelist[i]}')");
      }
    });
  } catch (e) {
    e.toString();
  }
  await database.close();
}

Future<http.Response> insertsalesinvdetails(int headerdocno, int RefNo) async {

  log("insertsalesinvdetails");
  var headers = {"Content-Type": "application/json"};
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'bestmummy.db');
  Database database = await openDatabase(path, version: 1);

  List<Map> list1 = await database.rawQuery("SELECT * FROM IN_MOB_SALES_INV_DETAILS where Sync=0 and Status='C' and HeaderDocNo in(${docModel.result[0].sqliteRefNo})");
                                      //print("SELECT * FROM IN_MOB_SALES_INV_DETAILS where Sync=0 and Status='C' and HeaderDocNo in('${docModel.result[0].sqliteRefNo.toString()}')");

  detailupload = SalesDetailList.fromJson(jsonDecode(json.encode(list1)));
  senddetailuploadlist.clear();
  for (int j = 0; j < detailupload.details.length; j++) {
    if (detailupload.details.length > 0) {
      senddetailuploadlist.add(
          SalesinvDetail(
          headerdocno,
          detailupload.details[j].categoryCode,
          detailupload.details[j].categoryName,
          detailupload.details[j].itemCode,
          detailupload.details[j].itemName,
          detailupload.details[j].itemGroupCode,
          detailupload.details[j].uom,
          detailupload.details[j].qty,
          detailupload.details[j].price,
          detailupload.details[j].total,
          detailupload.details[j].screenID,
          detailupload.details[j].screenName.toString(),
          detailupload.details[j].status,
          detailupload.details[j].pictureName,
          detailupload.details[j].pictureURL,
          int.parse(sessionuserID),
          detailupload.details[j].lineID,
          RefNo,
          "Post From Mobile",
          detailupload.details[j].Tax
          // int.parse("564"),
          ));
    }
  }
  final response = await http.post(
      Uri.parse(AppConstants.LIVE_URL + 'offinsertSalesinvDetails'),
      body: jsonEncode(senddetailuploadlist),
      headers: headers);
  if (response.statusCode == 200) {
    print(jsonDecode(response.body)["status"]);
    if (jsonDecode(response.body)["status"] == 0) {
      print('Nodatat');
    } else {
      docModel = DocModel.fromJson(jsonDecode(response.body));
      List<Map> list1 = await database.rawQuery("SELECT * FROM IN_MOB_SALES_INV_PAYMENT where Sync=0 and Status='C' and HeaderDocNo in('${docModel.result[0].sqliteRefNo.toString()}')");
      print("SELECT * FROM IN_MOB_SALES_INV_PAYMENT where Sync=0 and Status='C' and HeaderDocNo in('${docModel.result[0].sqliteRefNo.toString()}')");
      print('PAY SEND CHECK DATa');

      log(json.encode(list1));
      if (list1.length == 0) {
        print('Not go to payment');
        Fluttertoast.showToast(msg: "Not go to payment");
       // dbclear();
      } else {
        Fluttertoast.showToast(msg: "go to payment");
        print('go to payment');
        await insertsalesinvpayment(docModel.result[0].orderNo , docModel.result[0].sqliteRefNo);
      }
    }
  } else {
    throw Exception('Failed to Login API');
  }
}

Future<http.Response> insertsalesinvpayment(int Headerdocno, int RefNo) async {
  var headers = {"Content-Type": "application/json"};
  List<Map> list = await database.rawQuery("SELECT * FROM IN_MOB_SALES_INV_PAYMENT where Sync=0 and Status='C' and HeaderDocNo in('${docModel.result[0].sqliteRefNo.toString()}')");

  paymentupload = SalesPaymentList.fromJson(jsonDecode(json.encode(list)));
  print('PAY SEND DATa');

  log(json.encode(list));

  senddetailpaymentlist.clear();
  for (int k = 0; k < paymentupload.details.length; k++) {
    if (paymentupload.details.length > 0) {
      senddetailpaymentlist.add(SalesinvPayment(
          Headerdocno,
          paymentupload.details[k].lineID,
          paymentupload.details[k].type,
          paymentupload.details[k].billAmount,
          paymentupload.details[k].recvAmount,
          paymentupload.details[k].balanceAmount,
          paymentupload.details[k].remarks,
          paymentupload.details[k].transactionID,
          paymentupload.details[k].Status,
          1,
          paymentupload.details[k].screenName,
          paymentupload.details[k].createdBy,
          RefNo,
          'Post From Mobile'));
    }
  }
  final response = await http.post(
      Uri.parse(AppConstants.LIVE_URL + 'offinsertSalesinvPayment'),
      body: jsonEncode(senddetailpaymentlist),
      headers: headers);
  if (response.statusCode == 200) {
    print(jsonDecode(response.body)["status"]);
    if (jsonDecode(response.body)["status"] == 0) {
      print('Nodatat');
      dbclear();
    } else {
      log(response.body);
      print('updated Payment');
      List<Map> list2 = await database.rawQuery("SELECT * FROM IN_MOB_SALES_INV_MIXMASTER where SqlRefNo in('${docModel.result[0].sqliteRefNo}')");
      log(jsonEncode(list2));

      if (list2.length == 0) {
        print("MIXMASTER DB CLEAR");
        dbclear();
      } else {
        print('go to MIXMASTER');
        insertsalesinvmixbox(docModel.result[0].orderNo, docModel.result[0].sqliteRefNo);
      }

    }
    // return response;
  } else {
    throw Exception('Failed to Login API');
  }
}

Future<http.Response> insertsalesinvmixbox(int Headerdocno, int RefNo) async {
  print('mixbox11');
  var headers = {"Content-Type": "application/json"};
  List<Map> list = await database.rawQuery("SELECT * FROM IN_MOB_SALES_INV_MIXMASTER where  Status='C' AND SqlRefNo in('${RefNo.toString()}')");
  mixboxupload = Mixboxmodel.fromJson(jsonDecode("{\"testdata\": ${json.encode(list)}}"));

  senddetailMixboxlist.clear();
  for (int k = 0; k < mixboxupload.testdata.length; k++) {
    if (mixboxupload.testdata.length > 0) {
      senddetailMixboxlist.add(SalesinvMixbox(
          mixboxupload.testdata[k].refItemCode,
          mixboxupload.testdata[k].itemCode,
          mixboxupload.testdata[k].itemName,
          mixboxupload.testdata[k].qty,
          mixboxupload.testdata[k].actualQty,
          mixboxupload.testdata[k].uom,
          mixboxupload.testdata[k].comboNo,
          mixboxupload.testdata[k].sqlRefNo,
          mixboxupload.testdata[k].billNumber,
          Headerdocno)
      );
    }
  }
  final response = await http.post(
      Uri.parse(AppConstants.LIVE_URL + 'offinsertSalesinvMixbox'),
      body: jsonEncode(senddetailMixboxlist),
      headers: headers);
  if (response.statusCode == 200) {
    print(jsonDecode(response.body)["status"]);
    if (jsonDecode(response.body)["status"] == 0) {
      print('Nodatat');
      dbclear();
    } else {
      log(response.body);
      print('updated MixBox');
      dbclear();
    }
    // return response;
  } else {
    throw Exception('Failed to Login API');
  }
}

class SalesHeaderList {
  final List<SalesinvHeader> details;

  SalesHeaderList({
    this.details,
  });

  factory SalesHeaderList.fromJson(List<dynamic> parsedJson) {
    List<SalesinvHeader> details = new List<SalesinvHeader>();
    details = parsedJson.map((i) => SalesinvHeader.fromJson(i)).toList();

    return new SalesHeaderList(details: details);
  }
// Map<String, dynamic> toJson() {
//   final List<dynamic> data = new List();
//   // data['status'] = 1;
//   // if (this.details != null) {
//   //   data['result'] = this.details.map((v) => v.toJson()).toList();
//   // }
//   // return data;
// }
}

class SalesDetailList {
  final List<SalesinvDetail> details;

  SalesDetailList({
    this.details,
  });

  factory SalesDetailList.fromJson(List<dynamic> parsedJson) {
    List<SalesinvDetail> details = new List<SalesinvDetail>();
    details = parsedJson.map((i) => SalesinvDetail.fromJson(i)).toList();

    return new SalesDetailList(details: details);
  }
// Map<String, dynamic> toJson() {
//   final List<dynamic> data = new List();
//   // data['status'] = 1;
//   // if (this.details != null) {
//   //   data['result'] = this.details.map((v) => v.toJson()).toList();
//   // }
//   // return data;
// }
}

class SalesPaymentList {
  final List<SalesinvPayment> details;

  SalesPaymentList({
    this.details,
  });

  factory SalesPaymentList.fromJson(List<dynamic> parsedJson) {
    List<SalesinvPayment> details = new List<SalesinvPayment>();
    details = parsedJson.map((i) => SalesinvPayment.fromJson(i)).toList();

    return new SalesPaymentList(details: details);
  }
}

class SalesinvHeader {
  int orderNo;
  String orderDate;
  var customerNo;
  String DelDate;
  var occCode;
  String occName;
  String occDate;
  String message;
  String shapeCode;
  String shapeName;
  String doorDelivery;
  var custCharge;
  var advanceAmount;
  String delStateCode;
  String delStateName;
  String delDistCode;
  String delDistName;
  String delPlaceCode;
  String delPlaceName;
  var delCharge;
  var totQty;
  var totAmount;
  var taxAmount;
  var reqDiscount;
  var balanceDue;
  var overallAmount;
  String orderStatus;
  var approverID;
  String approverName;
  var approvedDiscount;
  String approvedStatus;
  String approvedRemarks1;
  String approvedRemarks2;
  int screenID;
  String screenName;
  int createdBy;
  int RefNo;
  String RefRemarks;
  int BranchID;
  var BillNo;
  var BlanceAmt;
  var ShiftId;

  SalesinvHeader(
      this.orderNo,
      this.orderDate,
      this.customerNo,
      this.DelDate,
      this.occCode,
      this.occName,
      this.occDate,
      this.message,
      this.shapeCode,
      this.shapeName,
      this.doorDelivery,
      this.custCharge,
      this.advanceAmount,
      this.delStateCode,
      this.delStateName,
      this.delDistCode,
      this.delDistName,
      this.delPlaceCode,
      this.delPlaceName,
      this.delCharge,
      this.totQty,
      this.totAmount,
      this.taxAmount,
      this.reqDiscount,
      this.balanceDue,
      this.overallAmount,
      this.orderStatus,
      this.approverID,
      this.approverName,
      this.approvedDiscount,
      this.approvedStatus,
      this.approvedRemarks1,
      this.approvedRemarks2,
      this.screenID,
      this.screenName,
      this.createdBy,
      this.RefNo,
      this.RefRemarks,
      this.BranchID,
      this.BillNo,
      this.BlanceAmt,
      this.ShiftId);

  SalesinvHeader.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    customerNo = json['CustomerNo'];
    DelDate = json['DeliveryDate'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    occDate = json['OccDate'];
    message = json['Message'];
    shapeCode = json['ShapeCode'];
    shapeName = json['ShapeName'];
    doorDelivery = json['DoorDelivery'];
    custCharge = json['CustCharge'];
    advanceAmount = json['AdvanceAmount'];
    delStateCode = json['DelStateCode'];
    delStateName = json['DelStateName'];
    delDistCode = json['DelDistCode'];
    delDistName = json['DelDistName'];
    delPlaceCode = json['DelPlaceCode'];
    delPlaceName = json['DelPlaceName'];
    delCharge = json['DelCharge'];
    totQty = json['TotQty'];
    totAmount = json['TotAmount'];
    taxAmount = json['TaxAmount'];
    reqDiscount = json['ReqDiscount'];
    balanceDue = json['BalanceDue'];
    overallAmount = json['OverallAmount'];
    orderStatus = json['OrderStatus'];
    approverID = json['ApproverID'];
    approverName = json['ApproverName'];
    approvedDiscount = json['ApprovedDiscount'];
    approvedStatus = json['ApprovedStatus'];
    approvedRemarks1 = json['ApprovedRemarks1'];
    approvedRemarks2 = json['ApprovedRemarks2'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    createdBy = json['UserID'];
    RefNo = json['RefNo'];
    RefRemarks = json['RefRemarks'];
    BranchID = json['BranchID'];
    BillNo = json['BillNo'];
    BlanceAmt = json['BlanceAmt'];
    ShiftId = json['ShiftId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['CustomerNo'] = this.customerNo;
    data['DelDate'] = this.DelDate;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['OccDate'] = this.occDate;
    data['Message'] = this.message;
    data['ShapeCode'] = this.shapeCode;
    data['ShapeName'] = this.shapeName;
    data['DoorDelivery'] = this.doorDelivery;
    data['CustCharge'] = this.custCharge;
    data['AdvanceAmount'] = this.advanceAmount;
    data['DelStateCode'] = this.delStateCode;
    data['DelStateName'] = this.delStateName;
    data['DelDistCode'] = this.delDistCode;
    data['DelDistName'] = this.delDistName;
    data['DelPlaceCode'] = this.delPlaceCode;
    data['DelPlaceName'] = this.delPlaceName;
    data['DelCharge'] = this.delCharge;
    data['TotQty'] = this.totQty;
    data['TotAmount'] = this.totAmount;
    data['TaxAmount'] = this.taxAmount;
    data['ReqDiscount'] = this.reqDiscount;
    data['BalanceDue'] = this.balanceDue;
    data['OverallAmount'] = this.overallAmount;
    data['OrderStatus'] = this.orderStatus;
    data['ApproverID'] = this.approverID;
    data['ApproverName'] = this.approverName;
    data['ApprovedDiscount'] = this.approvedDiscount;
    data['ApprovedStatus'] = this.approvedStatus;
    data['ApprovedRemarks1'] = this.approvedRemarks1;
    data['ApprovedRemarks2'] = this.approvedRemarks2;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['UserID'] = this.createdBy;
    data['RefNo'] = this.RefNo;
    data['RefRemarks'] = this.RefRemarks;
    data['BranchID'] = this.BranchID;
    data['BillNo'] = this.BillNo;
    data['BlanceAmt'] = this.BlanceAmt;
    data['ShiftId'] = this.ShiftId;
    return data;
  }
}

class SalesinvDetail {
  int headerDocNo;
  String categoryCode;
  String categoryName;
  String itemCode;
  String itemName;
  String itemGroupCode;
  String uom;
  var qty;
  var price;
  var total;
  int screenID;
  String screenName;
  String status;
  String pictureName;
  String pictureURL;
  int createdBy;
  String createdDatetime;
  String modifiedBy;
  String modifiedDatetime;
  int lineID;
  int RefNo;
  String refRemarks;
  String Tax;
  // int ModifiedBy;

  SalesinvDetail(
    this.headerDocNo,
    this.categoryCode,
    this.categoryName,
    this.itemCode,
    this.itemName,
    this.itemGroupCode,
    this.uom,
    this.qty,
    this.price,
    this.total,
    this.screenID,
    this.screenName,
    this.status,
    this.pictureName,
    this.pictureURL,
    this.createdBy,
    this.lineID,
    this.RefNo,
    this.refRemarks,
    this.Tax,
    //this.ModifiedBy
  );

  SalesinvDetail.fromJson(Map<String, dynamic> json) {
    headerDocNo = json['HeaderDocNo'];
    categoryCode = json['CategoryCode'];
    categoryName = json['CategoryName'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemGroupCode = json['ItemGroupCode'];
    uom = json['Uom'];
    qty = json['Qty'];
    price = json['Price'];
    total = json['Total'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    status = json['Status'];
    pictureName = json['PictureName'];
    pictureURL = json['PictureURL'];
    createdBy = json['UserID'];
    lineID = json['LineID'];
    Tax = json['Tax'];
    //ModifiedBy = json['ModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.headerDocNo;
    data['CatCode'] = this.categoryCode;
    data['CatName'] = this.categoryName;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemGroupCode'] = this.itemGroupCode;
    data['ItemGroupName'] = '';
    data['Uom'] = this.uom;
    data['Qty'] = this.qty;
    data['Price'] = this.price;
    data['Total'] = this.total;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['Status'] = this.status;
    data['PictureName'] = this.pictureName;
    data['PictureURL'] = this.pictureURL;
    data['UserID'] = this.createdBy;
    data['LineID'] = this.lineID;
    data['RefNo'] = this.RefNo;
    data['RefRemarks'] = this.refRemarks;
    data['Tax'] = this.Tax;
    //data['ModifiedBy'] = this.ModifiedBy;
    return data;
  }
}

class SalesinvPayment {
  int headerDocNo;
  var lineID;
  String type;
  var billAmount;
  var recvAmount;
  var balanceAmount;
  String remarks;
  String transactionID;
  String Status;
  int screenID;
  String screenName;
  var createdBy;
  var RefNo;
  String RefRemarks;

  SalesinvPayment(
      this.headerDocNo,
      this.lineID,
      this.type,
      this.billAmount,
      this.recvAmount,
      this.balanceAmount,
      this.remarks,
      this.transactionID,
      this.Status,
      this.screenID,
      this.screenName,
      this.createdBy,
      this.RefNo,
      this.RefRemarks);

  SalesinvPayment.fromJson(Map<String, dynamic> json) {
    headerDocNo = json['DocNo'];
    lineID = json['LineID'];
    type = json['Type'];
    billAmount = json['BillAmount'];
    recvAmount = json['RecvAmount'];
    balanceAmount = json['BalanceAmount'];
    remarks = json['Remarks'];
    transactionID = json['TransactionID'];
    Status = json['Status'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    createdBy = json['CreatedBy'];
    RefNo = json['HeaderDocNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.headerDocNo;
    data['LineID'] = this.lineID;
    data['TypeName'] = this.type;
    data['BillAmount'] = this.billAmount;
    data['RecvAmount'] = this.recvAmount;
    data['BalanceAmount'] = this.balanceAmount;
    data['PaymentRemarks'] = this.remarks;
    data['TransactionID'] = this.transactionID;
    data['Status'] = this.Status;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['UserID'] = this.createdBy;
    data['RefNo'] = this.RefNo;
    data['RefRemarks'] = this.RefRemarks;
    return data;
  }
}

class SalesinvMixbox {

  var RefItemCode;
  var ItemCode;
  var ItemName;
  var Qty;
  var ActualQty;
  var  Uom;
  var ComboNo;
  var SqlRefNo;
  var BillNumber;
  var SaleInvNo;


  SalesinvMixbox(
      this.RefItemCode,
      this.ItemCode,
      this.ItemName,
      this.Qty,
      this.ActualQty,
      this.Uom,
      this.ComboNo,
      this.SqlRefNo,
      this.BillNumber,
      this.SaleInvNo,);

  SalesinvMixbox.fromJson(Map<String, dynamic> json) {
    RefItemCode = json['RefItemCode'];
    ItemCode = json['ItemCode'];
    ItemName = json['ItemName'];
    Qty = json['Qty'];
    ActualQty = json['ActualQty'];
    Uom = json['Uom'];
    ComboNo = json['ComboNo'];
    SqlRefNo = json['SqlRefNo'];
    BillNumber = json['BillNumber'];
    SaleInvNo = json['SaleInvNo'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RefItemCode'] = this.RefItemCode;
    data['ItemCode'] = this.ItemCode;
    data['ItemName'] = this.ItemName;
    data['Qty'] = this.Qty;
    data['ActualQty'] = this.ActualQty;
    data['Uom'] = this.Uom;
    data['ComboNo'] = this.ComboNo;
    data['SqlRefNo'] = this.SqlRefNo;
    data['BillNumber'] = this.BillNumber;
    data['SaleInvNo'] = this.SaleInvNo;
    return data;
  }
}
