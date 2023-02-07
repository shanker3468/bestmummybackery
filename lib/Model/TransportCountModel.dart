class TransportCountModel {
  int status;
  List<Result> result;

  TransportCountModel({this.status, this.result});

  TransportCountModel.fromJson(Map<String, dynamic> json) {
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
  var headDocNo;
  String toloc;
  String itemName;
  var qty;

  Result({this.headDocNo, this.toloc, this.itemName, this.qty});

  Result.fromJson(Map<String, dynamic> json) {
    headDocNo = json['HeadDocNo'];
    toloc = json['Toloc'];
    itemName = json['ItemName'];
    qty = json['Qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HeadDocNo'] = this.headDocNo;
    data['Toloc'] = this.toloc;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    return data;
  }
}
