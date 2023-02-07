// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unused_import, unnecessary_import, missing_return, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/MastersScreen.dart';
import 'package:bestmummybackery/PriceList/Models/MyPricelistMasterTab1Model.dart';
import 'package:bestmummybackery/PriceList/Models/PriceListTab1Model.dart';
import 'package:bestmummybackery/PriceList/PriceListTab1LocationMaping.dart';
import 'package:bestmummybackery/PriceList/PriceListTap2SubScreen.dart';
import 'package:bestmummybackery/PriceList/PriceListTap3SubScreen.dart';
import 'package:bestmummybackery/PriceList/PriceListTap4SubScreen.dart';
import 'package:bestmummybackery/PriceList/PriceListTap5SubScreen.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PriceListMaster extends StatefulWidget {
  PriceListMaster({Key key, this.id}) : super(key: key);
  int id;

  @override
  _PriceListMasterState createState() => _PriceListMasterState();
}

class _PriceListMasterState extends State<PriceListMaster> {
  TabController _tabController;
  int currentindex = 0;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var _SerchVarince = new TextEditingController();
  var _SearchItemtab1 = new TextEditingController();
  var _SearchItemtab2 = new TextEditingController();
  var _SearchItemtab3 = new TextEditingController();
  int SelectLocatioCode = 0;
  String AltertItemCode;
  bool loading = false;
  int ReqFromId = 0;

  PriceListTab1Model RawPriceListTab1Model;
  List<TempPriceListTab1Model> SecPriceListTab1Model = new List();

  MyPricelistMasterTab1Model RawMyPricelistMasterTab1Model;
  List<TempMyPricelistMasterTab1Model> SecMyPricelistMasterTab1Model = new List();

  @override
  // ignore: must_call_super
  void initState() {
    ReqFromId = 2;
    setState(() {
      getStringValuesSF();
      currentindex = widget.id;
      print('currentindex' + currentindex.toString());
      PriceLisMastePost('', '', '', 0, '', '', currentindex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;

    //final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return tablet
        ? DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Price List Masyer'),
                actions: [
                  IconButton(
                    onPressed: () {
                      print('Back');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MastersScreen()),
                      );
                    },
                    icon: Icon(Icons.clear),
                  )
                ],
                bottom: TabBar(
                  controller: _tabController,
                  onTap: (var index) {
                    print("index$index");
                    setState(() {
                      if (index == 0) {
                        setState(() {
                          currentindex = index;
                          ReqFromId = 2;
                          PriceLisMastePost(
                              '', '', '', 0, '', '', currentindex);
                        });
                      } else if (index == 1) {
                        setState(() {
                          currentindex = index;
                          ReqFromId = 6;
                          PriceLisMastePost('', '', '', 0, '', '', 2);
                        });
                      } else if (index == 2) {
                        print('Selev Tab 3');
                        setState(() {
                          currentindex = index;
                          ReqFromId = 8;
                          PriceLisMastePost('', '', '', 0, '', '', 3);

                          //PriceLisMastePost(itemCode, itemName, uOM, Loccode, location, active, index);
                        });
                      } else if (index == 3) {
                        currentindex = index;
                        setState(() {
                          currentindex = index;
                          ReqFromId = 6;
                          PriceLisMastePost('', '', '', 0, '', '', 4);
                        });
                      } else if (index == 4) {
                        currentindex = index;
                        setState(() {
                          currentindex = index;
                          ReqFromId = 8;
                          PriceLisMastePost('', '', '', 0, '', '', 5);
                        });
                      }
                    });
                  },
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Colors.black12),
                  tabs: [
                    Tab(
                      text: 'Item Maping At Location',
                    ),
                    Tab(
                      text: 'Take Away Without Variance ',
                    ),
                    Tab(
                      text: 'Take Away With Variance ',
                    ),
                    Tab(
                      text: 'Dinning Without Variance',
                    ),
                    Tab(
                      text: 'Dinning With Variance',
                    ),
                  ],
                ),
              ),
              body: !loading
                  ? TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        Scaffold(
                          body: SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 2,
                                  child: TextField(
                                    controller: _SearchItemtab1,
                                    enabled: true,
                                    onChanged: (ssss) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecPriceListTab1Model.toString() ==
                                              "null"
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'S.No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Code',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'UOM',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: SecPriceListTab1Model.where(
                                                      (element) => element
                                                          .itemName
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                            _SearchItemtab1.text
                                                                .toLowerCase(),
                                                          ))
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(
                                                        Text(
                                                          SecPriceListTab1Model
                                                                  .indexOf(list)
                                                              .toString(),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          list.itemCode
                                                              .toString(),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          list.itemName
                                                              .toString(),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          list.uOM.toString(),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          list.active
                                                              .toString(),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Wrap(
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                              onPressed: () {
                                                                print('Line Item OPen' +
                                                                    list.itemCode);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => PriceListTap1SubScreen(
                                                                        PostItemCode:
                                                                            list
                                                                                .itemCode,
                                                                        PostItemName:
                                                                            list
                                                                                .itemName,
                                                                        PostUom:
                                                                            list
                                                                                .uOM,
                                                                        Index:
                                                                            currentindex),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                  'Add Location'),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  heroTag: "btn1",
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
                                  heroTag: "btn1",
                                  label: Text('Save'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 2,
                                  child: TextField(
                                    controller: _SearchItemtab2,
                                    enabled: true,
                                    onChanged: (ssss) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecPriceListTab1Model.toString() ==
                                              "null"
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'S.No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Code',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'UOM',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              //rows:
                                              // SecPriceListTab1Model.where(element) => itemName
                                              //             .toString()
                                              //             .contains(""))

                                              rows: SecPriceListTab1Model.where(
                                                (element) => element.itemName
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                      _SearchItemtab2.text
                                                          .toLowerCase(),
                                                    ),
                                              )
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(
                                                        Text(
                                                            SecPriceListTab1Model
                                                                    .indexOf(
                                                                        list)
                                                                .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.itemCode
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.itemName
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.uOM
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.active
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Wrap(
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                              onPressed: () {
                                                                print('Line Item OPen' +
                                                                    list.itemCode);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => PriceListTap2SubScreen(
                                                                        PostItemCode:
                                                                            list
                                                                                .itemCode,
                                                                        PostItemName:
                                                                            list
                                                                                .itemName,
                                                                        PostUom:
                                                                            list
                                                                                .uOM,
                                                                        Index:
                                                                            2),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                  'Add Tab2'),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    print('FloatingActionButton clicked');
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Save'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 4,
                                  margin: EdgeInsets.only(left: 15),
                                  child: TextField(
                                    controller: _SerchVarince,
                                    keyboardType: TextInputType.text,
                                    enabled: true,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            top: 3,
                                            bottom: 2,
                                            left: 10,
                                            right: 10),
                                        hintText: 'Select Variance',
                                        labelText: 'Select Variance',
                                        labelStyle: TextStyle(
                                            color: Colors.grey.shade600),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                SizedBox(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecPriceListTab1Model.toString() ==
                                              "null"
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'S.No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Code',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'UOM',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: SecPriceListTab1Model.where(
                                                (element) => element.itemName
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(_SerchVarince.text.toLowerCase().toString(),),
                                              )
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(
                                                        Text(SecPriceListTab1Model.indexOf(list).toString()),),
                                                      DataCell(
                                                        Text(list.itemCode
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.itemName
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.uOM
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Text(list.active
                                                            .toString()),
                                                      ),
                                                      DataCell(
                                                        Wrap(
                                                          direction: Axis
                                                              .vertical, //default
                                                          alignment:
                                                              WrapAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                              onPressed: () {
                                                                print('Line Item OPen' + list.itemCode);
                                                                Navigator.push(context, MaterialPageRoute(
                                                                    builder: (context) => PriceListTap3SubScreen(
                                                                        PostItemCode: list.itemCode,
                                                                        PostItemName: list.itemName,
                                                                        PostUom: list.uOM,
                                                                        Index: 2),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text('Add Tab3'),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    print('FloatingActionButton clicked');
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Save'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 2,
                                  child: TextField(
                                    controller: _SearchItemtab3,
                                    enabled: true,
                                    onChanged: (ssss) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                SizedBox(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecPriceListTab1Model.toString() ==
                                              "null"
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'S.No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Code',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'UOM',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: SecPriceListTab1Model.where(
                                                              (element) => element.itemName
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                              _SearchItemtab3.text
                                                                  .toLowerCase(),
                                                              ),
                                                              ).map(
                                                (list) => DataRow(cells: [
                                                  DataCell(
                                                    Text(SecPriceListTab1Model
                                                            .indexOf(list)
                                                        .toString()),
                                                  ),
                                                  DataCell(
                                                    Text(list.itemCode
                                                        .toString()),
                                                  ),
                                                  DataCell(
                                                    Text(list.itemName
                                                        .toString()),
                                                  ),
                                                  DataCell(
                                                    Text(list.uOM.toString()),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        list.active.toString()),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                         style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                          onPressed: () {
                                                            print('Line Item OPen' +
                                                                list.itemCode);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => PriceListTap4SubScreen(
                                                                    PostItemCode: list.itemCode,
                                                                    PostItemName: list.itemName,
                                                                    PostUom:list.uOM,
                                                                    Index: 2),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              Text('Add Tab4'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ).toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    print('FloatingActionButton clicked');
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Save'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecPriceListTab1Model.toString() ==
                                              "null"
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'S.No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Code',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'UOM',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: SecPriceListTab1Model.map(
                                                (list) => DataRow(cells: [
                                                  DataCell(
                                                    Text(SecPriceListTab1Model
                                                            .indexOf(list)
                                                        .toString()),
                                                  ),
                                                  DataCell(
                                                    Text(list.itemCode
                                                        .toString()),
                                                  ),
                                                  DataCell(
                                                    Text(list.itemName
                                                        .toString()),
                                                  ),
                                                  DataCell(
                                                    Text(list.uOM.toString()),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        list.active.toString()),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                          onPressed: () {
                                                            print('Line Item OPen' +
                                                                list.itemCode);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => PriceListTap5SubScreen(
                                                                    PostItemCode: list.itemCode,
                                                                    PostItemName: list.itemName,
                                                                    PostUom: list.uOM,
                                                                    Index: 2),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              Text('Add Tab5'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ).toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    print('FloatingActionButton clicked');
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Save'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          )
        : Container();
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
    });
  }

  Future<http.Response> PriceLisMastePost(String itemCode, String itemName, uOM,
      int Loccode, String location, String active, int index) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('TabINdex' + index.toString());
      print('FormId' + ReqFromId.toString());
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": 1,
      "ItemCode": itemCode,
      "ItemName": itemName,
      "ItemUOM": uOM,
      "Location": Loccode,
      "LocationName": location,
      "variance": "",
      "OccCode": 0,
      "OccName": "",
      "Rate": 1.0,
      "Active": active,
      "UserID": 0,
      "DocDate": "",
      "TabIndex": index
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PRRICELISTMASTER_SP'),
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
          SecPriceListTab1Model.clear();
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        //INSERT
        if (ReqFromId == 1) {
          print(response.body);
        }
        // FRONT DATA TBA 1
        else if (ReqFromId == 2) {
          setState(() {
            loading = false;
            SecPriceListTab1Model.clear();
          });

          print(response.body);
          setState(() {
            RawPriceListTab1Model =
                PriceListTab1Model.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawPriceListTab1Model.testdata.length; i++)
              SecPriceListTab1Model.add(
                TempPriceListTab1Model(
                  RawPriceListTab1Model.testdata[i].itemCode,
                  RawPriceListTab1Model.testdata[i].itemName,
                  RawPriceListTab1Model.testdata[i].uOM,
                  RawPriceListTab1Model.testdata[i].active,
                ),
              );
          });
        } else if (ReqFromId == 6) {
          setState(() {
            loading = false;
            SecPriceListTab1Model.clear();
          });

          print(response.body);
          setState(() {
            RawPriceListTab1Model =
                PriceListTab1Model.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawPriceListTab1Model.testdata.length; i++)
              SecPriceListTab1Model.add(
                TempPriceListTab1Model(
                  RawPriceListTab1Model.testdata[i].itemCode,
                  RawPriceListTab1Model.testdata[i].itemName,
                  RawPriceListTab1Model.testdata[i].uOM,
                  RawPriceListTab1Model.testdata[i].active,
                ),
              );
          });
        } else if (ReqFromId == 8) {
          setState(() {
            loading = false;
          });

          print(response.body);
          setState(() {
            SecPriceListTab1Model.clear();
            RawPriceListTab1Model =
                PriceListTab1Model.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawPriceListTab1Model.testdata.length; i++)
              SecPriceListTab1Model.add(
                TempPriceListTab1Model(
                  RawPriceListTab1Model.testdata[i].itemCode,
                  RawPriceListTab1Model.testdata[i].itemName,
                  RawPriceListTab1Model.testdata[i].uOM,
                  RawPriceListTab1Model.testdata[i].active,
                ),
              );
          });
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }
}

class TempMyPricelistMasterTab1Model {
  int code;
  String location;
  String itemCode;
  String active;
  TempMyPricelistMasterTab1Model(
      this.code, this.location, this.itemCode, this.active);
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class TempPriceListTab1Model {
  String itemCode;
  String itemName;
  var uOM;
  var active;

  TempPriceListTab1Model(this.itemCode, this.itemName, this.uOM, this.active);
}
