class KotTableModel {
  int status;
  List<Result> result;

  KotTableModel({this.status, this.result});

  KotTableModel.fromJson(Map<String, dynamic> json) {
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
  int tableNo;

  Result({this.tableNo});

  Result.fromJson(Map<String, dynamic> json) {
    tableNo = json['TableNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TableNo'] = this.tableNo;
    return data;
  }
}
