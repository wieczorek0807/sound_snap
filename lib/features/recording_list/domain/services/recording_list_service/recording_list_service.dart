import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/core/errors/failure.dart';
import 'package:sound_snap/features/recording_list/data/repositories/recording_list_repository.dart';
import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';

abstract interface class IRecordingListService {
  Future<Either<Failure, List<RecordingEntity>>> getRecordings();
}

@injectable
class RecordingListService with UiLoggy implements IRecordingListService {
  final RecordingListRepository _repository;

  RecordingListService(this._repository);

  @override
  Future<Either<Failure, List<RecordingEntity>>> getRecordings() async {
    try {
      final result = await _repository.getRecordings();

      return result.fold(
        (failure) {
          return Left(failure);
        },
        (models) {
          final entities = models.map(RecordingEntity.fromModel).toList();
          loggy.info('Successfully mapped ${entities.length} recordings to entities');
          return Right(entities);
        },
      );
    } catch (e, stackTrace) {
      loggy.error('Service layer error: ${e.toString()}', e, stackTrace);
      return Left(ServiceFailure(e.toString()));
    }
  }
}
