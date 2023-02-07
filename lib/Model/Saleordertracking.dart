class Saleordertracking {
  List<Testdata> testdata;

  Saleordertracking({this.testdata});

  Saleordertracking.fromJson(Map<String, dynamic> json) {
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
  String location;
  var orderNo;
  String deliveryDate;
  String orderStatus;
  var prodDocNo;
  String prodDate;
  String prodTime;
  String prodBy;
  var desDocNo;
  String desDate;
  String desTime;
  String despBy;
  String vehicleNo;
  String vehicleName;
  String driverName;

  Testdata(
      {this.location,
        this.orderNo,
        this.deliveryDate,
        this.orderStatus,
        this.prodDocNo,
        this.prodDate,
        this.prodTime,
        this.prodBy,
        this.desDocNo,
        this.desDate,
        this.desTime,
        this.despBy,
        this.vehicleNo,
        this.vehicleName,
        this.driverName});

  Testdata.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    orderNo = json['OrderNo'];
    deliveryDate = json['DeliveryDate'];
    orderStatus = json['OrderStatus'];
    prodDocNo = json['ProdDocNo'];
    prodDate = json['ProdDate'];
    prodTime = json['ProdTime'];
    prodBy = json['ProdBy'];
    desDocNo = json['DesDocNo'];
    desDate = json['DesDate'];
    desTime = json['DesTime'];
    despBy = json['DespBy'];
    vehicleNo = json['VehicleNo'];
    vehicleName = json['VehicleName'];
    driverName = json['DriverName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Location'] = this.location;
    data['OrderNo'] = this.orderNo;
    data['DeliveryDate'] = this.deliveryDate;
    data['OrderStatus'] = this.orderStatus;
    data['ProdDocNo'] = this.prodDocNo;
    data['ProdDate'] = this.prodDate;
    data['ProdTime'] = this.prodTime;
    data['ProdBy'] = this.prodBy;
    data['DesDocNo'] = this.desDocNo;
    data['DesDate'] = this.desDate;
    data['DesTime'] = this.desTime;
    data['DespBy'] = this.despBy;
    data['VehicleNo'] = this.vehicleNo;
    data['VehicleName'] = this.vehicleName;
    data['DriverName'] = this.driverName;
    return data;
  }
}
