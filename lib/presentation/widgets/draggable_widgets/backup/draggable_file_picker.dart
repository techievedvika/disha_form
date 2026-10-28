// lib/presentation/widgets/draggable_widgets/draggable_file_picker.dart

import 'package:disha_form/presentation/widgets/draggable_widgets/shared/draggable_widget_style.dart';
import 'package:flutter/material.dart';

class DraggableFilePicker extends StatelessWidget {
  const DraggableFilePicker({super.key});

  @override
  Widget build(BuildContext context) {
    // This is the data that will be dropped on the canvas.
    // The 'type' MUST match the case in form_canvas.dart.
    const Map<String, dynamic> widgetData = {
      'type': 'file_picker',
      'label': 'File Picker',
      'meta': {'required' : false,} // No meta data for this widget type'
    };

    const String widgetLabel = 'File Picker';
    const IconData widgetIcon = Icons.attach_file;

    return Draggable<Map<String, dynamic>>(
      data: widgetData,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5, child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
