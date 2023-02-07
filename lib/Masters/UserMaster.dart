import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Masters/RollmasterModel.dart';
import 'package:bestmummybackery/Masters/UsersMasterModel.dart';
import 'package:bestmummybackery/Model/EditUsermasterModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMaster extends StatefulWidget {
  const UserMaster({Key key}) : super(key: key);

  @override
  _UserMasterState createState() => _UserMasterState();
}

class _UserMasterState extends State<UserMaster> {
  TextEditingController Edt_UserName = new TextEditingController();
  TextEditingController Edt_Password = new TextEditingController();

  LocationModel locationModel = new LocationModel();
  EmpModel empModel = new EmpModel();

  List<String> loc = new List();
  List<String> emplist = new List();
  List<String> managerlist = new List();
  List<String> approverlist = new List();

  String alterlocname = "";
  String alterloccode = "";
  String altercashaccountcode = "";
  String altercashaccountname = "";

  String alterpettycashaccountname = "";
  String alterpettycashaccountcode = "";
  String alterKotname = "";
  String alterKotcode = "";
  var alterRollcode=0;
  var alterRollName="";

  String empcode = "";
  String empname = "";

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";

  var alterempname = "";
  var alterempid = "";

  var altermanagercode = "";
  var altermanagername = "";

  var alterapprname = "";
  var alterapprcode = "";
  bool _obscureText = true;
  bool loading = false;
  int formid = 0;
  var status = 0;
  UsersMasterModel usersmodel;
  EditUsermasterModel RawEditUsermasterModel;
  RollmasterModel RawRollmasterModel;
  List<String> rolllist = new List();
  bool isUpdating = false;
  int docno = 0;
  @override
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

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return !tablet
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("User MASTER"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
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
                                          if (locationModel.result[kk].name ==
                                              val) {
                                            print(
                                                locationModel.result[kk].code);
                                            alterlocname =
                                                locationModel.result[kk].name;
                                            alterloccode = locationModel
                                                .result[kk].code
                                                .toString();
                                          }
                                        }
                                      },
                                      selectedItem: alterlocname,
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
                                        controller: Edt_UserName,
                                        decoration: InputDecoration(
                                          labelText: "Enter User Name",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            SizedBox(
                              //Use of SizedBox
                              height: 10,
                            ),
                            Row(
                              children: [
                                //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                new Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextField(
                                        /*maxLines: 5,*/
                                        controller: Edt_Password,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: "Enter Password",
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
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
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.BOTTOM_SHEET,
                                      showSearchBox: true,
                                      items: emplist,
                                      label: "Select EmployeeName",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;
                                            kk < empModel.result.length;
                                            kk++) {
                                          if (empModel.result[kk].name == val) {
                                            print(empModel.result[kk].empID);
                                            alterempname =
                                                empModel.result[kk].name;
                                            alterempid = empModel
                                                .result[kk].empID
                                                .toString();
                                          }
                                        }
                                      },
                                      selectedItem: alterempname,
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
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      //mode of dropdown
                                      mode: Mode.BOTTOM_SHEET,
                                      //to show search box
                                      showSearchBox: true,
                                      items: managerlist,
                                      label: "Select Manager",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;
                                            kk < locationModel.result.length;
                                            kk++) {
                                          if (locationModel.result[kk].name ==
                                              val) {
                                            print(
                                                locationModel.result[kk].code);
                                            altermanagername =
                                                locationModel.result[kk].name;
                                            altermanagercode = locationModel
                                                .result[kk].code
                                                .toString();
                                          }
                                        }
                                      },

                                      selectedItem: alterlocname,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      //mode of dropdown
                                      mode: Mode.DIALOG,
                                      //to show search box
                                      showSearchBox: true,
                                      items: approverlist,
                                      label: "Approval Manager",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;
                                            kk < locationModel.result.length;
                                            kk++) {
                                          if (locationModel.result[kk].name ==
                                              val) {
                                            print(
                                                locationModel.result[kk].code);
                                            alterapprname =
                                                locationModel.result[kk].name;
                                            alterapprcode = locationModel
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
                                      label: "Cash Account",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;
                                            kk < locationModel.result.length;
                                            kk++) {
                                          if (locationModel.result[kk].name ==
                                              val) {
                                            print(
                                                locationModel.result[kk].code);
                                            alterlocname =
                                                locationModel.result[kk].name;
                                            alterloccode = locationModel
                                                .result[kk].code
                                                .toString();
                                          }
                                        }
                                      },
                                      selectedItem: alterlocname,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
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
                                      label: "Petty Cash Account",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;
                                            kk < locationModel.result.length;
                                            kk++) {
                                          if (locationModel.result[kk].name ==
                                              val) {
                                            print(
                                                locationModel.result[kk].code);
                                            alterlocname =
                                                locationModel.result[kk].name;
                                            alterloccode = locationModel
                                                .result[kk].code
                                                .toString();
                                          }
                                        }
                                      },
                                      selectedItem: alterlocname,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
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
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      //mode of dropdown
                                      mode: Mode.DIALOG,
                                      //to show search box
                                      showSearchBox: true,
                                      items: loc,
                                      label: "KOT",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;
                                            kk < locationModel.result.length;
                                            kk++) {
                                          if (locationModel.result[kk].name ==
                                              val) {
                                            print(
                                                locationModel.result[kk].code);
                                            alterlocname =
                                                locationModel.result[kk].name;
                                            alterloccode = locationModel
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
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
                                  label: Text(isUpdating ? 'UPDATE' : 'ADD'),
                                  onPressed: () {
                                    formid = 1;
                                    getlist();
                                  },
                                ),
                              ],
                            ),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    print('Button Clicked');
                                    formid = 1;
                                    getlist();
                                  },
                                  child: Text('Save '),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    print('Button Clicked');
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                ),
                              ],
                            ),*/
                            Container(
                              width: width,
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: usersmodel == null
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              columnSpacing: 30,
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Location Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      'User Name',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Password',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Emp.Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Manager Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Approver Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: usersmodel.result
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              formid = 2;
                                                              docno =
                                                                  list.docNo;
                                                              getlist();
                                                            },
                                                            child: Text(list
                                                                        .status
                                                                        .toString() ==
                                                                    "99"
                                                                ? "Enable"
                                                                : "Disabled")),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Text(
                                                            "${list.locationName}"),
                                                      )),
                                                      DataCell(Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Text(
                                                            "${list.userName.toString()}"),
                                                      )),
                                                      DataCell(
                                                        Wrap(
                                                            direction:
                                                                Axis.vertical,
                                                            //default
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  list.userPassword
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center)
                                                            ]),
                                                      ),
                                                      DataCell(
                                                        Center(
                                                            child: Center(
                                                                child: Wrap(
                                                                    direction: Axis
                                                                        .vertical,
                                                                    //default
                                                                    alignment: WrapAlignment.center,
                                                                    children: [
                                                              Text(list.empName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center)
                                                            ]))),
                                                      ),
                                                      DataCell(
                                                        Center(
                                                            child: Center(
                                                                child: Wrap(
                                                                    direction: Axis
                                                                        .vertical,
                                                                    //default
                                                                    alignment: WrapAlignment.center,
                                                                    children: [
                                                              Text(
                                                                  list
                                                                      .managerName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center)
                                                            ]))),
                                                      ),
                                                      DataCell(
                                                        Center(
                                                            child: Center(
                                                                child: Wrap(
                                                                    direction: Axis
                                                                        .vertical,
                                                                    //default
                                                                    alignment: WrapAlignment.center,
                                                                    children: [
                                                              Text(
                                                                  list
                                                                      .apprManagerName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center)
                                                            ]))),
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
                          ],
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("User MASTER"),
                ),
                body: !loading
                    ? Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                      Expanded(
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
                                                  alterlocname = locationModel
                                                      .result[kk].name;
                                                  alterloccode = locationModel
                                                      .result[kk].code
                                                      .toString();
                                                }
                                              }
                                            },
                                            selectedItem: alterlocname,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: InkWell(
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.white,
                                            child: TextField(
                                              /*maxLines: 5,*/
                                              controller: Edt_UserName,
                                              decoration: InputDecoration(
                                                labelText: "Enter User Name",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                      new Expanded(
                                        flex: 5,
                                        child: InkWell(
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.white,
                                            child: TextField(
                                              /*maxLines: 5,*/
                                              controller: Edt_Password,
                                              obscureText: _obscureText,
                                              decoration: InputDecoration(
                                                labelText: "Enter Password",
                                                border: OutlineInputBorder(),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    // Based on passwordVisible state choose the icon
                                                    _obscureText
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                                  onPressed: () {
                                                    // Update the state i.e. toogle the state of passwordVisible variable
                                                    setState(() {
                                                      _obscureText =
                                                          !_obscureText;
                                                    });
                                                  },
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
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.BOTTOM_SHEET,
                                            showSearchBox: true,
                                            items: emplist,
                                            label: "Select EmployeeName",
                                            onChanged: (val) {
                                              print(val);
                                              for (int kk = 0;
                                                  kk < empModel.result.length;
                                                  kk++) {
                                                if (empModel.result[kk].name ==
                                                    val) {
                                                  print(empModel
                                                      .result[kk].empID);
                                                  alterempname =
                                                      empModel.result[kk].name;
                                                  alterempid = empModel
                                                      .result[kk].empID
                                                      .toString();
                                                }
                                              }
                                            },
                                            selectedItem: alterempname,
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
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            //mode of dropdown
                                            mode: Mode.BOTTOM_SHEET,
                                            //to show search box
                                            showSearchBox: true,
                                            items: managerlist,
                                            label: "Select Manager",
                                            onChanged: (val) {
                                              print(val);
                                              setState(() {
                                                for (int kk = 0;
                                                    kk < empModel.result.length;
                                                    kk++) {
                                                  if (empModel
                                                          .result[kk].name ==
                                                      val) {
                                                    altermanagername = empModel
                                                        .result[kk].name;
                                                    altermanagercode = empModel
                                                        .result[kk].empID
                                                        .toString();
                                                    print(altermanagercode);
                                                  }
                                                }
                                              });
                                            },

                                            selectedItem: altermanagername,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      new Expanded(
                                        flex: 5,
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            //mode of dropdown
                                            mode: Mode.DIALOG,
                                            //to show search box
                                            showSearchBox: true,
                                            items: approverlist,
                                            label: "Approval Manager",
                                            onChanged: (val) {
                                              print(val);
                                              setState(() {
                                                for (int kk = 0;
                                                    kk < empModel.result.length;
                                                    kk++) {
                                                  if (empModel
                                                          .result[kk].name ==
                                                      val) {
                                                    alterapprname = empModel
                                                        .result[kk].name;
                                                    alterapprcode = empModel
                                                        .result[kk].empID
                                                        .toString();
                                                  }
                                                }
                                              });
                                            },
                                            selectedItem: alterapprname,
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
                                            label: "Cash Account",
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
                                                  altercashaccountname =
                                                      locationModel
                                                          .result[kk].name;
                                                  altercashaccountcode =
                                                      locationModel
                                                          .result[kk].code
                                                          .toString();
                                                }
                                              }
                                            },
                                            selectedItem: altercashaccountname,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
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
                                            label: "Petty Cash Account",
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
                                                  alterpettycashaccountname =
                                                      locationModel
                                                          .result[kk].name;
                                                  alterpettycashaccountcode =
                                                      locationModel
                                                          .result[kk].code
                                                          .toString();
                                                }
                                              }
                                            },
                                            selectedItem:
                                                alterpettycashaccountname,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
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
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            //mode of dropdown
                                            mode: Mode.DIALOG,
                                            //to show search box
                                            showSearchBox: true,
                                            items: loc,
                                            label: "KOT",
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
                                                  alterKotname = locationModel
                                                      .result[kk].name;
                                                  alterKotcode = locationModel
                                                      .result[kk].code
                                                      .toString();
                                                }
                                              }
                                            },
                                            selectedItem: alterKotname,
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
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            //mode of dropdown
                                            mode: Mode.DIALOG,
                                            //to show search box
                                            showSearchBox: true,
                                            items: rolllist,
                                            label: "Roll",
                                            onChanged: (val) {
                                              print(val);
                                              for (int kk = 0;kk <RawRollmasterModel.result.length;kk++) {
                                                if (RawRollmasterModel.result[kk].rallName == val) {
                                                  print(locationModel.result[kk].code);
                                                  alterRollName = RawRollmasterModel.result[kk].rallName;
                                                  alterRollcode = RawRollmasterModel.result[kk].docNo;
                                                }
                                              }
                                            },
                                            selectedItem: alterRollName,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /*Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        onPressed: () {
                                          print('Button Clicked');
                                          formid = 1;
                                          getlist();
                                        },
                                        child: Text('Save '),
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(12, 12, 12, 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          print('Button Clicked');
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(12, 12, 12, 12),
                                      ),
                                    ],
                                  ),*/
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FloatingActionButton.extended(
                                        backgroundColor: Colors.red,
                                        icon: Icon(Icons.clear),
                                        label: Text('Cancel'),
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
                                        label:
                                            Text(isUpdating ? 'UPDATE' : 'ADD'),
                                        onPressed: () {
                                          print(altermanagercode);
                                          print(alterapprcode);
                                          if (alterlocname == '') {
                                            Fluttertoast.showToast(
                                                msg: "Please Choose Location");
                                          } else if (Edt_UserName.text == '') {
                                            Fluttertoast.showToast(
                                                msg: "Please Enter UserName");
                                          } else if (Edt_UserName.text == '') {
                                            Fluttertoast.showToast(
                                                msg: "Please Enter PassWord");
                                          } else if (alterempname == '') {
                                            Fluttertoast.showToast(
                                                msg: "Please Choose Employee");
                                          } else if (altermanagercode == '') {
                                            Fluttertoast.showToast(
                                                msg: "Please Choose Manager");
                                          } else if (alterapprname == '') {
                                            Fluttertoast.showToast(msg: "Please Choose Approval Maneger");
                                          } else if (altercashaccountname == '') {
                                            Fluttertoast.showToast(
                                                msg: "Please Choose Cash Account");
                                          } else if (alterpettycashaccountname == '') {
                                            Fluttertoast.showToast(msg: "Please Choose Petty Cash Account");
                                          } else if (alterKotname == '') {
                                            Fluttertoast.showToast(msg: "Please Choose KOT");
                                          } else if (alterRollName == '' && alterRollcode==0) {
                                            Fluttertoast.showToast(msg: "Please Choose Roll");
                                          }



                                          else {
                                            if(isUpdating){

                                              print("Update Mode");
                                              setState(() {
                                                formid = 5;
                                                getlist();
                                              });

                                            }else{

                                              setState(() {
                                                int check=0;

                                                // for(int i = 0;i<usersmodel.result.length;i++){
                                                //   if(usersmodel.result[i].empCode==alterempid
                                                //     &&usersmodel.result[i].empName==alterempname){
                                                //     setState(() {
                                                //       check=100;
                                                //     });
                                                //
                                                //   }
                                                // }

                                                if(check==100){
                                                  print("NO Save");
                                                  Fluttertoast.showToast(msg: "Employee Already Add");

                                                }else{
                                                  formid = 1;
                                                  print("Save etnhethh");
                                                  getlist();
                                                }
                                              });

                                            }
                                          }
                                          //
                                          // formid = 1;
                                          // getlist();
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
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: usersmodel == null
                                      ? Center(
                                          child: Text('No Data Add!'),
                                        )
                                      : DataTable(
                                          sortColumnIndex: 0,
                                          sortAscending: true,
                                          columnSpacing: 20,
                                          headingRowColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue),
                                          showCheckboxColumn: false,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Location Name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Center(
                                                child: Text(
                                                  'User Name',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Password',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Emp.Name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Manager Name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Approver Name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                          rows: usersmodel.result
                                              .map(
                                                (list) => DataRow(cells: [
                                                  DataCell(Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            top: 5),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            primary: list.status.toString() == "99"
                                                                ? Colors.redAccent
                                                                : Colors.greenAccent),
                                                        onPressed: () {
                                                          status = list.status.toString() == "99"
                                                              ? 0 : 99;
                                                          formid = 2;
                                                          docno = list.docNo;
                                                          getlist();
                                                        },
                                                        child: Text(list.status.toString() == "99"
                                                            ? "Enable" : "Disabled")),
                                                  )),
                                                  DataCell(Text(
                                                      "${list.locationName}"),
                                                    showEditIcon: true,
                                                    onTap: (){
                                                    formid = 4;
                                                    docno = list.docNo;
                                                    getlist();

                                                  },),
                                                  DataCell(Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                        "${list.userName.toString()}"),
                                                  )),
                                                  DataCell(
                                                    Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        //default
                                                        alignment:
                                                            WrapAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              list.userPassword
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                        ]),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        //default
                                                        alignment:
                                                            WrapAlignment
                                                                .center,
                                                        children: [
                                                          Text(list.empName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                        ]),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        //default
                                                        alignment:
                                                            WrapAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              list
                                                                  .managerName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                        ]),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        //default
                                                        alignment:
                                                            WrapAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              list
                                                                  .apprManagerName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                        ]),
                                                  ),
                                                ]),
                                              )
                                              .toList(),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
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
      getlocation();
      getemp();
      getmanager();
      getapprover();
      getrollmaster();
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

  void getemp() {
    GETUserMasterAPI(1, sessionuserID).then((response) {
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
          empModel.result.clear();
          emplist.clear();
        } else {
          empModel = EmpModel.fromJson(jsonDecode(response.body));
          emplist.clear();
          for (int k = 0; k < empModel.result.length; k++) {
            emplist.add(empModel.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getmanager() {
    GETUserMasterAPI(2, sessionuserID).then((response) {
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
          empModel.result.clear();
          managerlist.clear();
        } else {
          empModel = EmpModel.fromJson(jsonDecode(response.body));
          managerlist.clear();
          for (int k = 0; k < empModel.result.length; k++) {
            managerlist.add(empModel.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getapprover() {
    GETUserMasterAPI(3, sessionuserID).then((response) {
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
          empModel.result.clear();
          approverlist.clear();
        } else {
          setState(() {
            empModel = EmpModel.fromJson(jsonDecode(response.body));
            approverlist.clear();
            for (int k = 0; k < empModel.result.length; k++) {
              approverlist.add(empModel.result[k].name);
            }
            formid = 3;
            getlist();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getlist() {
    setState(() {
      loading = true;
    });

    GetAllUserMaster(
            formid,
            docno,
            alterloccode,
            alterlocname,
            alterempid,
            alterempname,
            Edt_UserName.text,
            Edt_Password.text,
            alterRollcode.toString(),
            alterRollName,
            altermanagercode,
            altermanagername,
            alterapprcode,
            alterapprname,
            altercashaccountcode,
            altercashaccountname,
            alterpettycashaccountcode,
            alterpettycashaccountname,
            alterKotcode,
            alterKotname,
            status,
            sessionuserID)
        .then((response) {
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
          setState(() {
            if (formid == 1 && jsonDecode(response.body)["result"][0]["STATUSNAME"] == "User Already Exists") {
              Fluttertoast.showToast(
                  msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (formid == 1 && jsonDecode(response.body)["result"][0]["STATUSNAME"] != "User Already Exists") {
              Fluttertoast.showToast(
                  msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserMaster()));
            } else if (formid == 2) {
              Fluttertoast.showToast(
                  msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserMaster()));
            } else if (formid == 3) {
              //Select
              usersmodel = UsersMasterModel.fromJson(jsonDecode(response.body));
            }else if (formid == 4) {
                print("FromId4");
                log(response.body);
                RawEditUsermasterModel = EditUsermasterModel.fromJson(jsonDecode(response.body));
                alterloccode = RawEditUsermasterModel.result[0].locationCode.toString();
                alterlocname = RawEditUsermasterModel.result[0].locationName;
                Edt_UserName.text = RawEditUsermasterModel.result[0].userName;
                Edt_Password.text = RawEditUsermasterModel.result[0].userPassword;
                alterempid = RawEditUsermasterModel.result[0].empCode.toString();
                alterempname = RawEditUsermasterModel.result[0].empName;
                altermanagername = RawEditUsermasterModel.result[0].managerName;
                altermanagercode = RawEditUsermasterModel.result[0].managerID.toString();
                alterapprcode = RawEditUsermasterModel.result[0].apprManagerID.toString();
                alterapprname = RawEditUsermasterModel.result[0].apprManagerName;
                altercashaccountcode = RawEditUsermasterModel.result[0].cashOnAccID;
                altercashaccountname = RawEditUsermasterModel.result[0].cashOnAccName;
                alterpettycashaccountcode = RawEditUsermasterModel.result[0].pettyCashAccountID;
                alterpettycashaccountname = RawEditUsermasterModel.result[0].pettyCashAccountName;
                alterKotcode = RawEditUsermasterModel.result[0].kOTID.toString();
                alterKotname = RawEditUsermasterModel.result[0].kotName.toString();
                isUpdating=true;

            }

            else if (formid == 5) {
              log(response.body);

              setState(() {
                formid = 3;
                getlist();
              });

            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }


  void getrollmaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(15, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
         Fluttertoast.showToast(msg: "No Data in Roll Master");
        } else {
          setState(() {
            loading = false;
            print("Roll Master Screen");
            // RollmasterModel RawRollmasterModel;
            // List<String> rolllist = new List();
            RawRollmasterModel = RollmasterModel.fromJson(jsonDecode(response.body));
            for(int i = 0 ; i <RawRollmasterModel.result.length;i++ ){
              rolllist.add(RawRollmasterModel.result[i].rallName);
            }
            log(response.body);

          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

}
