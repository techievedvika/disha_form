import 'package:disha_form/presentation/widgets/draggable_widgets/shared/draggable_widget_style.dart';
import 'package:flutter/material.dart';

class DraggableCheckbox extends StatelessWidget {
  const DraggableCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'checkbox',
      'label': 'Checkbox',
      'meta': {
        'required' : false,
        'options': []
      },
    };

    const String widgetLabel = 'Checkbox';
    const IconData widgetIcon = Icons.check_box;

    return Draggable<Map<String, dynamic>>(
      data: template,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5,
          child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
