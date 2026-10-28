// lib/presentation/widgets/draggable_widgets/draggable_address.dart
import 'package:flutter/material.dart';
import 'shared/draggable_widget_style.dart';

class DraggableAddress extends StatelessWidget {
  const DraggableAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'address',
      'label': 'Address',
      'meta' : {
        'required' : false,
        'lane': [
          'Address Lane 1'
        ],
        'address_fields': [],
      },
    };

    const String widgetLabel = 'Address';
    const IconData widgetIcon = Icons.location_on;

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