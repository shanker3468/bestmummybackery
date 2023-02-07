class QRItemModel {
  int status;
  List<Result> result;

  QRItemModel({this.status, this.result});

  QRItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int flag;
  String taxCode;
  String itemCode;
  String serialNo;
  int weight;
  String itemName;
  int itmsGrpCod;
  String uOM;
  int price;
  int amount;
  int qty;
  String itmsGrpNam;
  String picturName;
  String imgUrl;

  Result(
      {this.flag,
      this.taxCode,
      this.itemCode,
      this.serialNo,
      this.weight,
      this.itemName,
      this.itmsGrpCod,
      this.uOM,
      this.price,
      this.amount,
      this.qty,
      this.itmsGrpNam,
      this.picturName,
      this.imgUrl});

  Result.fromJson(Map<String, dynamic> json) {
    flag = json['Flag'];
    taxCode = json['TaxCode'];
    itemCode = json['ItemCode'];
    serialNo = json['SerialNo'];
    weight = json['Weight'];
    itemName = json['ItemName'];
    itmsGrpCod = json['ItmsGrpCod'];
    uOM = json['UOM'];
    price = json['Price'];
    amount = json['Amount'];
    qty = json['Qty'];
    itmsGrpNam = json['ItmsGrpNam'];
    picturName = json['PicturName'];
    imgUrl = json['ImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Flag'] = this.flag;
    data['TaxCode'] = this.taxCode;
    data['ItemCode'] = this.itemCode;
    data['SerialNo'] = this.serialNo;
    data['Weight'] = this.weight;
    data['ItemName'] = this.itemName;
    data['ItmsGrpCod'] = this.itmsGrpCod;
    data['UOM'] = this.uOM;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['Qty'] = this.qty;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    data['PicturName'] = this.picturName;
    data['ImgUrl'] = this.imgUrl;
    return data;
  }
}
