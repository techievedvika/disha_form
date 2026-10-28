import 'package:equatable/equatable.dart';
import '../../../data/models/form_widget_model.dart';

abstract class FormBuilderEvent extends Equatable {
  const FormBuilderEvent();

  @override
  List<Object?> get props => [];
}

/// Add a widget to canvas (appends at end by default).
class AddWidgetEvent extends FormBuilderEvent {
  final FormWidgetModel widgetModel;
  const AddWidgetEvent(this.widgetModel);

  @override
  List<Object?> get props => [widgetModel];
}

/// Remove widget by id.
class RemoveWidgetEvent extends FormBuilderEvent {
  final String widgetId;
  const RemoveWidgetEvent(this.widgetId);

  @override
  List<Object?> get props => [widgetId];
}

/// Update an existing widget (match by id).
class UpdateWidgetEvent extends FormBuilderEvent {
  final String widgetId;
  final FormWidgetModel updatedWidget;
  const UpdateWidgetEvent(this.widgetId, this.updatedWidget);

  @override
  List<Object?> get props => [widgetId, updatedWidget];
}

/// Move widget from one index to another.
class MoveWidgetEvent extends FormBuilderEvent {
  final int fromIndex;
  final int toIndex;
  const MoveWidgetEvent(this.fromIndex, this.toIndex);

  @override
  List<Object?> get props => [fromIndex, toIndex];
}

/// Clear all widgets (reset canvas).
class ClearWidgetsEvent extends FormBuilderEvent {
  const ClearWidgetsEvent();
}

/// Loads an existing form into the builder for editing.
class LoadFormEvent extends FormBuilderEvent {
  final String formId;
  final String userId;
  const LoadFormEvent(this.formId , this.userId);@override
  List<Object?> get props => [formId, userId];
}