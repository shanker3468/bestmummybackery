class GetDistrictModel {
  List<Testdata> testdata;

  GetDistrictModel({this.testdata});

  GetDistrictModel.fromJson(Map<String, dynamic> json) {
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
  int docNum;
  String contryName;
  String stateName;
  String district;
  String place;
  String active;

  Testdata(
      {this.docNum,
      this.contryName,
      this.stateName,
      this.district,
      this.place,
      this.active});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNum = json['DocNum'];
    contryName = json['ContryName'];
    stateName = json['StateName'];
    district = json['District'];
    place = json['Place'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNum'] = this.docNum;
    data['ContryName'] = this.contryName;
    data['StateName'] = this.stateName;
    data['District'] = this.district;
    data['Place'] = this.place;
    data['Active'] = this.active;
    return data;
  }
}
