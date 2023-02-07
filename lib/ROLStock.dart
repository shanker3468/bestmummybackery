// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/ROLLocationWise.dart';
import 'package:bestmummybackery/Model/ROLStockWise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bestmummybackery/Model/ROLStockModel.dart';
//import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//import 'package:syncfusion_flutter_core/theme.dart';
import 'package:http/http.dart' as http;

class ROLStock extends StatefulWidget {
  const ROLStock({Key key}) : super(key: key);

  @override
  _ROLStockState createState() => _ROLStockState();
}

class _ROLStockState extends State<ROLStock> {
  ROLStockModel li2;
  ROLLocationWise li3;
  ROLStockWise li4;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  TextEditingController searchcontroller = new TextEditingController();
  var _searchResult = "";
  //int _currentSortColumn = 0;
  //bool _isAscending = true;
  bool loading = false;
  int first = 0;
  //List<FILETRResult> paginationlist = new List();
  var clickitemcode = "";
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);

    //final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ROL STOCK'),
      ),
      body: !loading
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  children: [
                    Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: searchcontroller,
                          decoration: new InputDecoration(hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _searchResult = value;
                              print(_searchResult);
                            });
                          },
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: li2 != null
                            ? DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                columnSpacing: 30,
                                dataRowHeight: 60,
                                headingRowColor: MaterialStateProperty.all(Colors.blue),
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'ROL',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Stock',
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
                                      'Item Group',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                rows: li2.result.where((element) => (element.uItemName.toLowerCase().contains(_searchResult.toLowerCase())) ||
                                        (element.itmsGrpNam.toLowerCase().contains(_searchResult.toLowerCase())))
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            color: Colors.blue,
                                            onPressed: () {
                                              print("Pressed");
                                              setState(() {
                                                clickitemcode = list.uItemCode;
                                                getrollistlocationwise(clickitemcode).then(
                                                  (value) => showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
                                                    builder: (BuildContext context) {
                                                      return Scaffold(
                                                        body: StatefulBuilder(
                                                          builder: (BuildContext context,
                                                              void Function(void Function()) setState) {
                                                            return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.arrow_back,
                                                                    size: 30,
                                                                    color: Colors.blue,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: width,
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.vertical,
                                                                    child: li3 != null
                                                                        ? DataTable(
                                                                            sortColumnIndex: 0,
                                                                            sortAscending: true,
                                                                            columnSpacing: 30,
                                                                            dataRowHeight: 60,
                                                                            headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                                            showCheckboxColumn: false,
                                                                            columns: const <DataColumn>[
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Item Name',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Location',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Day',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Maximum',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Minimum',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'UOM',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                            rows: li3.result
                                                                                .map(
                                                                                  (list) => DataRow(cells: [
                                                                                    DataCell(Padding(padding: EdgeInsets.only(top: 5), child: Text(list.uItemName))),
                                                                                    DataCell(
                                                                                      Text(list.uLocation, textAlign: TextAlign.center),
                                                                                    ),
                                                                                    DataCell(
                                                                                      Text(list.wEEKDAYS, textAlign: TextAlign.center),
                                                                                    ),
                                                                                    DataCell(
                                                                                      Text(list.uMax.toString(), textAlign: TextAlign.center),
                                                                                    ),
                                                                                    DataCell(
                                                                                      Text(list.uMin.toString(), textAlign: TextAlign.center),
                                                                                    ),
                                                                                    DataCell(
                                                                                      Text(list.uUOM.toString(), textAlign: TextAlign.center),
                                                                                    ),
                                                                                  ]),
                                                                                )
                                                                                .toList(),
                                                                          )
                                                                        : Container(
                                                                            child:
                                                                                Center(
                                                                              child: Text('No Data Found!'),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                        DataCell(
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            color: Colors.blue,
                                            onPressed: () {
                                              print("Pressed");
                                              setState(() {
                                                clickitemcode = list.uItemCode;
                                                getrolliststockwise(clickitemcode).then(
                                                  (value) => showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
                                                    builder: (BuildContext context) {
                                                      return Scaffold(
                                                        body: StatefulBuilder(
                                                          builder: (BuildContext context,
                                                              void Function( void Function()) setState) {
                                                            return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.arrow_back,
                                                                    size: 30,
                                                                    color: Colors.blue,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: width,
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.vertical,
                                                                    child: li4 != null
                                                                        ? DataTable(
                                                                            sortColumnIndex: 0,
                                                                            sortAscending: true,
                                                                            columnSpacing: 30,
                                                                            dataRowHeight: 60,
                                                                            headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                                            showCheckboxColumn: false,
                                                                            columns: const <DataColumn>[
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Item Name',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Warehouse',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'Stock',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              DataColumn(
                                                                                label: Text(
                                                                                  'UOM',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                            rows: li4.result
                                                                                .map(
                                                                                  (list) => DataRow(cells: [
                                                                                    DataCell(Padding(padding: EdgeInsets.only(top: 5), child: Text(list.uItemName))),
                                                                                    DataCell(
                                                                                      Text(list.uWhsName, textAlign: TextAlign.center),
                                                                                    ),
                                                                                    DataCell(
                                                                                      Text(list.onHand.toString(), textAlign: TextAlign.center),
                                                                                    ),
                                                                                    DataCell(
                                                                                      Text(list.uUOM.toString(), textAlign: TextAlign.center),
                                                                                    ),
                                                                                  ]),
                                                                                )
                                                                                .toList(),
                                                                          )
                                                                        : Container(
                                                                            child:
                                                                                Center(
                                                                              child: Text('No Data Found!'),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                        DataCell(Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(list.uItemName))),
                                        DataCell(
                                          Text(list.itmsGrpNam,
                                              textAlign: TextAlign.center),
                                        ),
                                      ]),
                                    )
                                    .toList(),
                              )
                            : Container(
                                child: Center(
                                  child: Text('No Data Found!'),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
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
      print('USERID$sessionuserID');
      first = 1;
      getpendinglist();
    });
  }

  Future<http.Response> getpendinglist() async {
    print('inside');
    var headers = {"Content-Type": "application/json"};

    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getrollist'),
          headers: headers);
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
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
        } else {
          try {
            print(jsonDecode(response.body)["result"]);
            li2 = ROLStockModel.fromJson(jsonDecode(response.body));
          } on Exception catch (e) {
            print(e.toString());
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
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

  Future<http.Response> getrollistlocationwise(String ItemCode) async {
    print('inside');
    var headers = {"Content-Type": "application/json"};
    var body = {"ItemCode": ItemCode};
    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getrollistlocationwise'),
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
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          try {
            print(jsonDecode(response.body)["result"]);
            li3 = ROLLocationWise.fromJson(jsonDecode(response.body));
          } on Exception catch (e) {
            print(e.toString());
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
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

  Future<http.Response> getrolliststockwise(String ItemCode) async {
    //print('inside');
    var headers = {"Content-Type": "application/json"};
    var body = {"ItemCode": ItemCode};
    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getrolliststock'),
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
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          try {
            print(jsonDecode(response.body)["result"]);
            li4 = ROLStockWise.fromJson(jsonDecode(response.body));
          } on Exception catch (e) {
            print(e.toString());
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
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
}
