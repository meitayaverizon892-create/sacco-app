import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/online_member.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // GET - Fetch all online members
  static Future<List<OnlineMember>> fetchOnlineMembers() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OnlineMember.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('API not found (404)');
      } else if (response.statusCode == 500) {
        throw Exception('Server error (500)');
      } else {
        throw Exception('Failed to load data (${response.statusCode})');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Connection timeout. Check your internet.');
      }
      throw Exception('Error: $e');
    }
  }
}
