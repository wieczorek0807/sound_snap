import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_snap/core/injection/injectable.dart';
import 'package:sound_snap/core/presentation/screens/app_default_screen.dart';
import 'package:sound_snap/core/presentation/values/values.dart';
import 'package:sound_snap/features/transcription/presentation/cubits/transcription_cubit/transcription_cubit.dart';

@RoutePage()
class TranscriptionScreen extends StatelessWidget {
  const TranscriptionScreen({super.key, required this.recordId, required this.filePath});

  final String recordId;
  final String filePath;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year} ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AppDefaultScreen(
      title: 'Transkrypcja',
      body: BlocProvider(
        create: (context) => getIt<TranscriptionCubit>()..transcribeAudio(filePath),
        child: BlocBuilder<TranscriptionCubit, TranscriptionState>(
          builder: (context, state) {
            return switch (state) {
              TranscriptionStateInitial() => const Center(child: Text('Rozpoczynam transkrypcję...')),
              TranscriptionStateLoading() => const Center(child: CircularProgressIndicator()),
              TranscriptionStateLoaded() => SingleChildScrollView(
                  padding: AppPadding.defaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppDimensions.gapMedium),
                      Text(
                        'Utworzono: ${_formatDate(state.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              TranscriptionStateError() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Wystąpił błąd: ${state.message}'),
                      const SizedBox(height: AppDimensions.gapMedium),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TranscriptionCubit>().transcribeAudio(filePath);
                        },
                        child: const Text('Spróbuj ponownie'),
                      ),
                    ],
                  ),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
