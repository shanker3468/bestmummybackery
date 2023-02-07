class MySaleOrderGetLIneData {
  List<Testdata> testdata;

  MySaleOrderGetLIneData({this.testdata});

  MySaleOrderGetLIneData.fromJson(Map<String, dynamic> json) {
    if (json['testdata'] != null) {
      testdata = <Testdata>[];
      json['testdata'].forEach((v) {
        testdata.add(new Testdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.testdata != null) {
      data['testdata'] = this.testdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testdata {
  int headerDocNo;
  var itemCode;
  String itemName;
  String itemGroupCode;
  String uom;
  var price;
  var qty;
  var amount;
  String itemGropName;
  String pictureName;
  String pictureURL;
  var taxAmount;
  var EmpId;
  var FirstName;
  var orderstatus;
  var Totltaxamt;
  var totalamt;
  var TaxCode;
  var CustomerNo;
  var CategoryName;
  var ApprovedDiscount;
  var CustCharge;
  var OccCode;
  var OccName;
  var Message;
  var BlanceAmt;
  var DelCharge;
  var ShaCode;
  var ShaName;
  var ReqDiscount;
  var ItemComboNo;
  var DeliveryTime;




  Testdata(
      {this.headerDocNo,
      this.itemCode,
      this.itemName,
      this.itemGroupCode,
      this.uom,
      this.price,
      this.qty,
      this.amount,
      this.itemGropName,
      this.pictureName,
      this.pictureURL,
      this.taxAmount,
      this.EmpId,
      this.FirstName,
      this.orderstatus,
      this.Totltaxamt,
      this.totalamt,
      this.TaxCode,
      this.CustomerNo,
      this.CategoryName,
      this.ApprovedDiscount,
      this.CustCharge,
      this.OccCode,
      this.OccName,
      this.Message,
      this.BlanceAmt,
      this.DelCharge,
      this.ShaCode,
      this.ShaName,
      this.ItemComboNo,
        this.DeliveryTime,
      });

  Testdata.fromJson(Map<String, dynamic> json) {
    headerDocNo = json['HeaderDocNo'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    itemGroupCode = json['ItemGroupCode'];
    uom = json['Uom'];
    price = json['Price'];
    qty = json['Qty'];
    amount = json['Amount'];
    itemGropName = json['ItemGropName'];
    pictureName = json['PictureName'];
    pictureURL = json['PictureURL'];
    taxAmount = json['TaxAmount'];
    EmpId = json['EmpId'];
    FirstName = json['FirstName'];
    orderstatus = json['Status'];
    Totltaxamt = json['TaxAmount'];
    totalamt = json['TotAmount'];
    TaxCode = json['TaxCode'];
    CustomerNo = json['CustomerNo'];
    CategoryName = json['CategoryName'];
    ApprovedDiscount = json['ApprovedDiscount'];
    CustCharge = json['CustCharge'];
    OccCode = json['OccCode'];
    OccName = json['OccName'];
    Message = json['Message'];
    BlanceAmt = json['BlanceAmt'];
    DelCharge = json['DelCharge'];
    ShaCode = json['ShaCode'];
    ShaName = json['ShaName'];
    ItemComboNo = json['ItemComboNo'];
    DeliveryTime = json['DeliveryTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HeaderDocNo'] = this.headerDocNo;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['ItemGroupCode'] = this.itemGroupCode;
    data['Uom'] = this.uom;
    data['Price'] = this.price;
    data['Qty'] = this.qty;
    data['Amount'] = this.amount;
    data['ItemGropName'] = this.itemGropName;
    data['PictureName'] = this.pictureName;
    data['PictureURL'] = this.pictureURL;
    data['TaxAmount'] = this.taxAmount;
    data['EmpId'] = this.EmpId;
    data['FirstName'] = this.FirstName;
    data['Status'] = this.orderstatus;
    data['TaxAmount'] = this.Totltaxamt;
    data['TotAmount'] = this.totalamt;
    data['TaxCode'] = this.TaxCode;
    data['CustomerNo'] = this.CustomerNo;
    data['CategoryName'] = this.CategoryName;
    data['ApprovedDiscount'] = this.ApprovedDiscount;
    data['CustCharge'] = this.CustCharge;
    data['OccCode'] = this.OccCode;
    data['OccName'] = this.OccName;
    data['Message'] = this.Message;
    data['BlanceAmt'] = this.BlanceAmt;
    data['DelCharge'] = this.DelCharge;
    data['ShaCode'] = this.ShaCode;
    data['ShaName'] = this.ShaName;
    data['ItemComboNo'] = this.ItemComboNo;
    data['DeliveryTime'] = this.DeliveryTime;
    return data;
  }
}
