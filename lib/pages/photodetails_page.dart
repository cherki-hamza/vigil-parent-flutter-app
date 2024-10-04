import 'package:flutter/material.dart';
import 'package:vigil_parents_app/pages/imageviewerpage.dart';

class PhotoDetailsPage extends StatelessWidget {
  final List<Map<String, String>> photos;

  PhotoDetailsPage({required this.photos});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> groupedPhotos = {};

    // Group photos by date and location
    for (var photo in photos) {
      final key = '${photo['date']} ${photo['location']}';
      if (!groupedPhotos.containsKey(key)) {
        groupedPhotos[key] = [];
      }
      groupedPhotos[key]?.add(photo);
    }

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
          'Photos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: groupedPhotos.entries.map((entry) {
            final dateLocation = entry.key.split(' ');
            final date = dateLocation[0];
            final location = dateLocation.sublist(1).join(' ');
            final photos = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date == DateTime.now()
                      .subtract(Duration(days: 1))
                      .toString()
                      .split(' ')[0]
                      ? 'Yesterday'
                      : _formatDate(date),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                _buildPhotoRow(photos, context),
                SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day} ${_monthToString(parsedDate.month)} ${parsedDate.year}';
  }

  String _monthToString(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  Widget _buildPhotoRow(List<Map<String, String>> photos, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: photos.map((photo) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewerPage(
                  images: photos,
                  initialIndex: photos.indexOf(photo),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              photo['imagePath']!,
              width: (MediaQuery.of(context).size.width - 60) / 4,
              height: (MediaQuery.of(context).size.width - 60) / 4,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
