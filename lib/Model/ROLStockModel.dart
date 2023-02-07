class ROLStockModel {
  int status;
  List<Result> result;

  ROLStockModel({this.status, this.result});

  ROLStockModel.fromJson(Map<String, dynamic> json) {
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
  String uItemCode;
  String uItemName;
  String uUOM;
  String itmsGrpNam;

  Result({this.uItemCode, this.uItemName, this.uUOM, this.itmsGrpNam});

  Result.fromJson(Map<String, dynamic> json) {
    uItemCode = json['U_ItemCode'];
    uItemName = json['U_ItemName'];
    uUOM = json['U_UOM'];
    itmsGrpNam = json['ItmsGrpNam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['U_ItemCode'] = this.uItemCode;
    data['U_ItemName'] = this.uItemName;
    data['U_UOM'] = this.uUOM;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    return data;
  }
}
