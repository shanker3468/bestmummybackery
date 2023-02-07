import 'dart:convert';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/PromotionMasterTransction.dart';
import 'package:bestmummybackery/Model/GetDistrictModel.dart';
import 'package:bestmummybackery/Model/GetPromotionModel.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PromotionMasterHome extends StatefulWidget {
  PromotionMasterHome({Key key}) : super(key: key);
  var PostUom = '';
  var PostItemCode = '';
  var PostItemName = '';
  int Index = 0;
  @override
  _PromotionMasterHomeState createState() => _PromotionMasterHomeState();
}

class _PromotionMasterHomeState extends State<PromotionMasterHome> {
  TextEditingController Edt_ProductName = TextEditingController();
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  int InsertFormId = 0;
  int HeaderDocNo = 0;
  bool loading = false;
  int SecreeId = 0;
  int ReqFromId = 0;
  bool isUpdating;

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;

  GetDistrictModel RawGetDistrictModel;
  List<TempGetDistrictModel> SecGetDistrictModel = new List();
  GetPromotionModel RawGetPromotionModel;
  List<TempGetPromotionModel> SecGetPromotionModel = new List();

  void initState() {
    isUpdating = false;
    getStringValuesSF();

    ReqFromId = 5;
    PromotionGetData();
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
                  title: Text("My Promotion Master"),
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
                                    width: width / 8,
                                    margin: EdgeInsets.only(left: 15),
                                    child: FloatingActionButton.extended(
                                      heroTag: "Create",
                                      backgroundColor: Colors.blue.shade700,
                                      icon: Icon(Icons.add),
                                      label: Text('Create'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PromotionMasterTransction(SendDocNo: 0),
                                          ),
                                        );
                                      },
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
                                    child: SecGetPromotionModel.length == 0
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
                                                label: Text('Discount Name',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Location',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Per/Amt',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Status',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Edit',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            rows: SecGetPromotionModel.map(
                                              (list) => DataRow(cells: [
                                                DataCell(
                                                  Text(
                                                      list.discountName.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(
                                                      list.locationName.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.amtPer.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Wrap(
                                                    direction:Axis.vertical, //default
                                                    alignment:WrapAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                        onPressed: () {
                                                          print(list.active);
                                                          setState(() {
                                                            list.active == 'Y'? list.active = 'N' : list.active = 'Y';
                                                          });
                                                          ReqFromId = 6;
                                                          PriceLisMasteUpdate(int.parse(list.docNo.toString()) ,list.active,);
                                                        },
                                                        child: Text((list.active =='Y'? 'Click to Disable': 'Click to Enable')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                DataCell(
                                                    Icon(Icons.edit),
                                                    onTap: () {
                                                        print(list.docNo);
                                                          Navigator.push(
                                                            context, MaterialPageRoute(
                                                              builder: (context) => PromotionMasterTransction(SendDocNo: list.docNo),
                                                            ),
                                                          );
                                                }),
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

  Error Validation(ErrorMsg) {
    Fluttertoast.showToast(
        msg: ErrorMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<http.Response> PromotionGetData() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('PromotionGetDataFromId' + ReqFromId.toString());
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": 1,
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
      "UserId": 20,
      "Active": "Y",
      "AutomaticDis": "Y"
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_HEADER_SP'),
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
        if (ReqFromId == 5) {
          SecGetPromotionModel.clear();
          print(response.body);
          RawGetPromotionModel =
              GetPromotionModel.fromJson(jsonDecode(response.body));

          for (int i = 0; i < RawGetPromotionModel.testdata.length; i++)
            SecGetPromotionModel.add(
              TempGetPromotionModel(
                  RawGetPromotionModel.testdata[i].discountName,
                  RawGetPromotionModel.testdata[i].locationName,
                  RawGetPromotionModel.testdata[i].amtPer,
                  RawGetPromotionModel.testdata[i].active,
                  RawGetPromotionModel.testdata[i].docNo),
            );
          setState(() {
            loading = false;
          });
        }
        // FRONT DATA TBA 1
      }
    } else {
      setState(() {
        loading = false;
      });
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> PriceLisMasteUpdate(int DocNo, String Active) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FromId' + ReqFromId.toString());
      print('Active' + Active.toString());
      print(DocNo);
    });
    var body = {
      "FormID": ReqFromId,
      "DocNo": DocNo,
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
      "UserId": int.parse(sessionuserID),
      "Active": Active,
      "AutomaticDis":""
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'PROMOTION_HEADER_SP'),
        headers: headers,
        body: jsonEncode(body));
    print(body);
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
        if (ReqFromId == 6) {
          print(response.body);
          ReqFromId = 5;
          loading = true;
          PromotionGetData();
        }
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }
}

class TempGetPromotionModel {
  String discountName;
  String locationName;
  String amtPer;
  String active;
  var docNo;
  TempGetPromotionModel(this.discountName, this.locationName, this.amtPer,
      this.active, this.docNo);
}

class TempGetDistrictModel {
  int docNum;
  String contryName;
  String stateName;
  String district;
  String place;
  String active;
  TempGetDistrictModel(this.docNum, this.contryName, this.stateName,
      this.district, this.place, this.active);
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

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
