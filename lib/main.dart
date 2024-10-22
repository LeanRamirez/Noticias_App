// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/NoticiasPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticias App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoticiasPage(),
    );
  }
}
