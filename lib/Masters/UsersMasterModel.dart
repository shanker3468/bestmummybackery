class UsersMasterModel {
  int status;
  List<Result> result;

  UsersMasterModel({this.status, this.result});

  UsersMasterModel.fromJson(Map<String, dynamic> json) {
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
  int docNo;
  String docDate;
  int locationCode;
  String locationName;
  int empCode;
  String empName;
  String userName;
  String userPassword;
  String rollID;
  String rollName;
  int managerID;
  String managerName;
  int apprManagerID;
  String apprManagerName;
  String cashOnAccID;
  String cashOnAccName;
  String pettyCashAccountID;
  String pettyCashAccountName;
  String kOTID;
  String kotName;
  int status;
  int sapStatus;
  int createdBy;
  String createdDate;

  Result(
      {this.docNo,
      this.docDate,
      this.locationCode,
      this.locationName,
      this.empCode,
      this.empName,
      this.userName,
      this.userPassword,
      this.rollID,
      this.rollName,
      this.managerID,
      this.managerName,
      this.apprManagerID,
      this.apprManagerName,
      this.cashOnAccID,
      this.cashOnAccName,
      this.pettyCashAccountID,
      this.pettyCashAccountName,
      this.kOTID,
      this.kotName,
      this.status,
      this.sapStatus,
      this.createdBy,
      this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    locationCode = json['LocationCode'];
    locationName = json['LocationName'];
    empCode = json['EmpCode'];
    empName = json['EmpName'];
    userName = json['UserName'];
    userPassword = json['UserPassword'];
    rollID = json['RollID'];
    rollName = json['RollName'];
    managerID = json['ManagerID'];
    managerName = json['ManagerName'];
    apprManagerID = json['ApprManagerID'];
    apprManagerName = json['ApprManagerName'];
    cashOnAccID = json['CashOnAccID'];
    cashOnAccName = json['CashOnAccName'];
    pettyCashAccountID = json['PettyCashAccountID'];
    pettyCashAccountName = json['PettyCashAccountName'];
    kOTID = json['KOTID'];
    kotName = json['KotName'];
    status = json['Status'];
    sapStatus = json['SapStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['LocationCode'] = this.locationCode;
    data['LocationName'] = this.locationName;
    data['EmpCode'] = this.empCode;
    data['EmpName'] = this.empName;
    data['UserName'] = this.userName;
    data['UserPassword'] = this.userPassword;
    data['RollID'] = this.rollID;
    data['RollName'] = this.rollName;
    data['ManagerID'] = this.managerID;
    data['ManagerName'] = this.managerName;
    data['ApprManagerID'] = this.apprManagerID;
    data['ApprManagerName'] = this.apprManagerName;
    data['CashOnAccID'] = this.cashOnAccID;
    data['CashOnAccName'] = this.cashOnAccName;
    data['PettyCashAccountID'] = this.pettyCashAccountID;
    data['PettyCashAccountName'] = this.pettyCashAccountName;
    data['KOTID'] = this.kOTID;
    data['KotName'] = this.kotName;
    data['Status'] = this.status;
    data['SapStatus'] = this.sapStatus;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
