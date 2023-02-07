class MyMixMaster {
  int status;
  List<Result> result;

  MyMixMaster({this.status, this.result});

  MyMixMaster.fromJson(Map<String, dynamic> json) {
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
  String uom;
  var qty;
  var location;
  String locationName;
  String active;
  String docDate;
  var createBy;
  var sync;

  Result(
      {this.docNo,
      this.itemCode,
      this.itemName,
      this.uom,
      this.qty,
      this.location,
      this.locationName,
      this.active,
      this.docDate,
      this.createBy,
      this.sync});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uom = json['Uom'];
    qty = json['Qty'];
    location = json['Location'];
    locationName = json['LocationName'];
    active = json['Active'];
    docDate = json['DocDate'];
    createBy = json['CreateBy'];
    sync = json['Sync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Uom'] = this.uom;
    data['Qty'] = this.qty;
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['Active'] = this.active;
    data['DocDate'] = this.docDate;
    data['CreateBy'] = this.createBy;
    data['Sync'] = this.sync;
    return data;
  }
}
