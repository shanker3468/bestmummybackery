class Dayendmodel {
  List<Testdata> testdata;

  Dayendmodel({this.testdata});

  Dayendmodel.fromJson(Map<String, dynamic> json) {
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
  int docNo;
  String screenName;
  String status;
  int branchId;

  Testdata({this.docNo, this.screenName, this.status, this.branchId});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    screenName = json['ScreenName'];
    status = json['Status'];
    branchId = json['BranchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ScreenName'] = this.screenName;
    data['Status'] = this.status;
    data['BranchId'] = this.branchId;
    return data;
  }
}
