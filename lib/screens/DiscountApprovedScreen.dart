import 'package:flutter/material.dart';

class DiscountApproved extends StatefulWidget {
  const DiscountApproved({Key key}) : super(key: key);

  @override
  _DiscountApprovedState createState() => _DiscountApprovedState();
}

class _DiscountApprovedState extends State<DiscountApproved> {
  int _selection = 0;
  String choice = "";
  selectTime(int timeSelected) {
    setState(() {
      _selection = timeSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Approved Discount'),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.all(10),
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
                            //controller: Edt_PoNo,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Location",
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
                            //controller: Edt_PoDate,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "User Name",
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                      new Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            //controller: Edt_PoNo,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Sales Order No",
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
                            //controller: Edt_PoDate,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Sales Order Date",
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                      new Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            //controller: Edt_PoNo,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Request Discount",
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
                            //controller: Edt_PoDate,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Approved Discount",
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                      new Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            //controller: Edt_PoNo,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Remarks1",
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
                            //controller: Edt_PoDate,
                            readOnly: true,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Remarks 2",
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
                    height: 10,
                  ),
                  /*Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selection = 1;
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 150,
                              color:
                                  _selection == 1 ? Colors.green : Colors.white,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  focusColor: Colors.white,
                                  groupValue: _selection,
                                  onChanged: selectTime,
                                  value: 1,
                                ),
                                Text(
                                  "Approved",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),*/
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ChoiceChip(
                                avatar: Image.asset("assets/imgs/rejected.png",
                                    matchTextDirection: false, width: 20.0),
                                label: Text('Reject',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 30),
                                selected: choice == 'Reject',
                                onSelected: (bool selected) {
                                  setState(() {
                                    choice = selected ? 'Reject' : null;
                                  });
                                },
                                selectedColor: Color(0xFF0D47A1),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)))),
                        Expanded(
                            child: ChoiceChip(
                                avatar: Image.asset("assets/imgs/accept.png",
                                    matchTextDirection: false, width: 20.0),
                                label: Text('Approve',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 30),
                                selected: choice == 'Approve',
                                onSelected: (bool selected) {
                                  setState(() {
                                    choice = selected ? 'Approve' : null;
                                  });
                                },
                                selectedColor: Color(0xFF0D47A1),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))))
                      ]),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Submit')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
