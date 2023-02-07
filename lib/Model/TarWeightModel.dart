class TarWeightModel {
  int status;
  List<Result> result;

  TarWeightModel({this.status, this.result});

  TarWeightModel.fromJson(Map<String, dynamic> json) {
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
  int docNo;
  String docDate;
  String itemCode;
  String itemName;
  String serialNo;
  var weight;
  var status;
  String remarks;
  int sapStatus;
  int sapRefNo;
  int createdBy;
  String createdDate;
  var modifiedBy;
  var modifiedDate;
  String itemGroupCode;
  String itemGroupName;

  Result(
      {this.docNo,
      this.docDate,
      this.itemCode,
      this.itemName,
      this.serialNo,
      this.weight,
      this.status,
      this.remarks,
      this.sapStatus,
      this.sapRefNo,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.itemGroupCode,
      this.itemGroupName});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    serialNo = json['SerialNo'];
    weight = json['Weight'];
    status = json['Status'];
    remarks = json['Remarks'];
    sapStatus = json['SapStatus'];
    sapRefNo = json['SapRefNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    itemGroupCode = json['ItemGroupCode'];
    itemGroupName = json['ItemGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['SerialNo'] = this.serialNo;
    data['Weight'] = this.weight;
    data['Status'] = this.status;
    data['Remarks'] = this.remarks;
    data['SapStatus'] = this.sapStatus;
    data['SapRefNo'] = this.sapRefNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['ItemGroupCode'] = this.itemGroupCode;
    data['ItemGroupName'] = this.itemGroupName;
    return data;
  }
}
