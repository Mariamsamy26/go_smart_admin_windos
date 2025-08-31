// To parse this JSON data, do
//
//     final dbNameRecordData = dbNameRecordDataFromJson(jsonString);

import 'dart:convert';

DbNameRecordData dbNameRecordDataFromJson(String str) => DbNameRecordData.fromJson(json.decode(str));

String dbNameRecordDataToJson(DbNameRecordData data) => json.encode(data.toJson());

class DbNameRecordData {
  int? status;
  String? result;

  DbNameRecordData({this.status, this.result});

  factory DbNameRecordData.fromJson(Map<String, dynamic> json) =>
      DbNameRecordData(status: json["status"], result: json["result"]);

  Map<String, dynamic> toJson() => {"status": status, "result": result};
}
