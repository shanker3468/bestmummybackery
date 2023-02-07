// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/OpenPODetailModel.dart';
import 'package:bestmummybackery/Model/VendorModel.dart';
import 'package:bestmummybackery/OpenPoScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GoodsReceipt extends StatefulWidget {
  const GoodsReceipt({Key key}) : super(key: key);

  @override
  _GoodsReceiptState createState() => _GoodsReceiptState();
}

class _GoodsReceiptState extends State<GoodsReceipt> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  String alterwhscode = "";
  String alterwhsname = "";
  String getpoentry = "";
  bool loading = false;

  String chvalue;
  List<AlternateOpenPODetailResult> detailitems = new List();

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  bool typevisible = false;
  bool typevisible1 = false;
  //int _value = 1;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController toWhsspinner = TextEditingController();
  final TextEditingController EdtDocNo = TextEditingController();
  final TextEditingController EdtDocDate = TextEditingController();
  final TextEditingController vendorSearchcontroller = TextEditingController();
  final TextEditingController Vendorcontroller = TextEditingController();
  final TextEditingController EdtRefNo = TextEditingController();

  final TextEditingController ItemController = TextEditingController();
  final TextEditingController ItemController2 = TextEditingController();

  static VendorModel VendorList = new VendorModel();
  List<VendorResultSearch> searchvendormodel = new List();

  String altercardcode = "";

  OpenPODetailModel li2;

  double TotalQty = 0;
  double TotalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Goods Receipt PO'),
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
                              color: Colors.white,
                              child: new TextField(
                                controller: EdtDocNo,
                                enabled: false,
                                onSubmitted: (value) {
                                  print("Onsubmit,$value");
                                },
                                decoration: InputDecoration(
                                  labelText: "GPO.No",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
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
                                  labelText: "GPO.Date",
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
                        height: 10,
                      ),
                      Row(
                        children: [
                          new Expanded(
                            flex: 5,
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: TextField(
                                controller: Vendorcontroller,
                                decoration: InputDecoration(
                                    labelText: "Select Vendor",
                                    hintText: "Select Vendor",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        vendorSearchcontroller.text = '';
                                        getvendorlist().then(
                                          (value) => showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            // user must tap button!
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return Scaffold(
                                                    body: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Card(
                                                              child: ListTile(
                                                                leading: new Icon(
                                                                    Icons
                                                                        .search),
                                                                title:
                                                                    new TextField(
                                                                  controller:
                                                                      vendorSearchcontroller,
                                                                  onChanged:
                                                                      (val) {
                                                                    print(val);
                                                                    setState(
                                                                        () {
                                                                      searchvendormodel
                                                                          .clear();
                                                                      for (int kk =
                                                                              0;
                                                                          kk <
                                                                              VendorList
                                                                                  .result.length;
                                                                          kk++)
                                                                        if (VendorList.result[kk].cardName.toString().toLowerCase().contains(val) ||
                                                                            VendorList.result[kk].cardCode.toString().toLowerCase().contains(val))
                                                                          searchvendormodel.add(VendorResultSearch(
                                                                              VendorList.result[kk].cardCode,
                                                                              VendorList.result[kk].cardName));
                                                                    });
                                                                  },
                                                                  decoration: new InputDecoration(
                                                                      hintText:
                                                                          'Search',
                                                                      border: InputBorder
                                                                          .none),
                                                                ),
                                                                trailing:
                                                                    new IconButton(
                                                                  icon: new Icon(
                                                                      Icons
                                                                          .cancel),
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          VendorList != null
                                                              ? Expanded(
                                                                  flex: 1,
                                                                  child: ListView
                                                                      .builder(
                                                                          itemCount: searchvendormodel
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return Card(
                                                                              child: ListTile(
                                                                                onTap: () {
                                                                                  // searchvendormodel.add(VendorResultSearch(VendorList.result[index].cardCode, VendorList.result[index].cardName));
                                                                                  addItemToController(
                                                                                    searchvendormodel[index].cardCode,
                                                                                    searchvendormodel[index].cardName,
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                title: Text('Vendor Name : ${searchvendormodel[index].cardName}'),
                                                                                subtitle: Text('Vendor Code : ${searchvendormodel[index].cardCode}'),
                                                                              ),
                                                                            );
                                                                          }),
                                                                )
                                                              : Container(
                                                                  child: Center(
                                                                    child: Text(
                                                                        'No Vendor Found!'),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                    ),
                                    border: OutlineInputBorder()),
                              ),
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
                                controller: EdtRefNo,
                                onSubmitted: (value) {
                                  print("Onsubmit,$value");
                                },
                                decoration: InputDecoration(
                                  labelText: "Ref.No",
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
                        height: 10,
                      ),
                      Row(
                        children: [
                          new Expanded(
                            flex: 7,
                            child: InkWell(
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
                                        icon:
                                            Icon(Icons.arrow_drop_down_circle),
                                      ),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ),
                          ),
                          /*Expanded(
                              flex: 2,
                              child: IconButton(
                                  onPressed: () {}, icon: Icon(Icons.add)))*/
                          SizedBox(
                            width: 5,
                          ),
                          new Expanded(
                            flex: 3,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.blue.shade700,
                              icon: Icon(Icons.check),
                              label: Text('Open PO'),
                              onPressed: () {
                                _navigateAndDisplaySelection(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.horizontal,
                        child: li2 != null
                            ? DataTable(
                                headingRowColor: MaterialStateProperty.all(Color(0xfffe494d)),
                                showCheckboxColumn: false,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'S.No',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'PO Num',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
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
                                      'Order Qty',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Received Qty',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Rate',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Total',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'TaxCode',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tax',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Line Total',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                rows: li2.result
                                    .map(
                                      (list) => DataRow(
                                          onSelectChanged: (value) {
                                            if (value == true) {}
                                          },
                                          cells: [
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        (li2.result.indexOf(
                                                                    list) +
                                                                1)
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        (getpoentry).toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        list.itemCode
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(list.itemName,
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        list.quantity
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(
                                              Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                            list.openQty
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center)
                                                      ]),
                                                ),
                                              ),
                                              placeholder: false,
                                              showEditIcon: true,
                                              onTap: () {
                                                print('onTapQty');
                                                print(list.openQty.toString());
                                                _displayTextInputDialog(context,
                                                    li2.result.indexOf(list));
                                              },
                                            ),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(list.price.toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction:
                                                      Axis.vertical, //default
                                                      alignment:
                                                      WrapAlignment.center,
                                                      children: [
                                                        Text(list.lineTotal.toString(),
                                                            textAlign:
                                                            TextAlign.center)
                                                      ]),
                                                ))),
                                            DataCell(Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction:
                                                      Axis.vertical, //default
                                                      alignment:
                                                      WrapAlignment.center,
                                                      children: [
                                                        Text(list.TaxCode.toString(),
                                                            textAlign:
                                                            TextAlign.center)
                                                      ]),
                                                ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        list.taxAmount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                        list.overAll.toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ))),
                                          ]),
                                    )
                                    .toList(),
                              )
                            : Container(
                                child: Center(
                                  child: Text('No Data'),
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          persistentFooterButtons: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Qty',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${TotalQty.toInt()}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\u20B9 $TotalAmount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(width: 10),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                icon: Icon(Icons.check),
                label: Text('Save'),
                onPressed: () {
                  if (Vendorcontroller.text.isEmpty) {
                    showDialogboxWarning(context, "Please Select To Vendor");
                  } else if (li2.result.length == 0) {
                    showDialogboxWarning(context, "add Atleast 1 grid");
                  } else {
                    int cnt = 0;
                    for (int kk2 = 0; kk2 < li2.result.length; kk2++) {
                      if (double.parse(li2.result[kk2].openQty.toString()) >
                          0) {
                        cnt++;
                      }
                    }
                    if (cnt > 0) {
                      postdataheader();
                    } else {
                      showDialogboxWarning(
                          context, "in Grid Item Qty Should Not Empty or Zero");
                    }
                  }
                },
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
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
              new TextEditingController();
          _textFieldController.text = li2.result[index].openQty.toString();
          return AlertDialog(
            title: Text('Enter Qty'),
            content: TextField(
              /*onChanged: (value) {
                setState(() {
                  valuetext = value;
                });
              },*/
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
                  if (int.parse(_textFieldController.text) >
                      li2.result[index].quantity) {
                    Fluttertoast.showToast(
                        msg: "Received Qty Should Not Greater then Quantity");
                  } else {
                    setState(() {
                      /* int value = int.parse(li2.result[index].qty.toString());
                    value = int.parse(_textFieldController.text);*/
                      li2.result[index].openQty =
                          int.parse((_textFieldController.text));

                      Navigator.pop(context);
                      opencount();
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  void opencount() {
    setState(() {
      TotalQty =0;
      TotalAmount =0;
      double totqty = 0;
      double totamnt = 0;
      for (int i = 0; i < li2.result.length; i++) {
        totqty = li2.result[i].quantity.toDouble();
        TotalQty += totqty;

        totamnt = li2.result[i].overAll.toDouble();
        TotalAmount += totamnt;
      }
    });
  }

  Future<http.Response> postdataheader() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "CardCode": altercardcode,
      "CardName": Vendorcontroller.text,
      "BranchCode": '$sessionbranchcode',
      "RefNo": '${EdtRefNo.text}',
      "PoNum": '$getpoentry',
      "PoEntry": '$getpoentry',
      "PoDate": '2021-10-2021',
      "UserID": '$sessionuserID',
      "UserID1": '$sessionuserID'
    };
    print(body);
    setState(() {
      loading = true;
    });

    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'insertGoodsHeader'),
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
            print('DOCNO${jsonDecode(response.body)["docNo"]}');

            postdatadetail(jsonDecode(response.body)["docNo"]);
          });
        }
      } else {
        throw Exception('Failed to Login API');
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

  Future<http.Response> postdatadetail(int headerdocno) async {
    var headers = {"Content-Type": "application/json"};

    for (int i = 0; i < li2.result.length; i++)
      if (li2.result[i].openQty > 0)
        detailitems.add(AlternateOpenPODetailResult(
            headerdocno,
            getpoentry,
            li2.result[i].itemCode,
            li2.result[i].itemName,
            li2.result[i].quantity,
            li2.result[i].openQty,
            li2.result[i].price,
            li2.result[i].taxAmount,
            li2.result[i].TaxCode,
            li2.result[i].lineTotal.toDouble(),
            '$sessionuserID',
            '$sessionuserID'));

    print(sessionuserID);
    setState(() {
      loading = true;
    });
    //print(jsonEncode(details));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertGoodsdetails'),
        headers: headers,
        body: jsonEncode(detailitems));

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
          // Fluttertoast.showToast(msg: "Inserted Successfully");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => GoodsReceipt()));
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Login API');
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OpenPoScreen(cardcode: altercardcode)),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
    getpoentry = "";
    if ('$result' == null) {
      getpoentry = "0";
    } else {
      getpoentry = '$result';
      getitemlist();

      print('OPEN PO NUMBER $getpoentry');
    }
  }

  void addItemToController(CardCode, CardName) {
    altercardcode = CardCode;
    Vendorcontroller.text = '';
    Vendorcontroller.text = CardName;
    setState(() {});
    // print(detailitems.length);
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
          EdtDocDate.text =
              jsonDecode(response.body)['result'][0]['PURDate'].toString();
          EdtDocNo.text =
              jsonDecode(response.body)['result'][0]['PURDocNo'].toString();
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

  Future<http.Response> getvendorlist() async {
    var headers = {"Content-Type": "application/json"};
    //var body = {"UserID": sessionuserID};
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(AppConstants.LIVE_URL + 'getgoodsvendor'),
        headers: headers);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == 0;
      print('$login');
      if (login == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        VendorList.result.clear();
      } else {
        print(response.body);
        //final responseJson = json.decode(response.body);

        setState(() {
          //dailymodel = WhsDailyModel.fromJson(jsonDecode(response.body));
          VendorList = VendorModel.fromJson(jsonDecode(response.body));
          searchvendormodel.clear();
          for (int kk = 0; kk < VendorList.result.length; kk++) {
            searchvendormodel.add(VendorResultSearch(
                VendorList.result[kk].cardCode,
                VendorList.result[kk].cardName));
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

  Future<http.Response> getitemlist() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 2,
      "UserID": sessionuserID,
      "BranchID": int.parse(sessionbranchcode),
      "PoEntry": getpoentry,
      "CardCode": altercardcode
    };
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'OpenPO'),
        headers: headers,
        body: jsonEncode(body));

    log(jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == 0;
      print('$login');
      if (login == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        li2.result.clear();
      } else {
        setState(() {

          log(response.body);
          //dailymodel = WhsDailyModel.fromJson(jsonDecode(response.body));
          li2 = OpenPODetailModel.fromJson(jsonDecode(response.body));

          opencount();
          /*searchmodel.clear();
          for (int kk = 0; kk < ItemList.result.length; kk++) {
            searchmodel.add(SearchResult(
                ItemList.result[kk].itemCode,
                ItemList.result[kk].itemName,
                ItemList.result[kk].uOM,
                ItemList.result[kk].stock,
                ItemList.result[kk].minLevel,
                ItemList.result[kk].minLevel,
                ItemList.result[kk].qty));*/
          //}
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
}

class VendorResultSearch {
  String cardCode;
  String cardName;

  VendorResultSearch(this.cardCode, this.cardName);
}
