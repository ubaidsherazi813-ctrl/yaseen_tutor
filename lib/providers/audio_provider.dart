import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Offline audio: har ayat ki mp3 `assets/audio/ayat_001.mp3` ... se chalti hai.
class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  int? current; // jo ayat chal rahi hai
  bool playing = false;
  bool autoNext = true;
  double speed = 1.0;
  int total = 0;
  String? error;

  AudioProvider() {
    _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        playing = false;
        notifyListeners();
        _onFinished();
      } else {
        playing = s.playing;
        notifyListeners();
      }
    });
  }

  Future<void> play(int ayatId, {int? totalAyaat}) async {
    if (totalAyaat != null) total = totalAyaat;
    current = ayatId;
    error = null;
    notifyListeners();
    try {
      final name = 'ayat_${ayatId.toString().padLeft(3, '0')}.mp3';
      await _player.setAsset('assets/audio/$name');
      await _player.setSpeed(speed);
      _player.play();
    } catch (e) {
      playing = false;
      error = 'Audio file nahi mili (ayat_${ayatId.toString().padLeft(3, '0')}.mp3)';
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    if (current == null) return;
    if (_player.playing) {
      await _player.pause();
    } else {
      _player.play();
    }
  }

  Future<void> next() async {
    if (current != null && current! < total) await play(current! + 1);
  }

  Future<void> previous() async {
    if (current != null && current! > 1) await play(current! - 1);
  }

  Future<void> stop() async {
    await _player.stop();
    current = null;
    playing = false;
    error = null;
    notifyListeners();
  }

  Future<void> setSpeed(double v) async {
    speed = v;
    await _player.setSpeed(v);
    notifyListeners();
  }

  void setAutoNext(bool v) {
    autoNext = v;
    notifyListeners();
  }

  void _onFinished() {
    if (autoNext && current != null && current! < total) {
      play(current! + 1);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
