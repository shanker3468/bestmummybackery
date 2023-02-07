
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/MyTableMasterModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/PriceList/Models/PriceListDinningModel.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyTableMaster extends StatefulWidget {
  MyTableMaster(
      {Key key, this.PostUom, this.PostItemCode, this.PostItemName, int Index})
      : super(key: key);
  var PostUom;
  var PostItemCode;
  var PostItemName;
  int Index;
  @override
  _MyTableMasterState createState() => _MyTableMasterState();
}

class _MyTableMasterState extends State<MyTableMaster> {
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
  int InsertFormId = 0;
  int HeaderDocNo = 0;
  int GetDocNUm = 0;
  bool loading = false;
  bool UpdateMode = false;
  int SecreeId = 0;
  int ReqFromId = 0;
  var EditBum;
  var EditPeace;
  var _Rate = new TextEditingController();
  var _TableNo = new TextEditingController();
  var _OccName = new TextEditingController();
  var _CreationName = new TextEditingController();
  var _TotalSeats = new TextEditingController();
  int OccCode = 0;
  //OSRDModel detailitems;
  LocationModel locationModel = new LocationModel();
  OccModel occModel = new OccModel();

  LocationResult test;
  //Result Additem;
  static WastageItemModel ItemList;
  String alterocccode;
  String alterocccname;
  String alterloccode;
  var alterlocname;
  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;

  PriceListDinningModel RawPriceListDinningModel;
  List<TempPriceListDinningModel> SecPriceListDinningModel = new List();

  MyTableMasterModel RawMyTableMasterModel;
  List<TempMyTableMasterModel> SecMyTableMasterModel = new List();

  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocationval();
    //ReqFromId = 8;
    //PriceLisMastePost();
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
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("My Table Master"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _TableNo,
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                          hintText: 'Table Number',
                                          labelText: 'Table Number',
                                          labelStyle: TextStyle(
                                              color: Colors.grey.shade600),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: loc,
                                      label: "Select Location",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0;kk < locationModel.result.length; kk++) {
                                          if (locationModel.result[kk].name ==val) {
                                            print(locationModel.result[kk].code);
                                            alterlocname =locationModel.result[kk].name;
                                            alterloccode = locationModel.result[kk].code.toString();
                                          }
                                        }
                                      },
                                      selectedItem: alterlocname,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ReqFromId = 11;
                                      GetDinningMaster().then(
                                        (value) => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Choose Dinning'),
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
                                                          _OccName.text = SecPriceListDinningModel[index].occName;
                                                          OccCode = int.parse(SecPriceListDinningModel[index].occCode.toString());
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
                                      width: width / 5,
                                      margin: EdgeInsets.only(left: 15),
                                      child: TextField(
                                        controller: _OccName,
                                        keyboardType: TextInputType.number,
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                            hintText: 'Select Dinning',
                                            labelText: 'Select Dinning',
                                            labelStyle: TextStyle(color: Colors.grey.shade600), border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _CreationName,
                                      keyboardType: TextInputType.text,
                                      enabled: true,
                                      style: TextStyle(fontSize: 12,),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                          hintText: 'Creation Name',
                                          labelText: 'Creation Name',
                                          labelStyle: TextStyle(
                                              color: Colors.grey.shade600),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    width: width / 12,
                                    margin: EdgeInsets.only(left: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_TableNo.text == '') {
                                          Fluttertoast.showToast(msg: "Enter Table No");
                                        } else if (alterlocname == '') {
                                          Fluttertoast.showToast(msg: "Choose The Location");
                                        } else if (_OccName.text == '') {
                                          Fluttertoast.showToast(msg: "Choose The Dinninig");
                                        } else if (_CreationName.text == '') {
                                          Fluttertoast.showToast(msg: "Enter The Creation Name");
                                        } else if (_TotalSeats.text == '') {
                                          Fluttertoast.showToast(msg: "Enter The Total Seats..");
                                        } else {
                                          ReqFromId = 1;
                                          PriceLisMastePost();
                                        }
                                      },
                                      child: Text('ADD'),
                                      //child: Text('Add'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _TotalSeats,
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                          hintText: 'Total Seats',
                                          labelText: 'Total Seats',
                                          labelStyle: TextStyle(color: Colors.grey.shade600),border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: width / 5,
                                    margin: EdgeInsets.only(left: 15),
                                  ),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                  ),
                                  Container(
                                    width: width / 12,
                                    margin: EdgeInsets.only(left: 15),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SecMyTableMasterModel.length == 0
                                        ? Center(
                                            child:
                                                Text('Add ItemCode Line Table'),
                                          )
                                        : DataTable(
                                            sortColumnIndex: 0,
                                            sortAscending: true,
                                            headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                            showCheckboxColumn: false,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  'Table No',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'No.of seats',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'location',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Creation Name',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Distribution',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Active/InActive',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            rows: SecMyTableMasterModel.map(
                                              (list) => DataRow(cells: [
                                                DataCell(
                                                  Text(list.tableNo.toString(),textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(
                                                      list.totalSeats.toString(),textAlign:TextAlign.left),),
                                                DataCell(
                                                  Text(
                                                      list.locationName.toString(),textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.createName.toString(),textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.occName.toString(),textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Wrap(
                                                    direction:Axis.vertical, //default
                                                    alignment:WrapAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(primary: list.active =='Y'
                                                        ? Colors.greenAccent
                                                            : Colors.redAccent,textStyle: TextStyle(color: Colors.white)),
                                                        onPressed: () {
                                                          print(list.active);
                                                          setState(() {
                                                            list.active == 'Y' ? list.active = 'N' : list.active = 'Y';
                                                          });
                                                          ReqFromId = 3;
                                                          PriceLisMasteUpdate(list.docNo,list.active,);
                                                        },
                                                        child: Text((list.active =='Y'
                                                            ? 'Click to Disable'
                                                            : 'Click to Enable')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ]),
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
        setState(() {
          locationModel = LocationModel.fromJson(jsonDecode(response.body));
          loc.clear();
          for (int k = 0; k < locationModel.result.length; k++) {
            loc.add(locationModel.result[k].name);
          }
          ReqFromId = 2;
          loading = true;
          PriceLisMastePost();
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

  Future<http.Response> GetDinningMaster() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('ItemCode' + widget.PostItemCode.toString());
      print('ItemName' + widget.PostItemName.toString());
      print('ItemUOM' + widget.PostUom.toString());
      print('TabIndex' + 2.toString());
      print('Location' + alterloccode.toString());
      //SecMyPricelistMasterSubTab2Model.clear();
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": 1,
      "ItemCode": widget.PostItemCode,
      "ItemName": widget.PostItemName,
      "ItemUOM": widget.PostUom,
      "Location": alterloccode,
      "LocationName": alterlocname,
      "variance": "",
      "OccCode": 0,
      "OccName": "D",
      "Rate": _Rate.text.isEmpty ? 0 : _Rate.text,
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
          SecPriceListDinningModel.clear();
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print('FromId Selva ' + ReqFromId.toString());
        if (ReqFromId == 11) {
          print(response.body);
          setState(() {
            SecPriceListDinningModel.clear();
            RawPriceListDinningModel =
                PriceListDinningModel.fromJson(jsonDecode(response.body));
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
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PriceLisMastePost() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('LocationCOde' + alterloccode.toString());
      print('LocName' + alterlocname.toString());
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": 1,
      "ScreenId": 1,
      "CreationName": _CreationName.text,
      "Location": alterloccode,
      "LocationName": alterlocname,
      "OccCode": OccCode,
      "OccName": _OccName.text,
      "TableNo": _TableNo.text,
      "TotalSeats": _TotalSeats.text,
      "UserID": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'TABLE_MASTER_SP'),
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
          ReqFromId = 2;
          loading = true;
          PriceLisMastePost();
        }
        // FRONT DATA TBA 1
        else if (ReqFromId == 2) {
          setState(() {
            loading = false;
          });

          print(response.body);
          setState(() {
            SecMyTableMasterModel.clear();
            RawMyTableMasterModel =
                MyTableMasterModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawMyTableMasterModel.testdata.length; i++)
              SecMyTableMasterModel.add(
                TempMyTableMasterModel(
                    RawMyTableMasterModel.testdata[i].docNo,
                    RawMyTableMasterModel.testdata[i].createName,
                    RawMyTableMasterModel.testdata[i].location,
                    RawMyTableMasterModel.testdata[i].locationName,
                    RawMyTableMasterModel.testdata[i].occCode,
                    RawMyTableMasterModel.testdata[i].occName,
                    RawMyTableMasterModel.testdata[i].tableNo,
                    RawMyTableMasterModel.testdata[i].totalSeats,
                    RawMyTableMasterModel.testdata[i].docDate,
                    RawMyTableMasterModel.testdata[i].userId,
                    RawMyTableMasterModel.testdata[i].active),
              );
            alterloccode = '';
            alterlocname = '';
          });
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PriceLisMasteUpdate(int DocNo, String Active) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('Active' + Active.toString());
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": DocNo,
      "ScreenId": 1,
      "CreationName": Active,
      "Location": 1,
      "LocationName": '',
      "OccCode": 1,
      "OccName": "",
      "TableNo": 1,
      "TotalSeats": 2,
      "UserID": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'TABLE_MASTER_SP'),
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
        print('YesResponce');
        //INSERT
        if (ReqFromId == 3) {
          print(response.body);
          setState(() {
            loading = false;
          });
          ReqFromId = 2;
          loading = true;
          PriceLisMastePost();
        }
        // FRONT DATA TBA 1
        else if (ReqFromId == 2) {
          setState(() {
            loading = false;
          });
          print(response.body);
          setState(() {
            SecMyTableMasterModel.clear();
            RawMyTableMasterModel =
                MyTableMasterModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawMyTableMasterModel.testdata.length; i++)
              SecMyTableMasterModel.add(
                TempMyTableMasterModel(
                    RawMyTableMasterModel.testdata[i].docNo,
                    RawMyTableMasterModel.testdata[i].createName,
                    RawMyTableMasterModel.testdata[i].location,
                    RawMyTableMasterModel.testdata[i].locationName,
                    RawMyTableMasterModel.testdata[i].occCode,
                    RawMyTableMasterModel.testdata[i].occName,
                    RawMyTableMasterModel.testdata[i].tableNo,
                    RawMyTableMasterModel.testdata[i].totalSeats,
                    RawMyTableMasterModel.testdata[i].docDate,
                    RawMyTableMasterModel.testdata[i].userId,
                    RawMyTableMasterModel.testdata[i].active),
              );
            alterloccode = '';
            alterlocname = '';
          });
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }
}

class TempMyTableMasterModel {
  var docNo;
  String createName;
  var location;
  String locationName;
  var occCode;
  String occName;
  var tableNo;
  var totalSeats;
  String docDate;
  var userId;
  String active;
  TempMyTableMasterModel(
      this.docNo,
      this.createName,
      this.location,
      this.locationName,
      this.occCode,
      this.occName,
      this.tableNo,
      this.totalSeats,
      this.docDate,
      this.userId,
      this.active);
}

class TempPriceListDinningModel {
  String locCode;
  var occCode;
  String occName;
  TempPriceListDinningModel(this.locCode, this.occCode, this.occName);
}

class TempRawPriceListVarianceModel {
  String itemCode;
  String variance;

  TempRawPriceListVarianceModel(this.itemCode, this.variance);
}

class TempMyPricelistMasterSubTab2Model {
  String itemCode;
  int location;
  String locationName;
  String variance;
  int occCode;
  String occName;
  var rate;
  String active;
  int tapIndex;
  TempMyPricelistMasterSubTab2Model(
      this.itemCode,
      this.location,
      this.locationName,
      this.variance,
      this.occCode,
      this.occName,
      this.rate,
      this.active,
      this.tapIndex);
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
    if (_MyTableMasterState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _MyTableMasterState.ItemList.result.length; a++)
        if (_MyTableMasterState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _MyTableMasterState.ItemList.result[a].itemCode,
              _MyTableMasterState.ItemList.result[a].itemName,
              _MyTableMasterState.ItemList.result[a].uOM,
              _MyTableMasterState.ItemList.result[a].qty,
              _MyTableMasterState.ItemList.result[a].Stock));
      return my;
    }
  }
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

class TempMyPricelistMasterSubTab1Model {
  String itemCode;
  int code;
  String locName;
  String active;

  TempMyPricelistMasterSubTab1Model(
      this.itemCode, this.code, this.locName, this.active);
}
