import 'dart:convert';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/MyMixBoxModel.dart';
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

class MyMixBoxMasterChild extends StatefulWidget {
  MyMixBoxMasterChild(
      {Key key, this.DocNo, this.PostItemCode, this.PostItemName})
      : super(key: key);
  var DocNo;
  var PostItemCode;
  var PostItemName;
  @override
  _MyMixBoxMasterChildState createState() => _MyMixBoxMasterChildState();
}

class _MyMixBoxMasterChildState extends State<MyMixBoxMasterChild> {
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
  var _Qty = new TextEditingController();
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
  var alterloccode = 0;
  var alterlocname;
  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;

  MyTableMasterModel RawMyTableMasterModel;
  List<TempMyTableMasterModel> SecMyTableMasterModel = new List();

  MyMixBoxModel RawMyMixBoxModel;
  List<TempMyMixBoxModel> SecMyMixBoxModel = new List();

  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocationval();
    getItem();
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
                  title: Text("Mix Box Master BOM-" + widget.PostItemName),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(10.0),
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
                                    width: width / 3,
                                    margin: EdgeInsets.only(left: 15),
                                    child: Container(
                                      width: width / 7,
                                      color: Colors.white,
                                      child: TypeAheadField(
                                        textFieldConfiguration:TextFieldConfiguration(
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                    hintText: "Select Product",
                                                    labelText: "Select Product",
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        Edt_ProductName.text = "";
                                                      },
                                                      icon: Icon(Icons.arrow_drop_down_circle),
                                                    ),
                                                    border:OutlineInputBorder()),
                                                controller: Edt_ProductName),
                                        suggestionsCallback: (pattern) async {
                                          return await BackendService.getSuggestions(pattern);
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                                suggestion.ItemName.toString()),
                                          );
                                        },
                                        onSuggestionSelected: (suggestion) {
                                          for (int i = 0;i < ItemList.result.length;i++) {
                                            this.Edt_ProductName.text = suggestion.ItemName.toString();
                                            //GrnSpinnerController.text = suggestion.toString();
                                            if (suggestion.ItemName.toString().length > 0) {
                                              Edt_ProductName.text = suggestion.ItemName.toString();
                                              alteritemcode = suggestion.ItemCode.toString();
                                              alteritemName = suggestion.ItemName.toString();
                                              alteritemuom = suggestion.UOM.toString();
                                              alteritemqty =suggestion.Qty.toString();
                                              alterstock =suggestion.Stock.toString();
                                            } else {
                                              ItemList.result.clear();
                                            }
                                          }
                                          ;
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 7,
                                    margin: EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: _Qty,
                                      keyboardType: TextInputType.text,
                                      enabled: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                          hintText: 'QTY',
                                          labelText: 'QTY',
                                          labelStyle: TextStyle(color: Colors.grey.shade600),
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  Container(
                                    width: width / 12,
                                    margin: EdgeInsets.only(left: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (Edt_ProductName.text == '') {
                                          Fluttertoast.showToast( msg: "Select The Product");
                                        } else if (_Qty.text == '') {
                                          Fluttertoast.showToast(msg: "Select The Qty");
                                        } else {
                                          print('Save...');
                                          ReqFromId = 4;
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
                                    child: SecMyMixBoxModel.length == 0
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
                                                  'Item Code',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Item Name',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Qty',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Uom',
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
                                            rows: SecMyMixBoxModel.map(
                                              (list) => DataRow(cells: [
                                                DataCell(
                                                  Text(list.itemCode.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.itemName.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.qty.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(list.uom.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Wrap(
                                                    direction:Axis.vertical, //default
                                                    alignment:WrapAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(primary: list.active =='Y'? Colors.greenAccent: Colors.redAccent,textStyle: TextStyle(color: Colors.white)),
                                                        onPressed: () {
                                                          print(list.active);
                                                          setState(() {
                                                            list.active == 'Y'? list.active ='N': list.active ='Y';
                                                          });
                                                          ReqFromId = 6;
                                                          PriceLisMasteUpdate(list.docNo,list.active,list.itemCode,);
                                                        },
                                                        child: Text((list.active =='Y'? 'Click to Disable': 'Click to Enable')),
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
          ReqFromId = 5;
          loading = true;
          PriceLisMastePost();
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
      "DocNo": widget.DocNo,
      "ScreenId": 1,
      "ItemCode": alteritemcode,
      "ItemName": alteritemName,
      "Uom": alteritemuom,
      "Qty": _Qty.text.isEmpty ? 1.0 : _Qty.text,
      "Location": 0,
      "LocationName": alterlocname,
      "Active": "Y",
      "UserId": int.parse(sessionuserID)
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'MIXBOX_MASTER_SP'),
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
        if (ReqFromId == 4) {
          print(response.body);
          setState(() {
            loading = false;
          });
          ReqFromId = 5;
          loading = true;
          PriceLisMastePost();
        }
        // FRONT DATA TBA 1
        else if (ReqFromId == 5) {
          print("Fromid - 5");

          setState(() {
            loading = false;
          });

          print(response.body);
          setState(() {
            SecMyMixBoxModel.clear();
            RawMyMixBoxModel =
                MyMixBoxModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawMyMixBoxModel.testdata.length; i++)
              SecMyMixBoxModel.add(
                TempMyMixBoxModel(
                  RawMyMixBoxModel.testdata[i].docNo,
                  RawMyMixBoxModel.testdata[i].itemCode,
                  RawMyMixBoxModel.testdata[i].itemName,
                  RawMyMixBoxModel.testdata[i].uom,
                  RawMyMixBoxModel.testdata[i].qty,
                  RawMyMixBoxModel.testdata[i].locCode,
                  RawMyMixBoxModel.testdata[i].locName,
                  RawMyMixBoxModel.testdata[i].active,
                ),
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

  Future<http.Response> PriceLisMasteUpdate(
      int DocNo, String Active, String itemCode) async {
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
      "ItemCode": itemCode,
      "ItemName": "ItemName",
      "Uom": "UOM",
      "Qty": 10.0,
      "Location": 10,
      "LocationName": "LocationName",
      "Active": Active,
      "UserId": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'MIXBOX_MASTER_SP'),
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
        if (ReqFromId == 6) {
          print(response.body);
          setState(() {
            loading = false;
          });
          ReqFromId = 5;
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
            SecMyMixBoxModel.clear();
            RawMyMixBoxModel =
                MyMixBoxModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawMyMixBoxModel.testdata.length; i++)
              SecMyMixBoxModel.add(
                TempMyMixBoxModel(
                    RawMyMixBoxModel.testdata[i].docNo,
                    RawMyMixBoxModel.testdata[i].itemCode,
                    RawMyMixBoxModel.testdata[i].itemName,
                    RawMyMixBoxModel.testdata[i].uom,
                    RawMyMixBoxModel.testdata[i].qty,
                    RawMyMixBoxModel.testdata[i].locCode,
                    RawMyMixBoxModel.testdata[i].locName,
                    RawMyMixBoxModel.testdata[i].active),
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
}

class TempMyMixBoxModel {
  var docNo;
  String itemCode;
  String itemName;
  String uom;
  var qty;
  var locCode;
  String locName;
  String active;
  TempMyMixBoxModel(this.docNo, this.itemCode, this.itemName, this.uom,
      this.qty, this.locCode, this.locName, this.active);
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
    if (_MyMixBoxMasterChildState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _MyMixBoxMasterChildState.ItemList.result.length; a++)
        if (_MyMixBoxMasterChildState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _MyMixBoxMasterChildState.ItemList.result[a].itemCode,
              _MyMixBoxMasterChildState.ItemList.result[a].itemName,
              _MyMixBoxMasterChildState.ItemList.result[a].uOM,
              _MyMixBoxMasterChildState.ItemList.result[a].qty,
              _MyMixBoxMasterChildState.ItemList.result[a].Stock));
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
