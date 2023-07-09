import 'package:flutter/material.dart';
import 'package:vca_app2/pages/fscreen.dart';
import 'package:vca_app2/pages/home.dart';
import 'package:vca_app2/pages/upload.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const Fscreen(),
    );
  }
}
