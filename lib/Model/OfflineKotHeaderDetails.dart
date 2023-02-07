class OfflineKotHeaderDetails {
  var status;
  List<Header> header;
  var status1;
  List<Detail> detail;

  OfflineKotHeaderDetails(
      {this.status, this.header, this.status1, this.detail});

  OfflineKotHeaderDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['Header'] != null) {
      header = <Header>[];
      json['Header'].forEach((v) {
        header.add(new Header.fromJson(v));
      });
    }
    status1 = json['status1'];
    if (json['Detail'] != null) {
      detail = <Detail>[];
      json['Detail'].forEach((v) {
        detail.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.header != null) {
      data['Header'] = this.header.map((v) => v.toJson()).toList();
    }
    data['status1'] = this.status1;
    if (this.detail != null) {
      data['Detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Header {
  var orderNo;
  String orderDate;
  String customerNo;
  String deliveryDate;
  String occCode;
  String occName;
  String occDate;
  String message;
  String shapeCode;
  String shapeName;
  String doorDelivery;
  var custCharge;
  var advanceAmount;
  String delStateCode;
  String delStateName;
  String delDistCode;
  String delDistName;
  String delPlaceCode;
  String delPlaceName;
  var delCharge;
  var totQty;
  var totAmount;
  var taxAmount;
  var reqDiscount;
  var balanceDue;
  var overallAmount;
  String orderStatus;
  var approverID;
  String approverName;
  var approvedDiscount;
  String approvedStatus;
  String approvedRemarks1;
  String approvedRemarks2;
  String creationName;
  String tableNo;
  String seatNo;
  var createdBy;
  String createdDate;
  var modifiedBy;
  String modifiedDate;
  var branchID;
  //var sync=0;

  Header(
      {this.orderNo,
      this.orderDate,
      this.customerNo,
      this.deliveryDate,
      this.occCode,
      this.occName,
      this.occDate,
      this.message,
      this.shapeCode,
      this.shapeName,
      this.doorDelivery,
      this.custCharge,
      this.advanceAmount,
      this.delStateCode,
      this.delStateName,
      this.delDistCode,
      this.delDistName,
      this.delPlaceCode,
      this.delPlaceName,
      this.delCharge,
      this.totQty,
      this.totAmount,
      this.taxAmount,
      this.reqDiscount,
      this.balanceDue,
      this.overallAmount,
      this.orderStatus,
      this.approverID,
      this.approverName,
      this.approvedDiscount,
      this.approvedStatus,
      this.approvedRemarks1,
      this.approvedRemarks2,
      this.creationName,
      this.tableNo,
      this.seatNo,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.branchID,
      //this.sync
      });

  Header.fromJson(Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    customerNo = json['CustomerNo'];
    deliveryDate = json['DeliveryDate'];
    occCode = json['OccCode'];
    occName = json['OccName'];
    occDate = json['OccDate'];
    message = json['Message'];
    shapeCode = json['ShapeCode'];
    shapeName = json['ShapeName'];
    doorDelivery = json['DoorDelivery'];
    custCharge = json['CustCharge'];
    advanceAmount = json['AdvanceAmount'];
    delStateCode = json['DelStateCode'];
    delStateName = json['DelStateName'];
    delDistCode = json['DelDistCode'];
    delDistName = json['DelDistName'];
    delPlaceCode = json['DelPlaceCode'];
    delPlaceName = json['DelPlaceName'];
    delCharge = json['DelCharge'];
    totQty = json['TotQty'];
    totAmount = json['TotAmount'];
    taxAmount = json['TaxAmount'];
    reqDiscount = json['ReqDiscount'];
    balanceDue = json['BalanceDue'];
    overallAmount = json['OverallAmount'];
    orderStatus = json['OrderStatus'];
    approverID = json['ApproverID'];
    approverName = json['ApproverName'];
    approvedDiscount = json['ApprovedDiscount'];
    approvedStatus = json['ApprovedStatus'];
    approvedRemarks1 = json['ApprovedRemarks1'];
    approvedRemarks2 = json['ApprovedRemarks2'];
    creationName = json['CreationName'];
    tableNo = json['TableNo'];
    seatNo = json['SeatNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    branchID = json['BranchID'];
    //sync = json['Sync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['CustomerNo'] = this.customerNo;
    data['DeliveryDate'] = this.deliveryDate;
    data['OccCode'] = this.occCode;
    data['OccName'] = this.occName;
    data['OccDate'] = this.occDate;
    data['Message'] = this.message;
    data['ShapeCode'] = this.shapeCode;
    data['ShapeName'] = this.shapeName;
    data['DoorDelivery'] = this.doorDelivery;
    data['CustCharge'] = this.custCharge;
    data['AdvanceAmount'] = this.advanceAmount;
    data['DelStateCode'] = this.delStateCode;
    data['DelStateName'] = this.delStateName;
    data['DelDistCode'] = this.delDistCode;
    data['DelDistName'] = this.delDistName;
    data['DelPlaceCode'] = this.delPlaceCode;
    data['DelPlaceName'] = this.delPlaceName;
    data['DelCharge'] = this.delCharge;
    data['TotQty'] = this.totQty;
    data['TotAmount'] = this.totAmount;
    data['TaxAmount'] = this.taxAmount;
    data['ReqDiscount'] = this.reqDiscount;
    data['BalanceDue'] = this.balanceDue;
    data['OverallAmount'] = this.overallAmount;
    data['OrderStatus'] = this.orderStatus;
    data['ApproverID'] = this.approverID;
    data['ApproverName'] = this.approverName;
    data['ApprovedDiscount'] = this.approvedDiscount;
    data['ApprovedStatus'] = this.approvedStatus;
    data['ApprovedRemarks1'] = this.approvedRemarks1;
    data['ApprovedRemarks2'] = this.approvedRemarks2;
    data['CreationName'] = this.creationName;
    data['TableNo'] = this.tableNo;
    data['SeatNo'] = this.seatNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['BranchID'] = this.branchID;
    //data['Sync'] = this.sync;
    return data;
  }
}

class Detail {
  var rowNo;
  var headerDocNo;
  String docDate;
  var categoryCode;
  String categoryName;
  String itemCode;
  String itemName;
  String itemGroupCode;
  String uom;
  var qty;
  var price;
  var total;
  String creationName;
  var tableNo;
  String seatNo;
  String status;
  String pictureName;
  String pictureURL;
  var createdBy;
  String createdDatetime;
  var modifiedBy;
  String modifiedDatetime;
  var lineID;
  var sync;
  var TaxCode;

  Detail(
      {this.rowNo,
      this.headerDocNo,
      this.docDate,
      this.categoryCode,
      this.categoryName,
      this.itemCode,
      this.itemName,
      this.itemGroupCode,
      this.uom,
      this.qty,
      this.price,
      this.total,
      this.creationName,
      this.tableNo,
      this.seatNo,
      this.status,
      this.pictureName,
      this.pictureURL,
      this.createdBy,
      this.createdDatetime,
      this.modifiedBy,
      this.modifiedDatetime,
      this.lineID,
      this.sync,
      this.TaxCode});

  Detail.fromJson(Map<String, dynamic> json) {
    rowNo = json['RowNo'];
    headerDocNo = json['HeaderDocNo'];
    docDate = json['DocDate'];
    categoryCode = json['CategoryCode'];
    categoryName = json['CategoryName'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemGroupCode = json['ItemGroupCode'];
    uom = json['Uom'];
    qty = json['Qty'];
    price = json['Price'];
    total = json['Total'];
    creationName = json['CreationName'];
    tableNo = json['TableNo'];
    seatNo = json['SeatNo'];
    status = json['Status'];
    pictureName = json['PictureName'];
    pictureURL = json['PictureURL'];
    createdBy = json['CreatedBy'];
    createdDatetime = json['CreatedDatetime'];
    modifiedBy = json['ModifiedBy'];
    modifiedDatetime = json['ModifiedDatetime'];
    lineID = json['LineID'];
    sync = json['Sync'];
    TaxCode = json['Tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNo'] = this.rowNo;
    data['HeaderDocNo'] = this.headerDocNo;
    data['DocDate'] = this.docDate;
    data['CategoryCode'] = this.categoryCode;
    data['CategoryName'] = this.categoryName;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemGroupCode'] = this.itemGroupCode;
    data['Uom'] = this.uom;
    data['Qty'] = this.qty;
    data['Price'] = this.price;
    data['Total'] = this.total;
    data['CreationName'] = this.creationName;
    data['TableNo'] = this.tableNo;
    data['SeatNo'] = this.seatNo;
    data['Status'] = this.status;
    data['PictureName'] = this.pictureName;
    data['PictureURL'] = this.pictureURL;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDatetime'] = this.createdDatetime;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDatetime'] = this.modifiedDatetime;
    data['LineID'] = this.lineID;
    data['Sync'] = this.sync;
    data['Tax'] = this.TaxCode;
    return data;
  }
}
