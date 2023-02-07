class WastageTransferModel {
  int status;
  String message;
  List<Result> result;

  WastageTransferModel({this.status, this.message, this.result});

  WastageTransferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int docNo;
  String docDate;
  String fromWhsCode;
  String fromWhsName;
  String toWhsCode;
  String toWhsName;
  String type;
  String itemCode;
  String itemName;
  var qty;
  String uOM;
  String reasonCode;
  String reasonName;
  String isTransfer;
  int createdBy;
  String createdDate;
  var modifiedBy;
  var modifiedDate;
  var UniqID;
  var TaxCode;
  var Price;
  var Ammount;
  var TaxAmt;

  Result(
      {this.docNo,
      this.docDate,
      this.fromWhsCode,
      this.fromWhsName,
      this.toWhsCode,
      this.toWhsName,
      this.type,
      this.itemCode,
      this.itemName,
      this.qty,
      this.uOM,
      this.reasonCode,
      this.reasonName,
      this.isTransfer,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.UniqID,this.TaxCode,this.Price,this.Ammount,this.TaxAmt});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    fromWhsCode = json['FromWhsCode'];
    fromWhsName = json['FromWhsName'];
    toWhsCode = json['ToWhsCode'];
    toWhsName = json['ToWhsName'];
    type = json['Type'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    qty = json['Qty'];
    uOM = json['UOM'];
    reasonCode = json['ReasonCode'];
    reasonName = json['ReasonName'];
    isTransfer = json['IsTransfer'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    UniqID = json['UniqDocNo'];
    TaxCode = json['TaxCode'];
    Price = json['Price'];
    Ammount = json['Ammount'];
    TaxAmt = json['TaxAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['FromWhsCode'] = this.fromWhsCode;
    data['FromWhsName'] = this.fromWhsName;
    data['ToWhsCode'] = this.toWhsCode;
    data['ToWhsName'] = this.toWhsName;
    data['Type'] = this.type;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Qty'] = this.qty;
    data['UOM'] = this.uOM;
    data['ReasonCode'] = this.reasonCode;
    data['ReasonName'] = this.reasonName;
    data['IsTransfer'] = this.isTransfer;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['UniqDocNo'] = this.UniqID;
    data['TaxCode'] = this.TaxCode;
    data['Price'] = this.Price;
    data['Ammount'] = this.Ammount;
    data['TaxAmt'] = this.TaxAmt;
    return data;
  }
}
