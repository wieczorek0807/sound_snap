import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/core/errors/failure.dart';
import 'package:sound_snap/features/recording_list/data/models/recording_model/recording_model.dart';

abstract interface class IRecordingListLocalDataSource {
  Future<Either<Failure, List<RecordingModel>>> getRecordings();
}

@injectable
class RecordingListDataSource with UiLoggy implements IRecordingListLocalDataSource {
  @override
  Future<Either<Failure, List<RecordingModel>>> getRecordings() async {
    try {
      final now = DateTime.now();
      final mockData = [
        RecordingModel(
          id: 'rec_001',
          file_name: 'Daily_Meeting.mp3',
          file_path: '/recordings/daily_meeting.mp3',
          duration: 900000,
          created_at: now.subtract(const Duration(days: 1)),
        ),
        RecordingModel(
          id: 'rec_002',
          file_name: 'Client_Call_ProjectX.mp3',
          file_path: '/recordings/client_call.mp3',
          duration: 1800000,
          created_at: now.subtract(const Duration(days: 3)),
        ),
        RecordingModel(
          id: 'rec_003',
          file_name: 'Ideas_2024.mp3',
          file_path: '/recordings/ideas.mp3',
          duration: 300000,
          created_at: now.subtract(const Duration(days: 5)),
        ),
        RecordingModel(
          id: 'rec_004',
          file_name: 'Interview_Backend.mp3',
          file_path: '/recordings/interview.mp3',
          duration: 2700000,
          created_at: now.subtract(const Duration(days: 7)),
        )
      ];

      return Right(mockData);
    } catch (e, stackTrace) {
      loggy.error('Data format error: $e', stackTrace);
      return Left(LocalDataSourceFailure(e.toString()));
    }
  }
}
