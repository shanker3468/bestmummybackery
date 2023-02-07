class GetVarianceUpdateRecord {
  List<Testdata> testdata;

  GetVarianceUpdateRecord({this.testdata});

  GetVarianceUpdateRecord.fromJson(Map<String, dynamic> json) {
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
  int location;
  String locationName;
  String itemCodeH;
  String itemNameH;
  int docNum;
  String active;
  String itemCode;
  String discription;
  String bun;
  var price;
  var LineId;

  Testdata(
      {this.location,
      this.locationName,
      this.itemCodeH,
      this.itemNameH,
      this.docNum,
      this.active,
      this.itemCode,
      this.discription,
      this.bun,
      this.price});

  Testdata.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    locationName = json['LocationName'];
    itemCodeH = json['ItemCodeH'];
    itemNameH = json['ItemNameH'];
    docNum = json['DocNum'];
    active = json['Active'];
    itemCode = json['ItemCode'];
    discription = json['Discription'];
    bun = json['Bun'];
    price = json['Price'];
    LineId = json['LineId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['ItemCodeH'] = this.itemCodeH;
    data['ItemNameH'] = this.itemNameH;
    data['DocNum'] = this.docNum;
    data['Active'] = this.active;
    data['ItemCode'] = this.itemCode;
    data['Discription'] = this.discription;
    data['Bun'] = this.bun;
    data['Price'] = this.price;
    data['LineId'] = this.LineId;
    return data;
  }
}
