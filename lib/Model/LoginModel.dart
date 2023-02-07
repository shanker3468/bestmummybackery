class LoginModel {
  int status;
  List<Result> result;

  LoginModel({this.status, this.result});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result>();
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
  String firstName;
  int branchCode;
  String branchName;
  int deptCode;
  String deptName;
  String PrintStatus;
  String DayEndClsg;
  String DayDash;
  String Contact1;
  String Contact2;

  Result(
      {this.empID,
      this.firstName,
      this.branchCode,
      this.branchName,
      this.deptCode,
      this.deptName,this.PrintStatus,this.DayEndClsg,this.DayDash});

  Result.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    firstName = json['firstName'];
    branchCode = json['BranchCode'];
    branchName = json['BranchName'];
    deptCode = json['DeptCode'];
    deptName = json['DeptName'];
    PrintStatus = json['PrintStatus'];
    DayEndClsg = json['DayEndClsg'];
    DayDash = json['DayDash'];
    Contact1 = json['Contact1'];
    Contact2 = json['Contact2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['firstName'] = this.firstName;
    data['BranchCode'] = this.branchCode;
    data['BranchName'] = this.branchName;
    data['DeptCode'] = this.deptCode;
    data['DeptName'] = this.deptName;
    data['PrintStatus'] = this.PrintStatus;
    data['DayEndClsg'] = this.DayEndClsg;
    data['DayDash'] = this.DayDash;
    data['Contact1'] = this.Contact1;
    data['Contact2'] = this.Contact2;
    return data;
  }
}
