import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/story_detail_provider.dart';
import 'package:story_app/services/story_service.dart';

class StoryDetailScreen extends StatelessWidget {
  final String id;

  const StoryDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoryDetailProvider(
        storyService: StoryService(),
        id: id,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Story')),
        body: Consumer<StoryDetailProvider>(
          builder: (context, provider, child) {
            switch (provider.state) {
              case ResultState.loading:
                return const Center(child: CircularProgressIndicator());
              case ResultState.error:
                return Center(child: Text(provider.message));
              case ResultState.hasData:
                final story = provider.story;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        story.photoUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
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
                        'Created at: ${story.createdAt.toLocal()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        story.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      if (story.lat != null && story.lon != null)
                        SizedBox(
                          height: 300,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(story.lat!, story.lon!),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('story-location'),
                                position: LatLng(story.lat!, story.lon!),
                              ),
                            },
                          ),
                        ),
                    ],
                  ),
                );
              default:
                return const Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }
}
