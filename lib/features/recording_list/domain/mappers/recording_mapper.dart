import 'package:sound_snap/features/recording_list/data/models/recording_model/recording_model.dart';
import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';

abstract class RecordingMapper {
  static RecordingEntity toEntity(RecordingModel model) {
    return RecordingEntity(
      id: model.id,
      fileName: model.file_name,
      filePath: model.file_path,
      duration: Duration(milliseconds: model.duration),
      createdAt: model.created_at,
    );
  }
}
