
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_app/services/auth_service.dart';
import '../models.dart';

class StoryService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';
  final AuthService _authService = AuthService();

  Future<List<Story>> getStories({int page = 1, int size = 10}) async {
    final token = await _authService.getToken();
    final url = Uri.parse('$_baseUrl/stories?page=$page&size=$size');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Story> stories = (data['listStory'] as List)
          .map((storyJson) => Story.fromJson(storyJson))
          .toList();
      return stories;
    } else {
      throw Exception('Failed to load stories');
    }
  }

  Future<Story> getStoryDetail(String id) async {
    final token = await _authService.getToken();
    final url = Uri.parse('$_baseUrl/stories/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Story.fromJson(data['story']);
    } else {
      throw Exception('Failed to load story detail');
    }
  }

  Future<void> addStory(
      String description, List<int> bytes, String fileName,
      {double? lat, double? lon}) async {
    final token = await _authService.getToken();
    final url = Uri.parse('$_baseUrl/stories');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    if (lat != null) {
      request.fields['lat'] = lat.toString();
    }
    if (lon != null) {
      request.fields['lon'] = lon.toString();
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: fileName,
      ),
    );

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add story');
    }
  }
}
