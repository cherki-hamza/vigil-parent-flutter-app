import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:vigil_parents_app/pages/photodetails_page.dart';
import 'package:vigil_parents_app/pages/videodetails_page.dart';

class PhotosAndVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> mediaData = {
      'photos': [
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1437419764061-2473afe69fc2.jpg',
          'date': '2024-08-01',
          'location': 'New York, USA',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1437422061949-f6efbde0a471.jpg',
          'date': '2024-08-01',
          'location': 'New York, USA',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1443890923422-7819ed4101c0.jpg',
          'date': '2024-08-01',
          'location': 'New York, USA',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1446329813274-7c9036bd9a1f.jpg',
          'date': '2024-08-02',
          'location': 'Los Angeles, USA',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1471769321038-24f4db35b24d.jpg',
          'date': '2024-08-02',
          'location': 'Los Angeles, USA',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1421789665209-c9b2a435e3dc.jpg',
          'date': '2024-08-03',
          'location': 'Paris, France',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1484882918957-e9f6567be3c8.jpg',
          'date': '2024-08-03',
          'location': 'Paris, France',
        },
        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1431538510849-b719825bf08b.jpg',
          'date': '2024-08-03',
          'location': 'Paris, France',
        },

        {
          'imagePath': 'https://raw.githubusercontent.com/ServiceStack/images/master/hero/photo-1422360902398-0a91ff2c1a1f.jpg',
          'date': '2024-08-07',
          'location': 'Sydney, Australia',
        },

      ],
      'videos': [
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          'date': '2024-08-03',
          'location': 'Paris, France',
          'title': 'Elephant Dreams'
        },
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          'date': '2024-08-04',
          'location': 'Berlin, Germany',
          'title': 'Big Buck Bunny'
        },
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          'date': '2024-08-04',
          'location': 'Berlin, Germany',
          'title': 'ForBiggerBlazes'

    },
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          'date': '2024-08-05',
          'location': 'Berlin, Germany',
          'title': 'ForBiggerBlazes'
        },
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
          'date': '2024-08-05',
          'location': 'Berlin, Germany',
          'title': 'ForBiggerBlazes'
        },
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
          'date': '2024-08-05',
          'location': 'Berlin, Germany',
          'title': 'ForBiggerBlazes'
        },
        {
          'imagePath': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
          'date': '2024-08-06',
          'location': 'Berlin, Germany',
          'title': 'ForBiggerBlazes'
        },
        // More video data here
      ]
    };

    final int photoCount = mediaData['photos']?.length ?? 0;
    final int videoCount = mediaData['videos']?.length ?? 0;

    // Get the latest 4 unique photos and videos
    final List<Map<String, String>> latestPhotos = mediaData['photos']?.sublist(
      mediaData['photos']!.length > 4 ? mediaData['photos']!.length - 4 : 0,
      mediaData['photos']!.length,
    ).toList().reversed.toList() ?? [];

    final List<Map<String, String>> latestVideos = mediaData['videos']?.sublist(
      mediaData['videos']!.length > 4 ? mediaData['videos']!.length - 4 : 0,
      mediaData['videos']!.length,
    ).toList().reversed.toList() ?? [];

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
          'Photos and Videos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PhotoDetailsPage(photos: mediaData['photos'] ?? []),
                            ),
                          );
                        },
                        child: _buildMediaCard(latestPhotos, false),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Photos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$photoCount',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoDetailsPage(videos: mediaData['videos'] ?? []),
                            ),
                          );
                        },
                        child: _buildMediaCard(latestVideos, true),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Videos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$videoCount',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
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

  Widget _buildMediaCard(List<Map<String, String>> mediaItems, bool isVideo) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: mediaItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final mediaItem = mediaItems[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isVideo
                ? FutureBuilder<Uint8List?>(
              future: _getVideoThumbnail(mediaItem['imagePath']!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Stack(
                      children: [
                        Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
                : Image.network(
              mediaItem['imagePath']!,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
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
