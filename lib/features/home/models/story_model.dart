class StoryModel {
  final String id;
  final String title;
  final String pdfPath;
  final String audioPath;
  final String coverImage;

  const StoryModel({
    required this.id,
    required this.title,
    required this.pdfPath,
    required this.audioPath,
    required this.coverImage,
  });
}

class StoryList {
  static List<StoryModel> getStories() {
    return [
      const StoryModel(
        id: '1',
        title: 'أحب أن أختار',
        pdfPath: 'assets/pdf/OhebAnAkhtar.pdf',
        audioPath: 'assets/audio/OhebAnAkhtar.mp3',
        coverImage: 'assets/images/story_lablel/story1.png',
      ),
      // يمكن إضافة المزيد من القصص هنا
    ];
  }

  static List<StoryModel> getStoriesForCategory(String categoryTitle) {
    // في الوقت الحالي، نعيد جميع القصص
    // يمكن تحسين هذا لاحقاً لإرجاع قصص محددة حسب الفئة
    return getStories();
  }
}
