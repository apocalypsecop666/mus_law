import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mus_law/core/constants/api_constants.dart';

class ApiClient {
  final http.Client client;

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final response = await client
          .get(Uri.parse(ApiConstants.postsEndpoint))
          .timeout(const Duration(seconds: ApiConstants.timeoutSeconds));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        
        if (decodedData is List) {
          return decodedData.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchPosts(String query) async {
    final allPosts = await getPosts();
    return allPosts.where((post) {
      final title = post['title']?.toString().toLowerCase() ?? '';
      final body = post['body']?.toString().toLowerCase() ?? '';
      return title.contains(query.toLowerCase()) ||
          body.contains(query.toLowerCase());
    }).toList();
  }
}
