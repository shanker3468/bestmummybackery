class TCD3SyncModel {
  int status;
  List<Result> result;

  TCD3SyncModel({this.status, this.result});

  TCD3SyncModel.fromJson(Map<String, dynamic> json) {
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
  var absId;
  var tcd2Id;
  String efctFrom;
  String EfctTo;
  String taxCode;

  Result({this.absId, this.tcd2Id, this.efctFrom, this.EfctTo, this.taxCode});

  Result.fromJson(Map<String, dynamic> json) {
    absId = json['AbsId'];
    tcd2Id = json['Tcd2Id'];
    efctFrom = json['EfctFrom'];
    EfctTo = json['EfctTo'];
    taxCode = json['TaxCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbsId'] = this.absId;
    data['Tcd2Id'] = this.tcd2Id;
    data['EfctFrom'] = this.efctFrom;
    data['EfctTo'] = this.EfctTo;
    data['TaxCode'] = this.taxCode;
    return data;
  }
}
