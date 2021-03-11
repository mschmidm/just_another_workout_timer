import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pref/pref.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';
import 'oss_license_page.dart';
import 'sound_helper.dart';
import 'tts_helper.dart';

/// change some settings of the app and display licenses
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _license = '';

  void _loadLicense() async {
    var lic = await rootBundle.loadString('LICENSE');
    setState(() {
      _license = lic;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadLicense();
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
        ),
        body: PrefPage(
          children: [
            PrefTitle(
              title: Text(S.of(context).general),
            ),
            PrefDropdown(
              title: Text(S.of(context).language),
              items: [
                DropdownMenuItem(
                    child: Text(S.of(context).english), value: 'en'),
                DropdownMenuItem(child: Text(S.of(context).german), value: 'de')
              ],
              onChange: (value) {
                setState(() {
                  S.load(Locale(value.toString()));
                });
              },
              pref: 'lang',
            ),
            PrefSwitch(
              title: Text(S.of(context).keepScreenAwake),
              pref: 'wakelock',
            ),
            PrefSwitch(
                title: Text(S.of(context).settingHalfway), pref: 'halftime'),
            PrefSwitch(
                title: Text(S.of(context).playTickEverySecond), pref: 'ticks'),
            PrefTitle(
              title: Text(S.of(context).soundOutput),
            ),
            PrefRadio(
              title: Text(S.of(context).noSound),
              value: 'none',
              pref: 'sound',
              //desc: S.of(context).noSoundDesc,
              onSelect: () {
                TTSHelper.useTTS = false;
                SoundHelper.useSound = false;
              },
            ),
            PrefRadio(
              title: Text(S.of(context).useTTS),
              value: 'tts',
              pref: 'sound',
              //desc: S.of(context).useTTSDesc,
              disabled: !TTSHelper.available,
              onSelect: () {
                TTSHelper.useTTS = true;
                SoundHelper.useSound = false;
              },
            ),
            PrefRadio(
              title: Text(S.of(context).useSound),
              value: 'beep',
              pref: 'sound',
              //desc: S.of(context).useSoundDesc,
              onSelect: () {
                TTSHelper.useTTS = false;
                SoundHelper.useSound = true;
              },
            ),
            PrefTitle(
              title: Text(S.of(context).tts),
            ),
            PrefDropdown(
              title: Text(S.of(context).ttsLang),
              pref: 'tts_lang',
              //desc: S.of(context).ttsLangDesc,
              items: TTSHelper.languages
                  .map((e) => DropdownMenuItem(
                      child: Text(e.toString()), value: e.toString()))
                  .toList(),
              disabled: !TTSHelper.available,
              onChange: (value) {
                TTSHelper.flutterTts.setLanguage(value.toString());
              },
            ),
            PrefSwitch(
              title: Text(S.of(context).announceUpcomingExercise),
              pref: 'tts_next_announce',
              //desc: S.of(context).AnnounceUpcomingExerciseDesc,
              disabled: !TTSHelper.available,
            ),
            PrefTitle(
              title: Text(S.of(context).licenses),
            ),
            PrefButton(
              child: Text(S.of(context).viewOnGithub),
              subtitle: Text(S.of(context).reportIssuesOrRequestAFeature),
              onTap: () {
                launch(
                    'https://github.com/blockbasti/just_another_workout_timer');
              },
            ),
            PrefButton(
              child: Text(S.of(context).viewLicense),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  S.of(context).title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(_license),
                              )
                            ],
                          ),
                        ));
              },
            ),
            PrefButton(
              child: Text(S.of(context).viewOSSLicenses),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OssLicensesPage(),
                    ));
              },
            )
          ],
        ));
  }
}
