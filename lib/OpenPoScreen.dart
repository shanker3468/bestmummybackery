import 'dart:convert';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/OpenPOHeaderModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpenPoScreen extends StatefulWidget {
  String cardcode;
  OpenPoScreen({Key key, this.cardcode}) : super(key: key);

  @override
  _OpenPoScreenState createState() => _OpenPoScreenState();
}

class _OpenPoScreenState extends State<OpenPoScreen> {
  OpenPOHeaderModel li2;
  static List<OpenPOResultSearch> li3 = new List();
  TextEditingController searchcontroller = new TextEditingController();

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  bool loading = false;
  @override
  void initState() {
    print(this.widget.cardcode);
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          body: loading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    child: Column(
                      children: [
                        Card(
                          child: new ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                              controller: searchcontroller,
                              decoration: new InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  if (li2 != null) {
                                    li3.clear();
                                    for (int k = 0; k < li2.result.length; k++)
                                      if (li2.result[k].pONo
                                              .toString()
                                              .toLowerCase()
                                              .contains(value) ||
                                          li2.result[k].cardName
                                              .toString()
                                              .toLowerCase()
                                              .contains(value))
                                        li3.add(OpenPOResultSearch(
                                            li2.result[k].pONo,
                                            li2.result[k].pOEntry,
                                            li2.result[k].pODate,
                                            li2.result[k].cardCode,
                                            li2.result[k].cardName));
                                  }
                                });
                              },
                            ),
                            trailing: new IconButton(
                              icon: new Icon(Icons.cancel),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.all(5.0),
                          scrollDirection: Axis.horizontal,
                          child: li3 != null
                              ? DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.all(Colors.red),
                                  showCheckboxColumn: false,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'PO No',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'PoDate',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Customer Name',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                  rows: li3
                                      .map(
                                        (list) => DataRow(
                                            onSelectChanged: (value) {
                                              if (value == true) {
                                                //String key = values.keys.elementAt(index);
                                                Navigator.pop(
                                                    context, list.pOEntry);
                                              }
                                            },
                                            cells: [
                                              DataCell(Center(
                                                  child: Center(
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(list.pONo.toString(),
                                                          textAlign:
                                                              TextAlign.center)
                                                    ]),
                                              ))),
                                              DataCell(Center(
                                                  child: Center(
                                                child: Wrap(
                                                    direction:
                                                        Axis.vertical, //default
                                                    alignment:
                                                        WrapAlignment.center,
                                                    children: [
                                                      Text(list.pODate,
                                                          textAlign:
                                                              TextAlign.center)
                                                    ]),
                                              ))),
                                              DataCell(
                                                Text(list.cardName.toString(),
                                                    textAlign: TextAlign.left),
                                              ),
                                            ]),
                                      )
                                      .toList(),
                                )
                              : Container(
                                  child: Center(
                                    child: Text('No Data'),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
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
      getpendingapprovallist();
    });
  }

  Future<http.Response> getpendingapprovallist() async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 1,
      "UserID": sessionuserID,
      "BranchID": int.parse(sessionbranchcode),
      "PoEntry": 0,
      "CardCode": this.widget.cardcode,
    };
    setState(() {
      loading = true;
    });
    print(body);
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'OpenPO'),
        body: jsonEncode(body),
        headers: headers);
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
        li2 = null;
        li3.clear();
      } else {
        li2 = OpenPOHeaderModel.fromJson(jsonDecode(response.body));
        li3.clear();
        for (int k = 0; k < li2.result.length; k++) {
          li3.add(OpenPOResultSearch(
              li2.result[k].pOEntry,
              li2.result[k].pONo,
              li2.result[k].pODate,
              li2.result[k].cardCode,
              li2.result[k].cardName));
        }
        // print(li2.result.length);

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
}
