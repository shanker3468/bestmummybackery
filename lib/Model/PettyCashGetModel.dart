class PettyCashGetModel {
  List<Testdata> testdata;

  PettyCashGetModel({this.testdata});

  PettyCashGetModel.fromJson(Map<String, dynamic> json) {
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
  int docNo;
  int locCode;
  String locName;
  var pettycashLimit;
  var advance;
  var currentamount;
  var expenseamount;
  int createBy;
  String docDate;
  String active;

  Testdata(
      {this.docNo,
      this.locCode,
      this.locName,
      this.pettycashLimit,
      this.advance,
      this.currentamount,
      this.expenseamount,
      this.createBy,
      this.docDate,
      this.active});

  Testdata.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    pettycashLimit = json['PettycashLimit'];
    advance = json['Advance'];
    currentamount = json['Currentamount'];
    expenseamount = json['Expenseamount'];
    createBy = json['CreateBy'];
    docDate = json['DocDate'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['PettycashLimit'] = this.pettycashLimit;
    data['Advance'] = this.advance;
    data['Currentamount'] = this.currentamount;
    data['Expenseamount'] = this.expenseamount;
    data['CreateBy'] = this.createBy;
    data['DocDate'] = this.docDate;
    data['Active'] = this.active;
    return data;
  }
}
