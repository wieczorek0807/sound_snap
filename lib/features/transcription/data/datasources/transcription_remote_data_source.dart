import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/core/errors/failure.dart';
import 'package:sound_snap/features/transcription/data/models/transcription_model/transcription_model.dart';

abstract interface class ITranscriptionRemoteDataSource {
  Future<Either<Failure, TranscriptionModel>> getTranscription(String audioPath);
}

@injectable
class TranscriptionRemoteDataSource with UiLoggy implements ITranscriptionRemoteDataSource {
  final List<String> _mockTranscriptions = [
    'To jest przykładowa transkrypcja pierwszego nagrania. Zawiera ona tekst, który został automatycznie wygenerowany na podstawie nagrania audio.',
    'Druga przykładowa transkrypcja zawiera inny tekst, który również został wygenerowany automatycznie. Może zawierać różne informacje i kontekst.',
    'Trzecia przykładowa transkrypcja pokazuje, jak różnorodne mogą być wygenerowane teksty. Każda transkrypcja jest unikalna i dostosowana do treści nagrania.'
  ];

  @override
  Future<Either<Failure, TranscriptionModel>> getTranscription(String audioPath) async {
    try {
      // Symulacja opóźnienia sieci
      await Future.delayed(const Duration(seconds: 1));

      final randomIndex = DateTime.now().millisecondsSinceEpoch % _mockTranscriptions.length;
      final transcription = TranscriptionModel(
        id: 'trans_${DateTime.now().millisecondsSinceEpoch}',
        recording_id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
        text: _mockTranscriptions[randomIndex],
        created_at: DateTime.now(),
      );

      return Right(transcription);
    } catch (e, stackTrace) {
      loggy.error('Error generating transcription: $e', e, stackTrace);
      return Left(ServiceFailure(e.toString()));
    }
  }
}
