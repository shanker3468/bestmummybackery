// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'DashsaleModel.dart';


class SalesDashView extends StatefulWidget {
  const SalesDashView({Key key}) : super(key: key);

  @override
  _SalesDashViewState createState() => _SalesDashViewState();
}

class _SalesDashViewState extends State<SalesDashView> {
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
  var TotalValue = 0.0;
  var _Docdate = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  var EditAmt = 0.0;
  var sessionDayEndCheck='';
  bool DayEndCheck=false;
  double totalsale=0;
  double totalCard=0;
  double totalCash=0;
  double totalUPI=0;
  double totalOthers=0;
  double Branchtotalsale=0;
  double BranchtotalCard=0;
  double BranchtotalCash=0;
  double BranchtotalUPI=0;
  double BranchtotalOthers=0;
  double totaldinning =0;
  double totaltakeaway=0;
  DashsaleModel RawDashsaleModel;
  DashsaleModel RawBranchDashsaleModel;
  List<SalesData> SecSalesData = new List();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay picked = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  String selectedDate = "";

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _Docdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      getStringValuesSF();
    });
    super.initState();
    setState(() {});
  }

   _SelectDelivery(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        selectedDate = new DateFormat("dd-MM-yyyy").format(d);
        _Docdate.text = selectedDate;
      });
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
                title: Text("Sales Dash Board"),
              ),
              body: !loading
                  ? SingleChildScrollView(
                    padding: EdgeInsets.all(5.0),
                    scrollDirection: Axis.vertical,
                      child: Container(
                        key: formKey,
                        alignment: Alignment.center,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/10,
                                          height:height/8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Total Sale", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totalsale.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/10,
                                          height:height/8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Total Cash", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totalCash.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/10,
                                          height:height/8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Total Card", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totalCard.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/10,
                                          height:height/8,
                                          color:Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Total UPI", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totalUPI.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/10,
                                          height:height/8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text("Total Others", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totalOthers.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/7,
                                          height:height/8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(" Dinning", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totaldinning.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(height/100),),
                                      child: Container(
                                          width:width/7,
                                          height:height/8,
                                          color: Colors.white,
                                          padding: EdgeInsets.all(3),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(" Take Away", textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                                SizedBox(height: height/25,),
                                                Text(totaltakeaway.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                                    fontWeight: FontWeight.bold,fontSize: 15),)
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height/50,),
                            Text("Sale Reports",style: TextStyle(fontSize: height/20,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                            SizedBox(height: height/50,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     Card(
                            //       elevation: 5,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(height/100),),
                            //       child: Container(
                            //           width:width/6,
                            //           height:height/8,
                            //           padding: EdgeInsets.all(3),
                            //           child: Center(
                            //             child: Column(
                            //               children: [
                            //                 Text("Total Sale", textAlign: TextAlign.center,
                            //                   style: TextStyle(color: Colors.pinkAccent, fontSize: height/40),),
                            //                 SizedBox(height: height/25,),
                            //                 Text(Branchtotalsale.toString(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58),
                            //                     fontSize: 15),)
                            //               ],
                            //             ),
                            //           )
                            //       ),
                            //     ),
                            //     Card(
                            //       elevation: 5,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(height/100),),
                            //       child: Container(
                            //           width:width/6,
                            //           height:height/8,
                            //           padding: EdgeInsets.all(3),
                            //           child: Center(
                            //             child: Column(
                            //               children: [
                            //                 Text("Total Cash", textAlign: TextAlign.center,
                            //                   style: TextStyle(color: Colors.blue.shade900, fontSize: height/40),),
                            //                 SizedBox(height: height/25,),
                            //                 Text(BranchtotalCash.toString(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58),
                            //                     fontSize: 15),)
                            //               ],
                            //             ),
                            //           )
                            //       ),
                            //     ),
                            //     Card(
                            //       elevation: 5,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(height/100),),
                            //       child: Container(
                            //           width:width/6,
                            //           height:height/8,
                            //           padding: EdgeInsets.all(3),
                            //           child: Center(
                            //             child: Column(
                            //               children: [
                            //                 Text("Total Card", textAlign: TextAlign.center,
                            //                   style: TextStyle(color: Colors.green.shade900, fontSize: height/40),),
                            //                 SizedBox(height: height/25,),
                            //                 Text(BranchtotalCard.toString(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58),
                            //                     fontSize: 15),)
                            //               ],
                            //             ),
                            //           )
                            //       ),
                            //     ),
                            //     Card(
                            //       elevation: 5,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(height/100),),
                            //       child: Container(
                            //           width:width/6,
                            //           height:height/8,
                            //           padding: EdgeInsets.all(3),
                            //           child: Center(
                            //             child: Column(
                            //               children: [
                            //                 Text("Total UPI", textAlign: TextAlign.center,
                            //                   style: TextStyle(color: Colors.orange, fontSize: height/40),),
                            //                 SizedBox(height: height/25,),
                            //                 Text(BranchtotalUPI.toString(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58),
                            //                     fontSize: 15),)
                            //               ],
                            //             ),
                            //           )
                            //       ),
                            //     ),
                            //     Card(
                            //       elevation: 5,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(height/100),),
                            //       child: Container(
                            //           width:width/6,
                            //           height:height/8,
                            //           padding: EdgeInsets.all(3),
                            //           child: Center(
                            //             child: Column(
                            //               children: [
                            //                 Text("Total Others", textAlign: TextAlign.center,
                            //                   style: TextStyle(color: Colors.purple, fontSize: height/40),),
                            //                 SizedBox(height: height/25,),
                            //                 Text(BranchtotalOthers.toString(), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF002D58),
                            //                     fontSize: 15),)
                            //               ],
                            //             ),
                            //           )
                            //       ),
                            //     ),
                            //
                            //   ],
                            // ),
                            Container(
                              height: height/1.5,
                              width: width,
                              child: SecSalesData != null
                                  ? GridView.count(
                                    childAspectRatio: 0.9,
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 0,
                                    children: [
                                      for (int cat = 0;cat <SecSalesData.length;cat++)

                                          InkWell(
                                            onTap: () {
                                              BranchSalesreport(int.parse(SecSalesData[cat].code.toString()) );

                                            },
                                            child: Container(
                                              padding:const EdgeInsets.all(2.0),
                                              child: Card(
                                                elevation: 5,
                                                clipBehavior:Clip.antiAlias,
                                                color: Colors.white,
                                                child: Stack(
                                                  alignment:Alignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                      crossAxisAlignment:CrossAxisAlignment.center,
                                                      children: [

                                                        Text(SecSalesData[cat].location.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: width/19,child: Text(" Dinning  ",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                            Text(SecSalesData[cat].dinning.toString(),style: TextStyle(fontWeight: FontWeight.w400,color: Colors.cyan.shade900),),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: width/17,child: Text(" TakeAway  ",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                            Text(SecSalesData[cat].takeaway.toString(),style: TextStyle(fontWeight: FontWeight.w400,color: Colors.teal.shade900),),
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [
                                                            SizedBox( width: width/19,child: Text(" Total  ",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                            Text(SecSalesData[cat].sales.toString(),
                                                              style: TextStyle(fontWeight: FontWeight.w700,
                                                                  color: SecSalesData[cat].sales.toString()=="0"?Colors.black54:
                                                                  Colors.redAccent
                                                              ),),
                                                          ],
                                                        )

                                                      ],
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

                          ],
                        ),
                      ),
              )
                  : Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                ),
              ),
              persistentFooterButtons: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.greenAccent,
                      icon: Icon(Icons.date_range),
                      label: Text(_Docdate.text,style: TextStyle(color: Colors.black54),),
                      onPressed: () {
                        _SelectDelivery(context);
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.red,
                      icon: Icon(Icons.refresh),
                      label: Text('Refresh'),
                      onPressed: () {
                        setState(() {
                          Salesreport();
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),

                  ],
                ),
              ],
            ),
          ),
    )
        : SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Sales Dash Board"),
            ),
            body: !loading
                ? SingleChildScrollView(
                  padding: EdgeInsets.all(5.0),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/10,
                                    height:height/8,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Total Sale", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totalsale.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/10,
                                    height:height/8,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Total Cash", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totalCash.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/10,
                                    height:height/8,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Total Card", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totalCard.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/10,
                                    height:height/8,
                                    color:Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Total UPI", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totalUPI.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/10,
                                    height:height/8,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Total Others", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totalOthers.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/7,
                                    height:height/8,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(" Dinning", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totaldinning.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(height/100),),
                                child: Container(
                                    width:width/7,
                                    height:height/8,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(3),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(" Take Away", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: height/40,fontWeight: FontWeight.bold),),
                                          SizedBox(height: height/25,),
                                          Text(totaltakeaway.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.black54,
                                              fontWeight: FontWeight.bold,fontSize: 15),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: height/50,),
                      Text("Sale Reports",style: TextStyle(fontSize: height/20,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                      SizedBox(height: height/50,),

                      Container(
                        height: height/2.5,
                        width: width,
                        child: SecSalesData != null
                            ? GridView.count(
                              childAspectRatio: 0.9,
                                crossAxisCount: 6,
                                mainAxisSpacing: 0,
                                children: [
                                for (int cat = 0;cat <SecSalesData.length;cat++)

                                      InkWell(
                                        onTap: () {
                                          BranchSalesreport(int.parse(SecSalesData[cat].code.toString()) );

                                        },
                                        child: Container(
                                          padding:const EdgeInsets.all(2.0),
                                          child: Card(
                                            elevation: 5,
                                            clipBehavior:Clip.antiAlias,
                                            color: Colors.white,
                                            child: Stack(
                                              alignment:Alignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment:CrossAxisAlignment.center,
                                                  children: [

                                                    Text(SecSalesData[cat].location.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: width/19,child: Text(" Dinning",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                        SizedBox(width: width/50,child: Text(":",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                        Text(SecSalesData[cat].dinning,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.cyan.shade900),),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: width/19,child: Text("T.Away",style: TextStyle(fontWeight: FontWeight.w500,),)),
                                                        SizedBox(width: width/50,child: Text(":",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                        Text(SecSalesData[cat].takeaway.toString(),style: TextStyle(fontWeight: FontWeight.w400,color: Colors.teal.shade900),),
                                                      ],
                                                    ),

                                                    Row(
                                                      children: [
                                                        SizedBox( width: width/19,child: Text(" Total  ",style: TextStyle(fontWeight: FontWeight.w500),)),
                                                        Text(SecSalesData[cat].sales.toString(),
                                                          style: TextStyle(fontWeight: FontWeight.w700,
                                                              color: SecSalesData[cat].sales.toString()=="0"?Colors.black54:
                                                              Colors.redAccent
                                                          ),),
                                                      ],
                                                    )

                                                  ],
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

                      SizedBox(height: height/50,),

                    ],
                  ),
            )
                : Container(
                  child: Center(
                      child: CircularProgressIndicator(),
              ),
            ),
            persistentFooterButtons: [
              Container(
                height: height/15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.greenAccent,
                      icon: Icon(Icons.date_range),
                      label: Text(_Docdate.text,style: TextStyle(color: Colors.black54),),
                      onPressed: () {
                        _SelectDelivery(context);
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.red,
                      icon: Icon(Icons.refresh),
                      label: Text('Refresh'),
                      onPressed: () {
                        setState(() {
                          Salesreport();
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),

                  ],
                ),
              ),
            ],
          ),
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
      sessionDayEndCheck = prefs.getString("DayEndClsg");
      Salesreport();
    });
  }

  Future<http.Response> Salesreport() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID-' + InsertFormId.toString());
      print('BranchId-' + sessionbranchcode.toString());
      print('DocDate-' + _Docdate.text.toString());
      SecSalesData.clear();

    });
    var body = {
      "FormId":1,
      "Date":_Docdate.text,
      "BarnchId":0
    };
    print(sessionuserID);
    log(jsonEncode(body));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DASHBOARD'),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {


        setState(() {
          loading = false;
          totalsale=0;
          totalCard=0;
          totalCash=0;
          totalUPI=0;
          totalOthers=0;
          totaldinning =0;
          totaltakeaway=0;
          SecSalesData.clear();
        });
      } else {
        log(response.body);
        setState(() {

           totalsale=0;
           totalCard=0;
           totalCash=0;
           totalUPI=0;
           totalOthers=0;
           totaldinning =0;
          totaltakeaway=0;

          RawDashsaleModel =  DashsaleModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<RawDashsaleModel.testdata.length;i++){

              totalsale += double.parse(RawDashsaleModel.testdata[i].sales.toString());
              totalCard += double.parse(RawDashsaleModel.testdata[i].card.toString());
              totalCash += double.parse(RawDashsaleModel.testdata[i].cash.toString());
              totalOthers += double.parse(RawDashsaleModel.testdata[i].others.toString());
              totalUPI += double.parse(RawDashsaleModel.testdata[i].uPI.toString());
              totaldinning += double.parse(RawDashsaleModel.testdata[i].dinning.toString());
              totaltakeaway += double.parse(RawDashsaleModel.testdata[i].takeaway.toString());


            SecSalesData.add(
                SalesData(
                    RawDashsaleModel.testdata[i].code.toString(),
                    RawDashsaleModel.testdata[i].location.toString(),
                    RawDashsaleModel.testdata[i].card.toString(),
                    RawDashsaleModel.testdata[i].cash.toString(),
                    RawDashsaleModel.testdata[i].uPI.toString(),
                    RawDashsaleModel.testdata[i].others.toString(),
                    RawDashsaleModel.testdata[i].sales.toString(),
                    RawDashsaleModel.testdata[i].dinning.toString(),
                    RawDashsaleModel.testdata[i].takeaway.toString(),
                )
            );
          }



          loading = false;
        });

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> BranchSalesreport(int BranchId) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID-' + InsertFormId.toString());
      print('BranchId-' + sessionbranchcode.toString());
      print('DocDate-' + _Docdate.text.toString());

    });
    var body = {
      "FormId":2,
      "Date":_Docdate.text,
      "BarnchId":BranchId
    };
    print(sessionuserID);
    log(jsonEncode(body));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'DASHBOARD'),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {


        setState(() {
          loading = false;
          Branchtotalsale=0;
          BranchtotalCard=0;
          BranchtotalCash=0;
          BranchtotalUPI=0;
          BranchtotalOthers=0;
        });
      } else {
        log(response.body);
        setState(() {

          Branchtotalsale=0;
          BranchtotalCard=0;
          BranchtotalCash=0;
          BranchtotalUPI=0;
          BranchtotalOthers=0;

          RawBranchDashsaleModel =  DashsaleModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<RawBranchDashsaleModel.testdata.length;i++){

            Branchtotalsale += double.parse(RawBranchDashsaleModel.testdata[i].sales.toString());
            BranchtotalCard += double.parse(RawBranchDashsaleModel.testdata[i].card.toString());
            BranchtotalCash += double.parse(RawBranchDashsaleModel.testdata[i].cash.toString());
            BranchtotalUPI += double.parse(RawBranchDashsaleModel.testdata[i].uPI.toString());
            BranchtotalOthers += double.parse(RawBranchDashsaleModel.testdata[i].others.toString());

          }



          loading = false;
        });

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

}

class SalesData {
  var code;
  String location;
  var card;
  var cash;
  var uPI;
  var others;
  var sales;
  var dinning;
  var takeaway;

  SalesData(
      this.code,
        this.location,
        this.card,
        this.cash,
        this.uPI,
        this.others,
        this.sales,this.dinning,this.takeaway);


}
