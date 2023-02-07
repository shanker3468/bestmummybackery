class OccModel {
  int status;
  List<OccResult> result;

  OccModel({this.status, this.result});

  OccModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<OccResult>();
      json['result'].forEach((v) {
        result.add(new OccResult.fromJson(v));
      });
    }
  }
  static List<OccModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => OccModel.fromJson(item)).toList();
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

class OccResult {
  String occCode;
  String occName;

  OccResult({this.occCode, this.occName});

  OccResult.fromJson(Map<String, dynamic> json) {
    occCode = json['OccCode'];
    occName = json['OccName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    return data;
  }
}
