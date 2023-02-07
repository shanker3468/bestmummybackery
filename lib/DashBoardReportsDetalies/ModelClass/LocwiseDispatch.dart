class LocwiseDispatch {
  List<Testdata> testdata;

  LocwiseDispatch({this.testdata});

  LocwiseDispatch.fromJson(Map<String, dynamic> json) {
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
  int locationId;
  String location;
  int deliveryNo;
  String itemCode;
  String itemName;
  String invntryUom;
  String groupName;
  var ammount;
  var qty;

  Testdata(
      {this.locationId,
        this.location,
        this.deliveryNo,
        this.itemCode,
        this.itemName,
        this.invntryUom,
        this.groupName,
        this.ammount,this.qty});

  Testdata.fromJson(Map<String, dynamic> json) {
    locationId = json['LocationId'];
    location = json['Location'];
    deliveryNo = json['DeliveryNo'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    invntryUom = json['InvntryUom'];
    groupName = json['GroupName'];
    ammount = json['Ammount'];
    qty = json['Qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocationId'] = this.locationId;
    data['Location'] = this.location;
    data['DeliveryNo'] = this.deliveryNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['InvntryUom'] = this.invntryUom;
    data['GroupName'] = this.groupName;
    data['Ammount'] = this.ammount;
    data['Qty'] = this.qty;
    return data;
  }
}
