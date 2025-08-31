// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  int? status;
  String? message;
  String? messageAr;

  Login({this.status, this.message, this.messageAr});

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(status: json["status"], message: json["message"], messageAr: json["message_ar"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message, "message_ar": messageAr};
}
