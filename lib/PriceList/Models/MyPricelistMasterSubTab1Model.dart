class MyPricelistMasterSubTab1Model {
  List<Testdata> testdata;

  MyPricelistMasterSubTab1Model({this.testdata});

  MyPricelistMasterSubTab1Model.fromJson(Map<String, dynamic> json) {
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
  String itemCode;
  int code;
  String locName;
  var active;

  Testdata({this.itemCode, this.code, this.locName, this.active});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    code = json['Code'];
    locName = json['LocName'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['Code'] = this.code;
    data['LocName'] = this.locName;
    data['Active'] = this.active;
    return data;
  }
}
