// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/story_reader_header.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/pdf_book_flip_local.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/audio_controls.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/managers/audio_manager.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/managers/pdf_manager.dart';

class StoryReaderView extends StatefulWidget {
  final StoryModel story;

  const StoryReaderView({super.key, required this.story});

  @override
  State<StoryReaderView> createState() => _StoryReaderViewState();
}

class _StoryReaderViewState extends State<StoryReaderView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Audio Manager
  late AudioManager _audioManager;

  // PDF Manager
  late PDFManager _pdfManager;

  // Animation Controllers
  late AnimationController _waveController;

  // State
  bool _showAudioControls = false;
  final bool _pageFitCover = false;
  final double _pageScale = 0.98;
  final Alignment _pageAlignment = Alignment.center;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeManagers();
    _initializeAnimations();
  }

  void _initializeManagers() {
    _audioManager = AudioManager(
      audioAssetPath: widget.story.audioPath,
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    _pdfManager = PDFManager(
      pdfAssetPath: widget.story.pdfPath,
      storyTitle: widget.story.title,
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    _audioManager.initialize();
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
    _audioManager.dispose();
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
      _audioManager.handleAppLifecyclePause();
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
              currentPage: _pdfManager.currentPage,
              totalPages: _pdfManager.totalPages,
              onAudioToggle: () => setState(() {
                _showAudioControls = !_showAudioControls;
              }),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                margin: EdgeInsets.all(0),
                color: AppColors.cardBackground,
                child: Stack(
                  children: [
                    // PDF Viewer - Main Content (fills available space)
                    Positioned.fill(
                      child: PdfBookFlipLocal(
                        fitCover: _pageFitCover,
                        scale: _pageScale,
                        alignment: _pageAlignment,
                        pdfPath: widget.story.pdfPath,
                      ),
                    ),

                    // Audio Controls overlay (does not affect layout)
                    if (_showAudioControls)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AudioControls(
                          audioManager: _audioManager,
                          categoryColor: AppColors.textPrimary,
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
