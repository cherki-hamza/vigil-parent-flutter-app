import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPaymentMethodPage extends StatefulWidget {
  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  String? selectedCountry;
  String? selectedState;
  List<String> countries = [];
  List<String> states = [];
  Map<String, List<String>> countryStateMap = {};

  @override
  void initState() {
    super.initState();
    fetchCountriesAndStates();
  }

  Future<void> fetchCountriesAndStates() async {
    final url = Uri.parse('https://countriesnow.space/api/v0.1/countries/states');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final countryList = data['data'];

      Map<String, List<String>> countryStateData = {};
      List<String> countryNames = [];

      for (var country in countryList) {
        countryNames.add(country['name']);
        List<String> stateNames = [];

        for (var state in country['states']) {
          stateNames.add(state['name']);
        }
        countryStateData[country['name']] = stateNames;
      }

      setState(() {
        countries = countryNames;
        countryStateMap = countryStateData;
      });
    } else {
      throw Exception('Failed to load countries and states');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 120.0), // Space for transparent header
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Credit / Debit Card',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Fill all required fields.',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Card Number Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.0),

                        // Cardholder Name Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Cardholder Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Expiration Date and Security Code Fields
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'MM/YY',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Security Code',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),

                        // Street Address Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Street Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Apartment/Suite Field
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Apartment, Suite, etc (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Country Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Country',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedCountry,
                          items: countries.map((String country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                              selectedState = null;
                              states = countryStateMap[selectedCountry] ?? [];
                            });
                          },
                        ),
                        SizedBox(height: 16.0),

                        // State Dropdown, wrapped with Visibility to hide it when no states are available
                        Visibility(
                          visible: states.isNotEmpty,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select State',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedState,
                            items: states.map((String state) {
                              return DropdownMenuItem<String>(
                                value: state,
                                child: Text(state),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedState = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),

                // Save Button and Terms Text at the bottom
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'By continuing, you agree to the terms of the payment service. Our Privacy Notice describes how your data is handled.',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle save action and pass card data
                          Navigator.pop(context, {
                            'cardNumber': '**** **** **** 1234', // Example card data
                            'cardHolder': 'John Doe',
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ],
            ),
          ),

          // Transparent AppBar replacement
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80.0, // Height including status bar
              padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              color: Colors.transparent, // Set the color as transparent
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Add Payment Method',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 48.0), // Placeholder for balancing the row
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
