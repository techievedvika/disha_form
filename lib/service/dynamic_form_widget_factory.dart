// lib/service/dynamic_form_widget_factory.dart

//------------------------------------------------------------------------------
///-----This is to define widget to rebuild at time of form filling -----------
//------------------------------------------------------------------------------


import 'dart:io';
import 'package:intl/intl.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DynamicFormWidgetFactory {
  static Widget build({
    required BuildContext context,
    required Map<String, dynamic> field,
    required dynamic currentValue,
    required Function(dynamic) onChanged,
  }) {

    //To extract meta data of file
    final Map<String, dynamic> meta = field['meta'] is Map ? field['meta'] : {};

    String type = field['type'];
    String label = field['label'] ?? '';
    //Have to add to check which field is required
    bool isRequired = meta['required'] ?? false;
    List<dynamic> columns = meta['rows'] ?? [];
    List<dynamic> rows = meta['columns'] ?? [];
    //To build matrix cell
    String cellType = meta['cellType'] ?? 'Text';

    //Ensure currentValue is a Map to store grid data
    Map<String, dynamic> matrixData = currentValue is Map<String, dynamic>
        ? currentValue
        : {};




    switch (type) {
      case 'switch':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: Text(label, style: GoogleFonts.poppins()),
              value: currentValue ?? false,
              onChanged: onChanged,
            ),
          ],
        );


      case 'radio':
      // Radio buttons usually have multiple options defined in meta
        List<dynamic> options = meta['options'] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Map through the options to create a list of RadioListTiles
            ...options.map((option) {
              return RadioListTile(
                title: Text(option.toString(), style: GoogleFonts.poppins()),
                value: option.toString(),
                groupValue: currentValue, // The currently selected value in the form state
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }).toList(),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("No options provided", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
          ],
        );

      case 'address':
        final List<dynamic> lanes = meta['lane'] ?? ['Address Line 1'];
        final List<dynamic> enabledFields = meta['address_fields'] ?? [];

        // Ensure we handle a Map for address values
        Map<String, dynamic> addressValues = currentValue is Map<String, dynamic> ? currentValue : {};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  if (isRequired)
                    const TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Render Dynamic Address Lanes (Line 1, Line 2, etc.)
            ...lanes.map((laneName) {
              String key = laneName.toString().toLowerCase().replaceAll(' ', '_');
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  initialValue: addressValues[key]?.toString(),
                  decoration: InputDecoration(
                    labelText: laneName.toString(),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    addressValues[key] = val;
                    onChanged(addressValues);
                  },
                ),
              );
            }).toList(),

            // Render Selected Optional Fields in a Grid (State, Pincode, etc.)
            if (enabledFields.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 2,
                  childAspectRatio: 2.5,
                ),
                itemCount: enabledFields.length,
                itemBuilder: (context, index) {
                  String field = enabledFields[index].toString();
                  String key = field.toLowerCase();
                  return TextFormField(
                    initialValue: addressValues[key]?.toString(),
                    decoration: InputDecoration(
                      labelText: field,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      addressValues[key] = val;
                      onChanged(addressValues);
                    },
                  );
                },
              ),
          ],
        );

      case 'mobile':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 10,
              initialValue: currentValue?.toString(),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              onChanged: onChanged,
            ),
          ],
        );

      case 'number_field':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: currentValue?.toString(),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              onChanged: onChanged,
            ),
          ],
        );

      case 'text_field':
        return Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: currentValue?.toString(),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              onChanged: onChanged,
            ),
          ],
        );

      case 'textarea':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 3,
              initialValue: currentValue?.toString(),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              onChanged: onChanged,
            ),
          ],
        );


      // case 'matrix':
      //   return Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       RichText(
      //         text: TextSpan(
      //           children: [
      //             TextSpan(
      //               text: label,
      //               style: const TextStyle(
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black,
      //               ),
      //             ),
      //             if (isRequired)
      //               const TextSpan(
      //                 text: ' *',
      //                 style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
      //               ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       Container(
      //         decoration: BoxDecoration(
      //           border: Border.all(color: Colors.indigo, width: 2),
      //         ),
      //         child: SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: Table(
      //             defaultColumnWidth: const FixedColumnWidth(120),
      //             border: TableBorder.all(color: Colors.grey.shade300),
      //             children: [
      //               // Header row
      //               TableRow(
      //                 decoration: BoxDecoration(
      //                   border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      //                 ),
      //                 children: [
      //                   // First column header - always blank
      //                   const SizedBox(),
      //
      //                   // Actual column headers start from second column
      //                   ...columns.map((column) {
      //                     return Container(
      //                       padding: const EdgeInsets.all(10),
      //                       child: Text(
      //                         column.toString(),
      //                         style: const TextStyle(
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.indigo,
      //                         ),
      //                         textAlign: TextAlign.center,
      //                       ),
      //                     );
      //                   }).toList(),
      //                 ],
      //               ),
      //
      //               // Data rows
      //               ...rows.asMap().entries.map((rowEntry) {
      //                 int rowIndex = rowEntry.key;
      //                 String rowLabel = rowEntry.value.toString();
      //
      //                 return TableRow(
      //                   children: [
      //
      //                     Container(
      //                       padding: const EdgeInsets.all(10),
      //                       child: Text(
      //                         rowLabel,
      //                         style: const TextStyle(fontWeight: FontWeight.bold),
      //                         textAlign: TextAlign.center,
      //                       ),
      //                     ),
      //
      //                     // Editable cells start from second column
      //                     ...columns.asMap().entries.map((colEntry) {
      //                       int colIndex = colEntry.key;
      //                       String colLabel = colEntry.value.toString();
      //
      //                       String cellKey = '$rowIndex-$colLabel';
      //
      //                       return Padding(
      //                         padding: const EdgeInsets.all(4.0),
      //                         child: TextFormField(
      //                           initialValue: matrixData[cellKey]?.toString() ?? '',
      //                           decoration: const InputDecoration(
      //                             hintText: '...',
      //                             border: InputBorder.none,
      //                             contentPadding: EdgeInsets.symmetric(horizontal: 8),
      //                           ),
      //                           onChanged: (value) {
      //                             final updatedMatrix =
      //                             Map<String, dynamic>.from(matrixData);
      //                             updatedMatrix[cellKey] = value;
      //                             onChanged(updatedMatrix);
      //                           },
      //                         ),
      //                       );
      //                     }).toList(),
      //                   ],
      //                 );
      //               }).toList(),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //     ],
      //   );
      case 'matrix':
        final List<dynamic> rows = meta['rows'] ?? ['Row 1'];
        final List<dynamic> columns = meta['columns'] ?? ['Col 1'];
        final String cellType = meta['cellType'] ?? 'Text';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  if (isRequired)
                    const TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(120.0),
                border: TableBorder.all(color: Colors.grey[300]!),
                children: [
                  // Header Row
                  TableRow(
                    children: [
                      const SizedBox.shrink(),
                      ...columns.map((col) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Text(col.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                        ),
                      )),
                    ],
                  ),
                  // Data Rows
                  ...rows.asMap().entries.map((rowEntry) {
                    int rowIndex = rowEntry.key;

                    String rowKey = cellType == 'Radio' ? 'row_$rowIndex' : 'r$rowIndex';

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(rowEntry.value.toString()),
                        ),
                        ...columns.asMap().entries.map((colEntry) {
                          int colIndex = colEntry.key;
                          String cellKey = cellType == 'Radio' ? rowKey : 'r${rowIndex}_c${colIndex}';
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _buildCellWidget(
                              type: cellType,
                              value: cellType == 'Radio' ? matrixData[cellKey] == colIndex : matrixData[cellKey],
                              onChanged: (val) {
                                if (cellType == 'Radio') {
                                  // Store the colIndex as the value for this column
                                  matrixData[cellKey] = colIndex;
                                } else {
                                  matrixData[cellKey] = val;
                                }
                                onChanged(Map<String, dynamic>.from(matrixData));
                              },
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        );



      case 'file_picker':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                    //if(field['require'])
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Show status based on currentValue
            Text(
              currentValue != null ? 'File Selected!' : 'No File Selected!',
              style: GoogleFonts.poppins(color: currentValue != null ? Colors.green : Colors.grey),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 18),
                  label: const Text('Scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      onChanged(File(image.path)); // Send file back to screen
                    }
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_copy, size: 18),
                  label: const Text('File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );
                    if (result != null && result.files.single.path != null) {
                      onChanged(File(result.files.single.path!)); // Send file back to screen
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );


      case 'camera_capture' :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt, size: 18),
              label: const Text('Capture Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  onChanged(File(image.path)); // Send file back to screen
                }
              },
            ),
          ],
        );

      case 'image_picker' :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if(isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Show status based on currentValue
            Text(
              currentValue != null ? 'Image Selected!' : 'No Image Selected!',
              style: GoogleFonts.poppins(color: currentValue != null ? Colors.green : Colors.grey),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 18),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      onChanged(File(image.path)); // Send file back to screen
                    }
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );
                    if (result != null && result.files.single.path != null) {
                      onChanged(File(result.files.single.path!)); // Send file back to screen
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );

      case 'date_picker':
        final String dateFormatPattern = meta['dateFormat'] ?? 'dd/MM/yyyy';
        // If currentValue is a DateTime, format it; otherwise, show the label
        String displayValue = "";
        if (currentValue is DateTime) {
          displayValue = DateFormat(dateFormatPattern).format(currentValue);
        } else if (currentValue is String && currentValue.isNotEmpty) {
          displayValue = currentValue; // Fallback if already formatted
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: currentValue is DateTime ? currentValue : DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  // We pass back the DateTime object so the UI can format it
                  // or the raw value can be sent to an API later.
                  onChanged(picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      displayValue.isEmpty ? "Select Date ($dateFormatPattern)" : displayValue,
                      style: GoogleFonts.poppins(
                        color: displayValue.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                    const Icon(Icons.calendar_today, size: 20, color: Colors.indigo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );

      case 'dropdown':
        final options = List<String>.from(meta['options'] ?? []);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: options.contains(currentValue) ? currentValue : null,
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: onChanged,
            ),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("No options provided", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
          ],
        );

      case 'checkbox':
        final options = List<String>.from(meta['options'] ?? []);
        List<String> selected = List<String>.from(currentValue ?? []);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...options.map((o) => CheckboxListTile(
              title: Text(o),
              value: selected.contains(o),
              onChanged: (val) {
                if (val == true) {
                  selected.add(o);
                } else {
                  selected.remove(o);
                }
                onChanged(selected);
              },
            )),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("No options provided", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
          ],
        );

      default:
        return ListTile(title: Text("Unsupported field: $type"));
    }
  }

  //This is for build matrix cell
  static Widget _buildCellWidget({
    required String type,
    required dynamic value,
    required Function(dynamic) onChanged,
  }) {
    switch (type) {
      case 'Radio':
        return Radio<bool>(
          value: true,
          groupValue: value == true,
          onChanged: (bool? val) {
            if (val == true) onChanged(true);
          },
        );
      case 'Checkbox':
        return Checkbox(
          value: value == true,
          onChanged: (val) => onChanged(val),
        );
      case 'Dropdown':
        return DropdownButton<String>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          items: ['Option 1', 'Option 2', 'Option 3']
              .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
              .toList(),
          onChanged: onChanged,
        );
      case 'Text':
      default:
        return Center(
          child: TextField(
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: "..."),
            onChanged: onChanged,
          ),
        );
    }
  }
}