// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_model.freezed.dart';
part 'recording_model.g.dart';

@freezed
class RecordingModel with _$RecordingModel {
  const RecordingModel._();
  const factory RecordingModel({
    required String id,
    required String file_name,
    required String file_path,
    required int duration,
    required DateTime created_at,
  }) = _RecordingModel;

  factory RecordingModel.fromJson(Map<String, dynamic> json) => _$RecordingModelFromJson(json);
}
