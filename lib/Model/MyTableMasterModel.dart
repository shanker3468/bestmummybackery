class MyTableMasterModel {
  List<Testdata> testdata;

  MyTableMasterModel({this.testdata});

  MyTableMasterModel.fromJson(Map<String, dynamic> json) {
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
  String createName;
  var location;
  String locationName;
  var occCode;
  String occName;
  var tableNo;
  var totalSeats;
  String docDate;
  var userId;
  String active;

  Testdata(
      {this.docNo,
      this.createName,
      this.location,
      this.locationName,
      this.occCode,
      this.occName,
      this.tableNo,
      this.totalSeats,
      this.docDate,
      this.userId,
      this.active});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    createName = json['CreateName'];
    location = json['Location'];
    locationName = json['LocationName'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    tableNo = json['TableNo'];
    totalSeats = json['TotalSeats'];
    docDate = json['DocDate'];
    userId = json['UserId'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['CreateName'] = this.createName;
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['TableNo'] = this.tableNo;
    data['TotalSeats'] = this.totalSeats;
    data['DocDate'] = this.docDate;
    data['UserId'] = this.userId;
    data['Active'] = this.active;
    return data;
  }
}
