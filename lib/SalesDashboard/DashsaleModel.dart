class DashsaleModel {
  List<Testdata> testdata;

  DashsaleModel({this.testdata});

  DashsaleModel.fromJson(Map<String, dynamic> json) {
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
  var code;
  String location;
  var card;
  var cash;
  var uPI;
  var others;
  var sales;
  var dinning;
  var takeaway;

  Testdata(
      {this.code,
        this.location,
        this.card,
        this.cash,
        this.uPI,
        this.others,
        this.sales,this.dinning,this.takeaway});

  Testdata.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    location = json['Location'];
    card = json['Card'];
    cash = json['Cash'];
    uPI = json['UPI'];
    others = json['Others'];
    sales = json['Sales'];
    dinning = json['Dinning'];
    takeaway = json['TakeAway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Location'] = this.location;
    data['Card'] = this.card;
    data['Cash'] = this.cash;
    data['UPI'] = this.uPI;
    data['Others'] = this.others;
    data['Sales'] = this.sales;
    data['Dinning'] = this.dinning;
    data['TakeAway'] = this.takeaway;
    return data;
  }
}
