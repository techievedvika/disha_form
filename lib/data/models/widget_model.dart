// import 'dart:convert';
//
// List<FormWidgetModel> parseFormList(List<String>? form) {
//   if (form == null || form.isEmpty) return [];
//
//   return form.map((item) {
//     final Map<String, dynamic> json = jsonDecode(item);
//
//     return FormWidgetModel(
//       id: json['id'],
//       type: json['type'],
//       label: json['label'],
//       meta: Map<String, dynamic>.from(json['meta'] ?? {}),
//     );
//   }).toList();
// }
