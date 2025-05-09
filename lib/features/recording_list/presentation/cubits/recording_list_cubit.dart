import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:loggy/loggy.dart';
import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';
import 'package:sound_snap/features/recording_list/domain/services/recording_list_service/recording_list_service.dart';

part 'recording_list_cubit.freezed.dart';
part 'recording_list_state.dart';

@injectable
class RecordingListCubit extends Cubit<RecordingListState> with UiLoggy {
  final RecordingListService _service;

  RecordingListCubit(this._service) : super(const RecordingListState.initial());

  Future<void> loadRecordings() async {
    loggy.debug('Loading recordings initiated');
    emit(const RecordingListState.loading());

    final result = await _service.getRecordings();

    result.fold(
      (failure) {
        emit(RecordingListState.error(failure.toString()));
      },
      (recordings) {
        loggy.info('Successfully loaded ${recordings.length} recordings');
        emit(RecordingListState.loaded(recordings));
      },
    );
  }
}
