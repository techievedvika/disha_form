// lib/presentation/widgets/draggable_widgets/draggable_mobile.dart
import 'package:flutter/material.dart';
import 'shared/draggable_widget_style.dart';

class DraggableMobile extends StatelessWidget {
  const DraggableMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'mobile',
      'label': 'Mobile Number',
      'meta' : {'required' : false,},
    };

    const String widgetLabel = 'Mobile';
    const IconData widgetIcon = Icons.phone_android;

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