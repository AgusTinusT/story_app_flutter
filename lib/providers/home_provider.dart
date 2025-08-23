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
  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  HomeProvider() {
    fetchStories(isInitialFetch: true);
  }

  Future<void> fetchStories({bool isInitialFetch = false}) async {
    if (isInitialFetch) {
      _page = 1;
      _stories = [];
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newStories = await _storyService.getStories(page: _page, size: _pageSize);
      if (newStories.length < _pageSize) {
        _hasMore = false;
      }
      _stories.addAll(newStories);
      _page++;
    } catch (e) {
      _errorMessage = 'Failed to load stories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
