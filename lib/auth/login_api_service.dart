import 'dart:convert';
import 'package:http/http.dart' as http;

class UserLoginApiService {
  final String apiUrl = "https://disha.vedvika.com/api/user-login"; // Replace with your API URL

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "version": "1.0.0",  // Add the version field here
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == false) {
        return {
          "status": true,
          "message": "Login successful",
          "id": data['data']['id']
        };
      } else {
        return {"status": false, "message": data['message']};
      }
    } else {
      return {"status": false, "message": "Server error. Please try again later."};
    }
  }
}
