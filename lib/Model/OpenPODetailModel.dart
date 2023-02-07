class OpenPODetailModel {
  int status;
  List<OpenPODetailResult> result;

  OpenPODetailModel({this.status, this.result});

  OpenPODetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<OpenPODetailResult>();
      json['result'].forEach((v) {
        result.add(new OpenPODetailResult.fromJson(v));
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

class OpenPODetailResult {
  String itemCode;
  String itemName;
  var quantity;
  var openQty;
  var price;
  var lineTotal;
  var taxAmount;
  var overAll;
  var TaxCode;

  OpenPODetailResult(
      {this.itemCode,
      this.itemName,
      this.quantity,
      this.openQty,
      this.price,
      this.lineTotal,
      this.taxAmount,
      this.overAll,this.TaxCode});

  OpenPODetailResult.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['Item Name'];
    quantity = json['Quantity'];
    openQty = json['OpenQty'];
    price = json['Price'];
    lineTotal = json['LineTotal'];
    taxAmount = json['TaxAmount'];
    overAll = json['Over All'];
    TaxCode = json['TaxCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['Item Name'] = this.itemName;
    data['Quantity'] = this.quantity;
    data['OpenQty'] = this.openQty;
    data['Price'] = this.price;
    data['LineTotal'] = this.lineTotal;
    data['TaxAmount'] = this.taxAmount;
    data['Over All'] = this.overAll;
    data['TaxCode'] = this.overAll;
    return data;
  }
}

class AlternateOpenPODetailResult {
  var DocNo;
  var PoEntry;
  String itemCode;
  String itemName;
  var OrderQty;
  var ReceivedQty;
  var Price;
  var TaxAmount;
  var TaxCode;
  var LineTotal;
  var UserID;
  var UserID1;

  AlternateOpenPODetailResult(
      this.DocNo,
      this.PoEntry,
      this.itemCode,
      this.itemName,
      this.OrderQty,
      this.ReceivedQty,
      this.Price,
      this.TaxAmount,
      this.TaxCode,
      this.LineTotal,
      this.UserID,
      this.UserID1);

  Map<String, dynamic> toJson() => {
        'DocNo': DocNo,
        'PoEntry': PoEntry,
        'ItemCode': itemCode,
        'ItemName': itemName,
        'OrderQty': OrderQty,
        'ReceivedQty': ReceivedQty,
        'Price': Price,
        'TaxAmount': TaxAmount,
        'TaxCode': TaxCode,
        'LineTotal': LineTotal,
        'UserID': UserID,
        'UserID': UserID,
      };
}
