import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'db/app_database.dart';
import 'screens/notes_screen.dart';

void main() {
  runApp(
    Provider(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NotesScreen(),
    );
  }
}
