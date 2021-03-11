import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pref/pref.dart';
import 'package:soundpool/soundpool.dart';

// ignore: avoid_classes_with_only_static_members
class SoundHelper {
  static final Soundpool _soundpool =
      Soundpool(streamType: StreamType.notification);
  static int? _beepId;
  static bool useSound = false;
  static bool playTicks = false;

  static Future<void> loadSounds(BuildContext context) async {
    _beepId = await _loadSound();
    useSound = PrefService.of(context).get('sound') == 'beep';
    playTicks = PrefService.of(context).get('ticks');
  }

  static Future<int> _loadSound() async {
    var asset = await rootBundle.load('assets/beep.wav');
    return await _soundpool.load(asset);
  }

  static void playBeepLow() {
    if (useSound) _soundpool.play(_beepId);
  }

  static void playBeepHigh() {
    if (useSound) _soundpool.play(_beepId, rate: 1.5);
  }

  static void playBeepTick() {
    if (playTicks) _soundpool.play(_beepId, rate: 2);
  }

  static void playDouble() {
    if (useSound) {
      _soundpool.play(_beepId);
      Future.delayed(Duration(milliseconds: 200))
          .then((value) => _soundpool.play(_beepId));
    }
  }
}
