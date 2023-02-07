class WastageItemModel {
  int status;
  List<Result> result;

  WastageItemModel({this.status, this.result});

  WastageItemModel.fromJson(Map<String, dynamic> json) {
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
  var qty;
  var Stock;
  var ItemGroCode;
  var ItemGrpName;
  var taxcode;
  var price;
  var ammount;

  Result(
      {this.itemCode,
      this.itemName,
      this.uOM,
      this.qty,
      this.Stock,
      this.ItemGroCode,
      this.ItemGrpName,this.taxcode,this.price,this.ammount});

  Result.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uOM = json['UOM'];
    qty = json['Qty'];
    Stock = json['Stock'];
    ItemGroCode = json['ItmsGrpCod'];
    ItemGrpName = json['ItmsGrpNam'];
    taxcode = json['TaxCode'];
    price = json['Price'];
    ammount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['UOM'] = this.uOM;
    data['Qty'] = this.qty;
    data['Stock'] = this.Stock;
    data['ItmsGrpCod'] = this.ItemGroCode;
    data['ItmsGrpNam'] = this.ItemGrpName;
    data['TaxCode'] = this.taxcode;
    data['Price'] = this.price;
    data['Amount'] = this.ammount;
    return data;
  }
}
