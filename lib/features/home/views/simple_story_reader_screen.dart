import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/core/widgets/custom_back_button.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/simple_pdf_viewer.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/simple_audio_player.dart';

class SimpleStoryReaderScreen extends StatefulWidget {
  final StoryModel story;

  const SimpleStoryReaderScreen({super.key, required this.story});

  @override
  State<SimpleStoryReaderScreen> createState() =>
      _SimpleStoryReaderScreenState();
}

class _SimpleStoryReaderScreenState extends State<SimpleStoryReaderScreen> {
  int currentPage = 0;
  int totalPages = 0;
  bool showAudioControls = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundContainer(
        color: AppColors.primary,
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // PDF Viewer
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SimplePdfViewer(
                    pdfPath: widget.story.pdfPath,
                    onPageChanged: (current, total) {
                      setState(() {
                        currentPage = current;
                        totalPages = total;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Audio Controls
            if (showAudioControls) ...[
              const SizedBox(height: 16),
              SimpleAudioPlayer(audioPath: widget.story.audioPath),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          const CustomBackButton(),

          const SizedBox(width: 16),

          // Story Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  widget.story.title,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                const SizedBox(height: 4),
                CustomText(
                  totalPages > 0
                      ? 'صفحة $currentPage من $totalPages'
                      : 'جاري التحميل...',
                  fontSize: 14,
                  color: AppColors.white.withOpacity(0.8),
                ),
              ],
            ),
          ),

          // Audio Toggle Button
          GestureDetector(
            onTap: () {
              setState(() {
                showAudioControls = !showAudioControls;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                showAudioControls ? Icons.volume_off : Icons.volume_up,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
