import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Onboarding.dart';
import 'package:flutter_helloo_world/pages/Dashboardbaru.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyDashboardApp()); // Replace MyApp with your app's main widget
}

class MyDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simpemas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/Dashboard': (context) => DashboardBaru(),
      },
    );
  }
}
