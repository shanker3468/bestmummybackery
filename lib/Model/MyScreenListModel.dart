class MyScreenListModel {
  List<Testdata> testdata;

  MyScreenListModel({this.testdata});

  MyScreenListModel.fromJson(Map<String, dynamic> json) {
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
  int screenId;
  String screenName;

  Testdata({this.screenId, this.screenName});

  Testdata.fromJson(Map<String, dynamic> json) {
    screenId = json['ScreenId'];
    screenName = json['ScreenName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScreenId'] = this.screenId;
    data['ScreenName'] = this.screenName;
    return data;
  }
}
