import 'dart:async';
import 'dart:convert';
import 'package:vigil_parents_app/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({Key? key}) : super(key: key);

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  List<String> _code = List.generate(6, (index) => '');
  bool _isRequestNewCodeEnabled = false;
  int _countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isRequestNewCodeEnabled = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _verifyOTP(String email) async {
    String otp = _code.join();
    // Send request to backend to verify OTP
    final url = '${Environment.apiBaseUrl}/api/auth/verify-otp';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      // Pass both email and OTP to the final password reset page
      Navigator.pushNamed(
        context,
        '/passwordreset_final',
        arguments: {
          'email': email,
          'otp': otp,
        },
      );
    } else {
      final errorMsg = jsonDecode(response.body)['msg'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMsg')));
    }
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      setState(() {
        _code[index] = value;
      });
      if (index < 5) {
        FocusScope.of(context).nextFocus();
      }
    } else {
      setState(() {
        _code[index] = '';
      });
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 110), // Add some space at the top
                Text(
                  "Enter the 6-digit code sent to your email.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 50),
                // Center the "Enter Code" text and the instruction
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Enter Code",
                        style: TextStyle(fontSize: 16, color: Color.fromRGBO(21, 190, 181, 1)),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "A 6-digit code is on its way to your email.\nEnter it below to reset your password.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      // Center the code input section with input fields for each digit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: 40,
                              child: TextField(
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none, // Remove the box/border
                                  hintText: '•',  // Dot as a placeholder
                                  hintStyle: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                onChanged: (value) => _onCodeChanged(value, index),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _verifyOTP(email), // Handle the button press
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 60), // Set the button's width to fill the parent and height to 60
                    ),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48), // This provides spacing equivalent to the icon
              ],
            ),
          ),
        ],
      ),
    );
  }
}
