
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';
import 'package:translator/translator.dart';
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
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  GoogleTranslator translator = GoogleTranslator();
  String language="English";
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();
    _controller=null;
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
  String _text = 'Please start',written_text="Please start";


  void setUpListener(String a){
    if(Speech)return;
    print(a);
    a=a.replaceAll(" ", "");
    _controller?.dispose();
    if(a.length==0)a=_text;
    if(a.length>0){
      _controller=VideoPlayerController.asset("assets/"+a[0].toUpperCase()+".mp4");
      _initializeVideoPlayerFuture = _controller?.initialize() ?? Future.value();
      _controller?.setLooping(false);
      _controller?.addListener(() {
        if (_controller == null || (_controller?.value.isCompleted ?? true)) {
          setState(() {
            setUpListener(a.substring(1));
          });
        }
       });
      _controller?.play();
    }
    else{
      _controller=null;
    }
  }
  bool Speech=true;
  @override
  Widget build(BuildContext context) {
    List<String> items = ["English", "Hindi","Arabic"];
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
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: Speech,
                        onChanged: (bool newValue) {
                          setState(() {
                            Speech = newValue;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: language,
                        onChanged: (newValue) {
                          setState(() {
                            language = newValue!;
                          });
                          _translate(_text);
                        },
                        items: items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Colors.black,
                      ),
                    ],
                  ),
                )
                ,
                SingleChildScrollView(
                  reverse: true,

                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                    // child: Transform(
                    //   transform: Matrix4.rotationY(3.14159),alignment:Alignment.center,
                      child: TextHighlight(
                        text: written_text,
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
                if(!Speech&&_isListening) {
                  setUpListener(_text);
                } else{ _controller?.pause();
              }});
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
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: Speech,
                          onChanged: (bool newValue) {
                            setState(() {
                              Speech = newValue;
                            });
                          },
                        ),
                        DropdownButton<String>(
                          value: language,
                          onChanged: (newValue) {
                            setState(() {
                              language = newValue!;
                              _translate(_text);
                            });
                          },
                          items: items.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: TextStyle(color: Colors.white),
                          dropdownColor: Colors.black,
                        ),
                      ],
                    ),
                  )
                  ,
                  Container(constraints: BoxConstraints(
                    maxHeight: 300
                  ) ,child: _controller != null ? VideoPlayer(_controller!) : Container()),
                  SingleChildScrollView(
                    reverse: true,

                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                      // child: Transform(
                      //   transform: Matrix4.rotationY(3.14159),alignment:Alignment.center,
                      child: TextHighlight(
                        text: written_text,
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
            if(_controller==null){
              setUpListener(_text);
            }
            _translate(_text);
          }),
        );
      }

    }
    else{
      _speech.stop();
    }
  }
  Future<void> _translate(String textToTranslate) async {
    try {
      if(language=="en")return;
      Map<String,String> mp={"English":'en',"Hindi":'hi',"Arabic":"ar"};
      Translation translation =
      await translator.translate(textToTranslate, from: 'en', to: mp[language]!);
      setState(() {
        written_text = translation.text;
      });
    } catch (e) {
      print('Translation error: $e');
    }
  }
}
