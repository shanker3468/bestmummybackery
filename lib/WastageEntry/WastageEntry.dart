import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/WastageTansferModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/Reasonmodel.dart';
import 'package:bestmummybackery/Model/VehicleModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/Model/WhsModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Masters/PromotionMasterTransction.dart';

class WastageEntry extends StatefulWidget {
  const WastageEntry({Key key}) : super(key: key);

  @override
  _WastageEntryState createState() => _WastageEntryState();
}

class _WastageEntryState extends State<WastageEntry> {
  TextEditingController Edt_DocNo = new TextEditingController();
  TextEditingController Edt_DocDate = new TextEditingController();
  TextEditingController Edt_FromWhs = new TextEditingController();
  TextEditingController Edt_ToWhs = new TextEditingController();

  TextEditingController Edt_DocNoNew = new TextEditingController();
  TextEditingController Edt_DocDateNew = new TextEditingController();
  TextEditingController Edt_FromWhsNew = new TextEditingController();
  TextEditingController Edt_ToWhsNew = new TextEditingController();
  TextEditingController Edt_ProductName = new TextEditingController();

  bool loading = false;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionContact1 = "";
  var sessionIPPortNo = 0;
  var altercategoryName = "";
  var altercategorycode = "";
  static WastageItemModel ItemList;
  WastageTransferModel transferModel;
  var alteritemcode = "";
  var alteritemName = "";
  var alteritemuom = "";
  var alteritemqty = "";
  var altervechiclename = "";
  List<Result> templist = new List();
  List<SendResult> sendtemplist = new List();
  List<ResultWastegeUpdate> trasnfertemplist = new List();
  List<WastagePrintList> secWastagePrintList = new List();
  TabController _tabController;
  List<String> vechiclelist = new List();
  VehicleModel vehicleModel;
  TextEditingController Edt_DriverName = new TextEditingController();
  TextEditingController Edt_WastageDate = new TextEditingController();
  String selectedDate = "";
  int currentindex = 0;
  WhsModel whsModel;
  var alterfromwhsCode = "";
  var alterfromwhsName = "";
  var alterTowhsCode = "";
  var alterTowhsName = "";
  var  alterdrivername = "";
  String alertTaxcode='';
  String alterprice='';
  String alterAmmount='';
  var alterdrivercode = 0;

  var altertrasnitwhscode = "";
  var altertrasnitwhsname = "";
  var alterItemtype='';

  EmpModel driverlistmodel;
  List<String> driverlist = new List();
  List<String> paytype = new List();

  Reasonmodel RawReasonmodel;
  var ResanStatus=0;
  NetworkPrinter printer;
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.blueGrey.shade500,
          title: Text('Wastage Screen'),
          bottom: TabBar(
            controller: _tabController,
            onTap: (var index) {
              setState(() {
                if (index == 0) {
                  currentindex = index;
                  getdocnoanddate();
                  getlocation();
                } else {
                  currentindex = index;
                  print("currentindex$currentindex");
                  Edt_WastageDate.text='';
                  alterdrivername = '';
                  alterdrivercode =0;
                  altervechiclename = '';
                  transferModel=null;
                  getdocnoanddatenew();
                  salesPersonget();
                }
              });
            },
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Colors.black12),
            tabs: [
              Tab(
                text: 'Wastage Entry',
              ),
              Tab(
                text: 'Wastage Transfer',
              ),
            ],
          ),
        ),
        body: !loading
            ? TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
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
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
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
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
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
                                flex: 2,
                                child: Container(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    controller: Edt_FromWhs,
                                    decoration: InputDecoration(
                                      labelText: "From Whs",
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
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    controller: Edt_ToWhs,
                                    decoration: InputDecoration(
                                      labelText: "To Whs",
                                      border: OutlineInputBorder(),
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
                                        for (int i = 0; i < ItemList.result.length; i++) {
                                          this.Edt_ProductName.text = suggestion.ItemName.toString();
                                          //GrnSpinnerController.text = suggestion.toString();
                                          if (suggestion.ItemName.toString().length > 0) {
                                            //getgridItems();
                                            Edt_ProductName.text = suggestion.ItemName.toString();
                                            alteritemcode =suggestion.ItemCode.toString();
                                            alteritemName = suggestion.ItemName.toString();
                                            alteritemuom = suggestion.UOM.toString();
                                            alteritemqty = suggestion.Qty.toString();
                                            alertTaxcode = suggestion.taxcode.toString();
                                            alterprice = suggestion.price.toString();
                                            alterAmmount = suggestion.ammount.toString();
                                          } else {
                                            ItemList.result.clear();
                                          }
                                        };
                                        log(alertTaxcode+alterprice+alterAmmount);
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
                                    onChanged: (String val) {
                                      alterItemtype=val;
                                    },
                                    selectedItem: alterItemtype,
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
                                    backgroundColor: Colors.blue.shade700,
                                    icon: Icon(Icons.add),
                                    label: Text('Add'),
                                    onPressed: () {

                                      if(Edt_ProductName.text==""){
                                        Fluttertoast.showToast(msg: "Select The Product Name");
                                      }
                                     else  if(alterItemtype==''){
                                        Fluttertoast.showToast(msg: "Select Item Type");
                                      }else{
                                      addItemToList(
                                          alteritemcode,
                                          alteritemName,
                                          alterfromwhsCode,
                                          alterfromwhsName,
                                          alterTowhsCode,
                                          alterTowhsName,
                                          alterItemtype,
                                          alteritemuom,
                                          alteritemqty,
                                          alertTaxcode,
                                          alterprice,
                                          alterAmmount,
                                          (double.parse(alertTaxcode.split("@")[1]) * double.parse(alterAmmount.toString()) / 100).round().toString()
                                      );
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
                            height: height * 0.6,
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
                                        headingRowColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
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
                                          DataColumn(
                                            label: Text(
                                              'Amt',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Price',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Total',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Tax  Price',
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
                                              (list) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    IconButton(
                                                      icon: Icon(Icons.cancel),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                          templist.remove(list);
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Deleted Row");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  DataCell(Text(
                                                      "${list.itemName}")),
                                                  DataCell(
                                                      Container(
                                                        child: Text(
                                                          list.qty.toString(),
                                                        ),
                                                      ),
                                                      showEditIcon: true,
                                                      onTap: () {
                                                    if (list.uOM == 'Grams' ||
                                                        list == "Kgs") {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                            shape:RoundedRectangleBorder(borderRadius:
                                                                  BorderRadius.circular(50),
                                                            ),
                                                            elevation: 0,
                                                            backgroundColor: Colors.transparent,
                                                            child: SubMyClac(context, templist.indexOf(list), '',),
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
                                                            child: QtyMyClac(context, templist.indexOf(list), '',
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }),
                                                  DataCell(
                                                    Text(
                                                        list.uOM
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign
                                                                .center),
                                                    onTap: (){
                                                      print(list.Resoncode);
                                                    }
                                                  ),
                                                  DataCell(
                                                      Text(list.ResonName
                                                              .toString(), textAlign: TextAlign.center),
                                                      showEditIcon: true,
                                                      onTap: () {
                                                    print('object');
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Choose The Type..'),
                                                          content: Container(
                                                            width: double.minPositive,
                                                            child:  RawReasonmodel!=null? ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: RawReasonmodel.result.length,
                                                              itemBuilder:
                                                                  (BuildContext context, int index) {
                                                                return ListTile(
                                                                  title:  Text(RawReasonmodel.result[index].remarks),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      list.ResonName = RawReasonmodel.result[index].remarks
                                                                          .toString();
                                                                      list.Resoncode = RawReasonmodel.result[index].docNo
                                                                          .toString();
                                                                    });
                                                                    Navigator.pop(context,);
                                                                  },
                                                                );
                                                              },
                                                            ):Text("Nodata"),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }),
                                                  DataCell(
                                                      Container(
                                                        child: Text(
                                                          list.taxcode.toString(),
                                                        ),
                                                      ),),
                                                  DataCell(
                                                      Text(
                                                          list.price.toString(),
                                                          textAlign: TextAlign.center),
                                                  ),
                                                  DataCell(
                                                      Text(list.ammount
                                                          .toString(), textAlign: TextAlign.center),
                                                  ),
                                                  DataCell(
                                                    Text(list.taxamt
                                                        .toString(), textAlign: TextAlign.center),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
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
                                    controller: Edt_DocNoNew,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
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
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    enabled: false,
                                    controller: Edt_DocDateNew,
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
                                flex: 2,
                                child: Container(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    controller: Edt_FromWhsNew,
                                    decoration: InputDecoration(
                                      labelText: "From Whs",
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
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    controller: Edt_ToWhsNew,
                                    decoration: InputDecoration(
                                      labelText: "To Whs",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    child: TextField(
                                      enabled: false,
                                      controller: Edt_WastageDate,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Wastage Date",
                                        border: OutlineInputBorder(),
                                      ),
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
                                  child: DropdownSearch<String>(
                                    mode: Mode.MENU,
                                    showSearchBox: true,
                                    items: driverlist,
                                    label: "Select Driver",
                                    onChanged: (val) {
                                      print(val);
                                      for (int kk = 0; kk < driverlistmodel.result.length; kk++) {
                                        if (driverlistmodel.result[kk].name == val) {
                                          print(driverlistmodel.result[kk].empID);
                                          alterdrivername = "";
                                          alterdrivercode = 0;

                                          alterdrivername = driverlistmodel.result[kk].name;
                                          alterdrivercode = driverlistmodel.result[kk].empID;
                                        }
                                      }
                                    },
                                    selectedItem: alterdrivername,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 2,
                                child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  items: vechiclelist,
                                  label: "Vehicle No",
                                  onChanged: (val) {
                                    setState(() {
                                      for (int kk = 0; kk < vehicleModel.result.length; kk++) {
                                        if (vehicleModel.result[kk].VehicleNo == val) {
                                          altervechiclename = vehicleModel.result[kk].VehicleNo;
                                        }
                                      }
                                      log(altervechiclename.toString());
                                    });
                                  },
                                  selectedItem: altervechiclename,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade700,
                                    icon: Icon(Icons.search),
                                    label: Text('Load'),
                                    onPressed: () {
                                      if (Edt_WastageDate.text.isEmpty) {
                                        showDialogboxWarning(
                                            context, "Select Date First");
                                      } else {
                                        getItemnew(Edt_WastageDate.text);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                color: Colors.white,
                                height: height * 0.6,
                                width: width,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: secWastagePrintList.length==0
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
                                                  'TaxCode',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Price',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Ammount',
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
                                            rows: transferModel.result
                                                .map(
                                                  (list) => DataRow(cells: [
                                                    DataCell(Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                          "${list.itemName}"),
                                                    )),
                                                    DataCell(Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                          "${list.qty.toString()}"),
                                                    )),
                                                    DataCell(
                                                      Text(list.uOM.toString(),
                                                          textAlign: TextAlign.center),
                                                    ),
                                                    DataCell(
                                                      Text(list.TaxCode.toString(),
                                                          textAlign: TextAlign.center),
                                                    ),
                                                    DataCell(
                                                      Text(list.Price.toString(),
                                                          textAlign: TextAlign.center),
                                                    ),
                                                    DataCell(
                                                      Text(list.Ammount.toString(),
                                                          textAlign: TextAlign.center),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                          list.reasonName,
                                                          textAlign: TextAlign.center),
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
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        persistentFooterButtons: [
          Row(
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                icon: Icon(Icons.check),
                label: Text('Save'),
                onPressed: () {
                  if (currentindex == 0) {
                    if (templist.length == 0) {
                      showDialogboxWarning(context, "Please Enter 1 Qty!");
                    }
                    else {
                      int status=0;
                      for(int i = 0 ; i <templist.length;i++){
                        if(templist[i].Resoncode == 0){
                          status =100;
                        }else{
                          status=1;
                        }
                      }
                      if(status ==100){
                        Fluttertoast.showToast(msg: "Kinldy Choose The Reason");
                      }else{

                        getuniqno();
                      }
                    }
                  } else {
                    if (transferModel.result.length == 0) {
                      showDialogboxWarning(context, "Add Atleast1 Grid Item");
                    }else if(alterdrivercode ==0 && alterdrivername ==''){
                      Fluttertoast.showToast(msg: "Choose The Driver...");
                    } else if(altervechiclename == ''){
                      Fluttertoast.showToast(msg: 'Choose vehicle Name');
                    }
                    else {
                      Fluttertoast.showToast(msg: "Saved...");
                      updateinsert();

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
            ],
          ),
        ],
      ),
    );
  }

  SubMyClac(context, index, packetType) {
    print('SubMyClac- Grems');
    var Qty;
    double qqqq = 0;
    var amt;
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
                      qqqq = double.parse(Qty);
                      amt = qqqq * 1000;
                      print(amt);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = value.toStringAsFixed(1);
                        qqqq = double.parse(Qty);
                        amt = qqqq * 1000;
                        print(amt);
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      templist[index].qty = 0;
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
                    templist[index].qty = amt;
                    countval();
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
                    child:ElevatedButton(
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

  QtyMyClac(context, index, packetType) {
    print('QtyMyClac- Qty');
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
                    templist[index].qty = Qty;
                    countval();
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

  void opendialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {},
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(), //.subtract(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        // we format the selected date and assign it to the state variable
        selectedDate = new DateFormat("dd-MM-yyyy").format(d);
        Edt_WastageDate.text = selectedDate;
        transferModel.result.clear();
      });
  }

  Future<http.Response> insertsalesdetails(String uniqid) async {
    var headers = {"Content-Type": "application/json"};

    setState(() {
      loading = true;
    });
    sendtemplist.clear();
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(SendResult(
          templist[i].FromWhsCode,
          templist[i].FromWhsName,
          templist[i].ToWhsCode,
          templist[i].ToWhsName,
          templist[i].Type,
          templist[i].itemCode,
          templist[i].itemName,
          templist[i].qty,
          templist[i].uOM,
          templist[i].Resoncode.toString(),
          templist[i].ResonName,
          'N',
          '${sessionuserID}',
          uniqid,
          templist[i].taxcode,
          templist[i].price,
          templist[i].ammount,
          templist[i].taxamt.toString(),
      ));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertwastage'),
        body: jsonEncode(sendtemplist),
        headers: headers);

    setState(() {
      loading = false;
    });

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
            context, MaterialPageRoute(builder: (context) => WastageEntry()));
        //setState(() {});
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future getuniqno() {
    GetUniqDocNo(sessionuserID).then((response) {
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
          setState(() {
            String uniqid =
                jsonDecode(response.body)['result'][0]['UniqNo'].toString();
            insertsalesdetails(uniqid);
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }



  void countval() async {
    setState(() {
      for (int s = 0; s < templist.length; s++) {
        if (double.parse(templist[s].qty.toString()) > 0) {
          templist[s].ammount = (double.parse(templist[s].qty.toString()) * double.parse(templist[s].price.toString())).toString();
          templist[s].taxamt = ((double.parse(templist[s].taxcode.split("@")[1]) *double.parse(templist[s].ammount.toString())) /100).round();
        }
      }
    });
  }

  void addItemToList(
      String itemCode, String itemName, String FromWhscode,
      String FromWhsName, String ToWhscode, String ToWhsName, String Type, String UOM,
      var qty,String taxcode,String price,String ammount,String taxAmt) {
    var countt = 0;

    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == itemCode) countt++;
    }
    if (countt == 0) {
      templist.add(Result(itemCode, itemName, FromWhscode, FromWhsName,
          ToWhscode, ToWhsName, Type, UOM, qty, 0, 'Select The Reson',taxcode,price,ammount,taxAmt));
      log(json.encode(templist));
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: itemName + "Item Already Exists");
    }
    Edt_ProductName.text = "";
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
      getdocnoanddate();
      getlocation();
      getreason();
    });
  }

  Future getdocnoanddate() {
    GetAllDocNo(currentindex == 0 ? 2 : 3, sessionuserID).then((response) {
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          Fluttertoast.showToast(msg: "No Data", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
        } else {
          Edt_DocDate.text = "";
          Edt_DocNo.text = "";
          Edt_DocDate.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
          Edt_DocNo.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
          getItem();
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getlocation() {
    GetAllWhs(sessionbranchcode).then((response) {
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          Fluttertoast.showToast(msg: "No Data", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
          setState(() {
            whsModel = null;
          });
        } else {
          setState(() {
            whsModel = WhsModel.fromJson(jsonDecode(response.body));

            print(currentindex);
            if (currentindex == 0) {
              print('Selva -- Entry');

              alterfromwhsName = "";
              alterfromwhsCode = "";
              alterTowhsName = "";
              alterTowhsCode = "";

              //Prodction
              alterfromwhsCode = whsModel.result[1].whsCode;
              alterfromwhsName = whsModel.result[1].whsName;

              //Wastage
              alterTowhsCode = whsModel.result[2].whsCode;
              alterTowhsName = whsModel.result[2].whsName;
              Edt_FromWhs.text = alterfromwhsName;
              Edt_ToWhs.text = alterTowhsName;
            } else {
              print('Selva -- Transfer');
              log(response.body);
              //Trasit
              alterfromwhsName = "";
              alterfromwhsCode = "";
              alterTowhsName = "";
              alterTowhsCode = "";

              alterfromwhsName = whsModel.result[2].whsName;
              alterfromwhsCode = whsModel.result[2].whsCode;
              //Wastage
              alterTowhsName = 'WastageIntransit';
              alterTowhsCode = 'Wast_GW';

              Edt_FromWhsNew.text = alterfromwhsName;
              Edt_ToWhsNew.text = alterTowhsName;
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }


  void salesPersonget() {
    setState(() {
      loading = true;
    });
    GetAllSalesPerson(int.parse(sessionuserID), int.parse(sessionbranchcode)).then((response) {
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
          driverlistmodel.result.clear();
        } else {
          setState(() {
            driverlistmodel = EmpModel.fromJson(jsonDecode(response.body));
            print(driverlistmodel.result.length);
            driverlist.clear();
            for (int k = 0; k < driverlistmodel.result.length; k++) {
              driverlist.add(driverlistmodel.result[k].name);
            }
            getvechiclemaster();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getdocnoanddatenew() {
    GetAllDocNo(3, sessionuserID).then((response) {
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
          print('Selva');
          log(response.body);
          setState(() {
            Edt_DocDateNew.text = "";
            Edt_DocNoNew.text = "";
            Edt_DocDateNew.text = jsonDecode(response.body)['result'][0]['DocDate'].toString();
            Edt_DocNoNew.text = jsonDecode(response.body)['result'][0]['DocNo'].toString();
            getvechiclemaster();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getreason() {

    print(int.parse(sessionuserID));
    print(int.parse(sessionbranchcode));

    GetAllMaster(9, int.parse(sessionuserID), int.parse(sessionbranchcode)).then((response) {
      if (response.statusCode == 200) {
        log(response.body);
        var nodata = jsonDecode(response.body)['status'] == 0;
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          ResanStatus = jsonDecode(response.body)['status'];
        } else {
          ResanStatus = jsonDecode(response.body)['status'];
          RawReasonmodel = Reasonmodel.fromJson(jsonDecode(response.body));
          for (int i = 0; i < RawReasonmodel.result.length; i++);

          setState(() {});
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
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data Vehicle Master",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          //vehicleModel.result.clear();
          getlocation();
        } else {
          setState(() {
            print('Vehicle Master');
            loading = false;
            vehicleModel = VehicleModel.fromJson(jsonDecode(response.body));

            vechiclelist.clear();
            for (int k = 0; k < vehicleModel.result.length; k++) {
              vechiclelist.add(vehicleModel.result[k].VehicleNo);
            }
            getlocation();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getItem() {
    GetItemWastage(sessionuserID, "1").then((response) {
       log(response.body);
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

  Future<http.Response> updateinsert() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    for (int i = 0; i < secWastagePrintList.length; i++)
      trasnfertemplist.add(ResultWastegeUpdate(
          Edt_WastageDate.text,
          alterdrivercode.toString(),
          alterdrivername,
          altervechiclename,
          alterfromwhsCode,
          alterfromwhsName,
          alterTowhsCode,
          alterTowhsName,
          secWastagePrintList[i].type,
          secWastagePrintList[i].itemCode,
          secWastagePrintList[i].itemName,
          secWastagePrintList[i].qty,
          secWastagePrintList[i].uOM,
          secWastagePrintList[i].reasonCode,
          secWastagePrintList[i].reasonName,
          secWastagePrintList[i].UniqID,
          int.parse(sessionuserID)));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'updatewastage'),
        body: jsonEncode(trasnfertemplist),
        headers: headers);

    print(trasnfertemplist);
    setState(() {
      loading = false;
    });

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
            setState(() {
              var TransferDocNo='';
              TransferDocNo = jsonDecode(response.body)["result"][0]["STATUSNAME"].toString();
              NetPrinter(sessionIPAddress, sessionIPPortNo, TransferDocNo);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WastageEntry(),
                ),
              );
            });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future getItemnew(String Date) {
    GetWastagetoTransfer(Date).then((response) {
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        log(response.body);
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            transferModel = null;
          });
        } else {
          setState(() {
            transferModel = WastageTransferModel.fromJson(jsonDecode(response.body));

            for(int i = 0 ; i <transferModel.result.length;i++ ){
              secWastagePrintList.add(
                  WastagePrintList(
                      transferModel.result[i]. docNo,
                      transferModel.result[i]. docDate,
                      transferModel.result[i]. fromWhsCode,
                      transferModel.result[i]. fromWhsName,
                      transferModel.result[i]. toWhsCode,
                      transferModel.result[i]. toWhsName,
                      transferModel.result[i]. type,
                      transferModel.result[i]. itemCode,
                      transferModel.result[i]. itemName,
                      transferModel.result[i]. qty,
                      transferModel.result[i]. uOM, transferModel.result[i]. reasonCode,
                      transferModel.result[i]. reasonName,
                      transferModel.result[i]. isTransfer, transferModel.result[i]. createdBy,
                      transferModel.result[i]. createdDate, transferModel.result[i]. modifiedBy,
                      transferModel.result[i]. modifiedDate, transferModel.result[i]. UniqID,
                      transferModel.result[i]. TaxCode, transferModel.result[i]. Price,transferModel.result[i]. Ammount,
                      transferModel.result[i]. TaxAmt)) ;
            }


          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  NetPrinter(String iPAddress, int pORT, String headerdocno,) async {
    log(iPAddress);
    log(pORT.toString());
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      //print('SDGVIUGSV' + iPAddress + 'pORT' + pORT.toString());
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printDemoReceipt(printer, headerdocno);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: ${e}');
      // TODO
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer,headerdocno) async {
    double TotalTaxAmt = 0;
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,), linesAfter: 1);
    printer.text((sessionbranchname), styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text("OrderDate - " + Edt_WastageDate.text, styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    printer.row([PosColumn(text: 'Wastage Chalan', width: 12, styles: PosStyles(align: PosAlign.center),),]);
    printer.row([
      PosColumn(text: "Wastage No", width: 2, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: headerdocno.toString(), width: 9, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "Transporter Person", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: alterdrivername, width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);

    printer.row([
      PosColumn(text: "Vech No", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: altervechiclename.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);
    printer.row([
      PosColumn(text: "From Location", width: 4, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: sessionbranchname.toString(), width: 7, styles: PosStyles(align: PosAlign.left),),
    ]);


    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'Item', width: 5, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(text: 'Qty', width: 2, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1),),
      PosColumn(text: 'Amt', width: 2, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1),),
      PosColumn(text: 'Tax %', width: 1, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);
    printer.hr(len: 12);
    for (int i = 0; i < secWastagePrintList.length; i++) {
      printer.row(
        [
          PosColumn(text: secWastagePrintList[i].itemName.toString() + "-" + secWastagePrintList[i].uOM.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: secWastagePrintList[i].qty.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: double.parse(secWastagePrintList[i].Price.toString()).round().toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: secWastagePrintList[i].TaxCode.split("@")[1].toString() + "%", width: 1, styles: PosStyles(align: PosAlign.right)),
          PosColumn(text: double.parse(secWastagePrintList[i].Price.toString()).round().toString(),width: 2, styles: PosStyles(align: PosAlign.right)),
        ],
      );
      TotalTaxAmt += double.parse(secWastagePrintList[i].Ammount.toString());
    }

    printer.hr(ch: '=', linesAfter: 1,len: 12);


    printer.row([
      PosColumn(text: 'Total Amt', width: 4, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1),),
      PosColumn(text: ':', width: 2, styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text: 'Rs.', width: 1, styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1,fontType: PosFontType.fontA)),
      PosColumn(text:  TotalTaxAmt.toString(), width: 5, styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);


    List<MyTempTax> SMyTempTax = new List();
    SMyTempTax.clear();

    var set = Set<String>();
    List<WastagePrintList> selected1 = secWastagePrintList.where((element) => set.add(element.TaxCode)).toList();

    for (int i = 0; i < secWastagePrintList.length; i++) {
      for (int j = 0; j < selected1.length; j++) {
        if (i == 0 && j == 0)
          SMyTempTax.add(MyTempTax(secWastagePrintList[i].TaxCode, 0, 0, 0));
        //print("${selected1[j].taxcode} == ${templist[i].taxcode.toString()}");
        if (selected1[j].TaxCode.toString() ==
            secWastagePrintList[i].TaxCode.toString()) if (SMyTempTax.where(
                (element) => element.taxcode == selected1[j].TaxCode).length ==
            0) SMyTempTax.add(MyTempTax(secWastagePrintList[i].TaxCode, 0, 0, 0));
      }
    }
    for (int i = 0; i < secWastagePrintList.length; i++) {
      for (int k = 0; k < SMyTempTax.length; k++)
        if (SMyTempTax[k].taxcode == secWastagePrintList[i].TaxCode) {
          SMyTempTax[k].amt = (double.parse(SMyTempTax[k].amt.toString())+double.parse(secWastagePrintList[i].TaxAmt.toString())).toString();
          SMyTempTax[k].cent = (double.parse(SMyTempTax[k].cent.toString())+double.parse(secWastagePrintList[i].TaxAmt.toString()) / 2).toString();
          SMyTempTax[k].sta = (double.parse(SMyTempTax[k].sta.toString()) + double.parse(secWastagePrintList[i].TaxAmt.toString())/ 2).toString();
        }
    }

    printer.hr(ch: '=', linesAfter: 1);
    log(jsonEncode(SMyTempTax));
    log(0.0.toStringAsFixed(2));
    for (int i = 0; i < SMyTempTax.length; i++) {
      printer.row(
        [
          PosColumn(
            text: SMyTempTax[i].taxcode.toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text:  double.parse(SMyTempTax[i].sta.toString()).toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: double.parse(SMyTempTax[i].cent.toString()).toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right),
          ),
        ],
      );
    }

    printer.feed(2);

    printer.text('Thank you!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('!!! THANKYOU AND PLEASE VISIT AGAIN !!!',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('GST - 33AATFB412B1ZW',styles: PosStyles(align: PosAlign.center, bold: true));
    printer.text('FASSI - ' + sessionContact1,styles: PosStyles(align: PosAlign.center, bold: true));

    printer.feed(1);
    //printer.cut();
    log('OK');
    log(sessionContact1);
    //ChildprintDemoReceipt(printer,headerdocno);
  }
}

class BackendService {
  static Future<List> getSuggestions(String query) async {
    // ignore: deprecated_member_use
    List<ItemFillModel> my = new List();
    if (_WastageEntryState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _WastageEntryState.ItemList.result.length; a++)
        if (_WastageEntryState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _WastageEntryState.ItemList.result[a].itemCode,
              _WastageEntryState.ItemList.result[a].itemName,
              _WastageEntryState.ItemList.result[a].uOM,
              _WastageEntryState.ItemList.result[a].qty,
              _WastageEntryState.ItemList.result[a].taxcode,
              _WastageEntryState.ItemList.result[a].price,
              _WastageEntryState.ItemList.result[a].ammount,));
      return my;
    }
  }
}

class ItemFillModel {
  String ItemCode;
  String ItemName;
  String UOM;
  var Qty;
  var taxcode;
  var price;
  var ammount;

  ItemFillModel(this.ItemCode, this.ItemName, this.UOM, this.Qty,this.taxcode,this.price,this.ammount);
}

class Result {
  String itemCode;
  String itemName;
  String FromWhsCode;
  String FromWhsName;
  String ToWhsCode;
  String ToWhsName;
  String Type;
  String uOM;
  var qty;
  var Resoncode;
  var ResonName;
  var taxcode;
  var price;
  var ammount;
  var taxamt;

  Result(
    this.itemCode,
    this.itemName,
    this.FromWhsCode,
    this.FromWhsName,
    this.ToWhsCode,
    this.ToWhsName,
    this.Type,
    this.uOM,
    this.qty,
    this.Resoncode,
    this.ResonName,
    this.taxcode,
    this.price,
    this.ammount,
    this.taxamt,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FromWhsCode'] = this.FromWhsCode;
    data['FromWhsName'] = this.FromWhsName;
    data['ToWhsCode'] = this.ToWhsCode;
    data['ToWhsName'] = this.ToWhsName;
    data['Type'] = this.Type;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['UOM'] = this.uOM;
    return data;
  }
}

class SendResult {
  String FromWhsCode;
  String FromWhsName;
  String ToWhsCode;
  String ToWhsName;
  String Type;
  String itemCode;
  String itemName;
  var qty;
  String uOM;
  String ReasonCode;
  String ReasonName;
  String Istransfer;
  String UserID;
  String UniqID;
  String TaxCode;
  String Price;
  String Ammount;
  String TaxAmt;

  SendResult(
      this.FromWhsCode,
      this.FromWhsName,
      this.ToWhsCode,
      this.ToWhsName,
      this.Type,
      this.itemCode,
      this.itemName,
      this.qty,
      this.uOM,
      this.ReasonCode,
      this.ReasonName,
      this.Istransfer,
      this.UserID,
      this.UniqID,this.TaxCode,this.Price,this.Ammount,this.TaxAmt);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FromWhsCode'] = this.FromWhsCode;
    data['FromWhsName'] = this.FromWhsName;
    data['ToWhsCode'] = this.ToWhsCode;
    data['ToWhsName'] = this.ToWhsName;
    data['Type'] = this.Type;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['UOM'] = this.uOM;
    data['ReasonCode'] = this.ReasonCode;
    data['ReasonName'] = this.ReasonName;
    data['IsTransfer'] = this.Istransfer;
    data['UserID'] = this.UserID;
    data['UniqID'] = this.UniqID;
    data['TaxCode'] = this.TaxCode;
    data['Price'] = this.Price;
    data['Ammount'] = this.Ammount;
    data['TaxAmt'] = this.TaxAmt;
    return data;
  }
}

class ResultWastegeUpdate {
  String TransferDate;
  String DriverCode;
  String Drivername;
  String VehicleNo;
  String fromWhsCode;
  String fromWhsName;
  String toWhsCode;
  String toWhsName;
  String type;
  String itemCode;
  String itemName;
  var qty;
  String uOM;
  String reasonCode;
  String reasonName;
  int isTransferDocNo;
  int createdBy;

  ResultWastegeUpdate(
      this.TransferDate,
      this.DriverCode,
      this.Drivername,
      this.VehicleNo,
      this.fromWhsCode,
      this.fromWhsName,
      this.toWhsCode,
      this.toWhsName,
      this.type,
      this.itemCode,
      this.itemName,
      this.qty,
      this.uOM,
      this.reasonCode,
      this.reasonName,
      this.isTransferDocNo,
      this.createdBy);

  ResultWastegeUpdate.fromJson(Map<String, dynamic> json) {
    TransferDate = json['WastageEntryDate'];
    DriverCode = json['DriverCode'];
    Drivername = json['DriverName'];
    VehicleNo = json['VehicleNo'];
    fromWhsCode = json['FromWhsCode'];
    fromWhsName = json['FromWhsName'];
    toWhsCode = json['ToWhsCode'];
    toWhsName = json['ToWhsName'];
    type = json['Type'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    qty = json['Qty'];
    uOM = json['UOM'];
    reasonCode = json['ReasonCode'];
    reasonName = json['ReasonName'];
    isTransferDocNo = json['IsTransferDocNo'];
    createdBy = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WastageEntryDate'] = this.TransferDate;
    data['DriverCode'] = this.DriverCode;
    data['DriverName'] = this.Drivername;
    data['VehicleNo'] = this.VehicleNo;
    data['FromWhsCode'] = this.fromWhsCode;
    data['FromWhsName'] = this.fromWhsName;
    data['ToWhsCode'] = this.toWhsCode;
    data['ToWhsName'] = this.toWhsName;
    data['Type'] = this.type;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['UOM'] = this.uOM;
    data['ReasonCode'] = this.reasonCode;
    data['ReasonName'] = this.reasonName;
    data['IsTransferDocNo'] = this.isTransferDocNo;
    data['UserID'] = this.createdBy;
    return data;
  }
}


class MyTempTax {
  var taxcode;
  var amt;
  var sta;
  var cent;
  MyTempTax(this.taxcode, this.amt, this.sta, this.cent);

  Map<String, dynamic> toJson() => {
    'taxcode': taxcode,
    'amt': amt,
    'sta': sta,
    'cent': cent
  };

}

class WastagePrintList {
  int docNo;
  String docDate;
  String fromWhsCode;
  String fromWhsName;
  String toWhsCode;
  String toWhsName;
  String type;
  String itemCode;
  String itemName;
  var qty;
  String uOM;
  String reasonCode;
  String reasonName;
  String isTransfer;
  int createdBy;
  String createdDate;
  var modifiedBy;
  var modifiedDate;
  var UniqID;
  var TaxCode;
  var Price;
  var Ammount;
  var TaxAmt;

  WastagePrintList(
      this.docNo,
        this.docDate,
        this.fromWhsCode,
        this.fromWhsName,
        this.toWhsCode,
        this.toWhsName,
        this.type,
        this.itemCode,
        this.itemName,
        this.qty,
        this.uOM,
        this.reasonCode,
        this.reasonName,
        this.isTransfer,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.UniqID,this.TaxCode,this.Price,this.Ammount,this.TaxAmt);
}
