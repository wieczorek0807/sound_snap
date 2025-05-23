import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/features/audio_player/domain/services/audio_player_service.dart';
import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';
import 'package:sound_snap/features/recording_list/domain/services/recording_list_service.dart';
import 'dart:async';

part 'recording_list_cubit.freezed.dart';
part 'recording_list_state.dart';

@injectable
class RecordingListCubit extends Cubit<RecordingListState> with UiLoggy {
  final RecordingListService _service;
  final AudioPlayerService _audioPlayerService;
  StreamSubscription? _playerStateSubscription;

  RecordingListCubit(this._service, this._audioPlayerService) : super(const RecordingListState.initial()) {
    _setupPlayerStateListener();
  }

  void _setupPlayerStateListener() {
    _playerStateSubscription = _audioPlayerService.playerStateStream.listen((playerState) {
      loggy.debug('Player state changed: ${playerState.processingState}, playing: ${playerState.playing}');
      final currentState = state;
      if (currentState is! RecordingListStateLoaded) return;

      if (playerState.processingState == ProcessingState.completed) {
        loggy.debug('Playback completed, clearing currentlyPlayingId');
        emit(currentState.copyWith(currentlyPlayingId: null));
      }
    });
  }

  Future<void> loadRecordings() async {
    loggy.debug('Loading recordings initiated');
    emit(const RecordingListState.loading());

    final result = await _service.getRecordings();

    result.fold(
      (failure) {
        emit(RecordingListState.error(failure.toString()));
      },
      (recordings) {
        loggy.info('Successfully loaded ${recordings.length} recordings');
        emit(RecordingListState.loaded(recordings: recordings, currentlyPlayingId: null));
      },
    );
  }

  Future<void> togglePlayback(RecordingEntity recording) async {
    try {
      final currentState = state;
      if (currentState is! RecordingListStateLoaded) return;

      if (currentState.currentlyPlayingId == recording.id) {
        loggy.debug('Pausing current recording: ${recording.id}');
        await _audioPlayerService.pause();
        emit(currentState.copyWith(currentlyPlayingId: null));
      } else {
        loggy.debug('Starting playback of recording: ${recording.id}');
        if (currentState.currentlyPlayingId != null) {
          loggy.debug('Stopping current playback before starting new one');
          await _audioPlayerService.stop();
        }

        emit(currentState.copyWith(currentlyPlayingId: recording.id));
        await _audioPlayerService.play(recording.filePath);

        loggy.debug('Playback started for recording: ${recording.id}');
      }
    } catch (e, stackTrace) {
      loggy.error('Error toggling playback: $e', e, stackTrace);
      final currentState = state;
      if (currentState is RecordingListStateLoaded) {
        emit(currentState.copyWith(currentlyPlayingId: null));
      }
      emit(RecordingListState.error('Failed to play recording: ${e.toString()}'));
    }
  }

  Future<void> stopPlayback() async {
    try {
      final currentState = state;
      if (currentState is! RecordingListStateLoaded) return;

      await _audioPlayerService.stop();
      emit(currentState.copyWith(currentlyPlayingId: null));
    } catch (e, stackTrace) {
      loggy.error('Error stopping playback: $e', e, stackTrace);
      emit(RecordingListState.error('Failed to stop recording: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _audioPlayerService.dispose();
    return super.close();
  }
}
