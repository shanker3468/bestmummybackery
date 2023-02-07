class EmpModel {
  int status;
  List<EmpResult> result;

  EmpModel({this.status, this.result});

  EmpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<EmpResult>();
      json['result'].forEach((v) {
        result.add(new EmpResult.fromJson(v));
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

class EmpResult {
  var empID;
  var name;

  EmpResult({this.empID, this.name});

  EmpResult.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['Name'] = this.name;
    return data;
  }
}
