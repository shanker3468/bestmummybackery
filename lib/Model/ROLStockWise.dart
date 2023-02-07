class ROLStockWise {
  int status;
  List<Result> result;

  ROLStockWise({this.status, this.result});

  ROLStockWise.fromJson(Map<String, dynamic> json) {
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
  int onHand;
  String uUOM;
  String itmsGrpNam;
  String uActive;
  String uLocation;
  String uDay;
  int uMax;
  int uMin;
  String uWhsCode;
  String uWhsName;
  String wEEKDAYS;

  Result(
      {this.uItemCode,
      this.uItemName,
      this.onHand,
      this.uUOM,
      this.itmsGrpNam,
      this.uActive,
      this.uLocation,
      this.uDay,
      this.uMax,
      this.uMin,
      this.uWhsCode,
      this.uWhsName,
      this.wEEKDAYS});

  Result.fromJson(Map<String, dynamic> json) {
    uItemCode = json['U_ItemCode'];
    uItemName = json['U_ItemName'];
    onHand = json['OnHand'];
    uUOM = json['U_UOM'];
    itmsGrpNam = json['ItmsGrpNam'];
    uActive = json['U_Active'];
    uLocation = json['U_Location'];
    uDay = json['U_Day'];
    uMax = json['U_Max'];
    uMin = json['U_Min'];
    uWhsCode = json['U_WhsCode'];
    uWhsName = json['U_WhsName'];
    wEEKDAYS = json['WEEKDAYS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['U_ItemCode'] = this.uItemCode;
    data['U_ItemName'] = this.uItemName;
    data['OnHand'] = this.onHand;
    data['U_UOM'] = this.uUOM;
    data['ItmsGrpNam'] = this.itmsGrpNam;
    data['U_Active'] = this.uActive;
    data['U_Location'] = this.uLocation;
    data['U_Day'] = this.uDay;
    data['U_Max'] = this.uMax;
    data['U_Min'] = this.uMin;
    data['U_WhsCode'] = this.uWhsCode;
    data['U_WhsName'] = this.uWhsName;
    data['WEEKDAYS'] = this.wEEKDAYS;
    return data;
  }
}
