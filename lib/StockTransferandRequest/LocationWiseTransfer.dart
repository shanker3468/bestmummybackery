import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocationWiseTransfer extends StatefulWidget {
  const LocationWiseTransfer({Key key}) : super(key: key);

  @override
  _LocationWiseTransferState createState() => _LocationWiseTransferState();
}

class _LocationWiseTransferState extends State<LocationWiseTransfer> {
  bool typevisible = false;
  bool typevisible1 = false;
  int _value = 1;
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: Text('Location Wise Request'),
          ),
          backgroundColor: Colors.white,
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('Location'),
                    ),
                    DataColumn(
                      label: Text('Stock'),
                    ),
                    DataColumn(
                      label: Text('Re.Qty'),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Data')),
                        DataCell(Text('Data')),
                        DataCell(Text('Data')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Data')),
                        DataCell(Text('Data')),
                        DataCell(Text('Data')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Data')),
                        DataCell(Text('Data')),
                        DataCell(Text('Data')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          persistentFooterButtons: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  child: Text("Cancel".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () => null),
              SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red, width: 2.0)))),
                child: Text('Save'),
                onPressed: () {},
              ),
            ])
          ],
        ),
      ),
    );
  }
}
