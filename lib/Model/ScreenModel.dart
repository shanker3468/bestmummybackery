class ScreenModel {
  int status;
  List<Result> result;

  ScreenModel({this.status, this.result});

  ScreenModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int docNo;
  int screenID;
  String screenName;
  int status;

  Result({this.docNo, this.screenID, this.screenName, this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    screenID = json['ScreenID'];
    screenName = json['ScreenName'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ScreenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    data['Status'] = this.status;
    return data;
  }
}
