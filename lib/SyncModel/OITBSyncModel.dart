class OITBSyncModel {
  int status;
  List<Result> result;

  OITBSyncModel({this.status, this.result});

  OITBSyncModel.fromJson(Map<String, dynamic> json) {
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
  var itmsGrpCod;
  String itmsGrpNam;
  String locked;

  Result({this.itmsGrpCod, this.itmsGrpNam, this.locked});

  Result.fromJson(Map<String, dynamic> json) {
    itmsGrpCod = json['ItmsGrpCod'];
    itmsGrpNam = json['ItmsGrpNam'];
    locked = json['Locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItmsGrpCod'] = this.itmsGrpCod;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    data['Locked'] = this.locked;
    return data;
  }
}
