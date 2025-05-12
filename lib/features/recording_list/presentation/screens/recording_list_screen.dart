import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_snap/core/injection/injectable.dart';
import 'package:sound_snap/core/presentation/screens/app_default_screen.dart';
import 'package:sound_snap/core/presentation/values/values.dart';
import 'package:sound_snap/core/router/app_router.dart';
import 'package:sound_snap/features/recording_list/domain/entities/recording_entity/recording_entity.dart';
import 'package:sound_snap/features/recording_list/presentation/cubits/recording_list_cubit/recording_list_cubit.dart';

@RoutePage()
class RecordingListScreen extends StatelessWidget {
  const RecordingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDefaultScreen(
      title: 'Lista nagrań',
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.push(const NewRecordingRoute()),
        tooltip: 'Rozpocznij nagranie',
        child: const Icon(Icons.mic),
      ),
      body: BlocProvider(
        create: (_) => getIt<RecordingListCubit>()..loadRecordings(),
        child: BlocBuilder<RecordingListCubit, RecordingListState>(
          builder: (context, state) {
            return switch (state) {
              RecordingListStateInitial() => _buildInitialView(context),
              RecordingListStateLoading() => const Center(child: CircularProgressIndicator()),
              RecordingListStateLoaded() => RefreshIndicator(
                  onRefresh: () => context.read<RecordingListCubit>().loadRecordings(),
                  child: _buildRecordingsList(state.recordings, state.currentlyPlayingId, context),
                ),
              RecordingListStateEmpty() => _buildEmptyState(context),
              RecordingListStateError() => _buildErrorState(state.message, context),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.read<RecordingListCubit>().loadRecordings(),
        child: const Text('Load Recordings'),
      ),
    );
  }

  Widget _buildRecordingsList(List<RecordingEntity> recordings, String? currentlyPlayingId, BuildContext context) {
    return ListView.builder(
      itemCount: recordings.length,
      itemBuilder: (context, index) {
        final recording = recordings[index];
        return Card(
          margin: AppMargin.smallMargin,
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                currentlyPlayingId == recording.id ? Icons.pause : Icons.play_arrow,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => context.read<RecordingListCubit>().togglePlayback(recording),
            ),
            title: Text(recording.fileName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDuration(recording.duration)),
                Text(_formatDate(recording.createdAt)),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.transcribe),
              onPressed: () => _navigateToTranscription(context, recording.id),
            ),
          ),
        );
      },
    );
  }

  void _navigateToTranscription(BuildContext context, String recordingId) {
    context.router.push(TranscriptionRoute(recordId: recordingId, filePath: recordingId));
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return [
      if (hours > 0) hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
      seconds.toString().padLeft(2, '0'),
    ].join(':');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year} ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'Brak dostępnych nagrań',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.pastelPeach, size: AppDimensions.iconLarge),
          const SizedBox(height: AppDimensions.gapMedium),
          Text(
            'Wystąpił błąd',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: AppPadding.defaultPadding,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.pastelPeach),
            ),
          ),
          ElevatedButton(
            onPressed: () => context.read<RecordingListCubit>().loadRecordings(),
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
}
