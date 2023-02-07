class KOTModel {
  int status;
  List<Result> result;

  KOTModel({this.status, this.result});

  KOTModel.fromJson(Map<String, dynamic> json) {
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
  var creationCode;
  String creationName;
  var tableNo;
  var totalSeats;

  Result({this.creationCode, this.creationName, this.tableNo, this.totalSeats});

  Result.fromJson(Map<String, dynamic> json) {
    creationCode = json['CreationCode'];
    creationName = json['CreationName'];
    tableNo = json['TableNo'];
    totalSeats = json['TotalSeats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreationCode'] = this.creationCode;
    data['CreationName'] = this.creationName;
    data['TableNo'] = this.tableNo;
    data['TotalSeats'] = this.totalSeats;
    return data;
  }
}
