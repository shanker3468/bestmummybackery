class PromotionGetModel {
  List<Testdata> testdata;

  PromotionGetModel({this.testdata});

  PromotionGetModel.fromJson(Map<String, dynamic> json) {
    if (json['testdata'] != null) {
      testdata = <Testdata>[];
      json['testdata'].forEach((v) {
        testdata.add(new Testdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.testdata != null) {
      data['testdata'] = this.testdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testdata {
  String itemCode;
  String itemName;
  int lineId;
  int lineDocNo;
  String lActive;

  Testdata(
      {this.itemCode,
      this.itemName,
      this.lineId,
      this.lineDocNo,
      this.lActive});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    lineId = json['LineId'];
    lineDocNo = json['LineDocNo'];
    lActive = json['LActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['LineId'] = this.lineId;
    data['LineDocNo'] = this.lineDocNo;
    data['LActive'] = this.lActive;
    return data;
  }
}
