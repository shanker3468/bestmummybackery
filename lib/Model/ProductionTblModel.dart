class ProductionTblModel {
  List<Testdata> testdata;

  ProductionTblModel({this.testdata});

  ProductionTblModel.fromJson(Map<String, dynamic> json) {
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
  var itemCode;
  var itemName;
  var quantity;
  var invntryUom;
  var packet;
  var box;
  var tray;
  var remarks;
  var Stock;
  var taxcode;
  var price;
  var amt;
  var taxamt;

  Testdata(
      {this.itemCode,
      this.itemName,
      this.quantity,
      this.invntryUom,
      this.packet,
      this.box,
      this.tray,
      this.remarks,
      this.Stock,
      this.taxcode,
      this.price,
      this.amt,
      this.taxamt,
      });

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    quantity = json['Quantity'];
    invntryUom = json['InvntryUom'];
    packet = json['Packet'];
    box = json['Box'];
    tray = json['Tray'];
    remarks = json['Remarks'];
    Stock = json['Stock'];
    taxcode = json['TaxCode'];
    price = json['Price'];
    amt = json['Amt'];
    taxamt = json['TaxAmt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Quantity'] = this.quantity;
    data['InvntryUom'] = this.invntryUom;
    data['Packet'] = this.packet;
    data['Box'] = this.box;
    data['Tray'] = this.tray;
    data['Remarks'] = this.remarks;
    data['Stock'] = this.Stock;
    data['TaxCode'] = this.taxcode;
    data['Price'] = this.price;
    data['Amt'] = this.amt;
    data['TaxAmt'] = this.taxamt;
    return data;
  }
}
