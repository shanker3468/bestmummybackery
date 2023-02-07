class GetInvoiceModel {
  List<Testdata> testdata;

  GetInvoiceModel({this.testdata});

  GetInvoiceModel.fromJson(Map<String, dynamic> json) {
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
  var orderNo;
  String customerNo;
  var totAmount;
  String orderStatus;
  String creationName;
  var tableNo;
  var branchID;
  var seatNo;

  Testdata({this.orderNo, this.customerNo, this.totAmount, this.orderStatus,this.creationName,this.seatNo,this.tableNo,this.branchID});

  Testdata.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    customerNo = json['CustomerNo'];
    totAmount = json['TotAmount'];
    orderStatus = json['OrderStatus'];
    creationName = json['CreationName'];
    seatNo = json['SeatNo'];
    tableNo = json['TableNo'];
    branchID = json['BranchID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['CustomerNo'] = this.customerNo;
    data['TotAmount'] = this.totAmount;
    data['OrderStatus'] = this.orderStatus;
    data['CreationName'] = this.creationName;
    data['SeatNo'] = this.seatNo;
    data['TableNo'] = this.tableNo;
    data['BranchID'] = this.branchID;
    return data;
  }
}
