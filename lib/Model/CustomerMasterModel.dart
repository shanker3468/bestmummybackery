class CustomerMasterModel {
  int status;
  List<Result> result;

  CustomerMasterModel({this.status, this.result});

  CustomerMasterModel.fromJson(Map<String, dynamic> json) {
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
  var docNo;
  String docDate;
  String cusCode;
  String cusName;
  var cusWhatsAppNo;
  String email;
  String discount;
  String remaks;
  var status;
  var sapStatus;
  var sapRefNo;
  var createdBy;
  String createdDate;
  var modifiedBy;
  var modifiedDate;

  Result(
      {this.docNo,
      this.docDate,
      this.cusCode,
      this.cusName,
      this.cusWhatsAppNo,
      this.email,
      this.discount,
      this.remaks,
      this.status,
      this.sapStatus,
      this.sapRefNo,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    docDate = json['DocDate'];
    cusCode = json['CusCode'];
    cusName = json['CusName'];
    cusWhatsAppNo = json['CusWhatsAppNo'];
    email = json['Email'];
    discount = json['Discount'];
    remaks = json['Remaks'];
    status = json['Status'];
    sapStatus = json['SapStatus'];
    sapRefNo = json['SapRefNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DocDate'] = this.docDate;
    data['CusCode'] = this.cusCode;
    data['CusName'] = this.cusName;
    data['CusWhatsAppNo'] = this.cusWhatsAppNo;
    data['Email'] = this.email;
    data['Discount'] = this.discount;
    data['Remaks'] = this.remaks;
    data['Status'] = this.status;
    data['SapStatus'] = this.sapStatus;
    data['SapRefNo'] = this.sapRefNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    return data;
  }
}
