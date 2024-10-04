import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigil_parents_app/pages/otp_generated.dart';
import 'package:vigil_parents_app/environment.dart';

class ManageDevicesPage extends StatefulWidget {
  @override
  _ManageDevicesPageState createState() => _ManageDevicesPageState();
}

class _ManageDevicesPageState extends State<ManageDevicesPage> {
  List devices = [];
  bool isLoading = true;
  late String token;
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    token = arguments['token'];
    email = arguments['email'];
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    setState(() {
      isLoading = true;
    });

    final url = '${Environment.apiBaseUrl}/api/children/children-by-email';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        devices = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error
      print('Failed to fetch devices');
    }
  }

  Future<void> _generatePairingCode(BuildContext context) async {
    final url = '${Environment.apiBaseUrl}/api/children/generate-pairing-code';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final pairingCode = responseBody['code'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LinkDevicePage(pairingCode: pairingCode),
        ),
      );
    } else {
      // Handle error
      print('Failed to generate pairing code');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _unpairDevice(String childId) async {
    final url = '${Environment.apiBaseUrl}/api/children/$childId';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        devices.removeWhere((device) => device['_id'] == childId);
      });
      print('Device unpaired successfully');
    } else {
      print('Failed to unpair device');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove the shadow/elevation
        centerTitle: true, // Center the title
        title: Text(
          'Manage Devices',
          style: TextStyle(color: Colors.black), // Set the title color to black
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set the icon color to black
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/homeicon.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/dashboard_home',
                arguments: {'email': email, 'token': token},
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchDevices, // Call the refresh function
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Call the logout function
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDevices, // Call the refresh function
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // The Card widget for email confirmation has been removed
              SizedBox(height: 18), // Adjust spacing if necessary
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return DeviceItem(
                      deviceName: device['deviceName'],
                      childName: device['name'],
                      actionLabel: 'Unpair',
                      onActionPressed: () =>
                          _unpairDevice(device['_id']), // Unpair the device
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _generatePairingCode(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add New Device',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Increase the vertical padding
                  minimumSize: Size(double.infinity, 56), // Increase the minimum height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DeviceItem extends StatelessWidget {
  final String deviceName;
  final String childName;
  final String actionLabel;
  final VoidCallback onActionPressed;

  DeviceItem({
    required this.deviceName,
    required this.childName,
    required this.actionLabel,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Image.asset('assets/paired-devices.png'),
        title: Text(
          childName,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          deviceName,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: TextButton(
          onPressed: onActionPressed,
          child: Text(
            actionLabel,
            style: TextStyle(color: Colors.black),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, minimumSize: Size(88, 36), // This makes the button height 36px
            padding: EdgeInsets.symmetric(horizontal: 30),
            side: BorderSide(color: Color(0xFF15BEB5)), // Border color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
