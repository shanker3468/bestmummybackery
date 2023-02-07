class TransferModel {
  int status;
  List<Result3> result;

  TransferModel({this.status, this.result});

  TransferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<Result3>();
      json['result'].forEach((v) {
        result.add(new Result3.fromJson(v));
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

class Result3 {
  int docNo;
  String docDate;
  String itemCode;
  String itemName;
  String locCode;
  String locName;
  var reqQty;
  var TransferQty;
  String uom;
  int status;
  String remarks;
  String sapStatus;
  int createdBy;
  String createdDate;
  int modifiedBy;
  String modifiedDate;
  var DocEntry;
  var RequestLocation;

  Result3(
      {this.docNo,
      this.docDate,
      this.itemCode,
      this.itemName,
      this.locCode,
      this.locName,
      this.reqQty,
      this.TransferQty,
      this.uom,
      this.status,
      this.remarks,
      this.sapStatus,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.DocEntry,this.RequestLocation});

  Result3.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    reqQty = json['ReqQty'];
    uom = json['Uom'];
    status = json['Status'];
    remarks = json['Remarks'];
    sapStatus = json['SapStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    DocEntry = json['DocEntry'];
    RequestLocation = json['RequestLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['LocCode'] = this.locCode;
    data['LocName'] = this.locName;
    data['ReqQty'] = this.reqQty;
    data['Uom'] = this.uom;
    data['Status'] = this.status;
    data['Remarks'] = this.remarks;
    data['SapStatus'] = this.sapStatus;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['DocEntry'] = this.DocEntry;
    data['RequestLocation'] = this.RequestLocation;
    return data;
  }
}
