class ShiftTblMaster {
  int status;
  List<Result> result;

  ShiftTblMaster({this.status, this.result});

  ShiftTblMaster.fromJson(Map<String, dynamic> json) {
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
  var openingAmt;
  var docDate;
  var counterId;
  var deviceId;
  var userId;
  String status;

  Result(
      {this.docNo,
        this.openingAmt,
        this.docDate,
        this.counterId,
        this.deviceId,
        this.userId,
        this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    openingAmt = json['OpeningAmt'];
    docDate = json['DocDateD'];
    counterId = json['CounterId'];
    deviceId = json['DeviceId'];
    userId = json['UserId'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['OpeningAmt'] = this.openingAmt;
    data['DocDateD'] = this.docDate;
    data['CounterId'] = this.counterId;
    data['DeviceId'] = this.deviceId;
    data['UserId'] = this.userId;
    data['Status'] = this.status;
    return data;
  }
}
