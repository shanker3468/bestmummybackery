class SalesReturnModel {
  int status;
  List<SalesReturnResult> result;

  SalesReturnModel({this.status, this.result});

  SalesReturnModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<SalesReturnResult>();
      json['result'].forEach((v) {
        result.add(new SalesReturnResult.fromJson(v));
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

class SalesReturnResult {
  String itemCode;
  String itemName;
  int itmsGrpCod;
  String uOM;
  var price;
  var amount;
  var qty;
  String itmsGrpNam;
  String picturName;
  String imgUrl;
  var TaxCode;
  int flag;
  var onHand;
  var Varince;

  SalesReturnResult(
      {this.itemCode,
        this.itemName,
        this.itmsGrpCod,
        this.uOM,
        this.price,
        this.amount,
        this.qty,
        this.itmsGrpNam,
        this.picturName,
        this.imgUrl,
        this.TaxCode,
        this.flag,
        this.onHand,
        this.Varince});

  SalesReturnResult.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itmsGrpCod = json['ItmsGrpCod'];
    uOM = json['UOM'];
    price = json['Price'];
    amount = json['Amount'];
    qty = json['Qty'];
    itmsGrpNam = json['ItmsGrpNam'];
    picturName = json['PicturName'];
    imgUrl = json['ImgUrl'];
    TaxCode = json['TaxCode'];
    flag = json['Flag'];
    onHand = json['OnHand'];
    Varince = json['Variance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItmsGrpCod'] = this.itmsGrpCod;
    data['UOM'] = this.uOM;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['Qty'] = this.qty;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    data['PicturName'] = this.picturName;
    data['ImgUrl'] = this.imgUrl;
    data['TaxCode'] = this.TaxCode;
    data['Flag'] = this.flag;
    data['OnHand'] = this.onHand;
    data['Variance'] = this.Varince;
    return data;
  }
}
