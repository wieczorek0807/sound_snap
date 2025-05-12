import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loggy/loggy.dart';

abstract interface class IAudioPlayerService {
  Future<void> play(String filePath);
  Future<void> pause();
  Future<void> stop();
  Stream<PlayerState> get playerStateStream;
  Stream<Duration?> get positionStream;
  Stream<Duration?> get durationStream;
}

@singleton
class AudioPlayerService with UiLoggy implements IAudioPlayerService {
  final AudioPlayer _audioPlayer;

  AudioPlayerService() : _audioPlayer = AudioPlayer();

  @override
  Future<void> play(String filePath) async {
    try {
      loggy.debug('Setting audio source: $filePath');
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.load();
      loggy.debug('Starting playback');
      await _audioPlayer.play();
      loggy.info('Started playing audio from: $filePath');
    } catch (e, stackTrace) {
      loggy.error('Error playing audio: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      loggy.info('Paused audio playback');
    } catch (e, stackTrace) {
      loggy.error('Error pausing audio: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      loggy.info('Stopped audio playback');
    } catch (e, stackTrace) {
      loggy.error('Error stopping audio: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  @override
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;

  @override
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  @disposeMethod
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
