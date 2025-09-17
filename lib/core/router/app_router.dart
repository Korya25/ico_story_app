import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/router/app_transitions.dart';
import 'package:ico_story_app/features/home/views/home_view.dart';
import 'package:ico_story_app/features/on_boreading/views/on_boreading_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: HomeScreen(),
        ),
      ),
    ],
  );
}
