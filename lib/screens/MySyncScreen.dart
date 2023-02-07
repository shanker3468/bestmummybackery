// ignore_for_file: non_constant_identifier_names, deprecated_member_use, missing_return, unnecessary_import, unnecessary_statements, unrelated_type_equality_checks
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/PriceListSyncModel.dart';
import 'package:bestmummybackery/Model/GetSyncEmpMaster.dart';
import 'package:bestmummybackery/Model/KottblMaster.dart';
import 'package:bestmummybackery/Model/MyMixMaster.dart';
import 'package:bestmummybackery/Model/MyMixMasterChild.dart';
import 'package:bestmummybackery/Model/ShiftTblMaster.dart';
import 'package:bestmummybackery/SyncModel/ItemMasterSyncModel.dart';
import 'package:bestmummybackery/SyncModel/OITBSyncModel.dart';
import 'package:bestmummybackery/SyncModel/OITGSyncModel.dart';
import 'package:bestmummybackery/SyncModel/SyncVarinceModel.dart';
import 'package:bestmummybackery/SyncModel/TCD2SyncModel.dart';
import 'package:bestmummybackery/SyncModel/TCD3SyncModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SyncOffline extends StatefulWidget {
  SyncOffline({Key key}) : super(key: key);

  @override
  SyncOfflineState createState() => SyncOfflineState();
}

class SyncOfflineState extends State<SyncOffline> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;
  bool loading = false;
  bool isSelected = false;
  String altersalespersoname = "";
  String altersalespersoncode = "";
  var BillCurrentDate;
  var BillCurrentTime;

  // MOdels
  TCD2SyncModel RawTCD2SyncModel;
  OITGSyncModel RawOITGSyncModel;
  ItemMasterSyncModel RawItemMasterSyncModel;
  SyncVarinceModel RawSyncVarinceModel;
  PriceListSyncModel RawPriceListSyncModel;
  TCD3SyncModel RawTCD3SyncModel;
  OITBSyncModel RawOITBSyncModel;
  MyMixMaster RawMyMixMaster;
  MyMixMasterChild RawMyMixMasterChild;
  KottblMaster RawKottblMaster;
  ShiftTblMaster RawShiftTblMaster;
  GetSyncEmpMaster RawGetSyncEmpMaster;
//End Models
  @override
  void initState() {
    getStringValuesSF();
    super.initState();
    BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    BillCurrentTime = DateFormat.jm().format(DateTime.now());
  }

  final pagecontroller = PageController(
    initialPage: 0,
  );
  var EditQRCode = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
          appBar: new AppBar(
            title: Text('My Sync Offiline'),
          ),
          body: loading
              ? Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  child: new Center(
                    child: image,
                  ),
                )
              : tablet
                  ? Container(
                      color: Colors.white,
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: width / 2,
                              height: height,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text(
                                                  'OITB Master',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getOITBMaster();
                                              },
                                              child: Text(
                                                'Sync OITB',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text(
                                                  'TCD2 Master',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getTCD2Master();
                                              },
                                              child: Text('Sync TCD2',),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text('TCD3 Master',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getTCD3Master();
                                              },
                                              child: Text('Sync TCD3',),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text('OITG Master',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getOTBMMaster();
                                              },
                                              child: Text('Sync OITG',),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text('Item Master',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getItemMaster();
                                              },
                                              child: Text('Sync OITM',),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text('Varince Master', style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getVarinceMaster();
                                              },
                                              child: Text('Sync Var',),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text('PriceList Master',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                              onPressed: () async {
                                                getMypricedata();
                                              },
                                              child: Text('Sync PM'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text('Mix Master',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                                  onPressed: () async {
                                                    getMyMixMater();
                                              },
                                              child: Text('Sync MM'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: width / 2,
                              height: height,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text(
                                                  'Mix Master Child',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green),
                                              onPressed: () async {
                                                //getMypricedata();
                                                getMyMixMaterChild();
                                              },
                                              child: Text('Sync MMC'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text(
                                                  'KOT Table Master',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green),
                                              onPressed: () async {
                                                //getMypricedata();
                                                //getMyMixMaterChild();
                                                getKOTtblMaster();
                                              },
                                              child: Text('Sync KOT Tbl'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text(
                                                  'Shift Table Master',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green),
                                              onPressed: () async {
                                               getShifttblMaster();
                                              },
                                              child: Text('Sync Shift Tbl'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: width / 2.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: height / 13,
                                            width: width / 4.2,
                                            child: Container(
                                              height: height / 14,
                                              width: width / 4.3,
                                              child: Card(
                                                child: Text(
                                                  'Employee  Master',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.green),
                                              onPressed: () async {
                                                getEMplMaster();
                                              },
                                              child: Text('Sync Employee Tbl'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      width: width,
                      child: Padding(
                         padding: const EdgeInsets.only(top: 10),
                            child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                        Container(
                                          width: width / 2,
                                          height: height,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'OITB Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getOITBMaster();
                                                            },
                                                            child: Text(
                                                              'Sync OITB',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'TCD2 Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getTCD2Master();
                                                            },
                                                            child: Text(
                                                              'Sync TCD2',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'TCD3 Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getTCD3Master();
                                                            },
                                                            child: Text(
                                                              'Sync TCD3',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'OITG Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getOTBMMaster();
                                                            },
                                                            child: Text(
                                                              'Sync OITG',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'Item Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getItemMaster();
                                                            },
                                                            child: Text(
                                                              'Sync OITM',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text('Varince Master', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getVarinceMaster();
                                                            },
                                                            child: Text(
                                                              'Sync Var',),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'PriceList Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                primary: Colors.green),
                                                            onPressed: () async {
                                                              getMypricedata();
                                                            },
                                                            child: Text('Sync PM'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Container(
                                                    width: width / 2.1,
                                                    margin: EdgeInsets.only(left: 0),
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          height: height / 13,
                                                          width: width / 4.2,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width / 4.3,
                                                            child: Card(
                                                              child: Text(
                                                                'Mix Master',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width/8,
                                                          height: height/ 16,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.green),
                                                            onPressed: () async {
                                                              getMyMixMater();
                                                            },
                                                            child: Text('Sync MM'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width / 2,
                                          height: height,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Container(
                                                  width: width / 2.1,
                                                  margin: EdgeInsets.only(left: 0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        height: height / 13,
                                                        width: width / 4.2,
                                                        child: Container(
                                                          height: height / 14,
                                                          width: width / 4.3,
                                                          child: Card(
                                                            child: Text(
                                                              'Mix Master Child',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: width/8,
                                                        height: height/ 16,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.green),
                                                          onPressed: () async {
                                                            //getMypricedata();
                                                            getMyMixMaterChild();
                                                          },
                                                          child: Text('Sync MMC'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Container(
                                                  width: width / 2.1,
                                                  margin: EdgeInsets.only(left: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        height: height / 13,
                                                        width: width / 4.2,
                                                        child: Container(
                                                          height: height / 14,
                                                          width: width / 4.3,
                                                          child: Card(
                                                            child: Text(
                                                              'KOT Table Master',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: width/7,
                                                        height: height/ 16,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: Colors.green),
                                                          onPressed: () async {
                                                            //getMypricedata();
                                                            //getMyMixMaterChild();
                                                            getKOTtblMaster();
                                                          },
                                                          child: Text('Sync KOT Tbl'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Container(
                                                  width: width / 2.1,
                                                  margin: EdgeInsets.only(left: 0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        height: height / 13,
                                                        width: width / 4.2,
                                                        child: Container(
                                                          height: height / 14,
                                                          width: width / 4.3,
                                                          child: Card(
                                                            child: Text(
                                                              'Shift Master',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: width/7,
                                                        height: height/ 16,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: Colors.green),
                                                          onPressed: () async {
                                                            getShifttblMaster();
                                                          },
                                                          child: Text('Sync KOT Tbl'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
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

  bool onWillPop() {
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
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      // sessionIPAddress = prefs.getString("SaleInvoiceIP");
      // sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));

      print('USERID$sessionuserID');
      print("sesse" + sessionbranchname.toString());
    });
  }

  void getOITBMaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(8, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawOITBSyncModel = OITBSyncModel.fromJson(
            jsonDecode(response.body),
          );
          setState(() {
            loading = false;
            print("Selvba V");
            OITBSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  OITBSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM OITB");

        for (int i = 0; i < RawOITBSyncModel.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO OITB ([ItmsGrpCod],[ItmsGrpNam],[Locked]) VALUES ("
              "${RawOITBSyncModel.result[i].itmsGrpCod},"
              "'${RawOITBSyncModel.result[i].itmsGrpNam}',"
              "'${RawOITBSyncModel.result[i].locked}')");
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

  void getTCD2Master() {
    setState(() {
      loading = true;
    });
    GetAllMaster(6, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawTCD2SyncModel = TCD2SyncModel.fromJson(
            jsonDecode(response.body),
          );
          setState(() {
            loading = false;
            print("Selvba V");
            TCD2Sync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  TCD2Sync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM TCD2");

        for (int i = 0; i < RawTCD2SyncModel.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO TCD2 ([AbsId],[Tcd1Id],[DispOrder],[KeyFld_1_V],[KeyFld_2_V],[KeyFld_3_V],[KeyFld_4_V],[KeyFld_5_V]) VALUES ("
              "${RawTCD2SyncModel.result[i].absId},"
              "'${RawTCD2SyncModel.result[i].tcd1Id}',"
              "'${RawTCD2SyncModel.result[i].dispOrder}',"
              "'${RawTCD2SyncModel.result[i].keyFld1V}',"
              "'${RawTCD2SyncModel.result[i].keyFld2V}','${RawTCD2SyncModel.result[i].keyFld3V}','${RawTCD2SyncModel.result[i].keyFld4V}','${RawTCD2SyncModel.result[i].keyFld5V}')");
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

  void getTCD3Master() {
    setState(() {
      loading = true;
    });
    GetAllMaster(7, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawTCD3SyncModel = TCD3SyncModel.fromJson(
            jsonDecode(response.body),
          );
          setState(() {
            loading = false;
            print("Selvba V");
            TCD3Sync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  TCD3Sync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM TCD3");

        for (int i = 0; i < RawTCD3SyncModel.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO TCD3 ([AbsId],[Tcd2Id],[EfctFrom],[EfctTo],[TaxCode]) VALUES ("
              "${RawTCD3SyncModel.result[i].absId},"
              "'${RawTCD3SyncModel.result[i].tcd2Id}',"
              "'${RawTCD3SyncModel.result[i].efctFrom}',"
              "'${RawTCD3SyncModel.result[i].EfctTo}',"
              "'${RawTCD3SyncModel.result[i].taxCode}')");
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

  void getOTBMMaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(5, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawOITGSyncModel = OITGSyncModel.fromJson(
            jsonDecode(response.body),
          );
          setState(() {
            loading = false;
            print("Selvba V");
            OTBMSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  OTBMSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM OITG");

        for (int i = 0; i < RawOITGSyncModel.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO OITG ([ItmsTypCod],[ItmsGrpNam],[UserSign],[Flag],[Sync]) VALUES ("
              "${RawOITGSyncModel.result[i].itmsTypCod},"
              "'${RawOITGSyncModel.result[i].itmsGrpNam}',"
              "'${RawOITGSyncModel.result[i].userSign}',"
              "'${RawOITGSyncModel.result[i].falg}',"
              "'${RawOITGSyncModel.result[i].sysnc}')");
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

  void getItemMaster() {
    setState(() {
      loading = true;
      log(sessionuserID);
      log(sessionbranchcode);
    });
    GetAllMaster(4, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      print("jsonDecode.body");
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
          //vehicleModel.result.clear();
        } else {
          //log(response.body);
          RawItemMasterSyncModel = ItemMasterSyncModel.fromJson(
            jsonDecode(response.body),
          );
          setState(() {
            loading = false;
            print("Selvba V");
            ItemSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  ItemSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM OITM");

        for (int i = 0; i < RawItemMasterSyncModel.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO OITM ([Flag],[ItemCode],[ItemName],[ItmsGrpCod],[InvntryUom],[PicturName],[OnHand],[QryGroup1],[QryGroup2],[QryGroup3],[QryGroup4],[QryGroup5],[QryGroup6],[QryGroup7],[QryGroup8],[QryGroup9],[QryGroup10],[QryGroup11]) VALUES ("
              "${RawItemMasterSyncModel.result[i].flag},"
              "'${RawItemMasterSyncModel.result[i].itemCode}',"
              "'${RawItemMasterSyncModel.result[i].itemName}',"
              "'${RawItemMasterSyncModel.result[i].itmsGrpCod}',"
              "'${RawItemMasterSyncModel.result[i].invntryUom}',"
              "'${RawItemMasterSyncModel.result[i].picturName}',"
              "'${RawItemMasterSyncModel.result[i].onHand}','${RawItemMasterSyncModel.result[i].QryGroup1}','${RawItemMasterSyncModel.result[i].QryGroup2}','${RawItemMasterSyncModel.result[i].QryGroup3}','${RawItemMasterSyncModel.result[i].QryGroup4}','${RawItemMasterSyncModel.result[i].QryGroup5}','${RawItemMasterSyncModel.result[i].QryGroup6}','${RawItemMasterSyncModel.result[i].QryGroup7}','${RawItemMasterSyncModel.result[i].QryGroup8}','${RawItemMasterSyncModel.result[i].QryGroup9}','${RawItemMasterSyncModel.result[i].QryGroup10}','${RawItemMasterSyncModel.result[i].QryGroup11}')");
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

  void getVarinceMaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(3, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
          VsarinceSync(2);
        } else {
          log(response.body);
          RawSyncVarinceModel = SyncVarinceModel.fromJson(
            jsonDecode(response.body),
          );
          setState(() {
            loading = false;
            print("Selvba V");
            VsarinceSync(1);
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  VsarinceSync(fromid) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);

    if (fromid == 1) {
      print('From -1');
      try {
        setState(() {
          loading = true;
        });
        await database.transaction((txn) async {
          await txn.rawDelete("DELETE  FROM IN_MOB_VARIANCE_MASTER_LIN");

          for (int i = 0; i < RawSyncVarinceModel.result.length; i++) {
            var priint = await txn.rawInsert(
                "INSERT INTO IN_MOB_VARIANCE_MASTER_LIN ([DocNum],[DocDate],[ItemCode],[ItemName],[ItemVariance],[ItemNos],[ItemPieceCount],[Active],[LineNumber]) VALUES ("
                "${RawSyncVarinceModel.result[i].docNum},"
                "'${RawSyncVarinceModel.result[i].docDate}',"
                "'${RawSyncVarinceModel.result[i].itemCode}',"
                "'${RawSyncVarinceModel.result[i].itemName}',"
                "'${RawSyncVarinceModel.result[i].itemVariance}',"
                "'${RawSyncVarinceModel.result[i].itemNos}',"
                "'${RawSyncVarinceModel.result[i].itemPieceCount}',"
                "'${RawSyncVarinceModel.result[i].active}',"
                "'${RawSyncVarinceModel.result[i].lineNumber}')");
            print(priint);
          }

          setState(() {
            loading = false;
          });
        });
      } catch (Excetion) {
        print(Excetion);
      }
    } else if (fromid == 2) {
      print('From -2');
      try {
        setState(() {
          loading = true;
        });
        await database.transaction((txn) async {
          await txn.rawDelete("DELETE  FROM IN_MOB_VARIANCE_MASTER_LIN");
          setState(() {
            loading = false;
          });
        });
      } catch (Excetion) {
        print(Excetion);
      }
    }
  }

  Future<http.Response> getMypricedata() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FromId": 20,
      "ScreenId": int.parse(sessionbranchcode),
      "DocNo": int.parse(sessionuserID),
      "DocEntry": 0,
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
    //var nodata = jsonDecode(response.body)['status'] == 0;
    print(response.body);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          RawPriceListSyncModel == '';
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        //print(response.body);
        log(response.body);
        RawPriceListSyncModel =
            PriceListSyncModel.fromJson(jsonDecode(response.body));
        print("GETLENGTH ${RawPriceListSyncModel.testdata.length}");
        setState(() {
          loading = false;
          PriceListSync();
        });
      }
    } else {
      throw Exception('Failed to Login API');
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

  void getMyMixMater() {
    setState(() {
      loading = true;
    });
    GetAllMaster(10, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawMyMixMaster = MyMixMaster.fromJson(
            jsonDecode(response.body),
          );

          setState(() {
            loading = false;
            print("Selvba V");
            MyMixMaterSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  MyMixMaterSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM IN_MOB_MIXBOX_MASTER");

        for (int i = 0; i < RawMyMixMaster.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO [IN_MOB_MIXBOX_MASTER]([DocNo],[ItemCode],[ItemName],[Uom],[Qty],[Location],[LocationName],[Active],[DocDate],[CreateBy],[Sync])VALUES("
              "${RawMyMixMaster.result[i].docNo},"
              "'${RawMyMixMaster.result[i].itemCode}',"
              "'${RawMyMixMaster.result[i].itemName}',"
              "'${RawMyMixMaster.result[i].uom}',"
              "'${RawMyMixMaster.result[i].qty}',"
              "'${RawMyMixMaster.result[i].location}',"
              "'${RawMyMixMaster.result[i].locationName}','${RawMyMixMaster.result[i].active}','${RawMyMixMaster.result[i].docDate}','${RawMyMixMaster.result[i].createBy}','${RawMyMixMaster.result[i].sync}')");
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

  void getMyMixMaterChild() {
    setState(() {
      loading = true;
    });
    GetAllMaster(11, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawMyMixMasterChild = MyMixMasterChild.fromJson(
            jsonDecode(response.body),
          );

          setState(() {
            loading = false;
            print("Selvba V");
            //MyMixMaterSync();
            MyMixMaterSyncChild();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  MyMixMaterSyncChild() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM IN_MOB_MIXBOXCHILD");

        for (int i = 0; i < RawMyMixMasterChild.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO [IN_MOB_MIXBOXCHILD]([DocNo],[ItemCode],[ItemName],[Qty],[Active],[CreatyBy])VALUES("
              "${RawMyMixMasterChild.result[i].docNo},"
              "'${RawMyMixMasterChild.result[i].itemCode}',"
              "'${RawMyMixMasterChild.result[i].itemName}',"
              "'${RawMyMixMasterChild.result[i].qty}',"
              "'${RawMyMixMasterChild.result[i].active}',"
              "'${RawMyMixMasterChild.result[i].creatyBy}')");
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

  void getKOTtblMaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(12, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);
          RawKottblMaster = KottblMaster.fromJson(
            jsonDecode(response.body),
          );

          setState(() {
            loading = false;
            print("Selvba V");
            GetKotTblSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  GetKotTblSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM IN_MOB_TABLE_MASTER");

        for (int i = 0; i < RawKottblMaster.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO [IN_MOB_TABLE_MASTER]([CreationName],[Location],[LocationName],[OccCode],[OccName],[TableNo],[SeatNo],[DocDate],[CreateBy],[Active],[Sync])VALUES("
                  "'${RawKottblMaster.result[i].creationName}',"
                  "'${RawKottblMaster.result[i].location}',"
                  "'${RawKottblMaster.result[i].locationName}',"
                  "'${RawKottblMaster.result[i].occCode}',"
                  "'${RawKottblMaster.result[i].occName}',"
                  "'${RawKottblMaster.result[i].tableNo}','${RawKottblMaster.result[i].seatNo}','${RawKottblMaster.result[i].docDate}','${RawKottblMaster.result[i].createBy}','${RawKottblMaster.result[i].active}','${RawKottblMaster.result[i].docNo}')");
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

  void getShifttblMaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(14, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);

          RawShiftTblMaster = ShiftTblMaster.fromJson(jsonDecode(response.body));


          setState(() {
            loading = false;
            print("Selvba V");
            GetShiftTblSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  GetShiftTblSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        await txn.rawDelete("DELETE  FROM IN_MOB_SHIFT_OPEN");

        for (int i = 0; i < RawShiftTblMaster.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO [IN_MOB_SHIFT_OPEN]([DocNo],[OpeningAmt],[DocDate],[CounterId],[DeviceId],[UserId],[Status])VALUES("
                  "'${RawShiftTblMaster.result[i].docNo}',"
                  "'${RawShiftTblMaster.result[i].openingAmt}',"
                  "'${RawShiftTblMaster.result[i].docDate}',"
                  "'${RawShiftTblMaster.result[i].counterId}',"
                  "'${RawShiftTblMaster.result[i].deviceId}',"
                  "'${RawShiftTblMaster.result[i].userId}','${RawShiftTblMaster.result[i].status}')");
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

  void getEMplMaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(17, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      //print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          log(response.body);

          RawGetSyncEmpMaster = GetSyncEmpMaster.fromJson(jsonDecode(response.body));

          setState(() {
            loading = false;
            print("Selvba V");
            GetEMpTblSync();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  GetEMpTblSync() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    try {
      setState(() {
        loading = true;
      });
      await database.transaction((txn) async {
        var priint = await txn.rawDelete("DELETE  FROM OHEM");

        for (int i = 0; i < RawGetSyncEmpMaster.result.length; i++) {
          var priint = await txn.rawInsert(
              "INSERT INTO [OHEM]([lastName],[firstName],[Code],[Active])VALUES('${RawGetSyncEmpMaster.result[i].lastName}','${RawGetSyncEmpMaster.result[i].firstName}',${RawGetSyncEmpMaster.result[i].empID},'${RawGetSyncEmpMaster.result[i].active}')");
          print(priint);
        }
        print(priint);

        setState(() {
          loading = false;
        });
      });
    } catch (Excetion) {
      print(Excetion);
    }
  }

}
