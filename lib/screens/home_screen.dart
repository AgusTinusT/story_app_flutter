import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<HomeProvider>(context, listen: false).logout();
              if (!context.mounted) return;
              context.go('/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (homeProvider.errorMessage != null) {
            return Center(child: Text('Error: \${homeProvider.errorMessage}'));
          } else if (homeProvider.stories.isEmpty) {
            return const Center(child: Text('No stories found.'));
          } else {
            final stories = homeProvider.stories;
            return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      story.photoUrl,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.image),
                    ),
                    title: Text(story.name),
                    subtitle: Text(
                      story.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      context.push("/story/${story.id}");
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/add_story');
          if (!context.mounted) return;
          Provider.of<HomeProvider>(context, listen: false).fetchStories();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}