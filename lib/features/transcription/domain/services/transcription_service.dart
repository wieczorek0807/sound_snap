import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/core/errors/failure.dart';

import 'package:sound_snap/features/transcription/data/datasources/transcription_remote_data_source.dart';
import 'package:sound_snap/features/transcription/domain/entities/transcription_entity/transcription_entity.dart';

abstract interface class ITranscriptionService {
  Future<Either<Failure, TranscriptionEntity>> transcribeAudio(String audioPath);
}

@injectable
class TranscriptionService with UiLoggy implements ITranscriptionService {
  final TranscriptionRemoteDataSource _remoteDataSource;

  TranscriptionService(this._remoteDataSource);

  @override
  Future<Either<Failure, TranscriptionEntity>> transcribeAudio(String audioPath) async {
    final result = await _remoteDataSource.getTranscription(audioPath);
    return result.map((model) => TranscriptionEntity(
          id: model.id,
          text: model.text,
          createdAt: model.created_at,
        ));
  }
}
