class TCD2SyncModel {
  int status;
  List<Result> result;

  TCD2SyncModel({this.status, this.result});

  TCD2SyncModel.fromJson(Map<String, dynamic> json) {
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
  var tcd1Id;
  var dispOrder;
  var keyFld1V;
  var keyFld2V;
  var keyFld3V;
  var keyFld4V;
  var keyFld5V;

  Result(
      {this.absId,
      this.tcd1Id,
      this.dispOrder,
      this.keyFld1V,
      this.keyFld2V,
      this.keyFld3V,
      this.keyFld4V,
      this.keyFld5V});

  Result.fromJson(Map<String, dynamic> json) {
    absId = json['AbsId'];
    tcd1Id = json['Tcd1Id'];
    dispOrder = json['DispOrder'];
    keyFld1V = json['KeyFld_1_V'];
    keyFld2V = json['KeyFld_2_V'];
    keyFld3V = json['KeyFld_3_V'];
    keyFld4V = json['KeyFld_4_V'];
    keyFld5V = json['KeyFld_5_V'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbsId'] = this.absId;
    data['Tcd1Id'] = this.tcd1Id;
    data['DispOrder'] = this.dispOrder;
    data['KeyFld_1_V'] = this.keyFld1V;
    data['KeyFld_2_V'] = this.keyFld2V;
    data['KeyFld_3_V'] = this.keyFld3V;
    data['KeyFld_4_V'] = this.keyFld4V;
    data['KeyFld_5_V'] = this.keyFld5V;
    return data;
  }
}
