import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_dto.dart';

class UserService {
  static const String baseUrl = 'https://streamsite-ball-wijzer.vercel.app/api';

  Future<Map<String, dynamic>> updateProfile(ProfileDTO profile) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/update'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profile.toMap()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
