import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importing intl package for date formatting

class AppUsagePage extends StatefulWidget {
  @override
  _AppUsagePageState createState() => _AppUsagePageState();
}

class _AppUsagePageState extends State<AppUsagePage> {
  DateTime selectedDate = DateTime.now(); // To store the currently selected date

  // Simulated app usage data for different dates
  Map<String, List<Map<String, dynamic>>> appUsageData = {
    'Aug 18, 2024': [
      {'appName': 'WhatsApp', 'limit': '3 hrs', 'usage': '2H 15M', 'color': Colors.green, 'icon': 'assets/whatsapp_logo.png'},
      {'appName': 'YouTube', 'limit': '2 hrs', 'usage': '1H 05M', 'color': Colors.red, 'icon': 'assets/youtube_logo.png'},
    ],
    'Aug 19, 2024': [
      {'appName': 'TikTok', 'limit': '2 hrs', 'usage': '0H 45M', 'color': Colors.black, 'icon': 'assets/tiktok_logo.png'},
      {'appName': 'Discord', 'limit': '3 hrs', 'usage': '1H 20M', 'color': Colors.blue, 'icon': 'assets/discord_logo.png'},
    ],
    'Aug 20, 2024': [
      {'appName': 'Instagram', 'limit': '2 hrs', 'usage': '1H 50M', 'color': Colors.purple, 'icon': 'assets/instagram_logo.png'},
      {'appName': 'Call of Duty', 'limit': '2 hrs', 'usage': '1H 05M', 'color': Colors.brown, 'icon': 'assets/cod_logo.png'},
    ],
  };

  // Helper method to get formatted date string for display
  String _getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date); // E.g., "Aug 18, 2024"
  }

  // Helper method to handle scrolling through dates
  List<DateTime> _generateDates(int numberOfDays) {
    return List.generate(
      numberOfDays,
          (index) => DateTime.now().subtract(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateList = _generateDates(7); // Generate the last 7 days for the date scroller
    String formattedDate = _getFormattedDate(selectedDate);
    List<Map<String, dynamic>> currentAppData = appUsageData[formattedDate] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
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
          'Apps Usage',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/appslibrary');
              },
              child: Text(
                'Apps Library',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Selector Tabs with Horizontal Scrolling
              Container(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dateList.length,
                  itemBuilder: (context, index) {
                    DateTime date = dateList[index];
                    String dateString = _getFormattedDate(date);
                    return _buildDateTab(
                      dateString,
                      isActive: date.isAtSameMomentAs(selectedDate),
                      onTap: () {
                        if (date.isBefore(DateTime.now())) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    );
                  },
                ),
              ),

              // Space between Date Picker and Chart
              SizedBox(height: 20),

              // Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 200, // Fixed height for the chart
                  child: _buildLineChart(),
                ),
              ),

              // Space after Chart
              SizedBox(height: 20),

              // List of Apps and Total Apps
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'List of Apps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${currentAppData.length} Apps',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Space after "List of Apps"
              SizedBox(height: 10),

              // Scrollable App Usage List with Divider
              ListView.separated(
                shrinkWrap: true, // Make the ListView shrink to the content size
                physics: NeverScrollableScrollPhysics(), // Prevent the ListView from scrolling
                itemCount: currentAppData.length,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  // Build the app items
                  return _buildAppItem(
                    currentAppData[index]['appName'],
                    currentAppData[index]['limit'],
                    currentAppData[index]['usage'],
                    currentAppData[index]['color'],
                    currentAppData[index]['icon'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build date tabs with an onTap action
  Widget _buildDateTab(String date, {bool isActive = false, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.teal : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(
          date,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Helper method to build the line chart
  Widget _buildLineChart() {
    List<FlSpot> spots = [
      FlSpot(0, 2),
      FlSpot(6, 1.5),
      FlSpot(12, 4),
      FlSpot(18, 1),
      FlSpot(24, 4),
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 24,
        minY: 0,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green, // Use 'color' instead of 'colors'
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.3), // Use 'color' instead of 'colors'
            ),
          ),
        ],
        /* titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              if (value == 0) {
                return '0h';
              } else if (value == 2.5) {
                return '2h';
              } else if (value == 5) {
                return '5h';
              }
              return '';
            },
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              if (value == 0) {
                return '12 AM';
              } else if (value == 6) {
                return '6 AM';
              } else if (value == 12) {
                return '12 PM';
              } else if (value == 18) {
                return '6 PM';
              } else if (value == 24) {
                return '12 AM';
              }
              return '';
            },
          ),
        ), */
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  // Helper method to build each app item row with exact percentage calculation for progress bar
  Widget _buildAppItem(String appName, String appLimit, String appUsage, Color progressColor, String iconPath) {
    final double appLimitMinutes = _convertToMinutes(appLimit);
    final double appUsageMinutes = _convertToMinutes(appUsage);

    final double percentageUsed = appLimitMinutes != 0 ? appUsageMinutes / appLimitMinutes : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Column: App Icon (Original Shape)
          Container(
            width: 48, // Specify a width that fits the design
            height: 48, // Specify a height that fits the design
            child: Image.asset(iconPath), // Display the original app logo without circular cropping
          ),
          SizedBox(width: 16),
          // Second Column: App Limit and Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App limit $appLimit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Stack(
                  children: [
                    // Full bar background
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: progressColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Filled bar based on percentage used
                    FractionallySizedBox(
                      widthFactor: percentageUsed.clamp(0.0, 1.0),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Third Column: App Usage
          Text(
            appUsage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to convert time strings to minutes
  double _convertToMinutes(String timeString) {
    try {
      final parts = timeString.split(' ');
      final double hours = double.parse(parts[0].replaceAll('H', ''));
      final double minutes = parts.length > 1 ? double.parse(parts[1].replaceAll('M', '')) : 0;
      return (hours * 60) + minutes;
    } catch (e) {
      return 0.0; // Return 0.0 if parsing fails
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AppUsagePage(),
  ));
}
