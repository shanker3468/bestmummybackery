class PriceListSyncModel {
  List<Testdata> testdata;

  PriceListSyncModel({this.testdata});

  PriceListSyncModel.fromJson(Map<String, dynamic> json) {
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
  var docNo;
  String itemCode;
  String itemName;
  String itemUOM;
  var location;
  String locationName;
  String variance;
  var occCode;
  String occName;
  var rate;
  String active;
  String docDate;
  var createBy;
  var tapIndex;
  var sync;

  Testdata(
      {this.docNo,
      this.itemCode,
      this.itemName,
      this.itemUOM,
      this.location,
      this.locationName,
      this.variance,
      this.occCode,
      this.occName,
      this.rate,
      this.active,
      this.docDate,
      this.createBy,
      this.tapIndex,
      this.sync});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemUOM = json['ItemUOM'];
    location = json['Location'];
    locationName = json['LocationName'];
    variance = json['variance'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    rate = json['Rate'];
    active = json['Active'];
    docDate = json['DocDate'];
    createBy = json['CreateBy'];
    tapIndex = json['TapIndex'];
    sync = json['Sync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemUOM'] = this.itemUOM;
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['variance'] = this.variance;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['Rate'] = this.rate;
    data['Active'] = this.active;
    data['DocDate'] = this.docDate;
    data['CreateBy'] = this.createBy;
    data['TapIndex'] = this.tapIndex;
    data['Sync'] = this.sync;
    return data;
  }
}
