import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_snap/core/injection/injectable.dart';
import 'package:sound_snap/core/presentation/screens/app_default_screen.dart';
import 'package:sound_snap/core/presentation/values/values.dart';
import 'package:sound_snap/features/new_recording/presentation/cubits/new_recording_cubit.dart';
import 'package:sound_snap/features/new_recording/presentation/cubits/new_recording_state.dart';

@RoutePage()
class NewRecordingScreen extends StatelessWidget {
  const NewRecordingScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewRecordingCubit>(),
      child: BlocConsumer<NewRecordingCubit, NewRecordingState>(
        listener: (context, state) {
          switch (state) {
            case NewRecordingStateSuccess(recording: final recording):
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pomyślnie dodano nagranie', ),
                  backgroundColor: AppColors.pastelGreen,
                  duration: Duration(seconds: 2),
                ),
              );
              context.router.pop(recording);
            case NewRecordingStateError(message: final message):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.pastelPeach,
                ),
              );
            default:
              break;
          }
        },
        builder: (context, state) {
          return AppDefaultScreen(
            title: 'Nowe nagranie',
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  switch (state) {
                    NewRecordingStateRecording(duration: final duration) => Column(
                        children: [
                          const Icon(Icons.mic, size: AppDimensions.iconLarge, color: AppColors.pastelPeach),
                          const SizedBox(height: AppDimensions.gapMedium),
                          Text(
                            _formatDuration(duration),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppDimensions.gapLarge),
                        ],
                      ),
                    _ => const SizedBox.shrink(),
                  },
                  switch (state) {
                    NewRecordingStateLoading() => const CircularProgressIndicator(),
                    _ => ElevatedButton.icon(
                        onPressed: () {
                          final cubit = context.read<NewRecordingCubit>();
                          switch (state) {
                            case NewRecordingStateRecording():
                              cubit.stopRecording();
                            default:
                              cubit.startRecording();
                          }
                        },
                        icon: Icon(
                          switch (state) {
                            NewRecordingStateRecording() => Icons.stop,
                            _ => Icons.mic,
                          },
                        ),
                        label: Text(
                          switch (state) {
                            NewRecordingStateRecording() => 'Zakończ nagranie',
                            _ => 'Rozpocznij nagranie',
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: AppPadding.defaultButtonPadding
                        ),
                      ),
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
