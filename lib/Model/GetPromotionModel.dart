class GetPromotionModel {
  List<Testdata> testdata;

  GetPromotionModel({this.testdata});

  GetPromotionModel.fromJson(Map<String, dynamic> json) {
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
  String discountName;
  String locationName;
  String amtPer;
  String active;
  var docNo;

  Testdata(
      {this.discountName,
      this.locationName,
      this.amtPer,
      this.active,
      this.docNo});

  Testdata.fromJson(Map<String, dynamic> json) {
    discountName = json['DiscountName'];
    locationName = json['LocationName'];
    amtPer = json['AmtPer'];
    active = json['Active'];
    docNo = json['DocNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DiscountName'] = this.discountName;
    data['LocationName'] = this.locationName;
    data['AmtPer'] = this.amtPer;
    data['Active'] = this.active;
    data['DocNo'] = this.docNo;
    return data;
  }
}
