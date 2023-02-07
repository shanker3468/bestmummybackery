class KOTBookedModel {
  int status;
  List<Result> result;

  KOTBookedModel({this.status, this.result});

  KOTBookedModel.fromJson(Map<String, dynamic> json) {
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
  var totAmount;
  var overallAmount;
  var orderNo;
  String seatNo;
  String creationName;
  String tableNo;

  Result(
      {this.totAmount,
      this.overallAmount,
      this.orderNo,
      this.seatNo,
      this.creationName,
      this.tableNo});

  Result.fromJson(Map<String, dynamic> json) {
    totAmount = json['TotAmount'];
    overallAmount = json['OverallAmount'];
    orderNo = json['OrderNo'];
    seatNo = json['SeatNo'];
    creationName = json['CreationName'];
    tableNo = json['TableNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotAmount'] = this.totAmount;
    data['OverallAmount'] = this.overallAmount;
    data['OrderNo'] = this.orderNo;
    data['SeatNo'] = this.seatNo;
    data['CreationName'] = this.creationName;
    data['TableNo'] = this.tableNo;
    return data;
  }
}
