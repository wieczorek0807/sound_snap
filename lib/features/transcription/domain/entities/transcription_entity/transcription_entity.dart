import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sound_snap/features/transcription/data/models/transcription_model/transcription_model.dart';

part 'transcription_entity.freezed.dart';

@freezed
abstract class TranscriptionEntity with _$TranscriptionEntity {
  const factory TranscriptionEntity({
    required String id,
    required String text,
    required DateTime createdAt,
  }) = _TranscriptionEntity;

  factory TranscriptionEntity.fromModel(TranscriptionModel model) {
    return TranscriptionEntity(
      id: model.id,
      text: model.text,
      createdAt: model.created_at,
    );
  }
}
