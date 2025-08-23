import 'package:flutter/material.dart';
import 'package:story_app/models.dart';
import 'package:story_app/services/auth_service.dart';
import 'package:story_app/services/story_service.dart';

class HomeProvider extends ChangeNotifier {
  final StoryService _storyService = StoryService();
  final AuthService _authService = AuthService();

  List<Story> _stories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeProvider() {
    fetchStories();
  }

  Future<void> fetchStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await _storyService.getStories();
    } catch (e) {
      _errorMessage = 'Failed to load stories: \$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
