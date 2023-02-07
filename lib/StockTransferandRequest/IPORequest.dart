import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class IPORequest extends StatefulWidget {
  const IPORequest({Key key}) : super(key: key);

  @override
  _IPORequestState createState() => _IPORequestState();
}

class _IPORequestState extends State<IPORequest> {
  bool typevisible = false;
  bool typevisible1 = false;
  int _value = 1;
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: Text('IPO Request'),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  children: [
                    //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          enabled: false,
                          onSubmitted: (value) {
                            print("Onsubmit,${value}");
                          },
                          decoration: InputDecoration(
                            labelText: "IPO No",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          enabled: false,
                          onSubmitted: (value) {
                            print("Onsubmit,${value}");
                          },
                          decoration: InputDecoration(
                            labelText: "IPO Date",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
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
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  hintText: "From Location",
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_drop_down_circle),
                                  ),
                                ),
                                controller: this._typeAheadController),
                            suggestionsCallback: (pattern) async {
                              Completer<List<String>> completer =
                                  new Completer();
                              completer
                                  .complete(<String>["Location1", "Location2"]);
                              return completer.future;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                  title: Text(suggestion.toString()));
                            },
                            onSuggestionSelected: (suggestion) {
                              if (suggestion.toString().contains("Select")) {
                              } else {
                                this._typeAheadController.text =
                                    suggestion.toString();

                                setState(() {
                                  if (suggestion
                                      .toString()
                                      .contains("Employee")) {
                                    typevisible = true;
                                    typevisible1 = false;
                                  } else {
                                    typevisible = false;
                                    typevisible1 = true;
                                  }
                                });
                              }
                            }),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  hintText: "To Location",
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_drop_down_circle),
                                  ),
                                ),
                                controller: this._typeAheadController),
                            suggestionsCallback: (pattern) async {
                              Completer<List<String>> completer =
                                  new Completer();
                              completer
                                  .complete(<String>["Location1", "Location2"]);
                              return completer.future;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                  title: Text(suggestion.toString()));
                            },
                            onSuggestionSelected: (suggestion) {
                              if (suggestion.toString().contains("Select")) {
                              } else {
                                this._typeAheadController.text =
                                    suggestion.toString();

                                setState(() {
                                  if (suggestion
                                      .toString()
                                      .contains("Employee")) {
                                    typevisible = true;
                                    typevisible1 = false;
                                  } else {
                                    typevisible = false;
                                    typevisible1 = true;
                                  }
                                });
                              }
                            }),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('S.No'),
                      ),
                      DataColumn(
                        label: Text('Item Name'),
                      ),
                      DataColumn(
                        label: Text('Ord.Qty'),
                      ),
                      DataColumn(
                        label: Text('UOM'),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Data')),
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
                          DataCell(Text('Data')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Data')),
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
                          DataCell(Text('Data')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
