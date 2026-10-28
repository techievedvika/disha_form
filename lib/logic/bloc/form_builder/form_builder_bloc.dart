import 'package:bloc/bloc.dart';
import 'form_builder_event.dart';
import 'form_builder_state.dart';
import '../../../data/models/form_widget_model.dart';
import '../../../service/form_repository.dart';


class FormBuilderBloc extends Bloc<FormBuilderEvent, FormBuilderState> {
  final FormRepository _formRepository = FormRepository(); // Instantiate the repo
  FormBuilderBloc() : super(const FormBuilderState()) {
    on<AddWidgetEvent>(_onAddWidget);
    on<RemoveWidgetEvent>(_onRemoveWidget);
    on<UpdateWidgetEvent>(_onUpdateWidget);
    on<MoveWidgetEvent>(_onMoveWidget);
    on<ClearWidgetsEvent>(_onClearWidgets);
    on<LoadFormEvent>(_onLoadForm);
  }

  void _onAddWidget(AddWidgetEvent event, Emitter<FormBuilderState> emit) {
    // Avoid accidental duplicates by ID
    final exists = state.widgets.any((w) => w.id == event.widgetModel.id);
    if (exists) {
      // If you prefer to replace instead of ignore, you can emit an updated list here.
      return;
    }

    final updated = List<FormWidgetModel>.from(state.widgets)..add(event.widgetModel);
    emit(state.copyWith(widgets: updated));
  }

  void _onRemoveWidget(RemoveWidgetEvent event, Emitter<FormBuilderState> emit) {
    final updated = state.widgets.where((w) => w.id != event.widgetId).toList();
    if (updated.length == state.widgets.length) {
      // nothing removed
      return;
    }
    emit(state.copyWith(widgets: updated));
  }

  void _onUpdateWidget(UpdateWidgetEvent event, Emitter<FormBuilderState> emit) {
    final idx = state.widgets.indexWhere((w) => w.id == event.widgetId);
    if (idx == -1) return; // widget not found

    final updated = List<FormWidgetModel>.from(state.widgets);
    updated[idx] = event.updatedWidget;
    emit(state.copyWith(widgets: updated));
  }

  void _onMoveWidget(MoveWidgetEvent event, Emitter<FormBuilderState> emit) {
    final from = event.fromIndex;
    final to = event.toIndex;

    if (from < 0 || from >= state.widgets.length || to < 0 || to >= state.widgets.length) {
      return; // out of bounds
    }

    final updated = List<FormWidgetModel>.from(state.widgets);
    final item = updated.removeAt(from);
    updated.insert(to, item);
    emit(state.copyWith(widgets: updated));
  }

  void _onClearWidgets(ClearWidgetsEvent event, Emitter<FormBuilderState> emit) {
    emit(const FormBuilderState(widgets: []));
  }

  // Add the handler logic for loading a form
  void _onLoadForm(LoadFormEvent event, Emitter<FormBuilderState> emit) async {
    try {
      final widgets = await _formRepository.getForm(event.formId,event.userId);
      emit(state.copyWith(widgets: widgets));
    } catch (e) {
      // Handle error (e.g., form not found)
      print('Error loading form: $e');
      // Optionally, emit a state to show an error in the UI
    }
  }
}
