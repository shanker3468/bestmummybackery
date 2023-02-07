class VechicleModel {
  int status;
  List<Result> result;

  VechicleModel({this.status, this.result});

  VechicleModel.fromJson(Map<String, dynamic> json) {
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
  String vehicleName;
  String model;
  String vehicleNo;
  int status;
  int sapStatus;
  int createdBy;
  String createdDate;

  Result(
      {this.docNo,
      this.docDate,
      this.vehicleName,
      this.model,
      this.vehicleNo,
      this.status,
      this.sapStatus,
      this.createdBy,
      this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    vehicleName = json['VehicleName'];
    model = json['Model'];
    vehicleNo = json['VehicleNo'];
    status = json['Status'];
    sapStatus = json['SapStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['VehicleName'] = this.vehicleName;
    data['Model'] = this.model;
    data['VehicleNo'] = this.vehicleNo;
    data['Status'] = this.status;
    data['SapStatus'] = this.sapStatus;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
