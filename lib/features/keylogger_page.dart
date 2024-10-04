import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KeyloggerPage extends StatefulWidget {
  @override
  _KeyloggerPageState createState() => _KeyloggerPageState();
}

class _KeyloggerPageState extends State<KeyloggerPage> {
  DateTime selectedDate = DateTime.now();
  bool isSearching = false;
  String searchQuery = '';

  // Mock data for apps and searches
  final List<Map<String, dynamic>> appData = [
    {
      "appName": "YouTube",
      "logo": "assets/youtube_logo.png",
      "searches": 2,
      "details": [
        {"keyword": "How to bake a cake", "time": "5:45 pm", "date": "06-25-2024"},
        {"keyword": "Ali's birthday party", "time": "3:22 pm", "date": "06-25-2024"},
      ]
    },
    {
      "appName": "TikTok",
      "logo": "assets/tiktok_logo.png",
      "searches": 2,
      "details": [
        {"keyword": "Top 10 dances", "time": "4:10 pm", "date": "06-25-2024"},
        {"keyword": "Funny cat videos", "time": "2:45 pm", "date": "06-25-2024"},
      ]
    },
    {
      "appName": "Discord",
      "logo": "assets/discord_logo.png",
      "searches": 2,
      "details": [
        {"keyword": "Gaming sessions", "time": "3:30 pm", "date": "06-25-2024"},
        {"keyword": "Find Discord servers", "time": "1:10 pm", "date": "06-25-2024"},
      ]
    },
    {
      "appName": "Instagram",
      "logo": "assets/instagram_logo.png",
      "searches": 5,
      "details": [
        {"keyword": "How does the first kiss feel like", "time": "5:45 pm", "date": "06-25-2024"},
        {"keyword": "Ali's birthday party is tomorrow", "time": "3:22 pm", "date": "06-25-2024"},
        {"keyword": "Call of duty cheat codes", "time": "3:05 pm", "date": "06-25-2024"},
        {"keyword": "App to help with math homework", "time": "2:10 pm", "date": "06-25-2024"},
        {"keyword": "Top viral influencers in 2024", "time": "12:42 pm", "date": "06-25-2024"},
      ]
    },
  ];

  List<Map<String, dynamic>> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: isSearching
            ? TextField(
          decoration: InputDecoration(
            hintText: "Enter keywords to find what you're looking for",
            border: InputBorder.none,
          ),
          onChanged: (query) {
            _searchData(query);
          },
        )
            : Text(
          'Keylogger',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!isSearching)
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  isSearching = true;
                  searchResults.clear();
                });
              },
            ),
          if (isSearching)
            TextButton(
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchQuery = '';
                  searchResults.clear(); // Reset search results
                });
              },
              child: Text('Done', style: TextStyle(color: Colors.black)),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Divider(color: Colors.grey.shade300),
          Expanded(
            child: isSearching && searchResults.isNotEmpty
                ? _buildSearchResults()
                : _buildAppList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  DateFormat('MMMM dd, yyyy').format(selectedDate),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppList() {
    return ListView.builder(
      itemCount: appData.length,
      itemBuilder: (context, index) {
        final app = appData[index];

        return Column(
          children: [
            ListTile(
              leading: Image.asset(
                app['logo'],
                width: 40,
                height: 40,
              ),
              title: Text(app['appName']),
              subtitle: Text('${app['searches']} Searches',
                  style: TextStyle(color: Colors.teal)),
              onTap: () {
                _showAppDetails(app);
              },
            ),
            Divider(color: Colors.grey.shade300),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];

        return Column(
          children: [
            ListTile(
              leading: Image.asset(
                result['logo'],
                width: 40,
                height: 40,
              ),
              title: Text(result['keyword']),
              subtitle: Text(result['appName']),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(result['time'], style: TextStyle(color: Colors.teal)),
                  Text(result['date'], style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  void _showAppDetails(Map<String, dynamic> app) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${app['appName']} Searches',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: app['details'].length,
                  itemBuilder: (context, index) {
                    final detail = app['details'][index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(detail['keyword']),
                          subtitle: Text(app['appName']),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(detail['time'],
                                  style: TextStyle(color: Colors.teal)),
                              Text(detail['date'],
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchData(String query) {
    List<Map<String, dynamic>> tempResults = [];

    for (var app in appData) {
      for (var detail in app['details']) {
        if (detail['keyword'].toLowerCase().contains(query.toLowerCase())) {
          tempResults.add({
            "appName": app['appName'],
            "logo": app['logo'],
            "keyword": detail['keyword'],
            "time": detail['time'],
            "date": detail['date'],
          });
        }
      }
    }

    setState(() {
      searchResults = tempResults;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
