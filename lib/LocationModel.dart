class LocationModel {
  int status;
  List<LocationResult> result;

  LocationModel({this.status, this.result});

  LocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<LocationResult>();
      json['result'].forEach((v) {
        result.add(new LocationResult.fromJson(v));
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

class LocationResult {
  var code;
  String name;
  String bankAccount;
  var fassi;

  LocationResult({this.code, this.name});

  LocationResult.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    bankAccount = json['BankAccount'];
    fassi = json['Fassi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['BankAccount'] = this.bankAccount;
    data['Fassi'] = this.fassi;
    return data;
  }
}
