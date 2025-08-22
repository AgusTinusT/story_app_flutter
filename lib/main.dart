import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/add_story_provider.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/home_provider.dart';
import 'package:story_app/router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AddStoryProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
      ),
    );
  }
}
