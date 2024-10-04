import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Protect Your \nChild',
      'description':
      'The digital world offers endless opportunities but also carries risks. \n\n'
          'Reports indicate 500,000 online predators are active daily, and child sexual abuse reports have surged by 87% since 2019. \n\n'
          'Safeguard your child\'s online experience with Vigil1, the ultimate parental monitoring app.',
    },
    {
      'title': 'Key Features',
      'description': {
        'text': 'With Vigil1, You Can',
        'bulletPoints': [
          'Block harmful apps.',
          'Track time spent on apps and set usage limits.',
          'Keep an eye on their social interactions and activities.',
          'Protect your child from bullies, online predators, and inappropriate content.',
        ],
      },
    },
    {
      'title': 'We Need Your Permission',
      'description':
      'To provide comprehensive protection and monitoring, this app will access certain installed applications on your child’s device. \n\n'
          'By using this application, you give us your permission to access and manage these apps to ensure optimal functionality and security. \n\n'
          'Rest assured, your privacy and data security are our top priorities. \n\n',
    },
    {
      'title': 'User Agreement',
      'description':
      'By continuing to use this app, you agree to abide by our User Agreement, Privacy Policy, and Terms and Conditions. \n\n'
          'These documents outline your rights and responsibilities, as well as how we collect, use, and protect your information. \n\n'
          'Take a moment to review these policies to ensure you understand and agree with them.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0F7FA), // Light cyan color
              Color(0xFFFFFFFF), // White color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: Column(
            children: [
              SizedBox(height: 52),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Skip action
                  },
                  child: Text('Skip',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500
                    ),),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 7,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _carouselItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _carouselItems[index]['title']!,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDescription(_carouselItems[index]['description']),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _carouselItems.length,
                      (index) => buildDot(index, context),
                ),
              ),
              Spacer(flex: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black, padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Set text color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6), // Set border radius
                      ),
                      fixedSize: Size(0, 48), // Set height to 48px, width will be dynamic (hug the content)
                      elevation: 0, // Remove button shadow
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registration');
                    },
                    child: Text('Sign up',
                        style:
                        TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(dynamic description) {
    if (description is String) {
      return Text(
        description,
        style: TextStyle(
          fontSize: 16,
        ),
      );
    } else if (description is Map<String, dynamic>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description['text']!,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: description['bulletPoints'].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.black),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      return Container(); // return an empty container if the description is not in a recognized format
    }
  }

  Widget buildDot(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        height: 12,
        width: 12,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
