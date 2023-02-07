// ignore_for_file: deprecated_member_use, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/Dayendmodel.dart';
import 'package:bestmummybackery/screens/ShiftDayEndClosing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ShiftClosing.dart';
import 'ShiftMaster.dart';
import 'package:http/http.dart' as http;
class ShiftHomeMaster extends StatefulWidget {
  const ShiftHomeMaster({Key key}) : super(key: key);

  @override
  _ShiftHomeMasterState createState() => _ShiftHomeMasterState();
}

class _ShiftHomeMasterState extends State<ShiftHomeMaster> {
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
  var TotalValue = 0.0;
  final formKey = new GlobalKey<FormState>();
  List<DenominationList> SecDenomination = new List();
  var EditAmt = 0.0;
  var sessionDayEndCheck='';
  bool DayEndCheck=false;

  Dayendmodel rawDayendmodel;
  List<ScreenData> secScreenData=[];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getStringValuesSF();
    });
    super.initState();
    setState(() {});
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionuserID = prefs.getString('UserID');
      sessionName = prefs.getString('FirstName');
      sessiondeptcode = prefs.getString('DeptCode');
      sessionbranchcode = prefs.getString('BranchCode');
      sessionbranchname = prefs.getString('BranchName');
      sessionDayEndCheck = prefs.getString("DayEndClsg");
      if(sessionDayEndCheck=='Y'){
        DayEndCheck=true;
      }else{
        DayEndCheck=false;
      }
    });
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
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Shift Dash Board"),
                ),
                body: !loading
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        scrollDirection: Axis.vertical,
                        child: Container(
                          key: formKey,
                          alignment: Alignment.center,
                          height: height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: DayEndCheck,
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade400,
                                    icon: Icon(Icons.open_in_new_outlined),
                                    label: Text(
                                      'Shift Opening',
                                    ),
                                    heroTag: "btn1",
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShiftMaster(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: DayEndCheck,
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade400,
                                    icon: Icon(Icons.open_in_new_outlined),
                                    label: Text('Shift Closing'),
                                    heroTag: "btn1",
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShiftClosingMaster(),),);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: DayEndCheck,
                                child: Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade400,
                                    icon: Icon(Icons.open_in_new_outlined),
                                    label: Text('Day End Process'),
                                    heroTag: "btn1",
                                    onPressed: () {
                                      getDataTableRecord();
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         ShiftDayEndMaster(),
                                      //   ),
                                      // );

                                    },
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
        : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
              child: SafeArea(
                  child: Scaffold(
                        appBar: AppBar(
                          title: Text("Shift Dash Board"),
                        ),
                        body: !loading
                            ? SingleChildScrollView(
                          padding: EdgeInsets.all(5.0),
                          scrollDirection: Axis.vertical,
                          child: Container(
                            key: formKey,
                            alignment: Alignment.center,
                            height: height / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade400,
                                    icon: Icon(Icons.open_in_new_outlined),
                                    label: Text(
                                      'Shift Opening',
                                    ),
                                    heroTag: "btn1",
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShiftMaster(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade400,
                                    icon: Icon(Icons.open_in_new_outlined),
                                    label: Text('Shift Closing'),
                                    heroTag: "btn1",
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShiftClosingMaster(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: width / 2.1,
                                  margin: EdgeInsets.only(left: 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.blue.shade400,
                                    icon: Icon(Icons.open_in_new_outlined),
                                    label: Text('Day End Process'),
                                    heroTag: "btn1",
                                    onPressed: () {

                                      getDataTableRecord();
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         ShiftDayEndMaster(),
                                      //   ),
                                      // );



                                      //Navigator.pop(context);
                                    },
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
    );
  }



  Future<http.Response> getDataTableRecord() async {
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
     secScreenData.clear();
    });
    var body = {
      "FromId": 3,
      "ItemCode": 40,
      "BranchId":sessionbranchcode,
      "DocDate":"DocDate",
      "DocNo":"DocNo"
    };
    //print(sessionuserID);
    log(jsonEncode(body));

    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'productstockdetalies'),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShiftDayEndMaster(),
            ),
          );
        });
        print('NoResponse');
      } else {
        setState(() {
        print('YesResponce');
        print(response.body);
        rawDayendmodel = Dayendmodel.fromJson(jsonDecode(response.body));
        for(int i =0 ; i < rawDayendmodel.testdata.length;i++){
          secScreenData.add(
              ScreenData(
                rawDayendmodel.testdata[i].docNo,
                rawDayendmodel.testdata[i].screenName,
                rawDayendmodel.testdata[i] .status,
                rawDayendmodel.testdata[i].branchId,
              ));
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
              const Text('Opening DocNo.'),
              content: SizedBox(
                width: double.minPositive,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: secScreenData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(secScreenData[index].screenName.toString()),
                      subtitle: Text(secScreenData[index].docNo.toString()),
                      onTap: () {
                        setState(() {
                          Navigator.pop(context,);
                        });

                      },
                    );
                  },
                ),
              ),
            );
          },
        );

          loading = false;
        });
      }
    } else {
      throw Exception('Failed to Login API');
    }
  }

}



class ScreenData {
  int docNo;
  String screenName;
  String status;
  int branchId;

  ScreenData(this.docNo, this.screenName, this.status, this.branchId);


}



class DenominationList {
  var Denomin;
  String Name;
  var Amt;
  var Total;
  DenominationList(this.Denomin, this.Name, this.Amt, this.Total);
}
