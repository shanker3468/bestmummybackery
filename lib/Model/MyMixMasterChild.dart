class MyMixMasterChild {
  int status;
  List<Result> result;

  MyMixMasterChild({this.status, this.result});

  MyMixMasterChild.fromJson(Map<String, dynamic> json) {
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
  var docNo;
  String itemCode;
  String itemName;
  var qty;
  String active;
  int creatyBy;

  Result(
      {this.docNo,
      this.itemCode,
      this.itemName,
      this.qty,
      this.active,
      this.creatyBy});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    qty = json['Qty'];
    active = json['Active'];
    creatyBy = json['CreatyBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['Active'] = this.active;
    data['CreatyBy'] = this.creatyBy;
    return data;
  }
}
