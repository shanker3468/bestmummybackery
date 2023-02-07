class MyGetStateCuntryModel {
  List<Testdata> testdata;

  MyGetStateCuntryModel({this.testdata});

  MyGetStateCuntryModel.fromJson(Map<String, dynamic> json) {
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
  String code;
  String discription;

  Testdata({this.code, this.discription});

  Testdata.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    discription = json['Discription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Discription'] = this.discription;
    return data;
  }
}
