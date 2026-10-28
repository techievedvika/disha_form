import 'package:flutter/material.dart';
import '../shared/draggable_widget_style.dart';

class DraggableSwitch extends StatelessWidget {
  const DraggableSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'switch',
      'label': 'Toggle Switch',
      'meta': {'required' : false,},
    };

    const String widgetLabel = 'Toggle Switch';
    const IconData widgetIcon = Icons.toggle_off_outlined;

    return Draggable<Map<String, dynamic>>(
      data: template,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5, child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
