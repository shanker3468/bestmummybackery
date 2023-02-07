// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:typed_data';
import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/Model/StateModel.dart';
import 'package:bestmummybackery/Model/countryModel.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as Wingscale;
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class QRCodeGeneration extends StatefulWidget {
  QRCodeGeneration({Key key}) : super(key: key);

  @override
  QRCodeGenerationState createState() => QRCodeGenerationState();
}

class QRCodeGenerationState extends State<QRCodeGeneration> {
  bool checkedValue = false;

  bool delstatelayout = false;
  bool delstateplace = false;
  bool delstateremarks = false;
  String colorchange = "";
  List<QrGenerateJson> templist = new List();
  NetworkPrinter printer;

  TextEditingController SearchController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  TextEditingController Edt_Total = new TextEditingController();

  TextEditingController Edt_DocNo = new TextEditingController();
  TextEditingController Edt_DocDate = new TextEditingController();

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

  var TextClicked;

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var altercategoryName = "";
  var altercategorycode = "";
  var dropdownValue = "Select";
  var altertype = "";
  var qrvisible = false;
  bool loading = false;
  bool isSelected = false;
  String altersalespersoname = "";
  String altersalespersoncode = "";
  String alterpayment = "";

  String search = "";
  double batchcount = 0;
  DataTableSource _data;
  int onclick = 0;

  OccModel models;

  //DataTableSource datalist;

  var altercountrycode = "";
  var alterstatecode = "";
  var altercareofcode = "";
  var altercareofname = "";
  var CuttentDate;
  var CurrentTime;
  var jsonout;
  List<QrGenerateJson> SecQrGenerateJson = new List();

  bool connected = false;
  String pathImage;
  var sessionIPAddress = '';
  var sessionIPPortNo = 0;
  List<Map<String, dynamic>> devices = [];
  @override
  void initState() {
    getStringValuesSF();

    DateFormat.jm().format(DateTime.now());
    CuttentDate = DateFormat('MMddyyyy').format(DateTime.now());
    CurrentTime = DateFormat.jm().format(DateTime.now());
    super.initState();
  }

  int currentIndex = 0;
  CategoriesModel categoryitem;
  //QRItemModel itemodel;
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
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();

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
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
    } else {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
    }
    var assetsImage = new AssetImage('assets/imgs/splashanim.gif');
    var image = new Image(
        image: assetsImage, height: MediaQuery.of(context).size.height);
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Generate QR Code"),
        ),
        body: loading
            ? Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: new Center(
                  child: image,
                ),
              )
            : Center(
                child: tablet
                    ? Container(
                        color: Colors.white,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: salespersonmodel != null
                                      ? GridView.count(
                                          childAspectRatio: 0.7,
                                          crossAxisCount: 5,
                                          children: [
                                            for (int cat = 0; cat < salespersonmodel.result.length; cat++)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    templist.clear();
                                                    templist.add(
                                                      QrGenerateJson(
                                                            salespersonmodel.result[cat].name,
                                                            "Emp",
                                                             0,
                                                            salespersonmodel.result[cat].empID),
                                                    );


                                                    jsonout= '{ItemCode:'+templist[0].EmpCode.toString()+',UOM:'+"EMP"+',Qty:'+"0"+',RowId:'+templist[0].RowID.toString()+'}';

                                                    

                                                    qrvisible =true;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Card(
                                                    elevation: 5,
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                              radius: 30.0,
                                                              child: Center(
                                                                child:Icon(Icons.account_circle_outlined)
                                                              ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Center(
                                                                child: Text(salespersonmodel.result[cat].name, textAlign: TextAlign.center, style: TextStyle(fontSize: 10),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    salespersonmodel.result[cat].empID.toString(),
                                                                    style: TextStyle(
                                                                        color: Pallete.mycolor,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        )
                                      : Container(),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 15),
                                            width: double.infinity / 2,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.circular(15),),
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
                                                      editingController.clear();
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
                                        Container(
                                          padding: EdgeInsets.only(top: 2),
                                          height: 250,
                                          width: width,
                                          child: templist.length == 0
                                              ? Center(child: Text('No Data Add!'),) :
                                          Container(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 20,),
                                                Container(
                                                    height: 50,
                                                    width: width,
                                                    child: Text(
                                                      templist[0].EmpCode,
                                                      style: TextStyle(fontSize:height/25,fontWeight: FontWeight.w500),
                                                    )
                                                ),
                                                SizedBox(height: 20,),
                                                Container(
                                                    height: 50,
                                                    width: width,
                                                    child: Text(templist[0].RowID.toString(),
                                                      style: TextStyle(fontSize:height/25,fontWeight: FontWeight.w500),)
                                                ),
                                                SizedBox(height: 20,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          height: 250,
                                          child: Visibility(
                                            visible: qrvisible,
                                            child: QrImage(
                                              data: jsonout == false ? '0' : jsonout.toString(),
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ),
                                        )
                                      ],
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
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade700,
                icon: Icon(Icons.check),
                label: Text('Save'),
                onPressed: () {
                  setState(() {
                    _print();
                  });
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
                },
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.print),
                label: Text('Print'),
                onPressed: () {
                  setState(() {
                    GetQrPrint(sessionIPAddress, sessionIPPortNo);
                  });
                  print(sessionIPAddress);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }



  bool onWillPop() {
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
                        Navigator.pop(context);
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ]));
  }



  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      sessionIPAddress = prefs.getString("QR-CodeIP");
      sessionIPPortNo = int.parse(prefs.getString("QR-CodePORT"));

      print('USERID$sessionuserID');


      getcategories();
    });
  }

  GetQrPrint( String iPAddress, int pORT,) async {
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
      print('Print result: ${e}');
      // TODO
    }
  }



  _print() async {
    print('Print QR CODE');
    try {
      //await flutterUsbPrinter.connect(4611, 628);
      var data = "alscouqgeouqgefoiadvoihevoihqwevoihqeoifhqefv qeovbqe vqoeuvq evouqev qefv---";

      await flutterUsbPrinter.printText(data);
      printDemoReceipt(printer);
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {
    print(jsonout.toString());

    printer.qrcode(jsonout.toString(), align: PosAlign.center);
    PosColumn(text: 'Item', width: 7);

    printer.feed(1);
    printer.cut();
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
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

            salesPersonget(
                int.parse(sessionuserID), int.parse(sessionbranchcode));
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



}







class QrGenerateJson {
  var EmpCode;
  var UOM;
  var Qty;
  var RowID;

  QrGenerateJson(this.EmpCode, this.UOM, this.Qty,
       this.RowID,);
  Map toJson() => {
        'ItemCode': EmpCode,
        'UOM': UOM,
        'Qty': Qty,
        'RowId': RowID,
      };
}



class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
