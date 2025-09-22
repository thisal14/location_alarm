import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../models/alarm_settings.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> triggerAlarm(AlarmSettings settings) async {
    if (_isPlaying) return;

    _isPlaying = true;

    // Vibration
    if (settings.isVibrationEnabled) {
      HapticFeedback.vibrate();
    }

    // Sound
    if (settings.isSoundEnabled) {
      try {
        await _audioPlayer.play(AssetSource('sounds/${settings.soundFile}'));
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      } catch (e) {
        print('Error playing alarm sound: $e');
      }
    }
  }

  Future<void> stopAlarm() async {
    _isPlaying = false;
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}