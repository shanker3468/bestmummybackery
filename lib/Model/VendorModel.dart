class VendorModel {
  int status;
  List<VendorResult> result;

  VendorModel({this.status, this.result});

  VendorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<VendorResult>();
      json['result'].forEach((v) {
        result.add(new VendorResult.fromJson(v));
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

class VendorResult {
  String cardCode;
  String cardName;

  VendorResult({this.cardCode, this.cardName});

  VendorResult.fromJson(Map<String, dynamic> json) {
    cardCode = json['CardCode'];
    cardName = json['CardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CardCode'] = this.cardCode;
    data['CardName'] = this.cardName;
    return data;
  }
}
