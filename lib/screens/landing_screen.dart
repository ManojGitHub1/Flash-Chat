// ignore_for_file: prefer_const_constructors

import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:flutter/services.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing_screen';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isAudioLoaded = false;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();

    // Hide the status bar and make the app full screen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Make status bar transparent
      systemNavigationBarColor: Colors.transparent,
      // Make navigation bar transparent
      systemNavigationBarDividerColor: Colors.transparent,
      // Make navigation bar divider transparent
      systemNavigationBarIconBrightness: Brightness.light,
      // Change icon brightness to match UI
      statusBarIconBrightness:
          Brightness.light, // Change status bar icon brightness to match UI
    ));


    // Initialize the video controller
    _videoController = VideoPlayerController.asset('assets/GokuRising.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {
          _videoController.play();
          _videoController.setLooping(true);
          _isVideoLoaded = true;
        });
      }).catchError((error) {
        print("Error initializing video: $error");
      });

    // Initialize the audio player
    _audioPlayer = AudioPlayer();
    // _audioPlayer.setLoopMode(LoopMode.one); // Set the audio to loop

    // Load and play audio from URL asynchronously
    _audioPlayer.setUrl('https://www.myinstants.com/media/sounds/miguel-ohara-theme.mp3')
        .then((_) {
      setState(() {
        _isAudioLoaded = true;
        _audioPlayer.play();
      });
    }).catchError((error) {
      print("Error loading audio: $error");
    });

    // PlayAudioThen Video
    // _playVideoThanAudio();
  }

  // void _playVideoThanAudio() async {
  //   // Play audio and video simultaneously
  //   await _audioPlayer.setUrl('https://www.myinstants.com/media/sounds/miguel-ohara-theme.mp3');
  //   _isAudioLoaded = true;
  //   _audioPlayer.play();
  //
  //   // Stop the audio after 10 seconds
  //   await Future.delayed(Duration(seconds: 10));
  //   _audioPlayer.stop();
  // }

  @override
  void dispose() {
    // Restore the status bar when the screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Size? _size;

  @override
  Widget build(BuildContext context) {
    // final padding = MediaQuery.of(context).padding; // Get device padding
    // _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Video Player
          Positioned.fill(
            child: _isVideoLoaded
                ? FittedBox(
                    fit: BoxFit
                        .cover, // Ensures the video covers the whole screen
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator()),
          ),
          // Positioned Button
          Positioned(
            bottom: 30,
            right: 30,
            child: OutlinedButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(BorderSide(color: Colors.white)),
                backgroundColor: WidgetStateProperty.all(Colors.black45),
              ),
              onPressed: () {
                Navigator.pushNamed(context, WelcomeScreen.id);
                _audioPlayer.dispose();
              },
              child: Text('Next', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
