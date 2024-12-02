import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tournoi_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TournoiProvider()), // Gestion des tournois
        ChangeNotifierProvider(create: (_) => UserProvider()),   // Gestion des utilisateurs
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Active Material Design 3 si compatible
      ),
      title: "AlcaDarts",
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false, // Désactive le bandeau de debug
    );
  }
}
