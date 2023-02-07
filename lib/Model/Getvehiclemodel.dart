class Getvehiclemodel {
  List<Testdata> testdata;

  Getvehiclemodel({this.testdata});

  Getvehiclemodel.fromJson(Map<String, dynamic> json) {
    if (json['testdata'] != null) {
      testdata = <Testdata>[];
      json['testdata'].forEach((v) {
        testdata.add(new Testdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.testdata != null) {
      data['testdata'] = this.testdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testdata {
  var docNo;
  String docDate;
  String vehicleName;
  String model;
  String vehicleNo;
  var status;
  var sapStatus;
  var createdBy;
  String createdDate;

  Testdata(
      {this.docNo,
      this.docDate,
      this.vehicleName,
      this.model,
      this.vehicleNo,
      this.status,
      this.sapStatus,
      this.createdBy,
      this.createdDate});

  Testdata.fromJson(Map<String, dynamic> json) {
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
