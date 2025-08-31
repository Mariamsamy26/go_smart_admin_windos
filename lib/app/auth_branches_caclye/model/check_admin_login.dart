// To parse this JSON data, do
//
//     final checkAdminLogin = checkAdminLoginFromJson(jsonString);

import 'dart:convert';

CheckAdminLogin checkAdminLoginFromJson(String str) => CheckAdminLogin.fromJson(json.decode(str));

String checkAdminLoginToJson(CheckAdminLogin data) => json.encode(data.toJson());

class CheckAdminLogin {
  int? status;
  String? message;
  String? messageAr;
  String? role;
  List<Branch>? branches;

  CheckAdminLogin({this.status, this.message, this.messageAr, this.role, this.branches});

  factory CheckAdminLogin.fromJson(Map<String, dynamic> json) => CheckAdminLogin(
    status: json["status"],
    message: json["message"],
    messageAr: json["message_ar"],
    role: json["role"],
    branches: json["branches"] == null ? [] : List<Branch>.from(json["branches"]!.map((x) => Branch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "message_ar": messageAr,
    "role": role,
    "branches": branches == null ? [] : List<dynamic>.from(branches!.map((x) => x.toJson())),
  };
}

class Branch {
  int? id;
  String? businessName;
  String? branchArea;
  String? odooUrl;
  String? apisUrl;
  String? dbName;
  String? image;

  Branch({this.id, this.businessName, this.branchArea, this.odooUrl, this.apisUrl, this.dbName, this.image});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    businessName: json["business_name"],
    branchArea: json["branch_area"],
    odooUrl: json["odoo_url"],
    apisUrl: json["apis_url"],
    dbName: json["db_name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_name": businessName,
    "branch_area": branchArea,
    "odoo_url": odooUrl,
    "apis_url": apisUrl,
    "db_name": dbName,
    "image": image,
  };
}
