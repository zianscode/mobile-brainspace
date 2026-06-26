import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal();

  final List<AudioPlayer> _correctPool = List.generate(3, (_) => AudioPlayer());
  final List<AudioPlayer> _incorrectPool = List.generate(3, (_) => AudioPlayer());
  
  int _correctIdx = 0;
  int _incorrectIdx = 0;
  
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  /// Pre-loads sources into players to ensure ultra-low latency playback.
  Future<void> init() async {
    try {
      for (final player in _correctPool) {
        await player.setSource(AssetSource('audio/correct.wav'));
        player.setPlayerMode(PlayerMode.lowLatency);
      }
      for (final player in _incorrectPool) {
        await player.setSource(AssetSource('audio/incorrect.wav'));
        player.setPlayerMode(PlayerMode.lowLatency);
      }
    } catch (e) {
      // Suppress logs if platform audio drivers fail to init in tests/emulator
      debugPrint("AudioService initialization warning: $e");
    }
  }

  /// Toggles the mute state and returns the new state.
  bool toggleMute() {
    _isMuted = !_isMuted;
    return _isMuted;
  }

  /// Explicitly sets the mute state.
  void setMute(bool mute) {
    _isMuted = mute;
  }

  /// Plays the correct answer 'ding' sound instantly.
  Future<void> playCorrect() async {
    if (_isMuted) return;
    try {
      final player = _correctPool[_correctIdx];
      _correctIdx = (_correctIdx + 1) % _correctPool.length;
      await player.stop();
      await player.play(AssetSource('audio/correct.wav'), mode: PlayerMode.lowLatency);
    } catch (e) {
      debugPrint("Error playing correct sound: $e");
    }
  }

  /// Plays the incorrect answer 'buzz' sound instantly.
  Future<void> playIncorrect() async {
    if (_isMuted) return;
    try {
      final player = _incorrectPool[_incorrectIdx];
      _incorrectIdx = (_incorrectIdx + 1) % _incorrectPool.length;
      await player.stop();
      await player.play(AssetSource('audio/incorrect.wav'), mode: PlayerMode.lowLatency);
    } catch (e) {
      debugPrint("Error playing incorrect sound: $e");
    }
  }
}
