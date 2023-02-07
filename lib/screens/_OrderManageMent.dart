// ignore_for_file: non_constant_identifier_names, deprecated_member_use, missing_return, unrelated_type_equality_checks, camel_case_types, equal_keys_in_map, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/DespatchScreen.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/OrderManagement.dart';
import 'package:bestmummybackery/Model/ProductionTblModel.dart';
import 'package:bestmummybackery/Model/PurchaseIndentheaderModel.dart';
import 'package:bestmummybackery/Model/SalesOrderModel.dart';
import 'package:bestmummybackery/Model/getQRModel.dart';
import 'package:bestmummybackery/screens/ProductionEntry.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

class OrderManageMent extends StatefulWidget {
  OrderManageMent({Key key,}) : super(key: key);



  @override
  _OrderManageMentState createState() => _OrderManageMentState();
}

class _OrderManageMentState extends State<OrderManageMent> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  String alterwhscode = "";
  String alterwhsname = "";
  bool loading = false;
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;

  LocationModel locationModel = new LocationModel();
  List<String> loc = new List();
  var alterloccode = '0';
  var alterlocname = '';
  NetworkPrinter printer;

  List<String> salesordernolist = new List();

  SalesOrderModel salesordermodel;
  getQRModel itemmodel;

  ProductionTblModel RawProductionTblModel;
  PurchaseIndentheaderModel RawPurchaseIndentheaderModel;

  OrderManagement RawOrderManagement;

  List<ScreenOrderManagement> secOrderManagement=[];
  List<TempTestdata> templist=[];


  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff3A9BDC),
            Color(0xff3A9BDC),
          ],
        ),
      ),
      child: SafeArea(
          child:!tablet?
          // MObile App Screen
          Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(!tablet? height/15 :height/9),
              child: new AppBar(
                title: Text('Pro Entry'),

              ),
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
                                setState(() {
                                  for (int kk = 0; kk < locationModel.result.length; kk++) {
                                    if (locationModel.result[kk].name == val) {
                                      print(locationModel.result[kk].code);
                                      alterlocname = locationModel.result[kk].name;
                                      alterloccode =locationModel.result[kk].code.toString();
                                    }
                                  }
                                  getDataTableRecord(alterloccode);
                                });
                              },
                              selectedItem: alterlocname,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 5, child: Text(""),

                          ),
                          SizedBox(
                            width: 5,
                          ),
                          new Expanded(
                            flex: 5,
                            child: Container(

                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          new Expanded(
                            flex: 5,
                            child: Container(

                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: secOrderManagement.length == 0
                            ? Center(child: Text('No Data Add!'),)
                            : DataTable(
                          sortColumnIndex: 0,
                          sortAscending: true,
                          headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                          showCheckboxColumn: false,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('View',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Pdf',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('ScreenName',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('DocNo',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('DocDate',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('LocName',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('OccName',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('DeliveryDate',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('DeliveryTime',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Pending',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Production',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Dispatched',style: TextStyle(color: Colors.white),),
                            ),
                            DataColumn(
                              label: Text('Status',style: TextStyle(color: Colors.white),),
                            ),


                          ],
                          rows: secOrderManagement.map((list) =>
                              DataRow(cells: [
                                DataCell(
                                    Icon(Icons.remove_red_eye,color: Colors.amber,),
                                    onTap: (){
                                      if(list.screenName=="IPO"){
                                        getItemDetalies(list.docNo, 18).then((value) => {
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
                                                child: Stockdetalies(context,tablet, height, width),
                                              );
                                            },
                                          )
                                        });

                                      }else{
                                        getItemDetalies(list.docEntry.toString(), 11).then((value) => {
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
                                                child: Stockdetalies(context,tablet, height, width),
                                              );
                                            },
                                          )
                                        });
                                      }
                                    }

                                ),
                                DataCell(
                                    Icon(Icons.picture_as_pdf,color: Colors.blueAccent,),
                                    onTap: (){


                                      getItemDetalies(list.docEntry.toString(), 11).then((value) => {

                                        NetPrinter(sessionIPAddress, sessionIPPortNo,
                                            list.docNo.toString(),
                                            list.locName.toString(),
                                            list.deliveryDate.toString(),
                                            list.deliveryTime.toString(),
                                            list.occName.toString(),
                                            list.shape.toString()
                                        ),



                                      });
                                    }
                                ),
                                DataCell(
                                    Text(list.screenName,textAlign: TextAlign.left),
                                    showEditIcon: true,
                                    onTap: (){


                                      if(list.orderStatus.toString()== "Pr" ||list.orderStatus.toString()== "Ds"){

                                        Fluttertoast.showToast(msg: "Production was closed...");

                                      } else{

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              ProductionEntry(DocType:list.screenName,DocNo:list.docNo.toString()),
                                          ),
                                        );
                                      }

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) =>
                                      //       DespatchScreen(DocType:list.screenName,DocNo:list.docNo.toString()),
                                      //   ),
                                      // );
                                    }
                                ),
                                DataCell(Text(list.docNo.toString(),textAlign: TextAlign.center),),
                                DataCell(Text(list.docDate.toString(),textAlign: TextAlign.center),),
                                DataCell(Text(list.locName.toString(),textAlign: TextAlign.center),),
                                DataCell(Text(list.occName.toString(),textAlign:TextAlign.center),),
                                DataCell(Text(list.deliveryDate.toString(),textAlign: TextAlign.center),),
                                DataCell(Text(list.deliveryTime.toString(),textAlign: TextAlign.center),),
                                DataCell(
                                    Icon(Icons.check,color: Colors.green,)
                                ),
                                DataCell(
                                    list.orderStatus.toString()== "Pr" ||list.orderStatus.toString()== "Ds"?
                                    Icon(Icons.check,color: Colors.green,)
                                        :Icon(Icons.cancel,color: Colors.redAccent,)
                                ),
                                DataCell(
                                    list.orderStatus.toString()=="Ds"?
                                    Icon(Icons.check,color: Colors.green,)
                                        :Icon(Icons.cancel,color: Colors.redAccent,)
                                ),
                                DataCell(
                                    Text(list.LevelStatus.toString())
                                ),
                              ],
                              ),).toList(),
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
                height: height/25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                  ],
                ),
              ),
            ],
          )
          //Tab Screen
              :Scaffold(
                  appBar: new AppBar(
                    title: Text('Order Management'),
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
                                  setState(() {
                                    for (int kk = 0; kk < locationModel.result.length; kk++) {
                                      if (locationModel.result[kk].name == val) {
                                        print(locationModel.result[kk].code);
                                        alterlocname = locationModel.result[kk].name;
                                        alterloccode =locationModel.result[kk].code.toString();
                                      }
                                    }
                                    getDataTableRecord(alterloccode);
                                  });
                                },
                                selectedItem: alterlocname,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 5, child: Text(""),

                            ),
                            SizedBox(
                              width: 5,
                            ),
                            new Expanded(
                              flex: 5,
                              child: Container(

                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            new Expanded(
                              flex: 5,
                              child: Container(

                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: secOrderManagement.length == 0
                              ? Center(child: Text('No Data Add!'),)
                              : DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text('View',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Pdf',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('ScreenName',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('DocNo',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('DocDate',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('LocName',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('OccName',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('DeliveryDate',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('DeliveryTime',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Pending',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Production',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Dispatched',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Status',style: TextStyle(color: Colors.white),),
                                  ),


                                ],
                                    rows: secOrderManagement.map((list) =>
                                      DataRow(cells: [
                                        DataCell(
                                            Icon(Icons.remove_red_eye,color: Colors.amber,),
                                          onTap: (){
                                              if(list.screenName=="IPO"){
                                                getItemDetalies(list.docNo, 18).then((value) => {
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
                                                        child: Stockdetalies(context,tablet, height, width),
                                                      );
                                                    },
                                                  )
                                                });
                                                
                                              }


                                              if(list.screenName=="RawMetrial Request"){
                                                getItemDetalies(list.docNo, 28).then((value) => {
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
                                                        child: Stockdetalies(context,tablet, height, width),
                                                      );
                                                    },
                                                  )
                                                });

                                              }




                                              else{
                                                getItemDetalies(list.docEntry.toString(), 11).then((value) => {
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
                                                        child: Stockdetalies(context,tablet, height, width),
                                                      );
                                                    },
                                                  )
                                                });
                                              }
                                          }
                                                
                                        ),
                                        DataCell(
                                            Icon(Icons.picture_as_pdf,color: Colors.blueAccent,),
                                          onTap: (){


                                            getItemDetalies(list.docEntry.toString(), 11).then((value) => {

                                            NetPrinter(sessionIPAddress, sessionIPPortNo,
                                            list.docNo.toString(),
                                            list.locName.toString(),
                                            list.deliveryDate.toString(),
                                            list.deliveryTime.toString(),
                                            list.occName.toString(),
                                            list.shape.toString()
                                            ),



                                            });
                                          }
                                        ),
                                        DataCell(
                                            Text(list.screenName,textAlign: TextAlign.left),
                                          showEditIcon: true,
                                          onTap: (){


                                             if(list.orderStatus.toString()== "Pr" ||list.orderStatus.toString()== "Ds"){

                                               Fluttertoast.showToast(msg: "Production was closed...");

                                             }else if(list.screenName=='RawMetrial Request'){
                                               Fluttertoast.showToast(msg: "Kindly Use Mobeil...");
                                             }
                                             else{

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>
                                                ProductionEntry(DocType:list.screenName,DocNo:list.docNo.toString()),
                                                ),
                                            );
                                           }

                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(builder: (context) =>
                                            //       DespatchScreen(DocType:list.screenName,DocNo:list.docNo.toString()),
                                            //   ),
                                            // );
                                          }
                                        ),
                                        DataCell(Text(list.docNo.toString(),textAlign: TextAlign.center),),
                                        DataCell(Text(list.docDate.toString(),textAlign: TextAlign.center),),
                                        DataCell(Text(list.locName.toString(),textAlign: TextAlign.center),),
                                        DataCell(Text(list.occName.toString(),textAlign:TextAlign.center),),
                                        DataCell(Text(list.deliveryDate.toString(),textAlign: TextAlign.center),),
                                        DataCell(Text(list.deliveryTime.toString(),textAlign: TextAlign.center),),
                                        DataCell(
                                           Icon(Icons.check,color: Colors.green,)
                                        ),
                                        DataCell(
                                            list.orderStatus.toString()== "Pr" ||list.orderStatus.toString()== "Ds"?
                                             Icon(Icons.check,color: Colors.green,)
                                            :Icon(Icons.cancel,color: Colors.redAccent,)
                                        ),
                                        DataCell(
                                            list.orderStatus.toString()=="Ds"?
                                             Icon(Icons.check,color: Colors.green,)
                                            :Icon(Icons.cancel,color: Colors.redAccent,)
                                        ),
                                        DataCell(
                                            Text(list.LevelStatus.toString())
                                        ),
                                      ],
                                      ),).toList(),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ],
          )
      ),
    );
  }

  Stockdetalies(context,tablet,height,width) {
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width,
          height: tablet?620:height/2,
          alignment: Alignment.center,
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
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: 0,
                sortAscending: true,
                columnSpacing: tablet?25:height/20,
                dataRowHeight: tablet?42:height/30,
                headingRowHeight: tablet?30:height/25,
                headingRowColor: MaterialStateProperty.all(Colors.blue),
                showCheckboxColumn: false,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'ItemName',
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
                      'Stock',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                rows: templist.map((list) =>
                    DataRow(
                      cells: [
                        DataCell(
                          Text(list.itemName.toString()),
                        ),
                        DataCell(
                          Text(list.quantity.toString()),
                        ),
                        DataCell(
                          Text(list.Stock.toString()),
                        ),
                      ],
                    ),
                ).toList(),
              ),
            ),
          ),

        ),
      ],
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
      getlocationval();
    });
  }

  Future<http.Response> getDataTableRecord(String alterloccode) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      var tt = alterloccode== "Pr"?1:
                alterloccode== "Pr"?20:0;
      secOrderManagement.clear();
    });
    var body = {
      "FromId": 2,
      "ItemCode": 40,
      "BranchId":alterloccode,
      "DocDate":"DocDate",
      "DocNo":"DocNo"
    };
    //print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'productstockdetalies'),
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
        print('YesResponce');
        print(response.body);
        setState(() {
        RawOrderManagement = OrderManagement.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawOrderManagement.testdata.length; i++) {




          secOrderManagement.add(
              ScreenOrderManagement(
              RawOrderManagement.testdata[i].screenName,
              RawOrderManagement.testdata[i].docNo,
              RawOrderManagement.testdata[i].docDate,
              RawOrderManagement.testdata[i].locCode,
              RawOrderManagement.testdata[i].locName,
              RawOrderManagement.testdata[i].occName,
              RawOrderManagement.testdata[i].deliveryDate,
              RawOrderManagement.testdata[i].deliveryTime,
              RawOrderManagement.testdata[i].orderStatus,
              RawOrderManagement.testdata[i].docEntry.toString(),
              RawOrderManagement.testdata[i].shape.toString(),
              RawOrderManagement.testdata[i].orderStatus== "Pr"?1:
              RawOrderManagement.testdata[i].orderStatus== "Ds"?2:0,

          )
          );
        }
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
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

  Future<http.Response> getItemDetalies(DocEntry, formId) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();

    });
    var body = {
      "FromId": formId,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": DocEntry,
      "Status": "D",
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
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == '0';
      if (login == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        RawProductionTblModel = null;
        loading= false;
      } else {
        log(response.body);
        setState(() {
          RawProductionTblModel = ProductionTblModel.fromJson(jsonDecode(response.body));
          for(int i=0;i<RawProductionTblModel.testdata.length;i++){
            templist.add(
                TempTestdata(
                    RawProductionTblModel.testdata[i].itemCode,
                    RawProductionTblModel.testdata[i].itemName,
                    RawProductionTblModel.testdata[i].quantity,
                    RawProductionTblModel.testdata[i].invntryUom,
                    RawProductionTblModel.testdata[i].Stock)
            );
          }
          loading= false;
        });
      }
      return response;
    } else {

    }
  }

  NetPrinter(String iPAddress,int pORT,OrderNo,Branch,DeliveryDate,DeliveryTime,OccName,Shape) async {
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      //print('SDGVIUGSV' + iPAddress + 'pORT' + pORT.toString());
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printDemoReceipt(printer,OrderNo,Branch,DeliveryDate,DeliveryTime,OccName,Shape,);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: $e');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer,OrderNo,Branch,DeliveryDate,DeliveryTime,OccName,Shape,) async {

    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());

    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text('Sweets & Cakes', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1,fontType: PosFontType.fontB), linesAfter: 1);

    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center,bold: true));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center,bold: true), linesAfter: 1);
    printer.row([PosColumn(text: 'Sale Order - Design', width: 12, styles: PosStyles(align: PosAlign.center),),]);

    printer.row([
      PosColumn(text: 'Shop Name', width: 4, styles: PosStyles(align: PosAlign.left,)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Branch.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ],
    );


    printer.row([
        PosColumn(text: 'Sales Order', width: 4, styles: PosStyles(align: PosAlign.left,)),
        PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
        PosColumn(text: OrderNo.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
      ],
    );
    printer.row([
      PosColumn(text: 'Delivery Date', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: DeliveryDate.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Delivery Time', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: DeliveryTime.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Event Name', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: OccName.toString(), width: 7, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.row([
      PosColumn(text: "Shape", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Shape.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);


    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'Item', width: 7, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(text: 'Qty', width: 5, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),

    ]);

    for (int i = 0; i < templist.length; i++) {
      printer.row(
        [
          PosColumn(text: templist[i].itemName.toString() ,width: 7, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: templist[i].quantity.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
        ],
      );
    }
    printer.feed(2);


    List<ProQrGenerateJson> SecQrGenerateJson=[];
    SecQrGenerateJson.clear();
    var json;
    SecQrGenerateJson.add(
        ProQrGenerateJson(
            OrderNo,
            DeliveryDate,
            DeliveryDate),
    );
    json = jsonEncode(SecQrGenerateJson.map((e) => e.toJson()).toList());
    print(json);

    printer.qrcode(json);


    printer.feed(2);

    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.text(timestamp, styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.feed(1);
    printer.cut();

  }

}

class ProQrGenerateJson {
  var OrderNo;
  var OccDate;
  var DeliveryDate;
  ProQrGenerateJson(this.OrderNo, this.OccDate, this.DeliveryDate);
  Map toJson() => {
    'OrderNo': OrderNo,
    'OccDate': OccDate,
    'DeliveryDate': DeliveryDate
  };
}

class ScreenOrderManagement {
  String screenName;
  int docNo;
  String docDate;
  int locCode;
  String locName;
  String occName;
  String deliveryDate;
  String deliveryTime;
  String orderStatus;
  var docEntry;
  var shape;
  var LevelStatus;

  ScreenOrderManagement(
      this.screenName,
        this.docNo,
        this.docDate,
        this.locCode,
        this.locName,
        this.occName,
        this.deliveryDate,
        this.deliveryTime,this.orderStatus,this.docEntry,this.shape,this.LevelStatus);
}

class TempTestdata {
  var itemCode;
  var itemName;
  var quantity;
  var invntryUom;
  var Stock;

  TempTestdata(
      this.itemCode,
        this.itemName,
        this.quantity,
        this.invntryUom,
        this.Stock);
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}


