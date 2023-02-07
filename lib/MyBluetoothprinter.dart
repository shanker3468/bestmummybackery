import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MyBluetoothPrinter extends StatefulWidget {
  const MyBluetoothPrinter({Key key}) : super(key: key);

  @override
  MyBluetoothPrinterState createState() => MyBluetoothPrinterState();
}

class MyBluetoothPrinterState extends State<MyBluetoothPrinter> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  NetworkPrinter printer;
  var BillCurrentDate;
  var BillCurrentTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    initSavetoPath();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'logo.jpg';
    var bytes = await rootBundle.load("assets/logo.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      //show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  final pagecontroller = PageController(
    initialPage: 0,
  );

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Setting'),
      ),
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
                            flex: 2,
                            child: Container(
                              child: DropdownButton(
                                items: _getDeviceItems(),
                                onChanged: (value) =>
                                    setState(() => _device = value),
                                value: _device,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.brown),
                                onPressed: () {
                                  initPlatformState();
                                },
                                child: Text(
                                  'Refresh',
                                  style: TextStyle(color: Colors.white),
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        _connected ? Colors.red : Colors.green),
                                onPressed: _connected ? _disconnect : _connect,
                                child: Text(
                                  _connected ? 'Disconnect' : 'Connect',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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
                onPageChanged: (page) => {
                  print(
                    page.toString(),
                  ),
                },
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
                            flex: 2,
                            child: Container(
                              child: DropdownButton(
                                items: _getDeviceItems(),
                                onChanged: (value) =>
                                    setState(() => _device = value),
                                value: _device,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.brown),
                                onPressed: () {
                                  initPlatformState();
                                },
                                child: Text(
                                  'Refresh',
                                  style: TextStyle(color: Colors.white),
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        _connected ? Colors.red : Colors.green),
                                onPressed: _connected ? _disconnect : _connect,
                                child: Text(
                                  _connected ? 'Disconnect' : 'Connect',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
