import 'package:flutter/material.dart';
import 'package:vigil_parents_app/features/contact_page.dart';

class ContactDetailsPage extends StatelessWidget {
  final Child contact;

  ContactDetailsPage({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          contact.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Color(int.parse(contact.color.replaceFirst('#', '0xff'))),
                  shape: BoxShape.rectangle, // Changed to square
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    contact.initials,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            buildInfoRow(Icons.phone, 'Phone', contact.phone['work'], contact.phone['home']),
            buildInfoRow(Icons.email, 'Email', contact.email),
            buildInfoRow(Icons.email, 'Whatsapp', contact.whatsapp),
            buildInfoRow(Icons.location_on, 'Address', contact.address),
            buildInfoRow(Icons.web, 'Website', contact.website),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 20), // Increased height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0), // No rounded corners
                  ),
                ),
                onPressed: () {
                  // Block contact action
                },
                child: Text(
                  'Block the contact',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String title, String? data1, [String? data2]) {
    if (data1 == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 4),
                if (data2 != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('(Work) $data1', style: TextStyle(fontSize: 16, color: Colors.black)),
                      Text('(Home) $data2', style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                if (data2 == null)
                  Text(
                    data1,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
