// ignore_for_file: non_constant_identifier_names, deprecated_member_use, missing_return
import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:typed_data';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
//import 'package:esc_pos_printer/esc_pos_printer.dart';
//import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as Wingscale;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:typed_data';

class SaleIncentive extends StatefulWidget {
  SaleIncentive({Key key}) : super(key: key);

  @override
  SaleIncentiveState createState() => SaleIncentiveState();
}

class SaleIncentiveState extends State<SaleIncentive> {
  String colorchange = "";
  String selectedDate = "";
  var TextClicked;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  var dropdownValue = "Select";
  var altertype = "";
  var qrvisible = false;
  bool loading = false;
  bool isSelected = false;
  String altersalespersoname = "";
  String altersalespersoncode = "";
  String alterpayment = "";
  String search = "";
  double batchcount = 0;
  int onclick = 0;
  var altercountrycode = "";
  var alterstatecode = "";
  var altercareofcode = "";
  var altercareofname = "";
  var CuttentDate;
  var CurrentTime;
  var json;
  DateTime dateTime = DateTime.now();
  List<AddAcheivalbles> SecAddAcheivalbles = new List();
  List<AcheivableLoop> SecAcheivableLoop = new List();

  //LOc
  LocationModel locationModel = new LocationModel();
  List<String> loc = new List();
  var alterlocname = '', alterloccode = '';
  //end Loc

  // Manager Satrt

  List<String> salespersonlist = new List();
  EmpModel salespersonmodel;
  List<String> careoflist = new List();

  //Manager End
//ProvisionType
  List<ProvisionType> SecProvisionType = new List();
  var ProviCode;
  var _ProvisionType = new TextEditingController();

  //END ProvisionType

  // EMP DETALIED
  EmpModel RawEmpModel;
  List<EmployeedetailsList> SecEmployeedetails = new List();

  // END EMP DETALIES

  var _DocDate = new TextEditingController();
  var _Basic = new TextEditingController();
  var _FromDate = new TextEditingController();
  var _Todate = new TextEditingController();
  var _TotalSalesPreSystem = new TextEditingController();
  var _TargetSalePer = new TextEditingController();
  var _TotalSales = new TextEditingController();
  var _TargetSale = new TextEditingController();
  var _AverageSale = new TextEditingController();
  var _ValidFrom = new TextEditingController();
  var _ValidTo = new TextEditingController();
  bool MyEmpCheckBox = false;
  bool MyItemLay = false;
  bool MyProductLay = false;

  @override
  void initState() {
    getStringValuesSF();
    DateFormat.jm().format(DateTime.now());
    CuttentDate = DateFormat('MMddyyyy').format(DateTime.now());
    _DocDate.text = DateFormat('MM-dd-yyyy').format(DateTime.now());
    CurrentTime = DateFormat.jm().format(DateTime.now());
    super.initState();
    SecProvisionType = [
      ProvisionType(1, 'Item'),
      ProvisionType(2, 'Product'),
    ];
  }

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  _SelectDate(BuildContext context, FormId) async {
    var _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        if (FormId == 1) {
          _FromDate.text = DateFormat('dd-MM-yyyy').format(_picked);
        } else if (FormId == 2) {
          _Todate.text = DateFormat('dd-MM-yyyy').format(_picked);
        }
      });
    }
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
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Sale Incentive"),
        ),
        body: Center(
          child: tablet
              ? Container(
                  color: Colors.white,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width / 2.5,
                          height: height,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: false,
                                          style: TextStyle(fontSize: 12,),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Doc No',
                                              labelText: 'Doc No',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          controller: _DocDate,
                                          enabled: false,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Doc Date',
                                              labelText: 'Doc Date',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: loc,
                                          label: "Select Location",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk <locationModel.result.length;kk++) {
                                              if (locationModel.result[kk].name ==val) {
                                                print(locationModel.result[kk].code);
                                                alterlocname = locationModel.result[kk].name;
                                                alterloccode = locationModel.result[kk].code.toString();
                                                setState(() {
                                                  GetMySalespersystem(alterloccode);
                                                });
                                              }
                                            }
                                          },
                                          selectedItem: alterlocname,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: DropdownSearch<String>(
                                          mode: Mode.MENU,
                                          showSearchBox: true,
                                          items: salespersonlist,
                                          label: "Manager Name",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                              if (salespersonmodel.result[kk].name ==val) {
                                                print(salespersonmodel.result[kk].empID);
                                                altersalespersoname =salespersonmodel.result[kk].name;
                                                altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                              }
                                            }
                                          },
                                          selectedItem: altersalespersoname,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          readOnly: true,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Select of Acheivable'),
                                                  content: Container(
                                                    width: double.minPositive,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:SecProvisionType.length,
                                                      itemBuilder:(BuildContext context,int i) {
                                                        return ListTile(
                                                          title: Text(SecProvisionType[i].Provision),
                                                          onTap: () {
                                                            setState(() {
                                                              _ProvisionType.text = SecProvisionType[i].Provision;
                                                              ProviCode = SecProvisionType[i].Code.toString();
                                                              print(ProviCode);
                                                              if (ProviCode =="1") {
                                                                setState(() {
                                                                  MyItemLay = true;
                                                                  MyProductLay = false;
                                                                });
                                                              } else if (ProviCode == "2") {
                                                                setState(() {
                                                                  SecAddAcheivalbles.clear();
                                                                  SecEmployeedetails.clear();
                                                                  MyEmpCheckBox =false;
                                                                  MyItemLay =false;
                                                                  MyProductLay =true;
                                                                });
                                                              }
                                                            });
                                                            Navigator.pop(context,);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          controller: _ProvisionType,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Provision',
                                              labelText: 'Provision',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(right: 0,),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: true,
                                          controller: _Basic,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Basic',
                                              labelText: 'Basic',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          readOnly: true,
                                          controller: _FromDate,
                                          onTap: () {
                                            _SelectDate(context, 1);
                                          },
                                          style: TextStyle(fontSize: 12,),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'From Date',
                                              labelText: 'From Date',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: true,
                                          controller: _ValidFrom,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Valid From',
                                              labelText: 'Valid From',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          readOnly: true,
                                          controller: _Todate,
                                          onTap: () {
                                            _SelectDate(context, 2);
                                          },
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'To Date',
                                              labelText: 'To Date',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: true,
                                          controller: _ValidTo,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Valid To',
                                              labelText: 'Valid To',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: false,
                                          controller: _TotalSalesPreSystem,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText:'Total Sales as per system',
                                              labelText:'Total Sales as per system',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: true,
                                          controller: _TargetSalePer,
                                          keyboardType: TextInputType.number,
                                          onChanged: (vvv) {
                                            _TargetSale.text = (double.parse(vvv) * double.parse(_AverageSale.text) +
                                                    double.parse(_AverageSale.text)).toStringAsFixed(3);
                                          },
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Target Sales %',
                                              labelText: 'Target Sales %',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: false,
                                          controller: _TotalSales,
                                          style: TextStyle( fontSize: 12,),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Total Sales ',
                                              labelText: 'Total Sales ',
                                              labelStyle: TextStyle(
                                                  color: Colors.grey.shade600),
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: false,
                                          controller: _TargetSale,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Target Sales',
                                              labelText: 'Target Sales',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(left: 0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: TextField(
                                          enabled: false,
                                          controller: _AverageSale,
                                          style: TextStyle( fontSize: 12,),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Average Sales /day',
                                              labelText: 'Average Sales /day',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width / 5.1,
                                      margin: EdgeInsets.only(
                                        right: 0,
                                      ),
                                      child: Visibility(
                                        visible: MyItemLay,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 50,
                                          width: width / 5.2,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: MyEmpCheckBox,
                                                onChanged: (vv) {
                                                  if (MyEmpCheckBox == true) {
                                                    setState(() {
                                                      MyEmpCheckBox = false;
                                                      SecEmployeedetails.clear();
                                                    });
                                                  } else if (MyEmpCheckBox == false) {
                                                    setState(() {
                                                      MyEmpCheckBox = true;
                                                      GetMyBranchEmp();
                                                    });
                                                  }
                                                },
                                              ),
                                              Text('Employee Details'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: MyItemLay,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                                  onPressed: () {
                                    if (alterloccode == '') {
                                      showDialogboxWarning(context, 'Choose Location');
                                    } else if (altersalespersoncode == '') {
                                      showDialogboxWarning(context, 'Choose Manager Name');
                                    } else if (_ProvisionType.text == '') {
                                      showDialogboxWarning(context, 'Choose Provision');
                                    } else {
                                      AddAcheivalblesList();
                                    }
                                  },
                                  child: Text('Add Acheivalblesss',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: MyItemLay,
                          child: Container(
                            width: width / 1.7,
                            height: height,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: height,
                                  width: width / 3.5,
                                  child: ListView.builder(
                                    itemCount: SecAddAcheivalbles.length,
                                    itemBuilder:(BuildContext context, int index) {
                                      return Container(
                                        height: 110,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,blurRadius: 2.0,spreadRadius: 0.0,offset: Offset(2.0,2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 100,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: CircleAvatar(
                                                      backgroundColor:Colors.tealAccent,
                                                      child: Column(
                                                        mainAxisAlignment:MainAxisAlignment.center,
                                                        children: [
                                                          Text((index + 1).toString(),
                                                            style: TextStyle(fontSize: 20,color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 240,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:context,
                                                                  builder:(BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text('Select of Acheivable'),
                                                                      content:
                                                                          Container(
                                                                              width: double.minPositive,
                                                                                child: ListView.builder(
                                                                                      shrinkWrap:true,
                                                                                      itemCount:SecAcheivableLoop.length,
                                                                                      itemBuilder:(BuildContext context, int i) {
                                                                                      return ListTile(
                                                                                        title: Text(SecAcheivableLoop[i].Discription),
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            SecAddAcheivalbles[index].Acheivable = SecAcheivableLoop[i].Discription;
                                                                                            print(SecAcheivableLoop[i].Code * double.parse(_TargetSale.text));
                                                                                            SecAddAcheivalbles[index].TargetValue = (SecAcheivableLoop[i].Code * double.parse(_TargetSale.text)).toString();
                                                                                          });
                                                                                          Navigator.pop(context,);
                                                                                        },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                width: 140,
                                                                height: 20,
                                                                child: Row(
                                                                  children: [
                                                                    Text('Acheivable'),
                                                                    Icon(Icons.edit,size: 18,)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              color: Colors.black12,
                                                              child: Text(SecAddAcheivalbles[index].Acheivable.toString()),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 140,
                                                              height: 20,
                                                              alignment: Alignment.centerLeft,
                                                              child: Text('Target Value'),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              alignment: Alignment.centerLeft,
                                                              color: Colors.black12,
                                                              child: Text(SecAddAcheivalbles[index].TargetValue .toString()),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                print('OnTap');
                                                                var EnterMobileNo;
                                                                showDialog( context: context,
                                                                  builder: (BuildContext
                                                                          contex1) =>
                                                                      AlertDialog(
                                                                    content:
                                                                        TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      onChanged:
                                                                          (vvv) {
                                                                        EnterMobileNo =
                                                                            vvv;
                                                                      },
                                                                    ),
                                                                    title: Text(
                                                                        "Enter Incentive"),
                                                                    actions: <
                                                                        Widget>[
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                child: TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      SecAddAcheivalbles[index].IncentivePer = EnterMobileNo;
                                                                                      print(double.parse(SecAddAcheivalbles[index].TargetValue) * double.parse(SecAddAcheivalbles[index].IncentivePer));
                                                                                      SecAddAcheivalbles[index].IncentiveValue = (double.parse(SecAddAcheivalbles[index].TargetValue) * double.parse(SecAddAcheivalbles[index].IncentivePer)).toStringAsFixed(3);
                                                                                      Navigator.pop(contex1,'Ok',);
                                                                                    });
                                                                                  },
                                                                                  child: const Text("Ok"),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                child: TextButton(
                                                                                  onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                                                  child: const Text('Cancel'),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                width: 140,
                                                                height: 20,
                                                                alignment: Alignment.centerLeft,
                                                                child: Row(
                                                                  children: [
                                                                    Text('Incentive %'),
                                                                    Icon(Icons.edit,size: 18,)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              color: Colors.black12,
                                                              child: Text(SecAddAcheivalbles[index].IncentivePer.toString(),),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 140,
                                                              height: 20,
                                                              color: Colors.white,
                                                              alignment: Alignment.centerLeft,
                                                              child: Text('Incentive Value'),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              color: Colors.black12,
                                                              child: Text(SecAddAcheivalbles[index].IncentiveValue.toString()),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: CircleAvatar(
                                                        backgroundColor:Colors.redAccent,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              SecAddAcheivalbles.removeAt(index);
                                                            });
                                                          },
                                                          icon: Icon(Icons.delete,color: Colors.white,),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  height: height,
                                  width: width / 3.5,
                                  child: ListView.builder(
                                    itemCount: SecEmployeedetails.length,
                                    itemBuilder:(BuildContext context, int index) {
                                      return Container(
                                        height: 110,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,blurRadius: 2.0,spreadRadius: 0.0,
                                              offset: Offset(2.0,2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 100,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: CircleAvatar(
                                                      backgroundColor:Colors.tealAccent,
                                                      child: Column(
                                                        mainAxisAlignment:MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            SecEmployeedetails[index].BioMetricNo.toString(),
                                                            style: TextStyle(fontSize: 20,color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 240,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                width: 140,
                                                                height: 20,
                                                                child: Text('Emp Id'),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              color: Colors.black12,
                                                              child: Text(SecEmployeedetails[index].EmpCode.toString()),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 140,
                                                              height: 20,
                                                              alignment: Alignment.centerLeft,
                                                              child: Text('Emp Name'),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              alignment: Alignment.centerLeft,
                                                              color: Colors.black12,
                                                              child: Text(SecEmployeedetails[index].EmpName.toString()),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                print('OnTap');
                                                                var EnterMobileNo;
                                                                showDialog(
                                                                  context:context,
                                                                  builder: (BuildContext contex1) =>
                                                                      AlertDialog(
                                                                          content:TextFormField(
                                                                          keyboardType:TextInputType.number,
                                                                            onChanged:(vvv) {
                                                                          EnterMobileNo =vvv;
                                                                        },),
                                                                        title: Text("Emp TargetValue"),
                                                                        actions: <Widget>[
                                                                        Column(
                                                                          children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                child: TextButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      SecEmployeedetails[index].TargetValue = EnterMobileNo;
                                                                                      Navigator.pop(contex1,'Ok',);
                                                                                    });
                                                                                  },
                                                                                  child: const Text("Ok"),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                child: TextButton(
                                                                                  onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                                                  child: const Text('Cancel'),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                width: 140,
                                                                height: 20,
                                                                alignment: Alignment.centerLeft,
                                                                child: Row(
                                                                  children: [
                                                                    Text('Target Value'),
                                                                    Icon(Icons.edit,size: 18,)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 90,
                                                              height: 20,
                                                              color: Colors.black12,
                                                              child: Text(SecEmployeedetails[index].TargetValue.toString(),),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: CircleAvatar(
                                                        backgroundColor:Colors.redAccent,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              SecAddAcheivalbles.removeAt(index);
                                                            });
                                                          },
                                                          icon: Icon(Icons.delete,color: Colors.white,),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MyProductLay,
                          child: Container(
                            width: width / 1.7,
                            height: height,
                            alignment: Alignment.center,
                            child: Text(''),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                icon: Icon(Icons.check),
                label: Text('Save'),
                onPressed: () {},
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.red,
                icon: Icon(Icons.clear),
                label: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.print),
                label: Text('Print'),
                onPressed: () {
                  print('Print');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool onWillPop() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Are you sure you want to go Back?'),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ]));
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
      LoopFunction();
      getlocationval();
    });
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

        //print(locationModel);
        salesPersonget(int.parse(sessionuserID), int.parse(sessionbranchcode));
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  void salesPersonget(int USERID, int BRANCHID) {
    setState(() {
      loading = true;
    });
    GetAllSalesPerson(USERID, BRANCHID).then((response) {
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
          salespersonmodel.result.clear();
        } else {
          setState(() {
            salespersonmodel = EmpModel.fromJson(jsonDecode(response.body));
            print(salespersonmodel.result.length);
            careoflist.clear();
            salespersonlist.clear();

            for (int k = 0; k < salespersonmodel.result.length; k++) {
              salespersonlist.add(salespersonmodel.result[k].name);
              careoflist.add(salespersonmodel.result[k].name);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> GetMySalespersystem(alterloccode) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print("MyScreenId" + int.parse(alterloccode).toString());
    });
    var body = {
      "FromId": 5,
      "ScreenId": 0,
      "DocNo": 1,
      "DocEntry": 10,
      "Status": alterloccode,
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
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
          _TotalSalesPreSystem.text = '';
          _TotalSales.text = '';
          _AverageSale.text = '';
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        _TotalSalesPreSystem.text = decode["testdata"][0]["Total"].toString();
        _TotalSales.text = decode["testdata"][0]["Total"].toString();
        _AverageSale.text =
            (decode["testdata"][0]["Total"] / 365).toStringAsFixed(3);
        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetMyBranchEmp() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecEmployeedetails.clear();
    });
    var body = {
      "branch": int.parse(sessionbranchcode),
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getSalesPersonIncentive'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(response.body);
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
          print(response.body);
          RawEmpModel = EmpModel.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawEmpModel.result.length; i++) {
            print(RawEmpModel.result[i].empID);
            SecEmployeedetails.add(EmployeedetailsList(0, RawEmpModel.result[i].empID,
                  RawEmpModel.result[i].name, 0.00, 'MOB'),);
          }
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  LoopFunction() {
    for (int i = 0; i <= 100; i++) {
      SecAcheivableLoop.add(
        AcheivableLoop(
          i,
          i.toString() + '-%',
        ),
      );
    }
  }

  AddAcheivalblesList() {
    setState(() {
      SecAddAcheivalbles.add(
        AddAcheivalbles('0%', '0.00', '0%', '0.00'),
      );
    });
  }
}

Future showDialogboxWarning(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class AddAcheivalbles {
  var Acheivable;
  var TargetValue;
  var IncentivePer;
  var IncentiveValue;
  AddAcheivalbles(this.Acheivable, this.TargetValue, this.IncentivePer,
      this.IncentiveValue);
}

class AcheivableLoop {
  var Code;
  var Discription;
  AcheivableLoop(this.Code, this.Discription);
}

class ProvisionType {
  var Code;
  var Provision;
  ProvisionType(this.Code, this.Provision);
}

class EmployeedetailsList {
  var BioMetricNo;
  var EmpCode;
  var EmpName;
  var TargetValue;
  var DBStatus;
  EmployeedetailsList(this.BioMetricNo, this.EmpCode, this.EmpName,
      this.TargetValue, this.DBStatus);
}
