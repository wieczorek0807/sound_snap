import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';
import 'dart:async';
import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:dartz/dartz.dart';
import 'package:sound_snap/core/errors/failure.dart';

abstract interface class IRecordingService {
  Future<Either<Failure, void>> startRecording();
  Future<Either<Failure, RecordingEntity>> stopRecording();
}

@injectable
class RecordingService with UiLoggy implements IRecordingService {
  Timer? _recordingTimer;
  DateTime? _recordingStartTime;
  final _random = Random();

  @override
  Future<Either<Failure, void>> startRecording() async {
    try {
      loggy.info('Starting recording...');
      await Future.delayed(const Duration(milliseconds: 500));
      _recordingStartTime = DateTime.now();
      loggy.info('Recording started at: $_recordingStartTime');

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        loggy.debug('Recording in progress...');
      });

      return const Right(null);
    } catch (e, stackTrace) {
      loggy.error('Failed to start recording', e, stackTrace);
      return Left(ServiceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecordingEntity>> stopRecording() async {
    try {
      loggy.info('Stopping recording...');
      await Future.delayed(const Duration(milliseconds: 300));

      _recordingTimer?.cancel();
      _recordingTimer = null;

      if (_recordingStartTime == null) {
        loggy.error('Attempted to stop recording that was not started');
        return Left(ServiceFailure('Recording was not started'));
      }

      final duration = Duration(seconds: _random.nextInt(290) + 10);
      loggy.info('Recording duration: $duration');

      final recording = RecordingEntity(
        id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
        fileName: 'Recording_${DateTime.now().millisecondsSinceEpoch}',
        duration: duration,
        createdAt: _recordingStartTime!,
        filePath: 'recordings/rec_${DateTime.now().millisecondsSinceEpoch}.wav',
      );

      loggy.info('Recording saved: ${recording.fileName}');
      _recordingStartTime = null;
      return Right(recording);
    } catch (e, stackTrace) {
      loggy.error('Failed to stop recording', e, stackTrace);
      return Left(ServiceFailure(e.toString()));
    }
  }
}
