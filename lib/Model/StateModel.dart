class StateModel {
  int status;
  List<Result> result;

  StateModel({this.status, this.result});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result>();
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
  var code;
  String name;
  String country;

  Result({this.code, this.name, this.country});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    country = json['Country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Country'] = this.country;
    return data;
  }
}
