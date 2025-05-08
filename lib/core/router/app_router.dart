import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_snap/features/new_recording/presentation/new_recording_screen.dart';
import 'package:sound_snap/features/recording_list/presentation/screens/recording_list_screen.dart';
import 'package:sound_snap/features/transcription/presentation/screens/transcription_screen.dart';

part 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: RecordingListRoute.page, initial: true),
        AutoRoute(page: NewRecordingRoute.page),
        AutoRoute(page: TranscriptionRoute.page)
      ];
}
