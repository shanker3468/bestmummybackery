// ignore_for_file: camel_case_types

class getBillNo {
  List<Testdata> testdata;

  getBillNo({this.testdata});

  getBillNo.fromJson(Map<String, dynamic> json) {
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
  String numAtCard;
  int docEntry;
  int docNum;
  var docTotal;

  Testdata({this.numAtCard, this.docEntry, this.docNum, this.docTotal});

  Testdata.fromJson(Map<String, dynamic> json) {
    numAtCard = json['NumAtCard'];
    docEntry = json['DocEntry'];
    docNum = json['DocNum'];
    docTotal = json['DocTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NumAtCard'] = this.numAtCard;
    data['DocEntry'] = this.docEntry;
    data['DocNum'] = this.docNum;
    data['DocTotal'] = this.docTotal;
    return data;
  }
}
