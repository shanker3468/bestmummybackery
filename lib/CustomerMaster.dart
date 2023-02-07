// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/CustomerMasterModel.dart';
import 'package:bestmummybackery/Model/LoyaltyModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerMaster extends StatefulWidget {
  const CustomerMaster({Key key}) : super(key: key);

  @override
  _CustomerMasterState createState() => _CustomerMasterState();
}

class _CustomerMasterState extends State<CustomerMaster> {
  bool loading = false;
  List<String> loc = new List();
  LocationModel locationModel = new LocationModel();
  TextEditingController Edt_CusCode = new TextEditingController();
  TextEditingController Edt_CustomerName = new TextEditingController();
  TextEditingController Edt_CusWhatsAppNo = new TextEditingController();
  TextEditingController Edt_Email = new TextEditingController();
  TextEditingController Edt_Discount = new TextEditingController();
  CustomerMasterModel model;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Master"),
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
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextField(
                                        readOnly: true,
                                        controller: Edt_CusCode,
                                        decoration: InputDecoration(
                                          labelText: "Customer Code",
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
                                        keyboardType: TextInputType.text,
                                        controller: Edt_CustomerName,
                                        decoration: InputDecoration(
                                          labelText: "Customer Name",
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
                                        controller: Edt_CusWhatsAppNo,
                                        decoration: InputDecoration(
                                          labelText: "WhatsApp No",
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: Edt_Email,
                                        decoration: InputDecoration(
                                          labelText: "E-Mail ID",
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
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        controller: Edt_Discount,
                                        decoration: InputDecoration(
                                          labelText: "Discount",
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
                                  style: ElevatedButton.styleFrom(primary: isUpdating?Colors.blue:Colors.green,textStyle: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    if (Edt_CusCode.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Customer Code");
                                    } else if (Edt_CustomerName.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Enter Customer Name");
                                    } else if (Edt_CusWhatsAppNo.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Enter Whats App No");
                                    } else if (Edt_Email.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Enter Email ID");
                                    } else if (Edt_Discount.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Enter Discount %");
                                    } else {
                                      print('Selva');
                                      if (!isUpdating) {
                                        print('Insert');
                                        print('Button Clicked');
                                        formid = 1;
                                        getcurd(formid,0);
                                      } else {
                                        print('Button Clicked');
                                        formid = 4;
                                        getcurd(formid,docno);
                                        print('updatemode');
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
                                headingRowColor:
                                    MaterialStateProperty.all(Colors.blue),
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Customer Code',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Center(
                                      child: Text(
                                        'Customer Name',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Customer Whatsapp',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                rows: model.result
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                formid = 3;
                                                status = list.status.toString() == "99"
                                                        ? 0 : 99;
                                                getcurd(formid,list.docNo);
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
                                                  docno = list.docNo;
                                                  Edt_CusCode.text =
                                                      list.cusCode;
                                                  Edt_CustomerName.text =
                                                      list.cusName;
                                                  Edt_CusWhatsAppNo.text = list
                                                      .cusWhatsAppNo
                                                      .toString();
                                                  Edt_Discount.text =
                                                      list.discount.toString();
                                                  Edt_Email.text =
                                                      list.email.toString();
                                                });
                                              },
                                              child: Text('Edit'),
                                            ))),
                                        DataCell(Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("${list.cusCode}"),
                                        )),
                                        DataCell(Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                              "${list.cusName.toString()}"),
                                        )),
                                        DataCell(
                                          Wrap(
                                              direction: Axis.vertical,
                                              //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(
                                                    list.cusWhatsAppNo
                                                        .toString(),
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
      getcusid();
      formid = 2;
      getlist(formid);
    });
  }

  Future getcurd(int formID, docNo) {
    setState(() {
      loading = true;
    });
    CURDCustomer(
            formID,
            docNo,
            Edt_CusCode.text.isEmpty ? "" : Edt_CusCode.text,
            Edt_CustomerName.text.isEmpty ? "" : Edt_CustomerName.text,
            Edt_CusWhatsAppNo.text.isEmpty ? "" : Edt_CusWhatsAppNo.text,
            Edt_Email.text.isEmpty ? "" : Edt_Email.text,
            Edt_Discount.text.isEmpty ? "" : Edt_Discount.text,
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
              msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
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
                  MaterialPageRoute(builder: (context) => CustomerMaster()));
            } else if (formid == 2) {
              /*model = LoyaltyModel.fromJson(jsonDecode(response.body));
              print(model.result.length);*/
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getlist(int FormID) {
    setState(() {
      loading = true;
    });
    CURDCustomer(
            FormID,
            docno,
            Edt_CusCode.text.isEmpty ? "" : Edt_CusCode.text,
            Edt_CustomerName.text.isEmpty ? "" : Edt_CustomerName.text,
            Edt_CusWhatsAppNo.text.isEmpty ? "" : Edt_CusWhatsAppNo.text,
            Edt_Email.text.isEmpty ? "" : Edt_Email.text,
            Edt_Discount.text.isEmpty ? "" : Edt_Discount.text,
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CustomerMaster()));
            } else {
              print("FromId"+FormID.toString());
              print(response.body);
              model = CustomerMasterModel.fromJson(jsonDecode(response.body));
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

  Future getcusid() {
    setState(() {
      loading = true;
    });
    CURDCustomer(
            5,
            docno,
            Edt_CusCode.text.isEmpty ? "" : Edt_CusCode.text,
            Edt_CustomerName.text.isEmpty ? "" : Edt_CustomerName.text,
            Edt_CusWhatsAppNo.text.isEmpty ? "" : Edt_CusWhatsAppNo.text,
            Edt_Email.text.isEmpty ? "" : Edt_Email.text,
            Edt_Discount.text.isEmpty ? "" : Edt_Discount.text,
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
            /* model = LoyaltyModel.fromJson(jsonDecode(response.body));
            print(model.result.length);*/
            Edt_CusCode.text = jsonDecode(response.body)['result'][0]['CUSID'];
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }
}
