import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_entity.freezed.dart';

@freezed
class RecordingEntity with _$RecordingEntity {
  const factory RecordingEntity({
    required String id,
    required String fileName,
    required String filePath,
    required Duration duration,
    required DateTime createdAt,
  }) = _RecordingEntity;
}
