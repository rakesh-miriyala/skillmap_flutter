import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000";

  static Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    } else {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getWorkers() async {
    final url = Uri.parse("$baseUrl/workers");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch workers");
    }
  }

  static Future<bool> addWorker(Map<String, dynamic> worker) async {
    final url = Uri.parse("$baseUrl/workers");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(worker),
    );

    return response.statusCode == 200;
  }

  static Future<bool> updateWorker(int id, Map<String, dynamic> worker) async {
    final url = Uri.parse("$baseUrl/workers/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(worker),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteWorker(int id) async {
    final url = Uri.parse("$baseUrl/workers/$id");
    final response = await http.delete(url);
    return response.statusCode == 200;
  }
}
