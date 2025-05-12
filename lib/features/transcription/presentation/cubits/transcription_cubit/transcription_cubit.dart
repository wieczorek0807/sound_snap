import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/features/transcription/domain/services/transcription_service.dart';

part 'transcription_state.dart';
part 'transcription_cubit.freezed.dart';

@injectable
class TranscriptionCubit extends Cubit<TranscriptionState> with UiLoggy {
  final TranscriptionService _transcriptionService;

  TranscriptionCubit(this._transcriptionService) : super(const TranscriptionState.initial());

  Future<void> transcribeAudio(String audioPath) async {
    loggy.debug('Starting transcription for audio: $audioPath');
    emit(const TranscriptionState.loading());
    try {
      final result = await _transcriptionService.transcribeAudio(audioPath);
      result.fold(
        (failure) {
          loggy.error('Transcription failed: ${failure.message}');
          emit(TranscriptionState.error(failure.message));
        },
        (transcription) {
          loggy.info('Transcription completed successfully');
          loggy.debug('Transcription text: ${transcription.text}');
          emit(
            TranscriptionState.loaded(
              text: transcription.text,
              createdAt: DateTime.now(),
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      loggy.error('Error during transcription: $e', e, stackTrace);
      emit(TranscriptionState.error(e.toString()));
    }
  }
}
