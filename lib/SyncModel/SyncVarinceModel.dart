class SyncVarinceModel {
  int status;
  List<Result> result;

  SyncVarinceModel({this.status, this.result});

  SyncVarinceModel.fromJson(Map<String, dynamic> json) {
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
  var docNum;
  String docDate;
  String itemCode;
  String itemName;
  String itemVariance;
  String itemNos;
  var itemPieceCount;
  String active;
  var lineNumber;

  Result(
      {this.docNum,
      this.docDate,
      this.itemCode,
      this.itemName,
      this.itemVariance,
      this.itemNos,
      this.itemPieceCount,
      this.active,
      this.lineNumber});

  Result.fromJson(Map<String, dynamic> json) {
    docNum = json['DocNum'];
    docDate = json['DocDate'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemVariance = json['ItemVariance'];
    itemNos = json['ItemNos'];
    itemPieceCount = json['ItemPieceCount'];
    active = json['Active'];
    lineNumber = json['LineNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNum'] = this.docNum;
    data['DocDate'] = this.docDate;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemVariance'] = this.itemVariance;
    data['ItemNos'] = this.itemNos;
    data['ItemPieceCount'] = this.itemPieceCount;
    data['Active'] = this.active;
    data['LineNumber'] = this.lineNumber;
    return data;
  }
}
