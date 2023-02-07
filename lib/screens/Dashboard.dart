// ignore_for_file: missing_return, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/Connection/NetworkPrinterList.dart';
import 'package:bestmummybackery/DespatchScreen.dart';
import 'package:bestmummybackery/Expense/ExpenseCustomer.dart';
import 'package:bestmummybackery/Masters/MastersScreen.dart';
import 'package:bestmummybackery/Masters/ShiftMasterHomePage.dart';
import 'package:bestmummybackery/PostData.dart';
import 'package:bestmummybackery/Purchase/GoodsReceipt.dart';
import 'package:bestmummybackery/Purchase/PurchaseRequest.dart';
import 'package:bestmummybackery/QRCodeGeneration.dart';
import 'package:bestmummybackery/RequestTransferScreen.dart';
import 'package:bestmummybackery/SaleIncentive.dart';
import 'package:bestmummybackery/SalesDashboard/salesdashview.dart';
import 'package:bestmummybackery/TransactionScreen.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/WastageEntry/WastageEntry.dart';
import 'package:bestmummybackery/screens/KOTHallName.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/MySyncScreen.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/screens/ProductionEntry.dart';
import 'package:bestmummybackery/screens/SalesInvoiceOffline.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:bestmummybackery/screens/TrackAsset.dart';
import 'package:bestmummybackery/screens/_CashierDashbord.dart';
import 'package:bestmummybackery/screens/_Despatchedreports.dart';
import 'package:bestmummybackery/screens/_OrderManageMent.dart';
import 'package:bestmummybackery/screens/_SalesInvoiceOnline.dart';
import 'package:bestmummybackery/screens/_SalesReturenOnline.dart';
import 'package:bestmummybackery/screens/_WastageTransferRecive.dart';
import 'package:connectivity/connectivity.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionDayDash = "";
  var sessionDayEndCheck = "";
  var loading=false;
  int NavigationChek=0;

  @override
  void initState() {
    printerManager.scanResults.listen((devices) async {
      setState(() {});
    });
    getStringValuesSF();
    timer = Timer.periodic(Duration(seconds: 25), (Timer t) {
      check().then((value) {
        if (value) {
          PostDataState.checkForNewSharedLists();
        }
      });
    });
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
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
    return !tablet
        ? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff3A9BDC),
                  Color(0xff3A9BDC)
                ],
              ),
            ),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Pallete.mycolor,
                  elevation: 0.0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dashboard',),
                    ],
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.menu),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.notifications_none),
                    )
                  ],
                ),
                body: Stack(
                  children: [
                    Container(
                      width: width / 1,
                      height: height / 2,
                      decoration: BoxDecoration(
                        color: Pallete.mycolor,
                        // image: DecorationImage(fit: BoxFit.cover),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: Image.asset(
                                    'assets/imgs/avataricon.png',
                                    height: height / 13,
                                    width: width / 25,
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Welcome Mr.$sessionName',
                                        style: TextStyle(
                                          fontSize: height / 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Branch :$sessionbranchname',
                                        style: TextStyle(
                                          fontSize: height / 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height / 8),
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(width / 30),
                          topRight: Radius.circular(width / 30),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "Menu",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xD0073E6C),
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  height: height - height / 20,
                                  child: GridView.count(
                                    childAspectRatio: 1,
                                    crossAxisCount: 4,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(9).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => MastersScreen(),),),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MastersScreen(),),),
                                            }

                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_kitchenorder.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(
                                                  height: !tablet? height/35:10,
                                                ),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Master",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(7).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftHomeMaster(),),),
                                            }

                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [

                                                Icon(
                                                  Icons.filter_tilt_shift,
                                                  color: Colors.green,
                                                  size: !tablet? height/35:30,
                                                ),
                                                SizedBox(
                                                  height: !tablet? height/35:10,
                                                ),
                                                Container(

                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Shift Master",
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(5).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => KOTHallName())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_kitchenorder.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(

                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text("Kitchen Order",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(1).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => SalesOrder(ScreenID: 1, ScreenName: "SalesOrder", OrderNo: 0,),),),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_sales.png",
                                                    fit: BoxFit.fill,
                                                height:!tablet? height/35:40,
                                                width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    padding: EdgeInsets.all(3),
                                                    width: double.infinity,
                                                    child: Text(
                                                      "Sales Order",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF002D58),
                                                          fontSize: !tablet? height/60:15),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(2).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceOffline(
                                                  ScreenID: 2, ScreenName:"Sales Invoices", OrderNo: 0, isIgnore: false),),)
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_invoice.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text("Sales Invoice",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Color(0xFF002D58),
                                                            fontSize: !tablet? height/60:15),),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(3).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReturn(ScreenID: 3, ScreenName:"Sales Return", OrderNo: 0),),)
                                            }
                                          });

                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_return.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    padding: EdgeInsets.all(3),
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Sales Return",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(6).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => WastageEntry())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_kitchenorder.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Wastage Entry",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(8).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ClosingEntry())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_closingentry.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Closing Entry",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(10).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              if(sessionbranchname=="HO" || sessionbranchname=="HEAD OFFICE"){
                                                Fluttertoast.showToast(msg: "Head Office Not permision.... "),
                                              }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => RequestTransferScreen(id: 0, DocNo: 0,),),)
                                              }

                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_stocktranfser.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(

                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Stock Transfer",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MaterialRequestMenu()));*/
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_receive.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Stock Receive",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(13).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseCustomer())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/imgs/ic_expense.png",
                                                    fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(

                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Book Expense",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(14).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => DespatchScreen())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_despatch.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Despatch",textAlign:TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print('Haill');
                                          NavigationChek=0;
                                          getScreenIdpermision(11).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => TrackAsset())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_report.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Report",
                                                        textAlign:TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xFF002D58),
                                                            fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(12).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionScreen())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_transactions.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Transactions",
                                                        textAlign:TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xFF002D58),
                                                            fontSize: !tablet? height/60:15,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {

                                          NavigationChek=0;
                                          getScreenIdpermision(15).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseRequest())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_purchase.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Pur Request",
                                                      maxLines: 2,
                                                      textAlign:TextAlign.center,
                                                      style: TextStyle(
                                                          color:Color(0xFF002D58),
                                                          fontSize: !tablet? height/60:15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(16).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => GoodsReceipt())),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_receipt.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Goods Receipt PO",
                                                      maxLines: 2,
                                                      textAlign:TextAlign.center,
                                                      style: TextStyle(
                                                          color:Color(0xFF002D58),
                                                          fontSize: !tablet? height/60:15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRCodeGeneration()));
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_qrcode.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "QR Code Generator", maxLines: 2, textAlign:TextAlign.center,
                                                      style: TextStyle(color:Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NavigationChek=0;
                                          getScreenIdpermision(18).then((value) => {
                                            if(NavigationChek==0){
                                              Fluttertoast.showToast(msg: "No Permision"),
                                            }else{
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionEntry(
                                                 // tablet:tablet

                                              )
                                              )
                                              ),
                                            }
                                          });
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_receipt.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Production Entry", maxLines: 2, textAlign:TextAlign.center,
                                                      style: TextStyle(color:Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SyncOffline(),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_qrcode.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text("Sync", maxLines: 2, textAlign:TextAlign.center,
                                                      style: TextStyle(color:Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          logoutfunction(context);
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ic_logout.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Logout",textAlign:TextAlign.center,
                                                        style: TextStyle(color: Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NetworkPrinterList(),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/printersetting.png",fit: BoxFit.fill,
                                                    height:!tablet? height/35:40,
                                                    width: !tablet? width/10:40),
                                                SizedBox(height: !tablet? height/35:10,),
                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Printer List", textAlign:TextAlign.center,
                                                        style: TextStyle(color: Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                      ),
                                                    ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if(sessionbranchcode.toString() =="8"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderManageMent(),),);
                                          }else{
                                            Fluttertoast.showToast(msg: "Your Location Not Allowed...");
                                          }
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/imgs/ordermanagement.png", fit: BoxFit.fill,height: height/18,width: width/20),

                                                Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text("Order ManageMent", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58), fontSize: 15),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: sessionDayDash=='Y' ?true:false,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SalesDashView(),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  //Image.asset("assets/imgs/printersetting.png",fit: BoxFit.fill,height: 60,width: 60),
                                                  SizedBox(height: !tablet? height/35:10,),
                                                  Container(
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "DashBoard", textAlign:TextAlign.center,
                                                        style: TextStyle(color: Color(0xFF002D58), fontSize: !tablet? height/60:15),
                                                      ),
                                                    ),
                                                  ),
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
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xff3A9BDC),
                      Color(0xff3A9BDC)
                    ]
                )
            ),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Pallete.mycolor,
                  elevation: 0.0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dashboard',
                      ),
                    ],
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.menu),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.notifications_none),
                    )
                  ],
                ),
                body: Stack(
                  children: [
                    Container(
                      width: width / 1,
                      height: height / 1,
                      decoration: BoxDecoration(
                        color: Pallete.mycolor,
                        // image: DecorationImage(fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    child: Image.asset(
                                      'assets/imgs/avataricon.png',
                                      height: height/10,
                                      width: width/20,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Welcome Mr.$sessionName',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Branch :$sessionbranchname',
                                          style: TextStyle(
                                            fontSize: height/50,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /*child: new Column(
                              children: <Widget>[
                                new Align(
                                  alignment: Alignment.topRight,
                                  child: new Text(
                                    'Welcome Mr.Admin',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height/7),
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width/27),
                              topRight: Radius.circular(width/27),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Menu",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xD0073E6C),
                                          fontSize: height/35),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      //height: 250.0,
                                      padding: EdgeInsets.all(5),
                                      height: height - height / 20,
                                      // width: width,
                                      child: GridView.count(
                                        childAspectRatio: 2,
                                        // crossAxisSpacing: width / 20,
                                        // mainAxisSpacing: height / 20,
                                        crossAxisCount: 6,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {

                                              NavigationChek=0;
                                              getScreenIdpermision(9).then((value) => {
                                               if(NavigationChek==0){
                                                 Fluttertoast.showToast(msg: "No Permision"),
                                                 //Navigator.push(context, MaterialPageRoute(builder: (context) => MastersScreen(),),),
                                               }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MastersScreen(),),),
                                               }

                                              });

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(5),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_kitchenorder.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text("Master",textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {

                                              NavigationChek=0;
                                              getScreenIdpermision(7).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftHomeMaster(),),),
                                                }

                                              });

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.filter_tilt_shift,
                                                      color: Colors.green,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Shift Master",
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {

                                              NavigationChek=0;
                                              getScreenIdpermision(5).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => KOTHallName())),
                                                }
                                              });



                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_kitchenorder.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Kitchen Order",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(1).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => SalesOrder(ScreenID: 1, ScreenName: "SalesOrder", OrderNo: 0,),),),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_sales.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Text(
                                                          "Sales Order",
                                                          textAlign:TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(0xFF002D58),
                                                              fontSize: 15),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(2).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                    SalesInvoiceOnline(ScreenID: 2,
                                                        ScreenName:"Sales Invoices",
                                                        OrderNo: 0,
                                                      isIgnore: false,
                                                      NetWorkCheckNumter: 0,
                                                    ),
                                                ),
                                                )
                                                }
                                              });

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_invoice.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Sales Invoice ",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(3).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SalesReturn(ScreenID: 3, ScreenName:"Sales Return", OrderNo: 0),),)
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_return.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text("Sales Return",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(6).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WastageEntry())),
                                                }
                                              });

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_kitchenorder.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Wastage Entry",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(8).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClosingEntry())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ic_closingentry.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Closing Entry",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Color(0xFF002D58),fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(10).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => RequestTransferScreen(id: 0, DocNo: 0,),),)
                                                }
                                              });

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_stocktranfser.png", fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Stock Transfer ",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(13).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseCustomer())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_expense.png",fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Boook Expense",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(14).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DespatchScreen())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_despatch.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Despatch",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(17).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TrackAsset())),
                                                }
                                              });

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/trackasset.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Track Asset",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if(sessionuserID.toString()=="204"){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => DespatchReports()));
                                              }else{
                                                Fluttertoast.showToast(msg: "Branch Report developing going on....");
                                              }

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_report.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Report",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Color(0xFF002D58),fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(12).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionScreen())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_transactions.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Transactions",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(15).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseRequest())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_purchase.png",
                                                  fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          "Purchase Request",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF002D58),
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(16).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => GoodsReceipt())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_receipt.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          "Goods Receipt PO",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF002D58),
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeGeneration()));
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_qrcode.png",
                                                  fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          "QR Code Generator",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF002D58),
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NavigationChek=0;
                                              getScreenIdpermision(18).then((value) => {
                                                if(NavigationChek==0){
                                                  Fluttertoast.showToast(msg: "No Permision"),
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionEntry())),
                                                }
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_receipt.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          "Production Entry",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF002D58),
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SyncOffline(),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_qrcode.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          "Sync",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF002D58),
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SaleIncentive(),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_qrcode.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      width: double.infinity,
                                                      child: Center(
                                                        child: Text(
                                                          "Sales Incentive",
                                                          maxLines: 2,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF002D58),
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              logoutfunction(context);
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/imgs/ic_logout.png",
                                                        fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Logout",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NetworkPrinterList(),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/printersetting.png", fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text("Printer List", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58), fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if(sessionbranchcode.toString() =="8"){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderManageMent(),),);
                                              }else{
                                                Fluttertoast.showToast(msg: "Your Location Not Allowed...");
                                              }
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ordermanagement.png", fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                         child: Text("Order ManageMent", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58), fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if(sessionbranchcode.toString() =="8"){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => WastageRecive(),),);
                                              }else{
                                                Fluttertoast.showToast(msg: "Your Location Not Allowed...");
                                              }
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/imgs/ordermanagement.png", fit: BoxFit.fill,height: height/18,width: width/20),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text("Wastage Recive", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58), fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            //sessionDayEndCheck=='Y' ?true:
                                            visible: sessionDayEndCheck=='Y' ?true:false,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CashierDashbord(),
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      //Image.asset("assets/imgs/printersetting.png", fit: BoxFit.fill, height: 60, width: 60),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.all(3),
                                                          width: double.infinity,
                                                          child: Center(
                                                            child: Text("Cashier", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58), fontSize: 15),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: sessionDayDash=='Y' ?true:false,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SalesDashView(),
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      //Image.asset("assets/imgs/printersetting.png", fit: BoxFit.fill, height: 60, width: 60),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.all(3),
                                                          width: double.infinity,
                                                          child: Center(
                                                            child: Text("DashBoard", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58), fontSize: 15),
                                                            ),
                                                          )),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  logoutfunction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("LoggedIn", false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false,
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
      sessionDayDash = prefs.getString('DayDash');
      sessionDayEndCheck = prefs.getString("DayEndClsg");
    });
  }


  Future <http.Response> getScreenIdpermision  ( int secreenid) async {
    setState(() {
      loading = true;
    });
    await GetAllMaster(18, int.parse(sessionuserID), secreenid)
        .then((response) {
      setState(() {
        loading = false;
      });
      log(response.body);
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          setState(() {
            NavigationChek=0;
          });
          //Fluttertoast.showToast(msg: "No Data in Roll Master");
        } else {
          setState(() {
            loading = false;
            NavigationChek =100;

          });
        }
        //return true;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

}
