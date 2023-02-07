class OccNameMaster {
  List<Testdata> testdata;

  OccNameMaster({this.testdata});

  OccNameMaster.fromJson(Map<String, dynamic> json) {
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
  var occCode;
  String occName;

  Testdata({this.occCode, this.occName});

  Testdata.fromJson(Map<String, dynamic> json) {
    occCode = json['OccCode'];
    occName = json['OccName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    return data;
  }
}
