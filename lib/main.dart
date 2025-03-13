import 'package:flutter/material.dart';
import 'moodtracker.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false; // Manage the theme state (light/dark)


  // Function to toggle between light and dark themes
  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker App',
      theme: _isDarkTheme ? _buildDarkTheme() : _buildLightTheme(),
      initialRoute: '/moodTracker',
      routes: {
        '/moodTracker': (context) => MoodTracker(
              toggleTheme: _toggleTheme, // Pass the function with a bool parameter
              isDarkTheme: _isDarkTheme, // Pass the current theme state
            ),
      },
    );
  }


  // Light theme settings
  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
      ),
      scaffoldBackgroundColor: Colors.blue[50],
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }


  // Dark theme settings
  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
        ),
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
