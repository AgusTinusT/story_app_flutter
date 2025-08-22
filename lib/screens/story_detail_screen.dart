import 'package:flutter/material.dart';
import 'package:story_app/models.dart';
import 'package:story_app/services/story_service.dart';

class StoryDetailScreen extends StatefulWidget {
  final String id;

  const StoryDetailScreen({super.key, required this.id});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final StoryService _storyService = StoryService();
  late Future<Story> _storyDetailFuture;

  @override
  void initState() {
    super.initState();
    _storyDetailFuture = _storyService.getStoryDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Story')),
      body: FutureBuilder<Story>(
        future: _storyDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Story not found.'));
          } else {
            final story = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    story.photoUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.image, size: 100)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    story.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created at: \${story.createdAt.toLocal()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    story.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
