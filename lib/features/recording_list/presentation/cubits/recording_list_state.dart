part of 'recording_list_cubit.dart';

@freezed
class RecordingListState with _$RecordingListState {
  const factory RecordingListState.initial() = RecordingListStateInitial;
  const factory RecordingListState.loading() = RecordingListStateLoading;
  const factory RecordingListState.loaded({
    required List<RecordingEntity> recordings,
    String? currentlyPlayingId,
  }) = RecordingListStateLoaded;
  const factory RecordingListState.empty() = RecordingListStateEmpty;
  const factory RecordingListState.error(String message) = RecordingListStateError;
}
