// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_brace_in_string_interps, missing_return, unused_local_variable, unrelated_type_equality_checks, equal_keys_in_map, camel_case_types, must_be_immutable
import 'dart:convert';
import 'dart:developer';

import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/DashBoardReportsDetalies/ModelClass/LocwiseDispatch.dart';
import 'package:bestmummybackery/Model/DespatchLocationwise.dart';
import 'package:bestmummybackery/Model/Saleordertracking.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LocationwiseDespatchReports extends StatefulWidget {
  LocationwiseDespatchReports({Key key, this. LocatinId, this. LocationName,this.FromDate,this.ToDate,this.fromid}) : super(key: key);
  var LocatinId="";
  var LocationName="";
  var FromDate="";
  var ToDate="";
  int fromid=0;
  @override
  _LocationwiseDespatchReportsState createState() => _LocationwiseDespatchReportsState();
}


class _LocationwiseDespatchReportsState extends State<LocationwiseDespatchReports> {
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var sessionIPAddress = '0';
  var sessionContact1 = "";
  var sessionIPPortNo = 0;
  bool loading = false;
  DateTime dateTime = DateTime.now();
  final _fromdate = TextEditingController();
  final _todate = TextEditingController();
  final Edt_Fulter = TextEditingController();
  final Edt_Search = TextEditingController();
  int FulterCode =0;
  LocwiseDispatch rawLocwiseDispatch;
  List<LocatioDesList> secLocatioDesList = new List();
  List<GroupList> secGroupList = new List();
  List<FulterType> felttertype = new List();

  double totalAmt=0;
  double totalqty=0;

  @override
  void initState() {
    _fromdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _todate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    felttertype.addAll(
        [
          FulterType(1, 'Delivery No'),
          FulterType(2, 'ItemName'),
          FulterType(3, 'UOM'),
          FulterType(4, 'GroupName'),
          FulterType(5, 'Ammount'),
        ]
    );
    getStringValuesSF();
    super.initState();
  }
  _SelectTo(BuildContext context, formid) async {
    var _picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        if (formid == 1) {
          _fromdate.text = DateFormat('dd-MM-yyyy').format(_picked);

          setState(() {});
        }
        if (formid == 2) {

          _todate.text = DateFormat('dd-MM-yyyy').format(_picked);

        }
      });
    }
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
            child: new AppBar(
              title: Text('Despatch'),

            ),
          ),
          backgroundColor: Colors.white,
          body: !loading ? SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: height,
                  width: width/3,
                  color: Colors.blueGrey,
                )

              ],
            ),
          ) : Center(child: CircularProgressIndicator(),),
          persistentFooterButtons: [
            Container(
              height: height/22,
              child: Row(
                children: [
                  FloatingActionButton.extended(
                    heroTag: "Print",
                    backgroundColor: Colors.blue.shade700,
                    icon: Icon(Icons.clear,size: height/50,),
                    label: Text('Print',style: TextStyle(fontSize: height/60),),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ) :
      SafeArea(
        child: Scaffold(
        appBar: new AppBar(
            title: Text('Despatch Reports'),
          ),
          backgroundColor: Colors.white,
          body: !loading ? SingleChildScrollView(
            padding: EdgeInsets.all(5.0),
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: height/1.2,
              child: Column(
                children: [
                  Container(
                    width: width/1.3,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width/3,
                          child: TextField(
                            enabled: true,
                            readOnly: true,
                            controller: Edt_Fulter,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Fulter Type",border: OutlineInputBorder(),),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:Text('Choose The Type..'),
                                    content: Container(
                                      width: double.minPositive,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:felttertype.length,
                                        itemBuilder:(BuildContext context,int index) {
                                          return ListTile(
                                            title: Text(felttertype[index].Name),
                                            onTap: () {
                                              setState(() {
                                                Edt_Fulter.text =felttertype[index].Name.toString();
                                                FulterCode =felttertype[index].Id;
                                              });
                                              Navigator.pop(context,);
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
                        SizedBox(width: 5,),
                        Container(
                          width: width/3,
                          child: TextField(
                            enabled: true,
                            controller: Edt_Search,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(labelText: "Search Here",border: OutlineInputBorder(),),
                            onChanged: (data){

                              setState(() {
                                totalAmt=0;
                                totalqty=0;
                                secLocatioDesList.clear();
                                for(int i=0; i < rawLocwiseDispatch.testdata.length;i++){
                                 if(FulterCode==1? rawLocwiseDispatch.testdata[i].deliveryNo.toString().toUpperCase().contains(data.toString().toUpperCase()):
                                 FulterCode==2? rawLocwiseDispatch.testdata[i].itemName.toString().toUpperCase().contains(data.toString().toUpperCase()):
                                 FulterCode==3? rawLocwiseDispatch.testdata[i].invntryUom.toString().toUpperCase().contains(data.toString().toUpperCase()):
                                 FulterCode==4? rawLocwiseDispatch.testdata[i].groupName.toString().toUpperCase().contains(data.toString().toUpperCase()):
                                 FulterCode==5? rawLocwiseDispatch.testdata[i].ammount.toUpperCase().contains(data.toString().toUpperCase()):
                                 rawLocwiseDispatch.testdata[i].ammount.toString().toUpperCase().contains(data.toString().toUpperCase())
                                 ){
                                   secLocatioDesList.add(
                                       LocatioDesList(
                                         rawLocwiseDispatch.testdata[i].locationId,
                                         rawLocwiseDispatch.testdata[i].location,
                                         rawLocwiseDispatch.testdata[i].deliveryNo,
                                         rawLocwiseDispatch.testdata[i].itemCode,
                                         rawLocwiseDispatch.testdata[i].itemName,
                                         rawLocwiseDispatch.testdata[i].invntryUom,
                                         rawLocwiseDispatch.testdata[i].groupName,
                                         rawLocwiseDispatch.testdata[i].ammount,
                                         rawLocwiseDispatch.testdata[i].qty,
                                       )
                                   );
                                   totalAmt += double.parse(rawLocwiseDispatch.testdata[i].ammount.toString());
                                   totalqty += double.parse(rawLocwiseDispatch.testdata[i].qty.toString());
                                 }
                                }
                              });
                            },

                          ),
                        ),
                      ],
                    ),


                  ),
                  SizedBox(height: 5,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: height/1.4,
                          width: width/1.5,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: secLocatioDesList.length == 0 ? Center(child: Text('No Data Add!'),) : DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                headingRowColor: MaterialStateProperty.all(Color(0xff44a1e8)),
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text('Deliver No',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('ItemCode',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('ItemName',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Group Name',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Ammount',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Qty',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                                rows: secLocatioDesList.map((list) =>
                                    DataRow(cells: [
                                      DataCell(
                                        Text(list.deliveryNo.toString(),textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.itemCode.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.itemName.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.groupName.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.ammount.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.qty.toString(),
                                            textAlign: TextAlign.center),
                                      ),

                                    ]),)
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width/3.2,
                          color: Colors.pinkAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ) : Center(
            child: CircularProgressIndicator(),
          ),
          persistentFooterButtons: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  label: Text('Save'),
                  onPressed: () {

                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.grey,
                  label: Text('TotalQty'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  heroTag: "Save",
                  backgroundColor: Colors.grey,
                  label: Text(totalqty.toStringAsFixed(2)),
                  onPressed: (){},
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.black12,
                  label: Text('Total Amt'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  heroTag: "Save",
                  backgroundColor: Colors.black12,
                  label: Text(totalAmt.toStringAsFixed(2)),
                  onPressed: (){},
                ),

              ],
            ),
          ],
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
      sessionIPAddress = prefs.getString("SaleInvoiceIP");
      sessionIPPortNo = int.parse(prefs.getString("SaleInvoicePort"));
      sessionContact1 = prefs.getString("Contact1");
      locationwisedispatch();

    });
  }



  Future<http.Response> locationwisedispatch() async {
    double total=0;
    setState(() {
      loading = true;
      secLocatioDesList.clear();
    });
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FromId":widget.fromid,
      "Location":widget.LocatinId,
      "FromDate":widget.FromDate,
      "Todate":widget.ToDate,
      "UserId":"",
    };
    log(jsonEncode(body));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getdespatchdetaliesreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        rawLocwiseDispatch = LocwiseDispatch.fromJson(jsonDecode(response.body));
        for(int i=0; i < rawLocwiseDispatch.testdata.length;i++){
          totalAmt += double.parse(rawLocwiseDispatch.testdata[i].ammount.toString());
          totalqty += double.parse(rawLocwiseDispatch.testdata[i].qty.toString());
          secLocatioDesList.add(
              LocatioDesList(
                  rawLocwiseDispatch.testdata[i].locationId,
                  rawLocwiseDispatch.testdata[i].location,
                  rawLocwiseDispatch.testdata[i].deliveryNo,
                  rawLocwiseDispatch.testdata[i].itemCode,
                  rawLocwiseDispatch.testdata[i].itemName,
                  rawLocwiseDispatch.testdata[i].invntryUom,
                  rawLocwiseDispatch.testdata[i].groupName,
                  rawLocwiseDispatch.testdata[i].ammount,
                  rawLocwiseDispatch.testdata[i].qty,
              )
          );
        }


        // for(int j=0; j < secLocatioDesList.length;j++){
        //   if(secGroupList.isEmpty){
        //     secGroupList.add(
        //         GroupList(secLocatioDesList[j].groupName, secLocatioDesList[j].qty, secLocatioDesList[j].ammount));
        //   }else{
        //
        //
        //   }
        // }



        loading = false;
      });
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

}

class FulterType {
  int Id;
  String Name;
  FulterType(this.Id,this.Name);
}

class GroupList {
  String Code;
  var Qty;
  var Amt;
  GroupList(this.Code,this.Qty,this.Amt);
}


class LocatioDesList {
  int locationId;
  String location;
  int deliveryNo;
  String itemCode;
  String itemName;
  String invntryUom;
  String groupName;
  var ammount;
  var qty;

  LocatioDesList(
      this.locationId,
        this.location,
        this.deliveryNo,
        this.itemCode,
        this.itemName,
        this.invntryUom,
        this.groupName,
        this.ammount,this.qty);


}


class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({List<LocatioDesList> employeeData}) {
    _employeeData = employeeData.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Location', value: e.location),
      DataGridCell<String>(columnName: 'ItemName', value: e.itemName),
      DataGridCell<String>(columnName: 'UOM', value: e.invntryUom),
      DataGridCell<String>(columnName: 'Ammount', value: e.ammount),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}


