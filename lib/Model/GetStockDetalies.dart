class GetStockDetalies {
  List<Testdata> testdata;

  GetStockDetalies({this.testdata});

  GetStockDetalies.fromJson(Map<String, dynamic> json) {
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
  String whsCode;
  String location;
  var onHand;

  Testdata({this.itemCode, this.whsCode, this.location, this.onHand});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    whsCode = json['WhsCode'];
    location = json['Location'];
    onHand = json['OnHand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['WhsCode'] = this.whsCode;
    data['Location'] = this.location;
    data['OnHand'] = this.onHand;
    return data;
  }
}
