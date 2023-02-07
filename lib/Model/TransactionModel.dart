class TransactionModel {
  int status;
  List<Result> result;

  TransactionModel({this.status, this.result});

  TransactionModel.fromJson(Map<String, dynamic> json) {
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
  String location;
  int orderNo;
  String billDate;
  String mobileNo;
  int billAmount;
  int screenID;
  String screenName;

  Result(
      {this.location,
      this.orderNo,
      this.billDate,
      this.mobileNo,
      this.billAmount,
      this.screenID,
      this.screenName});

  Result.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    orderNo = json['OrderNo'];
    billDate = json['BillDate'];
    mobileNo = json['MobileNo'];
    billAmount = json['BillAmount'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Location'] = this.location;
    data['OrderNo'] = this.orderNo;
    data['BillDate'] = this.billDate;
    data['MobileNo'] = this.mobileNo;
    data['BillAmount'] = this.billAmount;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    return data;
  }
}
