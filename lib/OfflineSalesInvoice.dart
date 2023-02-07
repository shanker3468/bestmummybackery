/*
import 'dart:convert';
import 'dart:io';

import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/helper/DbHelper.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineSalesInvoice extends StatefulWidget {
  OfflineSalesInvoice({Key key}) : super(key: key);

  @override
  _OfflineSalesInvoiceState createState() => _OfflineSalesInvoiceState();
}

class _OfflineSalesInvoiceState extends State<OfflineSalesInvoice> {
  final pagecontroller = PageController(
    initialPage: 0,
  );

  bool loading = false;
  DbHelper dbHelper = new DbHelper();
  CategoriesModel categoryitem;
  var TextClicked;
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  int onclick = 0;
  String colorchange = "";
  double getvalue = 0;
  bool loyalcheckboxValue = false;
  bool careofcheckboxValue = false;


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
  String altersalespersoname = "";
  String altersalespersoncode = "";
  String alterpayment = "Select";

  String search = "";
  double batchcount = 0;
  @override
  void initState() {
    // TODO: implement initState
    getdata();
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
    if (!tablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(title: Text("Offline")),
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
                                                        */
/*getdetailitems(
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
                                                            onclick);*/ /*

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
                                      */
/* child: itemodel != null
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
                                          : Container(),*/ /*

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
                                                                                80,
                                                                            child:
                                                                                Center(
                                                                              child: TextField(
                                                                                // readOnly: list.uOM.contains("kgs") ? false : true,
                                                                                style: TextStyle(fontSize: 20),

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
                                                                                  text: list.qty.toString(),
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
                      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                new Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextField(
                                        controller: Edt_Mobile,
                                        decoration: InputDecoration(
                                          labelText: "Customer No",
                                          border: OutlineInputBorder(),
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
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextField(
                                        enabled: false,
                                        controller: DelDateController,
                                        decoration: InputDecoration(
                                          labelText: "Delivery Date",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              //Use of SizedBox
                              height: 10,
                            ),
                            Row(
                              children: [
                                new Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: DropdownSearch<String>(
                                        mode: Mode.BOTTOM_SHEET,
                                        showSearchBox: true,
                                        items: occ,
                                        label: "Choose Occation",
                                        onChanged: (val) {
                                          for (int kk = 0;
                                              kk < occModel.result.length;
                                              kk++) {
                                            if (occModel.result[kk].occName ==
                                                val) {
                                              print(
                                                  occModel.result[kk].occCode);
                                              alterocccode =
                                                  occModel.result[kk].occCode;
                                            }
                                          }
                                        },
                                        selectedItem: alteroccname,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate1(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextField(
                                        enabled: false,
                                        controller: OccDateController,
                                        decoration: InputDecoration(
                                          labelText: "Occution Date",
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
                            Row(
                              children: [
                                new Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: TextField(
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                          labelText: "Message",
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
                            Row(
                              children: [
                                new Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: DropdownSearch<String>(
                                        mode: Mode.BOTTOM_SHEET,
                                        showSearchBox: true,
                                        label: "Shape",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: "Sales Person",
                                        border: OutlineInputBorder(),
                                      ),
                                      controller: TextEditingController(
                                          text: altersalespersoname),
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                print(checkedValue);
                                if (checkedValue == true) {
                                  delstatelayout = true;
                                  delstateplace = true;
                                  delstateremarks = true;
                                } else {
                                  delstatelayout = false;
                                  delstateplace = false;
                                  delstateremarks = false;
                                }
                              },
                              child: SizedBox(
                                width: 300,
                                child: CheckboxListTile(
                                  title: Text("Do You Want Door Delivery?"),
                                  // autofocus: false,
                                  activeColor: Colors.blue,
                                  checkColor: Colors.green,
                                  selected: checkedValue,
                                  value: checkedValue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      checkedValue = value;
                                      print(checkedValue);
                                      if (checkedValue == true) {
                                        delstatelayout = true;
                                        delstateplace = true;
                                        delstateremarks = true;
                                      } else {
                                        delstatelayout = false;
                                        delstateplace = false;
                                        delstateremarks = false;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: delstatelayout,
                              child: Row(
                                children: [
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: DropdownSearch<String>(
                                          mode: Mode.BOTTOM_SHEET,
                                          showSearchBox: true,
                                          items: countrylist,
                                          label: "Delivery Country",
                                          onChanged: (val) {
                                            for (int kk = 0;
                                                kk <
                                                    countryModell.result.length;
                                                kk++) {
                                              if (countryModell
                                                      .result[kk].name ==
                                                  val) {
                                                print(countryModell
                                                    .result[kk].code);
                                                altercountrycode = countryModell
                                                    .result[kk].code;
                                              }
                                            }
                                          },
                                          selectedItem: alteroccname,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: DropdownSearch<String>(
                                          mode: Mode.BOTTOM_SHEET,
                                          showSearchBox: true,
                                          items: statelist,
                                          label: "Delivery State",
                                          onChanged: (val) {
                                            for (int kk = 0;
                                                kk < stateModel.result.length;
                                                kk++) {
                                              if (stateModel.result[kk].name ==
                                                  val) {
                                                print(
                                                    stateModel.result[kk].code);
                                                alterstatecode =
                                                    stateModel.result[kk].code;
                                              }
                                            }
                                          },
                                          selectedItem: alteroccname,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: delstateplace,
                              child: Row(
                                children: [
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: DropdownSearch<String>(
                                          mode: Mode.BOTTOM_SHEET,
                                          showSearchBox: true,
                                          label: "Delivery Place",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: TextField(
                                          controller: Edt_Delcharge,
                                           inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Delivery Charge",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: delstateremarks,
                              child: Row(
                                children: [
                                  new Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: TextField(
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                            labelText: "Remarks",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            LineSeparator(color: Colors.grey),
                            ElevatedButton(
                                onPressed: () {
                                  pagecontroller.jumpToPage(2);
                                },
                                child: Text('Next')),
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
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (alterpayment == "Select") {
                                        showDialogboxWarning(
                                            context, "Please Choose Card Type");
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
                                    child: Text('Add'),
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
                                          height: height / 2,
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
                                      onPressed: (){},
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
                                                        */
/*getdetailitems(
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
                                                            onclick);*/ /*

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
                                  */
/* Expanded(
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
                                  ),*/ /*

                                ],
                              ),
                            ),
                            */
/* Expanded(
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
                            ),*/ /*

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


  Future<CategoriesModel> getdata() async {
    setState(() {
      loading = true;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bestmummy.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> list = await database.rawQuery(
        "Select Code,Name,Imgurl from(Select  ItmsTypCod'Code',ItmsGrpNam'Name',''as Imgurl from OITG UNION Select '99' as 'Code','Favourites' as 'Name',''as Imgurl)X  LIMIT 7");
    print(jsonEncode(list));
    await database.close();
    setState(() {
      loading = false;
    });
    if (list.length == 0) {
      showDialogboxWarning(this.context, "No Data");
    } else {
      //  print(json.encode("{status:0 , result: $list}" as Map<String, dynamic>));
      */
/*   categoryitem = CategoriesModel.fromJson(
          jsonDecode(json.encode("status\":\'0\' , \"result\": $list")));*/ /*


*/
/*      List<String> userData = List<String>.from(
          jsonDecode(json.encode("status\":\'0\' , \"result\": $list")));*/ /*


      // print(jsonDecode(json.encode("{status\":\'0\' , \"result\": $list}")));
      print(jsonDecode(
          json.encode("{status\":\"0\" , \"result\": ${json.encode(list)}")));

      try {
        //var jsonobj = jsonDecode(jsonstring);
        categoryitem = CategoriesModel.fromJson(
            jsonDecode("{\"status\":\0\,\"result\": ${json.encode(list)}}"));
      } catch (e) {
        print(e);
      }
    }
  }
}
*/
