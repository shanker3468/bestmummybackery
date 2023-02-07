class DespatchLocationwise {
  List<Testdata> testdata;

  DespatchLocationwise({this.testdata});

  DespatchLocationwise.fromJson(Map<String, dynamic> json) {
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
  var locationId;
  String location;
  String name;
  var ammount;
  var empid;

  Testdata({this.locationId, this.location,this.name, this.ammount,this.empid});

  Testdata.fromJson(Map<String, dynamic> json) {
    locationId = json['LocationId'];
    location = json['Location'];
    name = json['Name'];
    ammount = json['Ammount'];
    empid = json['EmpId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocationId'] = this.locationId;
    data['Location'] = this.location;
    data['Name'] = this.name;
    data['Ammount'] = this.ammount;
    data['EmpId'] = this.empid;
    return data;
  }
}
