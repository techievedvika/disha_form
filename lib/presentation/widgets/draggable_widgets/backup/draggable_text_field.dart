import 'package:flutter/material.dart';
import '../../../../data/models/form_widget_model.dart';
import '../shared/draggable_widget_style.dart';

class DraggableTextField extends StatelessWidget {
  const DraggableTextField({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: this is a template (no id). We'll generate the real id on drop.
    final Map<String, dynamic> template = {
      'type': 'text_field',
      'label': 'Untitled Text Field',
      'meta': {'required' : false,},
    };

    const String widgetLabel = 'Text Field';
    const IconData widgetIcon = Icons.text_fields;

    return Draggable<Map<String, dynamic>>(
      data: template,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5, child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
