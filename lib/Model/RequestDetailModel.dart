class RequestDetailModel {
  int status;
  List<Result> result;

  RequestDetailModel({this.status, this.result});

  RequestDetailModel.fromJson(Map<String, dynamic> json) {
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
  var rowID;
  var docNo;
  var lineID;
  String itemCode;
  String itemName;
  var locCode;
  String locName;
  var reqQty;
  var transferQty;
  String uom;
  var status;
  String remarks;
  var sapStatus;
  var createdBy;
  String createdDate;
  double UserQty = 0;
  Result(
      {this.rowID,
      this.docNo,
      this.lineID,
      this.itemCode,
      this.itemName,
      this.locCode,
      this.locName,
      this.reqQty,
      this.transferQty,
      this.uom,
      this.status,
      this.remarks,
      this.sapStatus,
      this.createdBy,
      this.createdDate,
      this.UserQty});

  Result.fromJson(Map<String, dynamic> json) {
    rowID = json['RowID'];
    docNo = json['DocNo'];
    lineID = json['LineID'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    reqQty = json['ReqQty'];
    transferQty = json['TransferQty'];
    uom = json['Uom'];
    status = json['Status'];
    remarks = json['Remarks'];
    sapStatus = json['SapStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowID;
    data['DocNo'] = this.docNo;
    data['LineID'] = this.lineID;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['ReqQty'] = this.reqQty;
    data['TransferQty'] = this.transferQty;
    data['Uom'] = this.uom;
    data['Status'] = this.status;
    data['Remarks'] = this.remarks;
    data['SapStatus'] = this.sapStatus;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
