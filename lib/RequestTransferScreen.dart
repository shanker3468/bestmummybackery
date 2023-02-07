// ignore_for_file: deprecated_member_use, non_constant_identifier_names, missing_return, unrelated_type_equality_checks, must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/Getvehiclemodel.dart';
import 'package:bestmummybackery/Model/IPOItemModel.dart';
import 'package:bestmummybackery/Model/RequestDetailModel.dart';
import 'package:bestmummybackery/Model/RequestHeaderModel.dart';
import 'package:bestmummybackery/Model/RequestStockWise.dart';
import 'package:bestmummybackery/Model/TransferModel.dart';
import 'package:bestmummybackery/Model/VehicleModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestTransferScreen extends StatefulWidget {
  RequestTransferScreen({Key key, this.id, this.DocNo}) : super(key: key);

  int id;
  int DocNo;

  @override
  _RequestTransferScreenState createState() => _RequestTransferScreenState();
}

class _RequestTransferScreenState extends State<RequestTransferScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentindex = 0;
  static WastageItemModel ItemList;

  TextEditingController Edt_ProductName = TextEditingController();
  TextEditingController Edt_DocNo = TextEditingController();
  TextEditingController Edt_DocDate = TextEditingController();

  TextEditingController Edt_DocNo1 = TextEditingController();
  TextEditingController Edt_DocDate1 = TextEditingController();

  TextEditingController Edt_MobileNo = TextEditingController();
  TextEditingController Edt_Location = TextEditingController();

  TextEditingController Edt_ReceiveNo = TextEditingController();
  TextEditingController Edt_ReceiveDate = TextEditingController();
  TextEditingController Edt_VehicelNo = TextEditingController();
  TextEditingController Edt_Mobile = TextEditingController();
  TextEditingController Edt_TransferNo = TextEditingController();
  TextEditingController Edt_DriverName = TextEditingController();
  TextEditingController Edt_DebitQty = TextEditingController(text: "0");
  TextEditingController Edt_DebitAmount = TextEditingController(text: "0");

  TextEditingController Edt_IpoDocNo = TextEditingController();
  TextEditingController Edt_IPODocDate = TextEditingController();
  TextEditingController Edt_ReqLocation = TextEditingController();

  RequestStockWise li4;

  RequestHeaderModel headermodel;
  RequestDetailModel detailmodel;
  TransferModel transferModel;
  List<String> vechiclelist = new List();
  VehicleModel vehicleModel;
  EmpModel salespersonmodel;

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
  var altervechiclcode = '';

  List<RequestModelTemp> templist = new List();
  List<SendTemp> sendtemplist = new List();

  List<String> salespersonlist = new List();
  List<String> secitemlist = new List();


  List<String> selipoitemmaster = new List();

  String altersalespersoname = "";
  String altersalespersoncode = "";

  String alterFromLocName = '',
      alterFromLocaCode = '',
      alterToLocName = '',
      alterToLocaCode = '';

  bool loading = false;
  var altervechiclename = "";

  static List<TextEditingController> controllers = new List();
 // static List<double> itemtotal = new List();
  String alterlocationcode = "";
  String alterdrivercode = "";
  String alterreceiveDocno = "";

  List<SendTranasferModel> detailitems = new List();
  List<SendReceiveModel> receiveddetailitems = new List();

  Getvehiclemodel RawGetvehiclemodel;
  NetworkPrinter printer;
  var json;
  var sessionIPAddress = '';
  var sessionIPPortNo = 0;
  var Edt_Type = new TextEditingController();
  var TypeCode = 0;

  LocationModel locationModel = new LocationModel();
  List<String> loc = new List();
  IPOItemModel RawIPOItemModel;
  List<IPODataModel> SecIPODataModel = new List();

  List<SendIPODataModel> TempIPODataModel = new List();
  List<ReceiceType> SecReceiceType = new List();

  String ipoitemname ='';
  var ScreenName = '';

  @override
  void initState() {
    ItemList = new WastageItemModel();
    getStringValuesSF();
    getdocnoanddate();
    SecReceiceType.addAll(
      [
        ReceiceType(1, "Loc-Loc"),
        ReceiceType(2, "GDN - Loc"),
      ],
    );
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(widget.id);
    super.initState();
  }


  Future<void> scanQR(formid) async {
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

      final decode = jsonDecode(barcodeScanRes);
      print("Out" + decode[0]["OrderNo"].toString());
      print("Out" + decode[0]["Type"].toString());
      ScreenName=  decode[0]["Type"].toString();

      if(formid==1){
            if (TypeCode == 1) {
              Edt_TransferNo.text = barcodeScanRes;
              getrecordreceive(decode[0]["OrderNo"].toString());
            } else if (TypeCode == 2) {
              print("Delivery");
              Edt_TransferNo.text = barcodeScanRes;
              getGDNHeaderRecord(decode[0]["OrderNo"].toString());
            }
      }
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
    return tablet
        ? DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Request & Transfer'),
                bottom: TabBar(
                  controller: _tabController,
                  onTap: (var index) {
                    print("index$index");
                    setState(() {
                      if (index == 0) {
                        currentindex = index;
                        getdocnoanddate();
                        ItemList = new WastageItemModel();
                      } else if (index == 1) {
                        currentindex = index;
                        li4 = null;
                        templist.clear();
                        sendtemplist.clear();
                        transferModel = null;
                        Edt_DocNo1.text = "";
                        Edt_DocDate1.text = "";
                        //getvechiclemaster();
                        getVEHICLERecord();
                      } else if (index == 2) {
                        currentindex = index;
                        headermodel = null;
                        Edt_TransferNo.text = "";
                        Edt_VehicelNo.text = "";
                        Edt_Mobile.text = "";
                        Edt_DriverName.text = "";
                        getdocnoanddatereceive();
                      } else if (index == 3) {
                        currentindex = index;
                        print("currentindex$currentindex");

                        getIPOdocnoanddate();
                      }
                    });
                  },
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Colors.black12),
                  tabs: [
                    Tab(
                      text: 'Request',
                    ),
                    Tab(
                      text: 'Transfer',
                    ),
                    Tab(
                      text: 'Receive',
                    ),
                    Tab(
                      text: 'IPO',
                    ),
                  ],
                ),
              ),
              body: !loading
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        Scaffold(
                          body: SingleChildScrollView(
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
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          enabled: false,
                                          controller: Edt_DocDate,
                                          decoration: InputDecoration(labelText: "Doc Date",border: OutlineInputBorder(),fillColor: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
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
                                                        hintText:"Select Product",
                                                        labelText:"Select Product",
                                                        suffixIcon: IconButton(
                                                          onPressed: () {
                                                            Edt_ProductName.text = "";
                                                          },
                                                          icon: Icon(Icons.arrow_drop_down_circle),),
                                                        border:OutlineInputBorder()),
                                                    controller:Edt_ProductName),
                                            suggestionsCallback:(pattern) async {
                                              return await BackendService.getSuggestions(pattern);},
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion.ItemName.toString()),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              for (int i = 0;i < ItemList.result.length;i++) {
                                                this.Edt_ProductName.text =suggestion.ItemName.toString();
                                                if (suggestion.ItemName.toString().length >0) {
                                                  Edt_ProductName.text =suggestion.ItemName.toString();
                                                  alteritemcode = suggestion.ItemCode.toString();
                                                  alteritemName = suggestion.ItemName.toString();
                                                  alteritemuom =suggestion.UOM.toString();
                                                  alteritemqty =suggestion.Qty.toString();
                                                  alterstock = suggestion.Stock.toString();
                                                } else {
                                                  ItemList.result.clear();
                                                }
                                              }
                                            },
                                          )),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: FloatingActionButton.extended(
                                          backgroundColor: Colors.blue.shade700,
                                          icon: Icon(Icons.send),
                                          label: Text('Open'),
                                          onPressed: () {
                                            if (Edt_ProductName.text.isEmpty) {
                                            } else {
                                              print(alteritemcode);
                                              li4 = null;
                                              getrolliststockwise(alteritemcode).then((value) =>_showTestDialog());
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  color: Colors.white,
                                  height: height * 0.4,
                                  width: width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
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
                                              headingRowColor:MaterialStateProperty.all(Colors.blue),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      'Qty',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Uom',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Reason',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: templist
                                                  /*.where((element) => element.itemName
                                          .toLowerCase()
                                          .contains(search.toLowerCase()))*/
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(
                                                        IconButton(
                                                          icon: Icon(Icons.cancel),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            setState(() {
                                                              templist.remove(list);
                                                              Fluttertoast.showToast( msg:"Deleted Row");
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      DataCell(Padding(
                                                        padding:EdgeInsets.only(top: 5),
                                                        child: Text("${list.itemName}"),
                                                      )),
                                                      DataCell(
                                                        Wrap(
                                                            direction:Axis.vertical,
                                                            alignment:WrapAlignment.center,
                                                            children: [
                                                              Text(list.qty.toString(),
                                                                  textAlign:TextAlign.center)
                                                            ]),
                                                      ),
                                                      DataCell(
                                                        Wrap(
                                                            direction:Axis.vertical,
                                                            alignment:WrapAlignment.center,
                                                            children: [
                                                              Text(list.uOM.toString(),
                                                                  textAlign:TextAlign.center)
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
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text('',textAlign:TextAlign.center)
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
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Request Save'),
                                  onPressed: () {
                                    if (templist.length == 0) {
                                      showDialogboxWarning(context,
                                          "grid should not left empty");
                                    } else {
                                      //insertRequestdetails();
                                      insertRequestHeader();
                                      print("object");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
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
                                        child: TextField(
                                          enabled: true,
                                          controller: Edt_DocNo1,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "DocNo",
                                            border: OutlineInputBorder(),
                                          ),
                                          onSubmitted: (val) {
                                            setState(() {
                                              getrecord(
                                                (val),
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          enabled: false,
                                          controller: Edt_DocDate1,
                                          decoration: InputDecoration(labelText: "Doc Date",border: OutlineInputBorder(),fillColor: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        mode: Mode.MENU,
                                        showSearchBox: true,
                                        items: salespersonlist,
                                        label: "Driver Name",
                                        onChanged: (val) {
                                          print(val);
                                          for (int kk = 0;kk <salespersonmodel.result.length;
                                              kk++) {
                                            if (salespersonmodel.result[kk].name ==val) {
                                              setState(() {
                                                print(salespersonmodel.result[kk].empID);
                                                altersalespersoname =salespersonmodel.result[kk].name;
                                                altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                              });
                                            }
                                          }
                                        },
                                        selectedItem: altersalespersoname,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: vechiclelist,
                                        label: "Vehicle No",
                                        onChanged: (val) {
                                          setState(() {
                                            print("jhgj" + val);
                                            for (int kk = 0;kk <RawGetvehiclemodel.testdata.length;kk++) {
                                              if (RawGetvehiclemodel.testdata[kk].vehicleNo ==val) {
                                                setState(() {
                                                  print(val);
                                                  altervechiclename =RawGetvehiclemodel.testdata[kk].vehicleNo;
                                                  altervechiclcode =RawGetvehiclemodel.testdata[kk].docNo.toString();
                                                });
                                              }
                                            }
                                          });
                                        },
                                        selectedItem: altervechiclename,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_Location,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(labelText: "Location",border: OutlineInputBorder(),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_ReqLocation,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(labelText: "Request Location",border: OutlineInputBorder(),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: Edt_MobileNo,
                                          decoration: InputDecoration(labelText: "Mobile No",border: OutlineInputBorder(),fillColor: Colors.blue),
                                          onChanged: (vvvv) {
                                            // Edt_MobileNo.text = vvvv;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  color: Colors.white,
                                  height: height * 0.4,
                                  width: width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: transferModel == null
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:MaterialStateProperty.all(Colors.blue),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text('S.No',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Item Name',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text('Req.Qty',style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text('Transfer.Qty',style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text('Uom',style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: transferModel.result
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(
                                                        InkWell(
                                                          onTap: () async {},
                                                          child: Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text((transferModel.result.indexOf(list) +1).toString(),
                                                                    textAlign:TextAlign.center)
                                                              ]),
                                                        ),
                                                      ),
                                                      DataCell(Padding(
                                                        padding:EdgeInsets.only(top: 5),
                                                        child: Text("${list.itemName}"),
                                                      )),
                                                      DataCell(
                                                        Wrap(
                                                            direction:Axis.vertical,
                                                            alignment:WrapAlignment.center,
                                                            children: [
                                                              Text(list.reqQty.toString(),textAlign:TextAlign.center)
                                                            ]),
                                                      ),
                                                      DataCell(
                                                        Row(
                                                          children: [
                                                            Text(list.TransferQty.toString() !="null"
                                                                ? list.TransferQty.toString()
                                                                : "0"),
                                                            IconButton(
                                                                onPressed: () {
                                                                  print('onTapQty');
                                                                  print(list.TransferQty.toString());
                                                                  _transferdisplayTextInputDialog(
                                                                      context,transferModel.result.indexOf(list));
                                                                },
                                                                icon: Icon(Icons.edit))
                                                          ],
                                                        ),
                                                        placeholder: false,
                                                        showEditIcon: false,
                                                        onTap: () {},
                                                      ),
                                                      DataCell(
                                                        Wrap(
                                                            direction:Axis.vertical,
                                                            alignment:WrapAlignment.center,
                                                            children: [
                                                              Text(list.uom,textAlign:TextAlign.center)
                                                            ]),
                                                      ),
                                                    ]),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    print('FloatingActionButton clicked');
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Send Transfer'),
                                  onPressed: () {
                                    print(altersalespersoname);
                                    print(altersalespersoncode);
                                    print(altervechiclcode);
                                    print(altervechiclename);
                                    print(Edt_MobileNo.text);
                                    if (Edt_DocNo.text.isEmpty) {
                                      showDialogboxWarning(context,"Ref No Should Not Left EMpty!");
                                    } else if (Edt_MobileNo.text.isEmpty) {
                                      showDialogboxWarning(context,"Mobile Should not left Empty!");
                                    }else if (Edt_MobileNo.text.length!= 10) {
                                      showDialogboxWarning(context,"Mobile No must be 10 digits..");
                                    }


                                    else {
                                      print(Edt_MobileNo.text);
                                      saveheader();
                                      //print(jsonEncode(transferModel));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
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
                                        child: TextField(
                                          enabled: true,
                                          readOnly: true,
                                          controller: Edt_Type,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(labelText: "Receive Type",border: OutlineInputBorder(),),
                                          onTap: () {
                                            print('dfv');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:Text('Choose The Type..'),
                                                  content: Container(
                                                    width: double.minPositive,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:SecReceiceType.length,
                                                      itemBuilder:(BuildContext context,int index) {
                                                        return ListTile(
                                                          title: Text(SecReceiceType[index].Description),
                                                          onTap: () {
                                                            setState(() {
                                                              Edt_Type.text =SecReceiceType[index].Description.toString();
                                                              TypeCode =SecReceiceType[index].Code;
                                                              //GetMatrialName();
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
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: true,
                                          autofocus: true,
                                          showCursor: true,
                                          controller: Edt_TransferNo,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Transfer/Delivery No",
                                            border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {
                                              if (TypeCode == 1) {
                                                getrecordreceive(val);
                                              } else if (TypeCode == 2) {
                                                print("Delivery");
                                                getGDNHeaderRecord(val);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_ReceiveNo,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(labelText: "Receive No",border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_Mobile,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(labelText: "Mobile No",border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_ReceiveDate,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(labelText: "Receive Date",border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {
                                              getrecord(int.parse(val));
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_DriverName,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(labelText: "DriverName",border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {
                                              getrecord(int.parse(val));
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_VehicelNo,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(labelText: "Vehicel No",border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {
                                              getrecord(int.parse(val));
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  color: Colors.white,
                                  height: height * 0.4,
                                  width: width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: detailmodel == null
                                          ? Center(
                                              child: Text('No Data Add!'),
                                            )
                                          : DataTable(
                                              sortColumnIndex: 0,
                                              sortAscending: true,
                                              headingRowColor:MaterialStateProperty.all(Colors.blue),
                                              showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'S.No',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Item Name',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      'Transfer.Qty',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                    child: Text(
                                                      'Received.Qty',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Uom',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              rows: detailmodel.result
                                                  .map(
                                                    (list) => DataRow(cells: [
                                                      DataCell(
                                                        InkWell(
                                                          onTap: () async {},
                                                          child: Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text((detailmodel.result.indexOf(list) +1).toString(),
                                                                    textAlign:TextAlign.center)
                                                              ]),
                                                        ),
                                                      ),
                                                      DataCell(Padding(
                                                        padding:EdgeInsets.only(top: 5),
                                                        child: Text("${list.itemName}"),
                                                      )),
                                                      DataCell(
                                                        Wrap(
                                                            direction:Axis.vertical,
                                                            alignment:WrapAlignment.center,
                                                            children: [
                                                              Text(list.transferQty.toStringAsFixed(2),
                                                                  textAlign:TextAlign.center)
                                                            ]),
                                                      ),
                                                      DataCell(
                                                        Row(
                                                          children: [
                                                            Text(list.UserQty.toString() !=null
                                                                ? list.UserQty.toStringAsFixed(2)
                                                                : "0"),
                                                            IconButton(
                                                                onPressed: () {
                                                                  print('onTapQty');
                                                                  print(list.UserQty.toString());
                                                                  _transferdisplayTextInputDialog1(
                                                                      context,detailmodel.result.indexOf(list));
                                                                },
                                                                icon: Icon(Icons.edit))
                                                          ],
                                                        ),
                                                        placeholder: false,
                                                        showEditIcon: false,
                                                        onTap: () {},
                                                      ),
                                                      DataCell(
                                                        Wrap(
                                                            direction:Axis.vertical,
                                                            alignment:WrapAlignment.center,
                                                            children: [
                                                              Text(list.uom,textAlign:TextAlign.center)
                                                            ]),
                                                      ),
                                                    ]),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          persistentFooterButtons: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: TextField(
                                      enabled: true,
                                      autofocus: true,
                                      showCursor: true,
                                      controller: Edt_DebitQty,
                                      textInputAction: TextInputAction.go,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(labelText: "Debit Qty",border: OutlineInputBorder(),),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: TextField(
                                      enabled: true,
                                      controller: Edt_DebitAmount,
                                      textInputAction: TextInputAction.go,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(labelText: "Debit Amount",border: OutlineInputBorder(),),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.red,
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel'),
                                  onPressed: () {
                                    print('FloatingActionButton clicked');
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  backgroundColor: Colors.blue.shade700,
                                  icon: Icon(Icons.check),
                                  label: Text('Save Rec'),
                                  onPressed: () {
                                    if (Edt_TransferNo.text.isEmpty) {
                                      showDialogboxWarning(context,
                                          "Transfer No Should Not Left EMpty!");
                                    } else if (Edt_Mobile.text.isEmpty) {
                                      showDialogboxWarning(context,
                                          "Mobile Should not left Empty!");
                                    }
                                    //else if (headermodel.result.length == 0) {
                                    //   showDialogboxWarning(context,
                                    //       "grid should not left empty!!");
                                    // }
                                    else {
                                      print(detailmodel.result.length);
                                      int count = 0;

                                      for (int i = 0;i < detailmodel.result.length;i++) {
                                        if (detailmodel.result[i].UserQty ==0) {
                                          count++;
                                        }
                                      }
                                      if (count == 0) {
                                        savereceiveheader();
                                      } else {
                                        showDialogboxWarning(
                                            context, "Please Enter User Qty");
                                      }
                                      // print(jsonEncode(transferModel));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Scaffold(
                          body: SingleChildScrollView(
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
                                        child: TextField(
                                          enabled: false,
                                          controller: Edt_IpoDocNo,
                                          textInputAction: TextInputAction.go,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(labelText: "DocNo",border: OutlineInputBorder(),),
                                          onSubmitted: (val) {
                                            setState(() {
                                              getrecord(int.parse(val));
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          enabled: false,
                                          controller: Edt_IPODocDate,
                                          decoration: InputDecoration(labelText: "Doc Date",border: OutlineInputBorder(),fillColor: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: loc,
                                        label: "From Location",
                                        onChanged: (val) {
                                          print(val);
                                          for (int kk = 0;kk < locationModel.result.length;kk++) {
                                            if (locationModel.result[kk].name ==val) {
                                              print(locationModel.result[kk].code);
                                              alterFromLocName = locationModel.result[kk].name;
                                              alterFromLocaCode = locationModel.result[kk].code.toString();
                                            }
                                          }
                                        },
                                        selectedItem: alterFromLocName,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: loc,
                                        label: "To Location",
                                        onChanged: (val) {
                                          print(val);
                                          for (int kk = 0;kk < locationModel.result.length;kk++) {
                                            if (locationModel.result[kk].name ==val) {
                                              print(locationModel.result[kk].code);
                                              alterToLocName =locationModel.result[kk].name;
                                              alterToLocaCode = locationModel.result[kk].code.toString();
                                            }
                                          }
                                        },
                                        selectedItem: alterToLocName,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: selipoitemmaster,
                                        label: "Select Product",
                                        onChanged: (val) {
                                          print(val);

                                          for (int kk = 0;kk < RawIPOItemModel.testdata.length;kk++) {
                                            if (RawIPOItemModel.testdata[kk].itemName ==val) {
                                              setState(() {
                                                print("RawIPOItemModel.testdata[kk].itemName");
                                                ipoitemname =RawIPOItemModel.testdata[kk].itemName;
                                                addipodatatble(RawIPOItemModel.testdata[kk].itemCode,
                                                    RawIPOItemModel.testdata[kk].itemName,
                                                    RawIPOItemModel.testdata[kk].uOM,
                                                    RawIPOItemModel.testdata[kk].stock,
                                                    RawIPOItemModel.testdata[kk].whsCode);
                                              });

                                            }

                                          }
                                        },
                                        selectedItem: ipoitemname,
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  color: Colors.white,
                                  height: height * 0.6,
                                  width: width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        sortColumnIndex: 0,
                                        sortAscending: true,
                                        headingRowColor:MaterialStateProperty.all(Colors.blue),
                                        showCheckboxColumn: false,
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text('S.No',style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text('Item Name',style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text('Order Qty',style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Center(
                                              child: Text('UOM', style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text('Stock',style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text('Remove',style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                        rows: SecIPODataModel.map(
                                          (list) => DataRow(cells: [
                                            DataCell(
                                              Text(SecIPODataModel.indexOf(list).toString(),),
                                            ),
                                            DataCell(
                                              Text(list.ItemName.toString(),),
                                            ),
                                            DataCell(
                                                Text(list.OrderQty.toString(),),
                                                showEditIcon: true, onTap: () {
                                              if (list.ItemUOM == "Grams" ||list == "Kgs") {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:(BuildContext context) {
                                                    return Dialog(
                                                      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(50),),
                                                      elevation: 0,
                                                      backgroundColor:Colors.transparent,
                                                      child: SubMyClac(context,SecIPODataModel.indexOf(list)),
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:(BuildContext context) {
                                                    return Dialog(
                                                      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(50),),
                                                      elevation: 0,
                                                      backgroundColor:Colors.transparent,
                                                      child: QtyMyClac(context,SecIPODataModel.indexOf(list)),
                                                    );
                                                  },
                                                );
                                              }
                                            }),
                                            DataCell(
                                              Text(list.ItemUOM.toString(),),),
                                            DataCell(
                                              Text(list.Stock.toString(),),),
                                            DataCell(
                                              Icon(Icons.delete,color: Colors.redAccent,),
                                            onTap: (){
                                              setState(() {
                                                SecIPODataModel.remove(list);
                                              });
                                            }
                                            )
                                          ]),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FloatingActionButton.extended(
                                    backgroundColor: Colors.red,
                                    icon: Icon(Icons.clear),
                                    label: Text('Cancel'),
                                    onPressed: () {
                                      print('FloatingActionButton clicked');
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade700,
                                    icon: Icon(Icons.check),
                                    label: Text('Send PO '),
                                    onPressed: () {
                                      insertIPOheader();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          )
        : DefaultTabController(
            length: 4,
            child: SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(height/10),
                  child: AppBar(
                    title: Text('Request & Transfer'),
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: (var index) {
                        print("index$index");
                        setState(() {
                          if (index == 0) {
                            currentindex = index;
                            getdocnoanddate();
                            ItemList = new WastageItemModel();
                          } else if (index == 1) {
                            currentindex = index;
                            li4 = null;
                            templist.clear();
                            sendtemplist.clear();
                            transferModel = null;
                            Edt_DocNo1.text = "";
                            Edt_DocDate1.text = "";
                            //getvechiclemaster();
                            getVEHICLERecord();
                          } else if (index == 2) {
                            currentindex = index;
                            headermodel = null;
                            Edt_TransferNo.text = "";
                            Edt_VehicelNo.text = "";
                            Edt_Mobile.text = "";
                            Edt_DriverName.text = "";
                            Edt_Type.text="GDN - Loc";
                            TypeCode = 2;
                            getdocnoanddatereceive();
                          } else if (index == 3) {
                            currentindex = index;
                            print("currentindex$currentindex");
                            getIPOdocnoanddate();
                          }
                        });
                      },
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.black12),
                      tabs: [
                        Tab(text: 'Request',),
                        Tab(text: 'Transfer',),
                        Tab(text: 'Receive',),
                        Tab(text: 'IPO',),
                      ],
                    ),
                  ),
                ),
                body: !loading
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          Scaffold(
                            body: SingleChildScrollView(
                              padding: EdgeInsets.all(5.0),
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: height/80,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/15,
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_DocNo,
                                            style: TextStyle(fontSize: height/60),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: "DocNo",border: OutlineInputBorder(),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/60,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/15,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: height/60),
                                            enabled: false,
                                            controller: Edt_DocDate,
                                            decoration: InputDecoration(labelText: "Doc Date",border: OutlineInputBorder(),fillColor: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height/80,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          height: height/18,
                                          child: DropdownSearch<String>(
                                            mode: Mode.DIALOG,
                                            showSearchBox: true,
                                            items: secitemlist,
                                            label: "Select Product",
                                            onChanged: (val) {
                                              print(val);
                                              for (int kk = 0;kk < ItemList.result.length; kk++) {
                                                if (ItemList.result[kk].itemName ==val) {
                                                  print(ItemList.result[kk].itemName);
                                                  Edt_ProductName.text =ItemList.result[kk].itemName;
                                                  alteritemName =ItemList.result[kk].itemName;
                                                  alteritemcode = ItemList.result[kk].itemCode.toString();
                                                  alteritemuom = ItemList.result[kk].uOM.toString();
                                                  alteritemqty = ItemList.result[kk].qty.toString();
                                                  alterstock = ItemList.result[kk].Stock.toString();
                                                }
                                              }
                                            },
                                            selectedItem: alteritemName,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width/60,),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: height/18,
                                          child: FloatingActionButton.extended(
                                            backgroundColor: Colors.blue.shade700,
                                            icon: Icon(Icons.send),
                                            label: Text('Open'),
                                            onPressed: () {
                                              if (Edt_ProductName.text.isEmpty) {
                                              } else {
                                                print(alteritemcode);
                                                li4 = null;
                                                getrolliststockwise(alteritemcode)
                                                    .then((value) =>
                                                    _showTestDialog());
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    color: Colors.white,
                                    height: height /1.7,
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
                                                columnSpacing: width/35,
                                                dataRowHeight: height/25,
                                                headingRowHeight: height/18,
                                                headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                showCheckboxColumn: true,
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text('Remove',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Center(
                                                      child: Text( 'Qty',style: TextStyle(color: Colors.white),),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Uom',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Reason',style: TextStyle(color: Colors.white),),
                                                  ),
                                                ],
                                                rows: templist
                                                    /*.where((element) => element.itemName
                                            .toLowerCase()
                                            .contains(search.toLowerCase()))*/
                                                    .map(
                                                      (list) => DataRow(cells: [
                                                        DataCell(
                                                          IconButton(
                                                            icon: Icon(Icons.cancel,),
                                                            color: Colors.red,
                                                            onPressed: () {
                                                              setState(() {
                                                                templist.remove(list);
                                                                Fluttertoast.showToast(msg:"Deleted Row");
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        DataCell(Text("${list.itemName}",style: TextStyle(fontSize: height/60),)),
                                                        DataCell(
                                                          Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text(
                                                                    list.qty.toString(),
                                                                    textAlign:TextAlign.center,style: TextStyle(fontSize: height/60),)
                                                              ]),
                                                        ),
                                                        DataCell(
                                                          Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text(list.uOM.toString(),
                                                                    textAlign:TextAlign.center,style: TextStyle(fontSize: height/60),)
                                                              ]),
                                                        ),
                                                        DataCell(
                                                          Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text('',textAlign:TextAlign.center)
                                                              ]),
                                                        ),
                                                      ]),
                                                    )
                                                    .toList(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            persistentFooterButtons: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: height/18,
                                    child: FloatingActionButton.extended(
                                      backgroundColor: Colors.red,
                                      icon: Icon(Icons.clear,size: height/35,),
                                      label: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: width/ 20,
                                  ),
                                  Container(
                                    height: height/18,
                                    child: FloatingActionButton.extended(
                                      backgroundColor: Colors.blue.shade700,
                                      icon: Icon(Icons.check,size: height/35,),
                                      label: Text('Request Save'),
                                      onPressed: () {
                                        if (templist.length == 0) {
                                          showDialogboxWarning(context,
                                              "grid should not left empty");
                                        } else {
                                          //insertRequestdetails();
                                          insertRequestHeader();
                                          print("object");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Scaffold(
                            body: SingleChildScrollView(
                              padding: EdgeInsets.all(4.0),
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: height/80,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: true,
                                            style: TextStyle(fontSize: height/50),
                                            controller: Edt_DocNo1,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: "DocNo",border: OutlineInputBorder(),),
                                            onSubmitted: (val) {
                                              setState(() {
                                                getrecord(int.parse(val),);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width/70,),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: height/50),
                                            enabled: false,
                                            controller: Edt_DocDate1,
                                            decoration: InputDecoration(labelText: "Doc Date",border: OutlineInputBorder(),fillColor: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height/80,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: height/18,
                                          child: DropdownSearch<String>(
                                            mode: Mode.MENU,
                                            showSearchBox: true,
                                            items: salespersonlist,
                                            label: "Driver Name",
                                            onChanged: (val) {
                                              print(val);
                                              for (int kk = 0;kk <salespersonmodel.result.length;kk++) {
                                                if (salespersonmodel.result[kk].name ==val) {
                                                  setState(() {
                                                    print(salespersonmodel.result[kk].empID);
                                                    altersalespersoname =salespersonmodel.result[kk].name;
                                                    altersalespersoncode =salespersonmodel.result[kk].empID.toString();
                                                  });
                                                }
                                              }
                                            },
                                            selectedItem: altersalespersoname,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/70,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: height/18,
                                          child: DropdownSearch<String>(
                                            mode: Mode.DIALOG,
                                            showSearchBox: true,
                                            items: vechiclelist,
                                            label: "Vehicle No",
                                            onChanged: (val) {
                                              setState(() {
                                                print("jhgj" + val);
                                                for (int kk = 0;kk <RawGetvehiclemodel.testdata.length;kk++) {
                                                  if (RawGetvehiclemodel.testdata[kk].vehicleNo == val) {
                                                    setState(() {
                                                      print(val);
                                                      altervechiclename =RawGetvehiclemodel.testdata[kk].vehicleNo;
                                                      altervechiclcode = RawGetvehiclemodel.testdata[kk].docNo.toString();
                                                    });
                                                  }
                                                }
                                              });
                                            },
                                            selectedItem: altervechiclename,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: height/80,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: false,
                                            style: TextStyle(fontSize: height/50),
                                            controller: Edt_Location,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(labelText: "Location",border: OutlineInputBorder(),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/70,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            style: TextStyle(fontSize: height/50),
                                            keyboardType: TextInputType.number,
                                            controller: Edt_MobileNo,
                                            decoration: InputDecoration(labelText: "Mobile No ",border: OutlineInputBorder(),fillColor: Colors.blue),
                                            onChanged: (vvvv) {
                                              // Edt_MobileNo.text = vvvv;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    color: Colors.white,
                                    height: height /1.8,
                                    width: width,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: transferModel == null
                                            ? Center(
                                                child: Text('No Data Add!'),
                                              )
                                            : DataTable(
                                                sortColumnIndex: 0,
                                                sortAscending: true,
                                                columnSpacing: width/35,
                                                dataRowHeight: height/20,
                                                headingRowHeight: height/20,
                                                headingRowColor: MaterialStateProperty.all(Colors.blue),
                                                showCheckboxColumn: true,
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text('S.No',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Center(
                                                      child: Text('Req.Qty',style: TextStyle(color: Colors.white),),),
                                                  ),
                                                  DataColumn(
                                                    label: Center(
                                                      child: Text(
                                                        'Transfer.Qty',style: TextStyle(color: Colors.white),),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Uom',style: TextStyle(color: Colors.white),),
                                                  ),
                                                ],
                                                rows: transferModel.result
                                                    .map(
                                                      (list) => DataRow(cells: [
                                                        DataCell(
                                                          Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text((transferModel.result.indexOf(list) +1).toString(),
                                                                    textAlign:TextAlign.center,style: TextStyle(fontSize: height/60),)
                                                              ]),
                                                        ),
                                                        DataCell(Text(
                                                            "${list.itemName}",style: TextStyle(fontSize: height/60),)),
                                                        DataCell(
                                                          Text(list.reqQty.toString(),
                                                              textAlign:TextAlign.center,style: TextStyle(fontSize: height/60),),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            children: [
                                                              Text(list.TransferQty.toString() !="null"
                                                                  ? list.TransferQty.toString()
                                                                  : "0",style: TextStyle(fontSize: height/60),),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    print(list.TransferQty.toString());
                                                                    _transferdisplayTextInputDialog(context,transferModel.result.indexOf(list));
                                                                  },
                                                                  icon: Icon(Icons.edit,size: height/60,))
                                                            ],
                                                          ),
                                                          placeholder: false,
                                                          showEditIcon: false,
                                                          onTap: () {},
                                                        ),
                                                        DataCell(
                                                          Text(list.uom,textAlign:TextAlign.center,style: TextStyle(fontSize: height/60)),
                                                        ),
                                                      ]),
                                                    )
                                                    .toList(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            persistentFooterButtons: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: height/20,
                                    child: FloatingActionButton.extended(
                                      backgroundColor: Colors.red,
                                      icon: Icon(Icons.clear,size: height/35,),
                                      label: Text('Cancel'),
                                      onPressed: () {
                                        print('FloatingActionButton clicked');
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: width/50,
                                  ),
                                  Container(
                                    height: height/20,
                                    child: FloatingActionButton.extended(
                                      backgroundColor: Colors.blue.shade700,
                                      icon: Icon(Icons.clear,size: height/35,),
                                      label: Text('Send Transfer '),
                                      onPressed: () {
                                        print(altersalespersoname);
                                        print(altersalespersoncode);
                                        print(altervechiclcode);
                                        print(altervechiclename);
                                        print(Edt_MobileNo.text);
                                        if (Edt_DocNo.text.isEmpty) {
                                          showDialogboxWarning(context,
                                              "Ref No Should Not Left EMpty!");
                                        } else if (Edt_MobileNo.text.isEmpty) {
                                          showDialogboxWarning(context,
                                              "Mobile Should not left Empty!");
                                        } else {
                                          print(Edt_MobileNo.text);
                                          saveheader();
                                          //print(jsonEncode(transferModel));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Scaffold(
                            body: SingleChildScrollView(
                              padding: EdgeInsets.all(5.0),
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: height/50,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: true,
                                            readOnly: true,
                                            controller: Edt_Type,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: "Receive Type",border: OutlineInputBorder(),),
                                            onTap: () {
                                              print('dfv');
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:Text('Choose The Type..'),
                                                    content: Container(
                                                      width: double.minPositive,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:SecReceiceType.length,
                                                        itemBuilder:(BuildContext context,int index) {
                                                          return ListTile(
                                                            title: Text(SecReceiceType[index].Description),
                                                            onTap: () {
                                                              setState(() {
                                                                Edt_Type.text =SecReceiceType[index].Description.toString();
                                                                TypeCode =SecReceiceType[index].Code;
                                                                //GetMatrialName();
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            readOnly: true,
                                            controller: Edt_TransferNo,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: "Transfer/Delivery No",
                                              contentPadding:  EdgeInsets.only(top: height/50, bottom: height/50, left: 0, right: 1),
                                              prefixIcon: Icon(Icons.camera_alt_rounded,color: Colors.green,size: height/70,),
                                              border: OutlineInputBorder(),
                                            ),

                                            onTap: (){
                                              setState(() {
                                                scanQR(1);
                                              });
                                            },


                                            // onSubmitted: (val) {
                                            //   setState(() {
                                            //     if (TypeCode == 1) {
                                            //       getrecordreceive(val);
                                            //     } else if (TypeCode == 2) {
                                            //       print("Delivery");
                                            //       getGDNHeaderRecord(val);
                                            //     }
                                            //   });
                                            // },
                                          ),
                                        ),
                                      ),
                                      SizedBox( width: 5,),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_ReceiveNo,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: "Receive No",border: OutlineInputBorder(),),
                                            onSubmitted: (val) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_Mobile,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: "Mobile No",border: OutlineInputBorder(),),
                                            onSubmitted: (val) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_ReceiveDate,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(labelText: "Receive Date",border: OutlineInputBorder(),),
                                            onSubmitted: (val) {
                                              setState(() {
                                                getrecord(int.parse(val));
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_DriverName,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: "DriverName",border: OutlineInputBorder(),),
                                            onSubmitted: (val) {
                                              setState(() {
                                                getrecord(int.parse(val));
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: height/18,
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_VehicelNo,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(labelText: "Vehicel No",border: OutlineInputBorder(),),
                                            onSubmitted: (val) {
                                              setState(() {
                                                getrecord(int.parse(val));
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    color: Colors.white,
                                    height: height * 0.4,
                                    width: width,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: detailmodel == null
                                            ? Center(
                                                child: Text('No Data Add!'),
                                              )
                                            : DataTable(
                                                sortColumnIndex: 0,
                                                sortAscending: true,
                                                columnSpacing: width/35,
                                                dataRowHeight: height/20,
                                                headingRowHeight: height/20,
                                                headingRowColor:MaterialStateProperty.all(Colors.blue),
                                                showCheckboxColumn: false,
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text('S.No',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                                  ),
                                                  DataColumn(
                                                    label: Center(
                                                      child: Text('Transfer.Qty',style: TextStyle(color: Colors.white),),),
                                                  ),
                                                  DataColumn(
                                                    label: Center(
                                                      child: Text('Received.Qty',style: TextStyle(color: Colors.white),),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Uom',style: TextStyle(color: Colors.white),),
                                                  ),
                                                ],
                                                rows: detailmodel.result
                                                    .map(
                                                      (list) => DataRow(cells: [
                                                        DataCell(
                                                          InkWell(
                                                            onTap: () async {},
                                                            child: Wrap(
                                                                direction:Axis.vertical,
                                                                alignment:WrapAlignment.center,
                                                                children: [
                                                                  Text((detailmodel.result.indexOf(list) +1).toString(),textAlign:TextAlign.center)
                                                                ]),
                                                          ),
                                                        ),
                                                        DataCell(Padding(
                                                          padding:EdgeInsets.only(top: 5),
                                                          child: Text("${list.itemName}"),
                                                        )),
                                                        DataCell(
                                                          Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text(list.transferQty.toStringAsFixed(2),
                                                                    textAlign:TextAlign.center)
                                                              ]),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            children: [
                                                              Text(list.UserQty.toString() !=null
                                                                  ? list.UserQty.toStringAsFixed(2)
                                                                  : "0"),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    print('onTapQty');
                                                                    print(list.UserQty.toString());
                                                                    _transferdisplayTextInputDialog1(
                                                                        context,detailmodel.result.indexOf(list));
                                                                  },
                                                                  icon: Icon(Icons.edit))
                                                            ],
                                                          ),
                                                          placeholder: false,
                                                          showEditIcon: false,
                                                          onTap: () {},
                                                        ),
                                                        DataCell(
                                                          Wrap(
                                                              direction:Axis.vertical,
                                                              alignment:WrapAlignment.center,
                                                              children: [
                                                                Text(list.uom,textAlign:TextAlign.center)
                                                              ]),
                                                        ),
                                                      ]),
                                                    )
                                                    .toList(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            persistentFooterButtons: [
                              Row(

                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: height/20,
                                      child: TextField(
                                        enabled: true,
                                        autofocus: true,
                                        showCursor: true,
                                        controller: Edt_DebitQty,
                                        textInputAction: TextInputAction.go,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(labelText: "Debit Qty",border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: height/20,
                                      child: TextField(
                                        enabled: true,
                                        controller: Edt_DebitAmount,
                                        textInputAction: TextInputAction.go,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(labelText: "Debit Amount",border: OutlineInputBorder(),),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: height/20,
                                      child: FloatingActionButton.extended(
                                        backgroundColor: Colors.red,
                                        label: Text('Cancel',style: TextStyle(fontSize: height/75)),
                                        onPressed: () {
                                          print('FloatingActionButton clicked');
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: height/20,
                                      child: FloatingActionButton.extended(
                                        backgroundColor: Colors.blue.shade700,
                                        label: Text('Save Rec',style: TextStyle(fontSize: height/75),),
                                        onPressed: () {
                                          if (Edt_TransferNo.text.isEmpty) {
                                            showDialogboxWarning(context,"Transfer No Should Not Left EMpty!");
                                          } else if (Edt_Mobile.text.isEmpty) {
                                            showDialogboxWarning(context,"Mobile Should not left Empty!");
                                          }
                                          //else if (headermodel.result.length == 0) {
                                          //   showDialogboxWarning(context,
                                          //       "grid should not left empty!!");
                                          // }
                                          else {
                                            print(detailmodel.result.length);
                                            int count = 0;

                                            for (int i = 0;i < detailmodel.result.length;i++) {
                                              if (detailmodel.result[i].UserQty ==0) {
                                                count++;
                                              }
                                            }
                                            if (count == 0) {
                                              savereceiveheader();
                                            } else {
                                              showDialogboxWarning(
                                                  context, "Please Enter User Qty");
                                            }
                                            // print(jsonEncode(transferModel));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Scaffold(
                            body: SingleChildScrollView(
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
                                          child: TextField(
                                            enabled: false,
                                            controller: Edt_IpoDocNo,
                                            textInputAction: TextInputAction.go,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: "DocNo",
                                              border: OutlineInputBorder(),
                                            ),
                                            onSubmitted: (val) {
                                              setState(() {
                                                getrecord(int.parse(val));
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            enabled: false,
                                            controller: Edt_IPODocDate,
                                            decoration: InputDecoration(labelText: "Doc Date",border: OutlineInputBorder(),fillColor: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: loc,
                                          label: "From Location",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk < locationModel.result.length;kk++) {
                                              if (locationModel.result[kk].name ==val) {
                                                print(locationModel.result[kk].code);
                                                alterFromLocName =locationModel.result[kk].name;
                                                alterFromLocaCode = locationModel.result[kk].code.toString();
                                              }
                                            }
                                          },
                                          selectedItem: alterFromLocName,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: loc,
                                          label: "To Location",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk < locationModel.result.length;kk++) {
                                              if (locationModel.result[kk].name ==val) {
                                                print(locationModel.result[kk].code);
                                                alterToLocName =locationModel.result[kk].name;
                                                alterToLocaCode = locationModel.result[kk].code.toString();
                                              }
                                            }
                                          },
                                          selectedItem: alterToLocName,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: selipoitemmaster,
                                          label: "Select Product",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk < RawIPOItemModel.testdata.length;kk++) {
                                              if (RawIPOItemModel.testdata[kk].itemName ==val) {

                                              }
                                            }
                                          },
                                          selectedItem: alterFromLocName,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: DropdownSearch<String>(
                                          mode: Mode.DIALOG,
                                          showSearchBox: true,
                                          items: loc,
                                          label: "To Location",
                                          onChanged: (val) {
                                            print(val);
                                            for (int kk = 0;kk < locationModel.result.length;kk++) {
                                              if (locationModel.result[kk].name ==val) {
                                                print(locationModel.result[kk].code);
                                                alterToLocName =locationModel.result[kk].name;
                                                alterToLocaCode = locationModel.result[kk].code.toString();
                                              }
                                            }
                                          },
                                          selectedItem: alterToLocName,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    color: Colors.white,
                                    height: height * 0.6,
                                    width: width,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          sortColumnIndex: 0,
                                          sortAscending: true,
                                          headingRowColor:MaterialStateProperty.all(Colors.blue),
                                          showCheckboxColumn: false,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'S.No',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Item Name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Center(
                                                child: Text(
                                                  'Order Qty',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Center(
                                                child: Text(
                                                  'UOM',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Stock',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                          rows: SecIPODataModel.map(
                                            (list) => DataRow(cells: [
                                              DataCell(
                                                Text(
                                                  SecIPODataModel.indexOf(list).toString(),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  list.ItemName.toString(),
                                                ),
                                              ),
                                              DataCell(
                                                  Text(
                                                    list.OrderQty.toString(),
                                                  ),
                                                  showEditIcon: true, onTap: () {
                                                if (list.ItemUOM == "Grams" ||list == "Kgs") {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
                                                    builder:(BuildContext context) {
                                                      return Dialog(
                                                        shape:RoundedRectangleBorder(
                                                          borderRadius:BorderRadius.circular(50),),
                                                        elevation: 0,
                                                        backgroundColor:Colors.transparent,
                                                        child: SubMyClac(context,SecIPODataModel.indexOf(list)),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:(BuildContext context) {
                                                      return Dialog(
                                                        shape:RoundedRectangleBorder(
                                                          borderRadius:BorderRadius.circular(50),),
                                                        elevation: 0,
                                                        backgroundColor:Colors.transparent,
                                                        child: QtyMyClac(context,SecIPODataModel.indexOf(list)),
                                                      );
                                                    },
                                                  );
                                                }
                                              }),
                                              DataCell(
                                                Text(
                                                  list.ItemUOM.toString(),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  list.Stock.toString(),
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
                            persistentFooterButtons: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FloatingActionButton.extended(
                                      backgroundColor: Colors.red,
                                      icon: Icon(Icons.clear),
                                      label: Text('Cancel'),
                                      onPressed: () {
                                        print('FloatingActionButton clicked');
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    FloatingActionButton.extended(
                                      backgroundColor: Colors.blue.shade700,
                                      icon: Icon(Icons.check),
                                      label: Text('Send PO '),
                                      onPressed: () {
                                        insertIPOheader();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          );
  }

  SubMyClac(context, index) {
    print("SubMyClac");
    var Qty;
    return Stack(
      children: <Widget>[
        Container(
          width: 450,
          height: 520,
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
                height: 420,
                width: 420,
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
                  theme: const CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 1,
                    displayColor: Colors.white,
                    displayStyle:
                        TextStyle(fontSize: 20, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle:
                        TextStyle(fontSize: 15, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle:
                        TextStyle(fontSize: 15, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle:
                        TextStyle(fontSize: 15, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    SecIPODataModel[index].OrderQty = double.parse(Qty);

                    //count();
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {},
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
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

  QtyMyClac(context, index) {
    print("QtyMyClac");
    var Qty;
    return Stack(
      children: <Widget>[
        Container(
          width: 450,
          height: 520,
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
                height: 420,
                width: 420,
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
                  theme: const CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 1,
                    displayColor: Colors.white,
                    displayStyle:
                        TextStyle(fontSize: 20, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle:
                        TextStyle(fontSize: 15, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle:
                        TextStyle(fontSize: 15, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle:
                        TextStyle(fontSize: 15, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    SecIPODataModel[index].OrderQty = double.parse(Qty);

                    // count();
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {},
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
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

  Future<http.Response> getIPODataTableRecord(DocEntry, FormId) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();
    });
    var body = {
      "FromId": FormId,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": DocEntry,
      "Status": "GH1_PWhs", //WHSCODE
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
   // var nodata = jsonDecode(response.body)['status'] == 0;
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        // print('YesResponce');
        print("IPO DataTbl" + response.body);
        RawIPOItemModel = IPOItemModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < RawIPOItemModel.testdata.length; i++) {
          selipoitemmaster.add(RawIPOItemModel.testdata[i].itemName);

        }

        setState(() {
          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
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
        print("Location Responce" + response.body);
        setState(() {
          locationModel = LocationModel.fromJson(jsonDecode(response.body));
          loc.clear();
          for (int k = 0; k < locationModel.result.length; k++) {
            print(locationModel.result[k].name);
            print(locationModel.result[k].code);
            if (locationModel.result[k].code == int.parse(sessionbranchcode)) {
              alterFromLocName = locationModel.result[k].name;
              alterFromLocaCode = locationModel.result[k].code.toString();
            }

            if (locationModel.result[k].code == 8) {
              alterToLocaCode = locationModel.result[k].code.toString();
              alterToLocName = locationModel.result[k].name.toString();
            }

            //loc.add(locationModel.result[k].name);
          }
          loading = false;
          getIPODataTableRecord(0, 16);
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> saveheader() async {
    print("Edt_Mobile->" + Edt_Mobile.text);
    var headers = {"Content-Type": "application/json"};
    var body = {
      "DriverCode": altersalespersoncode,
      "DriverName": altersalespersoname,
      "VehicleCode": altervechiclcode,
      "VehicleName": altervechiclename,
      "LocCode": alterlocationcode,
      "LocName": Edt_Location.text,
      "MobileNo": Edt_MobileNo.text,
      "RefNo": Edt_DocNo1.text,
      "RefDate": Edt_DocDate1.text.substring(0, 10),
      "Status": '0',
      "Remarks": '',
      "UserID": '$sessionuserID'
    };
    print(body);
    setState(() {
      loading = true;
    });

    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'insertTransferheader'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      print(response.body);
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
            Fluttertoast.showToast(
                msg: jsonDecode(response.body)['result'][0]["STATUSNAME"]
                    .toString());
            //print('DOCNO${jsonDecode(response.body)["DocNo"]}');
            postdatadetail(jsonDecode(response.body)["result"][0]["DocNo"], jsonDecode(response.body)["result"][0]["QRCode"]);
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

  Future<http.Response> postdatadetail(int headerdocno, Qrcode) async {
    print("Qrcode" + Qrcode);
    setState(() {
      json = Qrcode;
    });
    var headers = {"Content-Type": "application/json"};
    for (int i = 0; i < transferModel.result.length; i++)
      if (transferModel.result[i].TransferQty > 0)
        detailitems.add(SendTranasferModel(
            headerdocno,
            0,
            transferModel.result[i].itemCode,
            transferModel.result[i].itemName,
            transferModel.result[i].locCode,
            transferModel.result[i].locName,
            transferModel.result[i].reqQty,
            transferModel.result[i].TransferQty,
            transferModel.result[i].uom,
            '',
            '$sessionuserID'));
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertTransDetails'),
        headers: headers,
        body: jsonEncode(detailitems));
    print(jsonEncode(detailitems));
    setState(() {
      loading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          Fluttertoast.showToast(msg: jsonDecode(response.body)["result"][0]["STATUSNAME"]);
          GetQrPrint(sessionIPAddress, sessionIPPortNo);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RequestTransferScreen(
                id: 0,
                DocNo: 0,
              ),
            ),
          );
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Login API');
    }
  }

  GetQrPrint(String iPAddress, int pORT,) async {
    log(iPAddress);
    print(pORT);
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printDemoReceipt(printer);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: $e');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {

    printer.row([
      PosColumn(text: 'Request No', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Edt_DocNo1.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left),
      ),
    ]);
    printer.row([
      PosColumn(text: 'Transfer No', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: json.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: 'Vehicle No', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altervechiclename.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: 'Driver Name', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altersalespersoname.toString(), width: 7, styles: PosStyles(align: PosAlign.left),
      ),
    ]);
    printer.row([
      PosColumn(text: 'Mobile No', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Edt_MobileNo.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left),

      ),
    ]);
    printer.feed(1);



    List<ProQrGenerateJson> SecQrGenerateJson=[];
    SecQrGenerateJson.clear();
    var jsonwww;
    SecQrGenerateJson.add(
      ProQrGenerateJson(
          json.toString(),
          ScreenName),
    );
    jsonwww = jsonEncode(SecQrGenerateJson.map((e) => e.toJson()).toList());
    print(jsonwww);


    printer.qrcode(jsonwww, align: PosAlign.center);
    printer.feed(1);
    printer.row([
      PosColumn(text: 'From Whs/Loc', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: sessionbranchname.toString(), width: 7, styles: PosStyles(align: PosAlign.left),
      ),
    ]);

    printer.row([
      PosColumn(text: 'To Whs/Loc', width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: Edt_ReqLocation.text.toString(), width: 7, styles: PosStyles(align: PosAlign.left),
      ),
    ]);

    printer.feed(1);
    printer.cut();
  }

  Future<http.Response> savereceiveheader() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "TransferNo": alterreceiveDocno,
      "MobileNo": Edt_Mobile.text,
      "DriverCode": alterdrivercode,
      "DriverName": Edt_DriverName.text,
      "VehicleNo": Edt_VehicelNo.text,
      "VehicleName": Edt_VehicelNo.text,
      "Remarks": ScreenName,
      "UserID": '$sessionuserID',
      "DebitQty": Edt_DebitQty.text.isEmpty ? 0 : Edt_DebitQty.text,
      "DebitAmount": Edt_DebitAmount.text.isEmpty ? 0 : Edt_DebitAmount.text,
      "DocType": Edt_Type.text,
      "BranchId": int.parse(sessionbranchcode)
    };
    print(body);
    setState(() {
      loading = true;
    });

    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'insertreceiveheader'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      print(response.body);
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
            Fluttertoast.showToast(
                msg: jsonDecode(response.body)['result'][0]["STATUSNAME"]
                    .toString());
            //print('DOCNO${jsonDecode(response.body)["DocNo"]}');
            savereceivedetail(jsonDecode(response.body)["result"][0]["DocNo"]);
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

  Future<http.Response> savereceivedetail(int headerdocno) async {
    var headers = {"Content-Type": "application/json"};
    for (int i = 0; i < detailmodel.result.length; i++)
      if (detailmodel.result[i].UserQty > 0)
        receiveddetailitems.add(
          SendReceiveModel(
              headerdocno,
              0,
              detailmodel.result[i].itemCode,
              detailmodel.result[i].itemName,
              detailmodel.result[i].uom,
              detailmodel.result[i].reqQty,
              detailmodel.result[i].UserQty,
              '',
              alterreceiveDocno,
              '$sessionuserID',
              'WH001'),
        );

    //print(sessionuserID);
    setState(() {
      loading = true;
    });
    //print(jsonEncode(details));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertreceiveDetail'),
        headers: headers,
        body: jsonEncode(receiveddetailitems));
    print(jsonEncode(receiveddetailitems));
    setState(() {
      loading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)["result"][0]["STATUSNAME"]);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RequestTransferScreen(
                        id: 0,
                        DocNo: 0,
                      )));
        });
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Login API');
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
      sessionIPAddress = prefs.getString("SaleInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));
    });
    if (widget.id == 1) {
      li4 = null;
      templist.clear();
      sendtemplist.clear();
      transferModel = null;
      Edt_DocNo1.text = "";
      Edt_DocDate1.text = "";
      //getvechiclemaster();
      getVEHICLERecord();
      print("widget.DocNo - " + widget.DocNo.toString());
      getrecord(
        widget.DocNo,
      );
    } else {}
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
                            child: li4 == null
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
                                        label: Center(
                                          child: Text(
                                            'Item Name',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Text(
                                            'Location',
                                            style: TextStyle(color: Colors.white),
                                          ),
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
                                          'User Qty',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                    rows: li4.result
                                        .map(
                                          (list1) => DataRow(cells: [
                                            DataCell(
                                              Wrap(
                                                  direction: Axis.vertical,
                                                  //default
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                    Text(list1.itemName,
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
                                                        list1.location.toString(),
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
                                                    Text(list1.onHand.toString(),
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
                                                      list1.userQty.toString() != "null"
                                                          ? list1.userQty
                                                              .toString()
                                                          : "0",
                                                    ),
                                                  ]),
                                              placeholder: false,
                                              showEditIcon: true,
                                              onTap: () {
                                                print('onTapQty');
                                                print(list1.userQty.toString());
                                                _displayTextInputDialog(context,
                                                    li4.result.indexOf(list1),list1.UOM);
                                              },
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
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      child: new Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        child: new Text(
                          'Okfff',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          print('OKKO${li4.result.length}');
                          for (int k = 0; k < li4.result.length; k++) {

                            //print(li4.result[k].userQty);

                            if(li4.result[k].userQty.toString()=="null"){

                            }else{
                              setState(() {
                                templist.add(
                                  RequestModelTemp(
                                    li4.result[k].itemCode.toString(),
                                    li4.result[k].itemName.toString(),
                                    li4.result[k].UOM.toString(),
                                    li4.result[k].locCode.toString(),
                                    li4.result[k].location.toString(),
                                    li4.result[k].userQty.toString(),
                                    li4.result[k].onHand.toString(),
                                    li4.result[k].whsName.toString(),
                                ),
                              );
                              });
                            }


                          }
                          Navigator.pop(context);
                          li4.result = null;
                          alteritemcode = "";
                          Edt_ProductName.text = "";
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

  void addItemToList(String itemCode, String itemName, String uOM,
      String locCode, String locName, var qty, var Stock, String UOM) {
    var countt = 0;

    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == itemCode) countt++;
    }
    if (countt == 0) {
      templist.add(RequestModelTemp(
          itemCode, itemName, uOM, locCode, locName, qty, Stock, UOM));
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: itemName + "Item Already Exists");
    }
    Edt_ProductName.text = "";
  }

  Future<void> _displayTextInputDialog(BuildContext context, int index, String uom) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
              new TextEditingController();
          //print(li4.result[index].userQty.toString());
          //_textFieldController.text = "0";
          li4.result[index].userQty.toString() != "null"
              ? _textFieldController.text = li4.result[index].userQty.toString()
              : _textFieldController.text = "0";
          return AlertDialog(
            title: Text('Enter Qty'),
            content: TextField(
              inputFormatters: <TextInputFormatter>[

                uom=="Grams"||uom=="Kgs"?FilteringTextInputFormatter.singleLineFormatter
                :FilteringTextInputFormatter.digitsOnly,
              ],
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
                    print(li4.result[index].userQty);
                    if (_textFieldController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Qty Should not Empty");
                    } else if (double.parse(_textFieldController.text.toString().toString()) > li4.result[index].onHand) {
                      Fluttertoast.showToast(msg: "Stock and Qty Mismatched");
                    } else {
                      li4.result[index].userQty = double.parse(_textFieldController.text.toString());
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _transferdisplayTextInputDialog1(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
              new TextEditingController();
          //print(li4.result[index].userQty.toString());
          //_textFieldController.text = "0";
          detailmodel.result[index].UserQty.toString() != null
              ? _textFieldController.text =
                  detailmodel.result[index].UserQty.toString()
              : _textFieldController.text = "0";
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
                    if (_textFieldController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Qty Should not Empty");
                    } else if (double.parse(_textFieldController.text.toString().toString()) >
                        detailmodel.result[index].transferQty) {
                      Fluttertoast.showToast(msg: "Stock and Qty Mismatched");
                    } else {
                      detailmodel.result[index].UserQty = double.parse(_textFieldController.text);
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _transferdisplayTextInputDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
              new TextEditingController();
          //print(li4.result[index].userQty.toString());
          //_textFieldController.text = "0";
          transferModel.result[index].TransferQty.toString() != null
              ? _textFieldController.text =
                  transferModel.result[index].TransferQty.toString()
              : _textFieldController.text = "0";
          return AlertDialog(
            title: Text('Enter Qty'),
            content: TextField(
              inputFormatters: <TextInputFormatter>[
                transferModel.result[index].uom=="Grams"||transferModel.result[index].uom=="Kgs"
                    ? FilteringTextInputFormatter.singleLineFormatter
                    :FilteringTextInputFormatter.digitsOnly,
              ],
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
                    if (_textFieldController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Qty Should not Empty");
                    } else if (double.parse(
                            _textFieldController.text.toString().toString()) >
                        transferModel.result[index].reqQty) {
                      Fluttertoast.showToast(msg: "Stock and Qty Mismatched");
                    } else {
                      transferModel.result[index].TransferQty = double.parse(_textFieldController.text);
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future<http.Response> insertRequestHeader() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "BranchId": int.parse(sessionbranchcode),
      "UserID": int.parse(sessionuserID),
      "ReqQty": 0
    };
    print(body);
    setState(() {
      //loading = true;
    });

    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'insertRequestheader'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      print(response.body);
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
            Fluttertoast.showToast(
                msg: jsonDecode(response.body)['result'][0]["STATUSNAME"]
                    .toString());
            print(jsonDecode(response.body)["result"][0]["DocNo"]);
            insertRequestdetails(
                jsonDecode(response.body)["result"][0]["DocNo"]);
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

  Future<http.Response> insertRequestdetails(DocEntry) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(
        SendTemp(
            templist[i].itemCode,
            templist[i].itemName,
            templist[i].locCode,
            templist[i].locName,
            templist[i].qty,
            templist[i].uOM,
            '0',
            int.parse(sessionuserID),
            DocEntry),
      );

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertRequest'),
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
          context,
          MaterialPageRoute(
            builder: (context) => RequestTransferScreen(
              id: 0,
              DocNo: 0,
            ),
          ),
        );
        //setState(() {});
      }
      return response;
    } else {
      showDialogboxWarning(context, 'Failed to Login API');
    }
  }

  Future<http.Response> insertIPOheader() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromLocation": int.parse(alterFromLocaCode),
      "ToLocation": int.parse(alterToLocaCode),
      "TotalQty": 0.0,
      "CreateBy": int.parse(sessionuserID),
      "BranchId": int.parse(sessionbranchcode)
    };
    print(body);
    setState(() {
      //loading = true;
    });

    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'insertIPOheader'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      print(response.body);
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
            Fluttertoast.showToast(
                msg: jsonDecode(response.body)['result'][0]["STATUSNAME"]
                    .toString());
            print("DocNo" +
                jsonDecode(response.body)["result"][0]["DocNo"].toString());
            insertIPODetalis(jsonDecode(response.body)["result"][0]["DocNo"]);
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

  Future<http.Response> insertIPODetalis(DocEntry) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      //loading = true;
      TempIPODataModel.clear();
    });
    for (int i = 0; i < SecIPODataModel.length; i++)
      if (SecIPODataModel[i].OrderQty > 0.0) {
        TempIPODataModel.add(
          SendIPODataModel(
              DocEntry,
              1 + 1,
              SecIPODataModel[i].ItemCode,
              SecIPODataModel[i].ItemName,
              SecIPODataModel[i].ItemUOM,
              SecIPODataModel[i].Stock,
              SecIPODataModel[i].OrderQty,
              SecIPODataModel[i].WhsCode),
        );
      }
    log(jsonEncode(TempIPODataModel));
    // }
    //print(jsonDecode(TempIPODataModel.map((e) => e.toJson()).toList()));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertIPODetalis'),
        body: jsonEncode(TempIPODataModel),
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
          context,
          MaterialPageRoute(
            builder: (context) => RequestTransferScreen(
              id: 0,
              DocNo: 0,
            ),
          ),
        );
        //setState(() {});
      }
      return response;
    } else {
      showDialogboxWarning(context, 'Failed to Login API');
    }
  }

  Future getdocnoanddate() {
    GetAllDocNo(currentindex == 0 ? 5 : currentindex == 2 ? 7 : 8, sessionuserID)
        .then((response) {
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
          Edt_DocDate.text = "";
          Edt_DocNo.text = "";

          if (currentindex == 1) {
            Edt_DocDate.text = "";
            Edt_DocNo.text = "";
          } else {
            Edt_DocDate.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
            Edt_DocNo.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
          }
          getItem();
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getIPOdocnoanddate() {
    GetAllDocNo(9, sessionuserID).then((response) {
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
          Edt_DocDate.text = "";
          Edt_DocNo.text = "";

          if (currentindex == 1) {
            Edt_DocDate.text = "";
            Edt_DocNo.text = "";
          } else {
            Edt_IPODocDate.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
            Edt_IpoDocNo.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
          }
          // getItem();
          getlocationval();
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getdocnoanddatereceive() {
    GetAllDocNo(7, sessionuserID).then((response) {
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
          Edt_ReceiveNo.text = "";
          Edt_ReceiveDate.text = "";

          Edt_ReceiveNo.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
          Edt_ReceiveDate.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getrecord(DocNo) async {
    var headers = {"Content-Type": "application/json"};
    print(DocNo);
    print(sessionbranchcode);

    var body = {
      "DocNo": DocNo,
      "LocCode": int.parse(sessionbranchcode),
    };
    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(Uri.parse(AppConstants.LIVE_URL + 'getTransferData'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            Fluttertoast.showToast(
                msg: "No Data",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            transferModel = null;
            Edt_DocNo1.text = "";
            Edt_DocDate1.text = "";
            Edt_Location.text = "";
          });
        } else {
          log(response.body);
          setState(() {
            Edt_DocNo1.text = "";
            Edt_DocDate1.text = "";
            Edt_Location.text = "";
            transferModel = TransferModel.fromJson(jsonDecode(response.body));
            Edt_DocNo1.text = transferModel.result[0].DocEntry.toString();
            Edt_DocDate1.text =transferModel.result[0].docDate.toString().substring(0, 10);
            Edt_Location.text = transferModel.result[0].locName.toString();
            alterlocationcode = transferModel.result[0].locCode.toString();
            Edt_ReqLocation.text = transferModel.result[0].RequestLocation.toString();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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
                content: Text("Slow Server Response or Internet connection",
                  style: TextStyle(color: Colors.white)
                  ,)
              ,)
          ,);
      });
      throw Exception('Internet is down');
    }
  }

//LOC -LOC Recive Data Header
  Future<http.Response> getrecordreceive(String QR) async {
    print(QR);
    var headers = {"Content-Type": "application/json"};
    var body = {"QRCode": QR};
    setState(() {
      loading = true;
      detailmodel = null;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getTransferDataReceivedHeader'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            Fluttertoast.showToast(
                msg: "No Data",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            headermodel = null;
            Edt_DocNo1.text = "";
            Edt_DocDate1.text = "";
            Edt_Location.text = "";
          });
        } else {
          print(response.body);
          setState(() {
            Edt_DocNo1.text = "";
            Edt_DocDate1.text = "";
            Edt_Location.text = "";

            headermodel = RequestHeaderModel.fromJson(jsonDecode(response.body));

            Edt_TransferNo.text = headermodel.result[0].qRCode.toString();

            alterreceiveDocno = headermodel.result[0].docNo.toString();

            Edt_Mobile.text = headermodel.result[0].mobileNo.toString();
            Edt_DriverName.text = headermodel.result[0].driverName.toString();
            Edt_VehicelNo.text = headermodel.result[0].vehicleName.toString();

            alterdrivercode = headermodel.result[0].driverCode.toString();

            getdetails(headermodel.result[0].docNo.toString());
            print(headermodel.result[0].docNo.toString());
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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

  Future<http.Response> getdetails(String DocNo) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"DocNo": DocNo};
    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getTransferDataReceivedDetail'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            Fluttertoast.showToast(
                msg: "No Data",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            detailmodel = null;
          });
        } else {
          print("Recive Detalis" + response.body);
          setState(() {
            detailmodel = RequestDetailModel.fromJson(jsonDecode(response.body));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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

  // GDN- LOC

  Future<http.Response> getGDNHeaderRecord(DocEntry) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      //templist.clear();
    });
    var body = {
      "FromId": 19,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": DocEntry,
      "Status": "GH1_PWhs", //WHSCODE
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
    //var nodata = jsonDecode(response.body)['status'] == 0;
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
        final decode = jsonDecode(response.body.toString());

        setState(() {
          Edt_DocNo1.text = "";
          Edt_DocDate1.text = "";
          Edt_Location.text = "";

          //headermodel = RequestHeaderModel.fromJson(jsonDecode(response.body));

          Edt_TransferNo.text = decode["testdata"][0]["DocNo"].toString();

          alterreceiveDocno = decode["testdata"][0]["DocNo"].toString();
          print(
            decode["testdata"][0]["DriverName"].toString(),
          );

          Edt_Mobile.text = decode["testdata"][0]["MobileNo"].toString();
          Edt_DriverName.text = decode["testdata"][0]["DriverName"].toString();
          Edt_VehicelNo.text = decode["testdata"][0]["VehicleName"].toString();

          alterdrivercode = decode["testdata"][0]["DriverCode"].toString();
          getGDNDataTbleRecord(decode["testdata"][0]["DocNo"]);

          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getGDNDataTbleRecord(DocNo) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"DocNo": DocNo};
    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getGDNDataTbleRecord'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            Fluttertoast.showToast(
                msg: "No Data",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            detailmodel = null;
          });
        } else {
          print("Recive Detalis" + response.body);
          setState(() {
            detailmodel =
                RequestDetailModel.fromJson(jsonDecode(response.body));
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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

  // End GDN - LOC

  Future<http.Response> getDeliveryrecordreceive(String QR) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"QRCode": Edt_TransferNo.text};
    setState(() {
      loading = true;
      detailmodel = null;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getTransferDataReceivedHeader'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            Fluttertoast.showToast(
                msg: "No Data",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            headermodel = null;
            Edt_DocNo1.text = "";
            Edt_DocDate1.text = "";
            Edt_Location.text = "";
          });
        } else {
          print(response.body);
          setState(() {
            Edt_DocNo1.text = "";
            Edt_DocDate1.text = "";
            Edt_Location.text = "";

            headermodel =
                RequestHeaderModel.fromJson(jsonDecode(response.body));

            Edt_TransferNo.text = headermodel.result[0].qRCode.toString();

            alterreceiveDocno = headermodel.result[0].docNo.toString();

            Edt_Mobile.text = headermodel.result[0].mobileNo.toString();
            Edt_DriverName.text = headermodel.result[0].driverName.toString();
            Edt_VehicelNo.text = headermodel.result[0].vehicleName.toString();

            alterdrivercode = headermodel.result[0].driverCode.toString();

            getdetails(headermodel.result[0].docNo.toString());
            print(headermodel.result[0].docNo.toString());
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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
          secitemlist.clear();
          for (int k = 0; k < ItemList.result.length; k++) {
            secitemlist.add(ItemList.result[k].itemName);
          }
          //log(response.body.toString());
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getvechiclemaster() {
    setState(() {
      loading = true;
    });
    GetAllMaster(1, int.parse(sessionuserID), int.parse(sessionbranchcode))
        .then((response) {
      // print(jsonDecode.body);
      setState(() {
        loading = false;
        vechiclelist.clear();
      });
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
          //vehicleModel.result.clear();
        } else {
          setState(() {
            loading = false;
            print("Selvba V");

            vehicleModel = VehicleModel.fromJson(jsonDecode(response.body));

            for (int k = 0; k < vehicleModel.result.length; k++) {
              vechiclelist.add(vehicleModel.result[k].VehicleName);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getVEHICLERecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      templist.clear();
    });
    var body = {
      "FromId": 13,
      "ScreenId": 0,
      "DocNo": 10,
      "DocEntry": 10,
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
    //var nodata = jsonDecode(response.body)['status'] == 0;
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
        salesPersonget(
          int.parse(sessionuserID),
          int.parse(sessionbranchcode),
        );
      } else {
        print('Selva Vehile YesResponce');
        print(response.body);
        setState(() {
          RawGetvehiclemodel = Getvehiclemodel.fromJson(jsonDecode(response.body));
          print(RawGetvehiclemodel.testdata.length);
          vechiclelist.clear();

          for (int k = 0; k < RawGetvehiclemodel.testdata.length; k++) {
            vechiclelist.add(RawGetvehiclemodel.testdata[k].vehicleNo);
          }
          salesPersonget(
            int.parse(sessionuserID),
            int.parse(sessionbranchcode),
          );
        });
      }
      setState(() {
        loading = false;
      });
    } else {
      throw Exception('Failed to Login API');
    }
  }

  void salesPersonget(int USERID, int BRANCHID) {
    setState(() {
      loading = true;
    });
    GetAllSalesPerson(USERID, BRANCHID).then((response) {
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
          salespersonmodel.result.clear();
        } else {
          setState(() {
            salespersonmodel = EmpModel.fromJson(jsonDecode(response.body));
            print(salespersonmodel.result.length);
            salespersonlist.clear();
            for (int k = 0; k < salespersonmodel.result.length; k++) {
              salespersonlist.add(salespersonmodel.result[k].name);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void increment(int index) {
    setState(() {
      double b;
      if (double.parse(templist[index].qty.toString()) == 100) {
        Fluttertoast.showToast(msg: "You Cannot more than 100 Qty");
      } else {
        b = double.parse(templist[index].qty.toString());
        b++;
        templist[index].qty = double.parse(b.toString());
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

      }
    });
  }

  Future<http.Response> getrolliststockwise(String ItemCode) async {
    var headers = {"Content-Type": "application/json"};
    var body = {"ItemCode": ItemCode};
    setState(() {
      loading = true;
    });
    try {
      print('inside1');
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getRequeststock'),
          headers: headers,
          body: jsonEncode(body));
      setState(() {
        loading = false;
      });
      //print(jsonEncode(body));
      print('RES ${jsonDecode(response.body)['status']}');
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          setState(() {
            Fluttertoast.showToast(
                msg: "No Data",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            li4 = null;
          });
        } else {
          setState(() {
            try {
              print(jsonDecode(response.body)["result"]);
              li4 = RequestStockWise.fromJson(jsonDecode(response.body));

              for (int i = 0; i < li4.result.length; i++) {
                controllers.add(new TextEditingController());
                controllers[i].text = "0";
              }
            } on Exception catch (e) {
              print(e.toString());
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
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

  void addipodatatble(Itemcode,itemName,UOM,stock,whsCode) {
    setState(() {

      int count = 0;
      for(int i = 0 ; i < SecIPODataModel.length; i ++){
        if(SecIPODataModel[i].ItemCode ==Itemcode ){
          count++;
        }

      }

      if(count==0){
      SecIPODataModel.add(
        IPODataModel(
            0,
            Itemcode,
            itemName,
            UOM,
            stock,
            0,
            whsCode),
      );
      }else{
        Fluttertoast.showToast(msg: "This Item Already Added..");
      }
    });
  }
}

class ProQrGenerateJson {
  var OrderNo;
  var type;
  ProQrGenerateJson(this.OrderNo, this.type);
  Map toJson() => {
    'OrderNo': OrderNo,
    'Type': type,
  };
}



class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<ItemFillModel> my = new List();
    if (_RequestTransferScreenState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0;
          a < _RequestTransferScreenState.ItemList.result.length;
          a++)
        if (_RequestTransferScreenState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _RequestTransferScreenState.ItemList.result[a].itemCode,
              _RequestTransferScreenState.ItemList.result[a].itemName,
              _RequestTransferScreenState.ItemList.result[a].uOM,
              _RequestTransferScreenState.ItemList.result[a].qty,
              _RequestTransferScreenState.ItemList.result[a].Stock));
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

class RequestModelTemp {
  String itemCode;
  String itemName;
  String uOM;
  String locCode;
  String locName;
  var qty;
  var Stock;
  String UOM;

  RequestModelTemp(this.itemCode, this.itemName, this.uOM, this.locCode,
      this.locName, this.qty, this.Stock, this.UOM);
}

class SendTemp {
  String itemCode;
  String itemName;
  String LocCode;
  String LocName;
  var ReqQty;
  String Uom;
  String Remarks;
  int UserID;
  var DocEntry;

  SendTemp(this.itemCode, this.itemName, this.LocCode, this.LocName,
      this.ReqQty, this.Uom, this.Remarks, this.UserID, this.DocEntry);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;

    data['LocCode'] = this.LocCode;
    data['LocName'] = this.LocName;
    data['ReqQty'] = this.ReqQty;
    data['Uom'] = this.Uom;
    data['Remarks'] = this.Remarks;
    data['UserID'] = this.UserID;
    data['DocEntry'] = this.DocEntry;
    return data;
  }
}

class SendTranasferModel {
  var DocNo;
  var LineID;
  String itemCode;
  String itemName;
  String LocCode;
  String LocName;
  var ReqQty;
  var TransferQty;
  String Uom;
  String Remarks;
  var UserID;

  SendTranasferModel(
    this.DocNo,
    this.LineID,
    this.itemCode,
    this.itemName,
    this.LocCode,
    this.LocName,
    this.ReqQty,
    this.TransferQty,
    this.Uom,
    this.Remarks,
    this.UserID,
  );

  Map<String, dynamic> toJson() => {
        'DocNo': DocNo,
        'LineID': LineID,
        'ItemCode': itemCode,
        'ItemName': itemName,
        'LocCode': LocCode,
        'LocName': LocName,
        'ReqQty': ReqQty,
        'TransferQty': TransferQty,
        'Uom': Uom,
        'Remarks': Remarks,
        'UserID': UserID,
      };
}

class SendReceiveModel {
  var DocNo;
  var LineID;
  String itemCode;
  String itemName;
  String Uom;
  var ReqQty;
  var TransferQty;
  String Remarks;
  var RefNo;
  var UserID;
  var WhsCode;

  SendReceiveModel(
      this.DocNo,
      this.LineID,
      this.itemCode,
      this.itemName,
      this.Uom,
      this.ReqQty,
      this.TransferQty,
      this.Remarks,
      this.RefNo,
      this.UserID,
      this.WhsCode);

  Map<String, dynamic> toJson() => {
        'DocNo': DocNo,
        'LineID': LineID,
        'ItemCode': itemCode,
        'ItemName': itemName,
        'Uom': Uom,
        'Qty': ReqQty,
        'ReceivedQty': TransferQty,
        'Remarks': Remarks,
        'RefNo': RefNo,
        'UserID': UserID,
        'WhsCode': WhsCode
      };
}

class IPODataModel {
  var SNO;
  var ItemCode;
  var ItemName;
  var ItemUOM;
  var Stock;
  double OrderQty;
  var WhsCode;
  IPODataModel(this.SNO, this.ItemCode, this.ItemName, this.ItemUOM, this.Stock,
      this.OrderQty, this.WhsCode);
}

class SendIPODataModel {
  var DocNo;
  var SNO;
  var ItemCode;
  var ItemName;
  var ItemUOM;
  var Stock;
  var OrderQty;
  var WhsCode;
  SendIPODataModel(this.DocNo, this.SNO, this.ItemCode, this.ItemName,
      this.ItemUOM, this.Stock, this.OrderQty, this.WhsCode);
  Map<String, dynamic> toJson() => {
        'DocNo': DocNo,
        'RowId': SNO,
        'ItemCode': ItemCode,
        'UOM': ItemUOM,
        'WhsCode': WhsCode,
        'OrderQty': OrderQty,
        'Stock': Stock
      };
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class ReceiceType {
  int Code;
  var Description;
  ReceiceType(this.Code, this.Description);
}
