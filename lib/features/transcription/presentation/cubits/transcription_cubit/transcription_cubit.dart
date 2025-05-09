import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_snap/features/transcription/domain/services/transcription_service.dart';

part 'transcription_state.dart';
part 'transcription_cubit.freezed.dart';

@injectable
class TranscriptionCubit extends Cubit<TranscriptionState> {
  final TranscriptionService _transcriptionService;

  TranscriptionCubit(this._transcriptionService) : super(const TranscriptionState.initial());

  Future<void> transcribeAudio(String audioPath) async {
    emit(const TranscriptionState.loading());
    try {
      final result = await _transcriptionService.transcribeAudio(audioPath);
      result.fold(
        (failure) => emit(TranscriptionState.error(failure.message)),
        (transcription) => emit(
          TranscriptionState.loaded(
            text: transcription.text,
            createdAt: DateTime.now(),
          ),
        ),
      );
    } catch (e) {
      emit(TranscriptionState.error(e.toString()));
    }
  }
}
