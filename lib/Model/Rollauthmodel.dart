class Rollauthmodel {
  List<Testdata> testdata;

  Rollauthmodel({this.testdata});

  Rollauthmodel.fromJson(Map<String, dynamic> json) {
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
  var location;
  String disType;
  String valuess;
  String rallName;
  String docDate;
  var createBy;
  String active;

  Testdata(
      {this.docNo,
        this.location,
        this.disType,
        this.valuess,
        this.rallName,
        this.docDate,
        this.createBy,
        this.active});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    location = json['Location'];
    disType = json['DisType'];
    valuess = json['Valuess'];
    rallName = json['RallName'];
    docDate = json['DocDate'];
    createBy = json['CreateBy'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['Location'] = this.location;
    data['DisType'] = this.disType;
    data['Valuess'] = this.valuess;
    data['RallName'] = this.rallName;
    data['DocDate'] = this.docDate;
    data['CreateBy'] = this.createBy;
    data['Active'] = this.active;
    return data;
  }
}
