import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pref/pref.dart';

// ignore: avoid_classes_with_only_static_members
/// handles everything related to TTS
class TTSHelper {
  static FlutterTts flutterTts = FlutterTts();

  static List<String> languages = List.empty();

  static bool available = true;

  /// enable/disable TTS output
  static bool useTTS = true;

  static Future<void> init(BuildContext context) async {
    flutterTts = FlutterTts();

    useTTS = PrefService.of(context).get('sound') == 'tts';

    var ttsLang = PrefService.of(context).get('tts_lang');
    if (ttsLang.endsWith('*')) ttsLang = ttsLang.replaceAll('*', '');
    PrefService.of(context).set('tts_lang', ttsLang);

    try {
      await flutterTts
          .setLanguage(ttsLang)
          .timeout(Duration(seconds: 1))
          .then((_) async {
        await flutterTts.setSpeechRate(1.0);
        await flutterTts.setVolume(1.0);
        await flutterTts.setPitch(1.0);

        languages = List<String>.from(await flutterTts.getLanguages);
        languages.sort();
        languages.remove('de-DE');
        languages.remove('en-US');
        languages.insertAll(0, ['en-US', 'de-DE']);
      });
    } on TimeoutException {
      available = false;
      useTTS = false;
      PrefService.of(context).set('sound', 'beep');
      return;
    }
  }

  static void speak(String text) async {
    if (!useTTS) return;
    await flutterTts.speak(text);
  }
}
