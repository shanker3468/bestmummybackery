// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/Model/VehicleModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleMaster extends StatefulWidget {
  const VehicleMaster({Key key}) : super(key: key);

  @override
  _VehicleMasterState createState() => _VehicleMasterState();
}

class _VehicleMasterState extends State<VehicleMaster> {
  TextEditingController Edt_VehicleName = new TextEditingController();
  TextEditingController Edt_Model = new TextEditingController();
  TextEditingController Edt_VehicleNumber = new TextEditingController();

  bool isUpdating = false;
  bool loading = false;
  VehicleModel detailitems;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";

  int docno = 0;
  int status = 0;

  var altervehiclename = "";
  var altervehicleno = "";
  var altermodel = "";

  @override
  void initState() {
    setState(() {
      isUpdating = false;
      getStringValuesSF();
    });
    super.initState();
  }

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        child: Scaffold(
          appBar: AppBar(
            title: Text('Vehicle Master'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
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
                              /*maxLines: 5,*/
                              maxLength: 100,
                              controller: Edt_VehicleName,
                              decoration: InputDecoration(
                                labelText: "Enter Vehicle Name",
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
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: TextField(
                              maxLength: 100,
                              /*maxLines: 5,*/
                              controller: Edt_Model,
                              decoration: InputDecoration(
                                labelText: "Enter Model",
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
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: TextField(
                              /*maxLines: 5,*/
                              maxLength: 100,
                              controller: Edt_VehicleNumber,
                              decoration: InputDecoration(
                                labelText: "Enter Vehicle No",
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
                                print('insert');

                                if (Edt_VehicleNumber.text.isEmpty ||
                                    Edt_Model.text.isEmpty ||
                                    Edt_VehicleName.text.isEmpty) {
                                  showDialogboxWarning(
                                      context, "Enter all Fields");
                                } else {
                                  print(Edt_Model.text);
                                  insertvechicle(
                                      2,
                                      0,
                                      Edt_VehicleName.text,
                                      Edt_Model.text,
                                      Edt_VehicleNumber.text,
                                      0,
                                      sessionuserID,
                                  );
                                }
                              } else {
                                if (Edt_VehicleNumber.text.isEmpty &&
                                    Edt_Model.text.isEmpty &&
                                    Edt_VehicleName.text.isEmpty) {
                                  showDialogboxWarning(
                                      context, "Enter all Fields");
                                } else {
                                  altervehiclename = Edt_VehicleName.text;
                                  altervehicleno = Edt_VehicleNumber.text;
                                  altermodel = Edt_Model.text;
                                  print('save..');
                                  updateallvechicle(
                                    3,
                                    docno,
                                    altervehiclename,
                                    altermodel,
                                    altervehicleno,
                                    status,
                                    sessionuserID,
                                  );
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
                                    'Vehicle Name',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Model',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'VehicleNo',
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

                                                  docno = list.docNo;
                                                  status =
                                                      list.status == 0 ? 1 : 0;
                                                  Edt_Model.text = list.Model;
                                                  Edt_VehicleNumber.text =
                                                      list.VehicleNo;
                                                  Edt_VehicleName.text =
                                                      list.VehicleName;
                                                }),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Center(
                                            child: Wrap(
                                              direction:
                                                  Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                  onPressed: () {
                                                    updatestatus(
                                                        4,
                                                        list.docNo,
                                                        "",
                                                        "",
                                                        "",
                                                        list.status == 0
                                                            ? 1
                                                            : 0,
                                                        sessionuserID);
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
                                            Text(list.VehicleName.toString(),
                                                textAlign: TextAlign.left)
                                          ])),
                                      DataCell(
                                        Center(
                                            child: Wrap(
                                                direction:
                                                    Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                              Text(list.Model.toString(),
                                                  textAlign: TextAlign.center)
                                            ])),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Wrap(
                                                direction:
                                                    Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                              Text(list.VehicleNo.toString(),
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
            ),
          ),
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
      print('USERID$sessionuserID');
      getvalues();
    });
  }

  void getvalues() {
    setState(() {
      loading = true;
    });
    INSERTVEHICLEMASTER(1, 0, "", "", "", 0, int.parse(sessionuserID))
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
            detailitems = VehicleModel.fromJson(jsonDecode(response.body));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void insertvechicle(FormID, DocNo, VehicleName, VehicleModel, VehicleNum, Status, UserID) {
    setState(() {
      loading = true;
    });
    INSERTVEHICLEMASTER(FormID, DocNo, VehicleName, VehicleModel, VehicleNum, Status, UserID)
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
        } else {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => VehicleMaster()));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void updateallvechicle(
      FormID, DocNo, VehicleName, VehicleModel, VehicleNum, Status, UserID) {
    setState(() {
      loading = true;
    });
    INSERTVEHICLEMASTER(FormID, DocNo, VehicleName, VehicleModel, VehicleNum,
            Status, UserID)
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
        } else {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VehicleMaster(),
              ),
            );
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void updatestatus(
      FormID, DocNo, VehicleName, VehicleModel, VehicleNum, Status, UserID) {
    setState(() {
      loading = true;
    });
    INSERTVEHICLEMASTER(FormID, DocNo, VehicleName, VehicleModel, VehicleNum,
            Status, UserID)
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
        } else {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          setState(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => VehicleMaster()));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }
}
