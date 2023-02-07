class Purchaseitemmodel {
  int status;
  List<Result> result;

  Purchaseitemmodel({this.status, this.result});

  Purchaseitemmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String itemCode;
  String itemName;
  String uOM;
  var stock;
  var minLevel;
  var maxLevel;
  var qty;

  Result(
      {this.itemCode,
      this.itemName,
      this.uOM,
      this.stock,
      this.minLevel,
      this.maxLevel,
      this.qty});

  Result.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uOM = json['UOM'];
    stock = json['Stock'];
    minLevel = json['MinLevel'];
    maxLevel = json['MaxLevel'];
    qty = json['Qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['UOM'] = this.uOM;
    data['Stock'] = this.stock;
    data['MinLevel'] = this.minLevel;
    data['MaxLevel'] = this.maxLevel;
    data['Qty'] = this.qty;
    return data;
  }
}
