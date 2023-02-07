class KottblMaster {
  var status;
  List<Result> result;

  KottblMaster({this.status, this.result});

  KottblMaster.fromJson(Map<String, dynamic> json) {
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
  String creationName;
  var location;
  String locationName;
  var occCode;
  String occName;
  var tableNo;
  String seatNo;
  String docDate;
  var createBy;
  String active;

  Result(
      {this.docNo,
        this.creationName,
        this.location,
        this.locationName,
        this.occCode,
        this.occName,
        this.tableNo,
        this.seatNo,
        this.docDate,
        this.createBy,
        this.active});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    creationName = json['CreationName'];
    location = json['Location'];
    locationName = json['LocationName'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    tableNo = json['TableNo'];
    seatNo = json['SeatNo'];
    docDate = json['DocDate'];
    createBy = json['CreateBy'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['CreationName'] = this.creationName;
    data['Location'] = this.location;
    data['LocationName'] = this.locationName;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['TableNo'] = this.tableNo;
    data['SeatNo'] = this.seatNo;
    data['DocDate'] = this.docDate;
    data['CreateBy'] = this.createBy;
    data['Active'] = this.active;
    return data;
  }
}
