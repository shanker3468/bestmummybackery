class SalesConsolidateModel {
  List<Testdata> testdata;

  SalesConsolidateModel({this.testdata});

  SalesConsolidateModel.fromJson(Map<String, dynamic> json) {
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
  String screenName;
  String shiftId;
  String billTime;
  var orderNo;
  String billNo;
  var recAmt;
  var blanceAmt;
  var totAmount;
  var screenId;
  var type;

  Testdata(
      {this.screenName,
        this.shiftId,
        this.billTime,
        this.orderNo,
        this.billNo,
        this.recAmt,
        this.blanceAmt,
        this.totAmount,
        this.screenId,this.type});

  Testdata.fromJson(Map<String, dynamic> json) {
    screenName = json['ScreenName'];
    shiftId = json['ShiftId'];
    billTime = json['BillTime'];
    orderNo = json['OrderNo'];
    billNo = json['BillNo'];
    recAmt = json['RecAmt'];
    blanceAmt = json['BlanceAmt'];
    totAmount = json['TotAmount'];
    screenId = json['ScreenId'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScreenName'] = this.screenName;
    data['ShiftId'] = this.shiftId;
    data['BillTime'] = this.billTime;
    data['OrderNo'] = this.orderNo;
    data['BillNo'] = this.billNo;
    data['RecAmt'] = this.recAmt;
    data['BlanceAmt'] = this.blanceAmt;
    data['TotAmount'] = this.totAmount;
    data['ScreenId'] = this.screenId;
    data['Type'] = this.type;
    return data;
  }
}
