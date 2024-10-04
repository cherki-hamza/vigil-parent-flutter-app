import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildNotificationSection('Today', 'June 19, 2024', [
            _buildNotificationItem('Pat Matson', 'Commented on your post recently.', '1 hour ago', 'assets/logo.png'),
            _buildNotificationItem('Jake Tylor', 'Commented on your post recently.', '1 hour ago', 'assets/logo.png'),
            _buildNotificationItem('Mathew', 'Commented on your post recently.', '2 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Cate Elison', 'Commented on your post recently.', '3 hours ago', 'assets/logo.png'),
          ]),
          SizedBox(height: 16),
          _buildNotificationSection('Yesterday', 'June 18, 2024', [
            _buildNotificationItem('Pat Matson', 'Commented on your post recently.', '17 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Jake Tylor', 'Commented on your post recently.', '20 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Mathew', 'Commented on your post recently.', '21 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Cate Elison', 'Commented on your post recently.', '22 hours ago', 'assets/logo.png'),
          ]),
          SizedBox(height: 16),
          _buildNotificationSection('2 Days Ago', 'June 17, 2024', [
            _buildNotificationItem('Pat Matson', 'Commented on your post recently.', '17 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Jake Tylor', 'Commented on your post recently.', '20 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Mathew', 'Commented on your post recently.', '21 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Cate Elison', 'Commented on your post recently.', '22 hours ago', 'assets/logo.png'),
          ]),
          SizedBox(height: 16),
          _buildNotificationSection('3 Days Ago', 'June 16, 2024', [
            _buildNotificationItem('Pat Matson', 'Commented on your post recently.', '17 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Jake Tylor', 'Commented on your post recently.', '20 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Mathew', 'Commented on your post recently.', '21 hours ago', 'assets/logo.png'),
            _buildNotificationItem('Cate Elison', 'Commented on your post recently.', '22 hours ago', 'assets/logo.png'),
          ]),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(String title, String date, List<Widget> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.0), // Adjust padding as needed
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent.withOpacity(0.1), // Background color for the Row
            borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners for the Row
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Column(children: notifications),
      ],
    );

  }

  Widget _buildNotificationItem(String name, String message, String timeAgo, String profileImagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(profileImagePath), // Profile image
            backgroundColor: Colors.grey.shade200,
            child: Text(
              name.substring(0, 2).toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' $message',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Handle open post action
            },
            child: Row(
              children: [
                Text(
                  'Open post',
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
                SizedBox(width: 4),
                Image.asset('assets/arrow.png', width: 14, height: 14,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
