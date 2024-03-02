import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Text to Speech'),
          centerTitle: true,
        ),
        body: const TextToSpeech(),
      ),
    );
  }
}

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TextToSpeechState createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setPitch(1);
  }

  Future<void> speak(String text) async {
    setState(() {
      isSpeaking = true;
    });
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = false;
    });
  }

  Future<void> stop() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  Future<void> pause() async {
    await flutterTts.pause();
    setState(() {
      isSpeaking = false;
    });
  }

  Future<void> resume(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  Future<void> setLanguage(String languageCode) async {
    await flutterTts.setLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter text to speak',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed:
                    isSpeaking ? null : () => speak(textEditingController.text),
                child: const Text('Speak'),
              ),
              ElevatedButton(
                onPressed: isSpeaking ? () => stop() : null,
                child: const Text('Stop'),
              ),
              ElevatedButton(
                onPressed: isSpeaking ? () => pause() : null,
                child: const Text('Pause'),
              ),
              ElevatedButton(
                onPressed: isSpeaking
                    ? () => resume(textEditingController.text)
                    : null,
                child: const Text('Resume'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: 'en-IN',
            onChanged: (value) {
              setLanguage(value!);
            },
            items: <String>['en-IN', 'en-US', 'es-ES', 'fr-FR']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
