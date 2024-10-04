// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigil - Parents App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // Set SplashScreen as the initial route
        ...AppRoutes.routes,
      },
    );
  }
}

class SplashScreen extends StatelessWidget {

  Future<void> checkLoginState(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('email');
    final parentId = prefs.getString('parentId');
    final parent_name = prefs.getString('parent_name');

    if (token != null && email != null) {
      Navigator.pushReplacementNamed(context, '/devicespage', arguments: {'token': token, 'email': email, 'parentId': parentId , 'parent_name': parent_name});
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }

  }

  @override
  Widget build(BuildContext context) {
    checkLoginState(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
