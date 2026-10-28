import 'package:equatable/equatable.dart';
import '../../../data/models/form_widget_model.dart';

class FormBuilderState extends Equatable {
  /// Immutable list reference — always create a new list when changing.
  final List<FormWidgetModel> widgets;


  const FormBuilderState({this.widgets = const []});

  FormBuilderState copyWith({
    List<FormWidgetModel>? widgets,
  }) {
    return FormBuilderState(
      widgets: widgets ?? this.widgets,
    );
  }

  @override
  List<Object?> get props => [widgets];
}
