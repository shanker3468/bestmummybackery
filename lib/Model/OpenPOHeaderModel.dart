class OpenPOHeaderModel {
  int status;
  List<OpenPOResult> result;

  OpenPOHeaderModel({this.status, this.result});

  OpenPOHeaderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<OpenPOResult>();
      json['result'].forEach((v) {
        result.add(new OpenPOResult.fromJson(v));
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

class OpenPOResult {
  int pOEntry;
  int pONo;
  String pODate;
  String cardCode;
  String cardName;

  OpenPOResult(
      {this.pOEntry, this.pONo, this.pODate, this.cardCode, this.cardName});

  OpenPOResult.fromJson(Map<String, dynamic> json) {
    pOEntry = json['POEntry'];
    pONo = json['PONo'];
    pODate = json['PODate'];
    cardCode = json['CardCode'];
    cardName = json['CardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['POEntry'] = this.pOEntry;
    data['PONo'] = this.pONo;
    data['PODate'] = this.pODate;
    data['CardCode'] = this.cardCode;
    data['CardName'] = this.cardName;
    return data;
  }
}

class OpenPOResultSearch {
  int pOEntry;
  int pONo;
  String pODate;
  String cardCode;
  String cardName;

  OpenPOResultSearch(
      this.pOEntry, this.pONo, this.pODate, this.cardCode, this.cardName);
}
