class WastageRecivieModel {
  int status;
  String message;
  List<Result> result;

  WastageRecivieModel({this.status, this.message, this.result});

  WastageRecivieModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
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
  String modifiedBy;
  String modifiedDate;
  var uniqDocNo;
  String taxCode;
  String price;
  String ammount;
  String taxAmt;

  Result(
      this.docNo,
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
        this.uniqDocNo,
        this.taxCode,
        this.price,
        this.ammount,
        this.taxAmt);

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
    uniqDocNo = json['UniqDocNo'];
    taxCode = json['TaxCode'];
    price = json['Price'];
    ammount = json['Ammount'];
    taxAmt = json['TaxAmt'];
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
    data['UniqDocNo'] = this.uniqDocNo;
    data['TaxCode'] = this.taxCode;
    data['Price'] = this.price;
    data['Ammount'] = this.ammount;
    data['TaxAmt'] = this.taxAmt;
    return data;
  }
}
