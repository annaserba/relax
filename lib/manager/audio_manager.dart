import 'dart:io';

import 'package:audioplayers/audio_cache.dart'  show AudioCache;
import 'package:audioplayers/audioplayers.dart'  show AudioPlayer;
import 'package:relax/config/constants.dart';
import 'package:relax/model/sound.dart';

class AudioManager {
  late Map<String, AudioPlayer> playing;

  factory AudioManager() => _getInstance();

  static AudioManager get instance => _getInstance();
  static AudioManager _instance = new AudioManager._internal();

  static AudioManager _getInstance() {
    return _instance;
  }

  AudioManager._internal() {
    playing = Map();
    //AudioPlayer.logEnabled = true;
  }

  play(Sound sound) async {
    if (!playing.containsKey(sound.id)) {
      AudioCache player = AudioCache();
      if (Platform.isIOS) {
        if (player.fixedPlayer != null) {
          player.fixedPlayer!.startHeadlessService();
        }
      }
      playing[sound.id] = await player.loop(sound.audio, volume: sound.volume);
    }
    playing[sound.id]!.setVolume(sound.volume / Constants.maxSliderValue); // volume applies between 0 and 1
    playing[sound.id]!.resume();
  }

  stop(Sound sound) async {
    if (playing.containsKey(sound.id)) {
      await playing[sound.id]!.stop();
    }
  }
}
