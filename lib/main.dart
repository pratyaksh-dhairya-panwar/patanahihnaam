import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(background: Colors.black87)
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    pratu=_text;
    _speech = stt.SpeechToText();
    // Create and store the VideoPlayerController for the asset video.
    _controller = VideoPlayerController.asset('assets/Home.mp4');


    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }
    final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech=stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking',pratu="";
  double _confidence = 1.0;

  @override
  bool Speech=true;
  @override
  Widget build(BuildContext context) {
    if(_text!=""&&pratu!=""){
    _controller.addListener(() {
      if(pratu=="")pratu=_text.replaceAll(" ", "");
      if (_controller.value.isCompleted) {
        _controller.dispose();
        _controller=VideoPlayerController.asset("assets/"+pratu[0].toUpperCase()+".mp4");
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(false);
        setState(() {
          _controller.play();
          // String s=_text.replaceAll(" ","");
          pratu=pratu.replaceAll(" ", "").substring(1);
        });
      }
    });}
    if(Speech){
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      // ),
      appBar: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: (){
            setState(() {
              _isListening=!_isListening;
            });
            _listen();
          },
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          color: Colors.black87,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
            child: Column(
              children: [
                Switch(
                  value: Speech,
                  onChanged: (bool newValue) {
                    setState(() {
                      Speech = newValue;
                    });
                  },
                )
                ,
                SingleChildScrollView(
                  reverse: true,

                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                    // child: Transform(
                    //   transform: Matrix4.rotationY(3.14159),alignment:Alignment.center,
                      child: TextHighlight(
                        text: _text,
                        words: _highlights,
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );}
    else{
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        // ),
        appBar: null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: (){
              setState(() {
                _isListening=!_isListening;
                if(!Speech)_controller.play();
                else _controller.pause();
              });
              _listen();
            },
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
            child: Container(
              child: Column(
                children: [
                  Switch(
                    value: Speech,
                    onChanged: (bool newValue) {
                      setState(() {
                        Speech = newValue;
                      });
                    },
                  )
                  ,
                  Container(constraints: BoxConstraints(
                    maxHeight: 300
                  ) ,child: VideoPlayer(_controller)),
                  SingleChildScrollView(
                    reverse: true,

                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                      // child: Transform(
                      //   transform: Matrix4.rotationY(3.14159),alignment:Alignment.center,
                      child: TextHighlight(
                        text: _text,
                        words: _highlights,
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void _listen() async {
    if (_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => {if(val.startsWith("done")){
          _listen()}},
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _speech.listen(
          onResult: (val) => setState(() {
            _text= val.recognizedWords;
          }),
        );
      }

    }
    else{
      _speech.stop();
    }
  }
}
