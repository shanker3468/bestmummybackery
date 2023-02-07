class MixBoxChild {
  int status;
  List<Result> result;

  MixBoxChild({this.status, this.result});

  MixBoxChild.fromJson(Map<String, dynamic> json) {
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
  String refItemCode;
  String itemCode;
  String itemName;
  var qty;
  var uom;

  Result({this.refItemCode, this.itemCode, this.itemName, this.qty,this.uom});

  Result.fromJson(Map<String, dynamic> json) {
    refItemCode = json['RefItemCode'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    qty = json['Qty'];
    uom = json['Uom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RefItemCode'] = this.refItemCode;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['Uom'] = this.uom;
    return data;
  }
}
