// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/RollauthScreenmodel.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyRollAunthScreenpermision extends StatefulWidget {
  MyRollAunthScreenpermision({Key key, this.DocNo, this.Location, this. RollName, }): super(key: key);

  var DocNo;
  var Location;
  var RollName;

  @override
  _MyRollAunthScreenpermisionState createState() => _MyRollAunthScreenpermisionState();
}

class _MyRollAunthScreenpermisionState extends State<MyRollAunthScreenpermision> {

  var sessionName = "";
  var sessionuserID = "";
  var sessionbranchcode = "";
  var sessionbranchname = "";
  var sessiondeptcode = "";
  bool loading = false;
  int SecreeId = 0;

  bool isUpdating;

  List<String> loc = new List();
  List<String> occ = new List();

  final formKey = new GlobalKey<FormState>();
  int docno = 0;
  int updatestatus = 0;
  RollauthScreenmodel RawRollauthScreenmodel;
  List<ShowscreenData> SecShowscreenData = new List();

  void initState() {
    isUpdating = false;
    getStringValuesSF();
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
            decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
          child: SafeArea(
              child: Scaffold(appBar: AppBar(title: Text("My Roll Screen Permision"),),
                body: !loading?
                  SingleChildScrollView(
                      padding: EdgeInsets.all(5.0),
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: width / 4,
                                    alignment: Alignment.center,
                                    child: Text("DocNo :      "+widget.DocNo.toString()),
                                  ),
                                  Container(
                                    width: width / 8,
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text("Location :     "+widget.Location.toString()),
                                  ),
                                  Container(
                                    width: width / 8,
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text("Roll Name :"+widget.RollName.toString()),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),

                              Container(
                                height: 500,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: RollauthScreenmodel == null
                                          ? Center(child:Text('Add ItemCode Line Table'),)
                                          : DataTable(
                                            sortColumnIndex: 0,
                                            sortAscending: true,
                                            headingRowColor:MaterialStateProperty.all(Pallete.mycolor),
                                            showCheckboxColumn: false,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Text('DocNo',style: TextStyle(color: Colors.white),),
                                                ),
                                                DataColumn(
                                                  label: Text('ScreenNo',style: TextStyle(color: Colors.white),),
                                                ),
                                                DataColumn(
                                                  label: Text('Screen Name',style: TextStyle(color: Colors.white),),
                                                ),
                                                DataColumn(
                                                  label: Text('Status',style: TextStyle(color: Colors.white),),
                                                ),
                                              ],
                                            rows: SecShowscreenData.map((list) => DataRow(cells: [
                                                DataCell(
                                                  Text(list.docNo.toString(),textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  Text(
                                                      list.screenID.toString(),textAlign:TextAlign.left),),
                                                DataCell(
                                                  Text(
                                                      list.screenName.toString(),textAlign:TextAlign.left),
                                                ),
                                                DataCell(
                                                  list.status=='Y'
                                                  ?IconButton(icon: Icon(Icons.check_circle_rounded,color: Colors.green,), onPressed: () {
                                                    setState(() {
                                                      if( list.status=='Y'){
                                                        setState(() {
                                                          list.status='N';
                                                        });
                                                      }
                                                    });
                                                  },)
                                                  :IconButton(icon: Icon(Icons.check_box_outline_blank,color: Colors.red,), onPressed: () {
                                                    setState(() {
                                                      setState(() {
                                                        if( list.status=='N'){
                                                          setState(() {
                                                            list.status='Y';
                                                          });
                                                        }
                                                      });
                                                    });
                                                  },),
                                                ),

                                        ]),
                                        ).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),],),),)
                : Container(
                    child: Center(
                        child: CircularProgressIndicator(),
                      ),
          ),

                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: width / 2.5,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.blue.shade900,
                        icon: Icon(Icons.check),
                        label: Text(isUpdating?'Update':'Save'),
                        onPressed: () {

                          for(int i = 0 ; i< SecShowscreenData.length; i ++){
                            PostSaved(isUpdating?6:5, 0, "",i).then((value) => {
                              getDataonscreen(),
                            });

                          }


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
                    ],
                  ),
                ],
        ),
      ),
    )
        : Container();
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
      getDataonscreen();
    });
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


  Future<http.Response> PostSaved(int FormId,int DocNo, String Active, int index ) async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {

      "FormID":FormId,
      "DocNo":widget.DocNo,
      "Location":0,
      "DisType":"",
      "Valuess":"",
      "RollName":"",
      "CreateBy":int.parse(sessionuserID),
      "ScreenId":SecShowscreenData[index].screenID,
      "ScreenName":SecShowscreenData[index].screenName,
      "Active":SecShowscreenData[index].status

    };
    print(sessionuserID);
    log(jsonEncode(body));

    final response = await http.post(Uri.parse(AppConstants.LIVE_URL + 'RollauthMaster'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        log(response.body);
        setState(() {
          loading = false;
        });

      }
    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<http.Response> getDataonscreen() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var body = {

      "FormID":4,
      "DocNo":widget.DocNo,
      "Location":0,
      "DisType":"",
      "Valuess":"",
      "RollName":"",
      "CreateBy":int.parse(sessionuserID),
      "ScreenId":1,
      "ScreenName":"ScreenName",
      "Active":"Y"

    };
    print(sessionuserID);

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'RollauthMaster'),
        headers: headers,
        body: jsonEncode(body));
    setState(() {
      loading = false;
    });
    print(jsonDecode(response.body)["result"]);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["testdata"].toString() == '[]') {
        setState(() {
          loading = false;
        });
        print('NoResponse');
      } else {
        setState(() {
          SecShowscreenData.clear();
        log(response.body);
        RawRollauthScreenmodel = RollauthScreenmodel.fromJson(jsonDecode(response.body));
        for(int i = 0 ; i <RawRollauthScreenmodel.testdata.length;i++ ){
          if(RawRollauthScreenmodel.testdata[i].HeadDocNo==widget.DocNo){
            isUpdating =true;
          }else{

          }
          SecShowscreenData.add(
              ShowscreenData(RawRollauthScreenmodel.testdata[i].docNo,
              RawRollauthScreenmodel.testdata[i].screenID,
              RawRollauthScreenmodel.testdata[i].screenName,
              RawRollauthScreenmodel.testdata[i].status));
        }

          loading = false;
        });

      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

}




class ShowscreenData {
  var docNo;
  var screenID;
  String screenName;
  var status;

  ShowscreenData(this.docNo, this.screenID, this.screenName, this.status);
  Map<String, dynamic> toJson() => {
    'docNo': docNo,
    'screenID': screenID,
    'screenName': screenName,
    'status': status,

  };
}




