import 'dart:convert';
import 'dart:io';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Masters/KotSubTable.dart';
import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/KOTBookedModel.dart';
import 'package:bestmummybackery/Model/KOTHeaderDetail.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/Model/StateModel.dart';
import 'package:bestmummybackery/Model/countryModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KOTScreen extends StatefulWidget {
  //int ScreenID = 0;
  String CreationName = "";
  String TableNo = "";
  String SeatNo = "";

  KOTScreen({Key key, this.CreationName, this.TableNo, this.SeatNo})
      : super(key: key);

  @override
  KOTScreenState createState() => KOTScreenState();
}

class KOTScreenState extends State<KOTScreen> {
  bool checkedValue = false;

  bool delstatelayout = false;
  bool delstateplace = false;
  bool delstateremarks = false;
  String colorchange = "";
  List<SalesTempItemResult> templist = new List();
  List<SalesPayment> paymenttemplist = new List();
  List<SalesSendPayment> sendpaymenttemplist = new List();
  List<SalesTempItemResultSend> sendtemplist = new List();

  TextEditingController SearchController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  TextEditingController Edt_Total = new TextEditingController();

  TextEditingController Edt_Advance = new TextEditingController();
  TextEditingController Edt_Balance = new TextEditingController();
  TextEditingController Edt_Delcharge = new TextEditingController();
  TextEditingController Edt_Disc = new TextEditingController();
  TextEditingController Edt_CustCharge = new TextEditingController();
  TextEditingController Edt_Tax = new TextEditingController();
  TextEditingController Edt_Mobile = new TextEditingController();
  TextEditingController Edt_UserLoyalty = new TextEditingController();
  TextEditingController Edt_Loyalty = new TextEditingController();
  var Edt_Adjustment = new TextEditingController();
  TextEditingController BalancePoints = new TextEditingController();
  TextEditingController Edt_Credit = new TextEditingController();
  TextEditingController Edt_CareOf = new TextEditingController();

  TextEditingController BalanceAmount = new TextEditingController();

  TextEditingController DelReceiveAmount = new TextEditingController();

  List<TextEditingController> qtycontroller = new List();
  TextEditingController Edt_PayRemarks = new TextEditingController();
  String selectedDate = "";
  KOTBookedModel bookedmodel;
  var TextClicked;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";

  bool loading = false;
  bool isSelected = false;
  String altersalespersoname = "";
  String altersalespersoncode = "";
  String alterpayment = "Select";

  String search = "";
  double batchcount = 0;
  int onclick = 0;
  OccModel models;

  //DataTableSource datalist;
  var altercountrycode = "";
  var alterstatecode = "";
  var altercareofcode = "";
  var altercareofname = "";
  int updatedocno = 0;
  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  int currentIndex = 0;
  CategoriesModel categoryitem;
  SalesItemModel itemodel;
  EmpModel salespersonmodel;

  List<String> salespersonlist = new List();
  List<String> careoflist = new List();

  int rowcount = 0;

  var batchamount1 = 0;
  var taxamount = 0;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  var DelDateController = new TextEditingController();
  var OccDateController = new TextEditingController();

  OccModel occModel = new OccModel();

  countryModel countryModell = new countryModel();
  StateModel stateModel = new StateModel();

  List<String> loc = new List();
  List<String> occ = new List();

  List<String> countrylist = new List();
  List<String> statelist = new List();

  String alteroccname = "";
  String alterocccode = "";

  String altersalespersonname;
  int settlementisclicked = 0;

  double getvalue = 0;
  bool loyalcheckboxValue = false;
  bool careofcheckboxValue = false;
  KOTHeaderDetail kotheadermodel;
  KOTHeaderDetail kotdetailmodel;
  final pagecontroller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: new AppBar(title: new Text("KOT Order")),
        body: Center(
          child: tablet
              ? PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pagecontroller,
                  onPageChanged: (page) => {print(page.toString())},
                  pageSnapping: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  categoryitem != null
                                      ? Container(
                                          padding: EdgeInsets.all(10),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for (int cat = 0;
                                                    cat <
                                                        categoryitem
                                                            .result.length;
                                                    cat++)
                                                  Container(
                                                    margin: EdgeInsets.all(12),
                                                    child: InkWell(
                                                      onTap: () {
                                                        TextClicked =
                                                            altercategoryName =
                                                                categoryitem
                                                                    .result[cat]
                                                                    .name;
                                                        print(
                                                            "TextClicked${TextClicked}");
                                                        colorchange =
                                                            categoryitem
                                                                .result[cat]
                                                                .code
                                                                .toString();
                                                        onclick = 1;
                                                        altercategoryName =
                                                            categoryitem
                                                                .result[cat]
                                                                .name;
                                                        altercategorycode =
                                                            categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString()
                                                                    .isEmpty
                                                                ? 0
                                                                : categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString();
                                                        print('call THisITEM');
                                                        getdetailitems(
                                                            categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString()
                                                                    .isEmpty
                                                                ? 0
                                                                : categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString(),
                                                            onclick);
                                                        setState(() {});
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          categoryitem
                                                              .result[cat].name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextClicked ==
                                                                  categoryitem
                                                                      .result[
                                                                          cat]
                                                                      .name
                                                              ? TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)
                                                              : TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: height,
                                      width: width,
                                      child: itemodel != null
                                          ? GridView.count(
                                              childAspectRatio: 0.8,
                                              crossAxisCount: 4,
                                              children: [
                                                for (int cat = 0;
                                                    cat <
                                                        itemodel.result.length;
                                                    cat++)
                                                  InkWell(
                                                    onTap: () {
                                                      print(itemodel
                                                          .result[cat].imgUrl);
                                                      //qtycontroller.text = "1";
                                                      // qtycontroller.clear();
                                                      addItemToList(
                                                          itemodel.result[cat]
                                                              .itemCode,
                                                          itemodel.result[cat]
                                                              .itemName,
                                                          itemodel.result[cat]
                                                              .itmsGrpCod,
                                                          itemodel
                                                              .result[cat].uOM,
                                                          itemodel.result[cat]
                                                              .price,
                                                          itemodel.result[cat]
                                                              .amount,
                                                          1,
                                                          itemodel.result[cat]
                                                              .itmsGrpNam,
                                                          itemodel.result[cat]
                                                              .picturName,
                                                          itemodel.result[cat]
                                                              .imgUrl,
                                                          itemodel.result[cat]
                                                              .TaxCode
                                                              .split("@")[1]);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                        elevation: 5,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: itemodel
                                                                              .result[
                                                                                  cat]
                                                                              .imgUrl !=
                                                                          AppConstants.LIVE_URL +
                                                                              'Images/'
                                                                      ? Image
                                                                          .network(
                                                                          itemodel
                                                                              .result[cat]
                                                                              .imgUrl,
                                                                          height:
                                                                              height / 7,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )
                                                                      : CircleAvatar(
                                                                          radius:
                                                                              30.0,
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                              itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45.0),
                                                                            ),
                                                                          )),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        itemodel
                                                                            .result[cat]
                                                                            .itemName,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "Rs.${itemodel.result[cat].price}",
                                                                          style: TextStyle(
                                                                              color: Pallete.mycolor,
                                                                              fontWeight: FontWeight.w800),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  print('ok');
                                                                  print(
                                                                      'FLAGG${itemodel.result[cat].flag}');
                                                                  addfavourite(
                                                                      int.parse(
                                                                          sessionuserID),
                                                                      int.parse(
                                                                          sessionbranchcode),
                                                                      itemodel
                                                                          .result[
                                                                              cat]
                                                                          .itemCode,
                                                                      itemodel.result[cat].flag ==
                                                                              0
                                                                          ? 1
                                                                          : 0,
                                                                      cat,
                                                                      itemodel
                                                                          .result[
                                                                              cat]
                                                                          .itmsGrpCod);
                                                                },
                                                                child: Center(
                                                                  child: itemodel
                                                                              .result[cat]
                                                                              .flag ==
                                                                          0
                                                                      ? Icon(
                                                                          Icons
                                                                              .favorite_border,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              40,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              Colors.blue,
                                                                          size:
                                                                              40,
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            )
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                width: double.infinity / 2,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: TextField(
                                                  controller: editingController,
                                                  autofocus: false,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      search = val;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          search = "";
                                                          editingController
                                                              .clear();
                                                        });
                                                      },
                                                      icon: Icon(Icons.clear),
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: 'Search Item...',
                                                    prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child:
                                                            Icon(Icons.search)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2),
                                        color: Colors.white,
                                        height: height / 1.7,
                                        width: width,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: templist.length == 0
                                                ? Center(
                                                    child: Text('No Data Add!'),
                                                  )
                                                : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    columnSpacing: 30,
                                                    dataRowHeight: 60,
                                                    headingRowColor:
                                                        MaterialStateProperty
                                                            .all(Colors.blue),
                                                    showCheckboxColumn: false,
                                                    columns: const <DataColumn>[
                                                      DataColumn(
                                                        label: Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Item Name',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Qty',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Variance',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Amount',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: templist
                                                        .where((element) => element
                                                            .itemName
                                                            .toLowerCase()
                                                            .contains(search
                                                                .toLowerCase()))
                                                        .map(
                                                          (list) => DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Center(
                                                                    child: Center(
                                                                        child: IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .cancel),
                                                                      color: Colors
                                                                          .red,
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "Pressed");
                                                                        setState(
                                                                            () {
                                                                          templist
                                                                              .remove(list);
                                                                          Fluttertoast.showToast(
                                                                              msg: "Deleted Row");
                                                                          count();
                                                                        });
                                                                      },
                                                                    )),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                    Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 5),
                                                                  child: Text(
                                                                      "${list.itemName}\n \n " +
                                                                          "UOM : ${list.uOM}  " +
                                                                          "Rate : ${list.price}\n",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left),
                                                                )),
                                                                DataCell(
                                                                  Center(
                                                                    child: Card(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          new FloatingActionButton(
                                                                            onPressed:
                                                                                () {
                                                                              print('object');
                                                                              decrement(templist.indexOf(list));
                                                                            },
                                                                            child:
                                                                                new Icon(
                                                                              Icons.remove,
                                                                              color: Colors.black,
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                80,
                                                                            child:
                                                                                Center(
                                                                              child: TextField(
                                                                                // readOnly: list.uOM.contains("kgs") ? false : true,
                                                                                style: TextStyle(fontSize: 20),
                                                                                /*onChanged: (val) {
                                                                                  // if (qtycontroller[templist.indexOf(list)].text.isEmpty) {
                                                                                  // } else {
                                                                                  if (val.isNotEmpty) {
                                                                                    int pos = templist.indexOf(list);

                                                                                    list.qty = double.parse(val.toString());
                                                                                    templist[pos].amount = templist[pos].qty * templist[pos].price;
                                                                                    list.amount = list.qty * list.price;
                                                                                    setState(() {});
                                                                                    // }
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: "Please Enter Qty");
                                                                                  }
                                                                                },*/
                                                                                onSubmitted: (val) {
                                                                                  // if (qtycontroller[templist.indexOf(list)].text.isEmpty) {
                                                                                  // } else {
                                                                                  if (val.isNotEmpty) {
                                                                                    int pos = templist.indexOf(list);

                                                                                    list.qty = double.parse(val.toString());
                                                                                    templist[pos].amount = templist[pos].qty * templist[pos].price;
                                                                                    list.amount = list.qty * list.price;
                                                                                    setState(() {});
                                                                                    // }
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: "Please Enter Qty");
                                                                                  }
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                ),
                                                                                controller: TextEditingController(
                                                                                  text: list.uOM == "Grams" || list.uOM == "Kgs" ? double.parse(list.qty.toString()).toStringAsFixed(2) : list.qty.toString(),
                                                                                ),
                                                                                inputFormatters: list.uOM == "Grams" || list.uOM == "Kgs"
                                                                                    ? <TextInputFormatter>[]
                                                                                    : <TextInputFormatter>[
                                                                                        FilteringTextInputFormatter.digitsOnly,
                                                                                      ],
                                                                                keyboardType: TextInputType.number,
                                                                                enabled: true,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          new FloatingActionButton(
                                                                            onPressed:
                                                                                () {
                                                                              increment(templist.indexOf(list));
                                                                            },
                                                                            child:
                                                                                new Icon(Icons.add, color: Colors.black),
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child:
                                                                          Center(
                                                                              child:
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                        Text(
                                                                            ''.toString(),
                                                                            textAlign: TextAlign.center)
                                                                      ]))),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Center(
                                                                          child: Wrap(
                                                                              direction: Axis.vertical,
                                                                              //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                        Text(
                                                                            double.parse((list.amount).toStringAsFixed(2))
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ]))),
                                                                ),
                                                              ]),
                                                        )
                                                        .toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      DraftMethod(context, height),
                                    ],
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
                                    child: DropdownSearch<String>(
                                      mode: Mode.MENU,
                                      showSearchBox: true,
                                      items: [
                                        "Select",
                                        "Cash",
                                        "Card",
                                        "UPI",
                                        "Other Payment"
                                      ],
                                      label: "Select type Cash/Card",
                                      onChanged: (String val) {
                                        alterpayment = val;
                                      },
                                      selectedItem: alterpayment,
                                      //String alterpayment=items;
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
                                      onChanged: (val) {
                                        setState(() {
                                          try {
                                            double remaining = DelReceiveAmount
                                                    .text.isEmpty
                                                ? 0
                                                : (double.parse(
                                                        DelReceiveAmount.text) -
                                                    double.parse(
                                                        Edt_Total.text));
                                            if (DelReceiveAmount.text.isEmpty) {
                                              Edt_Balance.text = "0.00";
                                            } else {
                                              Edt_Balance.text =
                                                  remaining.toStringAsFixed(2);
                                            }
                                            print(remaining);
                                          } catch (Exception) {}
                                        });
                                      },
                                      controller: DelReceiveAmount,
                                      decoration: InputDecoration(
                                          suffixIconConstraints: BoxConstraints(
                                              minHeight: 30, minWidth: 30),
                                          suffixIcon: Icon(
                                            Icons.cancel,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder()),
                                      onTap: () {
                                        DelReceiveAmount.text = "0.00";
                                        getvalue = 0;
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
                                      controller: Edt_Total,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Bill Amount",
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
                                      readOnly: true,
                                      controller: Edt_Balance,
                                      decoration: InputDecoration(
                                          labelText: "Balance Amount",
                                          border: OutlineInputBorder(),
                                          fillColor: Colors.blue),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
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
                                      enabled: true,
                                      controller: Edt_PayRemarks,
                                      decoration: InputDecoration(
                                        labelText: "Remarks",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade700,
                                    icon: Icon(Icons.check),
                                    label: Text('Add'),
                                    onPressed: () {
                                      if (alterpayment == "Select") {
                                        showDialogboxWarning(
                                            context, "Please Choose card Type");
                                      } else {
                                        setState(() {
                                          paymenttemplist.add(SalesPayment(
                                              alterpayment,
                                              DelReceiveAmount.text,
                                              Edt_Total.text,
                                              Edt_Balance.text,
                                              Edt_PayRemarks.text));
                                          DelReceiveAmount.text = "";
                                          Edt_Balance.text = "";
                                          Edt_PayRemarks.text = "";
                                          alterpayment = "Select";
                                          getvalue = 0;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          height: height / 7,
                                          width: width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Denomination Details')
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RupeesButton(
                                                      context, "2000", 0),
                                                  RupeesButton(
                                                      context, "1000", 0),
                                                  RupeesButton(
                                                      context, "1500", 0),
                                                  RupeesButton(
                                                      context, "500", 1),
                                                  RupeesButton(
                                                      context, "200", 2),
                                                  RupeesButton(
                                                      context, "100", 3),
                                                  RupeesButton(
                                                      context, "50", 4),
                                                  RupeesButton(
                                                      context, "20", 5),
                                                  RupeesButton(
                                                      context, "10", 6),
                                                  RupeesButton(context, "5", 7),
                                                  RupeesButton(context, "2", 8),
                                                  RupeesButton(context, "1", 9),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width,
                                      height: height / 4,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: paymenttemplist.length == 0
                                              ? Center(
                                                  child: Text('No Data Add!'),
                                                )
                                              : DataTable(
                                                  sortColumnIndex: 0,
                                                  sortAscending: true,
                                                  columnSpacing: 30,
                                                  dataRowHeight: 60,
                                                  headingRowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue),
                                                  showCheckboxColumn: false,
                                                  columns: <DataColumn>[
                                                    DataColumn(
                                                      label: Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Type',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Bill Amount',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Received Amount',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Balance Amount',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Remarks',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: paymenttemplist
                                                      .map(
                                                        (list) => DataRow(
                                                            cells: [
                                                              DataCell(
                                                                Center(
                                                                  child: Center(
                                                                      child:
                                                                          IconButton(
                                                                    icon: Icon(Icons
                                                                        .cancel),
                                                                    color: Colors
                                                                        .red,
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          "Pressed");
                                                                      setState(
                                                                          () {
                                                                        paymenttemplist
                                                                            .remove(list);
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Deleted Row");
                                                                        //  count();
                                                                      });
                                                                    },
                                                                  )),
                                                                ),
                                                              ),
                                                              DataCell(Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Text(
                                                                    "${list.PaymentName}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left),
                                                              )),
                                                              DataCell(
                                                                Center(
                                                                    child:
                                                                        Center(
                                                                            child:
                                                                                Wrap(
                                                                                    direction: Axis.vertical,
                                                                                    //default
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                      Text(
                                                                          list.BillAmount
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center)
                                                                    ]))),
                                                              ),
                                                              DataCell(
                                                                Center(
                                                                  child: Center(
                                                                      child:
                                                                          Wrap(
                                                                              direction: Axis.vertical,
                                                                              //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                        Text(
                                                                            list.ReceivedAmount
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ])),
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Center(
                                                                  child: Center(
                                                                      child:
                                                                          Wrap(
                                                                              direction: Axis.vertical,
                                                                              //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                        Text(
                                                                            list.BalAmount
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ])),
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Center(
                                                                  child: Center(
                                                                      child:
                                                                          Wrap(
                                                                              direction: Axis.vertical,
                                                                              //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                        Text(
                                                                            list
                                                                                .PaymentRemarks,
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ])),
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
                                LineSeparator(color: Colors.grey),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Loyalty Points',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Checkbox(
                                                        value:
                                                            loyalcheckboxValue,
                                                        activeColor:
                                                            Colors.blue,
                                                        onChanged:
                                                            (bool newValue) {
                                                          setState(() {
                                                            loyalcheckboxValue =
                                                                newValue;
                                                          });
                                                          Text('');
                                                          print(
                                                              'ONCHANGE$loyalcheckboxValue');
                                                        }),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: TextField(
                                                      enabled: false,
                                                      controller: Edt_Mobile,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Mobile No",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      enabled: false,
                                                      controller: Edt_Loyalty,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "LoyaltyPoints",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      enabled: false,
                                                      controller:
                                                          Edt_Adjustment,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Adjustment",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          Edt_UserLoyalty,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "User Amount",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      enabled: false,
                                                      controller: BalancePoints,
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.grey,
                                                        labelText:
                                                            "Balance Pts",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    LineSeparator(color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Checkbox(
                                                        value:
                                                            careofcheckboxValue,
                                                        activeColor:
                                                            Colors.blue,
                                                        onChanged:
                                                            (bool newValue) {
                                                          setState(() {
                                                            careofcheckboxValue =
                                                                newValue;
                                                          });
                                                          Text('');
                                                          print(
                                                              'ONCHANGE$careofcheckboxValue');
                                                        }),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: TextField(
                                                      enabled: false,
                                                      controller: Edt_Credit,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Credit Amount",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
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
                                                    items: careoflist,
                                                    label: "C/O",
                                                    onChanged: (val) {
                                                      print(val);
                                                      for (int kk = 0;
                                                          kk <
                                                              salespersonmodel
                                                                  .result
                                                                  .length;
                                                          kk++) {
                                                        if (salespersonmodel
                                                                .result[kk]
                                                                .name ==
                                                            val) {
                                                          print(salespersonmodel
                                                              .result[kk]
                                                              .empID);
                                                          altercareofname =
                                                              salespersonmodel
                                                                  .result[kk]
                                                                  .name;
                                                          altercareofcode =
                                                              salespersonmodel
                                                                  .result[kk]
                                                                  .empID
                                                                  .toString();
                                                        }
                                                      }
                                                    },
                                                    selectedItem:
                                                        altercareofname,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    FloatingActionButton.extended(
                                      backgroundColor: Colors.blue.shade700,
                                      icon: Icon(Icons.check),
                                      label: Text('Save'),
                                      onPressed: () {
                                        settlementisclicked = 1;
                                        if (settlementisclicked == 1 &&
                                            paymenttemplist.length == 0) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Enter Payment Details");
                                        } else {
                                          insertSalesHeader(
                                              updatedocno,
                                              formatter.format(DateTime.now()),
                                              Edt_Mobile.text,
                                              formatter.format(DateTime.now()),
                                              alterocccode,
                                              alteroccname,
                                              formatter.format(DateTime.now()),
                                              'Message',
                                              'ShapeCode',
                                              'ShapeName',
                                              checkedValue == true ? "Y" : "N",
                                              Edt_CustCharge.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_CustCharge.text),
                                              Edt_Advance.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Advance.text),
                                              '',
                                              '',
                                              '',
                                              '',
                                              '',
                                              '',
                                              Edt_Delcharge.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Delcharge.text),
                                              batchcount,
                                              Edt_Total.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Total.text),
                                              Edt_Tax.text.isEmpty
                                                  ? 0
                                                  : double.parse(Edt_Tax.text),
                                              Edt_Disc.text.isEmpty
                                                  ? 0
                                                  : double.parse(Edt_Disc.text),
                                              Edt_Balance.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Balance.text),
                                              Edt_Total.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Total.text),
                                              'C',
                                              0,
                                              '',
                                              0,
                                              '',
                                              '',
                                              '',
                                              widget.CreationName.toString(),
                                              widget.TableNo,
                                              widget.SeatNo,
                                              int.parse(sessionuserID),
                                              sessionbranchcode);
                                          Fluttertoast.showToast(msg: "Ok");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pagecontroller,
                  onPageChanged: (page) => {print(page.toString())},
                  pageSnapping: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  categoryitem != null
                                      ? Container(
                                          padding: EdgeInsets.all(10),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for (int cat = 0;
                                                    cat <
                                                        categoryitem
                                                            .result.length;
                                                    cat++)
                                                  Container(
                                                    margin: EdgeInsets.all(12),
                                                    child: InkWell(
                                                      onTap: () {
                                                        TextClicked =
                                                            altercategoryName =
                                                                categoryitem
                                                                    .result[cat]
                                                                    .name;
                                                        print(
                                                            "TextClicked${TextClicked}");
                                                        colorchange =
                                                            categoryitem
                                                                .result[cat]
                                                                .code
                                                                .toString();
                                                        onclick = 1;
                                                        altercategoryName =
                                                            categoryitem
                                                                .result[cat]
                                                                .name;
                                                        altercategorycode =
                                                            categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString()
                                                                    .isEmpty
                                                                ? 0
                                                                : categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString();
                                                        print('call THisITEM');
                                                        getdetailitems(
                                                            categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString()
                                                                    .isEmpty
                                                                ? 0
                                                                : categoryitem
                                                                    .result[cat]
                                                                    .code
                                                                    .toString(),
                                                            onclick);
                                                        setState(() {});
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          categoryitem
                                                              .result[cat].name,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextClicked ==
                                                                  categoryitem
                                                                      .result[
                                                                          cat]
                                                                      .name
                                                              ? TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)
                                                              : TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: height,
                                      width: width,
                                      child: itemodel != null
                                          ? GridView.count(
                                              childAspectRatio: 0.8,
                                              crossAxisCount: 4,
                                              children: [
                                                for (int cat = 0;
                                                    cat <
                                                        itemodel.result.length;
                                                    cat++)
                                                  InkWell(
                                                    onTap: () {
                                                      print(itemodel
                                                          .result[cat].imgUrl);
                                                      //qtycontroller.text = "1";
                                                      // qtycontroller.clear();
                                                      addItemToList(
                                                          itemodel.result[cat]
                                                              .itemCode,
                                                          itemodel.result[cat]
                                                              .itemName,
                                                          itemodel.result[cat]
                                                              .itmsGrpCod,
                                                          itemodel
                                                              .result[cat].uOM,
                                                          itemodel.result[cat]
                                                              .price,
                                                          itemodel.result[cat]
                                                              .amount,
                                                          1,
                                                          itemodel.result[cat]
                                                              .itmsGrpNam,
                                                          itemodel.result[cat]
                                                              .picturName,
                                                          itemodel.result[cat]
                                                              .imgUrl,
                                                          itemodel.result[cat]
                                                              .TaxCode
                                                              .split("@")[1]);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                        elevation: 5,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: itemodel
                                                                              .result[
                                                                                  cat]
                                                                              .imgUrl !=
                                                                          AppConstants.LIVE_URL +
                                                                              'Images/'
                                                                      ? Image
                                                                          .network(
                                                                          itemodel
                                                                              .result[cat]
                                                                              .imgUrl,
                                                                          height:
                                                                              height / 7,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )
                                                                      : CircleAvatar(
                                                                          radius:
                                                                              30.0,
                                                                          backgroundColor: Colors
                                                                              .transparent,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              // itemodel.result[cat].itemName.trim().split(' ').map((l) => l[0]).take(2).join()
                                                                              itemodel.result[cat].itemName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join(),
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45.0),
                                                                            ),
                                                                          )),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        itemodel
                                                                            .result[cat]
                                                                            .itemName,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "Rs.${itemodel.result[cat].price}",
                                                                          style: TextStyle(
                                                                              color: Pallete.mycolor,
                                                                              fontWeight: FontWeight.w800),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  print('ok');
                                                                  print(
                                                                      'FLAGG${itemodel.result[cat].flag}');
                                                                  addfavourite(
                                                                      int.parse(
                                                                          sessionuserID),
                                                                      int.parse(
                                                                          sessionbranchcode),
                                                                      itemodel
                                                                          .result[
                                                                              cat]
                                                                          .itemCode,
                                                                      itemodel.result[cat].flag ==
                                                                              0
                                                                          ? 1
                                                                          : 0,
                                                                      cat,
                                                                      itemodel
                                                                          .result[
                                                                              cat]
                                                                          .itmsGrpCod);
                                                                },
                                                                child: Center(
                                                                  child: itemodel
                                                                              .result[cat]
                                                                              .flag ==
                                                                          0
                                                                      ? Icon(
                                                                          Icons
                                                                              .favorite_border,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              40,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              Colors.blue,
                                                                          size:
                                                                              40,
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            )
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                width: double.infinity / 2,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: TextField(
                                                  controller: editingController,
                                                  autofocus: false,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      search = val;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          search = "";
                                                          editingController
                                                              .clear();
                                                        });
                                                      },
                                                      icon: Icon(Icons.clear),
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: 'Search Item...',
                                                    prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child:
                                                            Icon(Icons.search)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                showSearchBox: true,
                                                items: salespersonlist,
                                                label: "Sales Person",
                                                onChanged: (val) {
                                                  print(val);
                                                  for (int kk = 0;
                                                      kk <
                                                          salespersonmodel
                                                              .result.length;
                                                      kk++) {
                                                    if (salespersonmodel
                                                            .result[kk].name ==
                                                        val) {
                                                      print(salespersonmodel
                                                          .result[kk].empID);
                                                      altersalespersoname =
                                                          salespersonmodel
                                                              .result[kk].name;
                                                      altersalespersoncode =
                                                          salespersonmodel
                                                              .result[kk].empID
                                                              .toString();
                                                    }
                                                  }
                                                },
                                                selectedItem:
                                                    altersalespersoname,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2),
                                        color: Colors.white,
                                        height: height * 0.4,
                                        width: width,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: templist.length == 0
                                                ? Center(
                                                    child: Text('No Data Add!'),
                                                  )
                                                : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    columnSpacing: 30,
                                                    dataRowHeight: 60,
                                                    headingRowColor:
                                                        MaterialStateProperty
                                                            .all(Colors.blue),
                                                    showCheckboxColumn: false,
                                                    columns: const <DataColumn>[
                                                      DataColumn(
                                                        label: Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Item Name',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Qty',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Variance',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Amount',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: templist
                                                        .where((element) => element
                                                            .itemName
                                                            .toLowerCase()
                                                            .contains(search
                                                                .toLowerCase()))
                                                        .map(
                                                          (list) => DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Center(
                                                                    child: Center(
                                                                        child: IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .cancel),
                                                                      color: Colors
                                                                          .red,
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "Pressed");
                                                                        setState(
                                                                            () {
                                                                          templist
                                                                              .remove(list);
                                                                          Fluttertoast.showToast(
                                                                              msg: "Deleted Row");
                                                                          count();
                                                                        });
                                                                      },
                                                                    )),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                    Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 5),
                                                                  child: Text(
                                                                      "${list.itemName}\n \n " +
                                                                          "UOM : ${list.uOM}  " +
                                                                          "Rate : ${list.price}\n",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left),
                                                                )),
                                                                DataCell(
                                                                  Center(
                                                                    child: Card(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          new FloatingActionButton(
                                                                            onPressed:
                                                                                () {
                                                                              print('object');
                                                                              decrement(templist.indexOf(list));
                                                                            },
                                                                            child:
                                                                                new Icon(
                                                                              Icons.remove,
                                                                              color: Colors.black,
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                50,
                                                                            child:
                                                                                Center(
                                                                              child: TextField(
                                                                                readOnly: list.uOM.contains("kgs") ? false : true,
                                                                                style: TextStyle(fontSize: 20),
                                                                                onChanged: (val) {
                                                                                  if (qtycontroller[templist.indexOf(list)].text.isEmpty) {
                                                                                  } else {
                                                                                    int pos = templist.indexOf(list);

                                                                                    list.qty = double.parse(val.toString());
                                                                                    templist[pos].amount = templist[pos].qty * templist[pos].price;
                                                                                    list.amount = list.qty * list.price;
                                                                                    setState(() {});
                                                                                  }
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(),
                                                                                ),
                                                                                controller: TextEditingController(text: list.qty.toString()),
                                                                                inputFormatters: <TextInputFormatter>[
                                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                                ],
                                                                                keyboardType: TextInputType.number,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          new FloatingActionButton(
                                                                            onPressed:
                                                                                () {
                                                                              increment(templist.indexOf(list));
                                                                            },
                                                                            child:
                                                                                new Icon(Icons.add, color: Colors.black),
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child:
                                                                          Center(
                                                                              child:
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                        Text(
                                                                            ''.toString(),
                                                                            textAlign: TextAlign.center)
                                                                      ]))),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Center(
                                                                          child: Wrap(
                                                                              direction: Axis.vertical,
                                                                              //default
                                                                              alignment: WrapAlignment.center,
                                                                              children: [
                                                                        Text(
                                                                            double.parse((list.amount).toStringAsFixed(2))
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ]))),
                                                                ),
                                                              ]),
                                                        )
                                                        .toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      DraftMethod(context, height),
                                    ],
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
                                    child: DropdownSearch<String>(
                                      mode: Mode.MENU,
                                      showSearchBox: true,
                                      //list of dropdown items
                                      items: [
                                        "Select",
                                        "Cash",
                                        "Card",
                                        "UPI",
                                        "Other Payment"
                                      ],
                                      label: "Select type Cash/Card",
                                      onChanged: (String val) {
                                        alterpayment = val;
                                      },
                                      selectedItem: "Select",
                                      //String alterpayment=items;
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
                                      onChanged: (val) {
                                        setState(() {
                                          try {
                                            double remaining = DelReceiveAmount
                                                    .text.isEmpty
                                                ? 0
                                                : (double.parse(
                                                        DelReceiveAmount.text) -
                                                    double.parse(
                                                        Edt_Total.text));
                                            if (DelReceiveAmount.text.isEmpty) {
                                              Edt_Balance.text = "0.00";
                                            } else {
                                              Edt_Balance.text =
                                                  remaining.toStringAsFixed(2);
                                            }
                                            print(remaining);
                                          } catch (Exception) {}
                                        });
                                      },
                                      controller: DelReceiveAmount,
                                      decoration: InputDecoration(
                                          suffixIconConstraints: BoxConstraints(
                                              minHeight: 30, minWidth: 30),
                                          suffixIcon: Icon(
                                            Icons.cancel,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder()),
                                      onTap: () {
                                        DelReceiveAmount.text = "0.00";
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
                                      controller: Edt_Total,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Bill Amount",
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
                                      readOnly: true,
                                      controller: Edt_Balance,
                                      decoration: InputDecoration(
                                          labelText: "Balance Amount",
                                          border: OutlineInputBorder(),
                                          fillColor: Colors.blue),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
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
                                      enabled: true,
                                      controller: Edt_PayRemarks,
                                      decoration: InputDecoration(
                                        labelText: "Remarks",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade700,
                                    icon: Icon(Icons.check),
                                    label: Text('Add'),
                                    onPressed: () {
                                      if (alterpayment.isEmpty) {
                                        showDialogboxWarning(context,
                                            "Payment Type Should not left Empty!");
                                      } else {
                                        paymenttemplist.add(SalesPayment(
                                            alterpayment,
                                            DelReceiveAmount.text,
                                            Edt_Total.text,
                                            Edt_Balance.text,
                                            Edt_PayRemarks.text));
                                        DelReceiveAmount.text = "";
                                        Edt_Balance.text = "";
                                        Edt_PayRemarks.text = "";
                                        alterpayment = "Select";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Denomination Details')
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RupeesButton(
                                                      context, "2000", 0),
                                                  RupeesButton(
                                                      context, "1000", 0),
                                                  RupeesButton(
                                                      context, "1500", 0),
                                                  RupeesButton(
                                                      context, "500", 1),
                                                  RupeesButton(
                                                      context, "200", 2),
                                                  RupeesButton(
                                                      context, "100", 3),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RupeesButton(
                                                      context, "50", 4),
                                                  RupeesButton(
                                                      context, "20", 5),
                                                  RupeesButton(
                                                      context, "10", 6),
                                                  RupeesButton(context, "5", 7),
                                                  RupeesButton(context, "2", 8),
                                                  RupeesButton(context, "1", 9),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: height / 2,
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: paymenttemplist.length == 0
                                                ? Center(
                                                    child: Text('No Data Add!'),
                                                  )
                                                : DataTable(
                                                    sortColumnIndex: 0,
                                                    sortAscending: true,
                                                    columnSpacing: 30,
                                                    dataRowHeight: 60,
                                                    headingRowColor:
                                                        MaterialStateProperty
                                                            .all(Colors.blue),
                                                    showCheckboxColumn: false,
                                                    columns: <DataColumn>[
                                                      DataColumn(
                                                        label: Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Type',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Bill Amount',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Received Amount',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Balance Amount',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'Remarks',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: paymenttemplist
                                                        .map(
                                                          (list) => DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Center(
                                                                    child: Center(
                                                                        child: IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .cancel),
                                                                      color: Colors
                                                                          .red,
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            "Pressed");
                                                                        setState(
                                                                            () {
                                                                          paymenttemplist
                                                                              .remove(list);
                                                                          Fluttertoast.showToast(
                                                                              msg: "Deleted Row");
                                                                          //  count();
                                                                        });
                                                                      },
                                                                    )),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                    Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 5),
                                                                  child: Text(
                                                                      "${list.PaymentName}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left),
                                                                )),
                                                                DataCell(
                                                                  Center(
                                                                      child:
                                                                          Center(
                                                                              child:
                                                                                  Wrap(
                                                                                      direction: Axis.vertical,
                                                                                      //default
                                                                                      alignment: WrapAlignment.center,
                                                                                      children: [
                                                                        Text(
                                                                            list.BillAmount
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.center)
                                                                      ]))),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child:
                                                                        Center(
                                                                            child:
                                                                                Wrap(
                                                                                    direction: Axis.vertical,
                                                                                    //default
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                          Text(
                                                                              list.ReceivedAmount.toString(),
                                                                              textAlign: TextAlign.center)
                                                                        ])),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child:
                                                                        Center(
                                                                            child:
                                                                                Wrap(
                                                                                    direction: Axis.vertical,
                                                                                    //default
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                          Text(
                                                                              list.BalAmount.toString(),
                                                                              textAlign: TextAlign.center)
                                                                        ])),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child:
                                                                        Center(
                                                                            child:
                                                                                Wrap(
                                                                                    direction: Axis.vertical,
                                                                                    //default
                                                                                    alignment: WrapAlignment.center,
                                                                                    children: [
                                                                          Text(
                                                                              list.PaymentRemarks,
                                                                              textAlign: TextAlign.center)
                                                                        ])),
                                                                  ),
                                                                ),
                                                              ]),
                                                        )
                                                        .toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                LineSeparator(color: Colors.grey),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Loyalty Points',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Checkbox(
                                                        value:
                                                            loyalcheckboxValue,
                                                        activeColor:
                                                            Colors.blue,
                                                        onChanged:
                                                            (bool newValue) {
                                                          setState(() {
                                                            loyalcheckboxValue =
                                                                newValue;
                                                          });
                                                          Text('');
                                                          print(
                                                              'ONCHANGE$loyalcheckboxValue');
                                                        }),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: TextField(
                                                      enabled: false,
                                                      controller: Edt_Mobile,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Mobile No",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      enabled: false,
                                                      controller: Edt_Loyalty,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "LoyaltyPoints",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      enabled: false,
                                                      controller:
                                                          Edt_Adjustment,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Adjustment",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          Edt_UserLoyalty,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "User Amount",
                                                        border:
                                                            OutlineInputBorder(),
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
                                                      enabled: false,
                                                      controller: BalancePoints,
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.grey,
                                                        labelText:
                                                            "Balance Pts",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    LineSeparator(color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Checkbox(
                                                        value:
                                                            careofcheckboxValue,
                                                        activeColor:
                                                            Colors.blue,
                                                        onChanged:
                                                            (bool newValue) {
                                                          setState(() {
                                                            careofcheckboxValue =
                                                                newValue;
                                                          });
                                                          Text('');
                                                          print(
                                                              'ONCHANGE$careofcheckboxValue');
                                                        }),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    child: TextField(
                                                      enabled: false,
                                                      controller: Edt_Credit,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Credit Amount",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
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
                                                    items: careoflist,
                                                    label: "C/O",
                                                    onChanged: (val) {
                                                      print(val);
                                                      for (int kk = 0;
                                                          kk <
                                                              salespersonmodel
                                                                  .result
                                                                  .length;
                                                          kk++) {
                                                        if (salespersonmodel
                                                                .result[kk]
                                                                .name ==
                                                            val) {
                                                          print(salespersonmodel
                                                              .result[kk]
                                                              .empID);
                                                          altercareofname =
                                                              salespersonmodel
                                                                  .result[kk]
                                                                  .name;
                                                          altercareofcode =
                                                              salespersonmodel
                                                                  .result[kk]
                                                                  .empID
                                                                  .toString();
                                                        }
                                                      }
                                                    },
                                                    selectedItem:
                                                        altercareofname,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ElevatedButton(
                                      child: Text(
                                        "Save",
                                      ),
                                      onPressed: () {
                                        settlementisclicked = 1;
                                        if (altersalespersoncode.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Choose Sales Person");
                                        } else if (settlementisclicked == 1 &&
                                            paymenttemplist.length == 0) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Enter Payment Details");
                                        } else {
                                          insertSalesHeader(
                                              updatedocno,
                                              formatter.format(DateTime.now()),
                                              Edt_Mobile.text,
                                              formatter.format(DateTime.now()),
                                              alterocccode,
                                              alteroccname,
                                              formatter.format(DateTime.now()),
                                              'Message',
                                              'ShapeCode',
                                              'ShapeName',
                                              checkedValue == true ? "Y" : "N",
                                              Edt_CustCharge.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_CustCharge.text),
                                              Edt_Advance.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Advance.text),
                                              '',
                                              '',
                                              '',
                                              '',
                                              '',
                                              '',
                                              Edt_Delcharge.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Delcharge.text),
                                              batchcount,
                                              Edt_Total.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Total.text),
                                              Edt_Tax.text.isEmpty
                                                  ? 0
                                                  : double.parse(Edt_Tax.text),
                                              Edt_Disc.text.isEmpty
                                                  ? 0
                                                  : double.parse(Edt_Disc.text),
                                              Edt_Balance.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Balance.text),
                                              Edt_Total.text.isEmpty
                                                  ? 0
                                                  : double.parse(
                                                      Edt_Total.text),
                                              'C',
                                              0,
                                              '',
                                              0,
                                              '',
                                              '',
                                              '',
                                              widget.CreationName,
                                              widget.TableNo,
                                              widget.SeatNo,
                                              int.parse(sessionuserID),
                                              sessionbranchcode);
                                          Fluttertoast.showToast(msg: "Ok");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  bool onWillPop() {
    /* print(pagecontroller.);
    if (pagecontroller.initialPage == 1)
      return true;
    else if (pagecontroller.initialPage == 2)
      return true;
    else if (pagecontroller.initialPage == 0) return false;*/
    print(pagecontroller.initialPage);
    print(pagecontroller.page.round());
    if (pagecontroller.initialPage == 0 && pagecontroller.page.round() == 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Are you sure you want to go Back?'),
                  actions: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KOTSubTable(
                                      CreationName: widget.CreationName,
                                      TableNo: widget.TableNo)));
                        }),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ]));
      return true;
    } else {
      pagecontroller.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  Widget DraftMethod(BuildContext context, double height) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      height: height * 0.5,
      child: Column(
        children: [
          Row(
            children: [
              new Expanded(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  child: new TextField(
                    controller: Edt_Mobile,
                    onSubmitted: (value) {
                      print("Onsubmit,${value}");
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cus.MobileNo",
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
              FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                icon: Icon(Icons.print),
                label: Text('Print & Settlement'),
                onPressed: () {
                  if (Edt_Total.text.isEmpty) {
                    showDialogboxWarning(
                        context, "Total Should Not Left Empty!");
                  } else {
                    pagecontroller.jumpToPage(2);
                    getoccation(
                        int.parse(sessionuserID), int.parse(sessionbranchcode));
                    getstate(2, sessionuserID);
                    getcountry(1, sessionuserID);
                  }
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
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 5,
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                icon: Icon(Icons.check),
                label: Text('ADD to KOT'),
                onPressed: () {
                  if (Edt_Total.text.isEmpty) {
                    showDialogboxWarning(
                        context, "Please Enter Atleaset 1 Qty!");
                  } else {
                    insertSalesHeader(
                        updatedocno,
                        formatter.format(DateTime.now()),
                        Edt_Mobile.text,
                        formatter.format(DateTime.now()),
                        '',
                        //OccCode
                        '',
                        //OccName
                        formatter.format(DateTime.now()),
                        '',
                        //Message
                        '',
                        //ShapeCode
                        '',
                        //ShapeName
                        'N',
                        Edt_CustCharge.text.isEmpty
                            ? 0
                            : double.parse(Edt_CustCharge.text),
                        Edt_Advance.text.isEmpty
                            ? 0
                            : double.parse(Edt_Advance.text),
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        Edt_Delcharge.text.isEmpty
                            ? 0
                            : double.parse(Edt_Delcharge.text),
                        batchcount,
                        Edt_Total.text.isEmpty
                            ? 0
                            : double.parse(Edt_Total.text),
                        Edt_Tax.text.isEmpty ? 0 : double.parse(Edt_Tax.text),
                        Edt_Disc.text.isEmpty ? 0 : double.parse(Edt_Disc.text),
                        Edt_Balance.text.isEmpty
                            ? 0
                            : double.parse(Edt_Balance.text),
                        Edt_Total.text.isEmpty
                            ? 0
                            : double.parse(Edt_Total.text),
                        'D',
                        0,
                        '',
                        0,
                        '',
                        '',
                        '',
                        widget.CreationName,
                        widget.TableNo,
                        widget.SeatNo,
                        int.parse(sessionuserID),
                        sessionbranchcode);
                  }
                },
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget RupeesButton(BuildContext context, String Name, int Position) {
    return ElevatedButton(
        onPressed: () {
          _onClick(Name);
        },
        child: Text(Name));
  }

  void _onClick(String value) {
    print(value);

    getvalue += double.parse(value);
    print(getvalue);
    DelReceiveAmount.text = "";
    DelReceiveAmount.text = getvalue.toStringAsFixed(2);
    double remaining = DelReceiveAmount.text.isEmpty
        ? 0
        : (double.parse(DelReceiveAmount.text) - double.parse(Edt_Total.text));
    if (DelReceiveAmount.text.isEmpty) {
      Edt_Balance.text = "0.00";
    } else {
      Edt_Balance.text = remaining.toStringAsFixed(2);
    }
  }

  void addpaymentDatatble(String alterpayment, String ReceiveAmount,
      String Bill, String Balance, String Remarks) {
    int count = 0;
    setState(() {
      paymenttemplist.add(
          SalesPayment(alterpayment, ReceiveAmount, Bill, Balance, Remarks));
      DelReceiveAmount.text = "";
      Edt_Total.text = "";
      BalanceAmount.text = "";
      Edt_PayRemarks.text = "";
    });
  }

  void decrement(int index) {
    setState(() {
      if (double.parse(templist[index].qty.toString()) <= 1) {
        Fluttertoast.showToast(msg: "You Cannot put less than 0");
        return;
      } else {
        templist[index].qty--;
        double qq = double.parse(templist[index].qty.toString());
        templist[index].amount = templist[index].qty * templist[index].price;
        /* qtycontroller.text = templist[index].qty--;*/
        //qtycontroller[index].text = qq.toString();
        count();
      }
    });
  }

  void increment(int index) {
    setState(() {
      if (double.parse(templist[index].qty.toString()) == 100) {
        Fluttertoast.showToast(msg: "You Cannot more than 100 Qty");
      } else {
        templist[index].qty++;
        double qq = double.parse(templist[index].qty.toString());
        templist[index].amount = templist[index].qty * templist[index].price;
        //  qtycontroller[index].text = qq.toString();
        count();
      }
    });
  }

  void count() async {
    setState(() {
      batchcount = 0;
      var batchamount = 0;
      batchamount1 = 0;
      taxamount = 0;
      var taxamount1 = 0;

      Edt_Total.text = '';
      for (int s = 0; s < templist.length; s++) {
        if (templist[s].qty > 0) {
          batchcount++;
          batchamount += templist[s].amount.toInt();
          batchamount1 = batchamount;

          print('TAX${templist[s].tax}');
          taxamount1 += int.parse(templist[s].tax).toInt();
          taxamount = taxamount1;
        }
      }
      Edt_Balance.text = batchamount1.toStringAsFixed(2).toString();

      if (Edt_Disc.text.isNotEmpty) {
        Edt_Balance.text =
            (double.parse(Edt_Balance.text) - double.parse(Edt_Disc.text))
                .toString();
      }
      if (Edt_Advance.text.isNotEmpty) {
        Edt_Balance.text =
            (double.parse(Edt_Balance.text) - double.parse(Edt_Advance.text))
                .toString();
      }

      Edt_Total.text = batchamount1.toStringAsFixed(2).toString();
      Edt_Balance.text = batchamount1.toStringAsFixed(2).toString();
      Edt_Tax.text = taxamount.toStringAsFixed(2);

      Edt_Total.text =
          (batchamount1 + (batchamount1 * taxamount) / 100).toStringAsFixed(2);
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
      print('USERID$sessionuserID');
      isbookingexists();
    });
  }

  void getcategories() {
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
              getdetailitems("0", 0);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void addfavourite(int sessionuserID, int BRANCH, String ItemCode, int FLAG,
      int Pos, int itmsGrpCod) {
    print(ItemCode);
    setState(() {
      loading = true;
    });
    AddFavourite(sessionuserID, BRANCH, ItemCode, FLAG).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print(jsonDecode(response.body));

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
            /*var nodata =
                jsonDecode(response.body)['status'] == "Updated";
            if (nodata == true) {

            } else {
              itemodel.result[Pos].flag = 0;
            }*/
            print('FLAG${FLAG}');

            if (itmsGrpCod == 0) {
              itemodel.result[Pos].flag = FLAG;
            } else {
              itemodel.result[Pos].flag = FLAG;
              getdetailitems(itmsGrpCod.toString(), 0);
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
    setState(() {
      loading = true;
    });
    GetAllCategories(2, int.parse(sessionuserID), sessionbranchcode,
            onclick == 0 ? '0' : groupcode)
        .then((response) {
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
          itemodel.result.clear();
        } else {
          setState(() {
            itemodel = SalesItemModel.fromJson(jsonDecode(response.body));

            /* salesPersonget(
                int.parse(sessionuserID), int.parse(sessionbranchcode));*/
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
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
            careoflist.clear();
            salespersonlist.clear();

            for (int k = 0; k < salespersonmodel.result.length; k++) {
              salespersonlist.add(salespersonmodel.result[k].name);
              careoflist.add(salespersonmodel.result[k].name);
            }
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void insertSalesHeader(
      int OrderNo,
      String OrderDate,
      String CustomerNo,
      String DelDate,
      String OccCode,
      String OccName,
      String OccDate,
      String Message,
      String ShapeCode,
      String ShapeName,
      String DoorDelivery,
      double CustCharge,
      double AdvanceAmount,
      String DelStateCode,
      String DelStateName,
      String DelDistCode,
      String DelDistName,
      String DelPlaceCode,
      String DelPlaceName,
      double DelCharge,
      double TotQty,
      double TotAmount,
      double TaxAmount,
      double ReqDiscount,
      double BalanceDue,
      double OverallAmount,
      String OrderStatus,
      int ApproverID,
      String ApproverName,
      double ApprovedDiscount,
      String ApprovedStatus,
      String ApprovedRemarks1,
      String ApprovedRemarks2,
      String CreationName,
      String TableNo,
      String SeatNo,
      int UserID,
      String BranchID) {
    setState(() {
      loading = true;
    });
    InsertKOTOrder(
            OrderNo,
            OrderDate,
            CustomerNo,
            DelDate,
            OccCode,
            OccName,
            OccDate,
            Message,
            ShapeCode,
            ShapeName,
            DoorDelivery,
            CustCharge == null ? 0 : CustCharge,
            AdvanceAmount == null ? 0 : AdvanceAmount,
            DelStateCode,
            DelStateName,
            DelDistCode,
            DelDistName,
            DelPlaceCode,
            DelPlaceName,
            DelCharge,
            TotQty,
            TotAmount,
            TaxAmount,
            ReqDiscount,
            BalanceDue,
            OverallAmount,
            OrderStatus,
            ApproverID,
            ApproverName,
            ApprovedDiscount,
            ApprovedStatus,
            ApprovedRemarks1,
            ApprovedRemarks2,
            CreationName,
            TableNo,
            SeatNo,
            UserID,
            BranchID)
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;
        print(response.body);
        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "Insert Failed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'][0]['DocNo'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          insertkotdetails(jsonDecode(response.body)['result'][0]['DocNo']);
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> insertkotdetails(int headerdocno) async {
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
    });
    for (int i = 0; i < templist.length; i++)
      sendtemplist.add(SalesTempItemResultSend(
          headerdocno,
          altercategorycode.isEmpty ? "0" : altercategorycode,
          altercategoryName.isEmpty ? "" : altercategoryName,
          templist[i].itemCode,
          templist[i].itemName,
          templist[i].itmsGrpCod,
          templist[i].itmsGrpNam,
          templist[i].uOM,
          templist[i].qty,
          templist[i].price,
          templist[i].price * templist[i].qty,
          widget.CreationName,
          widget.TableNo,
          widget.SeatNo,
          '',
          templist[i].picturName,
          templist[i].imgUrl,
          '${sessionuserID}',
          0));
    print(json.encode(sendtemplist));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertKOTDetail'),
        body: jsonEncode(sendtemplist),
        headers: headers);

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
          print('PAYMENTLENGTH${paymenttemplist.length}');
          if (paymenttemplist.length == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => KOTSubTable(
                        CreationName: widget.CreationName,
                        TableNo: widget.TableNo)));
            //Navigator.pop(context, false);
          } else {
            print('ENTER THIRD$settlementisclicked');
            insertKOTpayment(headerdocno);
          }
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> insertKOTpayment(int headerdocno) async {
    var headers = {"Content-Type": "application/json"};
    print(headerdocno);
    setState(() {
      loading = true;
    });
    for (int i = 0; i < paymenttemplist.length; i++)
      sendpaymenttemplist.add(SalesSendPayment(
          headerdocno,
          0,
          paymenttemplist[i].PaymentName,
          paymenttemplist[i].BillAmount,
          paymenttemplist[i].ReceivedAmount,
          paymenttemplist[i].BalAmount,
          paymenttemplist[i].PaymentRemarks,
          '',
          'C',
          widget.CreationName,
          widget.TableNo,
          widget.SeatNo,
          '${sessionuserID}'));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertKOTPayment'),
        body: jsonEncode(sendpaymenttemplist),
        headers: headers);

    setState(() {
      loading = false;
    });

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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => KOTScreen(
                    CreationName: widget.CreationName,
                    TableNo: widget.TableNo,
                    SeatNo: widget.SeatNo)));
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future getcountry(int formID, String UserID) {
    GETCOUNTRYAPI(formID, UserID).then((response) {
      print(response.body);
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
          countryModell.result.clear();
        } else {
          countryModell = countryModel.fromJson(jsonDecode(response.body));
          countrylist.clear();
          for (int k = 0; k < countryModell.result.length; k++) {
            countrylist.add(countryModell.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future getstate(int formID, String UserID) {
    GETCOUNTRYAPI(formID, UserID).then((response) {
      print(response.body);
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
          stateModel.result.clear();
        } else {
          stateModel = StateModel.fromJson(jsonDecode(response.body));
          statelist.clear();
          for (int k = 0; k < stateModel.result.length; k++) {
            statelist.add(stateModel.result[k].name);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

/*
  Future<bool> _onBackPressed() {
    print(pagecontroller.position);
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to Goback?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
*/

  Future getoccation(int UserID, int BranchID) {
    GETOCCATIONAPI(UserID, BranchID).then((response) {
      print(response.body);
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
          occModel.result.clear();
        } else {
          occModel = OccModel.fromJson(jsonDecode(response.body));
          occ.clear();
          for (int k = 0; k < occModel.result.length; k++) {
            occ.add(occModel.result[k].occName);
          }
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future additem(
      int FormID,
      int docno,
      int catcode,
      String catname,
      String itemCode,
      String itemName,
      String ItemGroupCode,
      String UOM,
      var Qty,
      double Price,
      double Total,
      int UserID,
      String PictureName,
      String PictureURL) {
    // setState(() {
    //   loading = true;
    // });
    InsertAddtoCart(
            FormID,
            docno,
            catcode,
            catname,
            itemCode,
            itemName,
            ItemGroupCode,
            UOM,
            Qty,
            Price,
            Total,
            sessionuserID,
            PictureName,
            PictureURL)
        .then((response) {
      print(response.body);
      // setState(() {
      //   loading = false;
      // });
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
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<String> fetchData() async {
    final String uri = AppConstants.LIVE_URL + "getOSRDOccation";
    List data = List();
    var response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var res = await http
          .get(Uri.parse(uri), headers: {"Accept": "application/json"});

      var resBody = json.decode(res.body);

      print('Loaded Successfully' + resBody);

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  void addItemToList(
      String itemCode,
      String itemName,
      int itmsGrpCod,
      String uOM,
      var price,
      var amount,
      var qty,
      String itmsGrpNam,
      String picturName,
      String imgUrl,
      var tax) {
    var countt = 0;

    for (int i = 0; i < templist.length; i++) {
      if (templist[i].itemCode == itemCode) countt++;
    }
    if (countt == 0) {
      templist.add(SalesTempItemResult(itemCode, itemName, itmsGrpCod, uOM,
          price, amount, qty, itmsGrpNam, picturName, imgUrl, tax));

      /*for (var i = 0; i < templist.length / 2; i++) {
        var temp = templist[i];
        templist[i] = templist[templist.length - 1 - i];
        templist[templist.length - 1 - i] = temp;
      }*/
      /*searchablelist.add(SalesTempItemResultSearch(
          itemCode,
          itemName,
          itmsGrpCod,
          uOM,
          price,
          amount,
          qty,
          itmsGrpNam,
          picturName,
          imgUrl,
          tax));*/

      setState(() {});
    } else {
      Fluttertoast.showToast(msg: itemName + "Item Already Exists");
    }
    count();
  }

  Future<http.Response> isbookingexists() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });

    var body = {
      "CreationName": widget.CreationName,
      "TableNo": widget.TableNo,
      "BranchID": sessionbranchcode,
      "SeatNo": widget.SeatNo
    };
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getIsTableBooked1'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        getcategories();
      } else {
        setState(() {
          updatedocno = jsonDecode(response.body)["result"][0]["OrderNo"];
          print('updatedocno' + updatedocno.toString());

          headerdetails();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> headerdetails() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });

    var body = {"OrderNo": updatedocno};
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getKOTHeaderandDetails'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["Header"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        getcategories();
      } else {
        setState(() {
          // updatedocno = jsonDecode(response.body)["result"][0]["OrderNo"];
          //print('updatedocno' + updatedocno.toString());

          kotheadermodel = KOTHeaderDetail.fromJson(json.decode(response.body));

          Edt_Mobile.text = '';
          Edt_Mobile.text = kotheadermodel.header[0].customerNo.toString();
          Edt_Total.text = kotheadermodel.header[0].totAmount.toString();
          Edt_Advance.text = kotheadermodel.header[0].advanceAmount.toString();
          Edt_Balance.text = kotheadermodel.header[0].balanceDue.toString();
          Edt_Delcharge.text = kotheadermodel.header[0].delCharge.toString();
          Edt_Disc.text = kotheadermodel.header[0].reqDiscount.toString();
          Edt_CustCharge.text = kotheadermodel.header[0].custCharge.toString();
          Edt_Tax.text = kotheadermodel.header[0].taxAmount.toString();

          print('TAX${kotheadermodel.header[0].taxAmount}');

          for (int k = 0; k < kotheadermodel.detail.length; k++) {
            templist.add(SalesTempItemResult(
                kotheadermodel.detail[k].itemCode,
                kotheadermodel.detail[k].itemName,
                kotheadermodel.detail[k].itemGroupCode.toString() == null
                    ? 0
                    : 1,
                kotheadermodel.detail[k].uom,
                kotheadermodel.detail[k].price,
                kotheadermodel.detail[k].total,
                kotheadermodel.detail[k].qty,
                kotheadermodel.detail[k].itemGroupCode,
                kotheadermodel.detail[k].pictureName,
                kotheadermodel.detail[k].pictureURL,
                kotheadermodel.header[0].taxAmount.toString()));
          }
          getcategories();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
}

/*
class MyData extends DataTableSource {
  bool get isRowCountApproximate => false;

  int get rowCount => KOTScreenState._data1.length;

  int get selectedRowCount => 0;

  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(KOTScreenState._data1[index].itemName)),
      // DataCell(Text(KOTScreenState._data1[index].qty.toString())),
      DataCell(
        Center(
          child: Card(
            child: Row(
              children: [
                new FloatingActionButton(
                  onPressed: () {
                    print('object');
                    KOTScreenState._data1[index].qty++;
                  },
                  child: new Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                ),
                new Text(KOTScreenState._data1[index].qty.toString(),
                    style: new TextStyle(fontSize: 20.0)),
                new FloatingActionButton(
                  onPressed: () {
                    KOTScreenState._data1[index].qty--;
                  },
                  child: new Icon(Icons.remove, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      DataCell(Text(KOTScreenState._data1[index].uOM.toString())),
      DataCell(Text('')),
      DataCell(Text(KOTScreenState._data1[index].price.toString())),
      DataCell(Text(KOTScreenState._data1[index].amount.toString())),
    ]);
  }
}
*/

class SalesTempItemResult {
  String itemCode;
  String itemName;
  int itmsGrpCod;
  String uOM;
  var price;
  var amount;
  var qty;
  String itmsGrpNam;
  String picturName;
  String imgUrl;
  var tax;

  SalesTempItemResult(
      this.itemCode,
      this.itemName,
      this.itmsGrpCod,
      this.uOM,
      this.price,
      this.amount,
      this.qty,
      this.itmsGrpNam,
      this.picturName,
      this.imgUrl,
      this.tax);
}

class SalesPayment {
  String PaymentName;
  var ReceivedAmount;
  var BillAmount;
  var BalAmount;
  String PaymentRemarks;

  SalesPayment(this.PaymentName, this.ReceivedAmount, this.BillAmount,
      this.BalAmount, this.PaymentRemarks);
}

class SalesSendPayment {
  var docno;
  int LineID;
  String PaymentName;
  var ReceivedAmount;
  var BillAmount;
  var BalAmount;
  String PaymentRemarks;
  String TransactionID;
  String Status;
  var CreationName;
  var TableNo;
  var SeatNo;
  var UserID;

  SalesSendPayment(
      this.docno,
      this.LineID,
      this.PaymentName,
      this.ReceivedAmount,
      this.BillAmount,
      this.BalAmount,
      this.PaymentRemarks,
      this.TransactionID,
      this.Status,
      this.CreationName,
      this.TableNo,
      this.SeatNo,
      this.UserID);

  Map<String, dynamic> toJson() => {
        'DocNo': docno,
        'LineID': LineID,
        'Type': PaymentName,
        'BillAmount': BillAmount,
        'RecvAmount': ReceivedAmount,
        'BalanceAmount': BalAmount,
        'PaymentRemarks': PaymentRemarks,
        'TransactionID': TransactionID,
        'Status': Status,
        'CreationName': CreationName,
        'TableNo': TableNo,
        'SeatNo': SeatNo,
        'UserID': UserID,
      };
}

class SalesTempItemResultSend {
  var docno;
  String CatCode;
  String CatName;
  String itemCode;
  String itemName;
  var itmsGrpCod;
  String itmsGrpNam;
  String uOM;
  var qty;
  var price;
  var amount;
  var CreationName;
  var TableNo;
  var SeatNo;
  var Status;
  String picturName;
  String imgUrl;
  var UserID;
  var LineID;

  SalesTempItemResultSend(
      this.docno,
      this.CatCode,
      this.CatName,
      this.itemCode,
      this.itemName,
      this.itmsGrpCod,
      this.itmsGrpNam,
      this.uOM,
      this.qty,
      this.price,
      this.amount,
      this.CreationName,
      this.TableNo,
      this.SeatNo,
      this.Status,
      this.picturName,
      this.imgUrl,
      this.UserID,
      this.LineID);

  Map<String, dynamic> toJson() => {
        'DocNo': docno,
        'CatCode': CatCode,
        'CatName': CatName,
        'ItemCode': itemCode,
        'ItemName': itemName,
        'ItemGroupCode': itmsGrpCod,
        'ItemGroupName': itmsGrpNam,
        'UOM': uOM,
        'Qty': qty,
        'Price': price,
        'Total': amount,
        'CreationName': CreationName,
        'TableNo': TableNo,
        'SeatNo': SeatNo,
        'Status': Status,
        'PictureName': picturName,
        'PictureURL': imgUrl,
        'UserID': UserID,
        'LineID': LineID
      };

/* Future<String> getData() async {
    var response =
        await http.get(Uri.parse(AppConstants.LIVE_URL + "getOSRDOccation"));

    final data = jsonEncode(response.body);

    if (data != null) {
      var resBody = json.decode(res.body);
    }
  }
*/

}

class DrawDottedhorizontalline extends CustomPainter {
  Paint _paint;

  DrawDottedhorizontalline() {
    _paint = Paint();
    _paint.color = Colors.black; //dots color
    _paint.strokeWidth = 2; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = -300; i < 300; i = i + 15) {
      // 15 is space between dots
      if (i % 3 == 0)
        canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
