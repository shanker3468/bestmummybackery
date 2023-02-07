class RequestStockWise {
  int status;
  List<Result1> result;

  RequestStockWise({this.status, this.result});

  RequestStockWise.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result1>();
      json['result'].forEach((v) {
        result.add(new Result1.fromJson(v));
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

class Result1 {
  var onHand;
  var userQty;
  String whsName;
  var locCode;
  String location;
  String itemCode;
  String itemName;
  String UOM;

  Result1(
      {this.onHand,
      this.whsName,
      this.locCode,
      this.location,
      this.itemCode,
      this.itemName,
      this.UOM});

  Result1.fromJson(Map<String, dynamic> json) {
    onHand = json['OnHand'];
    whsName = json['WhsName'];
    locCode = json['LocCode'];
    location = json['Location'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    UOM = json['UOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OnHand'] = this.onHand;
    data['WhsName'] = this.whsName;
    data['LocCode'] = this.locCode;
    data['Location'] = this.location;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['UOM'] = this.UOM;
    return data;
  }
}
