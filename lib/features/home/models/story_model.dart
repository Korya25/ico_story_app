class StoryModel {
  final String title;

  StoryModel({required this.title});

  static List<StoryModel> getStoriesForCategory(String category) {
    switch (category) {
      case 'كنوز القيم':
        return [
          StoryModel(title: 'الصدق منجاة'),
          StoryModel(title: 'الأمانة كنز'),
          StoryModel(title: 'العطاء والكرم'),
          StoryModel(title: 'احترام الكبير'),
          StoryModel(title: 'الصبر مفتاح الفرج'),
          StoryModel(title: 'التعاون قوة'),
        ];
      case 'قصص سيرة':
        return [
          StoryModel(title: 'سيدنا محمد ﷺ'),
          StoryModel(title: 'أبو بكر الصديق'),
          StoryModel(title: 'عمر بن الخطاب'),
          StoryModel(title: 'عثمان بن عفان'),
          StoryModel(title: 'علي بن أبي طالب'),
        ];
      case 'قصص حروف':
        return [
          StoryModel(title: 'مغامرة حرف الألف'),
          StoryModel(title: 'باء والبطة الصغيرة'),
          StoryModel(title: 'تاء وشجرة التفاح'),
          StoryModel(title: 'ثاء والثعلب الماكر'),
          StoryModel(title: 'جيم والجمل المسافر'),
          StoryModel(title: 'حاء والحصان السريع'),
          StoryModel(title: 'خاء والخروف الصغير'),
          StoryModel(title: 'دال والدب اللطيف'),
        ];
      default:
        return [];
    }
  }
}
