class MyMixBoxModel {
  List<Testdata> testdata;

  MyMixBoxModel({this.testdata});

  MyMixBoxModel.fromJson(Map<String, dynamic> json) {
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
  String itemCode;
  String itemName;
  String uom;
  var qty;
  var locCode;
  String locName;
  String active;
  String Status;

  Testdata({
    this.docNo,
    this.itemCode,
    this.itemName,
    this.uom,
    this.qty,
    this.locCode,
    this.locName,
    this.active,
    this.Status,
  });

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uom = json['Uom'];
    qty = json['Qty'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    active = json['Active'];
    Status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Uom'] = this.uom;
    data['Qty'] = this.qty;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['Active'] = this.active;
    data['Status'] = this.Status;
    return data;
  }
}
