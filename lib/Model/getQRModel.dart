class getQRModel {
  int status;
  List<Result> result;

  getQRModel({this.status, this.result});

  getQRModel.fromJson(Map<String, dynamic> json) {
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
  String docDate;
  String itemGroupCode;
  String itemGroupName;
  String itemCode;
  String itemName;
  String uom;
  String box;
  String tray;
  String packetType;
  var weight;
  String qRCode;
  int status;
  int sapStatus;
  int createdBy;
  String createdDate;
  int qty;
  int branchID;
  var remarks;

  Result(
      {this.docNo,
      this.docDate,
      this.itemGroupCode,
      this.itemGroupName,
      this.itemCode,
      this.itemName,
      this.uom,
      this.box,
      this.tray,
      this.packetType,
      this.weight,
      this.qRCode,
      this.status,
      this.sapStatus,
      this.createdBy,
      this.createdDate,
      this.qty,
      this.branchID,
      this.remarks});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    itemGroupCode = json['ItemGroupCode'];
    itemGroupName = json['ItemGroupName'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    uom = json['Uom'];
    box = json['Box'];
    tray = json['Tray'];
    packetType = json['PacketType'];
    weight = json['Weight'];
    qRCode = json['QRCode'];
    status = json['Status'];
    sapStatus = json['SapStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    qty = json['Qty'];
    branchID = json['BranchID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['ItemGroupCode'] = this.itemGroupCode;
    data['ItemGroupName'] = this.itemGroupName;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['Uom'] = this.uom;
    data['Box'] = this.box;
    data['Tray'] = this.tray;
    data['PacketType'] = this.packetType;
    data['Weight'] = this.weight;
    data['QRCode'] = this.qRCode;
    data['Status'] = this.status;
    data['SapStatus'] = this.sapStatus;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['Qty'] = this.qty;
    data['BranchID'] = this.branchID;
    return data;
  }
}
