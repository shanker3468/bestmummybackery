class Reasonmodel {
  int status;
  List<Result> result;

  Reasonmodel({this.status, this.result});

  Reasonmodel.fromJson(Map<String, dynamic> json) {
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
  var docNo;
  String docDate;
  var locationCode;
  String locationName;
  var occCode;
  String occName;
  String remarks;
  var status;
  var createdBy;
  String createdDate;

  Result(
      {this.docNo,
      this.docDate,
      this.locationCode,
      this.locationName,
      this.occCode,
      this.occName,
      this.remarks,
      this.status,
      this.createdBy,
      this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    locationCode = json['LocationCode'];
    locationName = json['LocationName'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    remarks = json['Remarks'];
    status = json['Status'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['LocationCode'] = this.locationCode;
    data['LocationName'] = this.locationName;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['Remarks'] = this.remarks;
    data['Status'] = this.status;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
