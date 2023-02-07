class ProductionModel {
  List<Testdata> testdata;

  ProductionModel({this.testdata});

  ProductionModel.fromJson(Map<String, dynamic> json) {
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
  String uom;
  String groupName;
  var productionQty;
  var despatchedQty;
  var remaining;
  var totalStock;

  Testdata(
      {this.itemCode,
        this.itemName,
        this.uom,
        this.groupName,
        this.productionQty,
        this.despatchedQty,
        this.remaining,
        this.totalStock});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uom = json['Uom'];
    groupName = json['GroupName'];
    productionQty = json['ProductionQty'];
    despatchedQty = json['DespatchedQty'];
    remaining = json['Remaining'];
    totalStock = json['TotalStock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Uom'] = this.uom;
    data['GroupName'] = this.groupName;
    data['ProductionQty'] = this.productionQty;
    data['DespatchedQty'] = this.despatchedQty;
    data['Remaining'] = this.remaining;
    data['TotalStock'] = this.totalStock;
    return data;
  }
}
