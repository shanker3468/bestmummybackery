class MySaleOrderGetPaymentData {
  List<Testdata> testdata;

  MySaleOrderGetPaymentData({this.testdata});

  MySaleOrderGetPaymentData.fromJson(Map<String, dynamic> json) {
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
  String payType;
  var recvAmt;
  var billAmt;
  var balanceAmt;
  String remarks;

  Testdata(
      {this.payType,
      this.recvAmt,
      this.billAmt,
      this.balanceAmt,
      this.remarks});

  Testdata.fromJson(Map<String, dynamic> json) {
    payType = json['PayType'];
    recvAmt = json['RecvAmt'];
    billAmt = json['BillAmt'];
    balanceAmt = json['BalanceAmt'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PayType'] = this.payType;
    data['RecvAmt'] = this.recvAmt;
    data['BillAmt'] = this.billAmt;
    data['BalanceAmt'] = this.balanceAmt;
    data['Remarks'] = this.remarks;
    return data;
  }
}
