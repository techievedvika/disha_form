import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../draggable_widgets/backup/draggable_camera_capture.dart';
import '../draggable_widgets/backup/draggable_file_picker.dart';
import '../draggable_widgets/backup/draggable_image_picker.dart';
import '../draggable_widgets/backup/draggable_number_field.dart';
import '../draggable_widgets/backup/draggable_radio_group.dart';
import '../draggable_widgets/backup/draggable_switch.dart';
import '../draggable_widgets/backup/draggable_text_field.dart';
import '../draggable_widgets/draggable_address.dart';
import '../draggable_widgets/draggable_checkbox_group.dart';
import '../draggable_widgets/draggable_date.dart';
import '../draggable_widgets/draggable_dropdown.dart';
import '../draggable_widgets/draggable_matrix.dart';
import '../draggable_widgets/draggable_mobile.dart';
import '../draggable_widgets/draggable_textarea.dart';

class DraggableWidgetDrawer extends StatefulWidget {
  const DraggableWidgetDrawer({Key? key}) : super(key: key);

  @override
  State<DraggableWidgetDrawer> createState() => _DraggableWidgetDrawerState();
}

class _DraggableWidgetDrawerState extends State<DraggableWidgetDrawer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isExpanded ? 200 : 65,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.indigo.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with toggle button
            _buildHeader(),

            // Widgets list
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    if (_isExpanded) ...[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            _buildCategoryLabel('Input Fields'),
                            DraggableTextField(),
                            SizedBox(height: 8),
                            DraggableTextArea(),
                            SizedBox(height: 8),
                            DraggableNumberField(),
                            SizedBox(height: 8),
                            DraggableMobile(),
                            SizedBox(height: 8),
                            DraggableAddress(),
                            SizedBox(height: 16),

                            _buildCategoryLabel('Selection'),
                            DraggableSelect(),
                            SizedBox(height: 8),
                            DraggableCheckboxGroup(),
                            SizedBox(height: 8),
                            DraggableSwitch(),
                            SizedBox(height: 8),
                            DraggableRadioGroup(),
                            SizedBox(height: 8),
                            DraggableDate(),
                            SizedBox(height: 16),

                            _buildCategoryLabel('Advanced'),
                            DraggableMatrix(),
                            SizedBox(height: 8),
                            DraggableFilePicker(),
                            SizedBox(height: 8),
                            DraggableImagePicker(),
                            SizedBox(height: 8),
                            DraggableCameraCapture(),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Collapsed view - show icons only
                      _buildCollapsedWidget(Icons.text_fields, 'Text'),
                      _buildCollapsedWidget(Icons.notes, 'Area'),
                      _buildCollapsedWidget(Icons.numbers, 'Number'),
                      _buildCollapsedWidget(Icons.phone_android, 'Mobile'),
                      _buildCollapsedWidget(Icons.home, 'Address'),
                      _buildCollapsedWidget(Icons.arrow_drop_down_circle, 'Dropdown'),
                      _buildCollapsedWidget(Icons.check_box, 'Checkbox'),
                      _buildCollapsedWidget(Icons.toggle_on, 'Switch'),
                      _buildCollapsedWidget(Icons.radio_button_checked_rounded, 'Radio'),
                      _buildCollapsedWidget(Icons.calendar_today, 'Date'),
                      _buildCollapsedWidget(Icons.grid_on, 'Matrix'),
                      _buildCollapsedWidget(Icons.attach_file, 'File'),
                      _buildCollapsedWidget(Icons.image, 'Image'),
                      _buildCollapsedWidget(Icons.camera_alt, 'Camera'),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isExpanded)
            Expanded(
              child: Text(
                'Widgets',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          IconButton(
            icon: Icon(
              _isExpanded ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.white,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLabel(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.indigo.shade700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedWidget(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24,
          color: Colors.indigo.shade600,
        ),
      ),
    );
  }
}

// Enhanced Draggable Widget Base
class EnhancedDraggableWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Map<String, dynamic> data;

  const EnhancedDraggableWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Map<String, dynamic>>(
      data: data,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _buildWidgetTile(),
      ),
      child: _buildWidgetTile(),
    );
  }

  Widget _buildWidgetTile() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
