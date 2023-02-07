import 'dart:convert';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/ViewCartModel.dart';
import 'package:bestmummybackery/screens/BillDetails.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({Key key}) : super(key: key);

  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  TextEditingController SearchController = new TextEditingController();
  var DelDateController = new TextEditingController();
  var OccDateController = new TextEditingController();

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  bool loading = false;
  String selectedDate = "";

  ViewCartModel itemodel;
  String search = "";
  int batchcount = 0;
  double batchamount = 0;
  bool checkedValue = false;
  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('View Cart'),
            actions: [],
          ),
          body: !loading
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: SearchController,
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
                                    SearchController.clear();
                                  });
                                },
                                icon: Icon(Icons.clear),
                              ),
                              border: InputBorder.none,
                              hintText: 'Search Item...',
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(Icons.search)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: height / 1.3,
                        child: ListView(
                          children: [
                            if (itemodel != null)
                              for (int k = 0; k < itemodel.result.length; k++)
                                if (itemodel.result[k].itemName
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))
                                  Card(
                                    elevation: 5,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width / 5,
                                          child: AspectRatio(
                                            aspectRatio: 0.88,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF5F6F9),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: itemodel.result[k]
                                                          .pictureURL !=
                                                      AppConstants.LIVE_URL +
                                                          'Images/'
                                                  ? Image.network(
                                                      itemodel
                                                          .result[k].pictureURL,
                                                      height: 100,
                                                      width: 100,
                                                    )
                                                  : Image.asset(
                                                      'assets/imgs/logo.png'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: width - 120,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    itemodel.result[k].itemName,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                    maxLines: 2,
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              itemodel.result[k].uom,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                              maxLines: 1,
                                            ),
                                            Container(
                                              width: width / 1.5,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '\u20B9 ' +
                                                        itemodel.result[k].price
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                    maxLines: 2,
                                                  ),
                                                  /*Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                'decrement{$k}');
                                                            _decrementButton(
                                                                context, k);
                                                          },
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 3,
                                                                  vertical: 2),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              color:
                                                                  Colors.white),
                                                          child: Text(
                                                            itemodel
                                                                .result[k].qty
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                'increment{$k}');
                                                            _incrementButton(
                                                                context, k);
                                                          },
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),*/
                                                  Row(
                                                    children: [
                                                      _decrementButton(
                                                          context, k),
                                                      Text(
                                                        itemodel.result[k].qty
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20.0),
                                                      ),
                                                      _incrementButton(
                                                          context, k),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            LineSeparator(color: Colors.grey),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      new Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          child: new TextField(
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                            onSubmitted: (value) {
                                              print("Onsubmit,${value}");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Customer Charge",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0))),
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
                                        child: Container(
                                          color: Colors.white,
                                          child: new TextField(
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                            onSubmitted: (value) {
                                              print("Onsubmit,${value}");
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Advance Amount",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  LineSeparator(color: Colors.grey),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: "Total:\n",
                                          children: [
                                            TextSpan(
                                              text: batchamount
                                                  .toStringAsFixed(2)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            color: Color(0xffff3a5a)),
                                        child:ElevatedButton(
                                          style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                          child: Text(
                                            "Checkout",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                          onPressed: () {
                                            //showBottomSheet(context);
                                            showDiallog(context, batchcount,
                                                batchamount);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          /*persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total Qty :\n\n",
                    children: [
                      TextSpan(
                        text: batchcount.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total Amount:\n\n",
                          children: [
                            TextSpan(
                              text: '\u20B9 ' + batchamount.toStringAsFixed(2),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Color(0xffff3a5a)),
                    child: FlatButton(
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],*/
        ),
      ),
    );
  }

  Widget _incrementButton(BuildContext context, int index) {
    return RoundedIconButton(
        icon: Icons.add,
        iconSize: 30,
        onPress: () {
          setState(() {
            if (itemodel.result[index].qty == 100) {
              Fluttertoast.showToast(msg: "You Cannot more than 100 Qty");
              return;
            }
            itemodel.result[index].qty++;
            additem(
                1,
                0,
                0,
                altercategoryName.toString(),
                itemodel.result[index].itemCode,
                itemodel.result[index].itemName,
                itemodel.result[index].itemGroupCode,
                itemodel.result[index].uom,
                itemodel.result[index].qty,
                itemodel.result[index].price.toDouble(),
                0,
                int.parse(sessionuserID),
                itemodel.result[index].pictureName,
                itemodel.result[index].pictureURL);
            count();
          });
        });
  }

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return new Container(
            height: MediaQuery.of(context).size.height - 350,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Center(
                child: new SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            new InputDecoration(hintText: 'Customer No'),
                        maxLength: 32,
                      ),
                      TextFormField(
                        decoration:
                            new InputDecoration(hintText: 'Delivery Date Time'),
                        maxLength: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void showDiallog(context, int qty, double amount) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(
          milliseconds:
              400), // How long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // Makes widget fullscreen
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(5.0),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LineSeparator(color: Colors.grey),
                  Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text(
                              'Total Qty : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(qty.toStringAsFixed(0).toString()),
                          ],
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
                        flex: 1,
                        child: Row(
                          children: [
                            Text(
                              'Total Amount : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '\u20B9 ${amount.toStringAsFixed(2).toString()}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LineSeparator(color: Colors.grey),
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
                            child: TextField(
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
                    height: 5,
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
                              label: "Choose Occution",
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
                    height: 5,
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
                    height: 5,
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
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              showSearchBox: true,
                              label: "Sales Person",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      print(checkedValue);
                    },
                    child: SizedBox(
                      width: 300,
                      child: CheckboxListTile(
                        title: Text("Do You Want Door Delivery?"),
                        // autofocus: false,
                        activeColor: Colors.white12,
                        checkColor: Colors.green,
                        selected: checkedValue,
                        value: checkedValue,
                        onChanged: (bool value) {
                          setState(() {
                            checkedValue = value;
                            print(checkedValue);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
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
                              label: "Delivery State",
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
                              label: "Delivery District",
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
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
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
                  SizedBox(
                    height: 5,
                  ),
                  Row(
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
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Color(0xffff3a5a)),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              Fluttertoast.showToast(msg: "Ok");
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BillDetails()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _decrementButton(BuildContext context, int index) {
    return RoundedIconButton(
      icon: Icons.remove,
      iconSize: 30,
      onPress: () {
        setState(() {
          if (itemodel.result[index].qty > 0) {
            itemodel.result[index].qty--;
            additem(
                1,
                0,
                0,
                altercategoryName.toString(),
                itemodel.result[index].itemCode,
                itemodel.result[index].itemName,
                itemodel.result[index].itemGroupCode,
                itemodel.result[index].uom,
                itemodel.result[index].qty,
                itemodel.result[index].price.toDouble(),
                0,
                int.parse(sessionuserID),
                itemodel.result[index].pictureName,
                itemodel.result[index].pictureURL);
            count();
          } else {
            Fluttertoast.showToast(msg: "You Cannot Put Less than 0");
          }
        });
      },
    );
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
      getdetailitems();
    });
  }

  void additem(
      int FormID,
      int docno,
      int catcode,
      String catname,
      String itemCode,
      String itemName,
      String ItemGroupCode,
      String UOM,
      int Qty,
      double Price,
      double Total,
      int UserID,
      String PictureName,
      String PictureURL) {
    setState(() {
      loading = true;
    });
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
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['result'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          getdetailitems();
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void getdetailitems() {
    setState(() {
      loading = true;
    });
    InsertAddtoCart(2, 0, 0, "", "", "", "", "", 0, 0, 0, sessionuserID, "", "")
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
        } else {
          setState(() {
            itemodel = ViewCartModel.fromJson(jsonDecode(response.body));
            count();
          });
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  void _oncheckedValue(bool newValue) => setState(() {
        checkedValue = newValue;

        if (checkedValue) {
          print("checked");
        } else {
          print("unchecked");
        }
      });
  void count() async {
    setState(() {
      batchcount = 0;
      batchamount = 0;
      for (int s = 0; s < itemodel.result.length; s++) {
        if (itemodel.result[s].qty > 0) {
          batchcount += itemodel.result[s].qty;
          batchamount += itemodel.result[s].price * itemodel.result[s].qty;
          print(batchcount);
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        // we format the selected date and assign it to the state variable
        selectedDate = new DateFormat("dd-MM-yyyy").format(d);
        DelDateController.text = selectedDate;
      });
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        // we format the selected date and assign it to the state variable
        selectedDate = new DateFormat("dd-MM-yyyy").format(d);
        OccDateController.text = selectedDate;
      });
  }
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

class RoundedIconButton extends StatelessWidget {
  RoundedIconButton(
      {@required this.icon, @required this.onPress, @required this.iconSize});

  final IconData icon;
  final Function onPress;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
      elevation: 6.0,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(iconSize * 0.2)),
      // fillColor: Color(0xFFFBEAD7),
      child: Icon(
        icon,
        color: Colors.orange,
        size: iconSize * 0.8,
      ),
    );
  }
}
