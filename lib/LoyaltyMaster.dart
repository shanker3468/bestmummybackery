// ignore_for_file: deprecated_member_use, non_constant_identifier_names, missing_return

import 'dart:convert';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/LoyaltyModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoyaltyMaster extends StatefulWidget {
  const LoyaltyMaster({Key key}) : super(key: key);

  @override
  _LoyaltyMasterState createState() => _LoyaltyMasterState();
}

class _LoyaltyMasterState extends State<LoyaltyMaster> {
  bool loading = false;
  List<String> loc = new List();
  LocationModel locationModel = new LocationModel();
  TextEditingController Edt_FromRange = new TextEditingController();
  TextEditingController Edt_ToRange = new TextEditingController();
  TextEditingController Edt_LoyaltyPoint = new TextEditingController();
  TextEditingController Edt_LoyaltyAmount = new TextEditingController();
  LoyaltyModel model;
  String alterlocname = "";
  String alterloccode = "";

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";

  int formid = 0;
  int docno = 0;
  int status = 0;
  bool isUpdating;
  @override
  void initState() {
    isUpdating = false;
    setState(() {
      getStringValuesSF();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);

    //final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Loyalty Master"),
      ),
      body: !loading
          ? Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: loc,
                                      label: "Select Location",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;kk < locationModel.result.length;kk++) {
                                          if (locationModel.result[kk].name == val) {
                                            print(locationModel.result[kk].code);
                                            alterlocname = locationModel.result[kk].name;
                                            alterloccode = locationModel.result[kk].code.toString();
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
                              ],
                            ),
                            SizedBox(
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
                                        maxLength: 10,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                        controller: Edt_FromRange,
                                        decoration: InputDecoration(
                                          labelText: "Loyalty From Range",
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
                                        maxLength: 10,
                                        keyboardType: TextInputType.number,
                                        controller: Edt_ToRange,
                                        decoration: InputDecoration(
                                          labelText: "To Range",
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
                                        maxLength: 10,
                                        keyboardType:TextInputType.numberWithOptions(decimal: true),
                                        controller: Edt_LoyaltyPoint,
                                        decoration: InputDecoration(
                                          labelText: "Loyalty Point",
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
                                        maxLength: 10,
                                        keyboardType:TextInputType.numberWithOptions(decimal: true),
                                        controller: Edt_LoyaltyAmount,
                                        decoration: InputDecoration(
                                          labelText: "Loyalty Amount",
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
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    if (!isUpdating) {
                                      print('Insert');
                                      print('Button Clicked');
                                      if(alterlocname=='' && alterloccode ==''){
                                        Fluttertoast.showToast(msg: "Choose The Location..");
                                      }else if (Edt_FromRange.text==''){
                                        Fluttertoast.showToast(msg: "Enter The From Range..");
                                      }
                                      else if (Edt_ToRange.text==''){
                                        Fluttertoast.showToast(msg: "Enter The To Range..");
                                      }
                                      else if (Edt_LoyaltyPoint.text==''){
                                        Fluttertoast.showToast(msg: "Enter The To Loyalty Point..");
                                      }
                                      else if (Edt_LoyaltyAmount.text==''){
                                        Fluttertoast.showToast(msg: "Enter The To Loyalty Amount..");
                                      }else{
                                        Fluttertoast.showToast(msg: "Save..");
                                        formid = 1;
                                        getcurd(formid);
                                      }

                                    } else {
                                      print('Button Clicked');
                                      print('updatemode');

                                      if(alterlocname=='' && alterloccode ==''){
                                        Fluttertoast.showToast(msg: "Choose The Location..");
                                      }else if (Edt_FromRange.text==''||Edt_FromRange.text=='0'){
                                        Fluttertoast.showToast(msg: "Enter The From Range..");
                                      }
                                      else if (Edt_ToRange.text==''||Edt_ToRange.text=='0'){
                                        Fluttertoast.showToast(msg: "Enter The To Range..");
                                      }
                                      else if (Edt_LoyaltyPoint.text==''||Edt_LoyaltyPoint.text=='0'){
                                        Fluttertoast.showToast(msg: "Enter The To Loyalty Point..");
                                      }
                                      else if (Edt_LoyaltyAmount.text==''||Edt_LoyaltyAmount.text=='0'){
                                        Fluttertoast.showToast(msg: "Enter The To Loyalty Amount..");
                                      }else{
                                        Fluttertoast.showToast(msg: "Update..");
                                        formid = 4;
                                        getcurd(formid);
                                      }
                                    }
                                  },
                                  child: Text(isUpdating ? 'Update' : 'Save'),

                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    print('Button Clicked');
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: model == null
                            ? Center(
                                child: Text('No Data Add!'),
                              )
                            : DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                columnSpacing: 30,
                                headingRowColor:MaterialStateProperty.all(Colors.blue),
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Status',style: TextStyle(color: Colors.white),),),
                                  DataColumn(label: Text('Edit',style: TextStyle(color: Colors.white),),),
                                  DataColumn(label: Text('Location Name',style: TextStyle(color: Colors.white),),),
                                  DataColumn(label: Text('From Range',style: TextStyle(color: Colors.white),),),
                                  DataColumn(label: Text('To Range',style: TextStyle(color: Colors.white),),),
                                ],
                                rows: model.result
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                formid = 3;
                                                docno =  list.docNo;
                                                status = list.status.toString() =="99" ? 0 : 99;
                                                getcurd(formid);
                                              },
                                              child: Text(
                                                  list.status.toString() == "99"
                                                      ? "click Enable"
                                                      : "Click Disable")),
                                        )),
                                        DataCell(Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  isUpdating = true;
                                                  Edt_FromRange.text = list.fromRange.toString();
                                                  Edt_ToRange.text = list.toRange.toString();
                                                  Edt_LoyaltyAmount.text = list.loyaltyAmount.toString();
                                                  Edt_LoyaltyPoint.text = list.loyaltyPoint.toString();
                                                  alterlocname = "";
                                                  alterloccode = "";
                                                  alterlocname = list.locName;
                                                  alterloccode = list.locCode;
                                                  docno = list.docNo;
                                                });
                                              },
                                              child: Text('Edit'),
                                            ))),
                                        DataCell(Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("${list.locName}"),
                                        )),
                                        DataCell(Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                              "${list.fromRange.toString()}"),
                                        )),
                                        DataCell(
                                          Wrap(
                                              direction: Axis.vertical,
                                              //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(list.toRange.toString(),
                                                    textAlign: TextAlign.center)
                                              ]),
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
      //formid = 2;
      getlocation();
      getlist();
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

  Future getcurd(int formID) {
    setState(() {
      loading = true;
    });
    CURDLoyalty(
            formID,
            docno,
            alterloccode,
            alterlocname,
            Edt_FromRange.text.isEmpty ? 0 : Edt_FromRange.text,
            Edt_ToRange.text.isEmpty ? 0 : Edt_ToRange.text,
            Edt_LoyaltyPoint.text.isEmpty ? 0 : Edt_LoyaltyPoint.text,
            Edt_LoyaltyAmount.text.isEmpty ? 0 : Edt_LoyaltyAmount.text,
            status,
            "",
            0,
            0,
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
            if (formid == 1 || formid == 3 || formid == 4) {
              Fluttertoast.showToast(
                  msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoyaltyMaster()));
            } else if (formid == 2) {
              model = LoyaltyModel.fromJson(jsonDecode(response.body));
              print(model.result.length);
            }
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
    CURDLoyalty(
            2,
            docno,
            alterloccode,
            alterlocname,
            Edt_FromRange.text.isEmpty ? 0 : Edt_FromRange.text,
            Edt_ToRange.text.isEmpty ? 0 : Edt_ToRange.text,
            Edt_LoyaltyPoint.text.isEmpty ? 0 : Edt_LoyaltyPoint.text,
            Edt_LoyaltyAmount.text.isEmpty ? 0 : Edt_LoyaltyAmount.text,
            status,
            "",
            0,
            0,
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
            model = LoyaltyModel.fromJson(jsonDecode(response.body));
            print(model.result.length);
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }
}
