import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/core/errors/failure.dart';
import 'package:sound_snap/features/recording_list/data/data_sources/recording_list_local_data_source.dart';
import 'package:sound_snap/features/recording_list/data/models/recording_model/recording_model.dart';

abstract interface class IRecordingListRepository {
  Future<Either<Failure, List<RecordingModel>>> getRecordings();
}

@injectable
class RecordingListRepository with UiLoggy implements IRecordingListRepository {
  final RecordingListLocalDataSource _dataSource;

  RecordingListRepository(this._dataSource);

  @override
  Future<Either<Failure, List<RecordingModel>>> getRecordings() async {
    try {
      final result = await _dataSource.getRecordings();

      return result.fold(
        (failure) {
          return Left(failure);
        },
        (recordings) {
          return Right(recordings);
        },
      );
    } catch (e, stackTrace) {
      loggy.error('Repository error: ${e.toString()}', e, stackTrace);
      return Left(RepositoryFailure(e.toString()));
    }
  }
}
