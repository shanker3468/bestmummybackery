class OrderManagement {
  List<Testdata> testdata;

  OrderManagement({this.testdata});

  OrderManagement.fromJson(Map<String, dynamic> json) {
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
  String screenName;
  int docNo;
  String docDate;
  int locCode;
  String locName;
  String occName;
  String deliveryDate;
  String deliveryTime;
  String orderStatus;
  var docEntry;
  String shape;

  Testdata(
      {this.screenName,
        this.docNo,
        this.docDate,
        this.locCode,
        this.locName,
        this.occName,
        this.deliveryDate,
        this.deliveryTime,this.orderStatus,this.docEntry,this.shape});

  Testdata.fromJson(Map<String, dynamic> json) {
    screenName = json['ScreenName'];
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    occName = json['OccName'];
    deliveryDate = json['DeliveryDate'];
    deliveryTime = json['DeliveryTime'];
    orderStatus = json['OrderStatus'];
    docEntry = json['DocEntry'];
    shape = json['Shape'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScreenName'] = this.screenName;
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['OccName'] = this.occName;
    data['DeliveryDate'] = this.deliveryDate;
    data['DeliveryTime'] = this.deliveryTime;
    data['OrderStatus'] = this.orderStatus;
    data['DocEntry'] = this.docEntry;
    data['Shape'] = this.shape;
    return data;
  }
}
