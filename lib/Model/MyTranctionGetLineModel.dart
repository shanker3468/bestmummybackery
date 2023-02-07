class MyTranctionGetLineModel {
  List<Testdata> testdata;

  MyTranctionGetLineModel({this.testdata});

  MyTranctionGetLineModel.fromJson(Map<String, dynamic> json) {
    if (json['testdata'] != null) {
      testdata = <Testdata>[];
      json['testdata'].forEach((v) {
        testdata.add(new Testdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.testdata != null) {
      data['testdata'] = this.testdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testdata {
  var orderNo;
  String orderDate;
  var totQty;
  var totAmount;
  var balanceDue;
  String status;
  var screenID;
  var screenName;
  var CustomerNo;

  Testdata(
      {this.orderNo,
      this.orderDate,
      this.totQty,
      this.totAmount,
      this.balanceDue,
      this.status,
      this.screenName,this.CustomerNo});

  Testdata.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    totQty = json['TotQty'];
    totAmount = json['TotAmount'];
    balanceDue = json['BalanceDue'];
    status = json['Status'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    CustomerNo = json['CustomerNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['TotQty'] = this.totQty;
    data['TotAmount'] = this.totAmount;
    data['BalanceDue'] = this.balanceDue;
    data['Status'] = this.status;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['CustomerNo'] = this.CustomerNo;
    return data;
  }
}
