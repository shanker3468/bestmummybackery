import 'dart:convert';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/OSRDModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/PettyCashGetModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PettyCashMaster extends StatefulWidget {
  const PettyCashMaster({Key key}) : super(key: key);

  @override
  _PettyCashMasterState createState() => _PettyCashMasterState();
}

class _PettyCashMasterState extends State<PettyCashMaster> {
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
  int InsertFormId = 0;
  int HeaderDocNo = 0;
  int GetDocNUm = 0;
  bool loading = false;
  bool UpdateMode = false;
  int SecreeId = 0;
  var EditBum;
  var EditPeace;
  LocationModel locationModel = new LocationModel();
  OccModel occModel = new OccModel();
  LocationResult test;
  static WastageItemModel ItemList;
  String alterocccode = '';
  String alterocccname = '';
  String alterloccode = '';
  var alterlocname = '';
  bool isUpdating;

  var _SelPettycashLimit = new TextEditingController();
  var _SelAdvanced = new TextEditingController();
  var _SelCurrentName = new TextEditingController();
  var _SelExpenseamount = new TextEditingController();

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;
  List<AddListItemRec> AddListItem = new List();
  PettyCashGetModel RawPettyCashGetModel;
  List<TempPettyCashGetModel> SecPettyCashGetModel = new List();

  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocationval();

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
    return tablet
        ? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)],
              ),
            ),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Petty Cash Master"),
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
                                    width: width / 3,
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

                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: TextField(
                                      controller: _SelPettycashLimit,
                                      enabled: true,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                        hintText: 'Pettycash Limit',
                                        labelText: 'Pettycash Limit',
                                        labelStyle: TextStyle(color: Colors.grey.shade600),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: TextField(
                                      controller: _SelAdvanced,
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      style: TextStyle(fontSize: 12,),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                        hintText: 'Advance',
                                        labelText: 'Advance',
                                        labelStyle: TextStyle(color: Colors.grey.shade600),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 3,
                                    color: Colors.white,
                                    child: TextField(
                                      controller: _SelCurrentName,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                        hintText: 'Current amount',
                                        labelText: 'Current amount',
                                        labelStyle: TextStyle(color: Colors.grey.shade600),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: TextField(
                                      controller: _SelExpenseamount,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                        hintText: 'Expense amount',
                                        labelText: 'Expense amount',
                                        labelStyle: TextStyle(color: Colors.grey.shade600),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (alterlocname == '') {
                                          Fluttertoast.showToast(msg: "Choose The Location");
                                        } else if (_SelPettycashLimit.text == '') {
                                          Fluttertoast.showToast(msg: "Enter The Pettycash limit");
                                        } else if (_SelAdvanced.text == '') {
                                          Fluttertoast.showToast(msg: "Enter The Advance");
                                        } else if (_SelCurrentName.text == '') {
                                          Fluttertoast.showToast(msg: "Enter The Current Amt");
                                        } else if (_SelExpenseamount.text =='') {
                                          Fluttertoast.showToast(msg: "Enter The Expence Amt");
                                        } else {
                                          print('Save');
                                          setState(() {
                                            InsertFormId = 1;
                                          });
                                          postdataheader(1, "Y");
                                        }
                                      },
                                      child: Text('ADD'),
                                      //child: Text('Add'),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SecPettyCashGetModel.toString() == "null"
                                        ? Center(
                                            child:Text('Add ItemCode Line Table'),
                                          )
                                        : DataTable(
                                            sortColumnIndex: 0,
                                            sortAscending: true,
                                            headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                            showCheckboxColumn: false,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  'DocNo',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Location',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Advance',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Current amount',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Expense amount',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Active',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Action',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            rows: SecPettyCashGetModel.map(
                                              (list) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      list.docNo.toString(),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      list.locName.toString(),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      list.advance.toString(),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        list.currentamount.toString(),
                                                        textAlign:TextAlign.left),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      list.expenseamount.toString(),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      list.active.toString(),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Wrap(
                                                      direction: Axis.vertical, //default
                                                      alignment:WrapAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: list.active == 'Y' ? Colors.greenAccent : Colors.redAccent,textStyle: TextStyle(color: Colors.white)),
                                                          onPressed: () {
                                                            print(list.active);
                                                            setState(() {
                                                              InsertFormId = 3;
                                                              list.active == 'Y' ? list.active = 'N' : list.active = 'Y';
                                                            });
                                                            postdataheader(list.docNo, list.active);
                                                          },
                                                          child: Text((list.active == 'Y' ? 'Click to Disable' : 'Click to Enable')),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ).toList(),
                                          ),
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

        print(locationModel);
        setState(() {
          InsertFormId = 2;
          postdataheader(0, '');
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future getItem() {
    GetItemWastage(sessionuserID, "1").then((response) {
      // print(response.body);
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
          ItemList = WastageItemModel.fromJson(jsonDecode(response.body));
          //log(response.body.toString());
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> postdataheader(docNo, Active) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID' + InsertFormId.toString());
    });
    var body = {
      "FormID": InsertFormId,
      "DocNo": docNo,
      "ScreenId": 1,
      "Location": alterloccode,
      "LocationName": alterlocname,
      "PettycashLimit":
          _SelPettycashLimit.text.isEmpty ? 0.0 : _SelPettycashLimit.text,
      "Advance": _SelAdvanced.text.isEmpty ? 1.2 : _SelAdvanced.text,
      "Currentamount":
          _SelCurrentName.text.isEmpty ? 1.2 : _SelCurrentName.text,
      "Expenseamount":
          _SelExpenseamount.text.isEmpty ? 1.2 : _SelExpenseamount.text,
      "UserID": 2,
      "Active": Active
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PETTYCASH_MASTER_SP'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      //print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        //// INsert REcord....///

        if (InsertFormId == 1) {
          if (decode["testdata"].toString() == '[]') {
            setState(() {
              loading = false;
            });
            print('NoResponse');
          } else {
            print(response.body);
            setState(() {
              print('Hai');
              InsertFormId = 2;
              postdataheader(0, '');
            });
            decode["testdata"][0]["STATUSNAME"].toString();
            HeaderDocNo = decode["testdata"][0]["DocNo"];
            Fluttertoast.showToast(
              msg: decode["testdata"][0]["STATUSNAME"].toString(),
            );
            alterlocname = '';
            _SelPettycashLimit.text = '';
            _SelAdvanced.text = '';
            _SelCurrentName.text = '';
            _SelExpenseamount.text = '';
          }
        }

        /// GET RECORDD/////

        else if (InsertFormId == 2) {
          print(response.body);
          if (decode["testdata"].toString() == '[]') {
            setState(() {
              loading = false;
            });
            print('NoResponse');
          } else {
            print('YesResponce');
            SecPettyCashGetModel.clear();
            RawPettyCashGetModel =
                PettyCashGetModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawPettyCashGetModel.testdata.length; i++)
              SecPettyCashGetModel.add(
                TempPettyCashGetModel(
                    RawPettyCashGetModel.testdata[i].docNo,
                    RawPettyCashGetModel.testdata[i].locCode,
                    RawPettyCashGetModel.testdata[i].locName,
                    RawPettyCashGetModel.testdata[i].pettycashLimit,
                    RawPettyCashGetModel.testdata[i].advance,
                    RawPettyCashGetModel.testdata[i].currentamount,
                    RawPettyCashGetModel.testdata[i].expenseamount,
                    RawPettyCashGetModel.testdata[i].createBy,
                    RawPettyCashGetModel.testdata[i].docDate,
                    RawPettyCashGetModel.testdata[i].active),
              );

            setState(() {
              loading = false;
            });
          }
        }

        /// Update Moode

        /// UPDATE MODE //

        else if (InsertFormId == 4) {
          print(response.body);
          if (decode["testdata"].toString() == '[]') {
            setState(() {
              loading = false;
            });
            print('NoResponse');
          } else {
            print('YesResponce');
            print(response.body);
            setState(() {
              print('Hai');
              InsertFormId = 2;
              postdataheader(0, '');
            });
            setState(() {
              loading = false;
            });
          }
        }

        /// finel else Part////
        else {
          setState(() {
            loading = false;
          });
        }
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
}

class TempPettyCashGetModel {
  int docNo;
  int locCode;
  String locName;
  var pettycashLimit;
  var advance;
  var currentamount;
  var expenseamount;
  int createBy;
  String docDate;
  String active;
  TempPettyCashGetModel(
      this.docNo,
      this.locCode,
      this.locName,
      this.pettycashLimit,
      this.advance,
      this.currentamount,
      this.expenseamount,
      this.createBy,
      this.docDate,
      this.active);
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
    if (_PettyCashMasterState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _PettyCashMasterState.ItemList.result.length; a++)
        if (_PettyCashMasterState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _PettyCashMasterState.ItemList.result[a].itemCode,
              _PettyCashMasterState.ItemList.result[a].itemName,
              _PettyCashMasterState.ItemList.result[a].uOM,
              _PettyCashMasterState.ItemList.result[a].qty,
              _PettyCashMasterState.ItemList.result[a].Stock));
      return my;
    }
  }
}

class ItemFillModel {
  String ItemCode;
  String ItemName;
  String UOM;
  var Qty;
  var Stock;

  ItemFillModel(this.ItemCode, this.ItemName, this.UOM, this.Qty, this.Stock);
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class TempVarianceMaster {
  String locationName;
  String itemCode;
  String itemName;
  int docNo;
  int userId;
  TempVarianceMaster(
      this.locationName, this.itemCode, this.itemName, this.docNo, this.userId);
}
