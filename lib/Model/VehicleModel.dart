class VehicleModel {
  int status;
  List<VehicleResult> result;

  VehicleModel({this.status, this.result});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<VehicleResult>();
      json['result'].forEach((v) {
        result.add(new VehicleResult.fromJson(v));
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

class VehicleResult {
  int docNo;
  String docDate;
  String VehicleName;
  String Model;
  String VehicleNo;
  int status;

  VehicleResult(
      {this.docNo,
      this.docDate,
      this.VehicleName,
      this.Model,
      this.VehicleNo,
      this.status});

  VehicleResult.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    VehicleName = json['VehicleName'];
    Model = json['Model'];
    VehicleNo = json['VehicleNo'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['VehicleName'] = this.VehicleName;
    data['Model'] = this.Model;
    data['VehicleNo'] = this.VehicleNo;
    data['Status'] = this.status;
    return data;
  }
}
