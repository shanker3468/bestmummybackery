class PurchaseIndentheaderModel {
  List<Testdata> testdata;

  PurchaseIndentheaderModel({this.testdata});

  PurchaseIndentheaderModel.fromJson(Map<String, dynamic> json) {
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
  var LocCode;
  String LocName;
  String vehicleCode;
  String vehicleName;
  var empId;
  String empName;
  String fassi;

  Testdata({this.docNo, this.docDate,this.LocCode,this.LocName,this.fassi});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    LocCode = json['LocCode'];
    LocName = json['LocName'];
    vehicleCode = json['VehicleCode'];
    vehicleName = json['VehicleName'];
    empId = json['EmpId'];
    empName = json['EmpName'];
    fassi = json['Fassi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['LocCode'] = this.LocCode;
    data['LocName'] = this.LocName;
    data['VehicleCode'] = this.vehicleCode;
    data['VehicleName'] = this.vehicleName;
    data['EmpId'] = this.empId;
    data['EmpName'] = this.empName;
    data['Fassi'] = this.fassi;
    return data;
  }
}
