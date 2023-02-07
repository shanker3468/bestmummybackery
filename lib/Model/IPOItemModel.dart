class IPOItemModel {
  List<Testdata> testdata;

  IPOItemModel({this.testdata});

  IPOItemModel.fromJson(Map<String, dynamic> json) {
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
  String itemName;
  String uOM;
  var stock;
  String whsCode;

  Testdata({this.itemCode, this.itemName, this.uOM, this.stock, this.whsCode});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uOM = json['UOM'];
    stock = json['Stock'];
    whsCode = json['WhsCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['UOM'] = this.uOM;
    data['Stock'] = this.stock;
    data['WhsCode'] = this.whsCode;
    return data;
  }
}
