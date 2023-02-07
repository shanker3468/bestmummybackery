// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/Model/SalesConsolidateModel.dart';
import 'package:bestmummybackery/Model/SalesPaymentModel.dart';
import 'package:bestmummybackery/Model/ShiftWiseSalesModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ShiftDayEndMaster extends StatefulWidget {
  const ShiftDayEndMaster({Key key}) : super(key: key);

  @override
  _ShiftDayEndMasterState createState() => _ShiftDayEndMasterState();
}

class _ShiftDayEndMasterState extends State<ShiftDayEndMaster> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  int InsertFormId = 0;
  bool loading = false;
  var _Docdate = new TextEditingController();
  final formKey = new GlobalKey<FormState>();

  var _ActualCashAmt = new TextEditingController(text: "0");
  var _TotalCard = new TextEditingController(text: "0");
  var _TotalUPI = new TextEditingController(text: "0");
  var _TotalOtders = new TextEditingController(text: "0");
  var _TotalAmt = new TextEditingController(text: "0");

  var _TotalRetAmt = new TextEditingController(text: "0");
  var _TotalCash = new TextEditingController(text: "0");
  var _TotalSalesRetAmt = new TextEditingController(text: "0");

  NetworkPrinter printer;
  var sessionIPAddress = '0';
  var sessionIPPortNo = 0;

  // MOdels
  ShiftWiseSalesModel RawShiftWiseSalesModel;
  List<ShiftWiseSales> ShiftWiseSalesList = new List();

  SalesConsolidateModel RawSalesConsolidateModel;
  List<SalesConsolidate> SalesConsolidateList = new List();

  SalesPaymentModel RawSalesPaymentModel;
  List<SalePayment> SalesPaymentList = new List();

  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
    getStringValuesSF();
    _Docdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

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
                  decoration:BoxDecoration(gradient: LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
                  child: Scaffold(
                    appBar: AppBar(title: Text("Day End"),),
                    body: !loading
                        ? SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                Container(
                                    height: height/1.8,
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 3.1,
                                          height: height/1.8,
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: ShiftWiseSalesList.toString() =="null"
                                                    ? Center(
                                                          child: Text('Add ItemCode Line Table'),
                                                )
                                                    : DataTable(
                                                        sortColumnIndex: 0,
                                                        sortAscending: true,
                                                        headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                        showCheckboxColumn: false,
                                                        columns: const <DataColumn>[
                                                          DataColumn(
                                                            label: Text('EmpName',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('OpeningTime',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('CloseTime',style: TextStyle(color:Colors.white),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            label: Text('OpeningAmt',style: TextStyle(color:Colors.white),),
                                                          ),

                                                          DataColumn(
                                                            label: Text('ShiftSales',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('ClosingAmt',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('TotalCash',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('TotalRet',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('Diff',style: TextStyle(color:Colors.white),),
                                                          ),
                                                        ],
                                                          rows: ShiftWiseSalesList.map((list) => DataRow(
                                                            color: list.empName=='Total'
                                                                ? MaterialStateProperty.all(Colors.greenAccent)
                                                                : MaterialStateProperty.all(Colors.white),
                                                            cells: [
                                                            DataCell(
                                                              Text(list.empName.toString(),textAlign:TextAlign.left),
                                                            ),
                                                            DataCell(
                                                              Text(list.OpeningTime.toString(),textAlign:TextAlign.left),
                                                            ),
                                                            DataCell(
                                                              Text(list.closeTime.toString(),textAlign:TextAlign.left),
                                                            ),
                                                            DataCell(
                                                              Text(list.openingAmt.toString(),textAlign:TextAlign.left),
                                                            ),

                                                            DataCell(
                                                              Text(list.shiftSales.toString(),textAlign:TextAlign.left),
                                                            ),
                                                              DataCell(
                                                                Text(list.closingAmt.toString(),textAlign:TextAlign.left),
                                                              ),
                                                              DataCell(
                                                                Text(list.TotalCash.toString(),textAlign:TextAlign.left),
                                                              ),
                                                              DataCell(
                                                                Text(list.TotalReturn.toString(),textAlign:TextAlign.left),
                                                              ),
                                                            DataCell(
                                                              Text(list.diff  .toString(),textAlign:TextAlign.left),
                                                            ),
                                                          ]),
                                                          ).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 3,
                                          height: height/1.8,
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: SalesConsolidateList.toString() =="null"
                                                    ? Center(
                                                        child: Text('Add ItemCode Line Table'),
                                                )
                                                    : DataTable(
                                                      sortColumnIndex: 0,
                                                      sortAscending: true,
                                                      headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                      showCheckboxColumn: false,
                                                      columns: const <DataColumn>[
                                                        DataColumn(
                                                          label: Text('ScreenName',style: TextStyle(color:Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Type',style: TextStyle(color:Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Bill Time',style: TextStyle(color:Colors.white),),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Bill No',style: TextStyle(color:Colors.white),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Rec Amt',style: TextStyle(color:Colors.white),),
                                                        ),

                                                      ],
                                                        rows: SalesConsolidateList.map((list) => DataRow(
                                                            color: list.screenName=='Total'
                                                                ? MaterialStateProperty.all(Colors.greenAccent)
                                                                : MaterialStateProperty.all(Colors.white),
                                                          cells: [
                                                          DataCell(
                                                            Text(list.screenName.toString(),textAlign:TextAlign.left),
                                                          ),
                                                            DataCell(
                                                              Text(list.type.toString(),textAlign:TextAlign.left),
                                                            ),
                                                          DataCell(
                                                            Text(list.billTime.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Text(list.orderNo.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Text(list.recAmt.toString(),textAlign:TextAlign.left),
                                                          ),

                                                        ]),
                                                        ).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 3,
                                          height: height/1.8,
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: SalesPaymentList.toString() =="null"
                                                    ? Center(
                                                          child: Text('Add ItemCode Line Table'),
                                                )
                                                    : DataTable(
                                                      sortColumnIndex: 0,
                                                      sortAscending: true,
                                                      headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                                      showCheckboxColumn: false,
                                                        columns: const <DataColumn>[
                                                          DataColumn(
                                                            label: Text('Screen Name',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('Type',style: TextStyle(color:Colors.white),),
                                                          ),
                                                          DataColumn(
                                                            label: Text('Rev Amt',style: TextStyle(color:Colors.white),
                                                            ),
                                                          ),
                                                        ],
                                                        rows: SalesPaymentList.map((list) => DataRow(
                                                            color:
                                                               list.status ==1 ? MaterialStateProperty.all(Colors.black26)
                                                               :list.status ==40 ? MaterialStateProperty.all(Colors.greenAccent)
                                                                : MaterialStateProperty.all(Colors.white),
                                                         cells: [
                                                           DataCell(
                                                            Text(list.screenName.toString(),textAlign:TextAlign.left,
                                                              style: TextStyle(
                                                                  // color: list.screenId==100?
                                                                  // Colors.pinkAccent:Colors.grey
                                                                color: list.screenId==100 &&list.status==0?Colors.redAccent
                                                                :list.screenId==200 &&list.status==0 ?Colors.green
                                                                :list.screenId==1001 &&list.status==0 ?Colors.purple
                                                                :list.screenId==201 &&list.status==1 ?Colors.cyanAccent
                                                                :list.screenId==101 &&list.status==1 ?Colors.greenAccent
                                                                :list.screenId==1001 &&list.status==1 ?Colors.limeAccent
                                                                :Colors.black,
                                                                fontWeight: FontWeight.w700



                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(list.type.toString(),textAlign:TextAlign.left),
                                                          ),
                                                          DataCell(
                                                            Text(list.recvAmount.toString(),textAlign:TextAlign.left),
                                                          ),
                                                        ]),
                                                        ).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 10,),
                                Container(
                                    height: height/10,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 5.5,
                                          child: TextField(
                                            controller: _TotalCash,
                                            enabled: false,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              //fontSize: 12,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Total Cash Amt',
                                              labelText: 'Total Cash Amt',
                                              labelStyle: TextStyle(color:Colors.grey.shade600),
                                            ),
                                          ),

                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 5.5,
                                          child: TextField(
                                            controller: _TotalRetAmt,
                                            enabled: false,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              //fontSize: 12,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Total Return Amt',
                                              labelText: 'Total Return Amt',
                                              labelStyle: TextStyle(color:Colors.grey.shade600),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 5.5,
                                          child: TextField(
                                            controller: _TotalSalesRetAmt,
                                            enabled: false,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              //fontSize: 12,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                              hintText: 'Total Sales Return Amt',
                                              labelText: 'Total Sales Return Amt',
                                              labelStyle: TextStyle(color:Colors.grey.shade600),
                                            ),
                                          ),
                                     ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 5.5,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: width / 5.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 10,),
                                Container(
                                  height: height/10,
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: width / 5.5,
                                        child: TextField(
                                          controller: _ActualCashAmt,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                            hintText: 'Actual Cash Amt',
                                            labelText: 'Actual Cash Amt',
                                            labelStyle: TextStyle(
                                                color:Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: width / 5.5,
                                        child: TextField(
                                          controller: _TotalCard,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                            hintText: ' Total Card Amt',
                                            labelText: ' Total Card Amt',
                                            labelStyle: TextStyle(
                                                color:Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: width / 5.5,
                                        child: TextField(
                                          controller: _TotalUPI,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                            hintText: 'Total UPI Amt',
                                            labelText: 'Total UPI Amt',
                                            labelStyle: TextStyle(
                                                color:Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: width / 5.5,
                                        child: TextField(
                                          controller: _TotalOtders,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                            hintText: 'Total Others Amt',
                                            labelText: 'Total Others Amt',
                                            labelStyle: TextStyle(color:Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: width / 5.5,
                                        child: TextField(
                                          controller: _TotalAmt,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            //fontSize: 12,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
                                            hintText: 'Total Amt',
                                            labelText: 'Total Amt',
                                            labelStyle: TextStyle(
                                                color:Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                            backgroundColor: Colors.pink,
                            icon: Icon(Icons.print, color: Colors.black45),
                            label: Text('Test Print', style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              setState(() {
                                NetPrinter(sessionIPAddress,sessionIPPortNo);
                              });
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.greenAccent,
                            icon: Icon(Icons.refresh, color: Colors.black45),
                            label: Text('Refresh', style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              getPendingListChecking();
                            },
                          ),

                        ],
                      ),
                    ],
                  ),
      ),
    )
        : Container();
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
      getPendingListChecking();
      //_Docdate.text = '04-02-2023';
      //shifwisesalereport();
    });
  }

  Future<http.Response> getPendingListChecking() async {
    print('getPendingListChecking');
    var headers = {"Content-Type": "application/json"};
    print('1');
    setState(() {
      loading = true;
      print('2');
    });
    var body = {
      "FormID": 2,
      "DocNo": 1,
      "ScreenId": 1,
      "OpeningAmt": 0.0,
      "CounterId": int.parse(sessionbranchcode),
      "DeviceId": 1000,
      "UserID": sessionuserID,
      "Status": "O"
    };
    //print(sessionuserID);
    print('2');

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'SHIFT_OEPN_SP'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    //print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      print(response.body);
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
          shifwisesalereport();
        });
      } else {
        loading = true;
        showDialogboxWarning(this.context, "Close The Previous Shift");
        Fluttertoast.showToast(
            msg: "Close Previous Shift",
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
  }

  Future<http.Response> shifwisesalereport() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID-' + InsertFormId.toString());
      print('BranchId-' + sessionbranchcode.toString());
      print('DocDate-' + _Docdate.text.toString());
      ShiftWiseSalesList.clear();
    });
    var body = {
      "FromId": 1,
      //"DocDate":"17-11-2022",
      "DocDate":_Docdate.text.toString(),
      "BranchId":sessionbranchcode.toString(),
      "DocNo":""
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'dayclosingentery'),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {

        showDialogboxWarning(this.context, 'Shift Wise Sales Report Not Load...');
        setState(() {
          loading = false;
        });
      } else {
        log(response.body);
        double total=0;
        setState(() {
        RawShiftWiseSalesModel = ShiftWiseSalesModel.fromJson(jsonDecode(response.body));
        for(int i = 0 ; i < RawShiftWiseSalesModel.testdata.length;i++){
          total += double.parse(RawShiftWiseSalesModel.testdata[i].shiftSales.toString());
          ShiftWiseSalesList.add(ShiftWiseSales(
              RawShiftWiseSalesModel.testdata[i].shiftId,
              RawShiftWiseSalesModel.testdata[i].closeShiftId,
              RawShiftWiseSalesModel.testdata[i].empName,
              RawShiftWiseSalesModel.testdata[i].openingAmt,
              RawShiftWiseSalesModel.testdata[i].closeTime,
              RawShiftWiseSalesModel.testdata[i].closingAmt,
              RawShiftWiseSalesModel.testdata[i].shiftSales,
              RawShiftWiseSalesModel.testdata[i].diff,
              RawShiftWiseSalesModel.testdata[i].OpeningTime,
              RawShiftWiseSalesModel.testdata[i].TotalCash,
              RawShiftWiseSalesModel.testdata[i].TotalReturn,
              RawShiftWiseSalesModel.testdata[i].ONHand,
              RawShiftWiseSalesModel.testdata[i].card,
              RawShiftWiseSalesModel.testdata[i].cash,
              RawShiftWiseSalesModel.testdata[i].upi,
              RawShiftWiseSalesModel.testdata[i].others,

          )
          );
        }

        ShiftWiseSalesList.add(ShiftWiseSales(
          "",
          "",
          "Total",
          "",
          "",
          "",
          total.toString(),
          "",
          "", "","","","","","","")
        );

          loading = false;
        saleconsolidatereport();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
// First TBL
  Future<http.Response> saleconsolidatereport() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print('FormID-' + InsertFormId.toString());
      print('BranchId-' + sessionbranchcode.toString());
      print('UserID-' + sessionuserID.toString());
      SalesConsolidateList.clear();
    });
    var body = {
      "FromId": 2,
      //"DocDate":"23-07-2022",
      "DocDate":_Docdate.text.toString(),
      "BranchId":sessionbranchcode.toString(),
      "DocNo":""
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'dayclosingentery'),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        showDialogboxWarning(this.context, 'Sale Consalidate Not Load...');
        setState(() {
          loading = false;
        });
      } else {
        double total=0;
        log(response.body);
        setState(() {
        RawSalesConsolidateModel = SalesConsolidateModel.fromJson(jsonDecode(response.body));
        for(int i = 0 ; i < RawSalesConsolidateModel.testdata.length; i++ ){
          total += double.parse(RawSalesConsolidateModel.testdata[i].recAmt.toString());
          SalesConsolidateList.add(SalesConsolidate(
            RawSalesConsolidateModel.testdata[i].screenName,
            RawSalesConsolidateModel.testdata[i].shiftId,
            RawSalesConsolidateModel.testdata[i].billTime,
            RawSalesConsolidateModel.testdata[i].orderNo,
            RawSalesConsolidateModel.testdata[i].billNo,
            RawSalesConsolidateModel.testdata[i].recAmt,
            RawSalesConsolidateModel.testdata[i].blanceAmt,
            RawSalesConsolidateModel.testdata[i].totAmount,
            RawSalesConsolidateModel.testdata[i].screenId,
            RawSalesConsolidateModel.testdata[i].type,
           ),
          );
        }

        SalesConsolidateList.add(SalesConsolidate(
          "Total",
          "",
          "",
          "",
          "",
          total.toString(),
          "",
          total.toString(),
          0,""
        ),
        );





          loading = false;
        Paymentwisesalereport();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> Paymentwisesalereport() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      print("Paymentwisesalereport");
      print('FormID' + InsertFormId.toString());
      print('BranchId' + sessionbranchcode.toString());
      print('UserID' + sessionuserID.toString());
      SalesPaymentList.clear();
    });
    var body = {
      "FromId": 3,
      "DocDate":_Docdate.text.toString(),
      "BranchId":sessionbranchcode.toString(),
      "DocNo":""
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'dayclosingentery'),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {

        showDialogboxWarning(this.context, 'Shift Wise Sales Report Not Load...');
        setState(() {
          loading = false;
        });
      } else {
        double total=0;
        double totalreturn=0;
        log(response.body);
        setState(() {
        RawSalesPaymentModel = SalesPaymentModel.fromJson(jsonDecode(response.body));
        for(int i = 0 ; i < RawSalesPaymentModel.testdata.length;i++){
          if(RawSalesPaymentModel.testdata[i].status==0){
            total+= double.parse(RawSalesPaymentModel.testdata[i].recvAmount.toString());
          }else{
            totalreturn+= double.parse(RawSalesPaymentModel.testdata[i].recvAmount.toString());
          }
          SalesPaymentList.add(
            SalePayment(
              RawSalesPaymentModel.testdata[i].screenName,
              RawSalesPaymentModel.testdata[i].type,
              RawSalesPaymentModel.testdata[i].recvAmount,
              RawSalesPaymentModel.testdata[i].status,
              RawSalesPaymentModel.testdata[i].screenId,
            ),
          );
        }
         loading = false;
         SalesPaymentList.add(
          SalePayment(
            "Total",
            "",
            (total-totalreturn).toString(),
            40,
            "",
          ),
        );

        MytotalCal();
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  MytotalCal() {
    double totalcard=0;
    double totalcash=0;
    double totalupi=0;
    double totalothers=0;
    double totalreturnamt=0;
    double totalSalesreturnamt=0;

    setState(() {
      for (int i = 0; i < SalesPaymentList.length; i++) {
        if (SalesPaymentList[i].type == 'Cash') {
          totalcash += double.parse(SalesPaymentList[i].recvAmount.toString());
        }
        else if (SalesPaymentList[i].type == 'Card') {
          totalcard += double.parse(SalesPaymentList[i].recvAmount.toString());
        }
        else if (SalesPaymentList[i].type == 'UPI') {
          totalupi += double.parse(SalesPaymentList[i].recvAmount.toString());
        }
        else if (SalesPaymentList[i].type == 'Others') {
          totalothers += double.parse(SalesPaymentList[i].recvAmount.toString());
        }
        else if (SalesPaymentList[i].type == 'Return Amt') {
          totalreturnamt += double.parse(SalesPaymentList[i].recvAmount.toString());
        }
        else if (SalesPaymentList[i].type == 'SalesReturn') {
          totalSalesreturnamt += double.parse(SalesPaymentList[i].recvAmount.toString());
        }
      }

    _TotalCash.text = totalcash.toString();
    _TotalRetAmt.text = totalreturnamt.toString();
    _TotalSalesRetAmt.text = totalSalesreturnamt.toString();

    _ActualCashAmt.text = ((totalcash-totalreturnamt)-totalSalesreturnamt).toString();

    _TotalCard.text = totalcard.toString();
    _TotalUPI.text = totalupi.toString();
     _TotalOtders.text = totalothers.toString();
     _TotalAmt.text = (double.parse(_ActualCashAmt.text.toString())+totalcard+totalupi+totalothers ).toString();

    });

  }

  NetPrinter(String iPAddress,int pORT,) async {
    print("NetPrinter");
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      //print('SDGVIUGSV' + iPAddress + 'pORT' + pORT.toString());
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        ShiftDemoReceipt(printer);
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: $e');
      // TODO
    }
  }

  Future<void> ShiftDemoReceipt(NetworkPrinter printer) async {
   print("ShiftDemoReceipt");


    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text('Sweets & Cakes', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1,fontType: PosFontType.fontB), linesAfter: 1);
    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center), linesAfter: 1);

   printer.row([PosColumn(text: 'Day End Closing', width: 12, styles: PosStyles(align: PosAlign.center),),]);

    printer.hr(len: 12);



    for(int S =0; S <ShiftWiseSalesList.length;S++ ){

      if(ShiftWiseSalesList[S].empName!='Total') {
        printer.row([
          PosColumn(text: 'EmpName', width: 2, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].empName.toString(), width: 4, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: 'Shift Id', width: 2, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].shiftId.toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
        ]);

        printer.row([
          PosColumn(text: 'Start Time', width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].OpeningTime.toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: 'Close Time', width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].closeTime.toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
        ]);

        printer.row([
          PosColumn(text: 'Opening Amt', width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].openingAmt.toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: 'Sales Amt', width: 3, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].shiftSales.toString(), width: 2, styles: PosStyles(align: PosAlign.left)),
        ]);

        // printer.row([
        //   PosColumn(text: 'TotalCash', width: 5, styles: PosStyles(align: PosAlign.left)),
        //   PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
        //   PosColumn(text: ShiftWiseSalesList[S].TotalCash.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        // ]);
        // printer.row([
        //   PosColumn(text: 'Return Cash', width: 5, styles: PosStyles(align: PosAlign.left)),
        //   PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
        //   PosColumn(text: ShiftWiseSalesList[S].TotalReturn.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        // ]);
        printer.row([
          PosColumn(text: 'System Cash', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].ONHand.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.row([
          PosColumn(text: 'Manual Cash Entery', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].closingAmt.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.row([
          PosColumn(text: 'Diff Cash', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].diff.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.row([
          PosColumn(text: 'Card Amt', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].card.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.row([
          PosColumn(text: 'Cash Amt', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].cash.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.row([
          PosColumn(text: 'UPI Amt', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].upi.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.row([
          PosColumn(text: 'Others Amt', width: 5, styles: PosStyles(align: PosAlign.left)),
          PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
          PosColumn(text: ShiftWiseSalesList[S].others.toString(), width: 6, styles: PosStyles(align: PosAlign.left)),
        ]);
        printer.hr(len: 12);
      }

    }

    printer.hr(len: 12);
    printer.row([
      PosColumn(text: 'Total Card', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _TotalCard.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
    ]);
    printer.row([
      PosColumn(text: 'Total UPI', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _TotalUPI.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.row([
      PosColumn(text: 'Total Others', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _TotalOtders.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left)),
    ]);

    printer.hr(len: 12);

    // printer.row([
    //   PosColumn(text: 'Total Cash', width: 6, styles: PosStyles(align: PosAlign.left)),
    //   PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
    //   PosColumn(text: _TotalCash.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right)),
    // ]);
    //
    // printer.row([
    //   PosColumn(text: "Total Return", width: 6, styles: PosStyles(align: PosAlign.left),),
    //   PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
    //   PosColumn(text: _TotalRetAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right),),
    // ]);
       printer.row([
         PosColumn(text: "Sales Return Amt", width: 6, styles: PosStyles(align: PosAlign.left),),
         PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
         PosColumn(text: _TotalSalesRetAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left),),
       ]);

    printer.row([
      PosColumn(text: "Cash OnHand", width: 6, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: ":", width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _ActualCashAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.left),),
    ]);



    printer.hr(len: 12);

    printer.row([
      PosColumn(text: 'Total Sales', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: ':', width: 1, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: _TotalAmt.text.toString(), width: 5, styles: PosStyles(align: PosAlign.right,bold: true)),
    ]);


    printer.feed(2);
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));
    printer.feed(1);
    printer.cut();

   TypewiseDemoReceipt(printer);

  }

  Future<void> BillwiseDemoReceipt(NetworkPrinter printer) async {


    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,), linesAfter: 1);

    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.row([PosColumn(text: 'Day End Billwise Report', width: 12, styles: PosStyles(align: PosAlign.center),),]);

    printer.hr(len: 12);

    printer.row([
      PosColumn(text: 'BillNo', width: 3, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: 'Time', width: 2, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: 'Type', width: 3, styles: PosStyles(align: PosAlign.center),),
      PosColumn(text: 'Amt', width: 4, styles: PosStyles(align: PosAlign.left)),
    ]);


    for(int k =0; k <SalesConsolidateList.length;k++ ){
      printer.row([
        PosColumn(text: SalesConsolidateList[k].orderNo.toString(), width: 3, styles: PosStyles(align: PosAlign.left)),
        PosColumn(text: SalesConsolidateList[k].billTime.toString(), width: 2, styles: PosStyles(align: PosAlign.left),),
        PosColumn(text: SalesConsolidateList[k].type.toString(), width: 3, styles: PosStyles(align: PosAlign.left),),
        PosColumn(text: SalesConsolidateList[k].recAmt.toString(), width: 4, styles: PosStyles(align: PosAlign.left)),
      ]);
    }


    printer.feed(2);
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));
    printer.feed(1);
    printer.cut();

    TypewiseDemoReceipt(printer);
  }

  Future<void> TypewiseDemoReceipt(NetworkPrinter printer) async {

    var BillCurrentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    var BillCurrentTime = DateFormat.jm().format(DateTime.now());
    printer.text('BESTMUMMY', styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2,), linesAfter: 1);

    printer.text((sessionbranchname),styles: PosStyles(align: PosAlign.center));
    printer.text('Ramnad, TN 623501',styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 07904996060', styles: PosStyles(align: PosAlign.center));
    printer.text((BillCurrentDate + "-" + BillCurrentTime),styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.row([PosColumn(text: 'Day End Typewise Sale', width: 12, styles: PosStyles(align: PosAlign.center),),]);

    printer.hr(len: 12);

    printer.row([
      PosColumn(text: 'Name', width: 5, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: 'Type', width: 3, styles: PosStyles(align: PosAlign.left),),
      PosColumn(text: 'Amt', width: 4, styles: PosStyles(align: PosAlign.left)),

    ]);

    for(int k =0; k <SalesPaymentList.length;k++ ){
      printer.row([
        PosColumn(text: SalesPaymentList[k].screenName.toString(), width: 5, styles: PosStyles(align: PosAlign.left),),
        PosColumn(text: SalesPaymentList[k].type.toString(), width: 3, styles: PosStyles(align: PosAlign.left),),
        PosColumn(text: SalesPaymentList[k].recvAmount.toString(), width: 4, styles: PosStyles(align: PosAlign.left)),
      ]);
    }

    printer.feed(2);
    printer.text('Thank you!', styles: PosStyles(align: PosAlign.center, bold: true));
    printer.feed(1);
    printer.cut();

  }

}

class ShiftWiseSales {
  var shiftId;
  var closeShiftId;
  String empName;
  var   openingAmt;
  String closeTime;
  var closingAmt;
  var shiftSales;
  var diff;
  var OpeningTime;
  var TotalCash;
  var TotalReturn;
  var ONHand;
  var card;
  var cash;
  var upi;
  var others;
  ShiftWiseSales(this.shiftId, this.closeShiftId, this.empName, this.openingAmt, this.closeTime,
      this.closingAmt, this.shiftSales, this.diff,this.OpeningTime,this.TotalCash,this.TotalReturn,this.ONHand,
      this.card,this.cash,this.upi,this.others);
}

class SalesConsolidate {
  String screenName;
  String shiftId;
  String billTime;
  var orderNo;
  String billNo;
  var recAmt;
  var blanceAmt;
  var totAmount;
  var screenId;
  var type;
  SalesConsolidate(this.screenName, this.shiftId, this.billTime, this.orderNo, this.billNo, this.recAmt,
      this.blanceAmt, this.totAmount, this.screenId,this.type);

}

class SalePayment {
  String screenName;
  String type;
  var recvAmount;
  var status;
  var screenId;
  SalePayment(this.screenName, this.type, this.recvAmount, this.status, this.screenId);
}

