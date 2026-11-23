import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RangerArchiveApp());
}

class RangerArchiveApp extends StatelessWidget {
  const RangerArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ranger Archive',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF4444),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
