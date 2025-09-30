// ignore_for_file: deprecated_member_use, avoid_print
import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/story_reader_header.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/pdf_book_flip_local.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/audio_controls.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/managers/audio_manager.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/managers/pdf_manager.dart';

class StoryReaderView extends StatefulWidget {
  final StoryModel story;
  final String? categoryId;

  const StoryReaderView({super.key, required this.story, this.categoryId});

  @override
  State<StoryReaderView> createState() => _StoryReaderViewState();
}

class _StoryReaderViewState extends State<StoryReaderView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Audio Manager
  AudioManager? _audioManager;

  // PDF Manager
  late PDFManager _pdfManager;

  // Animation Controllers
  late AnimationController _waveController;

  // State
  bool _showAudioControls = false;
  final Alignment _pageAlignment = Alignment.center;
  bool get _isSurah => widget.categoryId == AppConstant.surah;
  String? get _storyTypeLabel {
    if (_isSurah) return null;
    if (widget.categoryId == AppConstant.tarbawia) return 'الأنشودة';
    if (widget.categoryId == AppConstant.char) return 'القصة';
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeManagers();
    _initializeAnimations();
  }

  void _initializeManagers() {
    if (!_isSurah) {
      _audioManager = AudioManager(
        audioAssetPath: widget.story.audioPath,
        onStateChanged: () {
          if (mounted) setState(() {});
        },
      );
      _audioManager!.initialize();
    }

    _pdfManager = PDFManager(
      pdfAssetPath: widget.story.pdfPath,
      storyTitle: widget.story.title,
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _pdfManager.initialize();
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _audioManager?.dispose();
    _pdfManager.dispose();
    _waveController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _audioManager?.handleAppLifecyclePause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundContainer(
        color: AppColors.primary,
        child: Column(
          children: [
            // Header
            StoryReaderHeader(
              storyTitle: widget.story.title,
              onAudioToggle: _isSurah
                  ? null
                  : () => setState(() {
                      _showAudioControls = !_showAudioControls;
                    }),
              storyType: _storyTypeLabel,
              isAudioVisible: _showAudioControls && !_isSurah,
            ),

            // Main Content Area
            Expanded(
              child: Container(
                color: AppColors.cardBackground,
                child: Stack(
                  children: [
                    // PDF Viewer - Main Content (fills available space)
                    Positioned.fill(
                      child: PdfBookFlipLocal(
                        alignment: _pageAlignment,
                        pdfPath: widget.story.pdfPath,
                      ),
                    ),

                    // Audio Controls overlay (does not affect layout)
                    if (_showAudioControls &&
                        !_isSurah &&
                        _audioManager != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AudioControls(
                          audioManager: _audioManager!,
                          categoryColor: AppColors.soundBackground,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
