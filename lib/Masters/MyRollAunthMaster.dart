// ignore_for_file: deprecated_member_use, non_constant_identifier_names, missing_return

import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Masters/RollAuthScreenpermision.dart';
import 'package:bestmummybackery/Model/MyTableMasterModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/Rollauthmodel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
//import 'package:bestmummybackery/PriceList/Models/PriceListDinningModel.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyRollAunthMaster extends StatefulWidget {
  MyRollAunthMaster({Key key, }): super(key: key);

  @override
  _MyRollAunthMasterState createState() => _MyRollAunthMasterState();
}

class _MyRollAunthMasterState extends State<MyRollAunthMaster> {

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

  bool loading = false;
  int SecreeId = 0;

  var EditBum;
  var EditPeace;

  var _DisType = new TextEditingController();
  var _DiscValue = new TextEditingController();
  var _RollName = new TextEditingController();
  int OccCode = 0;
  //OSRDModel detailitems;
  LocationModel locationModel = new LocationModel();
  OccModel occModel = new OccModel();

  LocationResult test;
  //Result Additem;
  static WastageItemModel ItemList;

  String alterloccode='';
  var alterlocname='';
  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;

  MyTableMasterModel RawMyTableMasterModel;
  List<TempMyTableMasterModel> SecMyTableMasterModel = new List();
  List<DisType> SecDisType = new List();

  Rollauthmodel RawRollauthmodel;

  @override
  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocationval();
    SecDisType.addAll([
      DisType(1, 'Rupees'),
      DisType(2, 'Percentage')
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);
   // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return tablet
        ? Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
                child: Scaffold(appBar: AppBar(title: Text("My Roll Authentication"),),
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
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Choose Dinning'),
                                                    content: Container(
                                                      width: double.minPositive,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:SecDisType.length,
                                                        itemBuilder:(BuildContext context,int index) {
                                                          return ListTile(
                                                            title: Text(
                                                                SecDisType[index].Discription),
                                                            onTap: () {
                                                              setState(() {
                                                                _DisType.text =SecDisType[index].Discription;
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
                                              width: width / 5,
                                              margin: EdgeInsets.only(left: 15),
                                              child: TextField(
                                                controller: _DisType,
                                                keyboardType: TextInputType.number,
                                                enabled: false,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                                    hintText: 'Discount Type',
                                                    labelText: 'Discount Type',
                                                    labelStyle: TextStyle(color: Colors.grey.shade600), border: OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width / 7,
                                            margin: EdgeInsets.only(left: 15),
                                            child: TextField(
                                              controller: _DiscValue,
                                              keyboardType: TextInputType.text,
                                              enabled: true,
                                              style: TextStyle(fontSize: 12,),
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                  hintText: 'Enter Amt/ %',
                                                  labelText: 'Enter Amt/ %',
                                                  labelStyle: TextStyle(color: Colors.grey.shade600),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          Container(
                                            width: width / 7,
                                            margin: EdgeInsets.only(left: 15),
                                            child: TextField(
                                              controller: _RollName,
                                              keyboardType: TextInputType.text,
                                              enabled: true,
                                              style: TextStyle(fontSize: 12,),
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 3,bottom: 2,left: 10,right: 10),
                                                  hintText: 'Roll Name',
                                                  labelText: 'Roll Name',
                                                  labelStyle: TextStyle(color: Colors.grey.shade600),
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                          Container(
                                            width: width / 12,
                                            margin: EdgeInsets.only(left: 15),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (alterlocname == '' && alterloccode =='') {
                                                  Fluttertoast.showToast(msg: "Choose The Location");
                                                } else if (_DisType.text == '') {
                                                  Fluttertoast.showToast(msg: "Choose The Discount type");
                                                } else if (_DiscValue.text == '') {
                                                  Fluttertoast.showToast(msg: "Enter The Creation Name");
                                                }else if (_RollName.text == '') {
                                                  Fluttertoast.showToast(msg: "Enter The Creation Name");
                                                }
                                                else {
                                                  setState(() {
                                                    PostSaved(1, 0,"Y");
                                                  });
                                                }
                                              },
                                              child: Text('ADD'),
                                              //child: Text('Add'),
                                            ),
                                          ),
                                        ],
                                      ),
                                   SizedBox(height: 10,),
                                   Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: RawRollauthmodel == null
                                                ? Center(
                                                  child:
                                                    Text('Add ItemCode Line Table'), )
                                                  : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                    showCheckboxColumn: false,
                                                      columns: const <DataColumn>[
                                                        DataColumn(
                                                          label: Text('DocNo',style: TextStyle(color: Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Location',style: TextStyle(color: Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Dis Type',style: TextStyle(color: Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Amt/Per',style: TextStyle(color: Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Roll Name',style: TextStyle(color: Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Active/InActive',style: TextStyle(color: Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Edit',style: TextStyle(color: Colors.white),),
                                                        ),
                                                      ],
                                                    rows: RawRollauthmodel.testdata.map((list) => DataRow(cells: [
                                                          DataCell(
                                                            Text(list.docNo.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                                list.location.toString(),textAlign:TextAlign.left),),
                                                          DataCell(
                                                            Text(
                                                                list.disType.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Text(list.valuess.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Text(list.rallName.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Wrap(
                                                              direction:Axis.vertical, //default
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary: list.active =='Y' ? Colors.greenAccent : Colors.redAccent,textStyle: TextStyle(color: Colors.white)),
                                                                  onPressed: () {
                                                                    print(list.active);
                                                                    setState(() {
                                                                      list.active == 'Y' ? list.active = 'N' : list.active = 'Y';
                                                                      PostSaved(3, list.docNo,list.active);
                                                                    });
                                                                  },

                                                                  child: Text((list.active =='Y' ? 'Click to Disable' : 'Click to Enable')),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(primary: Colors.blue.shade900,textStyle: TextStyle(color: Colors.white)),
                                                                onPressed: () {
                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)
                                                                  =>MyRollAunthScreenpermision(DocNo:list.docNo,
                                                                                               Location:list.location,
                                                                                               RollName:list.rallName )));

                                                                },
                                                              child: Text('Edit',style: TextStyle(color: Colors.white),),
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
        : Container();
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
      getDataonscreen();
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

          loading = false;
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


  Future<http.Response> PostSaved(int FormId,int DocNo, String Active ) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {

    "FormID":FormId,
    "DocNo":DocNo,
    "Location":alterloccode==''?0: int.parse(alterloccode),
    "DisType":_DisType.text,
    "Valuess":_DiscValue.text,
    "RollName": alterlocname+"-"+_RollName.text,
    "CreateBy":int.parse(sessionuserID),
    "ScreenId":1,
    "ScreenName":"ScreenName",
    "Active":Active

    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'RollauthMaster'),
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
        log(response.body);
        alterloccode ='';
        alterlocname='';
        _DisType.text ='';
        _DiscValue.text='';
        _RollName.text ='';
        setState(() {
          loading = false;
          getDataonscreen();
        });

      }
    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<http.Response> getDataonscreen() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "FormID":2,
      "DocNo":0,
      "Location":0,
      "DisType":_DisType.text,
      "Valuess":_DiscValue.text,
      "RollName":_RollName.text,
      "CreateBy":int.parse(sessionuserID),
      "ScreenId":1,
      "ScreenName":"ScreenName",
      "Active":"Y"
    };
    print(sessionuserID);
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'RollauthMaster'),
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
        log(response.body);
        RawRollauthmodel = Rollauthmodel.fromJson(jsonDecode(response.body));
        setState(() {
          loading = false;
        });
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
  TempMyTableMasterModel(this.docNo, this.createName, this.location, this.locationName, this.occCode, this.occName, this.tableNo, this.totalSeats, this.docDate,this.userId, this.active);
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
  TempMyPricelistMasterSubTab2Model(this.itemCode, this.location, this.locationName, this.variance, this.occCode, this.occName, this.rate, this.active, this.tapIndex);
}

class AddListItemRec {
  var AddItemCode;
  var AddItemName;
  var AddBum;
  var Piece;
  var AcInc;
  var DocNo;
  var LineId;
  AddListItemRec(this.AddItemCode, this.AddItemName, this.AddBum, this.Piece, this.AcInc, this.DocNo, this.LineId);
}

class DisType {
  var Code;
  var Discription;

  DisType(this.Code, this.Discription);
}


class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<ItemFillModel> my = new List();
    if (_MyRollAunthMasterState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _MyRollAunthMasterState.ItemList.result.length; a++)
        if (_MyRollAunthMasterState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _MyRollAunthMasterState.ItemList.result[a].itemCode,
              _MyRollAunthMasterState.ItemList.result[a].itemName,
              _MyRollAunthMasterState.ItemList.result[a].uOM,
              _MyRollAunthMasterState.ItemList.result[a].qty,
              _MyRollAunthMasterState.ItemList.result[a].Stock));
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


