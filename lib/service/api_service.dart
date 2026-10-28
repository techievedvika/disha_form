import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // For handling file paths
import 'dart:io';

import '../data/models/form_widget_model.dart';

class ApiService {
  // Fetch all forms method
  static Future<List<dynamic>> fetchData() async {
    final url =
        'https://disha.vedvika.com/forms'; // API endpoint for fetching all forms
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // Post form data method (including image handling)
  static Future<void> postFormData(
      int formId, Map<String, dynamic> fieldsValue) async {
    print('Fields value: $fieldsValue'); // Print the fields value map

    final url =
        'https://disha.vedvika.com/api/save-form'; // API endpoint for posting form data

    // Separate image fields from other fields
    Map<String, dynamic> nonImageFields = {};
    Map<String, File> imageFiles = {};

    fieldsValue.forEach((key, value) {
      print('Key: $key, Value: $value'); // Print each key-value pair

      if (value is File) {
        imageFiles[key] = value; // Store images separately
      } else {
        nonImageFields[key] = value; // Store non-image fields
      }
    });

    try {
      // 1. Upload images if there are any
      for (String label in imageFiles.keys) {
        String? serverFileName = await uploadImage(label, imageFiles[label]!);
        if (serverFileName != null) {
          nonImageFields[label] =
              serverFileName; // Add the server filename to the fields
        }
      }

      // 2. Now, send the non-image fields (including the image URLs if they exist)
      if (nonImageFields.isNotEmpty) {
        final body = jsonEncode({
          'form_id': formId,
          'fields_value':
          nonImageFields, // Only non-image fields and image URLs are sent here
        });

        print('Body: $body'); // Print the request body

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
        );

        if (response.statusCode == 200) {
          print('Data posted successfully');
        } else {
          throw Exception('Failed to post data');
        }
      } else {
        print('No non-image data to post.');
      }
    } catch (e) {
      print('Error posting data: $e'); // Print the error message
      throw Exception('Error posting data: $e');
    }
  }

  // Upload image method
  static Future<String?> uploadImage(String label, File imageFile) async {
    final url =
        'https://disha.vedvika.com/api/upload'; // API endpoint for uploading images

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Attach the image file as an array
      request.files.add(
        await http.MultipartFile.fromPath(
          'image[]', // The field name expected by the API
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );

      var response = await request.send();

      // Read the response for further inspection
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response body: ${responseBody.body}');
        print('Image uploaded successfully');

        // Parse the response to get the file name given by the server
        final responseData = jsonDecode(responseBody.body);

        // Adjust based on the actual key returned by the API
        String? serverFileName = responseData['data'][0]['image_name'];
        // If the file name is not in the expected field, you might need to inspect the response body
        if (serverFileName == null) {
          print('Server did not return a file name.');
          print('Response body: ${responseBody.body}');
        } else {
          print('Server-assigned file name: $serverFileName');
        }

        return serverFileName;
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print('Response body: ${responseBody.body}');
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> postForm({
    required String userId,
    required String formName,
    required List<FormWidgetModel> widgets,
  }) async {
    final String apiUrl = 'https://demo.vedvika.com/api/dynamic_form_upload';

    try {
      // Encode form fields to JSON string
      final String jsonFormFields = jsonEncode(widgets);

      // Prepare body
      final Map<String, dynamic> body = {
        'user_id': userId,
        'form_name': formName,
        'form': jsonFormFields,
      };

      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Handle response
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Form submitted successfully: $result');
      } else {
        print('Failed to submit form. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('⚠Error submitting form: $e');
    }
  }

  static Future<List<dynamic>?> getAllForms(String userId) async {
    final String apiUrl =
        'https://demo.vedvika.com/api/get_dynamic_form?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // CASE 1: API already returns a list
        if (decoded is List) {
          return decoded.map((item) {
            if (item["form"] is String) {
              try {
                item["form"] = jsonDecode(item["form"]);
              } catch (_) {}
            }
            return item;
          }).toList();
        }

        // CASE 2: API returns {"data": [...]}
        if (decoded is Map && decoded["data"] is List) {
          return (decoded["data"] as List).map((item) {
            if (item["form"] is String) {
              try {
                item["form"] = jsonDecode(item["form"]);
              } catch (_) {}
            }
            return item;
          }).toList();
        }

        // CASE 3: API returns a single object
        if (decoded is Map) {
          if (decoded["form"] is String) {
            try {
              decoded["form"] = jsonDecode(decoded["form"]);
            } catch (_) {}
          }
          return [decoded]; // convert single object into list
        }
      } else if(response.statusCode == 404){
        print("No forms found for user: $userId");
        return [];
      }
      return null;
    } catch (e) {
      print("⚠️ Error while fetching forms: $e");
      return null;
    }
  }


}
