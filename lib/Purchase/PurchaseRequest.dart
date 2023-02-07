// ignore_for_file: deprecated_member_use, equal_keys_in_map, non_constant_identifier_names, missing_return

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/Purchaseitemmodel.dart';
import 'package:bestmummybackery/Model/WhsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PurchaseRequest extends StatefulWidget {
  const PurchaseRequest({Key key}) : super(key: key);

  @override
  _PurchaseRequestState createState() => _PurchaseRequestState();
}

class _PurchaseRequestState extends State<PurchaseRequest> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  String alterwhscode = "Prod_GW";
  String alterwhsname = "Production Warehouse_GDW1";
  bool loading = false;

  String chvalue;

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  bool typevisible = false;
  bool typevisible1 = false;
  //int _value = 1;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController toWhsspinner = TextEditingController(text: 'Head Office');
  final TextEditingController EdtDocNo = TextEditingController();
  final TextEditingController EdtDocDate = TextEditingController();
  final TextEditingController ItemController = TextEditingController();
  final TextEditingController Searchcontroller = TextEditingController();
  static WhsModel whsModel = new WhsModel();
  List<Result> detailitems = new List();

  List<DataItems1> details = new List();
  static Purchaseitemmodel ItemList = new Purchaseitemmodel();
  List<SearchResult> searchmodel = new List();
  var items = List<Result>();

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Purchase Request'),
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
                          new Expanded(
                            flex: 5,
                            child: Container(
                              color: Colors.white,
                              child: new TextField(
                                controller: EdtDocNo,
                                enabled: false,
                                onSubmitted: (value) {
                                  print("Onsubmit,$value");
                                },
                                decoration: InputDecoration(
                                  labelText: "Req.No",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0))),
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
                                controller: EdtDocDate,
                                enabled: false,
                                onSubmitted: (value) {
                                  print("Onsubmit,$value");
                                },
                                decoration: InputDecoration(
                                  labelText: "Req.Date",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0))),
                                ),
                              ),
                            ),
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
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          decoration: InputDecoration(
                                            hintText: "Status",
                                            labelText: "Status",
                                            border: OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.arrow_drop_down_circle),),
                                          ),
                                          controller: this._typeAheadController),
                                  suggestionsCallback: (pattern) async {
                                    Completer<List<String>> completer = new Completer();
                                    completer.complete(<String>[
                                      "Open",
                                      "Approved",
                                      "Rejected"
                                    ]);
                                    return completer.future;
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(title: Text(suggestion.toString()));
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    if (suggestion.toString().contains("Select")) {
                                    } else {
                                      this._typeAheadController.text = suggestion.toString();
                                    }
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          new Expanded(
                            flex: 5,
                            child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: new TextField(
                                  enabled: true,
                                  controller: toWhsspinner,
                                  style: TextStyle(fontSize: !tablet? height/55:height/50),
                                  decoration: InputDecoration(
                                    labelText: "Request Loctation",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0),),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          new Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                ItemController.text = "";
                                Searchcontroller.text = "";
                                getitemlist().then(
                                  (value) => showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Scaffold(
                                        body: StatefulBuilder(
                                          builder: (BuildContext context,
                                              void Function(void Function()) setState) {
                                            return Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Card(
                                                    child: ListTile(
                                                      leading: new Icon(Icons.search),
                                                      title: new TextField(
                                                        controller: Searchcontroller,
                                                        onChanged: (val) {
                                                          print(val);
                                                          setState(() {
                                                            searchmodel.clear();
                                                            for (int kk = 0; kk < ItemList.result.length; kk++)
                                                              if (ItemList.result[kk].itemName.toString().toLowerCase().contains(val) ||
                                                                  ItemList.result[kk].itemCode.toString().toLowerCase().contains(val))
                                                                searchmodel.add(SearchResult(
                                                                    ItemList.result[kk].itemCode,
                                                                    ItemList.result[kk].itemName,
                                                                    ItemList.result[kk].uOM,
                                                                    ItemList.result[kk].stock,
                                                                    ItemList.result[kk].minLevel,
                                                                    ItemList.result[kk].minLevel,
                                                                    ItemList.result[kk].qty));
                                                          });
                                                        },
                                                        decoration: new InputDecoration(hintText: 'Search', border: InputBorder.none),
                                                      ),
                                                      trailing: new IconButton(
                                                        icon: new Icon(
                                                            Icons.cancel),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  ),
                                                  ItemList != null
                                                      ? Expanded(
                                                          flex: 1,
                                                          child: ListView.builder(
                                                                  itemCount: searchmodel.length,
                                                                  itemBuilder: (BuildContext context, int index) {
                                                                    return Card(
                                                                      child: ListTile(
                                                                        onTap:
                                                                            () {
                                                                          addItemToList(
                                                                              searchmodel[index].itemCode,
                                                                              searchmodel[index].itemName,
                                                                              searchmodel[index].uOM,
                                                                              searchmodel[index].stock,
                                                                              int.parse(searchmodel[index].minLevel.toString()),
                                                                              int.parse(searchmodel[index].maxLevel.toString()),
                                                                              int.parse(searchmodel[index].qty.toString()),
                                                                          );
                                                                          Navigator.pop(context);

                                                                        },
                                                                        title: Text('Item Name : ${searchmodel[index].itemName}'),
                                                                        subtitle: Text('Item Code : ${searchmodel[index].itemCode}'),
                                                                      ),
                                                                    );
                                                                  }),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: TextField(
                                  enabled: false,
                                  controller: ItemController,
                                  decoration: InputDecoration(
                                      hintText: "Select Item",
                                      suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.arrow_drop_down_circle),
                                      ),
                                      border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: detailitems.length == 0
                            ? Center(
                                child: Text('No Data Add!'),
                              )
                            : DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                headingRowColor: MaterialStateProperty.all(Color(0xfffe494d)),
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'S.No',
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
                                      'UOM',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Stock',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Min',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Max',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Qty',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                rows: detailitems
                                    .map(
                                      (list) => DataRow(cells: [
                                        DataCell(
                                          Center(
                                            child: Center(
                                                child: IconButton(
                                                    icon: Icon(Icons.cancel),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                      setState(() {
                                                        detailitems.remove(list);
                                                        Fluttertoast.showToast(msg: "Deleted Row");
                                                      });
                                              },
                                            )),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        (detailitems.indexOf(list) + 1).toString(),
                                                        textAlign: TextAlign.center)
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text(list.itemName, textAlign: TextAlign.left)
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Wrap(
                                                  direction: Axis.vertical, //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                Text(list.uOM.toString(), textAlign: TextAlign.center)
                                              ])),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Wrap(
                                                  direction: Axis.vertical, //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                Text(list.stock.toString(), textAlign: TextAlign.center)
                                              ])),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Center(
                                              child: Wrap(
                                                direction: Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.minLevel.toString(),
                                                      textAlign: TextAlign.center)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Center(
                                                  child: Wrap(
                                                      direction: Axis.vertical, //default
                                                      alignment: WrapAlignment.center,
                                                      children: [
                                                      Text(list.maxLevel.toString(),
                                                        textAlign: TextAlign.center)
                                              ]))),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Center(
                                                  child: Wrap(
                                                      direction: Axis.vertical, //default
                                                      alignment:WrapAlignment.center,
                                                      children: [
                                                    Text(list.qty.toString(), textAlign: TextAlign.center)
                                              ]))),
                                          placeholder: false,
                                          showEditIcon: true,
                                          onTap: () {
                                            print('onTapQty');
                                            print(list.qty.toString());
                                            _displayTextInputDialog(context,
                                                detailitems.indexOf(list));
                                          },
                                        ),
                                      ]),
                                    )
                                    .toList(),
                              ),
                      )
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
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.clear),
                  label: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(Icons.check),
                  label: Text('Save'),
                  onPressed: () {
                    if (toWhsspinner.text.isEmpty) {
                      showDialogboxWarning(context, "Please Select To Whs");
                    } else if (detailitems.length == 0) {
                      showDialogboxWarning(context, "add Atleast 1 grid");
                    } else if (detailitems.length == 0) {
                      showDialogboxWarning(context, "add Atleast 1 grid");
                    } else {
                      int cnt = 0;
                      for (int kk2 = 0; kk2 < detailitems.length; kk2++) {
                        if (double.parse(detailitems[kk2].qty.toString()) > 0) {
                          cnt++;
                        }
                      }
                      if (cnt > 0) {
                        postdataheader();
                      } else {
                        showDialogboxWarning(context,
                            "in Grid Item Qty Should Not Empty or Zero");
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

  Future<http.Response> postdataheader() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "WhsCode": alterwhscode,
      "WhsName": alterwhsname,
      "BranchCode": '$sessionbranchcode',
      "UserID": '$sessionuserID',
      "UserID": '$sessionuserID'
    };
    print(sessionuserID);
    setState(() {
      loading = true;
    });

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertPurheader'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          postdatadetail(jsonDecode(response.body)["docNo"]);
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> postdatadetail(int headerdocno) async {
    var headers = {"Content-Type": "application/json"};

    for (int i = 0; i < detailitems.length; i++)
      if (detailitems[i].qty > 0)
        details.add(DataItems1(
            headerdocno,
            detailitems[i].itemCode,
            detailitems[i].itemName,
            detailitems[i].qty,
            detailitems[i].uOM,
            detailitems[i].stock,
            detailitems[i].maxLevel,
            detailitems[i].minLevel,
            detailitems[i].qty,
            sessionuserID,
            sessionuserID));

    print(sessionuserID);
    setState(() {
      loading = true;
    });
    //print(jsonEncode(details));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertPurdetails'),
        headers: headers,
        body: jsonEncode(details));

    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          Fluttertoast.showToast(msg: "Inserted Successfully");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PurchaseRequest()));
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Login API');
    }
  }

  void filterSearchResults(String query) {
    // List<Result> dummySearchList = List<Result>();
    // // dummySearchList.addAll(detailitems);
    // if (query.isNotEmpty) {
    //   for (int k = 0; k < ItemList.result.length; k++)
    //     if (ItemList.result[k].itemCode
    //             .toLowerCase()
    //             .contains(Searchcontroller.text) ||
    //         (ItemList.result[k].itemCode
    //             .toLowerCase()
    //             .contains(Searchcontroller.text)))
    //       dummySearchList.add(Result(
    //           ItemList.result[k].itemCode,
    //           ItemList.result[k].itemName,
    //           ItemList.result[k].uOM,
    //           ItemList.result[k].minLevel,
    //           ItemList.result[k].maxLevel,
    //           stock,
    //           qty));
    // } else {
    //   setState(() {
    //     items.clear();
    //     items.addAll(detailitems);
    //   });
    // }
  }

  Future<void> _displayTextInputDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
              new TextEditingController();
          _textFieldController.text = detailitems[index].qty.toString();
          return AlertDialog(
            title: Text('Enter Qty'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Qty"),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red,textStyle: TextStyle(color: Colors.white)),
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green,textStyle: TextStyle(color: Colors.white)),
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    print(detailitems[index].qty);
                    detailitems[index].qty = double.parse(_textFieldController.text);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void addItemToList(itemcode, itemname, uom, stock, min, max, qty) {
    print(stock);
    detailitems.add(
      Result(itemcode, itemname, uom, min, max, stock, qty),
    );

    //detailitems.reversed.toList();

    for (var i = 0; i < detailitems.length / 2; i++) {
      var temp = detailitems[i];
      detailitems[i] = detailitems[detailitems.length - 1 - i];
      detailitems[detailitems.length - 1 - i] = temp;
    }
    setState(() {});
    print(detailitems.length);
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      _typeAheadController.text = "Open";
      getdocno();
    });
  }

  Future<http.Response> getdocno() async {
    var headers = {"Content-Type": "application/json"};
    var body = {"UserID": "$sessionuserID", "FormID": 1};
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getdateandno'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getdateandno');
      setState(() {
        loading = false;
      });
      print('REPOSD  ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        int login = jsonDecode(response.body)['status'];

        if (login == 0) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          EdtDocDate.text = "";
          EdtDocNo.text = "";
        } else {
          EdtDocDate.text = "";
          EdtDocNo.text = "";
          print(response.body);
          print(jsonDecode(response.body)['result'][0]['PURDate']);
          EdtDocDate.text = jsonDecode(response.body)['result'][0]['PURDate'].toString();
          EdtDocNo.text = jsonDecode(response.body)['result'][0]['PURDocNo'].toString();
          //EdtDocNo.text = jsonDecode(response.body)['result']['PURDocNo'];
          getWhs();
        }
        // showDialogbox(context, response.body);

      } else {
        showDialogboxWarning(context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  "No Response!..",
                  style: TextStyle(color: Colors.purple),
                ),
                content: Text(
                  "Slow Server Response or Internet connection",
                  style: TextStyle(color: Colors.white),
                )));
      });
      throw Exception('Internet is down');
    }
  }

  Future<http.Response> getWhs() async {
    var headers = {"Content-Type": "application/json"};

    setState(() {
      loading = true;
    });

    print(AppConstants.LIVE_URL + 'getWhs');

    final response = await http.get(Uri.parse(AppConstants.LIVE_URL + 'getWhs'),
        headers: headers);
    setState(() {
      loading = false;
    });
    print("API Loated Sucess: ${response.body}");

    if (response.statusCode == 200) {
      print("API Loated Sucess: ${response.body}");

      //var nodata = jsonDecode(response.body)['status'] == 0;
      var nodata = jsonDecode(response.body)['status'] == 0;
      print('nodata$nodata');
      if (nodata == true) {
        setState(() {
          whsModel = null;
        });
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        whsModel = WhsModel.fromJson(jsonDecode(response.body));
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getitemlist() async {
    var headers = {"Content-Type": "application/json"};
   // var body = {"UserID": sessionuserID};
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(AppConstants.LIVE_URL + 'getItem'), headers: headers);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == '0';
      print('$login');
      if (login == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        ItemList = null;
      } else {
        setState(() {
          //dailymodel = WhsDailyModel.fromJson(jsonDecode(response.body));
          ItemList = Purchaseitemmodel.fromJson(jsonDecode(response.body));
          searchmodel.clear();
          for (int kk = 0; kk < ItemList.result.length; kk++) {
            searchmodel.add(
              SearchResult(
                  ItemList.result[kk].itemCode,
                  ItemList.result[kk].itemName,
                  ItemList.result[kk].uOM,
                  ItemList.result[kk].stock,
                  ItemList.result[kk].minLevel,
                  ItemList.result[kk].maxLevel,
                  ItemList.result[kk].qty),
            );
            // searchmodel.add(SearchResult(itemCode, itemName, uOM, stock, minLevel, maxLevel, qty))
          }
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Login API');
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

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes = "";
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;
  //
  //   setState(() {
  //     print(barcodeScanRes);
  //   });
  // }
}

class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<WhsFillModel> my = new List();
    if (_PurchaseRequestState.whsModel.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _PurchaseRequestState.whsModel.result.length; a++)
        if (_PurchaseRequestState.whsModel.result[a].whsName.toString().toLowerCase().contains(query.toLowerCase()))
          my.add(WhsFillModel(_PurchaseRequestState.whsModel.result[a].whsCode,
              _PurchaseRequestState.whsModel.result[a].whsName));
      return my;
    }
  }
}

class Result {
  String itemCode;
  String itemName;
  String uOM;
  int minLevel;
  int maxLevel;
  var stock;
  var qty;

  Result(this.itemCode, this.itemName, this.uOM, this.minLevel, this.maxLevel,
      this.stock, this.qty);
}

class WhsFillModel {
  String WhsCode;
  String WhsName;

  WhsFillModel(this.WhsCode, this.WhsName);
}

class DataItems1 {
  var DOCNO;
  var ITEMCODE;
  var ITEMNAME;
  var QTY;
  var UOM;
  var Stock;
  var Max;
  var Min;
  var Qty;
  var USERID;
  var USERID1;

  DataItems1(this.DOCNO, this.ITEMCODE, this.ITEMNAME, this.QTY, this.UOM,
      this.Stock, this.Max, this.Min, this.Qty, this.USERID, this.USERID1);

  Map<String, dynamic> toJson() => {
        'DocNo': DOCNO,
        'ItemCode': ITEMCODE,
        'ItemName': ITEMNAME,
        'QTY': QTY,
        'UOM': UOM,
        'Stock': Stock,
        'Max': Max,
        'Min': Min,
        'Qty': Qty,
        'UserID': USERID,
        'UserID': USERID1,
      };
}

class SearchResult {
  String itemCode;
  String itemName;
  String uOM;
  var stock;
  var minLevel;
  var maxLevel;
  var qty;

  SearchResult(this.itemCode, this.itemName, this.uOM, this.stock,
      this.minLevel, this.maxLevel, this.qty);
}
