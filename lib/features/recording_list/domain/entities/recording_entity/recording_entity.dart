import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sound_snap/features/recording_list/data/models/recording_model/recording_model.dart';

part 'recording_entity.freezed.dart';

@freezed
abstract class RecordingEntity with _$RecordingEntity {
  const factory RecordingEntity({
    required String id,
    required String fileName,
    required String filePath,
    required Duration duration,
    required DateTime createdAt,
  }) = _RecordingEntity;

  factory RecordingEntity.fromModel(RecordingModel model) {
    return RecordingEntity(
      id: model.id,
      fileName: model.file_name,
      filePath: model.file_path,
      duration: Duration(milliseconds: model.duration),
      createdAt: model.created_at,
    );
  }
}
