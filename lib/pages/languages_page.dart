import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late String selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the current selected language from the arguments
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    selectedLanguage = arguments['selectedLanguage'] ?? 'English'; // Default to 'English'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                          Navigator.of(context).pop(selectedLanguage); // Return the selected language
                        },
                      ),
                      Text(
                        'Languages',
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

                // List of languages
                Expanded(
                  child: ListView(
                    children: [
                      _buildLanguageItem('English'),
                      _buildLanguageItem('Spanish'),
                      _buildLanguageItem('French'),
                      _buildLanguageItem('Portuguese'),
                      _buildLanguageItem('German'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String language) {
    return ListTile(
      title: Text(
        language,
        style: TextStyle(
          fontWeight: selectedLanguage == language ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: selectedLanguage == language
          ? Icon(
        Icons.check,
        color: Colors.teal,
      )
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.of(context).pop(selectedLanguage); // Return the selected language to ProfilePage
      },
    );
  }
}
