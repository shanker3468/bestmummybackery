class RequestHeaderModel {
  int status;
  List<Result> result;

  RequestHeaderModel({this.status, this.result});

  RequestHeaderModel.fromJson(Map<String, dynamic> json) {
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
  int docNo;
  String docDate;
  String driverCode;
  String driverName;
  String vehicleCode;
  String vehicleName;
  String locCode;
  String locName;
  String mobileNo;
  int refNo;
  String refDate;
  int status;
  String remarks;
  int createdBy;
  String createdDate;
  String qRCode;

  Result(
      {this.docNo,
      this.docDate,
      this.driverCode,
      this.driverName,
      this.vehicleCode,
      this.vehicleName,
      this.locCode,
      this.locName,
      this.mobileNo,
      this.refNo,
      this.refDate,
      this.status,
      this.remarks,
      this.createdBy,
      this.createdDate,
      this.qRCode});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    driverCode = json['DriverCode'];
    driverName = json['DriverName'];
    vehicleCode = json['VehicleCode'];
    vehicleName = json['VehicleName'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    mobileNo = json['MobileNo'];
    refNo = json['RefNo'];
    refDate = json['RefDate'];
    status = json['Status'];
    remarks = json['Remarks'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    qRCode = json['QRCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['DriverCode'] = this.driverCode;
    data['DriverName'] = this.driverName;
    data['VehicleCode'] = this.vehicleCode;
    data['VehicleName'] = this.vehicleName;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['MobileNo'] = this.mobileNo;
    data['RefNo'] = this.refNo;
    data['RefDate'] = this.refDate;
    data['Status'] = this.status;
    data['Remarks'] = this.remarks;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['QRCode'] = this.qRCode;
    return data;
  }
}
