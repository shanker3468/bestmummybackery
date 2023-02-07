class GetIPAddressModel {
  List<Testdata> testdata;

  GetIPAddressModel({this.testdata});

  GetIPAddressModel.fromJson(Map<String, dynamic> json) {
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
  int sNo;
  String iPAddress;
  int pORT;
  String bRANCENAME;
  String sYSNAME;

  Testdata(
      {this.sNo, this.iPAddress, this.pORT, this.bRANCENAME, this.sYSNAME});

  Testdata.fromJson(Map<String, dynamic> json) {
    sNo = json['S.No'];
    iPAddress = json['IPAddress'];
    pORT = json['PORT'];
    bRANCENAME = json['BRANCENAME'];
    sYSNAME = json['SYSNAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['S.No'] = this.sNo;
    data['IPAddress'] = this.iPAddress;
    data['PORT'] = this.pORT;
    data['BRANCENAME'] = this.bRANCENAME;
    data['SYSNAME'] = this.sYSNAME;
    return data;
  }
}
