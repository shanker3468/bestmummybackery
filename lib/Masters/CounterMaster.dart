// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/CounterModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterMaster extends StatefulWidget {
  const CounterMaster({Key key}) : super(key: key);

  @override
  _CounterMasterState createState() => _CounterMasterState();
}

class _CounterMasterState extends State<CounterMaster> {
  TextEditingController Edt_CounterName = new TextEditingController();
  TextEditingController Edt_ImeiNumber = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  LocationModel locationModel = new LocationModel();
  EmpModel empModel = new EmpModel();

  List<String> loc = new List();

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  bool isUpdating;
  bool loading = false;
  CounterModel detailitems;

  @override
  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocation();
    super.initState();
  }

  var docno = 0;
  var FormID = 0;
  String alterlocname = "";
  String alterloccode = "";
  String alterimei = "";
  int status = 0;
  String altercountername = "";

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return tablet
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Counter MASTER"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                          new Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              child: DropdownSearch<String>(
                                                //mode of dropdown
                                                mode: Mode.DIALOG,
                                                //to show search box
                                                showSearchBox: true,
                                                items: loc,
                                                label: "Select Location",
                                                onChanged: (val) {
                                                  print(val);
                                                  for (int kk = 0;
                                                      kk <
                                                          locationModel
                                                              .result.length;
                                                      kk++) {
                                                    if (locationModel
                                                            .result[kk].name ==
                                                        val) {
                                                      print(locationModel
                                                          .result[kk].code);
                                                      alterlocname =
                                                          locationModel
                                                              .result[kk].name;
                                                      alterloccode =
                                                          locationModel
                                                              .result[kk].code
                                                              .toString();
                                                    }
                                                  }
                                                },
                                                selectedItem: alterlocname,
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
                                                child: TextField(
                                                  /*maxLines: 5,*/
                                                  controller: Edt_CounterName,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Enter Counter Name",
                                                    border:
                                                        OutlineInputBorder(),
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
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: TextField(
                                                  /*maxLines: 5,*/
                                                  controller: Edt_ImeiNumber,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Enter ImeiNumber",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FloatingActionButton.extended(
                                            heroTag: "Cancel",
                                            backgroundColor: Colors.red,
                                            icon: Icon(Icons.clear),
                                            label: Text('Cancel'),
                                            onPressed: () {
                                              print(
                                                  'FloatingActionButton clicked');
                                            },
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          FloatingActionButton.extended(
                                            heroTag: "isUpdating",
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            icon: Icon(Icons.check),
                                            label: Text(
                                                isUpdating ? 'UPDATE' : 'ADD'),
                                            onPressed: () {
                                              if (!isUpdating) {
                                                print(alterloccode);
                                                if (Edt_CounterName
                                                        .text.isEmpty &&
                                                    Edt_ImeiNumber
                                                        .text.isEmpty) {
                                                  showDialogboxWarning(context,
                                                      "Please Enter All Fields ");
                                                } else if (alterloccode
                                                    .isEmpty) {
                                                  showDialogboxWarning(context,
                                                      "Please Choose Location ");
                                                } else {
                                                  status = 0;
                                                  altercountername =
                                                      Edt_CounterName.text;
                                                  alterimei =
                                                      Edt_ImeiNumber.text;
                                                  print('Insert Mode');
                                                  insert(
                                                      2,
                                                      //INSERT All
                                                      0,
                                                      alterloccode,
                                                      alterlocname,
                                                      altercountername,
                                                      alterimei,
                                                      0,
                                                      int.parse(sessionuserID));
                                                }
                                              } else {
                                                if (Edt_CounterName
                                                        .text.isEmpty &&
                                                    Edt_ImeiNumber
                                                        .text.isEmpty &&
                                                    alterloccode.isEmpty) {
                                                  showDialogboxWarning(context,
                                                      "Please Enter All Fields ");
                                                } else {
                                                  altercountername =
                                                      Edt_CounterName.text;
                                                  alterimei =
                                                      Edt_ImeiNumber.text;
                                                  insert(
                                                      4,
                                                      //UPdate All
                                                      docno,
                                                      alterloccode,
                                                      alterlocname,
                                                      altercountername,
                                                      alterimei,
                                                      0,
                                                      int.parse(sessionuserID));
                                                  print('updatemode');
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: width,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: detailitems.toString() ==
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
                                                        'Edit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Active/InActive',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Location',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Counter',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: detailitems.result
                                                      .map(
                                                        (list) => DataRow(
                                                          cells: [
                                                            DataCell(
                                                              Center(
                                                                child: Center(
                                                                  child: IconButton(
                                                                      icon: Icon(Icons.create),
                                                                      color: Colors.red,
                                                                      onPressed: () {
                                                                        setState(
                                                                            () {
                                                                          isUpdating =
                                                                              true;
                                                                        });
                                                                        alterlocname =
                                                                            "";
                                                                        alterloccode =
                                                                            "";

                                                                        alterlocname =
                                                                            list.locationName;
                                                                        alterloccode =
                                                                            list.locationCode;
                                                                        alterimei =
                                                                            list.systemIpAddress;
                                                                        docno =
                                                                            list.docNo;
                                                                        status =
                                                                            list.status;

                                                                        Edt_ImeiNumber.text =
                                                                            list.systemIpAddress;
                                                                        Edt_CounterName.text =
                                                                            list.counterName;
                                                                      }),
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                child: Center(
                                                                  child: Wrap(
                                                                    direction: Axis
                                                                        .vertical, //default
                                                                    alignment:
                                                                        WrapAlignment
                                                                            .center,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(primary: list.status ==
                                                                  0
                                                                  ? Colors.greenAccent
                                                                      : Colors.redAccent,textStyle: TextStyle(color: Colors.white)),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            docno =
                                                                                list.docNo;
                                                                            status = list.status == 0
                                                                                ? 1
                                                                                : 0;
                                                                          });
                                                                          insert(
                                                                              3,
                                                                              //
                                                                              list.docNo,
                                                                              alterloccode,
                                                                              alterlocname,
                                                                              altercountername,
                                                                              alterimei,
                                                                              list.status == 0 ? 1 : 0,
                                                                              int.parse(sessionuserID));
                                                                        },
                                                                        child: Text((list.status ==
                                                                                0
                                                                            ? 'Click to Disable'
                                                                            : 'Click to Enable')),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
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
                                                                  Text(
                                                                      list.locationName
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left)
                                                                ],
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                child: Wrap(
                                                                  direction: Axis
                                                                      .vertical, //default
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        list.counterName
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.center)
                                                                  ],
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
          )
        : Container(
            child: Column(
              children: [
                Row(
                  children: [
                    //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: DropdownSearch<String>(
                          //mode of dropdown
                          mode: Mode.DIALOG,
                          //to show search box
                          showSearchBox: true,
                          items: loc,
                          label: "Select Location",
                          onChanged: (val) {
                            print(val);
                            for (int kk = 0;
                                kk < locationModel.result.length;
                                kk++) {
                              if (locationModel.result[kk].name == val) {
                                print(locationModel.result[kk].code);
                                alterlocname = locationModel.result[kk].name;
                                alterloccode =
                                    locationModel.result[kk].code.toString();
                              }
                            }
                          },
                          selectedItem: alterlocname,
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
                          child: TextField(
                            /*maxLines: 5,*/
                            controller: Edt_CounterName,
                            decoration: InputDecoration(
                              labelText: "Enter Counter Name",
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
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: TextField(
                            /*maxLines: 5,*/
                            controller: Edt_ImeiNumber,
                            decoration: InputDecoration(
                              labelText: "Enter ImeiNumber",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    new Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                          child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                          onPressed: () {
                            if (!isUpdating) {
                              print(alterloccode);
                              if (Edt_CounterName.text.isEmpty &&
                                  Edt_ImeiNumber.text.isEmpty) {
                                showDialogboxWarning(
                                    context, "Please Enter All Fields ");
                              } else if (alterloccode.isEmpty) {
                                showDialogboxWarning(
                                    context, "Please Choose Location ");
                              } else {
                                status = 0;
                                altercountername = Edt_CounterName.text;
                                alterimei = Edt_ImeiNumber.text;
                                print('Insert Mode');
                                insert(
                                    2,
                                    //INSERT All
                                    0,
                                    alterloccode,
                                    alterlocname,
                                    altercountername,
                                    alterimei,
                                    0,
                                    int.parse(sessionuserID));
                              }
                            } else {
                              if (Edt_CounterName.text.isEmpty &&
                                  Edt_ImeiNumber.text.isEmpty &&
                                  alterloccode.isEmpty) {
                                showDialogboxWarning(
                                    context, "Please Enter All Fields ");
                              } else {
                                altercountername = Edt_CounterName.text;
                                alterimei = Edt_ImeiNumber.text;
                                insert(
                                    4,
                                    //UPdate All
                                    docno,
                                    alterloccode,
                                    alterlocname,
                                    altercountername,
                                    alterimei,
                                    0,
                                    int.parse(sessionuserID));
                                print('updatemode');
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red,textStyle: TextStyle(color: Colors.white)),
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: detailitems.toString() == "null"
                        ? Center(
                            child: Text('No Data Add!'),
                          )
                        : DataTable(
                            sortColumnIndex: 0,
                            sortAscending: true,
                            headingRowColor:
                                MaterialStateProperty.all(Pallete.mycolor),
                            showCheckboxColumn: false,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Active/InActive',
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
                                  'Counter',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            rows: detailitems.result
                                .map(
                                  (list) => DataRow(cells: [
                                    DataCell(
                                      Center(
                                        child: Center(
                                          child: IconButton(
                                              icon: Icon(Icons.create),
                                              color: Colors.red,
                                              onPressed: () {
                                                setState(() {
                                                  isUpdating = true;
                                                });
                                                alterlocname = "";
                                                alterloccode = "";

                                                alterlocname =
                                                    list.locationName;
                                                alterloccode =
                                                    list.locationCode;
                                                alterimei =
                                                    list.systemIpAddress;
                                                docno = list.docNo;
                                                status = list.status;

                                                Edt_ImeiNumber.text =
                                                    list.systemIpAddress;
                                                Edt_CounterName.text =
                                                    list.counterName;
                                              }),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                onPressed: () {
                                                  setState(() {
                                                    docno = list.docNo;
                                                    status = list.status == 0
                                                        ? 1
                                                        : 0;
                                                  });
                                                  insert(
                                                      3,
                                                      //
                                                      list.docNo,
                                                      alterloccode,
                                                      alterlocname,
                                                      altercountername,
                                                      alterimei,
                                                      list.status == 0 ? 1 : 0,
                                                      int.parse(sessionuserID));
                                                },
                                                child: Text((list.status == 0
                                                    ? 'Click to Disable'
                                                    : 'Click to Enable')),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Wrap(
                                        direction: Axis.vertical, //default
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(list.locationName.toString(),
                                              textAlign: TextAlign.left)
                                        ])),
                                    DataCell(
                                      Center(
                                          child: Wrap(
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                            Text(list.counterName.toString(),
                                                textAlign: TextAlign.center)
                                          ])),
                                    ),
                                  ]),
                                )
                                .toList(),
                          ),
                  ),
                ),
              ],
            ),
          );
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        setState(() {
          isUpdating = false;
        });
      } else {
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => OSRDMaster()));*/
      }
    }
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
      getvalues();
    });
  }

  void getvalues() {
    setState(() {
      loading = true;
    });
    INSERTCOUNTER(1, 0, "", "", "", "", 0, int.parse(sessionuserID))
        .then((response) {
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
          detailitems.result.clear();
        } else {
          setState(() {
            detailitems = CounterModel.fromJson(jsonDecode(response.body));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void insert(int FormID, int DocNo, String LocCode, String LocName,
      String CounterName, String Imei, int Status, int UserID) {
    INSERTCOUNTER(
            FormID, DocNo, LocCode, LocName, CounterName, Imei, Status, UserID)
        .then((response) {
      print(INSERTCOUNTER);
      print(response.body);
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        print(response.body);
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CounterMaster()));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getlocation() {
    GETLocationAPI().then((response) {
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
          locationModel.result.clear();
          loc.clear();
        } else {
          locationModel = LocationModel.fromJson(jsonDecode(response.body));
          loc.clear();
          for (int k = 0; k < locationModel.result.length; k++) {
            loc.add(locationModel.result[k].name);
          }
          print(locationModel);
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }
}
