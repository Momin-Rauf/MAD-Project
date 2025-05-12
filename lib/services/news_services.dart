import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _baseUrl =
      'https://streamsite-ball-wijzer.vercel.app/api/news';

  Future<List<NewsModel>> getNews() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> headlines = data['headlines'];

        return headlines
            .map((headline) => NewsModel.fromJson(headline))
            .toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
