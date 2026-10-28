// lib/presentation/widgets/draggable_widgets/draggable_textarea.dart
import 'package:flutter/material.dart';
import 'shared/draggable_widget_style.dart';

class DraggableTextArea extends StatelessWidget {
  const DraggableTextArea({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'textarea',
      'label': 'Text Area',
      'meta': {'required' : false,}
    };

    const String widgetLabel = 'Text Area';
    const IconData widgetIcon = Icons.notes;

    return Draggable<Map<String, dynamic>>(
      data: template,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
      ),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}