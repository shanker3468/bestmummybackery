class GetItemMasterModel {
  int status;
  List<Result> result;

  GetItemMasterModel({this.status, this.result});

  GetItemMasterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
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
  String itemName;
  String itemCode;
  String invntryUom;
  var stock;
  var taxcode;
  var price;
  var amount;

  Result({this.itemName, this.itemCode, this.invntryUom, this.stock,this.taxcode,this.price,this.amount});

  Result.fromJson(Map<String, dynamic> json) {
    itemName = json['ItemName'];
    itemCode = json['ItemCode'];
    invntryUom = json['InvntryUom'];
    stock = json['Stock'];
    taxcode = json['TaxCode'];
    price = json['Price'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemName'] = this.itemName;
    data['ItemCode'] = this.itemCode;
    data['InvntryUom'] = this.invntryUom;
    data['Stock'] = this.stock;
    data['TaxCode'] = this.taxcode;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    return data;
  }
}
