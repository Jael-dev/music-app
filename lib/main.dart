import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioCache audioCache;
  Duration _durationM = new Duration();
  Duration _positionM = new Duration();
  bool isPlaying = false;
  String currentTime = "00:00";
  String completeTime = "00:00";
  String DurMaxMus = "00:00:00";
  String DurActiveMus = "00:00:00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
      });
    });
    audioCache = new AudioCache(fixedPlayer: _audioPlayer);
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
    initPlayer();
  }

  void initPlayer() {
    _audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: _audioPlayer);

    _audioPlayer.durationHandler = (d) => setState(() {
          _durationM = d;

          var MaxM = Duration(seconds: _durationM.inSeconds.toInt());
          DurMaxMus = _printDuration(MaxM);
        });

    _audioPlayer.positionHandler = (p) => setState(() {
          _positionM = p;

          var ActiveM = Duration(seconds: _positionM.inSeconds.toInt());
          DurActiveMus = _printDuration(ActiveM);
        });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    double len = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              height: len * 0.95,
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.black87,
              ),
              child: Image.asset(
                "assets/12.jpg",
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.blue.withOpacity(0.85),
                    Colors.blue.withOpacity(0.8),
                    Colors.blue.withOpacity(0.7),
                    Colors.blue.withOpacity(0.6),
                    Colors.blue.withOpacity(0.5),
                    Colors.blue.withOpacity(0.4),
                    Colors.blue.withOpacity(0.1),
                    Colors.blue.withOpacity(0.05),
                    Colors.blue.withOpacity(0.025),
                  ])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  Text(
                    "Hello You",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: len * 0.27,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.7,
              left: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(50)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "$DurActiveMus",
                      style: TextStyle(fontSize: len * 0.013),
                    ),
                    Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.white70,
                        value: _positionM.inSeconds.toDouble(),
                        min: 0.0,
                        max: _durationM.inSeconds.toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            seekToSecond(value.toInt());
                            value = value;
                          });
                        }),
                    Text(
                      "$DurMaxMus",
                      style: TextStyle(fontSize: len * 0.013),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          _audioPlayer.pause();

                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          _audioPlayer.resume();

                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.stop,
                      ),
                      onPressed: () {
                        _audioPlayer.stop();

                        setState(() {
                          isPlaying = false;
                        });
                      },
                    ),
                    Text(
                      "$DurActiveMus",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      " | ",
                    ),
                    Text(
                      "$DurMaxMus",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.audiotrack),
        onPressed: () async {
          String filePath = await FilePicker.getFilePath();

          int status = await _audioPlayer.play(filePath, isLocal: true);

          if (status == 1) {
            setState(() {
              isPlaying = true;
            });
          }
        },
      ),
    );
  }
}
