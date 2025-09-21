import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/features/home/models/story_category_model.dart';

class StoryCategoriesList {
  static List<StoryCategoryModel> get categories => [
    StoryCategoryModel(
      id: AppConstant.char,
      title: 'قصص الحروف',
      imagePath: AppAssets.charsStories,
    ),
    StoryCategoryModel(
      id: AppConstant.surah,
      title: 'قصص سيرة',
      imagePath: AppAssets.serahStories,
    ),
    StoryCategoryModel(
      id: AppConstant.tarbawia,
      title: 'كنوز القيم',
      imagePath: AppAssets.knoozStories,
    ),
  ];
}
