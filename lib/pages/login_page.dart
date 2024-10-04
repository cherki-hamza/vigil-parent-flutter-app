// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, avoid_print, prefer_const_constructors, use_build_context_synchronously, unnecessary_null_comparison, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vigil_parents_app/environment.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _loginAndSendOTP() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    //final url = Uri.parse('${Environment.apiBaseUrl}/api/auth/login');

    final url = Uri.parse('https://vigile-parent-backend.onrender.com/api/auth/login'); //Uri.parse('${Environment.apiBaseUrl}/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        print(json.decode(response.body));
        final responseBody = json.decode(response.body);
        final String token = responseBody['token'];
        final String parentId = responseBody['userId'];
        final String parent_name = responseBody['userName'];

        if (token != null) {
          // Save token and email to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('email', email);
          await prefs.setString('parentId', parentId);
          await prefs.setString('parent_name', parent_name);

          // Navigate to LinkParentDevicePage
          Navigator.pushReplacementNamed(context, '/devicespage', arguments: {'email': email, 'token': token , 'parentId': parentId , 'parent_name' : parent_name});
        } else {
          _showErrorDialog('Invalid response from server');
        }
      } else {
        // Handle error
        final responseBody = json.decode(response.body);
        _showErrorDialog(responseBody['msg'] ?? 'Unknown error');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      _showErrorDialog('An error occurred. Please try again.$error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60), // Add some space at the top
            Text(
              'Protect Your Child With',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Vigil 1',
              style: TextStyle(
                fontSize: 42,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                color: Color.fromRGBO(43, 160, 204, 1),
                height: 1,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sign in to get started.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'jhondoe@gmail.com',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                 Navigator.pushNamed(context, '/send_code');
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dont have an account?',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(21, 190, 181, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),// This will push the button to the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: double.infinity, // Make the button full-width
                child: ElevatedButton(
                  onPressed: _loginAndSendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 60), // Set width to full and height to 60
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
