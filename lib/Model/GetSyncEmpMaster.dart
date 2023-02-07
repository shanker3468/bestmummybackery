class GetSyncEmpMaster {
  int status;
  List<Result> result;

  GetSyncEmpMaster({this.status, this.result});

  GetSyncEmpMaster.fromJson(Map<String, dynamic> json) {
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
  int empID;
  String lastName;
  String firstName;
  String active;

  Result({this.empID, this.lastName, this.firstName,this.active});

  Result.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['Active'] = this.active;
    return data;
  }
}
