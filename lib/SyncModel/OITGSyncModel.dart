class OITGSyncModel {
  int status;
  List<Result> result;

  OITGSyncModel({this.status, this.result});

  OITGSyncModel.fromJson(Map<String, dynamic> json) {
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
  var itmsTypCod;
  String itmsGrpNam;
  var userSign;
  var falg;
  var sysnc;

  Result(
      {this.itmsTypCod, this.itmsGrpNam, this.userSign, this.falg, this.sysnc});

  Result.fromJson(Map<String, dynamic> json) {
    itmsTypCod = json['ItmsTypCod'];
    itmsGrpNam = json['ItmsGrpNam'];
    userSign = json['UserSign'];
    falg = json['Falg'];
    sysnc = json['Sysnc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItmsTypCod'] = this.itmsTypCod;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    data['UserSign'] = this.userSign;
    data['Falg'] = this.falg;
    data['Sysnc'] = this.sysnc;
    return data;
  }
}
