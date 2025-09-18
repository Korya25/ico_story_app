// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// ===== MAIN STORY READER SCREEN =====
class StoryReaderView extends StatefulWidget {
  final String storyTitle;
  final String pdfAssetPath;
  final String audioAssetPath;
  final Color categoryColor;

  const StoryReaderView({
    super.key,
    this.storyTitle = 'أحب ان أختار',
    this.pdfAssetPath = 'assets/pdf/OhebAnAkhtar.pdf',
    this.audioAssetPath = 'audio/OhebAnAkhtar.mp3',
    this.categoryColor = AppColors.primary,
  });

  @override
  State<StoryReaderView> createState() => _StoryReaderViewState();
}

class _StoryReaderViewState extends State<StoryReaderView>
    with TickerProviderStateMixin {
  // Audio Manager
  late AudioManager _audioManager;

  // PDF Manager
  late PDFManager _pdfManager;

  // Animation Controllers
  late AnimationController _waveController;

  // State
  bool _showAudioControls = false;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: widget.categoryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Simple Header for Children
            _ChildFriendlyHeader(
              storyTitle: widget.storyTitle,
              currentPage: _pdfManager.currentPage,
              totalPages: _pdfManager.totalPages,
              isPlaying: _audioManager.isPlaying,
              onBackPressed: () => Navigator.pop(context),
              onAudioToggle: () => setState(() {
                _showAudioControls = !_showAudioControls;
              }),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                margin: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // PDF Viewer - Main Content
                      Expanded(
                        child: _OptimizedPDFViewer(
                          pdfManager: _pdfManager,
                          categoryColor: widget.categoryColor,
                          onTap: _audioManager.togglePlayPause,
                          onSwipeLeft: _pdfManager.nextPage,
                          onSwipeRight: _pdfManager.previousPage,
                        ),
                      ),

                      // Simple Play Control for Children
                      _SimpleAudioControl(
                        audioManager: _audioManager,
                        categoryColor: widget.categoryColor,
                        onToggleControls: () => setState(() {
                          _showAudioControls = !_showAudioControls;
                        }),
                      ),

                      // Advanced Audio Controls (Hidden by default)
                      if (_showAudioControls)
                        _AdvancedAudioControls(
                          audioManager: _audioManager,
                          pdfManager: _pdfManager,
                          categoryColor: widget.categoryColor,
                        ),
                    ],
                  ),
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
    playbackSpeed = speed;
    await _audioPlayer.setPlaybackRate(speed);
    onStateChanged();
  }

  Future<void> setVolume(double vol) async {
    volume = vol;
    await _audioPlayer.setVolume(vol);
    onStateChanged();
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

// ===== CHILD-FRIENDLY HEADER =====
class _ChildFriendlyHeader extends StatelessWidget {
  final String storyTitle;
  final int currentPage;
  final int totalPages;
  final bool isPlaying;
  final VoidCallback onBackPressed;
  final VoidCallback onAudioToggle;

  const _ChildFriendlyHeader({
    required this.storyTitle,
    required this.currentPage,
    required this.totalPages,
    required this.isPlaying,
    required this.onBackPressed,
    required this.onAudioToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInDown(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            // Big, Friendly Back Button
            GestureDetector(
              onTap: onBackPressed,
              child: Container(
                padding: EdgeInsets.all(isTablet ? 15 : 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primary,
                  size: isTablet ? 28 : 24,
                ),
              ),
            ),

            Gap(isTablet ? 16 : 12),

            // Story Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    storyTitle,
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  if (totalPages > 0) ...[
                    Gap(4),
                    CustomText(
                      'صفحة ${currentPage + 1} من $totalPages',
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ],
                ],
              ),
            ),

            // Audio Status - Big and Clear
            GestureDetector(
              onTap: onAudioToggle,
              child: Container(
                padding: EdgeInsets.all(isTablet ? 15 : 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.volume_up : Icons.volume_off,
                  color: isPlaying ? Colors.green : AppColors.textSecondary,
                  size: isTablet ? 28 : 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== OPTIMIZED PDF VIEWER =====
class _OptimizedPDFViewer extends StatelessWidget {
  final PDFManager pdfManager;
  final Color categoryColor;
  final VoidCallback onTap;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const _OptimizedPDFViewer({
    required this.pdfManager,
    required this.categoryColor,
    required this.onTap,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!pdfManager.pdfReady || pdfManager.localPdfPath == null) {
      return _buildLoadingState();
    }

    return AppAnimations.fadeIn(
      GestureDetector(
        onTap: onTap,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < -50) {
              onSwipeLeft();
            } else if (details.primaryVelocity! > 50) {
              onSwipeRight();
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: categoryColor.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PDFView(
              filePath: pdfManager.localPdfPath!,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              enableSwipe: true,
              onViewCreated: pdfManager.onViewCreated,
              onRender: pdfManager.onRender,
              onPageChanged: pdfManager.onPageChanged,
              onError: (error) => print('PDF Error: $error'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: AppAnimations.bounceIn(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAnimations.spin(
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.menu_book, size: 60, color: categoryColor),
              ),
              duration: const Duration(seconds: 2),
              infinite: true,
            ),
            const Gap(20),
            CustomText(
              'جاري تحميل القصة...',
              fontSize: 18,
              color: categoryColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

// ===== SIMPLE AUDIO CONTROL FOR CHILDREN =====
class _SimpleAudioControl extends StatelessWidget {
  final AudioManager audioManager;
  final Color categoryColor;
  final VoidCallback onToggleControls;

  const _SimpleAudioControl({
    required this.audioManager,
    required this.categoryColor,
    required this.onToggleControls,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInUp(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              categoryColor.withOpacity(0.1),
              categoryColor.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous Page - Big Button
            _buildBigButton(
              icon: Icons.skip_previous,
              onTap: () {}, // Will be handled by PDF manager
              size: isTablet ? 50 : 45,
            ),

            // Play/Pause - Biggest Button
            GestureDetector(
              onTap: audioManager.togglePlayPause,
              child: Container(
                padding: EdgeInsets.all(isTablet ? 20 : 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [categoryColor, categoryColor.withOpacity(0.8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: categoryColor.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: audioManager.isLoading
                    ? SizedBox(
                        width: isTablet ? 36 : 32,
                        height: isTablet ? 36 : 32,
                        child: const CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : audioManager.isPlaying
                    ? AppAnimations.pulse(
                        Icon(
                          Icons.pause,
                          color: AppColors.white,
                          size: isTablet ? 36 : 32,
                        ),
                        infinite: true,
                        duration: const Duration(milliseconds: 1000),
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: AppColors.white,
                        size: isTablet ? 36 : 32,
                      ),
              ),
            ),

            // Next Page - Big Button
            _buildBigButton(
              icon: Icons.skip_next,
              onTap: () {}, // Will be handled by PDF manager
              size: isTablet ? 50 : 45,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: categoryColor.withOpacity(0.4), width: 2),
        ),
        child: Icon(icon, color: categoryColor, size: size),
      ),
    );
  }
}

// ===== ADVANCED AUDIO CONTROLS (COLLAPSIBLE) =====
class _AdvancedAudioControls extends StatelessWidget {
  final AudioManager audioManager;
  final PDFManager pdfManager;
  final Color categoryColor;

  const _AdvancedAudioControls({
    required this.audioManager,
    required this.pdfManager,
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
            // Progress Bar
            _buildProgressSection(context),
            Gap(isTablet ? 12 : 10),

            // Additional Controls
            _buildAdditionalControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      children: [
        // Time Display
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

        // Progress Slider
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
                    (value * audioManager.totalDuration.inMilliseconds).round(),
              );
              audioManager.seekTo(position);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Speed Control
        _buildControlChip(
          icon: Icons.speed,
          label: '${audioManager.playbackSpeed}x',
          onTap: () => _showSpeedDialog(context),
        ),

        // Volume Control
        _buildControlChip(
          icon: audioManager.volume > 0.5
              ? Icons.volume_up
              : audioManager.volume > 0
              ? Icons.volume_down
              : Icons.volume_off,
          onTap: () => _showVolumeDialog(context),
        ),

        // Restart
        _buildControlChip(
          icon: Icons.restart_alt,
          onTap: () {
            audioManager.restart();
            pdfManager.goToFirstPage();
          },
        ),
      ],
    );
  }

  Widget _buildControlChip({
    required IconData icon,
    String? label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: categoryColor.withOpacity(0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: categoryColor, size: 16),
            if (label != null) ...[
              const Gap(4),
              CustomText(
                label,
                fontSize: 12,
                color: categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          'سرعة التشغيل',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
              .map(
                (speed) => ListTile(
                  title: CustomText(
                    '${speed}x',
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                  leading: Radio<double>(
                    value: speed,
                    groupValue: audioManager.playbackSpeed,
                    activeColor: categoryColor,
                    onChanged: (value) {
                      audioManager.setSpeed(value!);
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showVolumeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          'مستوى الصوت',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: categoryColor,
                  thumbColor: categoryColor,
                ),
                child: Slider(
                  value: audioManager.volume,
                  onChanged: (value) {
                    setStateDialog(() {});
                    audioManager.setVolume(value);
                  },
                ),
              ),
              const Gap(10),
              CustomText(
                '${(audioManager.volume * 100).round()}%',
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText('تم', fontSize: 16, color: categoryColor),
          ),
        ],
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
