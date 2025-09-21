import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/router/app_transitions.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/views/home_view.dart';
import 'package:ico_story_app/features/home/views/stories_list_view.dart';
import 'package:ico_story_app/features/home/views/story_reader_screen.dart';
import 'package:ico_story_app/features/onboarding/views/onboarding_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
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
          child: HomeView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.storiesList,
        name: AppRoutes.storiesList,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return AppTransitions.slideFromRight(
            context: context,
            state: state,

            child: StoriesListView(
              categoryTitle: extras?[AppConstant.categoryTitle],
              storyCount: extras?[AppConstant.storyCount],
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.storyReader,
        name: AppRoutes.storyReader,
        pageBuilder: (context, state) {
          final story = state.extra as StoryModel;

          return AppTransitions.slideFromRight(
            context: context,
            state: state,
            child: StoryReaderView(story: story),
          );
        },
      ),
    ],
  );
}
/*
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StoriesListScreen(
        categoryTitle: 'كنوز القيم',
        categoryEmoji: '💎',
        categoryColor: AppColors.primary,
        categoryIcon: Icons.diamond,
      ),
    ),
  );
},
*/