class PriceListVarianceModel {
  List<Testdata> testdata;

  PriceListVarianceModel({this.testdata});

  PriceListVarianceModel.fromJson(Map<String, dynamic> json) {
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
  String variance;
  String ItemNos;

  Testdata({this.itemCode, this.variance});

  Testdata.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    variance = json['Variance'];
    ItemNos = json['ItemNos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemCode'] = this.itemCode;
    data['Variance'] = this.variance;
    data['ItemNos'] = this.ItemNos;
    return data;
  }
}
