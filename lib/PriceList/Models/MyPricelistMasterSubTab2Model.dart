class MyPricelistMasterSubTab2Model {
  List<Testdata> testdata;

  MyPricelistMasterSubTab2Model({this.testdata});

  MyPricelistMasterSubTab2Model.fromJson(Map<String, dynamic> json) {
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
  int location;
  String locationName;
  String variance;
  int occCode;
  String occName;
  var rate;
  String active;
  int tapIndex;

  Testdata(
      {this.itemCode,
      this.location,
      this.locationName,
      this.variance,
      this.occCode,
      this.occName,
      this.rate,
      this.active,
      this.tapIndex});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    location = json['Location'];
    locationName = json['LocationName'];
    variance = json['variance'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    rate = json['Rate'];
    active = json['Active'];
    tapIndex = json['TapIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['variance'] = this.variance;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['Rate'] = this.rate;
    data['Active'] = this.active;
    data['TapIndex'] = this.tapIndex;
    return data;
  }
}
