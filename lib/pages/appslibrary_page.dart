import 'package:flutter/material.dart';

class AppLibraryPage extends StatefulWidget {
  @override
  _AppLibraryPageState createState() => _AppLibraryPageState();
}

class _AppLibraryPageState extends State<AppLibraryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isUnblockedSelected = true; // Controls the state of Blocked/Unblocked toggle
  Map<String, bool> dayToggleStates = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };
  Map<String, Map<String, int>> timeLimitData = {
    "Monday": {"hour": 2, "minute": 20},
    "Tuesday": {"hour": 2, "minute": 20},
    "Wednesday": {"hour": 2, "minute": 20},
    "Thursday": {"hour": 2, "minute": 20},
    "Friday": {"hour": 2, "minute": 20},
    "Saturday": {"hour": 2, "minute": 20},
    "Sunday": {"hour": 2, "minute": 20},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleAllDays(bool isTurnOn) {
    setState(() {
      dayToggleStates.updateAll((key, value) => isTurnOn);
    });
  }

  void updateDayTimeLimit(String day, int hours, int minutes) {
    setState(() {
      timeLimitData[day]!["hour"] = hours;
      timeLimitData[day]!["minute"] = minutes;
    });
  }

  Future<void> editTimeLimitDialog(BuildContext context, String day) async {
    TextEditingController hourController =
    TextEditingController(text: timeLimitData[day]!["hour"].toString());
    TextEditingController minuteController =
    TextEditingController(text: timeLimitData[day]!["minute"].toString());

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Time Limit for $day'),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hourController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Hour'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: minuteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Minute'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                int newHours = int.tryParse(hourController.text) ?? 0;
                int newMinutes = int.tryParse(minuteController.text) ?? 0;
                updateDayTimeLimit(day, newHours, newMinutes);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Apps Library',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Installed Apps'),
                  Tab(text: 'Uninstalled Apps'),
                  Tab(text: 'App Limit'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInstalledAppsTab(),
          _buildUninstalledAppsTab(),
          _buildAppLimitTab(),
        ],
      ),
    );
  }

  Widget _buildInstalledAppsTab() {
    List<Map<String, String>> installedApps = [
      {"name": "WhatsApp", "size": "102 MB", "icon": "assets/whatsapp_logo.png"},
      {"name": "YouTube", "size": "501 MB", "icon": "assets/youtube_logo.png"},
      {"name": "TikTok", "size": "205 MB", "icon": "assets/tiktok_logo.png"},
      {"name": "Discord", "size": "304 MB", "icon": "assets/discord_logo.png"},
      {"name": "Call of Duty", "size": "1.57 GB", "icon": "assets/cod_logo.png"},
      {"name": "Instagram", "size": "458 MB", "icon": "assets/instagram_logo.png"},
      // Add more apps here as needed
    ];

    return ListView.separated(
      itemCount: installedApps.length,
      separatorBuilder: (context, index) => Divider(), // Adds a divider between each app
      itemBuilder: (context, index) {
        final app = installedApps[index];
        return _buildAppRow(
          app['name']!,
          app['size']!,
          app['icon']!,
          '06-20-2024', // Example install date
          '06:24 pm',  // Example install time
        );
      },
    );
  }

  Widget _buildUninstalledAppsTab() {
    List<Map<String, String>> uninstalledApps = [
      {"name": "Whiteout Survival", "size": "102 MB", "icon": "assets/whiteout_survival_logo.png"},
      {"name": "Royal Match", "size": "597 MB", "icon": "assets/royal_match_logo.png"},
      {"name": "Marble Match Origin", "size": "587 MB", "icon": "assets/marble_match_origin_logo.png"},
      // Add more apps here as needed
    ];

    return ListView.separated(
      itemCount: uninstalledApps.length,
      separatorBuilder: (context, index) => Divider(), // Adds a divider between each app
      itemBuilder: (context, index) {
        final app = uninstalledApps[index];
        return _buildAppRow(
          app['name']!,
          app['size']!,
          app['icon']!,
          '06-20-2024', // Example uninstall date
          '06:22 pm',  // Example uninstall time
        );
      },
    );
  }

  Widget _buildAppLimitTab() {
    return ListView(
      children: [
        GestureDetector(
          onTap: () => _showAppLimitModal('WhatsApp'),
          child: _buildAppLimitRow('WhatsApp', 'Mon, Tue, Wed, Thu, Fri', '3 hrs', true, 'assets/whatsapp_logo.png'),
        ),
        Divider(), // Adds a divider between each app
        GestureDetector(
          onTap: () => _showAppLimitModal('YouTube'),
          child: _buildAppLimitRow('YouTube', 'No Limit', 'Unlimited', false, 'assets/youtube_logo.png'),
        ),
        Divider(), // Adds a divider between each app
        GestureDetector(
          onTap: () => _showAppLimitModal('TikTok'),
          child: _buildAppLimitRow('TikTok', 'No Limit', 'Unlimited', false, 'assets/tiktok_logo.png'),
        ),
        Divider(), // Adds a divider between each app
        GestureDetector(
          onTap: () => _showAppLimitModal('Discord'),
          child: _buildAppLimitRow('Discord', 'No Limit', 'Unlimited', false, 'assets/discord_logo.png'),
        ),
      ],
    );
  }

  Widget _buildAppRow(String appName, String appSize, String iconPath, String installDate, String installTime) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
      title: Text(appName),
      subtitle: Row(
        children: [
          Text(
            installDate,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(width: 10),
          Text(
            installTime,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Text(appSize, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAppLimitRow(String appName, String days, String limit, bool isLimitSet, String iconPath) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
      title: Text(appName),
      subtitle: Row(
        children: [
          Text(
            days,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(width: 10),
          Text(
            limit,
            style: TextStyle(fontSize: 12, color: Colors.teal),
          ),
        ],
      ),
      trailing: Switch(
        value: isLimitSet,
        onChanged: (value) {
          setState(() {
            // Add logic to handle limit toggle
          });
        },
      ),
    );
  }

  void _showAppLimitModal(String appName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: _buildAppLimitModalContent(),
            );
          },
        );
      },
    );
  }

  Widget _buildAppLimitModalContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleButtonGroup(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          isUnblockedSelected ? _buildUnblockedData() : _buildBlockedData(),
        ],
      ),
    );
  }

  Widget _buildToggleButtonGroup() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isUnblockedSelected = false;
                toggleAllDays(false); // Turn off all toggles
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: !isUnblockedSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                'Blocked',
                style: TextStyle(
                  color: !isUnblockedSelected ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isUnblockedSelected = true;
                toggleAllDays(true); // Turn on all toggles
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isUnblockedSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                'Unblocked',
                style: TextStyle(
                  color: isUnblockedSelected ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display data when 'Unblocked' is selected
  Widget _buildUnblockedData() {
    return Column(
      children: [
        _buildTimeLimitRow('Monday'),
        _buildTimeLimitRow('Tuesday'),
        _buildTimeLimitRow('Wednesday', isSelected: true),
        _buildTimeLimitRow('Thursday'),
        _buildTimeLimitRow('Friday', isSelected: true),
        _buildTimeLimitRow('Saturday'),
        _buildTimeLimitRow('Sunday'),
      ],
    );
  }

  // Display data when 'Blocked' is selected
  Widget _buildBlockedData() {
    return Column(
      children: [
        _buildBlockedRow('WhatsApp'),
        _buildBlockedRow('YouTube'),
        _buildBlockedRow('TikTok'),
        _buildBlockedRow('Instagram'),
      ],
    );
  }

  // Sample blocked app row
  Widget _buildBlockedRow(String appName) {
    return ListTile(
      title: Text(
        appName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: Icon(Icons.block, color: Colors.red),
    );
  }

  // Time limit rows
  Widget _buildTimeLimitRow(String day, {bool isSelected = false}) {
    return ListTile(
      title: GestureDetector(
        onTap: () => editTimeLimitDialog(context, day),
        child: Text(
          day,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            'Hour ${timeLimitData[day]!["hour"]}',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(width: 10),
          Text(
            'Minutes ${timeLimitData[day]!["minute"]}',
            style: TextStyle(color: Colors.teal),
          ),
        ],
      ),
      trailing: Switch(
        value: dayToggleStates[day]!,
        onChanged: (value) {
          setState(() {
            dayToggleStates[day] = value;
          });
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AppLibraryPage(),
  ));
}
