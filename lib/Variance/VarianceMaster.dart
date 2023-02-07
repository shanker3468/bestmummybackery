import 'dart:convert';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/LocationModel.dart';
import 'package:bestmummybackery/Model/OSRDModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/WastageItemModel.dart';
import 'package:bestmummybackery/Variance/MOdel/GetVarianceUpdateRecord.dart';
import 'package:bestmummybackery/Variance/MOdel/VarianceMasterModel.dart';
import 'package:bestmummybackery/WastageEntry/ClosingEntry.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VarianceMaster extends StatefulWidget {
  const VarianceMaster({Key key}) : super(key: key);

  @override
  _VarianceMasterState createState() => _VarianceMasterState();
}

class _VarianceMasterState extends State<VarianceMaster> {
  TextEditingController Edt_Remarks = new TextEditingController();
  TextEditingController Edt_ProductName = TextEditingController();
  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  var alteritemcode = "";
  var alteritemName = "";
  var alteritemuom = "";
  var alteritemqty = "";
  var alterstock = "";
  int InsertFormId = 0;
  int HeaderDocNo = 0;
  int GetDocNUm = 0;
  bool loading = false;
  bool UpdateMode = false;
  int SecreeId = 0;

  var EditBum;
  var EditPeace;
  //OSRDModel detailitems;
  LocationModel locationModel = new LocationModel();
  OccModel occModel = new OccModel();

  LocationResult test;
  //Result Additem;
  static WastageItemModel ItemList;
  String alterocccode;
  String alterocccname;
  String alterloccode;
  var alterlocname;
  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;
  List<AddListItemRec> AddListItem = new List();
  List<Result> templist = new List();
  List<SendResultLine> sendtemplist = new List();
  GetVARIANCEMater RawVarianceMaster;
  List<TempVarianceMaster> SecVarianceMaster = new List();
  GetVarianceUpdateRecord RawGetVarianceUpdateRecord;

  void initState() {
    isUpdating = false;
    getStringValuesSF();
    getlocationval();
    getItem();
    //print(detailitems.toString());
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
    return tablet
        ? Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(title: Text("VARIANCE MASTER"),),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  new Expanded(
                                    flex: 4,
                                    child: Container(
                                      width: width / 3,
                                      color: Colors.white,
                                      child: DropdownSearch<String>(
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        items: loc,
                                        label: "Select Location",
                                        onChanged: (val) {
                                          print(val);
                                          for (int kk = 0;kk < locationModel.result.length;kk++) {
                                            if (locationModel.result[kk].name == val) {
                                              print(locationModel.result[kk].code);
                                              alterlocname = locationModel.result[kk].name;
                                              alterloccode = locationModel.result[kk].code.toString();
                                            }
                                          }
                                        },
                                        selectedItem: alterlocname,
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    flex: 4,
                                    child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: TypeAheadField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                                  autofocus: false,
                                                  decoration: InputDecoration(
                                                      hintText:"Select Product",
                                                      labelText:"Select Product",
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          Edt_ProductName.text ="";
                                                        },
                                                        icon: Icon(Icons.arrow_drop_down_circle),
                                                      ),
                                                      border:OutlineInputBorder()),
                                                  controller: Edt_ProductName),
                                          suggestionsCallback: (pattern) async {
                                            return await BackendService.getSuggestions(pattern);
                                            },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(title: Text(suggestion.ItemName.toString()),);
                                          },
                                          onSuggestionSelected: (suggestion) {
                                            for (int i = 0;i < ItemList.result.length;i++) {
                                              this.Edt_ProductName.text = suggestion.ItemName.toString();
                                              //GrnSpinnerController.text = suggestion.toString();
                                              if (suggestion.ItemName.toString().length >0) {
                                                //getgridItems();
                                                Edt_ProductName.text =suggestion.ItemName.toString();
                                                alteritemcode = suggestion.ItemCode.toString();
                                                alteritemName = suggestion.ItemName.toString();
                                                alteritemuom = suggestion.UOM.toString();
                                                alteritemqty = suggestion.Qty.toString();
                                                alterstock = suggestion.Stock.toString();
                                              } else {
                                                ItemList.result.clear();
                                              }
                                            }
                                            ;
                                          },
                                        )),
                                  ),

                                  new Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (UpdateMode == true) {
                                          print('Update');
                                          insertVarianceSigledetails(GetDocNUm);
                                        } else {
                                          print('Save');
                                          InserstRowIntbl(AddListItem.length);
                                        }
                                        // for (int a = 0;
                                        //     a < AddListItem.length;
                                        //     a++)

                                        // print('openpo');
                                        //
                                        // if (!isUpdating) {
                                        //   print('Insert');
                                        // } else {
                                        //   print('updatemode');
                                        // }
                                      },
                                      child: Text('ADD'),
                                      //child: Text('Add'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: AddListItem.toString() == "null"
                                        ? Center(
                                            child:
                                                Text('Add ItemCode Line Table'),
                                          )
                                        : DataTable(
                                            sortColumnIndex: 0,
                                            sortAscending: true,
                                            headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                            showCheckboxColumn: false,
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text('Edit',style: TextStyle(color: Colors.white),),
                                              ),
                                              DataColumn(
                                                label: Text('Edit',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Active/InActive',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Item Code',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Item Name',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Description',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Bun',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text('Price',style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            rows: AddListItem.map(
                                              (list) => DataRow(cells: [
                                                DataCell(
                                                  IconButton(
                                                      icon: Icon(Icons.delete),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                          AddListItem.remove(list);
                                                        });
                                                      }),
                                                ),
                                                DataCell(
                                                  IconButton(
                                                      icon: Icon(Icons.create),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        if (UpdateMode ==true) {
                                                          print('Update Ok');
                                                          setState(() {
                                                            InsertFormId = 5;
                                                          });

                                                          print(list.DocNo);
                                                          print(list.AddItemCode);
                                                          print(list.LineId);
                                                          print(list.AddBum);

                                                          postdataheader(
                                                              list.DocNo,
                                                              list.AddItemCode,
                                                              list.LineId,
                                                              list.AcInc,
                                                              list.AddBum);
                                                        } else {
                                                          print('Update NOt Ok');
                                                        }
                                                      }),
                                                ),
                                                DataCell(
                                                  Wrap(
                                                    direction:Axis.vertical, //default
                                                    alignment:WrapAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                                                        onPressed: () {
                                                          print(list.AcInc);
                                                          setState(() {
                                                            list.AcInc == 'Y'
                                                                ? list.AcInc ='N'
                                                                : list.AcInc ='Y';
                                                          });
                                                        },
                                                        child: Text((list.AcInc =='Y'
                                                            ? 'Click to Disable'
                                                            : 'Click to Enable')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                DataCell(Text(
                                                    list.AddItemCode.toString(),
                                                    textAlign: TextAlign.left)),
                                                DataCell(
                                                  Text(
                                                      list.AddItemName.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(
                                                      list.AddItemHeader.toString(),
                                                      textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                    Text(list.AddBum.toString(),textAlign:TextAlign.left),
                                                    showEditIcon: true,
                                                    onTap: () {
                                                  showDialog(context: context,
                                                    builder:(BuildContext contex) =>
                                                            AlertDialog(
                                                                content: TextFormField(
                                                                keyboardType:TextInputType.text,
                                                                onChanged: (vvv) {
                                                                EditBum = vvv;
                                                                print(EditBum);
                                                               },),
                                                              title: Text("Enter Your Packet"),
                                                              actions: <Widget>[
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              TextButton(
                                                                                onPressed:() {
                                                                                  setState(() {
                                                                                  list.AddBum = EditBum;
                                                                                });
                                                                                  Navigator.pop(context,'Ok',);
                                                                                },
                                                                                  child:const Text("Ok"),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:TextButton(
                                                                                onPressed: () =>
                                                                                Navigator.pop(context,'Cancel'),
                                                                                      child: const Text('Cancel'),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                    ),
                                                  );
                                                }),
                                                DataCell(
                                                    Text(list.Piece.toString(),textAlign:TextAlign.left),
                                                    showEditIcon: true,
                                                        onTap: () {
                                                        EditPeace = '';
                                                        showDialog(context: context,
                                                        builder:(BuildContext contex) =>
                                                            AlertDialog(
                                                              content: TextFormField(
                                                              keyboardType:TextInputType.number,
                                                              onChanged: (vvv) {
                                                                EditPeace = vvv;
                                                                print(EditPeace);
                                                                },
                                                              ),
                                                                title: Text("Enter Your Piece"),
                                                                actions: <Widget>[
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                TextButton(
                                                                                  onPressed:() {
                                                                                  if (EditPeace =='') {
                                                                                  } else {
                                                                                    setState(() {
                                                                                      list.Piece =EditPeace;
                                                                                      },
                                                                                    );
                                                                                    Navigator.pop(context,'Ok',);
                                                                                    }
                                                                                  },
                                                                                  child:const Text("Ok"),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:TextButton(
                                                                              onPressed: () =>Navigator.pop(context,'Cancel'),
                                                                              child: const Text('Cancel'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                          ),
                                                  );
                                                }),
                                              ]),
                                            ).toList(),
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
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: Colors.green,
                        icon: Icon(Icons.search),
                        label: Text('Find'),
                        onPressed: () {
                          InsertFormId = 3;
                          postdataheader(1, 1, '', '', '').then(
                            (value) => showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: MyVarianceRecord(context),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
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
                        backgroundColor: Colors.blue.shade700,
                        icon: Icon(Icons.check),
                        label: Text('Save'),
                        onPressed: () {
                          if (alterlocname == null) {
                            Validation("Select The Location");
                          } else if (Edt_ProductName.text == '') {
                            Validation("Select The ItemName");
                          } else if (AddListItem.length == 0) {
                            Validation("Add Item Data Table");
                          } else {
                            print('Success Header');
                            InsertFormId = 1;
                            postdataheader(1, 1, '', alteritemcode, '');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
            // child: SafeArea(
            //   child: Scaffold(
            //     appBar: AppBar(
            //       title: Text("OSRD MASTER"),
            //     ),
            //     body: !loading
            //         ? SingleChildScrollView(
            //             padding: EdgeInsets.all(5.0),
            //             scrollDirection: Axis.vertical,
            //             child: Form(
            //               key: formKey,
            //               child: Column(
            //                 children: [
            //                   Row(
            //                     children: [
            //                       //new Expanded(flex: 1, child: new Text("Scan Pallet")),
            //                       new Expanded(
            //                         flex: 5,
            //                         child: Container(
            //                           color: Colors.white,
            //                           child: DropdownSearch<String>(
            //                             mode: Mode.DIALOG,
            //                             showSearchBox: true,
            //                             items: loc,
            //                             label: "Select Location",
            //                             onChanged: (val) {
            //                               print(val);
            //                               for (int kk = 0;
            //                                   kk < locationModel.result.length;
            //                                   kk++) {
            //                                 if (locationModel.result[kk].name ==
            //                                     val) {
            //                                   print(locationModel
            //                                       .result[kk].code);
            //                                   alterlocname =
            //                                       locationModel.result[kk].name;
            //                                   alterloccode = locationModel
            //                                       .result[kk].code
            //                                       .toString();
            //                                 }
            //                               }
            //                             },
            //                             selectedItem: alterlocname,
            //                           ),
            //                         ),
            //                       ),
            //                       new Expanded(
            //                         flex: 5,
            //                         child: Container(),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     //Use of SizedBox
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     children: [
            //                       new Expanded(
            //                         flex: 5,
            //                         child: Container(
            //                           color: Colors.white,
            //                           child: DropdownSearch<String>(
            //                             //mode of dropdown
            //                             mode: Mode.DIALOG,
            //                             //to show search box
            //                             showSearchBox: true,
            //
            //                             items: occ,
            //                             label:
            //                                 "Select Occation/Shape/Reason/Distribution",
            //                             onChanged: (val) {
            //                               print(val);
            //                               for (int kk = 0;
            //                                   kk < occModel.result.length;
            //                                   kk++) {
            //                                 if (occModel.result[kk].occName ==
            //                                     val) {
            //                                   print(
            //                                       occModel.result[kk].occCode);
            //                                   alterocccname =
            //                                       occModel.result[kk].occName;
            //                                   alterocccode = occModel
            //                                       .result[kk].occCode
            //                                       .toString();
            //                                 }
            //                               }
            //                             },
            //                             selectedItem: alterocccname,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     //Use of SizedBox
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     children: [
            //                       new Expanded(
            //                         flex: 7,
            //                         child: InkWell(
            //                           child: Container(
            //                             width: double.infinity,
            //                             color: Colors.white,
            //                             child: TextField(
            //                               /*maxLines: 5,*/
            //                               controller: Edt_Remarks,
            //                               decoration: InputDecoration(
            //                                 labelText: "Remarks",
            //                                 hintText: "Enter Remarks",
            //                                 border: OutlineInputBorder(),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                       /*Expanded(
            //                     flex: 2,
            //                     child: IconButton(
            //                         onPressed: () {}, icon: Icon(Icons.add)))*/
            //                       SizedBox(
            //                         width: 5,
            //                       ),
            //                       new Expanded(
            //                         flex: 3,
            //                         child: ElevatedButton(
            //                           onPressed: () {
            //                             print('openpo');
            //
            //                             if (!isUpdating) {
            //                               print('Insert');
            //                             } else {
            //                               print('updatemode');
            //                             }
            //                           },
            //                           child:
            //                               Text(isUpdating ? 'UPDATE' : 'ADD'),
            //                           //child: Text('Add'),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     //Use of SizedBox
            //                     height: 10,
            //                   ),
            //                   Padding(
            //                     padding: EdgeInsets.all(5.0),
            //                     child: SingleChildScrollView(
            //                       scrollDirection: Axis.horizontal,
            //                       child: detailitems.toString() == "null"
            //                           ? Center(
            //                               child: Text('No Data Add!'),
            //                             )
            //                           : DataTable(
            //                               sortColumnIndex: 0,
            //                               sortAscending: true,
            //                               headingRowColor:
            //                                   MaterialStateProperty.all(
            //                                       Pallete.mycolor),
            //                               showCheckboxColumn: false,
            //                               columns: const <DataColumn>[
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Edit',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Active/InActive',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Location',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                                 DataColumn(
            //                                   label: Text(
            //                                     'Description',
            //                                     style: TextStyle(
            //                                         color: Colors.white),
            //                                   ),
            //                                 ),
            //                               ],
            //                               rows: detailitems.result
            //                                   .map(
            //                                     (list) => DataRow(cells: [
            //                                       DataCell(
            //                                         Center(
            //                                           child: Center(
            //                                             child: IconButton(
            //                                                 icon: Icon(
            //                                                     Icons.create),
            //                                                 color: Colors.red,
            //                                                 onPressed: () {
            //                                                   setState(() {
            //                                                     isUpdating =
            //                                                         true;
            //                                                   });
            //                                                   Edt_Remarks.text =
            //                                                       list.remarks;
            //                                                   alterlocname = "";
            //                                                   alterloccode = "";
            //                                                   alterocccode = "";
            //                                                   alterocccname =
            //                                                       "";
            //
            //                                                   alterlocname = list
            //                                                       .locationName;
            //                                                   alterloccode = list
            //                                                       .locationCode;
            //                                                   alterocccode =
            //                                                       list.occCode;
            //                                                   alterocccname =
            //                                                       list.occName;
            //                                                   docno =
            //                                                       list.docNo;
            //                                                   updatestatus =
            //                                                       list.status;
            //                                                 }),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       DataCell(
            //                                         Center(
            //                                           child: Center(
            //                                             child: Wrap(
            //                                               direction: Axis
            //                                                   .vertical, //default
            //                                               alignment:
            //                                                   WrapAlignment
            //                                                       .center,
            //                                               children: [
            //                                                 RaisedButton(
            //                                                   onPressed: () {},
            //                                                   child: Text((list
            //                                                               .status ==
            //                                                           0
            //                                                       ? 'Click to Disable'
            //                                                       : 'Click to Enable')),
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       DataCell(Wrap(
            //                                           direction: Axis
            //                                               .vertical, //default
            //                                           alignment:
            //                                               WrapAlignment.center,
            //                                           children: [
            //                                             Text(
            //                                                 list.locationName
            //                                                     .toString(),
            //                                                 textAlign:
            //                                                     TextAlign.left)
            //                                           ])),
            //                                       DataCell(
            //                                         Center(
            //                                             child: Wrap(
            //                                                 direction: Axis
            //                                                     .vertical, //default
            //                                                 alignment: WrapAlignment.center,
            //                                                 children: [
            //                                               Text(
            //                                                   list.remarks
            //                                                       .toString(),
            //                                                   textAlign:
            //                                                       TextAlign
            //                                                           .center)
            //                                             ])),
            //                                       ),
            //                                     ]),
            //                                   )
            //                                   .toList(),
            //                             ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           )
            //         : Container(
            //             child: Center(
            //               child: CircularProgressIndicator(),
            //             ),
            //           ),
            //   ),
            // ),
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
      //getpendingapprovallist();
    });
  }

  InserstRowIntbl(int length) {
    UpdateMode = false;
    setState(() {
      AddListItem.add(
        AddListItemRec(alteritemcode, 'Variance' + (length + 1).toString(), 0,
            0.0, 'Y', 0, 0,alteritemName.toString()),
      );
    });
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

  Future getItem() {
    GetItemWastage(sessionuserID, "1").then((response) {
      // print(response.body);
      if (response.statusCode == 200) {
        var nodata = jsonDecode(response.body)['status'] == 0;

        if (nodata == true) {
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          ItemList = WastageItemModel.fromJson(jsonDecode(response.body));
          //log(response.body.toString());
        }
        return response;
      } else {
        throw Exception('Failed to Login API');
      }
    });
  }

  Future<http.Response> getocc() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getOSRDOccation'),
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
        occModel.result.clear();
        occ.clear();
      } else {
        occModel = OccModel.fromJson(jsonDecode(response.body));
        occ.clear();
        for (int k = 0; k < occModel.result.length; k++) {
          occ.add(occModel.result[k].occName);
        }
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> postdataheader(
      docNo, itemcode, Screenid, acInc, varince) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
      alteritemcode = acInc;
      print('FormID' + InsertFormId.toString());
      print('docNo' + docNo.toString());
      print('itemcode' + itemcode.toString());
      print('Screenid' + Screenid.toString());
      print('acInc' + acInc.toString());
    });
    var body = {
      "FormID": InsertFormId,
      "DocNo": docNo,
      "ScreenId": Screenid,
      "Location": alterloccode,
      "LocationName": InsertFormId == 5 ? varince : alterlocname,
      "ItemCode": alteritemcode,
      "ItemName": InsertFormId == 5 ? itemcode : Edt_ProductName.text,
      "UserID": sessionuserID
    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'INSERTVARIANCE_HED'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      print(response.body);
      final decode = jsonDecode(response.body);
      if (jsonDecode(response.body)["Status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          if (InsertFormId == 3) {
            if (decode["testdata"].toString() == '[]') {
              setState(() {
                loading = false;
              });
              print('NoResponse');
            } else {
              SecVarianceMaster.clear();

              print('Yes Response');
              RawVarianceMaster =
                  GetVARIANCEMater.fromJson(jsonDecode(response.body));
              for (int i = 0; i < RawVarianceMaster.testdata.length; i++)
                SecVarianceMaster.add(
                  TempVarianceMaster(
                      RawVarianceMaster.testdata[i].locationName,
                      RawVarianceMaster.testdata[i].itemCode,
                      RawVarianceMaster.testdata[i].itemName,
                      RawVarianceMaster.testdata[i].docNo,
                      RawVarianceMaster.testdata[i].userId),
                );

              setState(() {
                loading = false;
              });
            }
          } else if (InsertFormId == 4) {
            print("From Id Is : "+InsertFormId.toString());
            UpdateMode = true;
            AddListItem.clear();
            RawGetVarianceUpdateRecord = GetVarianceUpdateRecord.fromJson(jsonDecode(response.body));
            for (int i = 0; i < RawGetVarianceUpdateRecord.testdata.length; i++) {
              //List<AddListItemRec> AddListItem = new List();
              AddListItem.add(
                AddListItemRec(
                    RawGetVarianceUpdateRecord.testdata[i].itemCode,
                    RawGetVarianceUpdateRecord.testdata[i].discription,
                    RawGetVarianceUpdateRecord.testdata[i].bun,
                    RawGetVarianceUpdateRecord.testdata[i].price,
                    RawGetVarianceUpdateRecord.testdata[i].active,
                    RawGetVarianceUpdateRecord.testdata[i].docNum,
                    RawGetVarianceUpdateRecord.testdata[i].LineId,RawGetVarianceUpdateRecord.testdata[i].itemNameH,),
              );
              alterloccode = RawGetVarianceUpdateRecord.testdata[i].location.toString();
              alterlocname = RawGetVarianceUpdateRecord.testdata[i].locationName;
            }


          } else {
            print(jsonDecode(response.body)['DocNo']);
            decode["testdata"][0]["STATUSNAME"].toString();
            HeaderDocNo = decode["testdata"][0]["DocNo"];
            Fluttertoast.showToast(
              msg: decode["testdata"][0]["STATUSNAME"].toString(),
            );
            print('HeaderDocNo' + HeaderDocNo.toString());
            insertVariancedetails(HeaderDocNo);
            if (UpdateMode = true) {
              setState(() {
                loading = false;
                InsertFormId = 4;
                postdataheader(GetDocNUm, 0, '', '', '');
              });
            } else {
              insertVariancedetails(HeaderDocNo);
            }
          }
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> insertVariancedetails(int DocNum) async {
    var headers = {"Content-Type": "application/json"};

    setState(() {
      loading = true;
    });
    sendtemplist.clear();
    for (int i = 0; i < AddListItem.length; i++) {
      sendtemplist.add(
        SendResultLine(
          1,
          DocNum,
          AddListItem[i].AddItemCode,
          Edt_ProductName.text,
          AddListItem[i].AddItemName,
          AddListItem[i].AddBum,
          AddListItem[i].Piece,
          AddListItem[i].AcInc,
        ),
      );
    }

    print(jsonEncode(sendtemplist));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'INSERTVARIANCE_LIN'),
        body: jsonEncode(sendtemplist),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VarianceMaster()));
        setState(() {});
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> insertVarianceSigledetails(int DocNum) async {
    var headers = {"Content-Type": "application/json"};

    setState(() {
      loading = true;
    });
    sendtemplist.clear();
    //for (int i = 0; i < AddListItem.length; i++)
    sendtemplist.add(SendResultLine(
      1,
      DocNum,
      alteritemcode,
      Edt_ProductName.text,
      'Variance' + (AddListItem.length + 1).toString(),
      '',
      0.0,
      'Y',
    ));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'INSERTVARIANCE_LIN'),
        body: jsonEncode(sendtemplist),
        headers: headers);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)["result"][0]["STATUSNAME"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        if (UpdateMode = true) {
          setState(() {
            InsertFormId = 4;
            postdataheader(DocNum, 0, '', '', '');
          });
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => VarianceMaster()));
          setState(() {});
        }
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Error Validation(ErrorMsg) {
    Fluttertoast.showToast(
        msg: ErrorMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  MyVarianceRecord(context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Stack(
          children: <Widget>[
            Container(
              width: 600,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 500,
                      height: 50,
                      child: TextField(
                        //controller: _SearchStudent,
                        onChanged: (data) {
                          setState(() {
                            SecVarianceMaster.clear();
                            for (int az = 0;
                                az < RawVarianceMaster.testdata.length;
                                az++)
                              if (RawVarianceMaster.testdata[az].itemCode.toLowerCase().toString().contains(data.toLowerCase().toString()) ||
                                  RawVarianceMaster.testdata[az].itemName.toLowerCase().toString().contains(data.toLowerCase().toString())) {
                                SecVarianceMaster.add(
                                  TempVarianceMaster(
                                      RawVarianceMaster.testdata[az].locationName,
                                      RawVarianceMaster.testdata[az].itemCode,
                                      RawVarianceMaster.testdata[az].itemName,
                                      RawVarianceMaster.testdata[az].docNo,
                                      RawVarianceMaster.testdata[az].userId,

                                  ),
                                );
                              }
                          });
                        },
                        enabled: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 3, bottom: 2, left: 10, right: 10),
                            hintText: 'Search ItemName',
                            labelText: 'Search ItemName',
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Container(
                      width: 500,
                      height: 450,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: SecVarianceMaster.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Column(
                                children: [
                                  Text(SecVarianceMaster[index].itemCode),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(SecVarianceMaster[index].itemName),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(SecVarianceMaster[index].locationName),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  print(SecVarianceMaster[index].docNo);
                                  InsertFormId = 4;
                                  GetDocNUm = SecVarianceMaster[index].docNo;
                                  //GETItemCode= SecVarianceMaster[index].docNo
                                  postdataheader(GetDocNUm, 0, '', '', '');
                                });

                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddListItemRec {
  var AddItemCode;
  var AddItemName;
  var AddBum;
  var Piece;
  var AcInc;
  var DocNo;
  var LineId;
  var AddItemHeader;
  AddListItemRec(this.AddItemCode, this.AddItemName, this.AddBum, this.Piece,
      this.AcInc, this.DocNo, this.LineId,this.AddItemHeader);
}

class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<ItemFillModel> my = new List();
    if (_VarianceMasterState.ItemList.result.length == 0) {
      Fluttertoast.showToast(
          msg: "No data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (int a = 0; a < _VarianceMasterState.ItemList.result.length; a++)
        if (_VarianceMasterState.ItemList.result[a].itemName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
          my.add(ItemFillModel(
              _VarianceMasterState.ItemList.result[a].itemCode,
              _VarianceMasterState.ItemList.result[a].itemName,
              _VarianceMasterState.ItemList.result[a].uOM,
              _VarianceMasterState.ItemList.result[a].qty,
              _VarianceMasterState.ItemList.result[a].Stock));
      return my;
    }
  }
}

class ItemFillModel {
  String ItemCode;
  String ItemName;
  String UOM;
  var Qty;
  var Stock;

  ItemFillModel(this.ItemCode, this.ItemName, this.UOM, this.Qty, this.Stock);
}

class Result {
  int docNum;
  String itemCode;
  String itemName;
  String itemVariance;
  String itemNos;
  var itemPieceCount;
  String active;

  Result({
    this.docNum,
    this.itemCode,
    this.itemName,
    this.itemVariance,
    this.itemNos,
    this.itemPieceCount,
    this.active,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNum'] = this.docNum;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemVariance'] = this.itemVariance;
    data['ItemNos'] = this.itemNos;
    data['ItemPieceCount'] = this.itemPieceCount;
    data['Active'] = this.active;
    return data;
  }
}

class SendResultLine {
  int FromId;
  int DocNo;
  String itemCode;
  String itemName;
  String itemVariance;
  String itemNos;
  var itemPieceCount;
  String active;

  SendResultLine(
    this.FromId,
    this.DocNo,
    this.itemCode,
    this.itemName,
    this.itemVariance,
    this.itemNos,
    this.itemPieceCount,
    this.active,
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FormID'] = this.FromId;
    data['DocNo'] = this.DocNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemVariance'] = this.itemVariance;
    data['ItemNos'] = this.itemNos;
    data['ItemPieceCount'] = this.itemPieceCount;
    data['Active'] = this.active;

    return data;
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class TempVarianceMaster {
  String locationName;
  String itemCode;
  String itemName;
  int docNo;
  int userId;
  //var ItemCodeH;
  TempVarianceMaster(
      this.locationName, this.itemCode, this.itemName, this.docNo, this.userId);
}
