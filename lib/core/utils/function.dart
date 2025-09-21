import 'package:ico_story_app/core/constants/app_constant.dart';

String returnTitle(String categoryTitle) {
  switch (categoryTitle) {
    case AppConstant.char:
      return 'قصص حروف';
    case AppConstant.tarbawia:
      return 'كنوز القيم';
    case AppConstant.surah:
      return 'قصص سيرة';
    default:
      return 'قصص ';
  }
}
