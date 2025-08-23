import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/screens/add_story_screen.dart';
import 'package:story_app/screens/home_screen.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/register_screen.dart';
import 'package:story_app/screens/splash_screen.dart';
import 'package:story_app/screens/story_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/add_story',
        builder: (BuildContext context, GoRouterState state) {
          return const AddStoryScreen();
        },
      ),
      GoRoute(
        path: '/story/:id',
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id']!;
          return StoryDetailScreen(id: id);
        },
      ),
    ],
  );
}
