part of 'transcription_cubit.dart';

@freezed
class TranscriptionState with _$TranscriptionState {
  const factory TranscriptionState.initial() = TranscriptionStateInitial;
  const factory TranscriptionState.loading() = TranscriptionStateLoading;
  const factory TranscriptionState.loaded({required String text, required DateTime createdAt}) =
      TranscriptionStateLoaded;
  const factory TranscriptionState.error(String message) = TranscriptionStateError;
}
