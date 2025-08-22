import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/screens/home_screen.dart';
import 'package:story_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    await Provider.of<AuthProvider>(context, listen: false).checkAuth();

    if (mounted) {
      if (Provider.of<AuthProvider>(context, listen: false).isAuthenticated) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
