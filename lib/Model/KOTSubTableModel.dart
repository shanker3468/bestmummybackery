class KOTSubTableModel {
  int status;
  List<Result> result;

  KOTSubTableModel({this.status, this.result});

  KOTSubTableModel.fromJson(Map<String, dynamic> json) {
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
  String seatNo;

  Result({this.seatNo});

  Result.fromJson(Map<String, dynamic> json) {
    seatNo = json['SeatNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SeatNo'] = this.seatNo;
    return data;
  }
}
