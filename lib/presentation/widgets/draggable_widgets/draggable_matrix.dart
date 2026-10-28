// lib/presentation/widgets/draggable_widgets/draggable_matrix.dart
import 'package:flutter/material.dart';
import 'shared/draggable_widget_style.dart';

class DraggableMatrix extends StatelessWidget {
  const DraggableMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> template = {
      'type': 'matrix',
      'label': 'Matrix',
      'meta' : {
        'cellType': 'Text',
        'rows': [],
        'columns': [],
        'required' : false,
      },
    };

    const String widgetLabel = 'Matrix';
    const IconData widgetIcon = Icons.view_module; // Changed to a more suitable icon

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