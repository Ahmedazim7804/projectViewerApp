import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projects_viewer/screens/auth_screen.dart';
import 'package:projects_viewer/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projects_viewer/screens/splash_screeen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return const AuthScreen();
        }
      }),
    );
  }
}