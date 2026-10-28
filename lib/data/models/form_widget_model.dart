import 'package:equatable/equatable.dart';

class FormWidgetModel extends Equatable {
  final String id;
  final String type; // e.g. text_field, dropdown, checkbox, date
  final String label;
  final Map<String, dynamic> meta;

  const FormWidgetModel({
    required this.id,
    required this.type,
    required this.label,
    this.meta = const {},
  });

  FormWidgetModel copyWith({
    String? id,
    String? type,
    String? label,
    Map<String, dynamic>? meta,
  }) {
    return FormWidgetModel(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'meta': meta,
    };
  }

  factory FormWidgetModel.fromJson(Map<String, dynamic> json) {
    return FormWidgetModel(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      meta: Map<String, dynamic>.from(json['meta'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, type, label, meta];
}
