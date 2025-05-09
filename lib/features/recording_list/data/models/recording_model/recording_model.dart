// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'recording_model.g.dart';

@JsonSerializable()
class RecordingModel {
  final String id;
  final String file_name;
  final String file_path;
  final int duration;
  final DateTime created_at;

  const RecordingModel({
    required this.id,
    required this.file_name,
    required this.file_path,
    required this.duration,
    required this.created_at,
  });

  factory RecordingModel.fromJson(Map<String, dynamic> json) => _$RecordingModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecordingModelToJson(this);
}
