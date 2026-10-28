// lib/presentation/widgets/draggable_widgets/draggable_camera_capture.dart

import 'package:disha_form/presentation/widgets/draggable_widgets/shared/draggable_widget_style.dart';
import 'package:flutter/material.dart';

class DraggableCameraCapture extends StatelessWidget {
  const DraggableCameraCapture({super.key});

  @override
  Widget build(BuildContext context) {
    // The data for the camera capture widget
    const Map<String, dynamic> widgetData = {
      'type': 'camera_capture',
      'label': 'Camera Capture',
      'meta': {'required' : false,}
    };

    const String widgetLabel = 'Camera Capture';
    const IconData widgetIcon = Icons.camera_alt;

    return Draggable<Map<String, dynamic>>(
      data: widgetData,
      feedback: DraggableWidgetFeedback(icon: widgetIcon, label: widgetLabel),
      childWhenDragging: Opacity(opacity: 0.5, child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel)),
      child: DraggableWidgetTile(icon: widgetIcon, label: widgetLabel),
    );
  }
}
