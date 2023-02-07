class SalesOrderModel {
  int status;
  List<Result> result;

  SalesOrderModel({this.status, this.result});

  SalesOrderModel.fromJson(Map<String, dynamic> json) {
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
  var docEntry;
  var docNum;
  String docDate;
  String docDueDate;
  var prodEntry;
  var ShopName;
  var OccName;
  var DeliveryDate;
  var BranchID;
  var Branch;
  var DeliveryTime;

  Result(
      {this.docEntry,
      this.docNum,
      this.docDate,
      this.docDueDate,
      this.prodEntry,
      this.ShopName,this.OccName,this.DeliveryDate,this.BranchID,this.Branch,this.DeliveryTime});

  Result.fromJson(Map<String, dynamic> json) {
    docEntry = json['DocEntry'];
    docNum = json['DocNo'];
    docDate = json['DocDate'];
    docDueDate = json['DocDueDate'];
    prodEntry = json['ProdEntry'];
    ShopName = json['ShapeName'];
    OccName = json['OccName'];
    DeliveryDate = json['DeliveryDate'];
    BranchID = json['BranchID'];
    Branch = json['Branch'];
    DeliveryTime = json['DeliveryTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocEntry'] = this.docEntry;
    data['DocNo'] = this.docNum;
    data['DocDate'] = this.docDate;
    data['DocDueDate'] = this.docDueDate;
    data['ProdEntry'] = this.prodEntry;
    data['ShapeName'] = this.ShopName;
    data['OccName'] = this.OccName;
    data['DeliveryDate'] = this.DeliveryDate;
    data['BranchID'] = this.BranchID;
    data['Branch'] = this.Branch;
    data['DeliveryTime'] = this.DeliveryTime;
    return data;
  }
}
