import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';

part 'new_recording_state.freezed.dart';

@freezed
class NewRecordingState with _$NewRecordingState {
  const factory NewRecordingState.initial() = NewRecordingStateInitial;
  const factory NewRecordingState.recording({
    required Duration duration,
  }) = NewRecordingStateRecording;
  const factory NewRecordingState.loading() = NewRecordingStateLoading;
  const factory NewRecordingState.success({
    required RecordingEntity recording,
  }) = NewRecordingStateSuccess;
  const factory NewRecordingState.error({
    required String message,
  }) = NewRecordingStateError;
}
