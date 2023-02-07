// ignore_for_file: non_constant_identifier_names, deprecated_member_use, missing_return

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Model/CategoriesModel.dart';

class ClosingEntry extends StatefulWidget {
  const ClosingEntry({Key key}) : super(key: key);

  @override
  _ClosingEntryState createState() => _ClosingEntryState();
}

class _ClosingEntryState extends State<ClosingEntry> {
  double countsystemstock = 0;
  double countuserentry = 0;

  bool typevisible = false;
  bool typevisible1 = false;
  int _value = 1;
  TextEditingController Edt_ProductName = TextEditingController();
  TextEditingController Edt_DocNo = TextEditingController();
  TextEditingController Edt_DocDate = TextEditingController();
  TextEditingController Edt_QrCode = TextEditingController();
  TextEditingController Edt_Search = TextEditingController();

  List<Result> templist = new List();
  List<SendResult> sendtemplist = new List();

  bool loading = false;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  static WastageItemModel ItemList;

  var alteritemcode = "";
  var alteritemName = "";
  var alteritemuom = "";
  var alteritemqty = "";
  var alterstock = "";
  int currentindex = 0;
  int oknotok = 0;
  bool issaveenable = false;
  //* Selva
  CategoriesModel categoryitem;
  var TextClicked = 'Bakery';
  var saerchItem ='';
  String colorchange = "";
  int onclick = 0;
  SalesItemModel itemodel;
  bool Myautofocus = false;
  @override
  void initState() {
    getStringValuesSF();
    ItemList = new WastageItemModel();
    super.initState();
  }

  @override
  void deactivate() {
    ItemList = new WastageItemModel();
    super.deactivate();
  }


  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      setState(() {});
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      var s = barcodeScanRes;
      var kv = s.substring(0, s.length - 1).substring(1).split(",");
      final Map<String, String> pairs = {};
      for (int i = 0; i < kv.length; i++) {
        var thisKV = kv[i].split(":");
        pairs[thisKV[0]] = thisKV[1].trim();
      }
      var encoded = json.encode(pairs);
      log(encoded);
      final decode = jsonDecode(encoded);
      log(decode["ItemCode"].toString());
      MyStockItemCheck(decode["ItemCode"].toString());

    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (!tablet) {
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    var assetsImage = new AssetImage('assets/imgs/splashanim.gif');
    var image = new Image(image: assetsImage, height: MediaQuery.of(context).size.height);
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: tablet?
             Scaffold(
               appBar: new AppBar(
                 title: Text('Closing Entry'),
               ),
               backgroundColor: Colors.white,
               body: loading ?
               Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  child: new Center(
                    child: image,
                  ),
                ) :
               SingleChildScrollView(
                  padding: EdgeInsets.all(5.0),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: height / 17,
                              child: TextField(
                                enabled: false,
                                controller: Edt_DocNo,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "DocNo",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: height / 17,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: false,
                                controller: Edt_DocDate,
                                decoration: InputDecoration(
                                    labelText: "Doc Date",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: height / 17,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: true,
                                autofocus: true,
                                controller: Edt_QrCode,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  labelText: "QRCode",
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.blue,
                                  contentPadding: EdgeInsets.only(
                                      top: 13, bottom: 12, left: 10, right: 10),
                                ),
                                onSubmitted: (hgygyh) {
                                  setState(() {
                                    Edt_QrCode.text = hgygyh;

                                    MyStockItemCheck("");
                                    Edt_QrCode.text = '';
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: false,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            autofocus: false,
                                            decoration: InputDecoration(
                                                hintText: "Select Product",
                                                labelText: "Select Product",
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    Edt_ProductName.text = "";
                                                  },
                                                  icon: Icon(Icons
                                                      .arrow_drop_down_circle),
                                                ),
                                                border: OutlineInputBorder()),
                                            controller: Edt_ProductName),
                                    suggestionsCallback: (pattern) async {
                                      return await BackendService
                                          .getSuggestions(pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(
                                            suggestion.ItemName.toString()),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      for (int i = 0;
                                          i < ItemList.result.length;
                                          i++) {
                                        this.Edt_ProductName.text =
                                            suggestion.ItemName.toString();
                                        //GrnSpinnerController.text = suggestion.toString();
                                        if (suggestion.ItemName.toString()
                                                .length >
                                            0) {
                                          //getgridItems();
                                          Edt_ProductName.text =
                                              suggestion.ItemName.toString();
                                          alteritemcode =
                                              suggestion.ItemCode.toString();
                                          alteritemName =
                                              suggestion.ItemName.toString();
                                          alteritemuom =
                                              suggestion.UOM.toString();
                                          alteritemqty =
                                              suggestion.Qty.toString();
                                          alterstock =
                                              suggestion.Stock.toString();
                                        } else {
                                          ItemList.result.clear();
                                        }
                                      };
                                    },
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  //list of dropdown items
                                  items: ["RW", "FG"],
                                  label: "Select type RW/FG",
                                  onChanged: (String val) {},
                                  selectedItem: "Select",
                                  //String alterpayment=items;
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: FloatingActionButton.extended(
                                  heroTag: "Add",
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.add),
                                  label: Text('Add'),
                                  onPressed: () {
                                    addItemToList(
                                        alteritemcode,
                                        alteritemName,
                                        "RW",
                                        alteritemuom,
                                        alteritemqty,
                                        alterstock);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        child: categoryitem != null
                            ? Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (int cat = 0; cat < categoryitem.result.length; cat++)
                                        Container(
                                          margin: EdgeInsets.all(12),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                TextClicked = altercategoryName = categoryitem.result[cat].name;
                                                print(categoryitem.result[cat].code);
                                                print("TextClicked${TextClicked}");

                                              });
                                            },
                                            child: Center(
                                              child: Container(
                                                height: MediaQuery.of(context).size.height / 30,
                                                width: 150,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  categoryitem.result[cat].name,
                                                  textAlign: TextAlign.center,
                                                  style: TextClicked == categoryitem.result[cat].name
                                                      ? TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)
                                                      : TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1),
                        //color: Colors.red,
                        height: height / 1.5,
                        width: width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: templist.length == 0
                                ? Center(
                                    child: Text('No Data Add!'),
                                  )
                                : DataTable(
                                    sortColumnIndex: 0,
                                    sortAscending: true,
                                    columnSpacing: 30,
                                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                                    showCheckboxColumn: false,
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Type',
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
                                        label: Center(
                                          child: Text(
                                            'Qty',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
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
                                          'Reason',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                    rows: templist.where((element) => element.Type.toString()
                                              .toLowerCase()
                                              .contains(TextClicked.toLowerCase().toString(),),
                                        )
                                        .map(
                                          (list) => DataRow(
                                              color: list.Status == 1
                                                  ? MaterialStateProperty.all(Colors.greenAccent)
                                                  : MaterialStateProperty.all(Colors.white70),
                                              cells: [
                                                DataCell(
                                                  Text(list.Type),
                                                ),
                                                DataCell(
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child: Text("${list.itemName}"),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Card(
                                                      child: Container(
                                                        width: 50,
                                                        child: Center(
                                                          child: Text(
                                                            list.qty.toString(),
                                                          ),

                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  showEditIcon: true,
                                                  onTap: (){
                                                    var enterMobileNo='';
                                                    showDialog(
                                                      context:context,
                                                      builder: (BuildContext contex1) =>
                                                          AlertDialog(
                                                            content:TextFormField(
                                                              keyboardType:TextInputType.number,
                                                              maxLength:10,
                                                              autofocus:true,
                                                              onChanged:(vvv) {
                                                                setState(() {
                                                                  enterMobileNo = vvv;
                                                                });
                                                              },
                                                            ),
                                                            title: const Text("Enter Qty"),
                                                            actions: <Widget>[
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          setState(() {

                                                                            list.qty = enterMobileNo.toString();
                                                                            Navigator.pop(contex1,'Ok',);
                                                                          });
                                                                        },
                                                                        child: const Text("Ok"),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                                        child: const Text('Cancel'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                    );
                                                  }
                                                ),
                                                DataCell(
                                                  Wrap(
                                                      direction: Axis.vertical,
                                                      alignment: WrapAlignment.center,
                                                      children: [
                                                        Text(list.uOM.toString(), textAlign: TextAlign.center)
                                                      ]),
                                                ),
                                                DataCell(
                                                  InkWell(
                                                    onTap: () async {
                                                      /*await getreason(
                                                          context,
                                                          templist
                                                              .indexOf(list));
                                                      opendialog();*/
                                                    },
                                                    child: Wrap(
                                                        direction: Axis.vertical,
                                                        alignment: WrapAlignment.center,
                                                        children: [
                                                          Text(
                                                              list.Stock.toString(),
                                                              textAlign: TextAlign.center)
                                                        ]),
                                                  ),
                                                ),
                                              ]),
                                        )
                                        .toList(),
                                  ),
                          ),
                        ),
                      ),
                      /*Container(
                  width: width / 3,
                  padding: EdgeInsets.only(top: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                child: Text(
                                  'System Stock',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  _showTestDialog();
                                  // _showMaterialDialog();
                                },
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '0.00',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                child: Text('Difference',
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () {},
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '0.00',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                child: Text('Stock Variation',
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () {},
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '0.00',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),*/
                    ],
                  ),
                ),
               persistentFooterButtons: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     FloatingActionButton.extended(
                  backgroundColor: !issaveenable ? Colors.grey : Colors.blue,
                  icon: Icon(Icons.check),
                  onPressed: !issaveenable
                      ? null
                      : () {
                          if (Edt_DocNo.text.isEmpty) {
                            showDialogboxWarning(
                                context, "DocNo No Fetching Error");
                          } else {
                            insertdetails();
                            print("object");
                          }
                        },
                  label: Text('Save'),
                ),
                     SizedBox(
                  width: 5,
                ),
                     FloatingActionButton.extended(
                  backgroundColor: Colors.blue,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Stock Variant'),
                  onPressed: () {
                    _showTestDialog();
                  },
                ),
                     SizedBox(
                  width: 5,
                ),
                     FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.clear),
                  label: Text('Cancel'),
                  onPressed: () {
                    _showTestDialog();
                  },
                ),
                   ],
            ),
               ],
             )
            :Scaffold(
                appBar: new AppBar(
                  title: Text('Closing Entry'),
                  actions: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            scanQR();
                          });
                        },
                        icon: Icon(Icons.camera_alt,color: Colors.pinkAccent,))

                  ],

                ),
                body: loading ?
                Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  child: new Center(child: image,),
                ) :
                SingleChildScrollView(
                  padding: EdgeInsets.all(5.0),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                                height: height / 17,
                                child: TextField(
                                  enabled: false,
                                  controller: Edt_DocNo,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                    labelText: "DocNo",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            flex: 2,
                            child:
                            Container(
                              height: height / 17,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                enabled: false,
                                controller: Edt_DocDate,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                    labelText: "Doc Date",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Visibility(
                            visible: false,
                            child: Expanded(
                              flex: 4,
                              child: Container(
                                height: height / 17,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: Edt_QrCode,
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    labelText: "QRCode",
                                    prefixIcon: Icon(Icons.camera_alt,color: Colors.pinkAccent,),
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.blue,
                                    contentPadding: EdgeInsets.only(top: 13, bottom: 12, left: 10, right: 10),),
                                  onTap: (){

                                  },

                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: height / 17,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: Edt_Search,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.blue,
                                  contentPadding: EdgeInsets.only(top: 13, bottom: 12, left: 10, right: 10),),
                                  onChanged: (vv){
                                    setState(() {
                                      saerchItem = vv.toString();
                                    });
                                 },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: false,
                        child: Row(
                          children: [
                            Expanded(
                        flex: 8,
                        child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: TypeAheadField(
                              textFieldConfiguration:
                              TextFieldConfiguration(
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      hintText: "Select Product",
                                      labelText: "Select Product",
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          Edt_ProductName.text = "";
                                        },
                                        icon: Icon(Icons
                                            .arrow_drop_down_circle),
                                      ),
                                      border: OutlineInputBorder()),
                                  controller: Edt_ProductName),
                              suggestionsCallback: (pattern) async {
                                return await BackendService
                                    .getSuggestions(pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(
                                      suggestion.ItemName.toString()),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                for (int i = 0;
                                i < ItemList.result.length;
                                i++) {
                                  this.Edt_ProductName.text =
                                      suggestion.ItemName.toString();
                                  //GrnSpinnerController.text = suggestion.toString();
                                  if (suggestion.ItemName.toString()
                                      .length >
                                      0) {
                                    //getgridItems();
                                    Edt_ProductName.text =
                                        suggestion.ItemName.toString();
                                    alteritemcode =
                                        suggestion.ItemCode.toString();
                                    alteritemName =
                                        suggestion.ItemName.toString();
                                    alteritemuom =
                                        suggestion.UOM.toString();
                                    alteritemqty =
                                        suggestion.Qty.toString();
                                    alterstock =
                                        suggestion.Stock.toString();
                                  } else {
                                    ItemList.result.clear();
                                  }
                                }
                                ;
                              },
                            )),
                      ),
                            SizedBox(
                        width: 5,
                      ),
                            Expanded(
                        flex: 3,
                        child: Container(
                          child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            //list of dropdown items
                            items: ["RW", "FG"],
                            label: "Select type RW/FG",
                            onChanged: (String val) {},
                            selectedItem: "Select",
                            //String alterpayment=items;
                          ),
                        ),
                      ),
                            SizedBox(
                        width: 5,
                      ),
                            Expanded(
                        flex: 1,
                        child: Container(
                          child: FloatingActionButton.extended(
                            heroTag: "Add",
                            backgroundColor: Colors.blue.shade700,
                            icon: Icon(Icons.add),
                            label: Text('Add'),
                            onPressed: () {
                              addItemToList(
                                  alteritemcode,
                                  alteritemName,
                                  "RW",
                                  alteritemuom,
                                  alteritemqty,
                                  alterstock);
                            },
                          ),
                        ),
                      ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        child: categoryitem != null ?
                        Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int cat = 0; cat < categoryitem.result.length; cat++)
                                  Container(margin: EdgeInsets.all(12),
                                    child: InkWell(
                                      onTap: () {
                                      setState(() {
                                        TextClicked = altercategoryName = categoryitem.result[cat].name;
                                        print(categoryitem.result[cat].code);
                                        print("TextClicked${TextClicked}");

                                      });
                                      },
                                      child: Center(
                                        child: Container(
                                          height: MediaQuery.of(context).size.height / 30,
                                          width: 150,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(Radius.circular(10),
                                            ),
                                          ), child: Text(
                                          categoryitem.result[cat].name,
                                          textAlign: TextAlign.center,
                                          style: TextClicked == categoryitem.result[cat].name
                                          ? TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)
                                          : TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                          maxLines: 1,
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                            : Container(),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1),
                        height: height / 1.5,
                        width: width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: templist.length == 0 ? Center(child: Text('No Data Add!'),) :
                            DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                columnSpacing:10,
                                headingRowColor: MaterialStateProperty.all(Colors.blue),
                                showCheckboxColumn: false,
                              columns: const <DataColumn>[
                                //DataColumn(label: Text('Type', style: TextStyle(color: Colors.white),),),
                                DataColumn(label: Text('Item Name', style: TextStyle(color: Colors.white),),),
                                DataColumn(label: Center(child: Text('Qty', style: TextStyle(color: Colors.white),),),),
                                DataColumn(label: Text('Uom', style: TextStyle(color: Colors.white),),),
                                DataColumn(label: Text('Reason', style: TextStyle(color: Colors.white),),),
                              ],
                              rows: templist.where((element) => element.Type.toString().toLowerCase().contains(TextClicked.toLowerCase().toString(),) && element.itemName.toString().toLowerCase().contains(saerchItem.toString().toLowerCase()) ,).map(
                              (list) => DataRow(
                                  color: list.Status == 1 ?
                                  MaterialStateProperty.all(Colors.greenAccent) :
                                  MaterialStateProperty.all(Colors.white70),
                                  cells: [
                                    DataCell(
                                      Padding(padding: EdgeInsets.only(top: 5), child: Text("${list.itemName}"),),
                                    ),
                                    DataCell(
                                        Card(
                                          child: Container(
                                            width: 50,
                                            child: Center(child: Text(list.qty.toString(),),),),),
                                        showEditIcon: true,
                                        onTap: (){
                                          var enterMobileNo='';
                                          showDialog(
                                            context:context,
                                            builder: (BuildContext contex1) =>
                                                AlertDialog(
                                                  content:TextFormField(
                                                    inputFormatters: <TextInputFormatter>[

                                                      list.uOM=="Grams"||list.uOM=="Kgs"?FilteringTextInputFormatter.singleLineFormatter
                                                          :FilteringTextInputFormatter.digitsOnly,
                                                    ],
                                                    keyboardType:TextInputType.number,
                                                    maxLength:10,
                                                     autofocus:true,
                                                    onChanged:(vvv) {
                                                      setState(() {
                                                        enterMobileNo = vvv;
                                                      });
                                                      },
                                                  ),
                                                  title: const Text("Enter Qty"),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            TextButton(
                                                          onPressed: () {
                                                            setState(() {

                                                              list.qty = enterMobileNo.toString();
                                                              Navigator.pop(contex1,'Ok',);
                                                            });
                                                          },
                                                          child: const Text("Ok"),
                                                        ),
                                                            TextButton(
                                                          onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                          child: const Text('Cancel'),
                                                        ),
                                                          ],
                                                    ),
                                                      ],
                                                )
                                                  ],
                                                ),
                                          );
                                        }
                                        ),
                                    DataCell(
                                      Text(list.uOM.toString(), textAlign: TextAlign.center),
                                    ),
                                    DataCell(

                                      Text(
                                          list.Stock.toString(),
                                          textAlign: TextAlign.center),
                                ),
                                  ]
                              ),
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              persistentFooterButtons: [
                Container(
                  height: height/20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: !issaveenable ? Colors.grey : Colors.blue,
                        icon: Icon(Icons.check),
                          onPressed: !issaveenable
                            ? null
                              : () {
                          if (Edt_DocNo.text.isEmpty) {
                            showDialogboxWarning(
                                context, "DocNo No Fetching Error");
                          } else {
                            insertdetails();
                            print("object");
                          }
                          },
                        label: Text('Save'),
                      ),

                      FloatingActionButton.extended(
                        backgroundColor: Colors.blue,
                        icon: Icon(Icons.play_arrow),
                        label: Text('Stock Variant'),
                        onPressed: () {
                          _showTestDialog();},
                      ),

                      FloatingActionButton.extended(
                        backgroundColor: Colors.red,
                        icon: Icon(Icons.clear),
                        label: Text('Cancel'),
                        onPressed: () {
                          _showTestDialog();
                          },
                      ),
                    ],
                  ),
                )
              ],
        ),
      ),
    );
  }

  Future<http.Response> insertdetails() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    sendtemplist.clear();
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(SendResult(
          1,
          0,
          templist[i].Type,
          templist[i].itemCode,
          templist[i].itemName,
          templist[i].qty,
          templist[i].uOM,
          '',
          '',
          '0',
          '0',
          int.parse(sessionuserID)));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertClosing'),
        body: jsonEncode(sendtemplist),
        headers: headers);

    setState(() {
      loading = false;
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ClosingEntry()));
        //setState(() {});
      }
      return response;
    } else {
      showDialogboxWarning(context, 'Failed to Login API');
    }
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

  Future<void> customDialogBox(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new TextField(
                            autofocus: true,
                            maxLength: 30,
                            decoration: InputDecoration(
                              labelText: "Barcode",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                            ),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ) //
                            ),
                        SizedBox(
                          height: 20.0,
                          width: 5.0,
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                            ),
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 25.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)),
                      backgroundColor: Colors.white,
                      mini: true,
                      elevation: 5.0,
                    ),
                  ),
                ],
              ));
        });
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      getdocnoanddate();
      categoriesonline();
      // getlocation();
      //getItem();
    });
  }

  void categoriesonline() {
    setState(() {
      loading = true;
    });
    GetAllCategories(1, int.parse(sessionuserID), 0, 0).then((response) {
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
          categoryitem.result.clear();
        } else {
          setState(() {
            categoryitem = CategoriesModel.fromJson(jsonDecode(response.body));
            print('ONCLICK${onclick}');
            if (onclick == 0) {
              setState(() {
                getdetailitems("0", 0);
              });
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getdetailitems(String groupcode, int onclick) {
    // print('va');
    // print(groupcode);
    // print(sessionbranchcode);
    // print(sessionuserID);
    // print(onclick);
    setState(() {
      loading = true;
    });
    print(sessionuserID + "-" + sessionbranchcode + "-" + groupcode);
    GetAllCategories(2, int.parse(sessionuserID), sessionbranchcode, onclick == 0 ? 0 : groupcode).then((response) {

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
        } else {
            templist.clear();
            print("Stock Report");
            log(response.body);
            itemodel = SalesItemModel.fromJson(jsonDecode(response.body));
            for (int i = 0; i < itemodel.result.length; i++) {
              setState(() {
                templist.add(
                  Result(
                      itemodel.result[i].itemCode,
                      itemodel.result[i].itemName,
                      itemodel.result[i].itmsGrpNam,
                      itemodel.result[i].uOM,
                      0,
                      itemodel.result[i].onHand,
                      itemodel.result[i].onHand,
                      0),
                );
              });
            }
            print("List Lenth");
            print(templist.length);
            setState(() {
              loading = false;
            });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void _showTestDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text("Information ${templist.length}")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: templist.length == 0
                                ? Center(
                                    child: Text('No Data Add!'),
                                  )
                                : DataTable(
                                    sortColumnIndex: 0,
                                    sortAscending: true,
                                    columnSpacing: 10,
                                    headingRowColor: MaterialStateProperty.all(Colors.blue),
                                    showCheckboxColumn: false,
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Center(
                                          child: Text(
                                            'Item Name',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'User Qty',
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
                                          'Stock Deviate',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                    rows: templist
                                        .map(
                                          (list1) => DataRow(cells: [
                                            DataCell(
                                                Wrap(
                                                    direction: Axis.vertical,
                                                    //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(list1.itemName,
                                                          textAlign:
                                                              TextAlign.center)
                                                    ]), onTap: () {
                                              print(list1.Status);
                                            }),
                                            DataCell(
                                              Wrap(
                                                  direction: Axis.vertical,
                                                  //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                    Text(list1.qty.toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ),
                                            DataCell(
                                              Wrap(
                                                  direction: Axis.vertical,
                                                  //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                    Text(list1.Stock.toString(),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                            ),
                                            DataCell(
                                              Wrap(
                                                  direction: Axis.vertical,
                                                  //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                      double.parse(list1.Deviate
                                                              .toString())
                                                          .toStringAsFixed(2),
                                                      /* (double.parse(list1.Stock
                                                                  .toString()) -
                                                              double.parse(list1
                                                                  .qty
                                                                  .toString()))
                                                          .toStringAsFixed(2),*/
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: double.parse(list1
                                                                          .Deviate
                                                                      .toString()) >
                                                                  0
                                                              ? Colors.green
                                                              : Colors.red,
                                                          fontSize: 20),
                                                    ),
                                                  ]),
                                            ),
                                          ]),
                                        )
                                        .toList(),
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black,textStyle: TextStyle(color: Colors.white)),
                      child: new Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),

                      ),

                      onPressed: () {
                        count();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 70.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black,textStyle: TextStyle(color: Colors.white)),
                        child: new Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),

                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              )
            ],
          );
        });
  }

  Future getdocnoanddate() {
    setState(() {
      loading = true;
    });
    GetAllDocNo(currentindex == 0 ? 4 : 3, sessionuserID).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
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

          Edt_DocDate.text =
              jsonDecode(response.body)['result'][0]['DocDate'].toString();
          Edt_DocNo.text =
              jsonDecode(response.body)['result'][0]['DocNo'].toString();

          getItem();
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getItem() {
    GetItemWastage(sessionuserID, "1").then((response) {
      print(response.body);
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

  void increment(int index) {
    print('line-1');
    setState(() {
      double b = 0;

      if (double.parse(templist[index].qty.toString()) == 100) {
        Fluttertoast.showToast(msg: "You Cannot more than 100 Qty");
      } else {
        b = double.parse(templist[index].qty.toString());

        b++;
        templist[index].qty = double.parse(b.toString());

        templist[index].Deviate =
            ((double.parse(templist[index].Stock.toString()) -
                    double.parse(templist[index].qty.toString()))
                .toStringAsFixed(2));
        print("increment will be done");
        count();
      }
    });
  }

  void decrement(int index) {
    setState(() {
      if (double.parse(templist[index].qty.toString()) <= 1) {
        Fluttertoast.showToast(msg: "You Cannot put less than 0");
        return;
      } else {
        //templist[index].qty--;
        templist[index].qty = double.parse(templist[index].qty.toString()) - 1;
        //double ss = double.parse(templist[index].qty.toString())--;
        //templist[index].Deviate = (ss - templist[index].Stock);
        templist[index].Deviate =
            ((double.parse(templist[index].Stock.toString()) -
                    double.parse(templist[index].qty.toString()))
                .toStringAsFixed(2));
        print(templist[index].Deviate);
        count();
      }
    });
  }

  void addItemToList(String itemCode, String itemName, String Type, String UOM,
      var qty, var Stock) {
    var countt = 0;

    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == itemCode) countt++;
    }
    if (countt == 0) {
      templist.add(Result(
          itemCode,
          itemName,
          Type,
          UOM,
          qty,
          Stock,
          (double.parse(Stock.toString()) -
              double.parse(
                qty.toString(),
              )),
          0));
      //log(json.encode(templist));
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: itemName + "Item Already Exists");
    }
    Edt_ProductName.text = "";

    count();
  }

  void count() async {
    setState(() {
      int flagsave = 0;
      print("C-1");
      for (int ll = 0; ll < templist.length; ll++) {
        print("C-2 loop");
        print(templist[ll].Deviate);
        if (double.parse(templist[ll].Deviate.toString()) < 0) {
          print("C-3 loop if");
          flagsave++;
        }
      }
      print("C-3 End Loof");
      print("saveflag $flagsave");

      if (flagsave == 0) {
        issaveenable = true;
      } else {
        issaveenable = false;
      }
    });
  }

  MyStockItemCheck(String Itemcode) {
  String Type='';
    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == Itemcode) {
        setState(() {
          Type=templist[i].Type;
          var TempItemCode = templist[i].itemCode;
          var TempItemName = templist[i].itemName;
          var TempType = templist[i].Type;
          var TempUom = templist[i].uOM;
          var TempQty = templist[i].qty;
          var TempStk = templist[i].Stock;
          var TempDeviate = templist[i].Deviate;
          var TempStatus = templist[i].Status;
          templist.removeAt(i);
          templist.insert(
              0,
              Result(TempItemCode, TempItemName, TempType, TempUom, 0, TempStk,
                  TempDeviate, 1));

          // templist.removeAt(i);
        });
      } else {
        print('Np data');
        templist[i].Status = 0;
      }
    }
    Edt_QrCode.text = '';
    TextClicked = Type;

    setState(() {});
  }
}

class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<ItemFillModel> my = new List();
    if (_ClosingEntryState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _ClosingEntryState.ItemList.result.length; a++)
        if (_ClosingEntryState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _ClosingEntryState.ItemList.result[a].itemCode,
              _ClosingEntryState.ItemList.result[a].itemName,
              _ClosingEntryState.ItemList.result[a].uOM,
              _ClosingEntryState.ItemList.result[a].qty,
              _ClosingEntryState.ItemList.result[a].Stock));
      return my;
    }
  }
}

class Result {
  String itemCode;
  String itemName;
  String Type;
  String uOM;
  var qty;
  var Stock;
  var Deviate;
  int Status;

  Result(
    this.itemCode,
    this.itemName,
    this.Type,
    this.uOM,
    this.qty,
    this.Stock,
    this.Deviate,
    this.Status,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.Type;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['UOM'] = this.uOM;
    data['Stock'] = this.Stock;
    return data;
  }
}

class SendResult {
  int FormID;
  int DocNo;
  String Type;
  String itemCode;
  String itemName;
  var qty;
  String uOM;
  String ReasonCode;
  String ReasonName;
  var Status;
  String Remarks;
  int UserID;

  SendResult(
      this.FormID,
      this.DocNo,
      this.Type,
      this.itemCode,
      this.itemName,
      this.qty,
      this.uOM,
      this.ReasonCode,
      this.ReasonName,
      this.Remarks,
      this.Status,
      this.UserID);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FormID'] = this.FormID;
    data['DocNo'] = this.DocNo;
    data['Type'] = this.Type;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['UOM'] = this.uOM;
    data['ReasonCode'] = this.ReasonCode;
    data['ReasonName'] = this.ReasonName;
    data['Status'] = this.Status;
    data['Remarks'] = this.Remarks;
    data['UserID'] = this.UserID;
    return data;
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
