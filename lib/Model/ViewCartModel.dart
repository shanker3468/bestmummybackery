class ViewCartModel {
  int status;
  List<Result> result;

  ViewCartModel({this.status, this.result});

  ViewCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int docNo;
  String docDate;
  int categoryCode;
  String categoryName;
  String itemCode;
  String itemName;
  String itemGroupCode;
  String uom;
  int qty;
  int price;
  int total;
  String addtoCart;
  int screenID;
  String screenName;
  int createdBy;
  String createdDatetime;
  var modifiedBy;
  var modifiedDatetime;
  int status;
  String pictureName;
  String pictureURL;

  Result(
      {this.docNo,
      this.docDate,
      this.categoryCode,
      this.categoryName,
      this.itemCode,
      this.itemName,
      this.itemGroupCode,
      this.uom,
      this.qty,
      this.price,
      this.total,
      this.addtoCart,
      this.screenID,
      this.screenName,
      this.createdBy,
      this.createdDatetime,
      this.modifiedBy,
      this.modifiedDatetime,
      this.status,
      this.pictureName,
      this.pictureURL});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    categoryCode = json['CategoryCode'];
    categoryName = json['CategoryName'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemGroupCode = json['ItemGroupCode'];
    uom = json['Uom'];
    qty = json['Qty'];
    price = json['Price'];
    total = json['Total'];
    addtoCart = json['AddtoCart'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    createdBy = json['CreatedBy'];
    createdDatetime = json['CreatedDatetime'];
    modifiedBy = json['ModifiedBy'];
    modifiedDatetime = json['ModifiedDatetime'];
    status = json['Status'];
    pictureName = json['PictureName'];
    pictureURL = json['PictureURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['CategoryCode'] = this.categoryCode;
    data['CategoryName'] = this.categoryName;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemGroupCode'] = this.itemGroupCode;
    data['Uom'] = this.uom;
    data['Qty'] = this.qty;
    data['Price'] = this.price;
    data['Total'] = this.total;
    data['AddtoCart'] = this.addtoCart;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDatetime'] = this.createdDatetime;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDatetime'] = this.modifiedDatetime;
    data['Status'] = this.status;
    data['PictureName'] = this.pictureName;
    data['PictureURL'] = this.pictureURL;
    return data;
  }
}
