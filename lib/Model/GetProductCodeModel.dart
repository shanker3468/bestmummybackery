class GetProductCodeModel {
  List<Testdata> testdata;

  GetProductCodeModel({this.testdata});

  GetProductCodeModel.fromJson(Map<String, dynamic> json) {
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
  String itemCode;
  String itemName;

  Testdata({this.code, this.itemCode, this.itemName});

  Testdata.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    return data;
  }
}
