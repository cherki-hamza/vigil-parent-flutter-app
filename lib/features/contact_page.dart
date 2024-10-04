import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vigil_parents_app/pages/contactdetails_page.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Parent> parents = [];

  @override
  void initState() {
    super.initState();
    loadContactsFromJson();
  }

  void loadContactsFromJson() {
    String jsonContacts = '''
    [
      {
        "parentId": 1,
        "children": [
          {
            "childId": 1,
            "name": "McColine Mac",
            "initials": "MM",
            "color": "#008080",
            "phone": {
              "work": "+1 (316) 253-5333",
              "home": "+1 (316) 237-5298"
            },
            "email": "theiremail@nooneknwos.com",
            "whatsapp": "+1 (316) 237-5298",
            "address": "4074 Deans Lane, New York, NY, USA.",
            "website": "thereisnowebsiteavailable.com"
          },
          {
            "childId": 2,
            "name": "Lola",
            "initials": "LC",
            "color": "#D4E157",
            "phone": {
              "work": "+1 (212) 555-1234"
            },
            "email": "lola@example.com",
            "whatsapp": "+1 (212) 555-1234",
            "address": "1234 Main St, Springfield, USA.",
            "website": "lolawebsite.com"
          }
        ]
      },
      {
        "parentId": 2,
        "children": [
          {
            "childId": 3,
            "name": "Killian",
            "initials": "KM",
            "color": "#673AB7",
            "phone": {
              "work": "+1 (718) 555-6789"
            },
            "email": "killian@example.com",
            "whatsapp": "+1 (718) 555-6789",
            "address": "45 Grand Ave, Brooklyn, NY, USA.",
            "website": "killianwebsite.com"
          },
          {
            "childId": 4,
            "name": "Erin",
            "initials": "EL",
            "color": "#2196F3",
            "phone": {
              "home": "+1 (646) 555-9876"
            },
            "email": "erin@example.com",
            "whatsapp": "+1 (646) 555-9876",
            "address": "789 Elm St, Manhattan, NY, USA.",
            "website": "erinwebsite.com"
          }
        ]
      }
    ]
    ''';

    List decodedJson = json.decode(jsonContacts);
    parents = decodedJson.map((json) => Parent.fromJson(json)).toList();
    setState(() {});
  }

  bool isSearching = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final List<Child> filteredContacts = parents
        .expand((parent) => parent.children)
        .where((contact) =>
    searchQuery.isEmpty ||
        contact.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: isSearching
            ? IconButton(
          icon: Icon(Icons.cancel, color: Colors.black),
          onPressed: () {
            setState(() {
              isSearching = false;
              searchQuery = "";
            });
          },
        )
            : IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: isSearching
            ? TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search contacts",
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
        )
            : Text(
          'Contacts',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isSearching)
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          if (isSearching)
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              child: Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = filteredContacts[index];

            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(int.parse(contact.color.replaceFirst('#', '0xff'))),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        contact.initials ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactDetailsPage(contact: contact),
                      ),
                    );
                  },
                ),
                if (index < filteredContacts.length - 1)
                  Divider(color: Colors.grey),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Parent {
  final int parentId;
  final List<Child> children;

  Parent({required this.parentId, required this.children});

  factory Parent.fromJson(Map<String, dynamic> json) {
    var childrenFromJson = json['children'] as List;
    List<Child> childrenList =
    childrenFromJson.map((childJson) => Child.fromJson(childJson)).toList();

    return Parent(parentId: json['parentId'], children: childrenList);
  }
}

class Child {
  final int childId;
  final String name;
  final String initials;
  final String color;
  final Map<String, String> phone;
  final String email;
  final String whatsapp;
  final String address;
  final String website;

  Child({
    required this.childId,
    required this.name,
    required this.initials,
    required this.color,
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.address,
    required this.website,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      childId: json['childId'],
      name: json['name'],
      initials: json['initials'],
      color: json['color'],
      phone: Map<String, String>.from(json['phone']),
      email: json['email'],
      whatsapp: json['whatsapp'],
      address: json['address'],
      website: json['website'],
    );
  }
}
