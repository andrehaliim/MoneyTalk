import 'package:flutter/material.dart';
import 'package:money_talk/pages/main/main-page.dart';
import 'package:money_talk/objectbox-store.dart';
import 'package:money_talk/themedata.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: MainPage(),
    );
  }
}
