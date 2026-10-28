// lib/presentation/widgets/draggable_widgets/draggable_date.dart
import 'package:flutter/material.dart';
import 'shared/draggable_widget_style.dart';

class DraggableDate extends StatelessWidget {
  const DraggableDate({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'date_picker',
      'label': 'Date',
      'meta': {
        'required' : false,
        'dateFormat' : 'dd/MM/yyyy',
      }
    };

    const String widgetLabel = 'Date';
    const IconData widgetIcon = Icons.calendar_today;

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