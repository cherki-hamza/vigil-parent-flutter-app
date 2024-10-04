import 'dart:async';
import 'dart:convert';
import 'package:vigil_parents_app/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendCodePage extends StatefulWidget {
  const SendCodePage({Key? key}) : super(key: key);

  @override
  _SendCodePageState createState() => _SendCodePageState();
}

class _SendCodePageState extends State<SendCodePage> {
  TextEditingController _emailController = TextEditingController();
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

  void _requestNewCode() async {
    setState(() {
      _countdown = 10;
      _isRequestNewCodeEnabled = false;
    });
    _startCountdown();

    // Send request to backend to send OTP

    final url = Uri.parse('${Environment.apiBaseUrl}/api/auth/request-password-reset');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/verify_otp', arguments: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent to your email')));
    } else {
      final errorMsg = jsonDecode(response.body)['msg'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMsg')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Enter your email and we'll send you a reset code.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'johndoe@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isRequestNewCodeEnabled
                            ? _requestNewCode
                            : null,
                        child: Text(
                          "Didn't receive the code? Request a new one",
                          style: TextStyle(color: _isRequestNewCodeEnabled ? Color.fromRGBO(21, 190, 181, 1) : Colors.grey),
                        ),
                      ),
                      if (!_isRequestNewCodeEnabled)
                        Text(
                          ' $_countdown' + 's',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _requestNewCode, // Handle the button press
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 60), // Set the button's width to fill the parent and height to 60
                    ),
                    child: Text(
                      'Send Code',
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
                      'Reset Password',
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
