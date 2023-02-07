class ItemMasterSyncModel {
  int status;
  List<Result> result;

  ItemMasterSyncModel({this.status, this.result});

  ItemMasterSyncModel.fromJson(Map<String, dynamic> json) {
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
  var flag;
  String itemCode;
  String itemName;
  var itmsGrpCod;
  String invntryUom;
  String picturName;
  var onHand;
  var QryGroup1;
  var QryGroup2;
  var QryGroup3;
  var QryGroup4;
  var QryGroup5;
  var QryGroup6;
  var QryGroup7;
  var QryGroup8;
  var QryGroup9;
  var QryGroup10;
  var QryGroup11;

  Result(
      {this.flag,
      this.itemCode,
      this.itemName,
      this.itmsGrpCod,
      this.invntryUom,
      this.picturName,
      this.onHand,
      this.QryGroup1,
      this.QryGroup2,
      this.QryGroup3,
      this.QryGroup4,
      this.QryGroup5,
      this.QryGroup6,
      this.QryGroup7,
      this.QryGroup8,this.QryGroup9,this.QryGroup10,this.QryGroup11
      });

  Result.fromJson(Map<String, dynamic> json) {
    flag = json['Flag'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itmsGrpCod = json['ItmsGrpCod'];
    invntryUom = json['InvntryUom'];
    picturName = json['PicturName'];
    onHand = json['OnHand'];
    QryGroup1 = json['QryGroup1'];
    QryGroup2 = json['QryGroup2'];
    QryGroup3 = json['QryGroup3'];
    QryGroup4 = json['QryGroup4'];
    QryGroup5 = json['QryGroup5'];
    QryGroup6 = json['QryGroup6'];
    QryGroup7 = json['QryGroup7'];
    QryGroup8 = json['QryGroup8'];
    QryGroup9 = json['QryGroup9'];
    QryGroup10 = json['QryGroup10'];
    QryGroup11 = json['QryGroup11'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Flag'] = this.flag;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItmsGrpCod'] = this.itmsGrpCod;
    data['InvntryUom'] = this.invntryUom;
    data['PicturName'] = this.picturName;
    data['OnHand'] = this.onHand;
    data['QryGroup1'] = this.QryGroup1;
    data['QryGroup2'] = this.QryGroup2;
    data['QryGroup3'] = this.QryGroup3;
    data['QryGroup4'] = this.QryGroup4;
    data['QryGroup5'] = this.QryGroup5;
    data['QryGroup6'] = this.QryGroup6;
    data['QryGroup7'] = this.QryGroup7;
    data['QryGroup8'] = this.QryGroup8;
    data['QryGroup9'] = this.QryGroup9;
    data['QryGroup10'] = this.QryGroup10;
    data['QryGroup11'] = this.QryGroup11;
    return data;
  }
}
