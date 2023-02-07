// ignore_for_file: non_constant_identifier_names, missing_return

import 'dart:convert';
import 'dart:typed_data';

import 'package:bestmummybackery/MyBluetoothprinter.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkPrinterList extends StatefulWidget {
  const NetworkPrinterList({Key key}) : super(key: key);

  @override
  _NetworkPrinterListState createState() => _NetworkPrinterListState();
}

class _NetworkPrinterListState extends State<NetworkPrinterList> {
  String colorchange = "";
  String selectedDate = "";
  var TextClicked;
  //Session
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  // printer Session

  TextEditingController _SaleIpAddress = new TextEditingController();
  TextEditingController _SalePortNo = new TextEditingController();
  TextEditingController _QRCodeGenerator = new TextEditingController();
  TextEditingController _QRCodePortNo = new TextEditingController();
  TextEditingController _KOTIpAddress = new TextEditingController();
  TextEditingController _KOTPortNo = new TextEditingController();
  TextEditingController _KOTKitchenIpAddress = new TextEditingController();
  TextEditingController _KOTKitchenPortNo = new TextEditingController();

  // End printer Session
  // End Session
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
  int onclick = 0;
  var altercountrycode = "";
  var alterstatecode = "";
  var altercareofcode = "";
  var altercareofname = "";

  // PRINTER VARIBLE

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];

  String pathImage = '';
  NetworkPrinter printer;
  var BillCurrentDate;
  var BillCurrentTime;
  MyBluetoothPrinter MyPrinter;

  List<Map<String, dynamic>> devices = [];
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;

  @override
  void initState() {
    //scanNetwork();
    //printIps();
    getStringValuesSF();
    //_getDevicelist();
    //initSavetoPath();
    //initPlatformState();
    super.initState();
  }

  _getDevicelist() async {
    List<Map<String, dynamic>> results = [];
    results = await FlutterUsbPrinter.getUSBDeviceList();

    print(" length: ${results.length}");
    setState(() {
      devices = results;
    });
  }

  _connect(int vendorId, int productId) async {
    bool returned = false;
    try {
      returned = await flutterUsbPrinter.connect(vendorId, productId);
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
    if (returned) {
      setState(() {
        connected = true;
      });
    }
  }

  _print() async {
    try {
      var data = Uint8List.fromList(
          utf8.encode(" Hello world Testing ESC POS printer..."));
      await flutterUsbPrinter.write(data);
      // await FlutterUsbPrinter.printRawData("text");
      // await FlutterUsbPrinter.printText("Testing ESC POS printer...");
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
  }

  NetPrinter(
    String iPAddress,
    int pORT,
  ) async {
    PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    printer = NetworkPrinter(paper, profile);
    try {
      PosPrintResult res = await printer.connect(iPAddress, port: pORT);
      if (res == PosPrintResult.success) {
        printer.disconnect();
      }
    } on Exception catch (e) {
      print('Print result: $e');
      // TODO
    }
  }

//   initSavetoPath() async {
//     //read and write
//     //image max 300px X 300px
//     final filename = 'logo.jpg';
//     var bytes = await rootBundle.load("assets/logo.jpg");
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     writeToFile(bytes, '$dir/$filename');
//     setState(() {
//       pathImage = '$dir/$filename';
//     });
//   }
//
//   Future<void> initPlatformState() async {
//     bool isConnected = await bluetooth.isConnected;
//     List<BluetoothDevice> devices = [];
//     try {
//       devices = await bluetooth.getBondedDevices();
//     } on PlatformException {
//       // TODO - Error
//     }
//
//     bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BlueThermalPrinter.CONNECTED:
//           setState(() {
//             print("bluetooth device state: connected");
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECTED:
//           setState(() {
//             print("bluetooth device state: disconnected");
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECT_REQUESTED:
//           setState(() {
//             print("bluetooth device state: disconnect requested");
//           });
//           break;
//         case BlueThermalPrinter.STATE_TURNING_OFF:
//           setState(() {
//             print("bluetooth device state: bluetooth turning off");
//           });
//           break;
//         case BlueThermalPrinter.STATE_OFF:
//           setState(() {
//             print("bluetooth device state: bluetooth off");
//           });
//           break;
//         case BlueThermalPrinter.STATE_ON:
//           setState(() {
//             print("bluetooth device state: bluetooth on");
//           });
//           break;
//         case BlueThermalPrinter.STATE_TURNING_ON:
//           setState(() {
//             print("bluetooth device state: bluetooth turning on");
//           });
//           break;
//         case BlueThermalPrinter.ERROR:
//           setState(() {
//             print("bluetooth device state: error");
//           });
//           break;
//         default:
//           print(state);
//           break;
//       }
//     });
//
//     if (!mounted) return;
//     setState(() {
//       _devices = devices;
//     });
//
//     if (isConnected) {
//       setState(() {});
//     }
//   }
//
//   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//     List<DropdownMenuItem<BluetoothDevice>> items = [];
//     if (_devices.isEmpty) {
//       items.add(DropdownMenuItem(
//         child: Text('NONE'),
//       ));
//     } else {
//       _devices.forEach((device) {
//         items.add(DropdownMenuItem(
//           child: Text(device.name),
//           value: device,
//         ));
//       });
//     }
//     return items;
//   }
//
// //write to app path
//   Future<void> writeToFile(ByteData data, String path) {
//     final buffer = data.buffer;
//     return new File(path).writeAsBytes(
//         buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!tablet) {
      // SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Printer Setting"),
        ),
        body: Center(
          child: tablet
              ? Container(
                  color: Colors.white,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width / 2,
                          height: height,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height/10,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _SaleIpAddress,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Ip Address",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _SalePortNo,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Port No",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                              "SaleInvoiceIP",
                                              _SaleIpAddress.text,
                                            );
                                            prefs.setString(
                                              "SaleInvoicePort",
                                              _SalePortNo.text,
                                            );
                                            getStringValuesSF();
                                          },
                                          child: Text('Sale Inv'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _QRCodeGenerator,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Ip Address",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _QRCodePortNo,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Port No",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.pinkAccent),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString("QR-CodeIP",
                                                _QRCodeGenerator.text);
                                            prefs.setString("QR-CodePORT",
                                                _QRCodePortNo.text);
                                            getStringValuesSF();
                                          },
                                          child: Text('QR-Code'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTIpAddress,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Ip Address",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTPortNo,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "KOT Port No",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.redAccent),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                              "KOTInvoiceIP",
                                              _KOTIpAddress.text,
                                            );
                                            prefs.setString(
                                              "KOTInvoicePort",
                                              _KOTPortNo.text,
                                            );
                                            getStringValuesSF();
                                          },
                                          child: Text('KOT'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTKitchenIpAddress,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "KOT Kitchen",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 50,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTKitchenPortNo,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "KOT Kitchen Port No",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue.shade900),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                              "KOTKitchenIP",
                                              _KOTKitchenIpAddress.text,
                                            );
                                            prefs.setString(
                                              "KOTKitchenPort",
                                              _KOTKitchenPortNo.text,
                                            );
                                            getStringValuesSF();
                                          },
                                          child: Text('Kitchen'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width / 2.5,
                          height: height,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height,
                                width: width / 3.5,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: width / 3.5,
                                      color: Colors.green,
                                      child: Text(_SaleIpAddress.text == null
                                          ? ''
                                          : _SaleIpAddress.text +
                                              "-" +
                                              _SalePortNo.text
                                        ..toString()),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 55,
                                      width: width / 3.5,
                                      color: Colors.pinkAccent,
                                      child: Text(
                                        _QRCodeGenerator.text == null
                                            ? ''
                                            : _QRCodeGenerator.text +
                                                "-" +
                                                _QRCodePortNo.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 55,
                                      width: width / 3.5,
                                      color: Colors.redAccent,
                                      child: Text(
                                        _KOTIpAddress.text == null
                                            ? ''
                                            : _KOTIpAddress.text +
                                                "-" +
                                                _KOTPortNo.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 55,
                                      width: width / 3.5,
                                      color: Colors.blue.shade900,
                                      child: Text(
                                        _KOTKitchenIpAddress.text == null
                                            ? ''
                                            : _KOTKitchenIpAddress.text +
                                                "-" +
                                                _KOTKitchenPortNo.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: devices.length > 0
                              ? ListView(
                                  scrollDirection: Axis.vertical,
                                  children: _buildList(devices),
                                )
                              : Container(),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  color: Colors.white,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 1.5,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _SaleIpAddress,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Ip Address",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 10,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _SalePortNo,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Port No",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width / 10,
                                        height: height / 10,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                              "SaleInvoiceIP",
                                              _SaleIpAddress.text,
                                            );
                                            prefs.setString(
                                              "SaleInvoicePort",
                                              _SalePortNo.text,
                                            );
                                            getStringValuesSF();
                                          },
                                          child: Text('Sale Inv'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 50,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 1.5,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _QRCodeGenerator,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Ip Address",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _QRCodePortNo,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Port No",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width / 10,
                                        height: height / 10,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.pinkAccent),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString("QR-CodeIP",
                                                _QRCodeGenerator.text);
                                            prefs.setString("QR-CodePORT",
                                                _QRCodePortNo.text);
                                            getStringValuesSF();
                                          },
                                          child: Text('QR-Code'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 1.5,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTIpAddress,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Ip Address",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTPortNo,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "KOT Port No",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width / 10,
                                        height: height / 10,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.redAccent),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                              "KOTInvoiceIP",
                                              _KOTIpAddress.text,
                                            );
                                            prefs.setString(
                                              "KOTInvoicePort",
                                              _KOTPortNo.text,
                                            );
                                            getStringValuesSF();
                                          },
                                          child: Text('KOT'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: width / 1.5,
                                  margin: EdgeInsets.only(left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTKitchenIpAddress,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "KOT Kitchen",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: height / 8,
                                        width: width / 5.2,
                                        child: new TextField(
                                          controller: _KOTKitchenPortNo,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "KOT Kitchen Port No",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width / 10,
                                        height: height / 10,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue.shade900),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                              "KOTKitchenIP",
                                              _KOTKitchenIpAddress.text,
                                            );
                                            prefs.setString(
                                              "KOTKitchenPort",
                                              _KOTKitchenPortNo.text,
                                            );
                                            getStringValuesSF();
                                          },
                                          child: Text(
                                            'Kitchen',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width / 4.5,
                          height: height,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height,
                                width: width / 4.5,
                                child: Column(
                                  children: [
                                    Container(
                                      height: height / 8,
                                      width: width / 4.5,
                                      color: Colors.green,
                                      child: Text(_SaleIpAddress.text == null
                                          ? ''
                                          : _SaleIpAddress.text +
                                              "-" +
                                              _SalePortNo.text
                                        ..toString()),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 55,
                                      width: width / 4.5,
                                      color: Colors.pinkAccent,
                                      child: Text(
                                        _QRCodeGenerator.text == null
                                            ? ''
                                            : _QRCodeGenerator.text +
                                                "-" +
                                                _QRCodePortNo.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 55,
                                      width: width / 4.5,
                                      color: Colors.redAccent,
                                      child: Text(
                                        _KOTIpAddress.text == null
                                            ? ''
                                            : _KOTIpAddress.text +
                                                "-" +
                                                _KOTPortNo.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 55,
                                      width: width / 4.5,
                                      color: Colors.blue.shade900,
                                      child: Text(
                                        _KOTKitchenIpAddress.text == null
                                            ? ''
                                            : _KOTKitchenIpAddress.text +
                                                "-" +
                                                _KOTKitchenPortNo.text,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: devices.length > 0
                              ? ListView(
                                  scrollDirection: Axis.vertical,
                                  children: _buildList(devices),
                                )
                              : Container(),
                        )
                      ],
                    ),
                  ),
                ),
        ),
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
      _SaleIpAddress.text = prefs.getString('SaleInvoiceIP');
      _SalePortNo.text = prefs.getString('SaleInvoicePort');

      _QRCodeGenerator.text = prefs.getString('QR-CodeIP');
      _QRCodePortNo.text = prefs.getString('QR-CodePORT');

      _KOTIpAddress.text = prefs.getString('KOTInvoiceIP');
      _KOTPortNo.text = prefs.getString('KOTInvoicePort');

      _KOTKitchenIpAddress.text = prefs.getString('KOTKitchenIP');
      _KOTKitchenPortNo.text = prefs.getString('KOTKitchenPort');

      print('USERID$sessionuserID');
      print(_KOTIpAddress.text);
    });
  }

  _buildList(List<Map<String, dynamic>> devices) {
    return devices
        .map((device) => new ListTile(
              onTap: () {
                _connect(int.parse(device['vendorId']),
                    int.parse(device['productId']));
              },
              leading: new Icon(Icons.usb),
              title: new Text(
                  device['manufacturer'] + " " + device['productName']),
              subtitle:
                  new Text(device['vendorId'] + " " + device['productId']),
            ))
        .toList();
  }

  // Future printIps() async {
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //
  //   final PosPrintResult res =
  //       await printer.connect('192.168.33.250', port: 9100);
  //
  //   if (res == PosPrintResult.success) {
  //     // testReceipt(printer);
  //     printer.disconnect();
  //   } else {
  //     print('error' + res.msg);
  //   }
  // }
}
