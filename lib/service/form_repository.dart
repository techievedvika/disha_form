// // lib/data/services/form_repository.dart
//
// import '../../data/models/form_widget_model.dart';
//
// /// A simulated repository to handle saving and retrieving form templates.
// /// In a real app, this would interact with a database (Firebase, Supabase, etc.).
// class FormRepository {
//   // Use a singleton pattern to ensure we're always working with the same "database".
//   static final FormRepository _instance = FormRepository._internal();
//   factory FormRepository() => _instance;
//   FormRepository._internal();
//
//   /// Our in-memory database.
//   /// The key is the formId (String), and the value is the list of widgets (the form structure).
//   final Map<String, List<Map<String, dynamic>>> _formDatabase = {};
//
//   /// Saves a form structure to the database and returns a unique ID.
//   Future<String> saveForm(List<FormWidgetModel> widgets) async {
//     // Generate a unique ID for the form.
//     final formId = 'form_${DateTime.now().millisecondsSinceEpoch}';
//
//     // Convert the list of widget models to a JSON-serializable list.
//     final formJson = widgets.map((widget) => widget.toJson()).toList();
//
//     // "Save" it to our map.
//     _formDatabase[formId] = formJson;
//
//     print('Form saved with ID: $formId');
//     print('Current DB state: $_formDatabase');
//
//     return formId;
//   }
//
//   /// Retrieves a form structure by its ID.
//   Future<List<FormWidgetModel>> getForm(String formId) async {
//     if (!_formDatabase.containsKey(formId)) {
//       throw Exception('Form not found!');
//     }
//
//     // Retrieve the raw JSON list.
//     final formJson = _formDatabase[formId]!;
//
//     // Convert it back to a list of FormWidgetModel.
//     return formJson.map((json) => FormWidgetModel.fromJson(json)).toList();
//   }
// }
// lib/service/form_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/form_list_item_model.dart';
import '../data/models/form_res_model.dart';
import '../data/models/form_widget_model.dart';
import '../core/apis/api.dart'; // Import your Api class

class FormRepository {
  /// Saves the form structure to the remote server.
  ///
  /// Takes a list of [FormWidgetModel] and a [userId], converts them to JSON,
  /// and POSTs them to the form upload API endpoint.
  // Future<String> saveForm(List<FormWidgetModel> widgets, String userId) async {
  //   // Use the API endpoint from your Api class.
  //   // Note: The original URL had a '+' which is likely a typo for '/'. I've corrected it.
  //   final url = Uri.parse(Api.baseUrl + "dynamic_form_upload");
  //
  //   // Convert the list of widget models to a list of maps.
  //   final List<Map<String, dynamic>> widgetJson = widgets.map((widget) => widget.toJson()).toList();
  //
  //   // Create the final payload including the userId and the form structure.
  //   final Map<String, dynamic> payload = {
  //     'user_id': userId,
  //     'form': widgetJson, // Embed the widget list in a 'form_data' key
  //     'form_name' : 'Testing',
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(payload), // Encode the entire payload map
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Success! Parse the response to get the form ID.
  //       final responseBody = json.decode(response.body);
  //
  //       // Assuming the server returns a JSON object like: {"status": "success", "form_id": "some_unique_id"}
  //       final String formId = responseBody['form_id'] ?? 'unknown_id';
  //       print('Form saved successfully. Form ID: $formId');
  //       return formId;
  //     } else {
  //       // Handle server errors (e.g., 404, 500).
  //       print('Failed to save form. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       throw Exception('Failed to save form on server. Status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle network errors (e.g., no internet connection).
  //     print('An error occurred while saving the form: $e');
  //     throw Exception('Network error occurred while saving form.');
  //   }
  // }

  Future<String> saveForm(List<FormWidgetModel> widgets, String userId, String formName) async {
    final url = Uri.parse(Api().formUploadApi);
    //final url = Uri.parse(Api.baseUrl + "dynamic_form_upload");

    final List<Map<String, dynamic>> widgetJson = widgets.map((widget) => widget.toJson()).toList();

    // *** THIS IS THE CORRECT PAYLOAD STRUCTURE ***
    // Your server-side code MUST be updated to read 'user_id', 'form_name', and 'form'.
    final Map<String, dynamic> payload = {
      'user_id': userId,
      'form_name': formName, // Sending the name.
      'form': widgetJson,    // Sending the form structure as a JSON array/list.
      'updated_by' : userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload), // Encode the entire payload map
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final String formId = responseBody['data']?['form_id']?.toString() ?? 'unknown_id';
        print('Form saved successfully. Form ID: $formId');
        return formId;
      } else {
        print('Failed to save form. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to save form on server. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while saving the form: $e');
      throw Exception('Network error occurred while saving form.');
    }
  }

  /// Retrieves a form structure from the server by its ID.
  Future<List<FormWidgetModel>> getForm(String formId, String userId) async {
    final url = Uri.parse(Api().getFormApi);
    const String testUserId = '123';

    // The payload needs to send the form_id to identify which form to get.
    // The previous implementation was sending 'form' instead of 'form_id'.
    final Map<String, dynamic> payload = {
      'user_id': userId,
      'form': formId, // Corrected key
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // *** THIS IS THE FIX ***
        // Assuming the server returns a direct JSON array in the 'data' key.
        // We cast it directly to a List<dynamic> without a second decode.
        final List<dynamic> widgetJsonList = responseBody['data'] as List<dynamic>;

        // Convert the raw JSON list back into a list of FormWidgetModel objects.
        final List<FormWidgetModel> widgets = widgetJsonList.map((json) => FormWidgetModel.fromJson(json)).toList();

        print('Form loaded successfully. Form ID: $formId');
        return widgets;
      } else {
        print('Failed to get form. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to get form from server. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while getting the form: $e');
      throw Exception('Network error or data parsing issue occurred.');
    }
  }

  // Future<FormResModel> getForm(int formId) async {
  //   final url = Uri.parse(Api().getFormApi);
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'id': formId,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final decoded = jsonDecode(response.body);
  //     return FormResModel.fromJson(decoded);
  //   } else if (response.statusCode == 422) {
  //     final decoded = jsonDecode(response.body);
  //     throw Exception(decoded['message']);
  //   } else if (response.statusCode == 404) {
  //     final decoded = jsonDecode(response.body);
  //     throw Exception(decoded['message']);
  //   } else {
  //     throw Exception('Failed to fetch form (${response.statusCode})');
  //   }
  // }




  Future<List<FormListItemModel>> getAllForms(String userId) async {
    // 1. Use the correct API endpoint
    final url = Uri.parse(Api().getAllFormApi);
    final payload = {'user_id': userId};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // 2. The server returns a list of forms directly in the 'data' key.
        final List<dynamic> formListJson = responseBody['data'] as List<dynamic>;

        // 3. Use the fromJson factory in FormListItemModel to parse each item.
        return formListJson
            .map((json) => FormListItemModel.fromJson(json))
            .toList();
      } else {
        print('Failed to fetch form list. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to fetch form list. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllForms: $e');
      throw Exception('Network error or data parsing issue occurred while fetching form list.');
    }
  }
}
