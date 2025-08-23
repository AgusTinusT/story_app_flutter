import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        homeProvider.fetchStories();
      }
    });

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.fetchStories(isInitialFetch: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          if (homeProvider.isLoading && homeProvider.stories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (homeProvider.errorMessage != null && homeProvider.stories.isEmpty) {
            return Center(child: Text('Error: ${homeProvider.errorMessage}'));
          } else if (homeProvider.stories.isEmpty) {
            return const Center(child: Text('No stories found.'));
          } else {
            final stories = homeProvider.stories;
            return ListView.builder(
              controller: _scrollController,
              itemCount: stories.length + (homeProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == stories.length) {
                  return const Center(child: CircularProgressIndicator());
                }
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
          Provider.of<HomeProvider>(context, listen: false)
              .fetchStories(isInitialFetch: true);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
