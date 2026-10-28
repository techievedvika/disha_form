import 'package:disha_form/presentation/widgets/draggable_widgets/shared/draggable_widget_style.dart';
import 'package:flutter/material.dart';

class DraggableNumberField extends StatelessWidget {
  const DraggableNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'number_field',
      'label': 'Number Field',
      'meta': {'required' : false,},
    };

    const String widgetLabel = 'Number Field';
    const IconData widgetIcon = Icons.pin_outlined;

    return Draggable<Map<String, dynamic>>(
      data: template,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5, child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
