// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/core/widgets/custom_icon_cackground.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/story_reader_header.dart';
import 'package:page_flip/page_flip.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

// ===== MAIN STORY READER SCREEN =====
class StoryReaderView extends StatefulWidget {
  final String storyTitle;
  final String pdfAssetPath;
  final String audioAssetPath;

  const StoryReaderView({
    super.key,
    this.storyTitle = 'أحب ان أختار',
    this.pdfAssetPath = 'assets/pdf/OhebAnAkhtar.pdf',
    this.audioAssetPath = 'audio/OhebAnAkhtar.mp3',
  });

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
  bool _pageFitCover = false;
  double _pageScale = 0.98;
  Alignment _pageAlignment = Alignment.center;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeManagers();
    _initializeAnimations();
  }

  void _initializeManagers() {
    _audioManager = AudioManager(
      audioAssetPath: widget.audioAssetPath,
      onStateChanged: () => setState(() {}),
    );

    _pdfManager = PDFManager(
      pdfAssetPath: widget.pdfAssetPath,
      storyTitle: widget.storyTitle,
      onStateChanged: () => setState(() {}),
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
    // Using responsive UI within nested widgets; no local flag needed here

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundContainer(
        color: AppColors.primary,
        child: Column(
          children: [
            // Header
            StoryReaderHeader(
              storyTitle: widget.storyTitle,
              currentPage: _pdfManager.currentPage,
              totalPages: _pdfManager.totalPages,
              onAudioToggle: () => setState(() {
                _showAudioControls = !_showAudioControls;
              }),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                margin: EdgeInsets.zero,
                color: AppColors.cardBackground,
                child: Stack(
                  children: [
                    // PDF Viewer - Main Content (fills available space)
                    Positioned.fill(
                      child: PdfBookFlipLocal(
                        fitCover: _pageFitCover,
                        scale: _pageScale,
                        alignment: _pageAlignment,
                      ),
                    ),

                    // Audio Controls overlay (does not affect layout)
                    if (_showAudioControls)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _AudioControls(
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

// ===== AUDIO MANAGER =====
class AudioManager {
  final String audioAssetPath;
  final VoidCallback onStateChanged;

  late AudioPlayer _audioPlayer;

  // State
  bool isPlaying = false;
  bool isLoading = true;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double playbackSpeed = 1.0;
  double volume = 0.8;

  AudioManager({required this.audioAssetPath, required this.onStateChanged});

  Future<void> initialize() async {
    _audioPlayer = AudioPlayer();
    await _setupAudioListeners();
    await _loadAudio();
  }

  Future<void> _setupAudioListeners() async {
    _audioPlayer.onDurationChanged.listen((duration) {
      totalDuration = duration;
      isLoading = false;
      onStateChanged();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      currentPosition = position;
      onStateChanged();
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      onStateChanged();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      isPlaying = false;
      currentPosition = Duration.zero;
      onStateChanged();
    });
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource(audioAssetPath));
    } catch (e) {
      print('Audio loading error: $e');
      isLoading = false;
      onStateChanged();
    }
  }

  // Control Methods
  Future<void> togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      print('Play/Pause error: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Seek error: $e');
    }
  }

  Future<void> restart() async {
    await seekTo(Duration.zero);
  }

  Future<void> setSpeed(double speed) async {
    // Removed speed control functionality as per requirements
  }

  Future<void> setVolume(double vol) async {
    // Removed volume control functionality as per requirements
  }

  Future<void> handleAppLifecyclePause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      }
    } catch (e) {
      print('Lifecycle pause error: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

// ===== PDF MANAGER =====
class PDFManager {
  final String pdfAssetPath;
  final String storyTitle;
  final VoidCallback onStateChanged;

  // State
  String? localPdfPath;
  int currentPage = 0;
  int totalPages = 0;
  bool pdfReady = false;
  PDFViewController? pdfViewController;

  PDFManager({
    required this.pdfAssetPath,
    required this.storyTitle,
    required this.onStateChanged,
  });

  Future<void> initialize() async {
    await _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      final byteData = await rootBundle.load(pdfAssetPath);
      final file = File(
        '${(await getTemporaryDirectory()).path}/$storyTitle.pdf',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());

      localPdfPath = file.path;
      pdfReady = true;
      onStateChanged();
    } catch (e) {
      print('PDF loading error: $e');
    }
  }

  Future<void> nextPage() async {
    if (pdfViewController != null && currentPage < totalPages - 1) {
      await pdfViewController!.setPage(currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (pdfViewController != null && currentPage > 0) {
      await pdfViewController!.setPage(currentPage - 1);
    }
  }

  Future<void> goToFirstPage() async {
    if (pdfViewController != null) {
      await pdfViewController!.setPage(0);
    }
  }

  void onViewCreated(PDFViewController controller) {
    pdfViewController = controller;
  }

  void onRender(int? pages) {
    totalPages = pages ?? 0;
    onStateChanged();
  }

  void onPageChanged(int? page, int? total) {
    currentPage = page ?? 0;
    totalPages = total ?? 0;
    onStateChanged();
  }

  void dispose() {
    // PDF resources are automatically handled
  }
}

// ===== AUDIO CONTROLS (SIMPLE INSIDE TOGGLE) =====
class _AudioControls extends StatelessWidget {
  final AudioManager audioManager;
  final Color categoryColor;

  const _AudioControls({
    required this.audioManager,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInUp(
      Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.05),
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
        ),
        child: Column(
          children: [
            // Time & Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  _formatDuration(audioManager.currentPosition),
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  _formatDuration(audioManager.totalDuration),
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const Gap(8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: categoryColor,
                inactiveTrackColor: categoryColor.withOpacity(0.3),
                thumbColor: categoryColor,
                overlayColor: categoryColor.withOpacity(0.2),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: audioManager.totalDuration.inMilliseconds > 0
                    ? audioManager.currentPosition.inMilliseconds /
                          audioManager.totalDuration.inMilliseconds
                    : 0.0,
                onChanged: (value) {
                  final position = Duration(
                    milliseconds:
                        (value * audioManager.totalDuration.inMilliseconds)
                            .round(),
                  );
                  audioManager.seekTo(position);
                },
              ),
            ),
            const Gap(6),
            // Play / Pause Button only
            Center(
              child: CustomIconBackground(
                onTap: audioManager.togglePlayPause,
                child: audioManager.isLoading
                    ? SizedBox(
                        width: isTablet ? 36 : 32,
                        height: isTablet ? 36 : 32,
                        child: const CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 3,
                        ),
                      )
                    : audioManager.isPlaying
                    ? AppAnimations.pulse(
                        Icon(
                          Icons.pause,
                          color: AppColors.primary,
                          size: isTablet ? 36 : 32,
                        ),
                        infinite: true,
                        duration: const Duration(milliseconds: 1000),
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: AppColors.primary,
                        size: isTablet ? 36 : 32,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class PdfBookFlipLocal extends StatefulWidget {
  const PdfBookFlipLocal({
    super.key,
    this.fitCover = true,
    this.scale = 1.0,
    this.alignment = Alignment.center,
  });
  final bool fitCover;
  final double scale;
  final Alignment alignment;

  @override
  State<PdfBookFlipLocal> createState() => _PdfBookFlipLocalState();
}

class _PdfBookFlipLocalState extends State<PdfBookFlipLocal> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  List<Image> pages = [];

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    final doc = await PdfDocument.openAsset('assets/pdf/OhebAnAkhtar.pdf');

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);

      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );

      if (pageImage != null) {
        pages.add(Image.memory(pageImage.bytes));
      }

      await page.close();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final fit = widget.fitCover ? BoxFit.cover : BoxFit.contain;
        final scaledWidth = width * widget.scale;
        final scaledHeight = height * widget.scale;

        final fullBleedPages = pages.map((img) {
          return SizedBox.expand(
            child: Stack(
              children: [
                FittedBox(
                  fit: fit,
                  alignment: widget.alignment,
                  child: SizedBox(
                    width: scaledWidth,
                    height: scaledHeight,
                    child: img,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.85),
                          AppColors.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();

        return PageFlipWidget(key: _controller, children: fullBleedPages);
      },
    );
  }
}
