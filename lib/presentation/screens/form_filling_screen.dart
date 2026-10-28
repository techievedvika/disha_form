// lib/presentation/screens/form_filling_screen.dart

import 'dart:convert';
import 'package:disha_form/presentation/widgets/normal_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/dynamic_form_widget_factory.dart';

class FormFillingScreen extends StatefulWidget {
  final String? formName;
  final String? formId;
  final dynamic formFields;

  const FormFillingScreen({this.formName, this.formId, this.formFields, super.key});

  @override
  State<FormFillingScreen> createState() => _FormFillingScreenState();
}

class _FormFillingScreenState extends State<FormFillingScreen> {
  List<dynamic> _fields = [];
  final Map<String, dynamic> _formValues = {};

  @override
  void initState() {
    super.initState();
    _parseFormFields();

  }

  void _parseFormFields() {
    if (widget.formFields != null) {
      try {
        _fields = (widget.formFields is String)
            ? jsonDecode(widget.formFields)
            : widget.formFields;

        _formValues.clear(); // Clear existing to prevent duplicates on rebuild

        for (var field in _fields) {
          String id = field['id'].toString();
          String label = field['label'] ?? '';

          // 1. Define the default value based on type
          dynamic defaultValue = ""; // Default for text, mobile, date, etc.

          if (field['type'] == 'checkbox') {
            defaultValue = <String>[];
          } else if (field['type'] == 'switch') {
            defaultValue = false;
          } else if (field['type'] == 'matrix') {
            defaultValue = <String, dynamic>{};
          } else if (field['type'] == 'address') {
            defaultValue = ""; // Or a Map if your address widget returns one
          }

          // 2. Assign the Map structure to _formValues
          _formValues[id] = {
            'label': label,
            'value': defaultValue,
          };
        }

        print("Initialized Form Values: $_formValues");
      } catch (e) {
        debugPrint("Error parsing form fields: $e");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${widget.formName}'),
      body: _fields.isEmpty
          ? const Center(child: Text("No fields found."))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _fields.length,
        itemBuilder: (context, index) {
          final field = _fields[index];
          final String id = field['id'];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DynamicFormWidgetFactory.build(
              context: context,
              field: field,
              currentValue: _formValues[id]['value'],
              onChanged: (newValue) {
                setState(() {
                  _formValues[id]['value'] = newValue;
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              print("FINAL FORM DATA: $_formValues");
              // You can now send _formValues back to your API
            },
            child: Text("Submit Form", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}