import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/services/story_service.dart';

class AddStoryProvider extends ChangeNotifier {
  final StoryService _storyService = StoryService();

  File? _image;
  bool _isLoading = false;
  String? _message;

  File? get image => _image;
  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<bool> addStory(String description) async {
    if (_image == null) {
      _message = 'Please select an image';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final bytes = await _image!.readAsBytes();
      final fileName = _image!.path.split('/').last;

      await _storyService.addStory(description, bytes, fileName);

      _message = 'Story added successfully!';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _message = 'Failed to add story: \$e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void resetMessage() {
    _message = null;
    notifyListeners();
  }
}
