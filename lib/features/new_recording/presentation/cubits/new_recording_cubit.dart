import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/features/new_recording/domain/services/recording_service.dart';
import 'package:sound_snap/features/new_recording/presentation/cubits/new_recording_state.dart';

@injectable
class NewRecordingCubit extends Cubit<NewRecordingState> with UiLoggy {
  final RecordingService _recordingService;
  Timer? _timer;

  NewRecordingCubit(this._recordingService) : super(const NewRecordingState.initial());

  Future<void> startRecording() async {
    try {
      loggy.debug('Starting new recording');
      emit(const NewRecordingState.loading());

      final result = await _recordingService.startRecording();

      result.fold(
        (failure) {
          loggy.error('Failed to start recording: ${failure.message}');
          emit(NewRecordingState.error(message: failure.message));
        },
        (_) {
          loggy.info('Recording started successfully');
          emit(const NewRecordingState.recording(duration: Duration.zero));
          _startTimer();
        },
      );
    } catch (e, stackTrace) {
      loggy.error('Error starting recording: $e', e, stackTrace);
      emit(NewRecordingState.error(message: e.toString()));
    }
  }

  Future<void> stopRecording() async {
    try {
      loggy.debug('Stopping recording');
      emit(const NewRecordingState.loading());
      _timer?.cancel();

      final result = await _recordingService.stopRecording();

      result.fold(
        (failure) {
          loggy.error('Failed to stop recording: ${failure.message}');
          emit(NewRecordingState.error(message: failure.message));
        },
        (recording) {
          loggy.info('Recording stopped successfully: ${recording.fileName}');
          emit(NewRecordingState.success(recording: recording));
        },
      );
    } catch (e, stackTrace) {
      loggy.error('Error stopping recording: $e', e, stackTrace);
      emit(NewRecordingState.error(message: e.toString()));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is NewRecordingStateRecording) {
        final currentState = state as NewRecordingStateRecording;
        loggy.debug('Recording duration: ${currentState.duration.inSeconds}s');
        emit(NewRecordingState.recording(
          duration: currentState.duration + const Duration(seconds: 1),
        ));
      }
    });
  }

  @override
  Future<void> close() {
    loggy.debug('Closing NewRecordingCubit');
    _timer?.cancel();
    return super.close();
  }
}
