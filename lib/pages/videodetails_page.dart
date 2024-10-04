import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'videoviewer_page.dart';

class VideoDetailsPage extends StatelessWidget {
  final List<Map<String, String>> videos;

  VideoDetailsPage({required this.videos});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> groupedVideos = {};

    // Group videos by date and location
    for (var video in videos) {
      final key = '${video['date']} ${video['location']}';
      if (!groupedVideos.containsKey(key)) {
        groupedVideos[key] = [];
      }
      groupedVideos[key]?.add(video);
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
          'Videos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: groupedVideos.entries.map((entry) {
            final dateLocation = entry.key.split(' ');
            final date = dateLocation[0];
            final location = dateLocation.sublist(1).join(' ');
            final videos = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
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
                _buildVideoRow(videos, context),
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

  Widget _buildVideoRow(List<Map<String, String>> videos, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: videos.map((video) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoViewerPage(
                  videos: videos,
                  initialIndex: videos.indexOf(video),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FutureBuilder<Uint8List?>(
              future: _getVideoThumbnail(video['imagePath']!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Stack(
                      children: [
                        Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: (MediaQuery.of(context).size.width - 60) / 4,
                          height: (MediaQuery.of(context).size.width - 60) / 4,
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      color: Colors.black,
                      width: (MediaQuery.of(context).size.width - 60) / 4,
                      height: (MediaQuery.of(context).size.width - 60) / 4,
                      child: Center(
                        child: Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
                      ),
                    );
                  }
                } else {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 60) / 4,
                    height: (MediaQuery.of(context).size.width - 60) / 4,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<Uint8List?> _getVideoThumbnail(String videoUrl) async {
    return await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, 0 for same width as the original
      quality: 75,
    );
  }
}
