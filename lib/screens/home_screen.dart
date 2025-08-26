import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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

  String _timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} years ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} months ago';
    } else if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  Future<String> _getAddressFromLatLng(double? lat, double? lon) async {
    if (lat == null || lon == null) {
      return 'Location not available';
    }
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks[0];
      String administrativeArea = place.administrativeArea ?? '';
      String country = place.country ?? '';

      if (administrativeArea.isNotEmpty && country.isNotEmpty) {
        return '$administrativeArea, $country';
      } else if (administrativeArea.isNotEmpty) {
        return administrativeArea;
      } else if (country.isNotEmpty) {
        return country;
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      return 'Could not get address: $e';
    }
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
            return ListView.builder(
              itemCount: 5, // Show 5 shimmer items
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          color: Colors.white,
                        ),
                        ListTile(
                          title: Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          subtitle: Container(
                            height: 12,
                            width: double.infinity,
                            color: Colors.white,
                            margin: const EdgeInsets.only(top: 4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (homeProvider.errorMessage != null &&
              homeProvider.stories.isEmpty) {
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
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            color: Colors.white,
                          ),
                          ListTile(
                            title: Container(
                              height: 16,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              height: 12,
                              width: double.infinity,
                              color: Colors.white,
                              margin: const EdgeInsets.only(top: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final story = stories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            story.photoUrl,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.image, size: 100),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54, // Contrasting background
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _timeAgo(story.createdAt),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  color: Colors.white,
                                ), // White text for contrast
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text(story.name),
                        subtitle: FutureBuilder<String>(
                          future: _getAddressFromLatLng(story.lat, story.lon),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading location...');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                  ), // Location icon
                                  const SizedBox(width: 4), // Small space
                                  Expanded(
                                    // Use Expanded to prevent overflow
                                    child: Text(
                                      snapshot.data!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Text('Location not available');
                            }
                          },
                        ),
                        onTap: () {
                          context.push("/story/${story.id}");
                        },
                      ),
                    ],
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
          Provider.of<HomeProvider>(
            context,
            listen: false,
          ).fetchStories(isInitialFetch: true);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
