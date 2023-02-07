// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_statements, missing_return

import 'dart:async';
import 'dart:convert';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/VehicleModel.dart';
import 'package:bestmummybackery/Model/VendorModel.dart';
import 'package:bestmummybackery/Model/getBillNo.dart';
import 'package:bestmummybackery/PriceList/Models/PriceListDinningModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseCustomer extends StatefulWidget {
  const ExpenseCustomer({Key key}) : super(key: key);

  @override
  _ExpenseCustomerState createState() => _ExpenseCustomerState();
}

class _ExpenseCustomerState extends State<ExpenseCustomer> {
  bool typevisible = false;
  bool typevisible1 = false;
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> vechiclelist = new List();
  List<String> vendorlist = new List();
  VehicleModel vehicleModel;
  EmpModel salespersonmodel;
  EmpModel derivetmodel;
  PriceListDinningModel RawPriceListDinningModel;
  List<TempPriceListDinningModel> SecPriceListDinningModel = new List();
  VendorModel vendormodel;
  List<String> salespersonlist = new List();
  TextEditingController Edt_DocNo = TextEditingController();
  TextEditingController Edt_DocDate = TextEditingController();
  TextEditingController _Edt_Amt = TextEditingController(text: "0");
  TextEditingController Edt_Remarks = TextEditingController();
  TextEditingController Edt_TransId = TextEditingController();
  TextEditingController Edt_BillAmt = TextEditingController(text: "0");
  TextEditingController Edt_BillNo = TextEditingController(text: "0");
  TextEditingController Edt_ExpenceName = TextEditingController();
  List<String> loc = new List();
  LocationModel locationModel = new LocationModel();
  List<String> paytype = new List();
  getBillNo rawgetBillNo;
  List<String>billlist=[];
  var nameatcard='0';
  var billdocentry='0';
  var billdocnum='0';
  var billdoctotal='0';
  String altersalespersoname = "";
  var altersalespersoncode = 0;
  var altervechiclename = "";
  var altervechicleNo = "";
  var alterBankcode = "0";
  bool loading = false;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var alterloccode = 0;
  var alterlocname='';
  var alterCardCode='';
  var alterCardName='';
  var Paytype='';
  var ExpenceCode=0;
  @override
  void initState() {
    getStringValuesSF();
    getdocnoanddate();
    super.initState();
  }

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
                appBar: new AppBar(
                  title: Text('Expense Request'),
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
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TypeAheadField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText: "Select Type",
                                                    border: OutlineInputBorder(),
                                                    suffixIcon: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.arrow_drop_down_circle),
                                                    ),
                                                  ),
                                                  controller: this._typeAheadController),
                                          suggestionsCallback: (pattern) async {
                                            Completer<List<String>> completer = new Completer();
                                            completer.complete(<String>["Employee", "Vendor"]);
                                            return completer.future;
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(title: Text(suggestion.toString()));
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            if (suggestion.toString().contains("Select")) {
                                            } else {
                                              this._typeAheadController.text = suggestion.toString();
                                              setState(() {
                                                if (suggestion.toString().contains("Employee")) {
                                                  typevisible = true;
                                                  typevisible1 = false;
                                                  salespersonmodel == null;
                                                  altersalespersoname = "";
                                                  altersalespersoncode = 0;
                                                  _Edt_Amt.text='';
                                                  altervechiclename = '';
                                                  altervechicleNo = '';
                                                  //alterloccode = 0;
                                                  //alterlocname = '';
                                                  salesPersonget(int.parse(sessionuserID), int.parse(sessionbranchcode));
                                                  nameatcard='0';
                                                  billdocentry='0';
                                                  billdocnum='0';
                                                  billdoctotal='0';
                                                  Edt_BillNo.text = "0";
                                                  Edt_BillAmt.text = "0";
                                                } else {
                                                  vendormodel == null;
                                                  typevisible = false;
                                                  typevisible1 = true;
                                                  altersalespersoname = "";
                                                  altersalespersoncode = 0;
                                                  _Edt_Amt.text='';
                                                  altervechiclename = '';
                                                  altervechicleNo = '';
                                                  nameatcard='0';
                                                  billdocentry='0';
                                                  billdocnum='0';
                                                  billdoctotal='0';
                                                  Edt_BillNo.text = "0";
                                                  Edt_BillAmt.text = "0";
                                                  getvendorlist();
                                                }
                                              });
                                            }
                                          })),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: new TextField(
                                      controller: Edt_DocNo,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Submit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Expense No",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(0))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(width: 5,),
                                        SizedBox(
                                          width:  200,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Location Name".toString()),
                                              Text(alterlocname.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        SizedBox(
                                          width:  200,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Account Code".toString()),
                                              Text(alterBankcode.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                    child: new TextField(
                                      controller: Edt_DocDate,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Onsubmit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Expense Date",
                                        border: OutlineInputBorder(
                                            borderRadius:BorderRadius.all(Radius.circular(0))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: typevisible,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.MENU,
                                            showSearchBox: true,
                                            items: salespersonlist,
                                            label: "Select Employee",
                                            onChanged: (val) {
                                              print(val);
                                              for (int kk = 0; kk < salespersonmodel.result.length; kk++) {
                                                if (salespersonmodel.result[kk].name == val) {
                                                  print(salespersonmodel.result[kk].empID);
                                                  altersalespersoname = "";
                                                  altersalespersoncode = 0;
                                                  altersalespersoname = salespersonmodel.result[kk].name;
                                                  altersalespersoncode = salespersonmodel.result[kk].empID;
                                                }
                                              }
                                            },
                                            selectedItem: altersalespersoname,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: InkWell(

                                          onTap: (){
                                            GetDinningMaster().then(
                                                  (value) => showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Choose Expence..'),
                                                    content: Container(
                                                      width: double.minPositive,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:SecPriceListDinningModel.length,
                                                        itemBuilder:(BuildContext context,int index) {
                                                          return ListTile(
                                                            title: Text(SecPriceListDinningModel[index].occName),
                                                            onTap: () {
                                                              setState(() {
                                                                Edt_ExpenceName.text = SecPriceListDinningModel[index].occName;
                                                                ExpenceCode = int.parse(SecPriceListDinningModel[index].occCode.toString());
                                                              });
                                                              Navigator.pop(context,);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },

                                          child: Container(
                                            color: Colors.white,
                                            child: new TextField(
                                              controller: Edt_ExpenceName,
                                              enabled: false,
                                              onSubmitted: (value) {
                                                print("Onsubmit,$value");
                                              },
                                              decoration: InputDecoration(
                                                labelText: "Expense Name",
                                                border: OutlineInputBorder(borderRadius: BorderRadius.all(
                                                        Radius.circular(0),),),
                                                suffixIcon: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.arrow_drop_down_circle),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: Colors.white,
                                          child: new TextField(
                                            controller: _Edt_Amt,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            enabled: true,
                                            onSubmitted: (value) {
                                              print("Onsubmit,$value");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Amount",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.MENU,
                                            showSearchBox: true,
                                            items: vechiclelist,
                                            label: "Vehicle No",
                                            onChanged: (val) {
                                              for (int kk = 0; kk < vehicleModel.result.length; kk++) {
                                                if (vehicleModel.result[kk].VehicleName == val) {
                                                  altervechicleNo = vehicleModel.result[kk].VehicleNo;
                                                  altervechiclename = vehicleModel.result[kk].VehicleName;
                                                }
                                              }
                                            },
                                            selectedItem: altervechiclename,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: Colors.white,
                                          child: new TextField(
                                            maxLength: 2000,
                                            enabled: true,
                                            onSubmitted: (value) {
                                              print("Submit,$value");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Remarks",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: typevisible1,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: vendorlist,
                                          label: "Select Vendor",
                                          onChanged: (val) {
                                            print(val);
                                            setState(() {
                                              for (int kk = 0; kk < vendormodel.result.length; kk++) {
                                                if (vendormodel.result[kk].cardName ==val) {
                                                  alterCardCode = vendormodel.result[kk].cardCode;
                                                  alterCardName = vendormodel.result[kk].cardName;
                                                }
                                              }
                                              print(alterCardCode);
                                              getBillNumber();
                                            });
                                          },
                                          selectedItem: alterCardName,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: billlist,
                                          label: "Select Bill",
                                          onChanged: (val) {
                                            print(val);
                                            setState(() {
                                              for (int kk = 0; kk < rawgetBillNo.testdata.length; kk++) {
                                                if (rawgetBillNo.testdata[kk].docNum.toString()==val) {
                                                    nameatcard=rawgetBillNo.testdata[kk].numAtCard.toString();
                                                    billdocentry=rawgetBillNo.testdata[kk].docEntry.toString();
                                                    billdocnum=rawgetBillNo.testdata[kk].docNum.toString();
                                                    billdoctotal=rawgetBillNo.testdata[kk].docTotal.toString();
                                                    Edt_BillNo.text = rawgetBillNo.testdata[kk].docNum.toString();
                                                    Edt_BillAmt.text = rawgetBillNo.testdata[kk].docTotal.toString();
                                                }
                                              }
                                              print(alterCardCode);
                                            });
                                          },
                                          selectedItem: Edt_BillNo.text.toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: Colors.white,
                                          child: new TextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            enabled: true,
                                            controller: Edt_BillAmt,
                                            onSubmitted: (value) {
                                              print("Onsubmit,$value");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Bill Amount",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 5,
                                        child: Container(
                                          color: Colors.white,
                                          child: DropdownSearch<String>(
                                            mode: Mode.DIALOG,
                                            showSearchBox: true,
                                            items: paytype,
                                            label: "Card/Cash/UPI/Others",
                                            onChanged: (val) {
                                              print(val);
                                              setState(() {
                                                Paytype = val;
                                              });

                                            },
                                            selectedItem: Paytype,
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
                                          child: new TextField(
                                            controller: _Edt_Amt,
                                            onSubmitted: (value) {
                                              print("Onsubmit,$value");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Amount",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0))),
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
                                          child: new TextField(
                                            readOnly: true,
                                            controller: Edt_TransId,
                                            onSubmitted: (value) {
                                              print("Onsubmit,$value");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Transaction ID",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    //Use of SizedBox
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: Colors.white,
                                          child: new TextField(
                                            controller: Edt_Remarks,
                                            enabled: true,
                                            onSubmitted: (value) {
                                              print("Onsubmit,$value");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Remarks",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
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
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "Cancel",
                        backgroundColor: Colors.red,
                        icon: Icon(Icons.clear),
                        label: Text('Cancel'),
                        onPressed: () {
                          setState(() {
                          Navigator.pop(context);
                          });
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FloatingActionButton.extended(
                        heroTag: "Save",
                        backgroundColor: Colors.blue.shade700,
                        icon: Icon(Icons.check),
                        label: Text('Save'),
                        onPressed: () {
                          if(_typeAheadController.text==''){
                            Fluttertoast.showToast(msg: "Select The Type..");
                          }
                          else if(alterloccode == 0){
                            Fluttertoast.showToast(msg: "Choose the location Name");
                          }
                          else if(_typeAheadController.text=='Employee'){
                                      if(altersalespersoname==''&&altersalespersoncode==0){
                                        Fluttertoast.showToast(msg: "Select The Employee..");
                                      }
                                      else if (_Edt_Amt.text==''||_Edt_Amt.text=='0'){
                                        Fluttertoast.showToast(msg: "Enter Amt..");
                                      }
                                      else if (altervechicleNo==''&&altervechiclename==''){
                                        Fluttertoast.showToast(msg: "Choose The Vechicle Name..");
                                      }
                                     else{
                                       Fluttertoast.showToast(msg: "Saved...");
                                        SavePostData();
                                     }
                          }
                          else if(_typeAheadController.text=='Vendor'){

                                  if(alterCardName==''&&alterCardCode==''){
                                    Fluttertoast.showToast(msg: "Choose The Vendor Name..");
                                  }else if(Edt_BillAmt.text==''){
                                    Fluttertoast.showToast(msg: "Enter The Bill Amt..");
                                  }else if(Edt_BillAmt.text==''){
                                    Fluttertoast.showToast(msg: "Enter The Bill Amt..");
                                  }else if (Paytype==''){
                                    Fluttertoast.showToast(msg: "Select The Pay Type..");
                                  }else if (_Edt_Amt.text==''){
                                    Fluttertoast.showToast(msg: "Enter The Amt..");
                                  }else if (Edt_TransId.text==''){
                                    Fluttertoast.showToast(msg: "Enter Transaction ID..");
                                  }else{
                                    Fluttertoast.showToast(msg: "Saved...");
                                    SavePostData();
                                  }

                          }
                   },
                      ),
                    ],
                  ),
                ],
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
      paytype.addAll(["Cash","Card","UPI","Others"]);
      getdocnoanddate();


    });
  }

  Future getdocnoanddate() {
    print("getdocnoanddate");
    GetAllDocNo(8, sessionuserID).then((response) {
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
          Edt_DocDate.text = "";
          Edt_DocNo.text = "";
          Edt_DocDate.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
          Edt_DocNo.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
          getlocationval();
        }
        return response;
      } else {
        showDialogboxWarning(context, "Failed to Login API Date and Time");
      }
    });
  }

  Future<http.Response> GetDinningMaster() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;

    });
    var body = {
      "FormID": 11,
      "DocNo": 1,
      "ItemCode": "",
      "ItemName": "",
      "ItemUOM": "",
      "Location": 0,
      "LocationName": "",
      "variance": "",
      "OccCode": 0,
      "OccName": "R",
      "Rate": 0 ,
      "Active": "Y",
      "UserID": 0,
      "DocDate": "",
      "TabIndex": 2
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PRRICELISTMASTER_SP'),
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
            SecPriceListDinningModel.clear();
            RawPriceListDinningModel = PriceListDinningModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawPriceListDinningModel.testdata.length; i++)
              SecPriceListDinningModel.add(
                TempPriceListDinningModel(
                  RawPriceListDinningModel.testdata[i].locCode,
                  RawPriceListDinningModel.testdata[i].occCode,
                  RawPriceListDinningModel.testdata[i].occName,
                ),
              );
            loading = false;
          });

      }
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
            salespersonlist.clear();
            for (int k = 0; k < salespersonmodel.result.length; k++) {
              salespersonlist.add(salespersonmodel.result[k].name);
            }
            getvechiclemaster();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getvechiclemaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(1, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      // print(jsonDecode.body);
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
          //vehicleModel.result.clear();
        } else {
          setState(() {
            loading = false;
            vehicleModel = VehicleModel.fromJson(jsonDecode(response.body));
            vechiclelist.clear();
            for (int k = 0; k < vehicleModel.result.length; k++) {
              vechiclelist.add(vehicleModel.result[k].VehicleNo);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getvendorlist() {
    setState(() {
      loading = true;
    });
    GetAllMaster(2, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      // print(jsonDecode.body);
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
          vendormodel.result.clear();
        } else {
          setState(() {
            loading = false;
            vendormodel = VendorModel.fromJson(jsonDecode(response.body));
            print(jsonEncode(vendormodel));
            vendorlist.clear();
            for (int k = 0; k < vendormodel.result.length; k++) {
              vendorlist.add(vendormodel.result[k].cardName);
            }
            getvechiclemaster();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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
        setState(() {

          print(sessionbranchcode.toString());

          locationModel = LocationModel.fromJson(jsonDecode(response.body));
          loc.clear();
          for (int k = 0; k < locationModel.result.length; k++) {
            if(locationModel.result[k].code.toString()== sessionbranchcode.toString()){
              alterlocname =locationModel.result[k].name.toString();
              alterloccode =locationModel.result[k].code;
              alterBankcode =locationModel.result[k].bankAccount;
              Edt_TransId.text =locationModel.result[k].bankAccount;
            }
          }
          loading = false;
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getBillNumber() async {
    print('getBillNumber');
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      nameatcard='0';
      billdocentry='0';
      billdocnum='0';
      billdoctotal='0';
      billlist.clear();
    });
    var body = {
      "FormId":3,
      "Date":alterCardCode,
      "BarnchId":0
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DASHBOARD'),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {

        setState(() {
           nameatcard='0';
           billdocentry='0';
           billdocnum='0';
           billdoctotal='0';
          loading = false;
        });
      } else {
        print(response.body);
        setState(() {
          rawgetBillNo = getBillNo.fromJson(jsonDecode(response.body));
          for(int i = 0 ; i<rawgetBillNo.testdata.length;i++ ){
            billlist.add(rawgetBillNo.testdata[i].docNum.toString() );
          }
          loading = false;
        });

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> SavePostData() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading=true;
    });
    var body = {
      "FormID":1,
      "Type":_typeAheadController.text,
      "LocCode":alterloccode,
      "LocName":alterlocname,
      "EmpCode":altersalespersoncode,
      "EmpName":altersalespersoname,
      "ExpenseCode":ExpenceCode,
      "ExpenseName":Edt_ExpenceName.text,
      "Amount":_Edt_Amt.text.isEmpty?0:double.parse(_Edt_Amt.text),
      "VehicleNo":altervechicleNo,
      "VehicleName":altervechiclename,
      "CardCode":alterCardCode,
      "CardName":alterCardName,
      "BillNo": Edt_BillNo.text,
      "BillAmount":Edt_BillAmt.text.isEmpty?0: double.parse(Edt_BillAmt.text),
      "CardType":Paytype.toString(),
      "TransNo":Edt_TransId.text,
      "Remarks":Edt_Remarks.text,
      "Status": int.parse(billdocentry.toString()) ,
      "SapStatus":0,
      "CreatedBy":int.parse(sessionuserID),
      "BranchId":int.parse(sessionbranchcode)
    };
    print(sessionuserID);
    print(jsonEncode(body));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_EXPENSION'),
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
      } else {
        print(response.body);
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseCustomer()));
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

}
class TempPriceListDinningModel {
  String locCode;
  var occCode;
  String occName;
  TempPriceListDinningModel(this.locCode, this.occCode, this.occName);
}
