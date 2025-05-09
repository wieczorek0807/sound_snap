import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_snap/features/new_recording/domain/services/recording_service.dart';
import 'package:sound_snap/features/new_recording/presentation/cubits/new_recording_state.dart';

@injectable
class NewRecordingCubit extends Cubit<NewRecordingState> {
  final RecordingService _recordingService;
  Timer? _timer;

  NewRecordingCubit(this._recordingService) : super(const NewRecordingState.initial());

  Future<void> startRecording() async {
    try {
      emit(const NewRecordingState.loading());

      final result = await _recordingService.startRecording();

      result.fold(
        (failure) => emit(NewRecordingState.error(message: failure.message)),
        (_) {
          emit(const NewRecordingState.recording(duration: Duration.zero));
          _startTimer();
        },
      );
    } catch (e) {
      emit(NewRecordingState.error(message: e.toString()));
    }
  }

  Future<void> stopRecording() async {
    try {
      emit(const NewRecordingState.loading());
      _timer?.cancel();

      final result = await _recordingService.stopRecording();

      result.fold(
        (failure) => emit(NewRecordingState.error(message: failure.message)),
        (recording) => emit(NewRecordingState.success(recording: recording)),
      );
    } catch (e) {
      emit(NewRecordingState.error(message: e.toString()));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is NewRecordingStateRecording) {
        final currentState = state as NewRecordingStateRecording;
        emit(NewRecordingState.recording(
          duration: currentState.duration + const Duration(seconds: 1),
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
