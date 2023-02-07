// ignore_for_file: deprecated_member_use, non_constant_identifier_names, missing_return

import 'dart:convert';
import 'package:bestmummybackery/AllApi.dart';
//import 'package:bestmummybackery/LocationModel.dart';
//import 'package:bestmummybackery/Model/CustomerMasterModel.dart';
//import 'package:bestmummybackery/Model/LoyaltyModel.dart';
import 'package:bestmummybackery/Model/TarWeightModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TarWeightMaster extends StatefulWidget {
  const TarWeightMaster({Key key}) : super(key: key);

  @override
  _TarWeightMasterState createState() => _TarWeightMasterState();
}

class _TarWeightMasterState extends State<TarWeightMaster> {
  bool loading = false;
  List<String> grouplist = new List();
  List<String> itemlist = new List();

  TextEditingController Edt_ItemGroup = new TextEditingController();
  TextEditingController Edt_Weight = new TextEditingController();
  TextEditingController Edt_ItemName = new TextEditingController();
  TextEditingController Edt_SerialNo = new TextEditingController();
  TarWeightModel tarmodel;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";

  var altergroupcode = "";
  var altergroupname = "";

  var alteritemcode = "";
  var alteritemname = "";

  int formid = 0;
  int docno = 0;
  int status = 0;
  bool isUpdating;

  TargetitemgroupModel itemgroupModel = new TargetitemgroupModel();
  TargetitemModel itemModel = new TargetitemModel();

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
        title: Text("TarWeight Master"),
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
                                      //mode of dropdown
                                      mode: Mode.DIALOG,
                                      //to show search box
                                      showSearchBox: true,
                                      items: grouplist,
                                      label: "Select Item Group",
                                      onChanged: (val) {
                                        setState(() {
                                          print(val);
                                          for (int kk = 0;kk < itemgroupModel.result.length;kk++) {
                                            if (itemgroupModel.result[kk].itmsGrpNam == val) {
                                              print(itemgroupModel.result[kk].itmsGrpCod);
                                              altergroupname = itemgroupModel.result[kk].itmsGrpNam;
                                              altergroupcode = itemgroupModel.result[kk].itmsGrpCod.toString();
                                              getitemlist(altergroupcode);
                                            }
                                          }
                                        });
                                      },
                                      selectedItem: altergroupname,
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
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: itemlist,
                                      label: "Select Item",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;kk < itemModel.result.length;kk++) {
                                          if (itemModel.result[kk].itemName == val) {
                                            alteritemname = itemModel.result[kk].itemName;
                                            alteritemcode = itemModel.result[kk].itemCode.toString();
                                          }
                                        }
                                      },
                                      selectedItem: alteritemname,
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
                                        controller: Edt_SerialNo,
                                        decoration: InputDecoration(labelText: "Serial No",border: OutlineInputBorder(),),
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
                                        controller: Edt_Weight,
                                        decoration: InputDecoration(labelText: "Weight",border: OutlineInputBorder(),
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
                                      if(altergroupcode=='' && altergroupname==''){
                                        Fluttertoast.showToast(msg: "Choose Group code");
                                      }else if (alteritemcode=='' && alteritemname==''){
                                        Fluttertoast.showToast(msg: "Choose Item Name");
                                      }else if(Edt_SerialNo.text==''){
                                        Fluttertoast.showToast(msg: "Enter The Serial No..");
                                      }
                                      else if(Edt_Weight.text==''){
                                        Fluttertoast.showToast(msg: "Enter The Weight..");
                                      }else {

                                        Fluttertoast.showToast(msg: "Save");
                                        formid = 1;
                                        getcurd(formid);

                                      }

                                    } else {
                                      print('Button Clicked');

                                      if(altergroupcode=='' && altergroupname==''){
                                        Fluttertoast.showToast(msg: "Choose Group code");
                                      }else if (alteritemcode=='' && alteritemname==''){
                                        Fluttertoast.showToast(msg: "Choose Item Name");
                                      }else if(Edt_SerialNo.text==''){
                                        Fluttertoast.showToast(msg: "Enter The Serial No..");
                                      }
                                      else if(Edt_Weight.text==''||Edt_Weight.text=='0'){
                                        Fluttertoast.showToast(msg: "Enter The Weight..");
                                      }else {

                                        Fluttertoast.showToast(msg: "Save");
                                        formid = 4;
                                        getcurd(formid);
                                        print('updatemode');

                                      }

                                    }
                                  },
                                  child: Text(isUpdating ? 'Update' : 'Save'),

                                  // color: Colors.blue,
                                  // textColor: Colors.white,
                                  // shape: RoundedRectangleBorder(borderRadius:new BorderRadius.circular(18.0),),
                                  // padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: tarmodel == null
                              ? Center(
                                  child: Text('No Data Add!'),
                                )
                              : DataTable(
                                  sortColumnIndex: 0,
                                  sortAscending: true,
                                  columnSpacing: 30,
                                  headingRowColor:MaterialStateProperty.all(Colors.blue),
                                  showCheckboxColumn: false,
                                  //border: TableBorder.all(color: Colors.grey),
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text('Status',style: TextStyle(color: Colors.white),),
                                    ),
                                    DataColumn(
                                      label: Text('Edit',style: TextStyle(color: Colors.white),),
                                    ),
                                    DataColumn(
                                      label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text('Serial No',style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text('Weight',style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                  rows: tarmodel.result
                                      .map(
                                        (list) => DataRow(cells: [
                                          DataCell(Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    formid = 3;
                                                    docno = list.docNo;
                                                    status =list.status.toString() =="99"? 0: 99;
                                                    getcurd(formid);
                                                  });
                                                },
                                                child: Text(list.status.toString() == "99"
                                                        ? "click Enable": "Click Disable")),
                                          )),
                                          DataCell(Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isUpdating = true;
                                                    docno = list.docNo;
                                                    altergroupname =list.itemGroupName;
                                                    altergroupcode =list.itemGroupCode;
                                                    alteritemcode = list.itemCode;
                                                    alteritemname = list.itemName;
                                                    Edt_SerialNo.text =list.serialNo;
                                                    Edt_Weight.text =list.weight.toString();
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.red,
                                                ),
                                              ))),
                                          DataCell(Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text("${list.itemName}"),
                                          )),
                                          DataCell(Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                                "${list.serialNo.toString()}"),
                                          )),
                                          DataCell(
                                            Wrap(
                                                direction: Axis.vertical,
                                                //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.weight.toString(),
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
      formid = 2;
      getItemgroupModel();
      getlist(formid);
    });
  }

  Future getcurd(int formID) {
    setState(() {
      loading = true;
    });
    CURDTarweight(
            formID,docno,altergroupcode,altergroupname,alteritemcode,alteritemname,
            Edt_SerialNo.text.isEmpty ? "" : Edt_SerialNo.text,
            Edt_Weight.text.isEmpty ? 0 : Edt_Weight.text,
            status,"",0,0,int.parse(sessionuserID))
        .then((response) {
      setState(() {
        loading = false;
      });
      print(response.body);
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
                  MaterialPageRoute(builder: (context) => TarWeightMaster()));
            } else if (formid == 2) {
              /* model = LoyaltyModel.fromJson(jsonDecode(response.body));
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

  void getItemgroupModel() {
    TargweightItemGroup().then((response) {
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
          itemgroupModel.result.clear();
          grouplist.clear();
        } else {
          itemgroupModel =
              TargetitemgroupModel.fromJson(jsonDecode(response.body));
          grouplist.clear();
          for (int k = 0; k < itemgroupModel.result.length; k++) {
            grouplist.add(itemgroupModel.result[k].itmsGrpNam);
          }
          print(itemgroupModel);
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getitemlist(String groupCode) {
    setState(() {
      loading = true;
    });
    TargweightItem(groupCode).then((response) {
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
          setState(() {
            itemModel.result.clear();
            itemlist.clear();
            loading = false;
          });
        } else {
          setState(() {
            itemModel = TargetitemModel.fromJson(jsonDecode(response.body));
            itemlist.clear();
            for (int k = 0; k < itemModel.result.length; k++) {
              itemlist.add(itemModel.result[k].itemName);
            }
            loading = false;
          });
          // print(itemgroupModel);
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
    CURDTarweight(2,0,altergroupcode,altergroupname,alteritemcode,alteritemname,
            Edt_SerialNo.text.isEmpty ? "" : Edt_SerialNo.text,
            Edt_Weight.text.isEmpty ? 0 : Edt_Weight.text,
            status,"",0,0,sessionuserID)
        .then((response) {
      setState(() {
        loading = false;
      });
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
        } else {
          setState(() {
            tarmodel = TarWeightModel.fromJson(jsonDecode(response.body));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }
}

class TargetitemgroupModel {
  int status;
  List<Result1> result;

  TargetitemgroupModel({this.status, this.result});

  TargetitemgroupModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result1>();
      json['result'].forEach((v) {
        result.add(new Result1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result1 {
  var itmsGrpCod;
  String itmsGrpNam;

  Result1({this.itmsGrpCod, this.itmsGrpNam});

  Result1.fromJson(Map<String, dynamic> json) {
    itmsGrpCod = json['ItmsGrpCod'];
    itmsGrpNam = json['ItmsGrpNam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItmsGrpCod'] = this.itmsGrpCod;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    return data;
  }
}

class TargetitemModel {
  int status;
  List<Result2> result;

  TargetitemModel({this.status, this.result});

  TargetitemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result2>();
      json['result'].forEach((v) {
        result.add(new Result2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result2 {
  String itemCode;
  String itemName;

  Result2({this.itemCode, this.itemName});

  Result2.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    return data;
  }
}
