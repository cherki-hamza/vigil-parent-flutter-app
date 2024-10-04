import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // A map to keep track of which FAQ is expanded
  Map<int, bool> expandedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom transparent App Bar
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Frequently Asked Questions (FAQs)',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 48), // Spacer for aligning text in center
                ],
              ),
            ),
            SizedBox(height: 40),

            // FAQ Accordion List
            Expanded(
              child: ListView(
                children: [
                  _buildExpansionTile(
                      0, 'Is Vigil1 safe to use?', 'Yes, Vigil1 prioritizes your child\'s safety and privacy. We have strong data security measures in place to protect your information. We encourage you to review our detailed privacy policy on our website for further assurance.'),
                  _buildExpansionTile(
                      1, 'Can I install Vigil1 remotely?', 'Currently, remote installation is not available for Vigil1. The Vigil1 Kids app needs to be downloaded onto your child\'s device. Once downloaded, you can easily pair the child\'s app with your parent app.'),
                  _buildExpansionTile(
                      2, 'What devices is Vigil1 compatible with?','Vigil1 is currently compatible with all Android devices.'),
                  _buildExpansionTile(
                      3, 'How many devices can I monitor at the same time?', 'The number of devices you can monitor depends on your subscription plan.'),
                  _buildExpansionTile(
                      4, 'Can my child see that I’m monitoring their activity?', 'No, the Vigil1 child app is designed to be discreet. The app works in the background and will not alert the device. However, we highly recommend open communication and transparency when using any parental monitoring apps.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(int index, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      ],
      initiallyExpanded: expandedItems[index] ?? false,
      onExpansionChanged: (bool expanded) {
        setState(() {
          expandedItems[index] = expanded;
        });
      },
    );
  }
}

