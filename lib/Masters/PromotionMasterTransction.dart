// ignore_for_file: deprecated_member_use, non_constant_identifier_names, missing_return, must_be_immutable

import 'dart:convert';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/GetItemCodeModel.dart';
import 'package:bestmummybackery/Model/GetProductCodeModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/PromotionGetModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromotionMasterTransction extends StatefulWidget {
  PromotionMasterTransction({Key key, this.SendDocNo}) : super(key: key);
  var PostUom;
  var PostItemCode;
  var PostItemName;
  var SendDocNo = 0;
  int Index;
  @override
  _PromotionMasterTransctionState createState() =>
      _PromotionMasterTransctionState();
}

class _PromotionMasterTransctionState extends State<PromotionMasterTransction> {
  TextEditingController Edt_ProductName = TextEditingController();
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var alteritemcode = "";
  var alteritemName = "";
  var alteritemuom = "";
  var alteritemqty = "";
  var alterstock = "";
  var alteritemgropcode = 0;
  var alteritemgroname = '';
  int InsertFormId = 0;
  int HeaderDocNo = 0;
  int GetDocNUm = 0;
  bool loading = false;
  bool UpdateMode = false;
  int SecreeId = 0;
  int ReqFromId = 0;
  var LineDocNo;
  var EditBum;
  var EditPeace;
  var _DiscountName = new TextEditingController();
  var _Seledate = new TextEditingController();
  var _Day = new TextEditingController();
  var _StartRange = new TextEditingController();
  var _EndTimeRange = new TextEditingController();
  var _StartDate = new TextEditingController();
  var _EndDate = new TextEditingController();
  var _EndTime = new TextEditingController();
  var _StartTime = new TextEditingController();
  var _Percentage = new TextEditingController(
    text: '0',
  );
  var _Ammount = new TextEditingController(text: '0');
  int OccCode = 0;
  var checkbox = false;
  var AutoDisCount = 'N';
  DateTime dateTime = DateTime.now();
  //OSRDModel detailitems;
  LocationModel locationModel = new LocationModel();
  GetItemCodeModel RawGetItemCodeModel = new GetItemCodeModel();
  GetProductCodeModel RawGetProductCodeModel = new GetProductCodeModel();
  OccModel occModel = new OccModel();

  LocationResult test;
  //Result Additem;
  static WastageItemModel ItemList;
  String alterocccode;
  String alterocccname;
  var alterloccode = 0;
  var alterlocname;
  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();
  List<String> grpCode = new List();
  List<String> productlist = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;

  List<TempMyItemDetaliesList> SecMyItemDetaliesList = new List();
  PromotionGetModel RawPromotionGetModel;

  void initState() {
    setState(() {
      print('MyDocNo' + widget.SendDocNo.toString());
      if (widget.SendDocNo == 0) {
        isUpdating = false;
        getStringValuesSF();
        GetItemCode();
        getlocationval();
      } else {
        GetItemCode();
        PromotionMasteGet();
      }
    });

    super.initState();
  }

  _SelectDOB(BuildContext context) async {
    var _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        var datemake;
        _Seledate.text = DateFormat('dd-MM-yyyy').format(_picked);
        datemake = DateFormat('yyyy-MM-dd').format(_picked);
        DateTime date = DateTime.parse(datemake);
        _Day.text = DateFormat('EEEE').format(date);
      });
    }
  }

  _SelectStartDate(BuildContext context) async {
    var _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        _StartDate.text = DateFormat('dd-MM-yyyy').format(_picked);
      });
    }
  }

  _SelectEndtDate(BuildContext context) async {
    var _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        _EndDate.text = DateFormat('dd-MM-yyyy').format(_picked);
      });
    }
  }

  TimeOfDay _currentTime = new TimeOfDay.now();
  String timeText = 'Set A Time';
  String TotimeText = 'Set A Time';

  Future<Null> _selectStartRange(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (selectedTime != null) {
      String formattedTime = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        setState(() {
          timeText = formattedTime;
          _StartRange.text = timeText;
        });
      }
    }
  }

  Future<Null> _selectToRange(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (selectedTime != null) {
      String formattedTime = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        setState(() {
          TotimeText = formattedTime;
          _EndTimeRange.text = TotimeText;
        });
      }
    }
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (selectedTime != null) {
      String formattedTime = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        setState(() {
          timeText = formattedTime;
          _StartTime.text = timeText;
        });
      }
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (selectedTime != null) {
      String formattedTime = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        setState(() {
          TotimeText = formattedTime;
          _EndTime.text = TotimeText;
        });
      }
    }
  }

  void AddListItem() {
    setState(() {
      SecMyItemDetaliesList.add(
        TempMyItemDetaliesList(
            SecMyItemDetaliesList.length + 1,
            alteritemgropcode,
            alteritemgroname,
            alteritemcode,
            alteritemName,
            alteritemuom,
            'Y',
            0),
      );
    });
    alteritemgroname = '';
    alteritemgropcode = 0;
    alteritemcode = '';
    alteritemName = '';
  }

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
                  title: Text("My Promotion Master-"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 4,
                                    height: height / 15,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: height / 8,
                                          width: width / 4,
                                          child: TextField(
                                            controller: _DiscountName,
                                            enabled: true,
                                            style: TextStyle(
                                                //fontSize: 12,
                                                ),
                                            decoration: InputDecoration(
                                                hintText: 'Discount name',
                                                labelText: 'Discount name',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width / 8,
                                    height: height / 15,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: height / 8,
                                          width: width / 8,
                                          child: TextField(
                                            controller: _Ammount,
                                            enabled: true,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                //fontSize: 12,
                                                ),
                                            decoration: InputDecoration(
                                                hintText: 'Amount',
                                                labelText: 'Amount',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width / 8,
                                    height: height / 15,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: height / 8,
                                          width: width / 8,
                                          child: TextField(
                                            controller: _Percentage,
                                            enabled: true,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                //fontSize: 12,
                                                ),
                                            decoration: InputDecoration(
                                                hintText: 'Percentage',
                                                labelText: 'Percentage',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width / 4,
                                    height: height / 15,
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
                                            alterlocname =locationModel.result[kk].name;
                                            alterloccode =locationModel.result[kk].code;
                                          }
                                        }
                                      },
                                      selectedItem: alterlocname,
                                    ),
                                  ),
                                  Container(
                                    width: width / 8,
                                    child: Column(
                                      children: [
                                        Checkbox(
                                          value: checkbox,
                                          onChanged: (bool value) {
                                            if (checkbox == true) {
                                              setState(() {
                                                checkbox = false;
                                                AutoDisCount = 'N';
                                                print(AutoDisCount);
                                              });
                                            } else if (checkbox == false) {
                                              setState(() {
                                                checkbox = true;
                                                AutoDisCount = 'Y';
                                                print(AutoDisCount);
                                              });
                                            }
                                          },
                                        ),
                                        Text('Automatic discount')
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: width / 4,
                                    height: height / 15,
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: grpCode,
                                      label: "Select Item Group Code",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;kk <RawGetItemCodeModel.testdata.length; kk++) {
                                          if (RawGetItemCodeModel.testdata[kk].name == val) {
                                            print(RawGetItemCodeModel.testdata[kk].code);
                                            alteritemgroname = RawGetItemCodeModel.testdata[kk].name;
                                            alteritemgropcode = RawGetItemCodeModel.testdata[kk].code;
                                            GetProductCode(alteritemgropcode);
                                          }
                                        }
                                      },
                                      selectedItem: alteritemgroname,
                                    ),
                                  ),
                                  Container(
                                    width: width / 4,
                                    height: height / 15,
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: productlist,
                                      label: "Select ItemName",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;kk <RawGetProductCodeModel.testdata.length;kk++) {
                                          if (RawGetProductCodeModel.testdata[kk].itemName == val) {
                                            print(RawGetProductCodeModel.testdata[kk].itemCode);
                                            alteritemcode = RawGetProductCodeModel.testdata[kk].itemCode;
                                            alteritemName = RawGetProductCodeModel.testdata[kk].itemName;
                                          }
                                        }
                                      },
                                      selectedItem: alteritemName,
                                    ),
                                  ),
                                  Container(
                                    width: width / 5,
                                    child: FloatingActionButton.extended(
                                      backgroundColor: Colors.blue.shade700,
                                      icon: Icon(Icons.add),
                                      label: Text('Create'),
                                      onPressed: () {
                                        if (_DiscountName.text.isEmpty) {
                                          showDialogboxWarning(
                                              context, "Enter Discount Name");
                                        } else if (_Ammount.text.isEmpty) {
                                          showDialogboxWarning(
                                              context, "Enter Amount Name");
                                        } else if (_Percentage.text.isEmpty) {
                                          showDialogboxWarning(
                                              context, "Enter Percentage");
                                        } else if (alteritemgroname == '') {
                                          showDialogboxWarning(
                                              context, "Choose GroupCode");
                                        } else {

                                            //PromotionMasteAddneeLine
                                          if(widget.SendDocNo==0){
                                            AddListItem();
                                          }else{

                                        //     SecMyItemDetaliesList.length + 1,
                                        // alteritemgropcode,
                                        // alteritemgroname,
                                        // alteritemcode,
                                        // alteritemName,
                                        // alteritemuom,
                                        // 'Y',

                                            PromotionMasteAddneeLine(1, widget.SendDocNo.toString(), alteritemgropcode,
                                                alteritemcode, alteritemName, alteritemuom,
                                                (SecMyItemDetaliesList.length+1).toString(), "Y");
                                          }


                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: width / 4,
                                    height: height / 15,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: height / 2.3,
                                width: width,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SecMyItemDetaliesList.length == 0
                                          ? Center(
                                              child: Text(
                                                  'Add ItemCode Line Table'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text('Line No',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Item Code',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Item Name',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Active/Inactive',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Satus',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: SecMyItemDetaliesList.map(
                                                (list) => DataRow(cells: [
                                                  DataCell(
                                                    Text(list.LinId.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        list.ItemCode.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        list.ItemName.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                      direction: Axis.vertical, //default
                                                      alignment:WrapAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                          onPressed: () {
                                                            print(list.Active);
                                                            setState(() {
                                                              list.Active == 'Y'? list.Active ='N': list.Active ='Y';
                                                            });
                                                            PromotionMasteLineUpdate(LineDocNo,list.LinId,list.Active);
                                                          },
                                                          child: Text((list.Active =='Y'? 'Click to Disable': 'Click to Enable')),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  DataCell(
                                                      Icon(Icons.cancel, color: Colors.red,),
                                                      onTap: () {
                                                        print(widget.SendDocNo);
                                                        if (widget.SendDocNo > 0) {
                                                          print('No');
                                                        } else {
                                                          setState(() {
                                                            SecMyItemDetaliesList.remove(list);
                                                          });
                                                        }
                                                  })
                                                ]),
                                              ).toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: height / 2.8,
                                width: width,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: width / 4,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _Seledate,
                                            readOnly: true,
                                            onTap: () {
                                              _SelectDOB(context);
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                              hintText: 'Select Date',
                                              labelText: 'Select Date',
                                              labelStyle: TextStyle(color: Colors.grey.shade600),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width / 4,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _Day,
                                            enabled: false,
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'Day',
                                                labelText: 'Day',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        Container(
                                          width: width / 8,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _StartRange,
                                            readOnly: true,
                                            onTap: () {
                                              _selectStartRange(context);
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'Start Time Range',
                                                labelText: 'Start Time Range',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        Container(
                                          width: width / 10,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _EndTimeRange,
                                            readOnly: true,
                                            onTap: () {
                                              _selectToRange(context);
                                            },
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'End Time Range',
                                                labelText: 'End Time Range',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: width / 4,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _StartDate,
                                            readOnly: true,
                                            onTap: () {
                                              _SelectStartDate(context);
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'Start Date',
                                                labelText: 'Start Date',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        Container(
                                          width: width / 4,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _EndDate,
                                            readOnly: true,
                                            onTap: () {
                                              _SelectEndtDate(context);
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'End Date',
                                                labelText: 'End Date',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        Container(
                                          width: width / 8,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _StartTime,
                                            readOnly: true,
                                            onTap: () {
                                              _selectStartTime(context);
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'Start Time',
                                                labelText: 'Start Time',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        Container(
                                          width: width / 10,
                                          height: height / 15,
                                          child: TextField(
                                            controller: _EndTime,
                                            readOnly: true,
                                            onTap: () {
                                              _selectEndTime(context);
                                            },
                                            style: TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                hintText: 'End Time',
                                                labelText: 'End Time',
                                                labelStyle: TextStyle(color:Colors.grey.shade600),
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        label: Text('Save'),
                        onPressed: () {
                          if (SecMyItemDetaliesList.length == 0) {
                            Fluttertoast.showToast(msg: 'Add Atlest One Row..');
                          } else if (_Seledate.text == ''&&_StartDate.text == '') {
                            Fluttertoast.showToast(msg: 'Choose The Select Date OR Start Date ');
                          }
                          else if(_Seledate.text.isNotEmpty){
                              if (_Day.text == '') {
                                 Fluttertoast.showToast(msg: 'Day not lode...');
                               }
                               else if (_StartRange.text == '') {
                                 Fluttertoast.showToast(msg: 'Choose The Start Range ..');
                               }
                               else if (_EndTimeRange.text == '') {
                                 Fluttertoast.showToast(msg: 'Choose The End Range..');
                               }else{
                                 Fluttertoast.showToast(msg: 'Save');
                                 print('Save...');
                                 ReqFromId = 1;
                                 PromotionMastePost();
                               }
                          }

                          else if(_StartDate.text.isNotEmpty){
                                   if (_EndDate.text == '') {
                                    Fluttertoast.showToast(msg: 'Choose The End Date');
                                  }
                                   else if (_StartTime.text == '') {
                                     Fluttertoast.showToast(msg: 'Choose The Start Time');
                                   }
                                   else if (_EndTime.text == '') {
                                     Fluttertoast.showToast(msg: 'Choose The End Time');
                                   }
                                   else {
                                     print('Save...');
                                     ReqFromId = 1;
                                     PromotionMastePost();
                                   }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            // child: SafeArea(
            //   child: Scaffold(
            //     appBar: AppBar(
            //       title: Text("OSRD MASTER"),
            //     ),
            //     body: !loading
            //         ? SingleChildScrollView(
            //             padding: EdgeInsets.all(5.0),
            //             scrollDirection: Axis.vertical,
            //             child: Form(
            //               key: formKey,
            //               child: Column(
            //                 children: [
            //                   Row(
            //                     children: [
            //                       //new Expanded(flex: 1, child: new Text("Scan Pallet")),
            //                       new Expanded(
            //                         flex: 5,
            //                         child: Container(
            //                           color: Colors.white,
            //                           child: DropdownSearch<String>(
            //                             mode: Mode.DIALOG,
            //                             showSearchBox: true,
            //                             items: loc,
            //                             label: "Select Location",
            //                             onChanged: (val) {
            //                               print(val);
            //                               for (int kk = 0;
            //                                   kk < locationModel.result.length;
            //                                   kk++) {
            //                                 if (locationModel.result[kk].name ==
            //                                     val) {
            //                                   print(locationModel
            //                                       .result[kk].code);
            //                                   alterlocname =
            //                                       locationModel.result[kk].name;
            //                                   alterloccode = locationModel
            //                                       .result[kk].code
            //                                       .toString();
            //                                 }
            //                               }
            //                             },
            //                             selectedItem: alterlocname,
            //                           ),
            //                         ),
            //                       ),
            //                       new Expanded(
            //                         flex: 5,
            //                         child: Container(),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     //Use of SizedBox
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     children: [
            //                       new Expanded(
            //                         flex: 5,
            //                         child: Container(
            //                           color: Colors.white,
            //                           child: DropdownSearch<String>(
            //                             //mode of dropdown
            //                             mode: Mode.DIALOG,
            //                             //to show search box
            //                             showSearchBox: true,
            //
            //                             items: occ,
            //                             label:
            //                                 "Select Occation/Shape/Reason/Distribution",
            //                             onChanged: (val) {
            //                               print(val);
            //                               for (int kk = 0;
            //                                   kk < occModel.result.length;
            //                                   kk++) {
            //                                 if (occModel.result[kk].occName ==
            //                                     val) {
            //                                   print(
            //                                       occModel.result[kk].occCode);
            //                                   alterocccname =
            //                                       occModel.result[kk].occName;
            //                                   alterocccode = occModel
            //                                       .result[kk].occCode
            //                                       .toString();
            //                                 }
            //                               }
            //                             },
            //                             selectedItem: alterocccname,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     //Use of SizedBox
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     children: [
            //                       new Expanded(
            //                         flex: 7,
            //                         child: InkWell(
            //                           child: Container(
            //                             width: double.infinity,
            //                             color: Colors.white,
            //                             child: TextField(
            //                               /*maxLines: 5,*/
            //                               controller: Edt_Remarks,
            //                               decoration: InputDecoration(
            //                                 labelText: "Remarks",
            //                                 hintText: "Enter Remarks",
            //                                 border: OutlineInputBorder(),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                       /*Expanded(
            //                     flex: 2,
            //                     child: IconButton(
            //                         onPressed: () {}, icon: Icon(Icons.add)))*/
            //                       SizedBox(
            //                         width: 5,
            //                       ),
            //                       new Expanded(
            //                         flex: 3,
            //                         child: ElevatedButton(
            //                           onPressed: () {
            //                             print('openpo');
            //
            //                             if (!isUpdating) {
            //                               print('Insert');
            //                             } else {
            //                               print('updatemode');
            //                             }
            //                           },
            //                           child:
            //                               Text(isUpdating ? 'UPDATE' : 'ADD'),
            //                           //child: Text('Add'),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     //Use of SizedBox
            //                     height: 10,
            //                   ),
            //                   Padding(
            //                     padding: EdgeInsets.all(5.0),
            //                     child: SingleChildScrollView(
            //                       scrollDirection: Axis.horizontal,
            //                       child: detailitems.toString() == "null"
            //                           ? Center(
            //                               child: Text('No Data Add!'),
            //                             )
            //                           : DataTable(
            //                               sortColumnIndex: 0,
            //                               sortAscending: true,
            //                               headingRowColor:
            //                                   MaterialStateProperty.all(
            //                                       Pallete.mycolor),
            //                               showCheckboxColumn: false,
            //                               columns: const <DataColumn>[
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Edit',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Active/InActive',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Location',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Description',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                               ],
            //                               rows: detailitems.result
            //                                   .map(
            //                                     (list) => DataRow(cells: [
            //                                       DataCell(
            //                                         Center(
            //                                           child: Center(
            //                                             child: IconButton(
            //                                                 icon: Icon(
            //                                                     Icons.create),
            //                                                 color: Colors.red,
            //                                                 onPressed: () {
            //                                                   setState(() {
            //                                                     isUpdating =
            //                                                         true;
            //                                                   });
            //                                                   Edt_Remarks.text =
            //                                                       list.remarks;
            //                                                   alterlocname = "";
            //                                                   alterloccode = "";
            //                                                   alterocccode = "";
            //                                                   alterocccname =
            //                                                       "";
            //
            //                                                   alterlocname = list
            //                                                       .locationName;
            //                                                   alterloccode = list
            //                                                       .locationCode;
            //                                                   alterocccode =
            //                                                       list.occCode;
            //                                                   alterocccname =
            //                                                       list.occName;
            //                                                   docno =
            //                                                       list.docNo;
            //                                                   updatestatus =
            //                                                       list.status;
            //                                                 }),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       DataCell(
            //                                         Center(
            //                                           child: Center(
            //                                             child: Wrap(
            //                                               direction: Axis
            //                                                   .vertical, //default
            //                                               alignment:
            //                                                   WrapAlignment
            //                                                       .center,
            //                                               children: [
            //                                                 RaisedButton(
            //                                                   onPressed: () {},
            //                                                   child: Text((list
            //                                                               .status ==
            //                                                           0
            //                                                       ? 'Click to Disable'
            //                                                       : 'Click to Enable')),
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       DataCell(Wrap(
            //                                           direction: Axis
            //                                               .vertical, //default
            //                                           alignment:
            //                                               WrapAlignment.center,
            //                                           children: [
            //                                             Text(
            //                                                 list.locationName
            //                                                     .toString(),
            //                                                 textAlign:
            //                                                     TextAlign.left)
            //                                           ])),
            //                                       DataCell(
            //                                         Center(
            //                                             child: Wrap(
            //                                                 direction: Axis
            //                                                     .vertical, //default
            //                                                 alignment: WrapAlignment.center,
            //                                                 children: [
            //                                               Text(
            //                                                   list.remarks
            //                                                       .toString(),
            //                                                   textAlign:
            //                                                       TextAlign
            //                                                           .center)
            //                                             ])),
            //                                       ),
            //                                     ]),
            //                                   )
            //                                   .toList(),
            //                             ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           )
            //         : Container(
            //             child: Center(
            //               child: CircularProgressIndicator(),
            //             ),
            //           ),
            //   ),
            // ),
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
      //getpendingapprovallist();
    });
  }

  Future<http.Response> GetItemCode() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('alterloccode' + alterloccode.toString());
      print('LocName' + alterlocname.toString());
    });
    var body = {
      "FormID": 2,
      "DocNo": 171,
      "ScreenId": 1,
      "DiscountName": "DiscountName",
      "Location": 10,
      "LocationName": "LocationName",
      "Ammount": 0,
      "Percentage": 12,
      "Date": "20-12.2022",
      "Day": "Monday",
      "StartTimeRange": "10.20-AM",
      "EndTimeRange": "11-30 PM",
      "FromDate": "11.20.2022",
      "EndDate": "12-20-2020",
      "StartTime": "09-20 AM",
      "EndTime": "02.30 PM",
      "UserId": sessionuserID,
      "Active": "Y",
      "AutomaticDis": "Y"
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_HEADER_SP'),
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
        });
        print('NoResponse');
        grpCode.clear();
        RawGetItemCodeModel.testdata.clear();
      } else {
        RawGetItemCodeModel = GetItemCodeModel.fromJson(jsonDecode(response.body));
        grpCode.clear();
        for (int k = 0; k < RawGetItemCodeModel.testdata.length; k++) {
          grpCode.add(RawGetItemCodeModel.testdata[k].name);
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> GetProductCode(int alteritemgropcode) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('alterloccode' + alterloccode.toString());
      print('LocName' + alterlocname.toString());
    });
    var body = {
      "FormID": 3,
      "DocNo": alteritemgropcode,
      "ScreenId": 1,
      "DiscountName": "DiscountName",
      "Location": 10,
      "LocationName": "LocationName",
      "Ammount": 0,
      "Percentage": 12,
      "Date": "20-12.2022",
      "Day": "Monday",
      "StartTimeRange": "10.20-AM",
      "EndTimeRange": "11-30 PM",
      "FromDate": "11.20.2022",
      "EndDate": "12-20-2020",
      "StartTime": "09-20 AM",
      "EndTime": "02.30 PM",
      "UserId": sessionuserID,
      "Active": "Y",
      "AutomaticDis": "Y"
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_HEADER_SP'),
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
        });
        print('NoResponse');
        productlist.clear();
        RawGetProductCodeModel.testdata.clear();
      } else {
        RawGetProductCodeModel = GetProductCodeModel.fromJson(jsonDecode(response.body));
        productlist.clear();
        for (int k = 0; k < RawGetProductCodeModel.testdata.length; k++) {
          productlist.add(RawGetProductCodeModel.testdata[k].itemName);
        }
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
        setState(() {
          locationModel = LocationModel.fromJson(jsonDecode(response.body));
          loc.clear();
          for (int k = 0; k < locationModel.result.length; k++) {
            loc.add(locationModel.result[k].name);
          }
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Error Validation(ErrorMsg) {
    Fluttertoast.showToast(
        msg: ErrorMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<http.Response> PromotionMastePost() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": 1,
      "ScreenId": 1,
      "DiscountName": _DiscountName.text,
      "Location": alterloccode,
      "LocationName": alterlocname,
      "Ammount": _Ammount.text,
      "Percentage": int.parse(_Percentage.text),
      "Date": _Seledate.text,
      "Day": _Day.text,
      "StartTimeRange": _StartRange.text,
      "EndTimeRange": _EndTimeRange.text,
      "FromDate": _StartDate.text,
      "EndDate": _EndDate.text,
      "StartTime": _StartTime.text,
      "EndTime": _EndTime.text,
      "UserId": sessionuserID,
      "Active": "Y",
      "AutomaticDis": AutoDisCount
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_HEADER_SP'),
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
        });
        print('NoResponse');
      } else {
        if (ReqFromId == 1) {
          print(response.body);
          HeaderDocNo = decode["testdata"][0]["DocNo"];
          setState(() {
            loading = false;
          });
          for (int i = 0; i < SecMyItemDetaliesList.length; i++)
            PromotionMasteLine(i);
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PromotionMasteLine(index) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": HeaderDocNo,
      "ScreenId": 1,
      "ItemGropCode": SecMyItemDetaliesList[index].ItemGropCode,
      "ItemCode": SecMyItemDetaliesList[index].ItemCode,
      "ItemName": SecMyItemDetaliesList[index].ItemName,
      "Uom": SecMyItemDetaliesList[index].ItemUom,
      "LineId": SecMyItemDetaliesList[index].LinId,
      "Active": SecMyItemDetaliesList[index].Active,
      "FromQty": 0,
      "ToQty": 0
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_LINE_SP'),
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
        });
        print('NoResponse');
      } else {
        if (ReqFromId == 1) {
          print(response.body);
          setState(() {
            loading = false;
          });
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PromotionMasteGet() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecMyItemDetaliesList.clear();
    });
    var body = {
      "FormID": 7,
      "DocNo": widget.SendDocNo,
      "ScreenId": 1,
      "DiscountName": _DiscountName.text,
      "Location": alterloccode,
      "LocationName": alterlocname,
      "Ammount": _Ammount.text,
      "Percentage": int.parse(_Percentage.text),
      "Date": _Seledate.text,
      "Day": _Day.text,
      "StartTimeRange": _StartRange.text,
      "EndTimeRange": _EndTimeRange.text,
      "FromDate": _StartDate.text,
      "EndDate": _EndDate.text,
      "StartTime": _StartTime.text,
      "EndTime": _EndTime.text,
      "UserId": sessionuserID,
      "Active": "Y",
      "AutomaticDis": AutoDisCount
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_HEADER_SP'),
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
        });
        print('NoResponse');
      } else {
        print(response.body);
        HeaderDocNo = decode["testdata"][0]["HeadDocNo"];
        LineDocNo = decode["testdata"][0]["LineDocNo"];
        _DiscountName.text = decode["testdata"][0]["DiscountName"];
        alterloccode = decode["testdata"][0]["Location"];
        alterlocname = decode["testdata"][0]["LocationName"];
        _Ammount.text = decode["testdata"][0]["Ammount"].toString();
        _Percentage.text = decode["testdata"][0]["Percentage"].toString();
        AutoDisCount = decode["testdata"][0]["AutoMaticDis"];
        _Seledate.text = decode["testdata"][0]["Date"];
        _Day.text = decode["testdata"][0]["Day"];
        _StartRange.text = decode["testdata"][0]["StartTimeRange"];
        _EndTimeRange.text = decode["testdata"][0]["EndTimeRange"];
        _StartDate.text = decode["testdata"][0]["FromDate"];
        _EndDate.text = decode["testdata"][0]["EndDate"];
        _StartTime.text = decode["testdata"][0]["StartTime"];
        _EndTime.text = decode["testdata"][0]["EndTime"];
        // List<TempMyItemDetaliesList> SecMyItemDetaliesList = new List();
        // PromotionGetModel RawPromotionGetModel;
        RawPromotionGetModel = PromotionGetModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPromotionGetModel.testdata.length; i++)
          SecMyItemDetaliesList.add(
            TempMyItemDetaliesList(
                RawPromotionGetModel.testdata[i].lineId,
                0, //itemgropcode
                '', //itemgroupName
                RawPromotionGetModel.testdata[i].itemCode,
                RawPromotionGetModel.testdata[i].itemName,
                '',
                RawPromotionGetModel.testdata[i].lActive,1),
          );

        setState(() {
          loading = false;
          if (AutoDisCount == 'Y') {
            checkbox = true;
          } else {
            checkbox = false;
          }
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PromotionMasteAddneeLine(FormID,DocNo,ItemGropCode,ItemCode,ItemName,Uom,LineId,Active) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": 1,
      "DocNo": DocNo,
      "ScreenId": 1,
      "ItemGropCode": ItemGropCode.toString(),
      "ItemCode": ItemCode.toString(),
      "ItemName": ItemName.toString(),
      "Uom": Uom.toString(),
      "LineId": int.parse(LineId.toString()),
      "Active": Active,
      "FromQty": 0,
      "ToQty": 0
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_LINE_SP'),
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
        });
        print('NoResponse');
      } else {

          print(response.body);
          setState(() {
            loading = false;
            PromotionMasteGet();
          });

      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PromotionMasteLineUpdate(DocNo, lineid, Active) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": 5,
      "DocNo": DocNo,
      "ScreenId": 1,
      "ItemGropCode": 0,
      "ItemCode": '',
      "ItemName": '',
      "Uom": '',
      "LineId": lineid,
      "Active": Active,
      "FromQty": 0,
      "ToQty": 0
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_LINE_SP'),
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
        });
        print('NoResponse');
      } else {
        print(response.body);
        PromotionMasteGet();
        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }


}

class TempMyItemDetaliesList {
  var LinId;
  var ItemGropCode;
  var ItemGropDis;
  var ItemCode;
  var ItemName;
  var ItemUom;
  var Active;
  var Status;
  TempMyItemDetaliesList(this.LinId, this.ItemGropCode, this.ItemGropDis,
      this.ItemCode, this.ItemName, this.ItemUom, this.Active,this.Status);
}

class AddListItemRec {
  var AddItemCode;
  var AddItemName;
  var AddBum;
  var Piece;
  var AcInc;
  var DocNo;
  var LineId;
  AddListItemRec(this.AddItemCode, this.AddItemName, this.AddBum, this.Piece,
      this.AcInc, this.DocNo, this.LineId);
}

class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<ItemFillModel> my = new List();
    if (_PromotionMasterTransctionState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0;
          a < _PromotionMasterTransctionState.ItemList.result.length;
          a++)
        if (_PromotionMasterTransctionState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _PromotionMasterTransctionState.ItemList.result[a].itemCode,
              _PromotionMasterTransctionState.ItemList.result[a].itemName,
              _PromotionMasterTransctionState.ItemList.result[a].uOM,
              _PromotionMasterTransctionState.ItemList.result[a].qty,
              _PromotionMasterTransctionState.ItemList.result[a].Stock));
      return my;
    }
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
