
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedLanguage = "English"; // Default language

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String email = arguments['email'];
    final String token = arguments['token'];

    Future<void> _logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('email');
      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          email,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/notificationstoggle',
                  arguments: {
                    'email': email,
                    'token': token,
                  },
                );
              },
              child: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/editprofile',
                      arguments: {
                        'email': email,
                        'token': token,
                      },
                    );
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),

            // Subscription Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subscription',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '\$10/',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Monthly',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                              context,
                              '/subscriptionpage',
                              arguments: {
                                'email': email,
                                'token': token,
                              },
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),

            // Language Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Navigate to LanguagePage and wait for result
                    final result = await Navigator.pushNamed(
                      context,
                      '/languages',
                      arguments: {
                        'selectedLanguage': selectedLanguage, // Pass the current selected language
                      },
                    );

                    // If result is not null, update the language in ProfilePage
                    if (result != null && result is String) {
                      setState(() {
                        selectedLanguage = result; // Update the selected language
                      });
                    }
                  },
                  child: Text(
                    selectedLanguage, // Display selected language
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),

            // Notifications Row
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/notificationstoggle',
                  arguments: {
                    'email': email,
                    'token': token,
                  },
                );
              },
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.0),

            // FAQs Row
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/faq',
                  arguments: {
                    'email': email,
                    'token': token,
                  },
                );
              },
              child: Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.0),

            // About Vigil1 Row
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/aboutus',
                  arguments: {
                    'email': email,
                    'token': token,
                  },
                );
              },
              child: Text(
                'About Vigil1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),

            // Logout Button
            Center(
              child: Column(
                children: [
                  Text(
                    'App version 1.0.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      padding: EdgeInsets.symmetric(vertical: 18), // Vertical padding for height
                      minimumSize: Size(double.infinity, 56), // Full-width button with a consistent height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0), // Rounded corners
                      ),
                      elevation: 5, // Add shadow for depth
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font for emphasis
                        fontWeight: FontWeight.bold, // Bold text for importance
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Assuming Profile is the second tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/dashboard_home', arguments: arguments);
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile', arguments: arguments);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/homeicon.png', // Path to your custom home icon
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/profile-icon.png', // Path to your custom profile icon
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

}


