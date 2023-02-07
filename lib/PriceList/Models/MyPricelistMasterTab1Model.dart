class MyPricelistMasterTab1Model {
  List<Testdata> testdata;

  MyPricelistMasterTab1Model({this.testdata});

  MyPricelistMasterTab1Model.fromJson(Map<String, dynamic> json) {
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
  int code;
  String location;
  String itemCode;
  String active;

  Testdata({this.code, this.location, this.itemCode, this.active});

  Testdata.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    location = json['Location'];
    itemCode = json['ItemCode'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Location'] = this.location;
    data['ItemCode'] = this.itemCode;
    data['Active'] = this.active;
    return data;
  }
}
