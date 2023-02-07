class RollauthScreenmodel {
  List<Testdata> testdata;

  RollauthScreenmodel({this.testdata});

  RollauthScreenmodel.fromJson(Map<String, dynamic> json) {
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
  var docNo;
  var screenID;
  String screenName;
  var status;
  var HeadDocNo;

  Testdata({this.docNo, this.screenID, this.screenName, this.status});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    status = json['Status'];
    HeadDocNo = json['HeadDocNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['Status'] = this.status;
    data['HeadDocNo'] = this.HeadDocNo;
    return data;
  }
}
