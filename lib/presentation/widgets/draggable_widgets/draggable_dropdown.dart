// lib/presentation/widgets/draggable_widgets/draggable_select.dart
import 'package:flutter/material.dart';
import 'shared/draggable_widget_style.dart';

class DraggableSelect extends StatelessWidget {
  const DraggableSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'dropdown',
      'label': 'Dropdown',
      'meta' : {
        'required' : false,
        'options': [],
      },
    };

    const String widgetLabel = 'Dropdown';
    const IconData widgetIcon = Icons.arrow_drop_down_circle;

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