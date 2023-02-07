import 'dart:convert';

import 'package:bestmummybackery/AllApi.dart';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:bestmummybackery/Model/CategoriesModel.dart';
import 'package:bestmummybackery/Model/EmpModel.dart';
import 'package:bestmummybackery/Model/OccModel.dart';
import 'package:bestmummybackery/Model/SalesItemModel.dart';
import 'package:bestmummybackery/screens/LoginPage.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:bestmummybackery/widgets/LineSeparator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSalesOrder extends StatefulWidget {
  @override
  _EditSalesOrderState createState() => new _EditSalesOrderState();
}

class _EditSalesOrderState extends State<EditSalesOrder> {
  ScrollController c;

  @override
  void initState() {
    super.initState();
    c = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new FloatingActionButton(
              child: new Icon(Icons.navigate_before),
              onPressed: () {
                //c.animateTo(MediaQuery.of(context).size.width, duration: new Duration(seconds: 1), curve: Curves.easeIn);
                c.jumpTo(0.0);
              }),
          new Container(
            width: 15.0,
          ),
          new FloatingActionButton(
              child: new Icon(Icons.navigate_next),
              onPressed: () {
                c.animateTo(MediaQuery.of(context).size.width,
                    duration: new Duration(seconds: 1), curve: Curves.easeIn);
              }),
        ],
      ),
      appBar: new AppBar(title: new Text("First Page")),
      body: new IgnorePointer(
        child: new PageView(
          controller: c,
          children: <Widget>[
            new Column(children: <Widget>[new Container()]),
            new Container(child: new Text("Second Item")),
          ],
        ),
      ),
    );
  }
}
