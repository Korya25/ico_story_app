class StoryModel {
  final String id;
  final String title;
  final String pdfPath;
  final String? audioPath;
  final String coverImage;

  const StoryModel({
    required this.id,
    required this.title,
    required this.pdfPath,
    this.audioPath,
    required this.coverImage,
  });
}
