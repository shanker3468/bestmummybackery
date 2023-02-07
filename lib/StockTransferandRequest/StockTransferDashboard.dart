import 'package:bestmummybackery/Expense/ExpenseCustomer.dart';
import 'package:bestmummybackery/StockTransferandRequest/IPORequest.dart';
import 'package:bestmummybackery/StockTransferandRequest/LocationWiseTransfer.dart';
import 'package:bestmummybackery/StockTransferandRequest/StockRequest.dart';
import 'package:bestmummybackery/StockTransferandRequest/StockTransfer.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/screens/SalesOrder.dart';
import 'package:flutter/material.dart';

class StockTransferDashboard extends StatefulWidget {
  const StockTransferDashboard({Key key}) : super(key: key);

  @override
  _StockTransferDashboardState createState() => _StockTransferDashboardState();
}

class _StockTransferDashboardState extends State<StockTransferDashboard> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: new AppBar(
        title: Text('Transfer Request'),
      ),
      body: Stack(
        children: [
          Container(
            width: width / 1,
            height: height / 1,
            decoration: BoxDecoration(
              color: Pallete.mycolor,
              // image: DecorationImage(fit: BoxFit.cover),
            ),
            child: Center(),
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: height - height / 20,
                            // width: width,
                            child: GridView.count(
                              childAspectRatio: 1,
                              // crossAxisSpacing: width / 20,
                              // mainAxisSpacing: height / 20,
                              crossAxisCount: 3,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StockRequest(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/imgs/ic_stocktranfser.png",
                                              fit: BoxFit.fill,
                                              height: 40,
                                              width: 40),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              width: double.infinity,
                                              child: Center(
                                                child: Text(
                                                  "Request",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xFF002D58),
                                                      fontSize: 15),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StockTransfer(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/imgs/ic_stocktranfser.png",
                                              fit: BoxFit.fill,
                                              height: 40,
                                              width: 40),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              width: double.infinity,
                                              child: Text(
                                                "Transfer",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xFF002D58),
                                                    fontSize: 15),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IPORequest(),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/imgs/ic_stocktranfser.png",
                                              fit: BoxFit.fill,
                                              height: 40,
                                              width: 40),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              width: double.infinity,
                                              child: Center(
                                                child: Text(
                                                  "IPO",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xFF002D58),
                                                      fontSize: 15),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LocationWiseTransfer(),
                                        ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/imgs/ic_stocktranfser.png",
                                              fit: BoxFit.fill,
                                              height: 40,
                                              width: 40),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              width: double.infinity,
                                              child: Center(
                                                child: Text(
                                                  "Location",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xFF002D58),
                                                      fontSize: 15),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
