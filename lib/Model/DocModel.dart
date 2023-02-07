class DocModel {
  int status;
  List<Result> result;

  DocModel({this.status, this.result});

  DocModel.fromJson(Map<String, dynamic> json) {
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
  int orderNo;
  int sqliteRefNo;
  var BillNo;
  var Refno;

  Result({this.orderNo, this.sqliteRefNo,this.BillNo,this.Refno});

  Result.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    sqliteRefNo = json['SqliteRefNo'];
    BillNo = json['BillNo'];
    Refno = json['RefNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['SqliteRefNo'] = this.sqliteRefNo;
    data['BillNo'] = this.BillNo;
    data['RefNo'] = this.Refno;
    return data;
  }
}
