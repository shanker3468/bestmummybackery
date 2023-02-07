class CategoriesModel {
  int status;
  List<CategoriesResult> result;

  CategoriesModel({this.status, this.result});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = new List<CategoriesResult>();
      json['result'].forEach((v) {
        result.add(new CategoriesResult.fromJson(v));
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

class CategoriesResult {
  int code;
  String name;
  String imgurl;

  CategoriesResult({this.code, this.name, this.imgurl});

  CategoriesResult.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    imgurl = json['Imgurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Imgurl'] = this.imgurl;
    return data;
  }
}
