// ignore_for_file: non_constant_identifier_names

class ShiftWiseSalesModel {
  List<Testdata> testdata;

  ShiftWiseSalesModel({this.testdata});

  ShiftWiseSalesModel.fromJson(Map<String, dynamic> json) {
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
  var shiftId;
  var closeShiftId;
  String empName;
  var   openingAmt;
  String closeTime;
  var closingAmt;
  var shiftSales;
  var diff;
  var OpeningTime;
  var TotalCash;
  var TotalReturn;
  var ONHand;
  var card;
  var cash;
  var upi;
  var others;


  Testdata(
      {this.shiftId,
        this.closeShiftId,
        this.empName,
        this.openingAmt,
        this.closeTime,
        this.closingAmt,
        this.shiftSales,
        this.diff,this.OpeningTime,this.TotalCash,this.TotalReturn,this.ONHand,this.card,this.cash,this.upi,this.others});

  Testdata.fromJson(Map<String, dynamic> json) {
    shiftId = json['ShiftId'];
    closeShiftId = json['CloseShiftId'];
    empName = json['EmpName'];
    openingAmt = json['OpeningAmt'];
    closeTime = json['CloseTime'];
    closingAmt = json['ClosingAmt'];
    shiftSales = json['ShiftSales'];
    diff = json['Diff'];
    OpeningTime = json['OpeningTime'];
    TotalCash = json['TotalCash'];
    TotalReturn = json['TotalReturn'];
    ONHand = json['ONHand'];
    card = json['Card'];
    cash = json['Cash'];
    upi = json['UPI'];
    others = json['Others'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShiftId'] = this.shiftId;
    data['CloseShiftId'] = this.closeShiftId;
    data['EmpName'] = this.empName;
    data['OpeningAmt'] = this.openingAmt;
    data['CloseTime'] = this.closeTime;
    data['ClosingAmt'] = this.closingAmt;
    data['ShiftSales'] = this.shiftSales;
    data['Diff'] = this.diff;
    data['OpeningTime'] = this.OpeningTime;
    data['TotalCash'] = this.TotalCash;
    data['TotalReturn'] = this.TotalReturn;
    data['ONHand'] = this.ONHand;
    data['Card'] = this.card;
    data['Cash'] = this.cash;
    data['UPI'] = this.upi;
    data['Others'] = this.others;
    return data;
  }
}
