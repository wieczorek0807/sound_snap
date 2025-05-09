part of 'recording_list_cubit.dart';

@freezed
class RecordingListState with _$RecordingListState {
  const factory RecordingListState.initial() = _Initial;
  const factory RecordingListState.loading() = _Loading;
  const factory RecordingListState.loaded(List<RecordingEntity> recordings) = _Loaded;
  const factory RecordingListState.empty() = _Empty;
  const factory RecordingListState.error(String message) = _Error;
}
