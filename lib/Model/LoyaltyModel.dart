class LoyaltyModel {
  int status;
  List<Result> result;

  LoyaltyModel({this.status, this.result});

  LoyaltyModel.fromJson(Map<String, dynamic> json) {
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
  int docNo;
  String docDate;
  String locCode;
  String locName;
  var fromRange;
  var toRange;
  var loyaltyPoint;
  var loyaltyAmount;
  int status;
  String remarks;
  int sapStatus;
  String sapRefNo;
  int createdBy;
  String createdDate;

  Result(
      {this.docNo,
      this.docDate,
      this.locCode,
      this.locName,
      this.fromRange,
      this.toRange,
      this.loyaltyPoint,
      this.loyaltyAmount,
      this.status,
      this.remarks,
      this.sapStatus,
      this.sapRefNo,
      this.createdBy,
      this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    fromRange = json['FromRange'];
    toRange = json['ToRange'];
    loyaltyPoint = json['LoyaltyPoint'];
    loyaltyAmount = json['LoyaltyAmount'];
    status = json['Status'];
    remarks = json['Remarks'];
    sapStatus = json['SapStatus'];
    sapRefNo = json['SapRefNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['FromRange'] = this.fromRange;
    data['ToRange'] = this.toRange;
    data['LoyaltyPoint'] = this.loyaltyPoint;
    data['LoyaltyAmount'] = this.loyaltyAmount;
    data['Status'] = this.status;
    data['Remarks'] = this.remarks;
    data['SapStatus'] = this.sapStatus;
    data['SapRefNo'] = this.sapRefNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
