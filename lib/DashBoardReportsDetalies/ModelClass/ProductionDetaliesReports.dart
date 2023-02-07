// ignore_for_file: non_constant_identifier_names, deprecated_member_use, unnecessary_brace_in_string_interps, missing_return, unused_local_variable, unrelated_type_equality_checks, equal_keys_in_map, camel_case_types, must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/DashBoardReportsDetalies/ModelClass/ProductionModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductionDetaliesReports extends StatefulWidget {
  ProductionDetaliesReports({Key key, this. LocatinId, this. LocationName,this.FromDate,this.ToDate,this.fromid}) : super(key: key);
  var LocatinId="";
  var LocationName="";
  var FromDate="";
  var ToDate="";
  int fromid=0;
  @override
  _ProductionDetaliesReportsState createState() => _ProductionDetaliesReportsState();
}


class _ProductionDetaliesReportsState extends State<ProductionDetaliesReports> {
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
  ProductionModel rawProductionModel;
  List<LocatioDesList> secLocatioDesList = new List();
  List<GroupList> secGroupList = new List();
  List<FulterType> felttertype = new List();

  double production=0;
  double dispatched=0;

  @override
  void initState() {
    _fromdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _todate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    felttertype.addAll(
        [
          FulterType(1, 'ItemName'),
          FulterType(2, 'Group Name'),
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
              title: Text('Production'),

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
            title: Text('Production  Reports'),
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
                                production=0;
                                dispatched=0;
                                secLocatioDesList.clear();
                                for(int i=0; i < rawProductionModel.testdata.length;i++){
                                  if(
                                  FulterCode==1? rawProductionModel.testdata[i].itemName.toString().toUpperCase().contains(data.toString().toUpperCase()):
                                  FulterCode==2? rawProductionModel.testdata[i].groupName.toString().toUpperCase().contains(data.toString().toUpperCase()):
                                  rawProductionModel.testdata[i].itemName.toString().toUpperCase().contains(data.toString().toUpperCase())
                                  ){
                                        secLocatioDesList.add(
                                          LocatioDesList(
                                              rawProductionModel.testdata[i].itemCode,
                                              rawProductionModel.testdata[i].itemName,
                                              rawProductionModel.testdata[i].uom,
                                              rawProductionModel.testdata[i].groupName,
                                              rawProductionModel.testdata[i].productionQty,
                                              rawProductionModel.testdata[i].despatchedQty,
                                              rawProductionModel.testdata[i].remaining,
                                              rawProductionModel.testdata[i].totalStock),

                                    );
                                    production += double.parse(rawProductionModel.testdata[i].productionQty.toString());
                                    dispatched += double.parse(rawProductionModel.testdata[i].despatchedQty.toString());
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
                          width: width/1.1,
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
                                    label: Text('ItemName',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Group Name',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Prod Qty',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Des Qty',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Remaining',style: TextStyle(color: Colors.white),),
                                  ),
                                  DataColumn(
                                    label: Text('Stock',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                                rows: secLocatioDesList.map((list) =>
                                    DataRow(cells: [

                                      DataCell(
                                        Text(list.itemName.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.groupName.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.productionQty.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.despatchedQty.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.remaining.toString(),
                                            textAlign: TextAlign.center),
                                      ),
                                      DataCell(
                                        Text(list.totalStock.toString(),
                                            textAlign: TextAlign.center),
                                      ),

                                    ]),)
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   width: width/3.2,
                        //   color: Colors.pinkAccent,
                        // ),
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
                  label: Text('Total Dispatch'),
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
                  label: Text(dispatched.toStringAsFixed(2)),
                  onPressed: (){},
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  heroTag: "Cancel",
                  backgroundColor: Colors.black12,
                  label: Text('Total Production'),
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
                  label: Text(production.toStringAsFixed(2)),
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
        Uri.parse(AppConstants.LIVE_URL + 'getproduvsdespatchreports'),
        headers: headers,
        body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        rawProductionModel = ProductionModel.fromJson(jsonDecode(response.body));
        for(int i=0; i < rawProductionModel.testdata.length;i++){
          production += double.parse(rawProductionModel.testdata[i].productionQty.toString());
          dispatched += double.parse(rawProductionModel.testdata[i].despatchedQty.toString());
          secLocatioDesList.add(
              LocatioDesList(
                  rawProductionModel.testdata[i].itemCode,
                  rawProductionModel.testdata[i].itemName,
                  rawProductionModel.testdata[i].uom,
                  rawProductionModel.testdata[i].groupName,
                  rawProductionModel.testdata[i].productionQty,
                  rawProductionModel.testdata[i].despatchedQty,
                  rawProductionModel.testdata[i].remaining,
                  rawProductionModel.testdata[i].totalStock),
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
  String itemCode;
  String itemName;
  String uom;
  String groupName;
  var productionQty;
  var despatchedQty;
  var remaining;
  var totalStock;

  LocatioDesList(
      this.itemCode,
      this.itemName,
      this.uom,
      this.groupName,
      this.productionQty,
      this.despatchedQty,
      this.remaining,
      this.totalStock);


}





