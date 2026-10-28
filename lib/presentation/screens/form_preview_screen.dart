import 'package:disha_form/service/dynamic_form_widget_factory.dart';
import 'package:flutter/material.dart';
import '../../data/models/form_widget_model.dart';
import '../widgets/normal_widgets/custom_appbar.dart';


class FormPreviewScreen extends StatefulWidget {
  final List<FormWidgetModel> formFields;
  FormPreviewScreen({super.key, required this.formFields});

  @override
  State<FormPreviewScreen> createState() => _FormPreviewScreenState();
}

class _FormPreviewScreenState extends State<FormPreviewScreen> {
  // Store values of the form fields to handle state within the preview
  final Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    // Initialize form data with null or empty values if needed
    for (var field in widget.formFields) {
      _formData[field.id] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Form Preview'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.formFields.map((fieldModel) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DynamicFormWidgetFactory.build(
                    context: context,
                    // Convert model to JSON map as expected by the factory
                    field: fieldModel.toJson(),
                    currentValue: _formData[fieldModel.id],
                    onChanged: (newValue) {
                      setState(() {
                        _formData[fieldModel.id] = newValue;
                      });
                    },
                  ),
                );
              }).toList(),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     // Example of how to access the collected data
              //     print("Captured Form Data: $_formData");
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Form data printed to console')),
              //     );
              //   },
              //   child: const Text('Submit (Preview Mode)'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}