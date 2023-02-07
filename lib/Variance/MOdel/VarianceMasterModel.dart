class GetVARIANCEMater {
  List<Testdata> testdata;

  GetVARIANCEMater({this.testdata});

  GetVARIANCEMater.fromJson(Map<String, dynamic> json) {
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
  String locationName;
  String itemCode;
  String itemName;
  int docNo;
  int userId;

  Testdata(
      {this.locationName,
      this.itemCode,
      this.itemName,
      this.docNo,
      this.userId});

  Testdata.fromJson(Map<String, dynamic> json) {
    locationName = json['LocationName'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    docNo = json['DocNo'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocationName'] = this.locationName;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['DocNo'] = this.docNo;
    data['UserId'] = this.userId;
    return data;
  }
}
