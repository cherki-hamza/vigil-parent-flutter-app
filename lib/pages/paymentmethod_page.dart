import 'package:flutter/material.dart';
import 'dart:convert';


class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String email = '';
  String token = '';
  int _selectedIndex = 1; // Initially, "Yearly" is selected
  bool _isYearly = true; // True if "Yearly" is selected, false if "Monthly" is selected

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    email = arguments['email'];
    token = arguments['token'];


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.0), // To give space for the status bar
          // Custom Header instead of AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.0), // To balance the back button width
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 50,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Monthly Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      _isYearly = false; // Monthly selected
                    });
                  },
                  child: Container(
                    width: 200, // Adjust width based on design
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: _selectedIndex == 0
                          ? [BoxShadow(color: Colors.transparent, blurRadius: 1.0, spreadRadius: 1.0)]
                          : [],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: _selectedIndex == 0 ? Colors.teal : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Yearly Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _isYearly = true; // Yearly selected
                    });
                  },
                  child: Container(
                    width: 200, // Adjust width based on design
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: _selectedIndex == 1
                          ? [BoxShadow(color: Colors.transparent, blurRadius: 1.0, spreadRadius: 1.0)]
                          : [],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Yearly',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: _selectedIndex == 1 ? Colors.teal : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Number of cards
              itemBuilder: (context, index) {
                return buildPlanCard(
                  index: index, // Pass index to control styling
                  planType: index == 0 ? 'Basic' : index == 1 ? 'Standard' : 'Premium',
                  price: index == 0
                      ? (_isYearly ? '50' : '5') // Example: Yearly price vs Monthly price
                      : index == 1
                      ? (_isYearly ? '100' : '10')
                      : (_isYearly ? '200' : '20'),
                  description: index == 0
                      ? ['App & web dashboard', 'One device', _isYearly ? 'Yearly access' : 'Monthly access']
                      : index == 1
                      ? ['App & web dashboard', 'Up to five devices', _isYearly ? 'Yearly access' : 'Monthly access']
                      : ['App & web dashboard', 'Up to ten devices', _isYearly ? 'Yearly access' : 'Monthly access'],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Auto-Renewal. Cancel Anytime.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanCard({
    required int index, // Add index parameter
    required String planType,
    required String price,
    required List<String> description,
  }) {
    bool isGradientText = planType == 'Basic' || planType == 'Premium';
    bool isSecondCard = index == 1;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: isSecondCard ? Colors.black : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Column: Plan Type and Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isGradientText
                        ? ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF2BA0CC), Color(0xFF15BEB5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        planType,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : Text(
                      planType,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: isSecondCard ? Colors.white : Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '\$$price',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: isSecondCard ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      _isYearly ? 'Per year' : 'Per month',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: isSecondCard ? Colors.grey[300] : Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 24.0),

                // Second Column: Features List
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: description.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: isSecondCard ? Colors.white : Colors.teal,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isSecondCard ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Button as a Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Show bottom sheet with selected plan details
                      _showBottomSheet(planType, price);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.0), backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text(
                      'Get This Plan',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(String planType, String price) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4.0,
                  width: 40.0,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1 Device  -  ${_isYearly ? '1 Year Plan' : '1 Month Plan'} ($planType)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                email,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Starting Today',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    '\$$price.00/ ${_isYearly ? 'Yearly' : 'Monthly'}',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Text(
                'Add a payment method to your account to subscribe. Your payment information will only be visible here.',
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),
              SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addcardpage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    'Add Payment Method',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}
