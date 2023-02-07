class RollmasterModel {
  int status;
  List<Result> result;

  RollmasterModel({this.status, this.result});

  RollmasterModel.fromJson(Map<String, dynamic> json) {
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
  var location;
  String disType;
  String valuess;
  String rallName;
  String docDate;
  var createBy;
  String active;

  Result(
      {this.docNo,
        this.location,
        this.disType,
        this.valuess,
        this.rallName,
        this.docDate,
        this.createBy,
        this.active});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    location = json['Location'];
    disType = json['DisType'];
    valuess = json['Valuess'];
    rallName = json['RallName'];
    docDate = json['DocDate'];
    createBy = json['CreateBy'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['Location'] = this.location;
    data['DisType'] = this.disType;
    data['Valuess'] = this.valuess;
    data['RallName'] = this.rallName;
    data['DocDate'] = this.docDate;
    data['CreateBy'] = this.createBy;
    data['Active'] = this.active;
    return data;
  }
}
