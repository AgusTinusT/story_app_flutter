import 'package:flutter/material.dart';
import 'package:story_app/models.dart';
import 'package:story_app/services/story_service.dart';

enum ResultState { loading, noData, hasData, error }

class StoryDetailProvider extends ChangeNotifier {
  final StoryService storyService;
  final String id;

  StoryDetailProvider({required this.storyService, required this.id}) {
    _fetchStoryDetail();
  }

  late Story _story;
  late ResultState _state;
  String _message = '';

  Story get story => _story;
  ResultState get state => _state;
  String get message => _message;

  Future<void> _fetchStoryDetail() async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final story = await storyService.getStoryDetail(id);
      _story = story;
      _state = ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
