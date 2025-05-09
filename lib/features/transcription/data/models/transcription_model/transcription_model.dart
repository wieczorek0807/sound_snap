// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'transcription_model.g.dart';

@JsonSerializable()
class TranscriptionModel {
  final String id;
  final String recording_id;
  final String text;
  final DateTime created_at;

  const TranscriptionModel({
    required this.id,
    required this.recording_id,
    required this.text,
    required this.created_at,
  });

  factory TranscriptionModel.fromJson(Map<String, dynamic> json) => _$TranscriptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TranscriptionModelToJson(this);
}
