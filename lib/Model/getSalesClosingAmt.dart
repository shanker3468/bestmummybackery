class GetSalesClosingAmt {
  List<Testdata> testdata;

  GetSalesClosingAmt({this.testdata});

  GetSalesClosingAmt.fromJson(Map<String, dynamic> json) {
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
  String type;
  var recvAmount;
  var status;
  var ScreenId;

  Testdata({this.screenName, this.type, this.recvAmount, this.status});

  Testdata.fromJson(Map<String, dynamic> json) {
    screenName = json['ScreenName'];
    type = json['Type'];
    recvAmount = json['RecvAmount'];
    status = json['Status'];
    ScreenId = json['ScreenId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScreenName'] = this.screenName;
    data['Type'] = this.type;
    data['RecvAmount'] = this.recvAmount;
    data['Status'] = this.status;
    data['ScreenId'] = this.ScreenId;
    return data;
  }
}
