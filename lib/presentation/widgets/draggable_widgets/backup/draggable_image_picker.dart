// lib/presentation/widgets/draggable_widgets/draggable_image_picker.dart

import 'package:disha_form/presentation/widgets/draggable_widgets/shared/draggable_widget_style.dart';
import 'package:flutter/material.dart';

class DraggableImagePicker extends StatelessWidget {
  const DraggableImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    // The data for the image picker widget
    const Map<String, dynamic> widgetData = {
      'type': 'image_picker',
      'label': 'Image Picker',
      'meta': {'required' : false,} // No meta data for this widget type'
    };

    const String widgetLabel = 'Image Picker';
    const IconData widgetIcon = Icons.image;

    return Draggable<Map<String, dynamic>>(
      data: widgetData,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5, child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
