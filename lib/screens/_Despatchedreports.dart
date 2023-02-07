// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_brace_in_string_interps, missing_return, unused_local_variable, unrelated_type_equality_checks, equal_keys_in_map, camel_case_types, must_be_immutable
import 'dart:convert';
import 'dart:developer';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/DashBoardReportsDetalies/LocationwiseDespatchReports.dart';
import 'package:bestmummybackery/DashBoardReportsDetalies/ModelClass/ProductionDetaliesReports.dart';
import 'package:bestmummybackery/Model/DespatchLocationwise.dart';
import 'package:bestmummybackery/Model/Saleordertracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DespatchReports extends StatefulWidget {
  DespatchReports({Key key, this. DocNo, this. DocType}) : super(key: key);
  var DocType="";
  var DocNo="";
  @override
  _DespatchReportsState createState() => _DespatchReportsState();
}


class _DespatchReportsState extends State<DespatchReports> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionContact1 = "";
  var sessionIPPortNo = 0;
  bool loading = false;
  DateTime dateTime = DateTime.now();
  final _fromdate = TextEditingController();
  final _todate = TextEditingController();

  //
   DespatchLocationwise rawDespatchLocationwise;
   List<DespatchLocationwiseList>  secDespatchLocationwiseList=[];

  Saleordertracking rawSaleordertracking;
  List<SaleOrderTracking>  secSaleOrderTracking=[];


  DespatchLocationwise rawDriverAndUser;
  List<Driveranduserlist>  secDriveranduserlist=[];
  DespatchLocationwise rawUser;
  List<Driveranduserlist>  secUserlist=[];

  //
  bool locationwisedispatch = false;
  bool saleorderaginstproduction = false;
  bool otherproduction = false;
  bool saleordertranction = false;
  bool driverwisedispatch = false;
  bool userwisedespatch = false;

  @override
  void initState() {
    _fromdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _todate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    getStringValuesSF();
    super.initState();
  }
  _SelectTo(BuildContext context, formid) async {
    var _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        if (formid == 1) {
          _fromdate.text = DateFormat('dd-MM-yyyy').format(_picked);

          setState(() {});
        }
        if (formid == 2) {

          _todate.text = DateFormat('dd-MM-yyyy').format(_picked);

        }
      });
    }
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

            ),
          ),
          backgroundColor: Colors.white,
          body: !loading ? SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: height,
                  width: width/3,
                  color: Colors.blueGrey,
                )

              ],
            ),
          ) : Center(child: CircularProgressIndicator(),),
          persistentFooterButtons: [
            Container(
              height: height/22,
              child: Row(
                children: [
                  FloatingActionButton.extended(
                    heroTag: "Print",
                    backgroundColor: Colors.blue.shade700,
                    icon: Icon(Icons.clear,size: height/50,),
                    label: Text('Print',style: TextStyle(fontSize: height/60),),
                    onPressed: () {},
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
            title: Text('Despatch Reports'),
          ),
          backgroundColor: Colors.white,
          body: !loading ? SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: height/1.2,
                      width: width/5,
                      child: Column(
                        children: [
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              onPressed: (){
                                _SelectTo(context, 1);
                              },
                              child: Text(_fromdate.text.toString()),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                                onPressed: (){
                                  _SelectTo(context, 2);
                                },
                                child: Text(_todate.text.toString()),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary:  locationwisedispatch?Colors.black12:Colors.blue),
                              onPressed: (){
                                setState(() {
                                  despatchlocationwise();
                                });
                              },
                              child: Text('Location wise dispatch value'),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary:  saleorderaginstproduction?Colors.black12:Colors.blue),
                              onPressed: (){
                                saleorderaginstwise();
                              },
                              child: Text('Sale Order Aginst Production Value'),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              onPressed: (){},
                              child: Text('Others Production Value'),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary:  saleordertranction?Colors.black12:Colors.blue),
                              onPressed: (){
                                saleordertracking();
                              },
                              child: Text('Sale Orders Tranction Tracking'),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary:  driverwisedispatch?Colors.black12:Colors.blue),
                              onPressed: (){
                                setState(() {
                                  driverwise();
                                });
                              },
                              child: Text('Driverwise Despatch Value'),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary:  userwisedespatch?Colors.black12:Colors.blue),
                              onPressed: (){
                                setState(() {
                                  userwise();
                                });
                              },
                              child: Text('Userwise Despatch Value'),
                            ),
                          ),
                          SizedBox(
                            width: width/5,
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ProductionDetaliesReports(
                                      LocatinId: "0",
                                      LocationName: "0",
                                      FromDate: _fromdate.text.toString(),
                                      ToDate: _todate.text.toString(),
                                      fromid: 1,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Production Detalies Reports'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height/1.2,
                      width: width/1.3,
                      child: Column(
                        children: [
                          Container(
                            height: height/13,
                            width: width/1.3,
                            color: Colors.white,
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                            visible: locationwisedispatch,
                            child: Container(
                              height: height/1.4,
                              width: width/1.3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: secDespatchLocationwiseList.length == 0
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
                                            label: Text('Location',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Ammount',style: TextStyle(color: Colors.white),),
                                          ),
                                          DataColumn(
                                            label: Text('Check',style: TextStyle(color: Colors.white),),
                                          ),

                                        ],
                                      rows: secDespatchLocationwiseList.map((list) =>
                                          DataRow(cells: [
                                            DataCell(
                                              Text(list.location.toString(),textAlign: TextAlign.center),
                                            ),
                                            DataCell(
                                              Text(list.ammount.toString(),
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataCell(
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context) => LocationwiseDespatchReports(
                                                        LocatinId: list.locationId.toString(),
                                                        LocationName: list.location.toString(),
                                                        FromDate: _fromdate.text.toString(),
                                                        ToDate: _todate.text.toString(),
                                                        fromid: 1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ]),)
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                            visible: saleorderaginstproduction,
                            child: Container(
                              height: height/1.4,
                              width: width/1.3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: secDespatchLocationwiseList.length == 0
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
                                      label: Text('Location',style: TextStyle(color: Colors.white),),
                                    ),
                                    DataColumn(
                                      label: Text('Ammount',style: TextStyle(color: Colors.white),),
                                    ),

                                  ],
                                  rows: secDespatchLocationwiseList.map((list) =>
                                      DataRow(cells: [
                                        DataCell(
                                          Text(list.location.toString(),textAlign: TextAlign.center),
                                        ),
                                        DataCell(
                                          Text(list.ammount.toString(),
                                              textAlign: TextAlign.center),
                                        ),
                                      ]),)
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                            visible: saleordertranction,
                            child: Container(
                              height: height/1.4,
                              width: width/1.3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: secSaleOrderTracking.length == 0
                                      ? Center(child: Text('No Data Add!'),)
                                      : DataTable(
                                          sortColumnIndex: 0,
                                          sortAscending: true,
                                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                          showCheckboxColumn: false,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text('Location',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('OrderNo',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('DeliveryDate',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('ProdDocNo',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('ProdTime',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('ProdBy',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Des DocNo',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Des Date',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Des Time',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Desp By',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('VehicleNo',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('VehicleName',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('DriverName',style: TextStyle(color: Colors.white),),
                                            ),

                                          ],
                                        rows: secSaleOrderTracking.map((list) =>
                                            DataRow(cells: [
                                              DataCell(
                                                Text(list.location.toString(),textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.orderNo.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.deliveryDate.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.prodDocNo.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.prodTime.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.prodBy.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.desDocNo.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.desDate.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.desTime.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.despBy.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.vehicleNo.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.vehicleName.toString(),
                                                    textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.driverName.toString(),
                                                    textAlign: TextAlign.center),
                                              ),

                                            ]),)
                                            .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                            visible: driverwisedispatch,
                            child: Container(
                              height: height/1.4,
                              width: width/1.3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: secDriveranduserlist.length == 0
                                      ? Center(child: Text('No Data Add!'),)
                                      : DataTable(
                                          sortColumnIndex: 0,
                                          sortAscending: true,
                                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                          showCheckboxColumn: false,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text('Driver Name',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Ammount',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Check',style: TextStyle(color: Colors.white),),
                                            ),

                                          ],
                                    rows: secDriveranduserlist.map((list) =>
                                        DataRow(cells: [
                                          DataCell(
                                            Text(list.Name.toString(),textAlign: TextAlign.center),
                                          ),
                                          DataCell(
                                            Text(list.ammount.toString(),
                                                textAlign: TextAlign.center),
                                          ),
                                          DataCell(
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) => LocationwiseDespatchReports(
                                                      LocatinId: list.empId.toString(),
                                                      LocationName: list.Name.toString(),
                                                      FromDate: _fromdate.text.toString(),
                                                      ToDate: _todate.text.toString(),
                                                      fromid: 2,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),



                                        ]),)
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                            visible: userwisedespatch,
                            child: Container(
                              height: height/1.4,
                              width: width/1.3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: secUserlist.length == 0
                                      ? Center(child: Text('No Data Add!'),)
                                      : DataTable(
                                          sortColumnIndex: 0,
                                          sortAscending: true,
                                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                          showCheckboxColumn: false,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text('User Name',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Ammount',style: TextStyle(color: Colors.white),),
                                            ),
                                            DataColumn(
                                              label: Text('Check',style: TextStyle(color: Colors.white),),
                                            ),


                                          ],
                                        rows: secUserlist.map((list) =>
                                            DataRow(cells: [
                                                DataCell(
                                                  Text(list.Name.toString(),textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                Text(list.ammount.toString(),
                                                  textAlign: TextAlign.center),
                                              ),
                                              DataCell(
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext context) => LocationwiseDespatchReports(
                                                          LocatinId: list.empId.toString(),
                                                          LocationName: list.Name.toString(),
                                                          FromDate: _fromdate.text.toString(),
                                                          ToDate: _todate.text.toString(),
                                                          fromid: 3,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),

                                        ]),)
                                        .toList(),
                                  ),
                                ),
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
          ) : Center(
            child: CircularProgressIndicator(),
          ),
          persistentFooterButtons: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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

                  },
                ),
              ],
            ),
          ],
        ),
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
      sessionIPAddress = prefs.getString("SaleInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));
      sessionContact1 = prefs.getString("Contact1");
    });
  }

  Future<http.Response> despatchlocationwise() async {
    double total=0;
    setState(() {
       locationwisedispatch = true;
       saleorderaginstproduction = false;
       otherproduction = false;
       saleordertranction = false;
       driverwisedispatch = false;
       userwisedespatch = false;
      loading = true;
      secDespatchLocationwiseList.clear();
    });
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromId":1,
      "FromDate":_fromdate.text,
      "Todate":_todate.text
    };
    log(jsonEncode(body));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getdespatchreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
        setState(() {
          rawDespatchLocationwise  = DespatchLocationwise.fromJson(jsonDecode(response.body));
          for(int i=0;i<rawDespatchLocationwise.testdata.length;i++){
            total += double.parse(rawDespatchLocationwise.testdata[i].ammount.toString());
            secDespatchLocationwiseList.add(
                DespatchLocationwiseList(
                    rawDespatchLocationwise.testdata[i].locationId,
                    rawDespatchLocationwise.testdata[i].location,
                    rawDespatchLocationwise.testdata[i].ammount));
          }
          secDespatchLocationwiseList.add(
              DespatchLocationwiseList(
                  0,
                  'Total',
                  total.toString()));


            loading = false;
        });
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
  Future<http.Response> saleorderaginstwise() async {
    double total=0;
    setState(() {
      locationwisedispatch = false;
      saleorderaginstproduction = true;
      otherproduction = false;
      saleordertranction = false;
      driverwisedispatch = false;
      userwisedespatch = false;
      loading = true;
      secDespatchLocationwiseList.clear();
    });
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromId":2,
      "FromDate":_fromdate.text,
      "Todate":_todate.text
    };
    log(jsonEncode(body));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getdespatchreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        rawDespatchLocationwise  = DespatchLocationwise.fromJson(jsonDecode(response.body));
        for(int i=0;i<rawDespatchLocationwise.testdata.length;i++){
          total += double.parse(rawDespatchLocationwise.testdata[i].ammount.toString());
          secDespatchLocationwiseList.add(
              DespatchLocationwiseList(
                  rawDespatchLocationwise.testdata[i].locationId,
                  rawDespatchLocationwise.testdata[i].location,
                  rawDespatchLocationwise.testdata[i].ammount));
        }
        secDespatchLocationwiseList.add(
            DespatchLocationwiseList(
                0,
                'Total',
                total.toString()));


        loading = false;
      });
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
  Future<http.Response> saleordertracking() async {
    double total=0;
    setState(() {
      locationwisedispatch = false;
      saleorderaginstproduction = false;
      otherproduction = false;
      saleordertranction = true;
      driverwisedispatch = false;
      userwisedespatch = false;
      loading = true;
      secDespatchLocationwiseList.clear();
    });
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromId":4,
      "FromDate":_fromdate.text,
      "Todate":_todate.text
    };
    log(jsonEncode(body));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getdespatchreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        rawSaleordertracking = Saleordertracking.fromJson(jsonDecode(response.body));
        for(int i=0; i < rawSaleordertracking.testdata.length;i++){
          secSaleOrderTracking.add(SaleOrderTracking(
              rawSaleordertracking.testdata[i].location,
              rawSaleordertracking.testdata[i].orderNo,
              rawSaleordertracking.testdata[i].deliveryDate,
              rawSaleordertracking.testdata[i].orderStatus,
              rawSaleordertracking.testdata[i].prodDocNo,
              rawSaleordertracking.testdata[i].prodDate,
              rawSaleordertracking.testdata[i].prodTime,
              rawSaleordertracking.testdata[i].prodBy,
              rawSaleordertracking.testdata[i].desDocNo,
              rawSaleordertracking.testdata[i].desDate,
              rawSaleordertracking.testdata[i].desTime,
              rawSaleordertracking.testdata[i].despBy,
              rawSaleordertracking.testdata[i].vehicleNo,
              rawSaleordertracking.testdata[i].vehicleName,
              rawSaleordertracking.testdata[i].driverName)
          );
        }

        loading = false;
      });
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
  Future<http.Response> driverwise() async {
    double total=0;
    setState(() {
      locationwisedispatch = false;
      saleorderaginstproduction = false;
      otherproduction = false;
      saleordertranction = false;
      driverwisedispatch = true;
      userwisedespatch = false;
      loading = true;
      secDriveranduserlist.clear();
    });
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromId":5,
      "FromDate":_fromdate.text,
      "Todate":_todate.text
    };
    log(jsonEncode(body));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getdespatchreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        rawDriverAndUser = DespatchLocationwise.fromJson(jsonDecode(response.body));
        for(int i=0; i < rawDriverAndUser.testdata.length;i++){
          total += double.parse(rawDriverAndUser.testdata[i].ammount.toString());
          secDriveranduserlist.add(
              Driveranduserlist(
              rawDriverAndUser.testdata[i].name,
              rawDriverAndUser.testdata[i].ammount,
              rawDriverAndUser.testdata[i].empid,
              ));
        }
        secDriveranduserlist.add(Driveranduserlist("Total", total.toString(),""));

        loading = false;
      });
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
  Future<http.Response> userwise() async {
    double total=0;
    setState(() {
      locationwisedispatch = false;
      saleorderaginstproduction = false;
      otherproduction = false;
      saleordertranction = false;
      driverwisedispatch = false;
      userwisedespatch = true;
      loading = true;
      secUserlist.clear();
    });
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromId":6,
      "FromDate":_fromdate.text,
      "Todate":_todate.text
    };
    log(jsonEncode(body));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getdespatchreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        rawUser = DespatchLocationwise.fromJson(jsonDecode(response.body));
        for(int i=0; i < rawUser.testdata.length;i++){
          total += double.parse(rawUser.testdata[i].ammount.toString());
          secUserlist.add(Driveranduserlist(
              rawUser.testdata[i].name,
              rawUser.testdata[i].ammount,
              rawUser.testdata[i].empid,
          )
          );
        }
        secUserlist.add(Driveranduserlist("Total", total.toString(),''));
        loading = false;
      });
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }



}


class DespatchLocationwiseList {
  var locationId;
  String location;
  var ammount;

  DespatchLocationwiseList(this.locationId, this.location, this.ammount);


}

class Driveranduserlist {
  String Name;
  var ammount;
  var empId;

  Driveranduserlist(this.Name, this.ammount,this.empId);


}


class SaleOrderTracking {
  String location;
  var orderNo;
  String deliveryDate;
  String orderStatus;
  var prodDocNo;
  String prodDate;
  String prodTime;
  String prodBy;
  var desDocNo;
  String desDate;
  String desTime;
  String despBy;
  String vehicleNo;
  String vehicleName;
  String driverName;

  SaleOrderTracking(
      this.location,
        this.orderNo,
        this.deliveryDate,
        this.orderStatus,
        this.prodDocNo,
        this.prodDate,
        this.prodTime,
        this.prodBy,
        this.desDocNo,
        this.desDate,
        this.desTime,
        this.despBy,
        this.vehicleNo,
        this.vehicleName,
        this.driverName);

}
