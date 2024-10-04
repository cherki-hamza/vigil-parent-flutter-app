import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class CallRecordingsPage extends StatefulWidget {
  @override
  _CallRecordingsPageState createState() => _CallRecordingsPageState();
}

class _CallRecordingsPageState extends State<CallRecordingsPage> {
  DateTime selectedDate = DateTime.now();
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  int currentRecordingIndex = 0;

  List<Map<String, dynamic>> recordings = [
    {
      "name": "McColine Mac",
      "time": "06:24 pm",
      "date": "2024-06-20",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },
    {
      "name": "Lola",
      "time": "06:00 pm",
      "date": "2024-06-21",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },
    {
      "name": "Clara",
      "time": "06:00 pm",
      "date": "2024-06-22",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Mana",
      "time": "06:00 pm",
      "date": "2024-06-23",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Arza",
      "time": "06:00 pm",
      "date": "2024-06-23",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Stephen",
      "time": "06:00 pm",
      "date": "2024-06-24",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Raul",
      "time": "06:00 pm",
      "date": "2024-06-25",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Lola",
      "time": "06:00 pm",
      "date": "2024-06-26",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Lola",
      "time": "06:00 pm",
      "date": "2024-06-26",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Lola",
      "time": "06:00 pm",
      "date": "2024-06-27",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },{
      "name": "Lola",
      "time": "06:00 pm",
      "date": "2024-06-27",
      "audioUrl": "https://phpstack-1245064-4836951.cloudwaysapps.com/audio/audio_1.mp3"
    },








    // Add more recordings here...
  ];

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    _audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      _playNext();
    });
  }

  void _playPauseAudio() {
    if (isPlaying) {
      _audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPaused = true;
      });
    } else if (isPaused) {
      _audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
    } else {
      _audioPlayer.play(recordings[currentRecordingIndex]['audioUrl']);
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
    }
  }

  void _playNext() {
    setState(() {
      currentRecordingIndex =
          (currentRecordingIndex + 1) % recordings.length;
      _audioPlayer.play(recordings[currentRecordingIndex]['audioUrl']);
      isPlaying = true;
      isPaused = false;
    });
  }

  void _playPrevious() {
    setState(() {
      currentRecordingIndex =
          (currentRecordingIndex - 1 + recordings.length) %
              recordings.length;
      _audioPlayer.play(recordings[currentRecordingIndex]['audioUrl']);
      isPlaying = true;
      isPaused = false;
    });
  }

  void _showMediaPlayer(int index) {
    currentRecordingIndex = index;
    _playPauseAudio();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _buildMediaPlayer();
      },
    );
  }

  Widget _buildMediaPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slider and time indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(currentPosition)),
                Expanded(
                  child: Slider(
                    value: currentPosition.inSeconds.toDouble().clamp(0, totalDuration.inSeconds.toDouble()),
                    min: 0,
                    max: (totalDuration.inSeconds > 0) ? totalDuration.inSeconds.toDouble() : 1,
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(newPosition);
                    },
                    activeColor: Colors.teal,
                  ),
                ),
                Text(_formatDuration(totalDuration)),
              ],
            ),
            // Media player controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: _playPrevious,
                ),
                FloatingActionButton(
                  onPressed: _playPauseAudio,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.teal,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: _playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Call Recordings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Divider(color: Colors.grey.shade300),
          Expanded(child: _buildRecordingList()),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          _selectDate(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              DateFormat('dd/MM/yyyy').format(selectedDate),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingList() {
    List<Map<String, dynamic>> filteredRecordings = recordings
        .where((recording) =>
    DateTime.parse(recording['date']) == selectedDate)
        .toList();

    return ListView.builder(
      itemCount: filteredRecordings.length,
      itemBuilder: (context, index) {
        final recording = filteredRecordings[index];
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: Icon(
                recording['name'] == "Miss Jones"
                    ? Icons.call_received
                    : Icons.call_made,
                color: Colors.teal,
              ),
              title: Text(recording['name']),
              subtitle: Text(_formatDuration(totalDuration)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recording['time'],
                    style: TextStyle(color: Colors.teal),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.download, color: Colors.black),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.play_arrow, color: Colors.black),
                    onPressed: () {
                      _showMediaPlayer(index);
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
          ],
        );
      },
    );
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
