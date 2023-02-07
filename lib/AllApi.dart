// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:bestmummybackery/AppConstants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> GETLocationAPI() async {
  var url;

/*  String basicAuth = 'Basic ' + base64Encode(utf8.encode('admin:1234'));
  print(basicAuth);*/

  url = Uri.parse(AppConstants.LIVE_URL + 'getLocation');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var response = await http.get(url, headers: headers);

  return response;
}

Future<http.Response> GETUserMasterAPI(int formid, String userid) async {
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'getUserMaster');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": formid,
    "UserID": userid,
  };

  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> INSERTCOUNTER(FormID, DocNo, LocCode, LocName, CounterName, Imei, Status, UserID) async {
  print("here");
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'InsertUpdateCounter');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "LocCode": LocCode,
    "LocName": LocName,
    "CounterName": CounterName,
    "Imei": Imei,
    "Status": Status,
    "UserID": UserID,
  };
  print("1");
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  print("2");
  return response;
}

Future<http.Response> INSERTVEHICLEMASTER(FormID, DocNo, VehicleName, VehicleModel, VehicleNum, Status, UserID) async {
  print("here");
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'InsertUpdateVehicle');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "VehicleName": VehicleName,
    "VehicleModel": VehicleModel,
    "VehicleNum": VehicleNum,
    "Status": Status,
    "UserID": UserID,
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;
}
//getsalesOrderCategorieskot
Future<http.Response> GetAllCategories(FormID, UserID, BranchCode, GroupNo) async {
  print("here");
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'getsalesOrderCategories');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "UserID": UserID,
    "BranchCode": BranchCode,
    "GroupNo": GroupNo
  };
  print(body);
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;

}

Future<http.Response> GetAllCategorieskot(FormID, UserID, BranchCode, GroupNo) async {
  print("here");
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'getsalesOrderCategorieskot');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "UserID": UserID,
    "BranchCode": BranchCode,
    "GroupNo": GroupNo
  };
  print(body);
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;

}

Future<http.Response> InsertAddtoCart(FormID, DocNo, CatCode, CatName, ItemCode, ItemName,
    ItemGroupCode, UOM, Qty, Price, Total, UserID, PictureName, PictureURL) async {
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'insertAddtoCard');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "CatCode": CatCode,
    "CatName": CatName,
    "ItemCode": ItemCode,
    "ItemName": ItemName,
    "ItemGroupCode": ItemGroupCode,
    "UOM": UOM,
    "Qty": Qty,
    "Price": Price,
    "Total": Total,
    "UserID": UserID,
    "PictureName": PictureName,
    "PictureURL": PictureURL
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;
}

Future<http.Response> InsertSalesOrder(
    OrderNo, OrderDate, CustomerNo, DelDate, OccCode, OccName, OccDate,
    Message, ShapeCode, ShapeName, DoorDelivery, CustCharge, AdvanceAmount,
    DelStateCode, DelStateName, DelDistCode, DelDistName, DelPlaceCode,
    DelPlaceName, DelCharge, TotQty, TotAmount, TaxAmount, ReqDiscount, BalanceDue,
    OverallAmount, OrderStatus, ApproverID, ApproverName, ApprovedDiscount,
    ApprovedStatus, ApprovedRemarks1, ApprovedRemarks2, ScreenID, ScreenName, UserID, ShaCode,
    ShaName, BlanceAmt, BranchId,ShiftId,DeliveryTime) async {
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'insertSalesHeader');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "OrderNo": OrderNo,
    "OrderDate": OrderDate,
    "CustomerNo": CustomerNo,
    "DelDate": DelDate,
    "OccCode": OccCode,
    "OccName": OccName,
    "OccDate": OccDate,
    "Message": Message,
    "ShapeCode": ShapeCode,
    "ShapeName": ShapeName,
    "DoorDelivery": DoorDelivery,
    "CustCharge": CustCharge,
    "AdvanceAmount": AdvanceAmount,
    "DelStateCode": DelStateCode,
    "DelStateName": DelStateName,
    "DelDistCode": DelDistCode,
    "DelDistName": DelDistName,
    "DelPlaceCode": DelPlaceCode,
    "DelPlaceName": DelPlaceName,
    "DelCharge": DelCharge,
    "TotQty": TotQty,
    "TotAmount": TotAmount,
    "TaxAmount": TaxAmount,
    "ReqDiscount": ReqDiscount,
    "BalanceDue": BalanceDue,
    "OverallAmount": OverallAmount,
    "OrderStatus": OrderStatus,
    "ApproverID": ApproverID,
    "ApproverName": ApproverName,
    "ApprovedDiscount": ApprovedDiscount,
    "ApprovedStatus": ApprovedStatus,
    "ApprovedRemarks1": ApprovedRemarks1,
    "ApprovedRemarks2": ApprovedRemarks2,
    "ScreenID": ScreenID,
    "ScreenName": ScreenName,
    "UserID": UserID,
    "ShaCode": ShaCode,
    "ShaName": ShaName,
    "BlanceAmt": BlanceAmt,
    "BranchId": BranchId,
    "ShiftId": ShiftId,
    "DeliveryTime":DeliveryTime
  };
  print(body);
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;
}


Future<http.Response> InsertSalesReturnHeader(
    OrderNo, OrderDate, CustomerNo, DelDate, OccCode, OccName, OccDate,
    Message, ShapeCode, ShapeName, DoorDelivery, CustCharge, AdvanceAmount,
    DelStateCode, DelStateName, DelDistCode, DelDistName, DelPlaceCode,
    DelPlaceName, DelCharge, TotQty, TotAmount, TaxAmount, ReqDiscount, BalanceDue,
    OverallAmount, OrderStatus, ApproverID, ApproverName, ApprovedDiscount,
    ApprovedStatus, ApprovedRemarks1, ApprovedRemarks2, ScreenID, ScreenName, UserID, ShaCode,
    ShaName, BlanceAmt, BranchId,ShiftId,DeliveryTime) async {
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'insertSalesreturnHeader');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "OrderNo": OrderNo,
    "OrderDate": OrderDate,
    "CustomerNo": CustomerNo,
    "DelDate": DelDate,
    "OccCode": OccCode,
    "OccName": OccName,
    "OccDate": OccDate,
    "Message": Message,
    "ShapeCode": ShapeCode,
    "ShapeName": ShapeName,
    "DoorDelivery": DoorDelivery,
    "CustCharge": CustCharge,
    "AdvanceAmount": AdvanceAmount,
    "DelStateCode": DelStateCode,
    "DelStateName": DelStateName,
    "DelDistCode": DelDistCode,
    "DelDistName": DelDistName,
    "DelPlaceCode": DelPlaceCode,
    "DelPlaceName": DelPlaceName,
    "DelCharge": DelCharge,
    "TotQty": TotQty,
    "TotAmount": TotAmount,
    "TaxAmount": TaxAmount,
    "ReqDiscount": ReqDiscount,
    "BalanceDue": BalanceDue,
    "OverallAmount": OverallAmount,
    "OrderStatus": OrderStatus,
    "ApproverID": ApproverID,
    "ApproverName": ApproverName,
    "ApprovedDiscount": ApprovedDiscount,
    "ApprovedStatus": ApprovedStatus,
    "ApprovedRemarks1": ApprovedRemarks1,
    "ApprovedRemarks2": ApprovedRemarks2,
    "ScreenID": ScreenID,
    "ScreenName": ScreenName,
    "UserID": UserID,
    "ShaCode": ShaCode,
    "ShaName": ShaName,
    "BlanceAmt": BlanceAmt,
    "BranchId": BranchId,
    "ShiftId": ShiftId,
    "DeliveryTime":DeliveryTime
  };
  print(body);
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;
}


Future<http.Response> InsertKOTOrder(
    OrderNo, OrderDate, CustomerNo, DelDate, OccCode, OccName, OccDate, Message, ShapeCode, ShapeName, DoorDelivery,
    CustCharge, AdvanceAmount, DelStateCode, DelStateName, DelDistCode, DelDistName, DelPlaceCode, DelPlaceName,
    DelCharge, TotQty, TotAmount, TaxAmount, ReqDiscount, BalanceDue, OverallAmount, OrderStatus, ApproverID,
    ApproverName, ApprovedDiscount, ApprovedStatus, ApprovedRemarks1, ApprovedRemarks2, CreationName,
    TableNo, SeatNo, UserID, BranchID) async {
  var url;

  url = Uri.parse(AppConstants.LIVE_URL + 'insertKOTHeader');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "OrderNo": OrderNo,
    "OrderDate": OrderDate,
    "CustomerNo": CustomerNo,
    "DelDate": DelDate,
    "OccCode": OccCode,
    "OccName": OccName,
    "OccDate": OccDate,
    "Message": Message,
    "ShapeCode": ShapeCode,
    "ShapeName": ShapeName,
    "DoorDelivery": DoorDelivery,
    "CustCharge": CustCharge,
    "AdvanceAmount": AdvanceAmount,
    "DelStateCode": DelStateCode,
    "DelStateName": DelStateName,
    "DelDistCode": DelDistCode,
    "DelDistName": DelDistName,
    "DelPlaceCode": DelPlaceCode,
    "DelPlaceName": DelPlaceName,
    "DelCharge": DelCharge,
    "TotQty": TotQty,
    "TotAmount": TotAmount,
    "TaxAmount": TaxAmount,
    "ReqDiscount": ReqDiscount,
    "BalanceDue": BalanceDue,
    "OverallAmount": OverallAmount,
    "OrderStatus": OrderStatus,
    "ApproverID": ApproverID,
    "ApproverName": ApproverName,
    "ApprovedDiscount": ApprovedDiscount,
    "ApprovedStatus": ApprovedStatus,
    "ApprovedRemarks1": ApprovedRemarks1,
    "ApprovedRemarks2": ApprovedRemarks2,
    "CreationName": CreationName,
    "TableNo": TableNo,
    "SeatNo": SeatNo,
    "UserID": UserID,
    "BranchID": BranchID
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  return response;
}

Future<http.Response> GETCOUNTRYAPI(formid, userid) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getcountry');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": formid,
    "UserID": userid,
  };

  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GETSTATEAPI(formid, userid) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getstate');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": formid,
    "UserID": userid,
  };

  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GETOCCATIONAPI(UserID, BRANCH) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getOSRDOccation');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"UserID": UserID, "BranchID": BRANCH};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> AddFavourite(UserID, BRANCH, ItemCode, FLAG) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'AddFavourite');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "UserID": UserID,
    "BranchID": BRANCH,
    "ItemCode": ItemCode,
    "Flag": FLAG,
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GetAllSalesPerson(USERID, BRANCH) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getSalesPerson');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"UserID": USERID, "BranchID": BRANCH};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GetAllDocNo(FormID, UserID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getdateandno');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"FormID": FormID, "UserID": UserID};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GetItemWastage(UserID, GroupID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getItemWastage');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"UserID": UserID, "GroupID": GroupID};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GetAllMaster(FormID, UserID, BranchID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'GetAllMaster');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"FormID": FormID, "UserID": UserID, "BranchID": BranchID};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));

  return response;
}

Future<http.Response> GetWastagetoTransfer(TransferDate) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getWastagetoTransfer');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"TransferDate": TransferDate};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> GetUniqDocNo(UserID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getUniqID');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"UserID": UserID};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> GetAllWhs(BranchID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'getwhsAll');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {"BranchID": BranchID};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> GetAllUserMaster(
    FormID,
    DocNo,
    LocationCode,
    LocationName,
    EmpCode,
    EmpName,
    UserName,
    UserPassword,
    RollID,
    RollName,
    ManagerID,
    ManagerName,
    ApprManagerID,
    ApprManagerName,
    CashOnAccID,
    CashOnAccName,
    PettyCashAccountID,
    PettyCashAccountName,
    KOTID,
    KotName,
    Status,
    UserID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'insertUsers');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "LocationCode": LocationCode,
    "LocationName": LocationName,
    "EmpCode": EmpCode,
    "EmpName": EmpName,
    "UserName": UserName,
    "UserPassword": UserPassword,
    "RollID": RollID,
    "RollName": RollName,
    "ManagerID": ManagerID,
    "ManagerName": ManagerName,
    "ApprManagerID": ApprManagerID,
    "ApprManagerName": ApprManagerName,
    "CashOnAccID": CashOnAccID,
    "CashOnAccName": CashOnAccName,
    "PettyCashAccountID": PettyCashAccountID,
    "PettyCashAccountName": PettyCashAccountName,
    "KOTID": KOTID,
    "KotName": KotName,
    "Status": Status,
    "UserID": UserID
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> CURDLoyalty(
    FormID,
    DocNo,
    LocCode,
    LocName,
    FromRange,
    ToRange,
    LoyaltyPoint,
    LoyaltyAmount,
    Status,
    Remarks,
    SapStatus,
    SapRefNo,
    UserID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'insertLoyalty');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "LocCode": LocCode,
    "LocName": LocName,
    "FromRange": FromRange,
    "ToRange": ToRange,
    "LoyaltyPoint": LoyaltyPoint,
    "LoyaltyAmount": LoyaltyAmount,
    "Status": Status,
    "Remarks": Remarks,
    "SapStatus": SapStatus,
    "SapRefNo": SapRefNo,
    "UserID": UserID
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> CURDCustomer(
    FormID,
    DocNo,
    CusCode,
    CusName,
    CusWhatsAppNo,
    Email,
    Discount,
    Status,
    Remarks,
    SapStatus,
    SapRefNo,
    UserID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'insertCustomer');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "CusCode": CusCode,
    "CusName": CusName,
    "CusWhatsAppNo": CusWhatsAppNo,
    "Email": Email,
    "Discount": Discount,
    "Status": Status,
    "Remarks": Remarks,
    "SapStatus": SapStatus,
    "SapRefNo": SapRefNo,
    "UserID": UserID
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> CURDTarweight(
    FormID,
    DocNo,
    ItemGroupCode,
    ItemGroupName,
    ItemCode,
    ItemName,
    SerialNo,
    Weight,
    Status,
    Remarks,
    SapStatus,
    SapRefNo,
    UserID) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'inserttarweight');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "FormID": FormID,
    "DocNo": DocNo,
    "ItemGroupCode": ItemGroupCode,
    "ItemGroupName": ItemGroupName,
    "ItemCode": ItemCode,
    "ItemName": ItemName,
    "SerialNo": SerialNo,
    "Weight": Weight,
    "Status": Status,
    "Remarks": Remarks,
    "SapStatus": SapStatus,
    "SapRefNo": SapRefNo,
    "UserID": UserID
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> TargweightItemGroup() async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'gettargetitemgroupModel');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {};
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}

Future<http.Response> TargweightItem(ItemGroupCode) async {
  var url;
  url = Uri.parse(AppConstants.LIVE_URL + 'gettargetitemModel');
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  var body = {
    "ItemGroupCode": ItemGroupCode,
  };
  var response = await http.post(url, headers: headers, body: jsonEncode(body));
  //
  return response;
}
