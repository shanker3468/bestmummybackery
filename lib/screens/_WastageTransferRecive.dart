// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_brace_in_string_interps, missing_return, unused_local_variable, unrelated_type_equality_checks, equal_keys_in_map, camel_case_types, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/WastageRecivieModel.dart';
import 'package:bestmummybackery/PostData.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WastageRecive extends StatefulWidget {
  WastageRecive({Key key, this. DocNo, this. DocType}) : super(key: key);
  var DocType="";
  var DocNo="";
  @override
  _WastageReciveState createState() => _WastageReciveState();
}

class _WastageReciveState extends State<WastageRecive> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionContact1 = "";
  var sessionIPPortNo = 0;
  bool loading = false;
  final TextEditingController Edt_TrnsferNo = TextEditingController();

  WastageRecivieModel rawWastageTransferList;
  List<WastageTransferList> secWastageTransferList=[];


  @override
  void initState() {
    getStringValuesSF();
    super.initState();
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
      child: !tablet?
       SafeArea(
         child: Scaffold(
           appBar: PreferredSize(
             preferredSize: Size.fromHeight(!tablet? height/15 :height/9),
             child: new AppBar(title: Text('Despatch'),),
          ),
          backgroundColor: Colors.white,
          persistentFooterButtons: [
            Container(
              height: height/22,
              child:Row(
                children: [
                  SizedBox(
                    width: width/50,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "Cancel",
                    backgroundColor: Colors.red,
                    icon: Icon(Icons.clear,size: height/50,),
                    label: Text('Cancel',style: TextStyle(fontSize: height/60),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: width/50,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "Save",
                    backgroundColor: Colors.blue.shade700,
                    icon: Icon(Icons.clear,size: height/50,),
                    label: Text('Save',style: TextStyle(fontSize: height/60),),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
       )
      :SafeArea(child: Scaffold(appBar: new AppBar(title: Text('Wastage Recive'),),
           backgroundColor: Colors.white,
           body: !loading
              ? SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                        children: [
                          new Expanded(
                            flex: 5,
                              child: new TextField(
                                controller: Edt_TrnsferNo,
                                enabled: true,
                                onSubmitted: (value) {
                                  setState(() {
                                    print("Onsubmit,${value}");
                                    getTransferData();
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Enter Transfer No",
                                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(0))),
                                ),
                              ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: height/1.2,
                      width: width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: secWastageTransferList.length == 0
                            ? Center(
                          child: Text('No Data Add!'),
                        )
                            : DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                showCheckboxColumn: false,
                                headingRowHeight: !tablet? height/20: height/11,
                                dataRowHeight: !tablet? height/20:height/12,
                                columnSpacing: width/20,
                                columns: const <DataColumn>[

                                  DataColumn(
                                    label: Text('S.No',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Item Name',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('UOM',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Transfer Qty',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Recive Qty',style: TextStyle(color: Colors.white),),
                                  ),



                                ],
                                rows: secWastageTransferList.map((list) =>
                                    DataRow(cells: [

                                      DataCell(
                                        Text(
                                          (secWastageTransferList.indexOf(list) +1).toString(),
                                          textAlign:TextAlign.center,style: TextStyle(fontSize: !tablet? height/55:height/30),),
                                      ),
                                      DataCell(
                                        Text(list.itemName,textAlign: TextAlign.left,style: TextStyle(fontSize: !tablet? height/55:height/30),),
                                      ),
                                      DataCell(
                                        Text(list.itemName,textAlign: TextAlign.left,style: TextStyle(fontSize: !tablet? height/55:height/30),),
                                      ),
                                      DataCell(
                                          Text(list.qty.toString(),style: TextStyle(fontSize: !tablet? height/55:height/30),textAlign:TextAlign.center),
                                          ),
                                      DataCell(
                                        Text(list.TransferQty,textAlign: TextAlign.left,style: TextStyle(fontSize: !tablet? height/55:height/30),),
                                          showEditIcon: true, onTap: () {

                                        if (list.uOM == "Grams" || list.uOM == "Kgs") {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder:(BuildContext context) {
                                              return Dialog(
                                                shape:RoundedRectangleBorder(
                                                  borderRadius:BorderRadius.circular(50),),
                                                elevation: 0,
                                                backgroundColor:Colors.transparent,
                                                child: SubMyClac(
                                                    context,
                                                    secWastageTransferList.indexOf(list),list.TransferQty,tablet,height,width,
                                                    list.price,list.ammount),
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
                                                child: QtyMyClac(context,secWastageTransferList.indexOf(list),list.TransferQty,tablet,height,width,list.price,list.ammount),
                                              );
                                            },
                                          );
                                        }
                                      }
                                      ),
                                    ]),
                                ).toList(),
                        ),
                      ),
                    ),
                  ],
            ),
          ) : Center(child: CircularProgressIndicator(),),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.clear),
                  label: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  heroTag: "Save",
                  backgroundColor: Colors.blue.shade700,
                  icon: Icon(Icons.check),
                  label: Text('Savee'),
                  onPressed: () {
                    int count=0;
                    for(int i=0;i<secWastageTransferList.length;i++){
                    if(double.parse(secWastageTransferList[i].qty.toString())<double.parse(secWastageTransferList[i].TransferQty.toString())){
                      count++;
                    }
                    }
                    if(count==0){
                      Fluttertoast.showToast(msg: "Success...");
                      updateinsert();
                    }else{
                      Fluttertoast.showToast(msg: " Qty Mis Matched...");

                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SubMyClac(context, index, packetType,tablet,height,width,price,amount) {
    var Qty;
    log("Grams");
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

                      Qty = (value * 1).toStringAsFixed(3);
                      Qty = (value * 1).toStringAsFixed(3);
                      //print(price.round() / 1 * double.parse(Qty));
                      amount =  (double.parse(price.toString()).round() / 1 * double.parse(Qty)).round().toString();
                      print(amount.toString());
                    });
                    if (kDebugMode) {
                      setState(() {
                        Qty = (value * 1).toStringAsFixed(3);
                      });
                    }
                  },
                  onTappedDisplay: (value, details) {
                    print(details);
                    print(value);
                    if (kDebugMode) {
                      //templist[index].qty = 0;
                      Navigator.pop(context);
                    }
                  },
                  theme: const CalculatorThemeData(
                    borderColor: Colors.black12,
                    borderWidth: 1,
                    displayColor: Colors.white,
                    displayStyle:TextStyle(fontSize: 20, color: Colors.black54),
                    expressionColor: Colors.white,
                    expressionStyle:TextStyle(fontSize: 15, color: Colors.black54),
                    operatorColor: Colors.lightBlue,
                    operatorStyle:TextStyle(fontSize: 15, color: Colors.black54),
                    commandColor: Colors.lightGreenAccent,
                    commandStyle:TextStyle(fontSize: 15, color: Colors.black54),
                    numColor: Colors.white24,
                    numStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(
                height: tablet?50:height/50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    secWastageTransferList[index].TransferQty = Qty.toString();
                    // templist[index].amount = amount;
                    // countval();
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

  QtyMyClac(context, index, packetType,tablet,height,width,price,amount) {
    var Qty;
    log("Pcs");
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
                      Qty = (value * 1).toStringAsFixed(3);
                      amount = double.parse(price.toString()).round()* double.parse(Qty);
                    });
                    if (kDebugMode) {
                      setState(() {
                        print(value);
                        Qty = (value * 1).toStringAsFixed(3);
                        amount = double.parse(price.toString()).round()* double.parse(Qty);
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
                height: tablet?50:height/50,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    secWastageTransferList[index].TransferQty = Qty.toString();
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
      sessionContact1 = prefs.getString("Contact1");
    });
  }

  Future<http.Response> getTransferData() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      //templist.clear();
    });
    var body = {
      "TransferDocNo": Edt_TrnsferNo.text.toString(),
    };
    final response = await http.post(Uri.parse(AppConstants.LIVE_URL + 'getWastagetgetData'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    var nodata = jsonDecode(response.body)['status'] == 0;
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if(jsonDecode(response.body)['status']=='0'){

      }else{
        setState(() {
          rawWastageTransferList = WastageRecivieModel.fromJson(jsonDecode(response.body));
          for(int i=0; i <rawWastageTransferList.result.length;i++ ){
            secWastageTransferList.add(
                WastageTransferList(
                    rawWastageTransferList.result[i].docNo,
                    rawWastageTransferList.result[i].docDate,
                    rawWastageTransferList.result[i].fromWhsCode,
                    rawWastageTransferList.result[i].fromWhsName,
                    rawWastageTransferList.result[i].toWhsCode,
                    rawWastageTransferList.result[i].toWhsName,
                    rawWastageTransferList.result[i].type,
                    rawWastageTransferList.result[i].itemCode,
                    rawWastageTransferList.result[i].itemName,
                    rawWastageTransferList.result[i].qty,
                    rawWastageTransferList.result[i].uOM,
                    rawWastageTransferList.result[i].reasonCode,
                    rawWastageTransferList.result[i].reasonName, rawWastageTransferList.result[i].isTransfer,
                    rawWastageTransferList.result[i].createdBy, rawWastageTransferList.result[i].createdDate,
                    rawWastageTransferList.result[i].modifiedBy,
                    rawWastageTransferList.result[i].modifiedDate,
                    rawWastageTransferList.result[i].uniqDocNo,
                    rawWastageTransferList.result[i].taxCode,
                    rawWastageTransferList.result[i].price, rawWastageTransferList.result[i].ammount,
                    rawWastageTransferList.result[i].taxAmt,'0'));
          }
          loading = false;
        });
      }

    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> updateinsert() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    print(jsonEncode(secWastageTransferList));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'recivewastage'),
        body: jsonEncode(secWastageTransferList),
        headers: headers);


    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["SatausMesg"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["SatausMesg"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);

            if(jsonDecode(response.body)["result"][0]["Status"]=="0"){

            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WastageRecive(),
                ),
              );
            }

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }


}

class WastageTransferList {
  var docNo;
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
  String modifiedBy;
  String modifiedDate;
  var uniqDocNo;
  String taxCode;
  String price;
  String ammount;
  String taxAmt;
  String TransferQty;

  WastageTransferList(
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
      this.uniqDocNo,
      this.taxCode,
      this.price,
      this.ammount,
      this.taxAmt,this.TransferQty);

  Map<String, dynamic> toJson() => {
    'FromLocation': '0',
    'FromWhsCode': fromWhsCode,
    'ItemCode': itemCode,
    'ItemName': itemName,
    'TransferQty': qty,
    'FromWhsName': fromWhsName,
    'ReciveQty': TransferQty,
    'Recvwhscode': '',
    'CreateBy': sessionuserID,
    'RefNumber': uniqDocNo,
    'SapStatus': '0',
  };
}
