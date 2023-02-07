import 'dart:convert';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/GetDistrictModel.dart';
import 'package:bestmummybackery/Model/MyGetStateCuntryModel.dart';
import 'package:bestmummybackery/Model/MyTableMasterModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DistrictMaster extends StatefulWidget {
  DistrictMaster(
      {Key key, this.PostUom, this.PostItemCode, this.PostItemName, int Index})
      : super(key: key);
  var PostUom;
  var PostItemCode;
  var PostItemName;
  int Index;
  @override
  _DistrictMasterState createState() => _DistrictMasterState();
}

class _DistrictMasterState extends State<DistrictMaster> {
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
  var _DistrictName = new TextEditingController();
  var _Place = new TextEditingController();

  int OccCode = 0;
  //OSRDModel detailitems;

  LocationResult test;
  //Result Additem;
  static WastageItemModel ItemList;
  static MyGetStateCuntryModel SateList;
  static MyGetStateCuntryModel MYStateList;
  String alterocccode="";
  String alterocccname="";
  var alterloccode = 0;
  var alterlocname="";
  String Code = '';
  String Discription = '';
  bool isUpdating;
  var StateCode = '';
  var StateName = '';

  List<String> Sat = new List();
  List<String> Satate = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;

  MyTableMasterModel RawMyTableMasterModel;
  List<TempMyTableMasterModel> SecMyTableMasterModel = new List();

  GetDistrictModel RawGetDistrictModel;
  List<TempGetDistrictModel> SecGetDistrictModel = new List();

  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getcountrynval();
    getStateval();
    ReqFromId = 4;
    PriceLisMastePost();
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
                  title: Text("My District Master"),
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
                                mainAxisAlignment:MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: Sat,
                                      label: "Select Country",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0; kk < SateList.testdata.length;kk++) {
                                          if (SateList.testdata[kk].discription == val) {
                                            print(SateList.testdata[kk].code);
                                            Code = SateList.testdata[kk].code;
                                            Discription = SateList.testdata[kk].discription;
                                          }
                                        }
                                      },
                                      selectedItem: Discription,
                                    ),
                                  ),
                                  Container(
                                    width: width / 4,
                                    color: Colors.white,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items: Satate,
                                      label: "Select State",
                                      onChanged: (val) {
                                        print(val);
                                        for (int kk = 0; kk < MYStateList.testdata.length; kk++) {
                                          if (MYStateList.testdata[kk].discription == val) {
                                            print(MYStateList.testdata[kk].code);
                                            StateCode =MYStateList.testdata[kk].code;
                                            StateName = MYStateList.testdata[kk].discription;
                                          }
                                        }
                                      },
                                      selectedItem: StateName,
                                    ),
                                  ),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _DistrictName,
                                      keyboardType: TextInputType.text,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                          hintText: 'District Name',
                                          labelText: 'District Name',
                                          labelStyle: TextStyle(color: Colors.grey.shade600),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _Place,
                                      keyboardType: TextInputType.text,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                          hintText: 'Place',
                                          labelText: 'Place',
                                          labelStyle: TextStyle(color: Colors.grey.shade600),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    width: width / 12,
                                    margin: EdgeInsets.only(left: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if(Code==""&&Discription==""){
                                          Fluttertoast.showToast(msg: "Select Country..");
                                        }else if (StateCode==""&&StateName==""){
                                          Fluttertoast.showToast(msg: "Select State..");
                                        }else if (_DistrictName.text==""){
                                          Fluttertoast.showToast(msg: "Enter The District Name");
                                        }else if (_Place.text==""){
                                          Fluttertoast.showToast(msg: "Enter The Place Name");
                                        }else{
                                          Fluttertoast.showToast(msg: "Save");
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
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SecGetDistrictModel.length == 0
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
                                                  'District Name',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'State',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Country',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Place',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Active/Inactive',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            rows: SecGetDistrictModel.map(
                                              (list) => DataRow(cells: [
                                                DataCell(
                                                  Text(list.district.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(
                                                      list.stateName.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(
                                                      list.contryName.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.place.toString(),
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
                                                          print(list.active);
                                                          setState(() {
                                                            list.active == 'Y' ? list.active = 'N' : list.active = 'Y';
                                                          });
                                                          ReqFromId = 5;
                                                          PriceLisMasteUpdate(list.docNum,list.active,);
                                                        },
                                                        child: Text((list.active == 'Y' ? 'Click to Disable': 'Click to Enable')),
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

  Future<http.Response> getcountrynval() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('CountryName');
    });
    var body = {
      "FormID": 2,
      "DocNo": 1,
      "ScreenId": 1,
      "Country": "IN",
      "State": "TN",
      "District": "District",
      "Place": "Place",
      "Active": "Y",
      "UserId": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DISTRICT_MASTER_SP'),
        headers: headers,
        body: jsonEncode(body));
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        print('YES Response ');
        SateList = MyGetStateCuntryModel.fromJson(jsonDecode(response.body));
        Sat.clear();
        for (int k = 0; k < SateList.testdata.length; k++) {
          Sat.add(SateList.testdata[k].discription);
        }

        print(response.body);
        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getStateval() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('CountryName');
    });
    var body = {
      "FormID": 3,
      "DocNo": 1,
      "ScreenId": 1,
      "Country": "IN",
      "State": "TN",
      "District": "District",
      "Place": "Place",
      "Active": "Y",
      "UserId": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DISTRICT_MASTER_SP'),
        headers: headers,
        body: jsonEncode(body));
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        //StateList.testdata.clear();
        print('YES Response ');
        MYStateList = MyGetStateCuntryModel.fromJson(jsonDecode(response.body));
        Satate.clear();
        for (int k = 0; k < MYStateList.testdata.length; k++) {
          Satate.add(MYStateList.testdata[k].discription);
        }

        print(response.body);
        setState(() {
          loading = false;
        });
      }
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

  Future<http.Response> PriceLisMastePost() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('alterloccode' + alterloccode.toString());
      print('LocName' + alterlocname.toString());
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": 1,
      "ScreenId": 1,
      "Country": Code,
      "State": StateCode,
      "District": _DistrictName.text,
      "Place": _Place.text,
      "Active": "Y",
      "UserId": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DISTRICT_MASTER_SP'),
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
          ReqFromId = 4;
          loading = true;
          PriceLisMastePost();
        }
        // FRONT DATA TBA 1
        else if (ReqFromId == 4) {
          setState(() {
            loading = false;
          });
          print(response.body);
          setState(() {
            SecGetDistrictModel.clear();
            RawGetDistrictModel = GetDistrictModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawGetDistrictModel.testdata.length; i++)
              SecGetDistrictModel.add(
                TempGetDistrictModel(
                    RawGetDistrictModel.testdata[i].docNum,
                    RawGetDistrictModel.testdata[i].contryName,
                    RawGetDistrictModel.testdata[i].stateName,
                    RawGetDistrictModel.testdata[i].district,
                    RawGetDistrictModel.testdata[i].place,
                    RawGetDistrictModel.testdata[i].active),
              );
            alterloccode = 0;
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
      "Country": Code,
      "State": StateCode,
      "District": _DistrictName.text,
      "Place": _Place.text,
      "Active": Active,
      "UserId": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DISTRICT_MASTER_SP'),
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
        if (ReqFromId == 5) {
          print(response.body);
          setState(() {
            loading = false;
          });
          ReqFromId = 4;
          loading = true;
          PriceLisMastePost();
        }
        // FRONT DATA TBA 1
        // else if (ReqFromId == 2) {
        //   setState(() {
        //     loading = false;
        //   });
        //   print(response.body);
        //   setState(() {
        //     SecMyMixBoxModel.clear();
        //     RawMyMixBoxModel =
        //         MyMixBoxModel.fromJson(jsonDecode(response.body));
        //     for (int i = 0; i < RawMyMixBoxModel.testdata.length; i++)
        //       SecMyMixBoxModel.add(
        //         TempMyMixBoxModel(
        //             RawMyMixBoxModel.testdata[i].docNo,
        //             RawMyMixBoxModel.testdata[i].itemCode,
        //             RawMyMixBoxModel.testdata[i].itemName,
        //             RawMyMixBoxModel.testdata[i].uom,
        //             RawMyMixBoxModel.testdata[i].qty,
        //             RawMyMixBoxModel.testdata[i].locCode,
        //             RawMyMixBoxModel.testdata[i].locName,
        //             RawMyMixBoxModel.testdata[i].active),
        //       );
        //     alterloccode = 0;
        //     alterlocname = '';
        //   });
        // }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }
}

class TempGetDistrictModel {
  int docNum;
  String contryName;
  String stateName;
  String district;
  String place;
  String active;
  TempGetDistrictModel(this.docNum, this.contryName, this.stateName,this.district, this.place, this.active);
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
    if (_DistrictMasterState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _DistrictMasterState.ItemList.result.length; a++)
        if (_DistrictMasterState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _DistrictMasterState.ItemList.result[a].itemCode,
              _DistrictMasterState.ItemList.result[a].itemName,
              _DistrictMasterState.ItemList.result[a].uOM,
              _DistrictMasterState.ItemList.result[a].qty,
              _DistrictMasterState.ItemList.result[a].Stock));
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
