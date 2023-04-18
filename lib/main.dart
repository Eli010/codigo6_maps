import 'package:codigo6_mapas/pages/home_page.dart';
import 'package:codigo6_mapas/pages/permission_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: PermissionPage(),
      // home: HomePage(),
    );
  }
}
