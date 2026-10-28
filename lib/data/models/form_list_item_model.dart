// lib/data/models/form_list_item_model.dart

import 'package:equatable/equatable.dart';

class FormListItemModel extends Equatable {
  final String formId;
  final String formName;
  // You can add other fields like created_at, etc. if the API provides them

  const FormListItemModel({
    required this.formId,
    required this.formName,
  });

  factory FormListItemModel.fromJson(Map<String, dynamic> json) {
    return FormListItemModel(
      // Ensure the keys 'form_id' and 'form_name' match your API response
      formId: json['form_id'].toString(),
      formName: json['form_name'] as String,
    );
  }

  @override
  List<Object?> get props => [formId, formName];
}
