// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/OSRDModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OSRDMaster extends StatefulWidget {
  const OSRDMaster({Key key}) : super(key: key);

  @override
  _OSRDMasterState createState() => _OSRDMasterState();
}

class _OSRDMasterState extends State<OSRDMaster> {
  TextEditingController Edt_Remarks = new TextEditingController();
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  bool loading = false;
  OSRDModel detailitems;
  LocationModel locationModel = new LocationModel();
  OccModel occModel = new OccModel();

  LocationResult test;
  Result Additem;

  String alterocccode = '';
  String alterocccname = '';
  String alterloccode = '';
  String alterlocname = '';
  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;
  List<selectType> SecselectType = new List();
  var Edt_Type = new TextEditingController();

  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocationval();

    print(detailitems.toString());

    SecselectType.addAll([
      selectType('O', 'Occation'),
      selectType('S', 'Shape'),
      selectType('R', 'Reason'),
      selectType('D', 'Distribution'),
    ]);
    for (int i = 0; i < SecselectType.length; i++) {
      occ.add(SecselectType[i].Description);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var tablet = data.size.shortestSide < 600 ? false : true;
    print(tablet);
    print(data.size.shortestSide);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return !tablet
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("OSRD MASTER"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                  new Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: width,
                                      color: Colors.white,
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: loc,
                                        label: "Select Location",
                                        onChanged: (val) {
                                          print(val);
                                          for (int kk = 0;
                                              kk < locationModel.result.length;
                                              kk++) {
                                            if (locationModel.result[kk].name ==
                                                val) {
                                              print(locationModel
                                                  .result[kk].code);
                                              alterlocname =
                                                  locationModel.result[kk].name;
                                              alterloccode = locationModel
                                                  .result[kk].code
                                                  .toString();
                                            }
                                          }
                                        },
                                        selectedItem: alterlocname,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Row(
                                children: [
                                  new Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: TextField(
                                        enabled: true,
                                        readOnly: true,
                                        controller: Edt_Type,
                                        textInputAction: TextInputAction.go,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Receive Type",
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () {
                                          print('dfv');
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text('Choose The Type..'),
                                                content: Container(
                                                  width: double.minPositive,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        SecselectType.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ListTile(
                                                        title: Text(
                                                            SecselectType[index]
                                                                .Description),
                                                        onTap: () {
                                                          setState(() {
                                                            Edt_Type.text =
                                                                SecselectType[
                                                                        index]
                                                                    .Description;
                                                            alterocccname =
                                                                SecselectType[
                                                                        index]
                                                                    .Description
                                                                    .toString();
                                                            alterocccode =
                                                                SecselectType[
                                                                        index]
                                                                    .Code;
                                                            //GetMatrialName();
                                                          });
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Row(
                                children: [
                                  new Expanded(
                                    flex: 7,
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: TextField(
                                          /*maxLines: 5,*/
                                          controller: Edt_Remarks,
                                          decoration: InputDecoration(
                                            labelText: "Remarks",
                                            hintText: "Enter Remarks",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  /*Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.add)))*/
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print('openpo');
                                        if (alterocccname == '') {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Choose Sales Person");
                                        }

                                        // if (!isUpdating) {
                                        //   print('Insert');
                                        //   postdataheader();
                                        // } else {
                                        //   postdataupdate(docno, updatestatus);
                                        //   print('updatemode');
                                        // }
                                      },
                                      child:
                                          Text(isUpdating ? 'UPDATE' : 'ADD'),
                                      //child: Text('Add'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: detailitems.toString() == "null"
                                        ? Center(
                                            child: Text('No Data Add!'),
                                          )
                                        : DataTable(
                                            sortColumnIndex: 0,
                                            sortAscending: true,
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                    Pallete.mycolor),
                                            showCheckboxColumn: false,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Active/InActive',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Location',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Description',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            rows: detailitems.result
                                                .map(
                                                  (list) => DataRow(cells: [
                                                    DataCell(
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons.create),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            setState(() {
                                                              isUpdating = true;
                                                            });
                                                            Edt_Remarks.text =
                                                                list.remarks;
                                                            alterlocname = "";
                                                            alterloccode = "";
                                                            alterocccode = "";
                                                            alterocccname = "";
                                                            Edt_Type.text = '';
                                                            alterlocname = list
                                                                .locationName;
                                                            alterloccode = list
                                                                .locationCode;
                                                            alterocccode =
                                                                list.occCode;
                                                            alterocccname =
                                                                list.occName;
                                                            Edt_Type.text =
                                                                list.occName;
                                                            docno = list.docNo;
                                                            updatestatus =
                                                                list.status;
                                                          }),
                                                    ),
                                                    DataCell(
                                                      Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                            onPressed: () {
                                                              updateOSRD(
                                                                  context,
                                                                  list.docNo,
                                                                  list.status);
                                                            },
                                                            child: Text((list
                                                                        .status ==
                                                                    0
                                                                ? 'Click to Disable'
                                                                : 'Click to Enable')),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    DataCell(Text(
                                                        list.locationName
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left)),
                                                    DataCell(
                                                      Text(
                                                          list.remarks
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left),
                                                    ),
                                                  ]),
                                                )
                                                .toList(),
                                          ),
                                  ),
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
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("OSRD MASTER"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: width,
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                                          new Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              child: DropdownSearch<String>(
                                                mode: Mode.DIALOG,
                                                showSearchBox: true,
                                                items: loc,
                                                label: "Select Location",
                                                onChanged: (val) {
                                                  print(val);
                                                  for (int kk = 0;
                                                      kk <
                                                          locationModel
                                                              .result.length;
                                                      kk++) {
                                                    if (locationModel
                                                            .result[kk].name ==
                                                        val) {
                                                      print(locationModel
                                                          .result[kk].code);
                                                      alterlocname =
                                                          locationModel
                                                              .result[kk].name;
                                                      alterloccode =
                                                          locationModel
                                                              .result[kk].code
                                                              .toString();
                                                    }
                                                  }
                                                },
                                                selectedItem: alterlocname,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        //Use of SizedBox
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          new Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              child: DropdownSearch<String>(
                                                //mode of dropdown
                                                mode: Mode.DIALOG,
                                                //to show search box
                                                showSearchBox: true,

                                                items: occ,
                                                label:
                                                    "Select Occation/Shape/Reason/Distribution",
                                                onChanged: (val) {
                                                  print(val);
                                                  for (int kk = 0;
                                                      kk < SecselectType.length;
                                                      kk++) {
                                                    if (SecselectType[kk]
                                                            .Description ==
                                                        val) {
                                                      print(SecselectType[kk]
                                                          .Description);
                                                      alterocccname =
                                                          SecselectType[kk]
                                                              .Description;
                                                      alterocccode =
                                                          SecselectType[kk]
                                                              .Code
                                                              .toString();
                                                    }
                                                  }
                                                },
                                                selectedItem: alterocccname,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        //Use of SizedBox
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          new Expanded(
                                            flex: 7,
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: TextField(
                                                  /*maxLines: 5,*/
                                                  controller: Edt_Remarks,
                                                  decoration: InputDecoration(
                                                    labelText: "Remarks",
                                                    hintText: "Enter Remarks",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        //Use of SizedBox
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FloatingActionButton.extended(
                                            backgroundColor: Colors.red,
                                            icon: Icon(Icons.clear),
                                            label: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          FloatingActionButton.extended(
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            icon: Icon(Icons.check),
                                            label: Text(
                                                isUpdating ? 'UPDATE' : 'ADD'),
                                            onPressed: () {
                                              if (alterlocname == '') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Choose Location");
                                              } else if (alterocccname == '') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Choose Occation");
                                              } else if (Edt_Remarks.text ==
                                                  '') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter  Description");
                                              } else {
                                                print('SAve');
                                                if (!isUpdating) {
                                                  print('Insert');
                                                  postdataheader();
                                                } else {
                                                  postdataupdate(
                                                      docno, updatestatus);
                                                  print('updatemode');
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: width,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child:
                                              detailitems.toString() == "null"
                                                  ? Center(
                                                      child:
                                                          Text('No Data Add!'),
                                                    )
                                                  : DataTable(
                                                      sortColumnIndex: 0,
                                                      sortAscending: true,
                                                      headingRowColor:
                                                          MaterialStateProperty
                                                              .all(Pallete
                                                                  .mycolor),
                                                      showCheckboxColumn: false,
                                                      columns: const <
                                                          DataColumn>[
                                                        DataColumn(
                                                          label: Text(
                                                            'Edit',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                            'Active/InActive',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                            'Location',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                            'Description',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                      rows: detailitems.result
                                                          .map(
                                                            (list) => DataRow(
                                                                cells: [
                                                                  DataCell(
                                                                    Center(
                                                                      child:
                                                                          Center(
                                                                        child: IconButton(
                                                                            icon: Icon(Icons.create),
                                                                            color: Colors.red,
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                isUpdating = true;
                                                                              });
                                                                              Edt_Remarks.text = list.remarks;
                                                                              alterlocname = "";
                                                                              alterloccode = "";
                                                                              alterocccode = "";
                                                                              alterocccname = "";

                                                                              alterlocname = list.locationName;
                                                                              alterloccode = list.locationCode;
                                                                              alterocccode = list.occCode;
                                                                              alterocccname = list.occName;
                                                                              docno = list.docNo;
                                                                              updatestatus = list.status;
                                                                            }),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Center(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Wrap(
                                                                          direction:
                                                                              Axis.vertical, //default
                                                                          alignment:
                                                                              WrapAlignment.center,
                                                                          children: [
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(primary: list.status == 0 ? Colors.greenAccent : Colors.redAccent,textStyle: TextStyle(color: Colors.white)),
                                                                              onPressed: () {
                                                                                updateOSRD(context, list.docNo, list.status);
                                                                              },
                                                                              child: Text(
                                                                                (list.status == 0 ? 'Click to Disable' : 'Click to Enable'),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DataCell(Wrap(
                                                                      direction:
                                                                          Axis.vertical, //default
                                                                      alignment: WrapAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                            list.locationName
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.left)
                                                                      ])),
                                                                  DataCell(
                                                                    Center(
                                                                        child:
                                                                            Wrap(
                                                                                direction: Axis.vertical, //default
                                                                                alignment: WrapAlignment.center,
                                                                                children: [
                                                                          Text(
                                                                              list.remarks.toString(),
                                                                              textAlign: TextAlign.center)
                                                                        ])),
                                                                  ),
                                                                ]),
                                                          )
                                                          .toList(),
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
                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
          );
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        setState(() {
          isUpdating = false;
        });
      } else {
        /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => OSRDMaster()));*/
      }
    }
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
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(AppConstants.LIVE_URL + 'getOSRDMaster'),
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
        //detailitems.result.clear();
      } else {
        detailitems = OSRDModel.fromJson(jsonDecode(response.body));

        print(detailitems);
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getlocationval() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse(AppConstants.LIVE_URL + 'getLocation'),
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
        locationModel.result.clear();
        loc.clear();
      } else {
        locationModel = LocationModel.fromJson(jsonDecode(response.body));
        loc.clear();
        for (int k = 0; k < locationModel.result.length; k++) {
          loc.add(locationModel.result[k].name);
        }

        print(locationModel);
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> updateOSRD(
      BuildContext context, int docno, int status) async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "DocNo": docno,
      "Status": status == 0 ? 1 : 0,
    };

    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'updateOSRD'),
        headers: headers,
        body: jsonEncode(body));
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
        Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => OSRDMaster()));
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> postdataupdate(int docno, int updatestatus) async {
    var headers = {"Content-Type": "application/json"};
    var body = {
      "LocCode": alterloccode,
      "LocName": alterlocname,
      "OccCode": '${alterocccode}',
      "OccName": '${alterocccname}',
      "Remarks": '${Edt_Remarks.text}',
      "Status": '${updatestatus}',
      "UserID": '${sessionuserID}',
      "DocNo": '${docno}'
    };
    print(sessionuserID);
    setState(() {
      loading = true;
    });

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'updateAllOSRD'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => OSRDMaster()));
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> postdataheader() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {
      "LocCode": alterloccode,
      "LocName": alterlocname,
      "OccCode": '${alterocccode}',
      "OccName": '${alterocccname}',
      "Remarks": '${Edt_Remarks.text}',
      "UserID": '${sessionuserID}'
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'insertOSRD'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          print(jsonDecode(response.body)['status'] = 1);
          Fluttertoast.showToast(msg: jsonDecode(response.body)['result']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => OSRDMaster()));
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }
}

Widget _customPopupItemBuilderExample2(
    BuildContext context, LocationResult item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text('${item.name}' ?? ''),
      /*subtitle: Text('Code : ${item.code.toString()}' ?? ''),*/
    ),
  );
}

Widget _customPopupItemBuilderOcc(
    BuildContext context, OccResult item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text('Name : ${item.occName}' ?? ''),
      subtitle: Text('Code : ${item?.occCode}'?.toString() ?? ''),
    ),
  );
}

class selectType {
  var Code;
  var Description;
  selectType(this.Code, this.Description);
}
