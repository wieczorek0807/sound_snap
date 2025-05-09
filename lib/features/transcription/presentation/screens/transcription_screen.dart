import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sound_snap/core/presentation/screens/app_default_screen.dart';

@RoutePage()
class TranscriptionScreen extends StatelessWidget {
  const TranscriptionScreen({super.key, required this.recordId, required this.filePath});

  final String recordId;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return AppDefaultScreen(
      title: 'context.appLocalizations.notes,',
      // body: BlocBuilder<NotesCubit, NotesState>(
      //   builder: (context, state) {
      //     return state.when(
      //       initial: () => Text(context.appLocalizations.addFirstNote),
      //       error: (message) =>
      //           Text(context.appLocalizations.errorScreenMessage(message)),
      //       loaded: (noteEntitiesList) =>
      //           NotesList(noteEntities: noteEntitiesList),
      //       loading: () => const CircularProgressIndicator(),
      //     );
      //   },
      // ),
      body: Placeholder(),
      // floatingActionButton: const AddNoteFloatingActionButton(),
    );
  }
}
