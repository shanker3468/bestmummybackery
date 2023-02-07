// ignore_for_file: non_constant_identifier_names, deprecated_member_use, missing_return, unrelated_type_equality_checks, camel_case_types, equal_keys_in_map, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/GetItemMasterModel.dart';
import 'package:bestmummybackery/Model/GetStockDetalies.dart';
import 'package:bestmummybackery/Model/ProductionTblModel.dart';
import 'package:bestmummybackery/Model/PurchaseIndentheaderModel.dart';
import 'package:bestmummybackery/Model/SalesOrderModel.dart';
import 'package:bestmummybackery/Model/WhsModel.dart';
import 'package:bestmummybackery/Model/getQRModel.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductionEntry extends StatefulWidget {


   ProductionEntry({Key key, this.tablet,this.DocType, this.DocNo}) : super(key: key);

  bool tablet=false;
   var DocType="";
   var DocNo="";

  @override
  _ProductionEntryState createState() => _ProductionEntryState();
}

class _ProductionEntryState extends State<ProductionEntry> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  String alterwhscode = "";
  String alterwhsname = "";
  bool loading = false;
  String chvalue;

  bool typevisible = false;
  bool typevisible1 = false;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController toWhsspinner = TextEditingController();
  final TextEditingController EdtDocNo = TextEditingController();
  final TextEditingController EdtDocDate = TextEditingController();
  final TextEditingController ItemController = TextEditingController();
  final TextEditingController Searchcontroller = TextEditingController();
  final TextEditingController Edt_SoDate = TextEditingController();

  final TextEditingController Edt_SoDelDate = TextEditingController();
  final TextEditingController QRCodeController = TextEditingController();
  final TextEditingController Edt_SapRefNo = TextEditingController(text: '0');
  final TextEditingController Edt_FromWHS = TextEditingController();
  WhsModel whsModel;

  List<DataItems1> details = new List();
  List<SearchResult> searchmodel = new List();
  var items = List<Result>();
  List<String> salesordernolist = new List();
  List<SendItemTemp> sendtemplist = new List();
  SalesOrderModel salesordermodel;
  getQRModel itemmodel;
  FocusNode QrFocusNode;
  List<getQRModelTemp> templist = new List();
  var alterdocentry = "0";
  var alterdocnum = "0";
  var alterdocdate = "";
  var alterdeldate = "";
  var alterprodentry = "0";
  var alterDocType = '';
  ProductionTblModel RawProductionTblModel;
  PurchaseIndentheaderModel RawPurchaseIndentheaderModel;
  List<PurchaseIndent> SecPurchaseIndent = new List();
  List<PurchaseIndent> SecIPOIndent = new List();
  bool CheckIndent = false;
  GetItemMasterModel rawGetItemMasterModel;
  List<String> secItemMaster=[];
  var alterItemCode ="";
  var alterItemName ="";
  var alterUOM ="";
  int delectcont=0;

  bool QrCodeAutoFocus=false;
  bool OpenProductionLayout=true;
  GetStockDetalies rawGetStockDetalies;
  List<StockDetalies> secStockDetalies = [];

  int ProductionDocEntry=0;

  bool Holdbtn = false;


  @override
  void initState() {
    getStringValuesSF();
    QrFocusNode = FocusNode();
    alterdocnum = "0";
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    QrFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      //log("true tablet");
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      //log("false tablet");
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }

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
        child:!tablet?
        // MObile App Screen
            Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(!tablet? height/15 :height/9),
                  child: new AppBar(
                    title: Text('Pro Entry'),
                    actions: [
                      Badge(
                        position: BadgePosition.topEnd(top: 0, end: 3),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(salesordermodel == null ? '0' : salesordermodel.result.length.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: TextButton(
                          onPressed: () {
                            delectcont=0;
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: MySaleOrder(context),
                                  );
                                },
                              );
                          },
                          child: Container(
                            height: !tablet? height/15 :height/10,
                            width: !tablet? width/10 :width/7,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.all(
                                Radius.circular(height/20),
                              ),
                            ),
                            child: Text(
                              'SO',
                              style: TextStyle(color: Colors.white,fontSize: !tablet? height/50 :height/30),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          getIPOIdent().then((value) => {
                                delectcont=0,
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: IPOReocrd(context),
                                    );
                                  },
                                )
                              });
                        },
                        child: Container(
                          height: !tablet? height/15 :height/10,
                          width: !tablet? width/10 :width/7,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.all(
                              Radius.circular(height/20),
                            ),
                          ),
                          child: Text(
                            'IPO',
                            style: TextStyle(color: Colors.white,fontSize: !tablet? height/50 :height/30),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                backgroundColor: Colors.white,
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Visibility(
                              visible: false,
                              child: Row(
                                children: [
                                  //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                  Expanded(
                                    flex: 5,
                                    child: DropdownSearch<String>(
                                      //mode: Mode.MENU,
                                      showSearchBox: true,
                                      // items: salesordernolist,
                                      label: "Customer Sales Order No",
                                      onChanged: (val) {
                                        // print(val);
                                        // for (int kk = 0; kk < salesordermodel.result.length; kk++) {
                                        //   if (salesordermodel.result[kk].prodEntry
                                        //               .toString() + "-" +
                                        //           salesordermodel.result[kk].ShopName
                                        //               .toString()
                                        //               .toString() ==
                                        //       val) {
                                        //
                                        //   }
                                        // }
                                      },
                                      selectedItem: alterdocnum,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      color: Colors.white,
                                      child: new TextField(
                                        controller: Edt_SoDate,
                                        enabled: false,
                                        onSubmitted: (value) {
                                          print("Onsubmit,$value");
                                        },
                                        decoration: InputDecoration(
                                          labelText: "SO.Date",
                                          border: OutlineInputBorder(
                                              borderRadius:BorderRadius.all(Radius.circular(0),
                                              ),
                                          ),
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
                                        controller: EdtDocNo,
                                        enabled: false,
                                        onSubmitted: (value) {
                                          print("Onsubmit,$value");
                                        },
                                        decoration: InputDecoration(
                                          labelText: "PE.No",
                                          border: OutlineInputBorder(
                                              borderRadius:BorderRadius.all(Radius.circular(0),
                                              ),
                                          ),
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
                                          labelText: "PE.Date",
                                          border: OutlineInputBorder(
                                              borderRadius:BorderRadius.all(Radius.circular(0))),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: true,
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: new Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                        child: new TextField(
                                          controller: Edt_SoDelDate,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,$value");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "SO.Del.Date",
                                            border: OutlineInputBorder(
                                                borderRadius:BorderRadius.all(Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  /* new Expanded(
                                    flex: 5,
                                    child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: TypeAheadField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                                  autofocus: false,
                                                  decoration: InputDecoration(
                                                      hintText: "Select Warehouse",
                                                      labelText: "Select Warehouse",
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          toWhsspinner.text = "";
                                                        },
                                                        icon: Icon(Icons
                                                            .arrow_drop_down_circle),
                                                      ),
                                                      border: OutlineInputBorder()),
                                                  controller: toWhsspinner),
                                          suggestionsCallback: (pattern) async {
                                            return await BackendService.getSuggestions(
                                                pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title:
                                                  Text(suggestion.WhsName.toString()),
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            print(suggestion.WhsName);
                                            for (int i = 0;
                                                i < whsModel.result.length;
                                                i++) {
                                              print(whsModel.result[i].whsCode
                                                  .toString());
                                              print(whsModel.result[i].whsName
                                                  .toString());

                                              this.toWhsspinner.text =
                                                  suggestion.WhsName.toString();
                                              //GrnSpinnerController.text = suggestion.toString();
                                              if (suggestion.WhsName.toString().length >
                                                  0) {
                                                //getgridItems();
                                                toWhsspinner.text =
                                                    suggestion.WhsName.toString();
                                                alterwhscode =
                                                    suggestion.WhsCode.toString();
                                                alterwhsname =
                                                    suggestion.WhsName.toString();
                                              } else {
                                                whsModel.result.clear();
                                              }
                                            }
                                            ;
                                          },
                                        )),
                                  ),*/
                                  new Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: new TextField(
                                        controller: Edt_FromWHS,
                                        readOnly: true,
                                        style: TextStyle(fontSize: !tablet? height/55:height/30),
                                        onSubmitted: (value) {
                                          print("Onsubmit,$value");
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:  EdgeInsets.only(top:height/ 50, bottom: height/ 100, left:width/ 20, right: width/ 20),
                                          labelText: "From Whs",
                                          border: OutlineInputBorder(
                                              borderRadius:BorderRadius.all(Radius.circular(0),
                                              ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: new Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                        child: new TextField(
                                          controller: Edt_SapRefNo,
                                          enabled: false,
                                          onSubmitted: (value) {
                                            print("Onsubmit,$value");
                                          },
                                          decoration: InputDecoration(
                                            labelText: "SAP RefNo",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0),
                                                ),
                                            ),
                                          ),
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
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: new TextField(
                                        keyboardType: TextInputType.text,
                                        controller: QRCodeController,
                                        focusNode: QrFocusNode,
                                        showCursor: true,
                                        //autofocus: QrCodeAutoFocus,
                                        style: TextStyle(fontSize: !tablet? height/55:height/30),
                                        enabled: OpenProductionLayout,
                                        onSubmitted: (value) {
                                          setState(() {
                                             var Qty;
                                             var s = value;
                                             log(value);
                                             if(value.toString().isEmpty){
                                            setState(() {
                                              Fluttertoast.showToast(msg: "No Data read");
                                              //QrCodeAutoFocus=true;
                                              QrFocusNode.requestFocus();
                                            });
                                             }else {
                                               var kv = s.substring(0, s.length - 1).substring(1).split(",");
                                               final Map<String, String> pairs = {};
                                               for (int i = 0; i < kv.length; i++) {
                                                 var thisKV = kv[i].split(":");
                                                 pairs[thisKV[0]] = thisKV[1].trim();
                                               }
                                               var encoded = json.encode(pairs);
                                               log(encoded);
                                               final decode = jsonDecode(encoded);
                                               setState(() {
                                                 for (int kk = 0; kk < rawGetItemMasterModel.result.length; kk++) {
                                                   if (rawGetItemMasterModel.result[kk].itemCode == decode["ItemCode"].toString()) {
                                                     alterItemCode = rawGetItemMasterModel.result[kk].itemCode;
                                                     alterItemName = rawGetItemMasterModel.result[kk].itemName;
                                                     alterUOM = rawGetItemMasterModel.result[kk].invntryUom;
                                                   }
                                                 }
                                               });

                                               Qty = (double.parse(decode["Qty"].toString()) * 1).toStringAsFixed(3);
                                               delectcont = 0;
                                               int validation =0;
                                               if(alterUOM=="Grams" || alterUOM =="Kgs"){
                                                 log("selva groms 2");
                                                 for(int i=0;i<templist.length;i++){
                                                   if(templist[i].box.toString()==decode["RowId"].toString()){
                                                     validation=100;
                                                   }
                                                 }

                                               }else{

                                               }
                                               if(validation==0) {
                                                 addmyRow(0, '', '0', '0', alterItemCode, alterItemName, alterUOM, decode["RowId"].toString(), '', '', 0, 'qRCode', Qty, sessionbranchcode, '', 1);
                                               }else{
                                                 Fluttertoast.showToast(msg: "This Item Alrwady Added...");
                                                 delectcont = 1;
                                                 QrFocusNode.requestFocus();
                                                 QRCodeController.clear();
                                                 showDialogboxWarning(context,"This QR Already Scaned..");
                                               }
                                             }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Scan QR Code M",
                                          contentPadding:  EdgeInsets.only(top:height/ 50, bottom: height/ 100, left:width/ 50, right: width/ 50),
                                          border: OutlineInputBorder(
                                            borderRadius:BorderRadius.all(Radius.circular(0),
                                            ),
                                          ),
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
                                      height: !tablet? height/20:height/10,
                                      color: Colors.white,
                                      child: Visibility(
                                        visible: OpenProductionLayout,
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items:secItemMaster,
                                          label: "Select Item",
                                          onChanged: (val) {
                                            print(val);
                                            var Qty;
                                            setState(() {
                                              for (int kk = 0;kk <rawGetItemMasterModel.result.length;kk++) {
                                                if (rawGetItemMasterModel.result[kk].itemName ==val) {
                                                  alterItemCode =rawGetItemMasterModel.result[kk].itemCode;
                                                  alterItemName =rawGetItemMasterModel.result[kk].itemName;
                                                  alterUOM =rawGetItemMasterModel.result[kk].invntryUom;

                                                }
                                              }

                                              delectcont=0;
                                              if(alterUOM == "Grams" || alterUOM == "Kgs"){

                                                showDialog(
                                                  context:context,
                                                  builder: (BuildContext contex1) => AlertDialog(
                                                        content:TextFormField(
                                                          keyboardType:TextInputType.number,
                                                          maxLength:10,
                                                          autofocus:true,
                                                          onChanged:(vvv) {
                                                            Qty = vvv;
                                                            //Qty.toStringAsFixed(3);
                                                          },
                                                        ),
                                                        title: Text("Enter The Grms & Kg"),
                                                        actions: <Widget>[
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: TextButton(
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          //Qty.toStringAsFixed(3);
                                                                          addmyRow(0, '', '0', '0',
                                                                              alterItemCode, alterItemName, alterUOM, '', '', '', 0, 'qRCode',
                                                                              Qty, sessionbranchcode, '',0);
                                                                          Navigator.pop(contex1,'Ok',);
                                                                        });
                                                                      },
                                                                      child: const Text("Ok"),),),
                                                                  Container(
                                                                    child: TextButton(
                                                                      onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                                      child: const Text('Cancel'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                );


                                              }else{

                                                addmyRow(0, '', '0', '0',
                                                    alterItemCode, alterItemName, alterUOM, '', '', '', 0, 'qRCode',
                                                    1, sessionbranchcode, '',0);

                                              }
                                            });
                                          },
                                          selectedItem:alterItemName,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: !tablet? height/60:10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: templist.length == 0
                                  ? Center(
                                      child: Text('No Data Add!'),
                                    )
                                  : DataTable(
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                      headingRowHeight: !tablet? height/20: height/11,
                                      dataRowHeight: !tablet? height/20:height/12,
                                      columnSpacing: width/20,
                                      border: TableBorder.all(color: Colors.black26),
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
                                            'Order Qty',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Weight/Qty',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Remarks',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: templist.map((list) =>
                                          DataRow(
                                              cells: [
                                              DataCell(
                                                Center(
                                                    child: IconButton(
                                                      icon: Icon(Icons.cancel,size: !tablet? height/40:height/25,),
                                                        color: Colors.red,
                                                        onPressed: () {
                                                        print("Pressed");
                                                        setState(() {
                                                          setState(() {
                                                            if(delectcont==1){
                                                              templist.remove(list);
                                                            }else{

                                                            }
                                                          });
                                                      // templist.remove(list);
                                                    });
                                                  },
                                                )),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Wrap(
                                                      direction: Axis.vertical, //default
                                                      alignment: WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                            (templist.indexOf(list) + 1).toString(),
                                                            textAlign: TextAlign.center,style: TextStyle(fontSize: !tablet? height/40:height/30),),
                                                      ],
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Wrap(
                                                  direction: Axis.vertical, //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                    Text(list.itemName, textAlign: TextAlign.left,style: TextStyle(fontSize:!tablet? height/55: height/30)),
                                                  ],
                                                ),
                                                  showEditIcon: true,
                                                  onTap: (){
                                                    getStockDetalies(list.itemCode).then((value) => {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        // user must tap button!
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(50),
                                                            ),
                                                            elevation: 0,
                                                            backgroundColor: Colors.transparent,
                                                            child: Stockdetalies(context,tablet, height, width),
                                                          );
                                                        },
                                                      )
                                                    });
                                                  }
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Wrap(
                                                        direction:Axis.vertical, //default
                                                        alignment:WrapAlignment.center,
                                                        children: [
                                                      Text(list.uom.toString(),
                                                          textAlign: TextAlign.center,style: TextStyle(fontSize:!tablet? height/55: height/30)),
                                                        ],
                                                    ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                    child: Wrap(
                                                        direction: Axis.vertical, //default
                                                        alignment: WrapAlignment.center,
                                                        children: [
                                                          Text(list.qty.toString(),
                                                              textAlign: TextAlign.center,style: TextStyle(fontSize: !tablet? height/55:height/30)),
                                                        ],
                                                    ),
                                                ),
                                              ),
                                              DataCell(
                                                  Center(
                                                    child: Wrap(
                                                      direction: Axis.vertical, //default
                                                      alignment: WrapAlignment.center,
                                                      children: [
                                                        Text(list.weight.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: !tablet? height/55:height/30))
                                                      ],
                                                    ),
                                                  ), onTap: () {
                                                if (CheckIndent == true) {
                                                  if (list.uom == "Grams" || list.uom == "Kgs") {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          elevation: 0,
                                                          backgroundColor: Colors.transparent,
                                                          child: SubMyClac(
                                                            context,
                                                            templist.indexOf(list),
                                                            list.packetType,tablet,height,width
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          elevation: 0,
                                                          backgroundColor: Colors.transparent,
                                                          child: QtyMyClac(
                                                            context,
                                                            templist.indexOf(list),
                                                            list.packetType,tablet,height,width
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {}
                                              }, showEditIcon: true,
                                              ),
                                              DataCell(
                                                    Text(
                                                        list.remarks.toString() == null ? "" : list.remarks.toString(),
                                                        textAlign: TextAlign.center),
                                                    showEditIcon: true,
                                                    onTap: (){
                                                      var EditRemarks;
                                                      showDialog(
                                                        context:context,
                                                        builder: (BuildContext contex1) => AlertDialog(
                                                          content:TextFormField(
                                                            keyboardType:TextInputType.text,
                                                            autofocus:true,
                                                            onChanged:(vvv) {
                                                              EditRemarks = vvv;
                                                              //Qty.toStringAsFixed(3);
                                                            },
                                                          ),
                                                          title: Text("Enter The Remarks"),
                                                          actions: <Widget>[
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      child: TextButton(
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            list.remarks = EditRemarks.toString();
                                                                            Navigator.pop(contex1,'Ok',);
                                                                          });
                                                                        },
                                                                        child: const Text("Ok"),),),
                                                                    Container(
                                                                      child: TextButton(
                                                                        onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                                        child: const Text('Cancel'),
                                                                      ),
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
                          Container(
                            height: height/25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  heroTag: "Cancel",
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear,size: height/40,),
                                  label: Text('Cancel',style: TextStyle(fontSize: height/60),),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  heroTag: "Save",
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.clear,size: height/40,),
                                  label: Text('Save',style: TextStyle(fontSize: height/60),),
                                  onPressed: () {
                                    if (templist.isEmpty) {
                                      showDialogboxWarning(context, "Scan Atleast 1 Entry");
                                    }  else {
                                      postdataheader("Saved",ProductionDocEntry);
                                    }
                                  },
                                ),
                             ],
                       ),
                          ),
                  ],
        )
        //Tab Screen
            :Scaffold(
                appBar: new AppBar(
                  title: Text('Production Entry'),

                  actions: [
                    TextButton(
                      onPressed: () {
                        getProductionHold().then((value) => {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                  elevation: 0,
                                  backgroundColor:
                                  Colors.transparent,
                                  child: MySaleOrder(context),
                                );
                                },
                            ),
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Text(
                          'My Hold',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        getIPOIdent().then((value) => {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            // user must tap button!
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child: IPOReocrd(context),
                              );
                            },
                          )
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Text(
                          'IPO Indent',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     showDialog<void>(
                    //       context: context,
                    //       barrierDismissible: false,
                    //       // user must tap button!
                    //       builder: (BuildContext context) {
                    //         return Dialog(
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(50),
                    //           ),
                    //           elevation: 0,
                    //           backgroundColor: Colors.transparent,
                    //           child: MyHoldReocrd(context),
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: Container(
                    //     height: 100,
                    //     width: 150,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue.shade900,
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(30),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Purchase Indent',
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                  ],
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
                                Expanded(
                                  flex: 5,
                                  child: Visibility(
                                    visible: OpenProductionLayout,
                                    child: DropdownSearch<String>(
                                      mode: Mode.DIALOG,
                                      showSearchBox: true,
                                      items:secItemMaster,
                                      label: "Select Item",
                                      onChanged: (val) {
                                        print(val);
                                        var Qty;
                                        setState(() {
                                          for (int kk = 0;kk <rawGetItemMasterModel.result.length;kk++) {
                                            if (rawGetItemMasterModel.result[kk].itemName ==val) {
                                              alterItemCode =rawGetItemMasterModel.result[kk].itemCode;
                                              alterItemName =rawGetItemMasterModel.result[kk].itemName;
                                              alterUOM =rawGetItemMasterModel.result[kk].invntryUom;

                                            }
                                          }

                                          delectcont=0;
                                          if(alterUOM == "Grams" || alterUOM == "Kgs"){

                                            showDialog(
                                              context:context,
                                              builder: (BuildContext contex1) => AlertDialog(
                                                content:TextFormField(
                                                  keyboardType:TextInputType.number,
                                                  maxLength:10,
                                                  autofocus:true,
                                                  onChanged:(vvv) {
                                                    Qty = vvv;
                                                    //Qty.toStringAsFixed(3);
                                                  },
                                                ),
                                                title: Text("Enter The Grms & Kg"),
                                                actions: <Widget>[
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  //Qty.toStringAsFixed(3);
                                                                  addmyRow(0, '', '0', '0',
                                                                      alterItemCode, alterItemName, alterUOM, '', '', '', 0, 'qRCode',
                                                                      Qty, sessionbranchcode, '',0);
                                                                  Navigator.pop(contex1,'Ok',);
                                                                });
                                                              },
                                                              child: const Text("Ok"),),),
                                                          Container(
                                                            child: TextButton(
                                                              onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                              child: const Text('Cancel'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );


                                          }else{

                                            addmyRow(0, '', '0', '0',
                                                alterItemCode, alterItemName, alterUOM, '', '', '', 0, 'qRCode',
                                                1, sessionbranchcode, '',0);

                                          }
                                        });
                                      },
                                      selectedItem:alterItemName,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: new TextField(
                                      controller: Edt_SoDate,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Onsubmit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "SO.Date",
                                        border: OutlineInputBorder(
                                          borderRadius:BorderRadius.all(Radius.circular(0),
                                          ),
                                        ),
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
                                      controller: EdtDocNo,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Onsubmit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "PE.No",
                                        border: OutlineInputBorder(
                                          borderRadius:BorderRadius.all(Radius.circular(0),
                                          ),
                                        ),
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
                                        labelText: "PE.Date",
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
                            Row(
                              children: [
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: new TextField(
                                      controller: Edt_SoDelDate,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Onsubmit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "SO.Del.Date",
                                        border: OutlineInputBorder(
                                            borderRadius:BorderRadius.all(Radius.circular(0))),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                /* new Expanded(
                                        flex: 5,
                                        child: Container(
                                            width: double.infinity,
                                            color: Colors.white,
                                            child: TypeAheadField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                      autofocus: false,
                                                      decoration: InputDecoration(
                                                          hintText: "Select Warehouse",
                                                          labelText: "Select Warehouse",
                                                          suffixIcon: IconButton(
                                                            onPressed: () {
                                                              toWhsspinner.text = "";
                                                            },
                                                            icon: Icon(Icons
                                                                .arrow_drop_down_circle),
                                                          ),
                                                          border: OutlineInputBorder()),
                                                      controller: toWhsspinner),
                                              suggestionsCallback: (pattern) async {
                                                return await BackendService.getSuggestions(
                                                    pattern);
                                              },
                                              itemBuilder: (context, suggestion) {
                                                return ListTile(
                                                  title:
                                                      Text(suggestion.WhsName.toString()),
                                                );
                                              },
                                              onSuggestionSelected: (suggestion) {
                                                print(suggestion.WhsName);
                                                for (int i = 0;
                                                    i < whsModel.result.length;
                                                    i++) {
                                                  print(whsModel.result[i].whsCode
                                                      .toString());
                                                  print(whsModel.result[i].whsName
                                                      .toString());

                                                  this.toWhsspinner.text =
                                                      suggestion.WhsName.toString();
                                                  //GrnSpinnerController.text = suggestion.toString();
                                                  if (suggestion.WhsName.toString().length >
                                                      0) {
                                                    //getgridItems();
                                                    toWhsspinner.text =
                                                        suggestion.WhsName.toString();
                                                    alterwhscode =
                                                        suggestion.WhsCode.toString();
                                                    alterwhsname =
                                                        suggestion.WhsName.toString();
                                                  } else {
                                                    whsModel.result.clear();
                                                  }
                                                }
                                                ;
                                              },
                                            )),
                                      ),*/
                                new Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.white,
                                    child: new TextField(
                                      controller: Edt_FromWHS,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Onsubmit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "From Whs",
                                        border: OutlineInputBorder(
                                          borderRadius:BorderRadius.all(Radius.circular(0),
                                          ),
                                        ),
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
                                      controller: Edt_SapRefNo,
                                      enabled: false,
                                      onSubmitted: (value) {
                                        print("Onsubmit,$value");
                                      },
                                      decoration: InputDecoration(
                                        labelText: "SAP RefNo",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(0),
                                          ),
                                        ),
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
                                      keyboardType: TextInputType.text,
                                      controller: QRCodeController,
                                      focusNode: QrFocusNode,
                                      showCursor: true,
                                      enabled: OpenProductionLayout,
                                      onSubmitted: (value) {
                                        setState(() {
                                          var Qty;
                                          var s = value;
                                          if(value.isEmpty){
                                            setState(() {
                                              Fluttertoast.showToast(msg: "No Data read");
                                              //QrCodeAutoFocus=true;
                                              QrFocusNode.requestFocus();
                                            });
                                          }else {
                                            var kv = s.substring(0, s.length - 1).substring(1).split(",");
                                            final Map<String, String> pairs = {};
                                            for (int i = 0; i < kv.length; i++) {
                                              var thisKV = kv[i].split(":");
                                              pairs[thisKV[0]] = thisKV[1].trim();
                                            }
                                            var encoded = json.encode(pairs);
                                            log(encoded);
                                            final decode = jsonDecode(encoded);
                                            for (int kk = 0; kk < rawGetItemMasterModel.result.length; kk++) {
                                              if (rawGetItemMasterModel.result[kk].itemCode == decode["ItemCode"].toString()) {
                                                alterItemCode = rawGetItemMasterModel.result[kk].itemCode;
                                                alterItemName = rawGetItemMasterModel.result[kk].itemName;
                                                alterUOM = rawGetItemMasterModel.result[kk].invntryUom;
                                              }
                                            }

                                            Qty = (double.parse(decode["Qty"].toString()) * 1).toStringAsFixed(3);
                                            delectcont = 0;
                                            int validation =0;

                                            if(alterUOM=="Grams" || alterUOM =="Kgs"){
                                              log("selva groms 2");
                                              for(int i=0;i<templist.length;i++){
                                                if(templist[i].box.toString()==decode["RowId"].toString()){
                                                  validation=100;
                                                }
                                              }

                                            }else{

                                            }
                                            if(validation==0){
                                              addmyRow(0, '', '0', '0', alterItemCode, alterItemName, alterUOM, decode["RowId"].toString(), '', '', 0, 'qRCode', Qty, sessionbranchcode, '', 1);
                                            }else{
                                              Fluttertoast.showToast(msg: "This Item Alrwady Added...");
                                              delectcont = 1;
                                              QrFocusNode.requestFocus();
                                              QRCodeController.clear();
                                              showDialogboxWarning(context,"This QR Already Scaned..");
                                            }


                                          }
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Scan QR Code ",
                                        border: OutlineInputBorder(
                                          borderRadius:BorderRadius.all(Radius.circular(0),
                                          ),
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
                              child: templist.length == 0 ?
                              Center(
                                      child: Text('No Data Add!'),
                              ) :
                              DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
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
                                      'QR No',
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
                                      'Box',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                      'Tray',
                                      style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                      'Weight/Qty',
                                      style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                      'Remarks',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    ),
                                ],
                                rows: templist.map((list) =>
                                    DataRow(
                                        cells: [
                                          DataCell(
                                            Center(
                                                child: IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    print("Pressed");
                                                    setState(() {
                                                      setState(() {
                                                        setState(() {
                                                          if(delectcont==1){
                                                            templist.remove(list);
                                                          }else{

                                                          }
                                                        });
                                                        // templist.remove(list);
                                                      });
                                                    });
                                                  },
                                                )),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction: Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(
                                                      (templist.indexOf(list) + 1).toString(),
                                                      textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Wrap(
                                              direction: Axis.vertical, //default
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Text(list.itemName, textAlign: TextAlign.left),
                                              ],
                                            ),
                                            showEditIcon: true,
                                            onTap: (){
                                              getStockDetalies(list.itemCode).then((value) => {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  // user must tap button!
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      child: Stockdetalies(context,tablet, height, width),
                                                    );
                                                  },
                                                )
                                              });
                                            }
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction:Axis.vertical, //default
                                                alignment:WrapAlignment.center,
                                                children: [
                                                  Text(list.uom.toString(),
                                                      textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction:Axis.vertical, //default
                                                alignment:WrapAlignment.center,
                                                children: [
                                                  Text(list.qRCode.toString(), textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction: Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.qty.toString(),
                                                      textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction: Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.box.toString(),
                                                      textAlign: TextAlign.center)
                                                ],
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction: Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.tray.toString(), textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Wrap(
                                                direction: Axis.vertical, //default
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(list.weight.toString(), textAlign: TextAlign.center)
                                                ],
                                              ),
                                            ), onTap: () {
                                            if (CheckIndent == true) {
                                              if (list.uom == "Grams" || list.uom == "Kgs") {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      child: SubMyClac(
                                                        context,
                                                        templist.indexOf(list),
                                                        list.packetType,tablet,height,width
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      child: QtyMyClac(
                                                        context,
                                                        templist.indexOf(list),
                                                        list.packetType,tablet,height,width
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            } else {}
                                          }, showEditIcon: true,
                                          ),
                                          DataCell(
                                            Text(
                                                list.remarks.toString() == null ? "" : list.remarks.toString(),
                                                textAlign: TextAlign.center),
                                            showEditIcon: true,
                                            onTap: (){
                                              var EditRemarks;
                                              showDialog(
                                                context:context,
                                                builder: (BuildContext contex1) => AlertDialog(
                                                  content:TextFormField(
                                                    keyboardType:TextInputType.text,
                                                    autofocus:true,
                                                    onChanged:(vvv) {
                                                      EditRemarks = vvv;
                                                      //Qty.toStringAsFixed(3);
                                                    },
                                                  ),
                                                  title: Text("Enter The Remarks"),
                                                  actions: <Widget>[
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    list.remarks = EditRemarks.toString();
                                                                    Navigator.pop(contex1,'Ok',);
                                                                  });
                                                                },
                                                                child: const Text("Ok"),),),
                                                            Container(
                                                              child: TextButton(
                                                                onPressed: () => Navigator.pop(contex1, 'Cancel'),
                                                                child: const Text('Cancel'),
                                                              ),
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
                                        ]),
                                ).toList(),
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
                      Visibility(
                        visible: Holdbtn,
                        child: FloatingActionButton.extended(
                          heroTag: "Hold",
                          backgroundColor: Colors.pinkAccent,
                          icon: Icon(Icons.accessible_rounded),
                          label: Text("Hold"),
                          onPressed: () {
                            if (templist.isEmpty) {
                              showDialogboxWarning(context, "Scan Atleast 1 Entry");
                            } else {
                              postdataheader("Hold",ProductionDocEntry);
                            }

                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FloatingActionButton.extended(
                        heroTag: "Cancel",
                        backgroundColor: Colors.red,
                        icon: Icon(Icons.clear),
                        label: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
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

                          if (templist.isEmpty) {
                            showDialogboxWarning(context, "Scan Atleast 1 Entry");
                          }  else {
                            postdataheader("Saved",ProductionDocEntry);
                          }
                        },
                      ),
                    ],
                  ),
                ],
        )
      ),
    );
  }

  SubMyClac(context, index, packetType,tablet,height,width) {
    var Qty = '0';
    log("Grams");
    QrCodeAutoFocus=false;
    return Stack(
      children: <Widget>[
        Container(

          width: tablet?450:width,
          height: tablet?520:height/2,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              //color: Color.fromRGBO(117, 191, 255, 0.40),
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            children: <Widget>[
              Container(
                height: tablet?420:height/2.5,
                width: tablet?420:width/1.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      //Qty = value ?? 0;
                      Qty = (value * 1).toStringAsFixed(3);
                    });
                    if (kDebugMode) {
                      setState(() {
                        //print(value);
                        Qty = (value * 1).toStringAsFixed(3);
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      templist[index].weight = 0;
                      Navigator.pop(context);
                    }
                  },
                  theme:  CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 5,
                    displayColor: Colors.white,
                    displayStyle: TextStyle(fontSize: tablet?20:height/20, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle: TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle: TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle: TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: tablet?20:height/40, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: tablet?50:height/50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    //log(Qty);
                    //print(double.parse(Qty.toString()));
                    templist[index].weight = Qty;
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  height:height/30,
                  width: width/2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Text(
                    "Ok",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  QtyMyClac(context, index, packetType,tablet,height,width) {
    var Qty;
    log("Pcs");
    QrCodeAutoFocus=false;
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width,
          height: tablet?520:height/2,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              //color: Color.fromRGBO(117, 191, 255, 0.40),
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            children: <Widget>[
              Container(
                height: tablet?420:height/2.5,
                width: tablet?420:width/1.5,
                child: SimpleCalculator(
                  value: 0.0,
                  hideExpression: false,
                  hideSurroundingBorder: true,
                  onChanged: (key, value, expression) {
                    setState(() {
                      Qty = value ?? 0;
                      Qty = value.toStringAsFixed(1);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = value.toStringAsFixed(1);
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      Navigator.pop(context);
                    }
                  },
                  theme:  CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 5,
                    displayColor: Colors.white,
                    displayStyle:
                        TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle:
                        TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle:
                        TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle:
                        TextStyle(fontSize: tablet?20:height/40, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: tablet?20:height/40, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: tablet?50:height/50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    templist[index].weight = double.parse(Qty.toString()) ;
                  });

                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height:height/30,
                    width: width/2.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(Constants.padding),
                    ),
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stockdetalies(context,tablet,height,width) {
    return Stack(
      children: <Widget>[
        Container(
          width: tablet?450:width,
          height: tablet?620:height/2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.transparent,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: 0,
                sortAscending: true,
                columnSpacing: tablet?25:height/20,
                dataRowHeight: tablet?42:height/30,
                headingRowHeight: tablet?30:height/25,
                headingRowColor: MaterialStateProperty.all(Colors.blue),
                showCheckboxColumn: false,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'WhsCode',
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
                rows: secStockDetalies.map((list) =>
                    DataRow(
                    cells: [
                      DataCell(
                        Text(list.location.toString()),
                      ),
                      DataCell(
                        Text(list.whsCode.toString()),
                      ),
                      DataCell(
                        Text(list.onHand.toString()),
                      ),
                    ],
                  ),
                ).toList(),
              ),
            ),
          ),

        ),
      ],
    );
  }



  IPOReocrd(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  //color: Color.fromRGBO(117, 191, 255, 0.40),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.transparent,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {});
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search',
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecIPOIndent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "IPO Indent - " +
                                    SecIPOIndent[index].DocNo.toString() +
                                    "\n" +
                                    "IPO Date - " +
                                    SecIPOIndent[index].DocDate.toString() +
                                    "\n",
                              ),
                              subtitle: Text(SecIPOIndent[index].LocName.toString()),
                              onTap: () {
                                setState(() {
                                  alterdocnum = '0';
                                  Edt_SapRefNo.text = '0';
                                  Edt_SoDate.text = SecIPOIndent[index].DocDate.toString();
                                  Edt_SapRefNo.text = SecIPOIndent[index].DocNo.toString();
                                  alterprodentry = SecIPOIndent[index].DocNo.toString();
                                  alterDocType = "IOP";
                                  CheckIndent = true;
                                  OpenProductionLayout = false;
                                  ProductionDocEntry=0;
                                  Holdbtn = false;
                                  getDataTableRecord(SecIPOIndent[index].DocNo, 18);
                                });

                                //getPerSonalDetalisChek();
                                Navigator.pop(context,);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  MySaleOrder(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  //color: Color.fromRGBO(117, 191, 255, 0.40),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.transparent,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {});
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search',
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecIPOIndent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text(
                                "IPO Indent - " +
                                    SecIPOIndent[index].DocNo.toString() +
                                    "\n" +
                                    "IPO Date - " +
                                    SecIPOIndent[index].DocDate.toString() +
                                    "\n",
                              ),
                              subtitle: Text(SecIPOIndent[index].LocName.toString()),
                              onTap: () {
                                setState(() {
                                  alterdocnum = '0';
                                  Edt_SapRefNo.text = '0';
                                  Edt_SoDate.text = SecIPOIndent[index].DocDate.toString();
                                  Edt_SapRefNo.text = SecIPOIndent[index].DocNo.toString();
                                  alterprodentry = SecIPOIndent[index].DocNo.toString();
                                  ProductionDocEntry = int.parse(SecIPOIndent[index].DocNo.toString()) ;

                                  // alterDocType = "IOP";
                                  CheckIndent = true;
                                  OpenProductionLayout = true;
                                  delectcont=1;
                                  Holdbtn = true;
                                  getDataTableRecord(SecIPOIndent[index].DocNo, 24);
                                });

                                //getPerSonalDetalisChek();
                                Navigator.pop(context,);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<http.Response> postdataheader(remarks,RefNo) async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "SoEntry": int.parse(Edt_SapRefNo.text),
      "SoNum": int.parse(alterdocnum),
      "SoDate": Edt_SoDate.text,
      "SoDelDate": Edt_SoDelDate.text,
      "PoEntry": int.parse(alterprodentry),
      "WhsCode": alterwhscode,
      "WhsName": alterwhsname,
      "Remarks": remarks,
      "RefNo": int.parse(RefNo.toString()),
      "UserID": int.parse(sessionuserID),
      "Type": alterDocType
    };
    print(sessionuserID);
    log(jsonEncode(body));
    setState(() {
      loading = true;
    });

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertprodheader'),
        headers: headers,
        body: jsonEncode(body));
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
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result'][0]['STATUSNAME']);
          //postdatadetail(jsonDecode(response.body)["docNo"]);
          print(jsonDecode(response.body)['result'][0]['DocNo']);
          postdatadetails(jsonDecode(response.body)['result'][0]['DocNo']);
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> postdatadetails(int headerdocno) async {
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      //loading = true;
    });
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(
        SendItemTemp(
            headerdocno,
            headerdocno,
            templist[i].itemCode,
            templist[i].itemName,
            templist[i].uom,
            templist[i].qRCode,
            templist[i].packetType,
            templist[i].box,
            templist[i].tray,
            templist[i].weight == null ? 0 : templist[i].weight,
            templist[i].qty,
            templist[i].remarks == null ? "-" : templist[i].remarks,
            templist[i].docNo.toString(),
            '$sessionuserID',
            alterwhscode),
      );
    print(json.encode(sendtemplist));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertprodDetail'),
        headers: headers,
        body: jsonEncode(sendtemplist));

    setState(() {
      loading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["status"]);
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
        setState(() {
          loading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProductionEntry(),
            ),
          );
        });
      }
      return response;
    } else {
      showDialogboxWarning(context, 'Failed to Login API');
    }
  }

  Future<http.Response> getDataTableRecord(DocEntry, formId) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();
    });
    var body = {
      "FromId": formId,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": DocEntry,
      "Status": "D",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    //print(sessionuserID);
    log(jsonEncode(body));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        RawProductionTblModel = ProductionTblModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawProductionTblModel.testdata.length; i++) {
          templist.add(
            getQRModelTemp(
              0,
              '',
              '0',
              '0',
              RawProductionTblModel.testdata[i].itemCode,
              RawProductionTblModel.testdata[i].itemName, //itemName,
              RawProductionTblModel.testdata[i].invntryUom,
              RawProductionTblModel.testdata[i].box,
              RawProductionTblModel.testdata[i].tray,
              '', //packetType
              RawProductionTblModel.testdata[i].quantity, //weight
              "qRCode",
              RawProductionTblModel.testdata[i].quantity,
              '',
              '',
            ),
          );
        }
        setState(() {
          loading = false;
        });
      }
    } else {
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

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      _typeAheadController.text = "Open";
      getlocation();
      getItemMaster();

      if(widget.DocType=="IPO"){
        getIPOIdent();

      }else if(widget.DocType=="Sale Order"){
        getSaleslist();
      }


    });
  }

  addmyRow(docNo,docDate,itemGroupCode,itemGroupName,itemCode,itemName,uom,box,tray,packetType,weight,qRCode,qty,
  branchID,remarks,AddType){
    setState(() {
      CheckIndent=true;
      delectcont=1;
      double totalQty=0;
      double rawtotalQty=0;
      int count=0;

      for(int i = 0 ; i < templist.length;i++){
        if(uom=="Grams"||uom=="Kgs"){
          if(templist[i].itemCode==itemCode.toString() && templist[i].box==box){
            count++;
          }
        }else{
          if(templist[i].itemCode==itemCode.toString()){
            count++;
          }
        }
      }
      if(count==0){
        templist.add(
          getQRModelTemp(
              docNo, docDate, itemGroupCode, itemGroupName, itemCode, itemName, uom, box,
              tray, packetType,double.parse(qty.toString()) , qRCode, double.parse(qty.toString()), branchID, remarks),
        );
      }else{
        for(int kk = 0 ;kk < templist.length;kk++){
          if(templist[kk].itemCode == itemCode){
            rawtotalQty += double.parse(templist[kk].weight.toString());
            totalQty = double.parse(qty.toString());
            log((rawtotalQty+totalQty).toString());
            if(templist[kk].uom == "Grams" || templist[kk].uom  == "Kgs"){
              templist[kk].weight = (rawtotalQty+totalQty).toStringAsFixed(3);
            }else{
              templist[kk].weight = (rawtotalQty+totalQty).toString();
            }

          }
        }
      }
      if(AddType==1){
        QrFocusNode.requestFocus();
        QRCodeController.clear();
        log("Focus");
      }else{
        QrCodeAutoFocus = false;
        //QrFocusNode.dispose();

      }

    });

  }

  Future getItemMaster() {
    GetAllMaster(19,0,0).then((response) {

      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          setState(() {
            whsModel = null;
            loading= false;
            //getdocno();
          });
        } else {
          setState(() {
            log(response.body);
             rawGetItemMasterModel = GetItemMasterModel.fromJson(jsonDecode(response.body));
             for(int i = 0 ; i<rawGetItemMasterModel.result.length;i++ ){
               secItemMaster.add(rawGetItemMasterModel.result[i].itemName);
             }

            loading= false;
            //getdocno();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getproductionIdent() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      //templist.clear();
    });
    var body = {
      "FromId": 15,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": 0,
      "Status": "D",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    //print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        print('YesResponce');
        print(response.body);
        RawPurchaseIndentheaderModel =
            PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++) {
          SecPurchaseIndent.add(
            PurchaseIndent(
              RawPurchaseIndentheaderModel.testdata[i].docNo,
              RawPurchaseIndentheaderModel.testdata[i].docDate,
              RawPurchaseIndentheaderModel.testdata[i].LocCode,
              RawPurchaseIndentheaderModel.testdata[i].LocName,
            ),
          );
        }

        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getIPOIdent() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecIPOIndent.clear();
    });
    var body = {
      "FromId": 17,
      "ScreenId": 0,
      "DocNo": 0,
      "DocEntry": 0,
      "Status": "D",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    //print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        setState(() {
        print('YesResponce');
        print(response.body);
        RawPurchaseIndentheaderModel = PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++)
        {
          SecIPOIndent.add(
            PurchaseIndent(
              RawPurchaseIndentheaderModel.testdata[i].docNo,
              RawPurchaseIndentheaderModel.testdata[i].docDate,
              RawPurchaseIndentheaderModel.testdata[i].LocCode,
              RawPurchaseIndentheaderModel.testdata[i].LocName,
            ),
          );
        }

        //   alterdocnum = '0';
        //   Edt_SapRefNo.text = '0';
        //   Edt_SoDate.text = RawPurchaseIndentheaderModel.testdata[0].docDate.toString();
        //   Edt_SapRefNo.text = RawPurchaseIndentheaderModel.testdata[0].docNo.toString();
        //   alterprodentry = RawPurchaseIndentheaderModel.testdata[0].docNo.toString();
        //   alterDocType = "IPO";
        //   CheckIndent = true;
        //   OpenProductionLayout = false;
        //   loading = false;
        // getDataTableRecord(widget.DocNo.toString(), 18);
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getProductionHold() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      SecIPOIndent.clear();
    });
    var body = {
      "FromId": 23,
      "ScreenId": 0,
      "DocNo": 0,
      "DocEntry": 0,
      "Status": "Hold",
      "FromDate": "FromDate",
      "ToDate": "ToDate"
    };
    //print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'IN_MOB_TRANCTION'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        setState(() {
          print('YesResponce');
          print(response.body);
          RawPurchaseIndentheaderModel = PurchaseIndentheaderModel.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawPurchaseIndentheaderModel.testdata.length; i++)
          {
            SecIPOIndent.add(
              PurchaseIndent(
                RawPurchaseIndentheaderModel.testdata[i].docNo,
                RawPurchaseIndentheaderModel.testdata[i].docDate,
                RawPurchaseIndentheaderModel.testdata[i].LocCode,
                RawPurchaseIndentheaderModel.testdata[i].LocName,
              ),
            );
          }

          //   alterdocnum = '0';
          //   Edt_SapRefNo.text = '0';
          //   Edt_SoDate.text = RawPurchaseIndentheaderModel.testdata[0].docDate.toString();
          //   Edt_SapRefNo.text = RawPurchaseIndentheaderModel.testdata[0].docNo.toString();
          //   alterprodentry = RawPurchaseIndentheaderModel.testdata[0].docNo.toString();
          //   alterDocType = "IPO";
          //   CheckIndent = true;
          //   OpenProductionLayout = false;
          //   loading = false;
          // getDataTableRecord(widget.DocNo.toString(), 18);
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
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
          setState(() {
            EdtDocDate.text = "";
            EdtDocNo.text = "";
            print(response.body);
            print(jsonDecode(response.body)['result'][0]['PURDate']);
            EdtDocDate.text =
                jsonDecode(response.body)['result'][0]['PURDate'].toString();
            EdtDocNo.text =
                jsonDecode(response.body)['result'][0]['PURDocNo'].toString();
            //EdtDocNo.text = jsonDecode(response.body)['result']['PURDocNo'];
            getWhs();
            loading= false;
          });
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
            ),
          ),
        );
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
        setState(() {
          whsModel = WhsModel.fromJson(jsonDecode(response.body));
          loading= false;
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getSaleslist() async {
    var headers = {"Content-Type": "application/json"};
    var body = {"OrderNo": widget.DocNo};
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getSalesorderNo'),
        headers: headers,
        body: jsonEncode(body));
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
        salesordermodel = null;
        loading= false;
      } else {
        setState(() {
          //dailymodel = WhsDailyModel.fromJson(jsonDecode(response.body));
          salesordermodel = SalesOrderModel.fromJson(jsonDecode(response.body));
          salesordernolist.clear();
          print("Sale Order List");
          log(response.body);

          for (int i = 0; i < salesordermodel.result.length; i++)
          alterdocentry = salesordermodel.result[0].docEntry.toString(); // Sap DocEntry
          alterdocnum = salesordermodel.result[0].docNum.toString(); //MobDocNo
          alterdocdate = salesordermodel.result[0].docDate.toString(); //
          alterdeldate = salesordermodel.result[0].docDueDate.toString();
          alterprodentry = salesordermodel.result[0].prodEntry.toString();
          Edt_SoDate.text = alterdocdate.substring(0, 10);
          Edt_SoDelDate.text = alterdeldate.substring(0, 10);
          Edt_SapRefNo.text = alterdocentry;
          alterDocType = 'CusSaleOrder';
          CheckIndent = false;
          OpenProductionLayout = false;
          getDataTableRecord(int.parse(Edt_SapRefNo.text), 11);
          loading= false;
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      showDialogboxWarning(context, "Sales Drop Down Failed to Login API");
    }
  }

  Future<http.Response> getStockDetalies(String itemCode) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      secStockDetalies.clear();
    });
    var body = {
      "FromId": 1,
      "ItemCode": itemCode,
      "BranchId":sessionbranchcode,
      "DocDate":"DocDate",
      "DocNo":"DocNo"
    };

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'productstockdetalies'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == '0';
      if (login == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        salesordermodel = null;
        loading= false;
      } else {
        setState(() {
          rawGetStockDetalies = GetStockDetalies.fromJson(jsonDecode(response.body));
         for(int i = 0 ; i <rawGetStockDetalies.testdata.length;i++ ){
           secStockDetalies.add(
               StockDetalies(
                   rawGetStockDetalies.testdata[i].itemCode,
                   rawGetStockDetalies.testdata[i].whsCode,
                   rawGetStockDetalies.testdata[i].location,
                   rawGetStockDetalies.testdata[i].onHand)
           );
         }
          loading= false;
        });
      }
      return response;
    } else {
      showDialogboxWarning(context, "Sales Drop Down Failed to Login API");
    }
  }

  Future getlocation() {
    GetAllWhs(sessionbranchcode).then((response) {
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print('sessioncode$sessionbranchcode');
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            whsModel = null;
            loading= false;
            getdocno();
          });
        } else {
          setState(() {
            whsModel = WhsModel.fromJson(jsonDecode(response.body));

            alterwhscode = whsModel.result[2].whsCode;
            alterwhsname = whsModel.result[2].whsName;
            Edt_FromWHS.text = alterwhsname;
            loading= false;
            getdocno();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getitemlist(String qrcode) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"QrCode": qrcode};
    print(sessionuserID);
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getqrdetailsinproduction'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var login = jsonDecode(response.body)['status'] == 0;
      print('$login');
      if (login == true) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['result'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        itemmodel.result.clear();
        templist.clear();
      } else {
        setState(() {
          //itemmodel = null;
          itemmodel = getQRModel.fromJson(jsonDecode(response.body));
          print(jsonEncode(itemmodel));

          for (int i = 0; i < itemmodel.result.length; i++) {
            templist.add(
                getQRModelTemp(
                    itemmodel.result[i].docNo,
                    itemmodel.result[i].docDate,
                    itemmodel.result[i].itemGroupCode,
                    itemmodel.result[i].itemGroupName,
                    itemmodel.result[i].itemCode,
                    itemmodel.result[i].itemName,
                    itemmodel.result[i].uom,
                    itemmodel.result[i].box,
                    itemmodel.result[i].tray,
                    itemmodel.result[i].packetType,
                    itemmodel.result[i].weight,
                    itemmodel.result[i].qRCode,
                    double.parse(itemmodel.result[i].qty.toString()) ,
                    itemmodel.result[i].branchID,
                    itemmodel.result[i].remarks),
            );
            print(itemmodel.result[i].remarks);
          }
          itemmodel = null;
          QRCodeController.text = "";
          QrFocusNode.requestFocus();
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      showDialogboxWarning(context, "Sales Drop Down Failed to Login API");
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

/*class BackendService {
  static Future<List> getSuggestions(String query) async {
    // ignore: deprecated_member_use
    List<WhsFillModel> my = new List();
    if (_ProductionEntryState.whsModel.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _ProductionEntryState.whsModel.result.length; a++)
        if (_ProductionEntryState.whsModel.result[a].whsName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(WhsFillModel(_ProductionEntryState.whsModel.result[a].whsCode,
              _ProductionEntryState.whsModel.result[a].whsName));
      return my;
    }
  }
}*/

class Result {
  String itemCode;
  String itemName;
  String uOM;
  int minLevel;
  int maxLevel;
  int stock;
  int qty;

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
  int stock;
  int minLevel;
  int maxLevel;
  int qty;

  SearchResult(this.itemCode, this.itemName, this.uOM, this.stock,
      this.minLevel, this.maxLevel, this.qty);
}

class getQRModelTemp {
  var docNo;
  String docDate;
  String itemGroupCode;
  String itemGroupName;
  String itemCode;
  String itemName;
  String uom;
  String box;
  String tray;
  String packetType;
  var weight;
  var qRCode;
  var qty;
  var branchID;
  var remarks;

  getQRModelTemp(
      this.docNo,
      this.docDate,
      this.itemGroupCode,
      this.itemGroupName,
      this.itemCode,
      this.itemName,
      this.uom,
      this.box,
      this.tray,
      this.packetType,
      this.weight,
      this.qRCode,
      this.qty,
      this.branchID,
      this.remarks);
}

class SendItemTemp {
  var DOCNO;
  var LineID;
  var ITEMCODE;
  var ITEMNAME;
  var UOM;
  var QrCode;
  var PacketType;
  var Box;
  var Tray;
  var Weight;
  var Qty;
  var Remarks;
  var RefNo;
  var UserID;
  var WhsCode;
  SendItemTemp(
      this.DOCNO,
      this.LineID,
      this.ITEMCODE,
      this.ITEMNAME,
      this.UOM,
      this.QrCode,
      this.PacketType,
      this.Box,
      this.Tray,
      this.Weight,
      this.Qty,
      this.Remarks,
      this.RefNo,
      this.UserID,
      this.WhsCode);

  Map<String, dynamic> toJson() => {
        'DocNo': DOCNO,
        'LineID': LineID,
        'ItemCode': ITEMCODE,
        'ItemName': ITEMNAME,
        'Uom': UOM,
        'QRCode': QrCode,
        'PacketType': PacketType,
        'Box': Box,
        'Tray': Tray,
        'Weight': Weight,
        'Qty': Qty,
        'Remarks': Remarks,
        'RefNo': RefNo,
        'UserID': UserID,
        'WhsCode': WhsCode
      };
}

class PurchaseIndent {
  var DocNo;
  var DocDate;
  var LocCode;
  String LocName;
  PurchaseIndent(this.DocNo, this.DocDate,this.LocCode,this.LocName);
}


class User {
  int id;
  String name;
  String address;

  User({this.id, this.name, this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}

class StockDetalies{
  String itemCode;
  String whsCode;
  String location;
  var onHand;
  StockDetalies(this.itemCode,this.whsCode,this.location,this.onHand);
}

