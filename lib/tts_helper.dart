import 'package:flutter_tts/flutter_tts.dart';
import 'package:preferences/preference_service.dart';

// ignore: avoid_classes_with_only_static_members
/// handles everything related to TTS
class TTSHelper {
  static FlutterTts flutterTts = FlutterTts();

  static List<String> languages = List.empty();

  /// enable/disable TTS output
  static bool useTTS = true;

  static Future<void> init() async {
    flutterTts = FlutterTts();

    useTTS = PrefService.getString('sound') == 'tts';
    await flutterTts.setLanguage(PrefService.getString('tts_lang'));
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    languages = List<String>.from(await flutterTts.getLanguages);
    languages.sort();
    languages.remove('de-DE');
    languages.remove('en-US');
    languages.insertAll(0, ['en-US', 'de-DE']);
    languages = await Future.wait(languages.map((e) async =>
        '$e${await flutterTts.isLanguageInstalled(e) ? '' : '*'}'));
  }

  static void speak(String text) async {
    if (!useTTS) return;
    await flutterTts.speak(text);
  }
}
