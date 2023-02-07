class CounterModel {
  int status;
  List<CounterResult> result;

  CounterModel({this.status, this.result});

  CounterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<CounterResult>();
      json['result'].forEach((v) {
        result.add(new CounterResult.fromJson(v));
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

class CounterResult {
  int docNo;
  String docDate;
  String locationCode;
  String locationName;
  String systemIpAddress;
  String systemMacAddress;
  int status;
  String counterName;

  CounterResult(
      {this.docNo,
      this.docDate,
      this.locationCode,
      this.locationName,
      this.systemIpAddress,
      this.systemMacAddress,
      this.status,
      this.counterName});

  CounterResult.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    locationCode = json['LocationCode'];
    locationName = json['LocationName'];
    systemIpAddress = json['SystemIpAddress'];
    systemMacAddress = json['SystemMacAddress'];
    status = json['Status'];
    counterName = json['CounterName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['LocationCode'] = this.locationCode;
    data['LocationName'] = this.locationName;
    data['SystemIpAddress'] = this.systemIpAddress;
    data['SystemMacAddress'] = this.systemMacAddress;
    data['Status'] = this.status;
    data['CounterName'] = this.counterName;
    return data;
  }
}
