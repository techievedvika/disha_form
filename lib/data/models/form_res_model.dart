// // To parse this JSON data, do
// //
// //final FormResModel = welcomeFromJson(jsonString);
//
// import 'dart:convert';
//
// FormResModel FormResModelFromJson(String str) => FormResModel.fromJson(json.decode(str));
//
// String FormResModelToJson(FormResModel data) => json.encode(data.toJson());
//
// class FormResModel {
//   bool status;
//   String message;
//   List<Datum> data;
//
//   FormResModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   factory FormResModel.fromJson(Map<String, dynamic> json) => FormResModel(
//     status: json["status"],
//     message: json["message"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   int id;
//   int userId;
//   String form;
//   String formName;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   dynamic updatedBy;
//
//   Datum({
//     required this.id,
//     required this.userId,
//     required this.form,
//     required this.formName,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.updatedBy,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["id"],
//     userId: json["user_id"],
//     form: json["form"],
//     formName: json["form_name"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     updatedBy: json["updated_by"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "form": form,
//     "form_name": formName,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "updated_by": updatedBy,
//   };
// }
