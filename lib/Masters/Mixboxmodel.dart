class Mixboxmodel {
  List<Testdata> testdata;

  Mixboxmodel({this.testdata});

  Mixboxmodel.fromJson(Map<String, dynamic> json) {
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
  String refItemCode;
  String itemCode;
  String itemName;
  var qty;
  var actualQty;
  String uom;
  var comboNo;
  var sqlRefNo;
  String billNumber;
  String status;

  Testdata(
      {this.refItemCode,
        this.itemCode,
        this.itemName,
        this.qty,
        this.actualQty,
        this.uom,
        this.comboNo,
        this.sqlRefNo,
        this.billNumber,
        this.status});

  Testdata.fromJson(Map<String, dynamic> json) {
    refItemCode = json['RefItemCode'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    qty = json['Qty'];
    actualQty = json['ActualQty'];
    uom = json['Uom'];
    comboNo = json['ComboNo'];
    sqlRefNo = json['SqlRefNo'];
    billNumber = json['BillNumber'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RefItemCode'] = this.refItemCode;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['ActualQty'] = this.actualQty;
    data['Uom'] = this.uom;
    data['ComboNo'] = this.comboNo;
    data['SqlRefNo'] = this.sqlRefNo;
    data['BillNumber'] = this.billNumber;
    data['Status'] = this.status;
    return data;
  }
}
