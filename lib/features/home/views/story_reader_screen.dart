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
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

// ===== WORKING STORY READER SCREEN =====
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
  // Audio Player
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isLoading = true;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double playbackSpeed = 1.0;
  double volume = 0.8;

  // PDF Viewer
  String? localPdfPath;
  int currentPage = 0;
  int totalPages = 0;
  bool pdfReady = false;
  PDFViewController? pdfViewController;

  // Animation Controllers
  late AnimationController _playButtonController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAudio();
    _loadPdfFromAssets();
  }

  void _initializeControllers() {
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  Future<void> _initializeAudio() async {
    audioPlayer = AudioPlayer();

    try {
      // تحميل الملف الصوتي من assets
      await audioPlayer.setSource(AssetSource(widget.audioAssetPath));

      // الاستماع لتغييرات مدة الصوت
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          totalDuration = duration;
          isLoading = false;
        });
      });

      // الاستماع لتغييرات موقع التشغيل
      audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          currentPosition = position;
        });
      });

      // الاستماع لحالة التشغيل
      audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });

        if (isPlaying) {
          _playButtonController.forward();
        } else {
          _playButtonController.reverse();
        }
      });

      // عند انتهاء التشغيل
      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          isPlaying = false;
          currentPosition = Duration.zero;
        });
        _playButtonController.reverse();
      });
    } catch (e) {
      print('خطأ في تحميل الملف الصوتي: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      final byteData = await rootBundle.load(widget.pdfAssetPath);
      final file = File(
        '${(await getTemporaryDirectory()).path}/${widget.storyTitle}.pdf',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());

      setState(() {
        localPdfPath = file.path;
        pdfReady = true;
      });
    } catch (e) {
      print('خطأ في تحميل ملف PDF: $e');
      // يمكنك عرض رسالة خطأ للمستخدم
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _playButtonController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Main Content
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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // PDF Viewer
                      Expanded(child: _buildPDFViewer(context)),

                      // Audio Control Panel
                      _buildAudioControlPanel(context),
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

  Widget _buildHeader(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInDown(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(isTablet ? 12 : 10),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                  size: isTablet ? 24 : 20,
                ),
              ),
            ),

            Gap(isTablet ? 16 : 12),

            // Story Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    widget.storyTitle,
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  Gap(4),
                  if (totalPages > 0)
                    CustomText(
                      'صفحة ${currentPage + 1} من $totalPages',
                      fontSize: isTablet ? 14 : 12,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                ],
              ),
            ),

            // Audio Status Icon
            if (isLoading)
              AppAnimations.spin(
                Icon(
                  Icons.refresh,
                  color: AppColors.white,
                  size: isTablet ? 24 : 20,
                ),
                duration: Duration(seconds: 1),
                infinite: true,
              )
            else
              Icon(
                isPlaying ? Icons.volume_up : Icons.volume_off,
                color: AppColors.white,
                size: isTablet ? 24 : 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFViewer(BuildContext context) {
    if (!pdfReady || localPdfPath == null) {
      return _buildLoadingPDF();
    }

    return AppAnimations.fadeIn(
      GestureDetector(
        onTap: () {
          // النقر على PDF يوقف/يشغل الصوت
          _togglePlayPause();
        },
        onHorizontalDragEnd: (details) {
          // السحب الأفقي للتنقل بين الصفحات
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < -50) {
              // سحب لليسار - الصفحة التالية
              _nextPage();
            } else if (details.primaryVelocity! > 50) {
              // سحب لليمين - الصفحة السابقة
              _previousPage();
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.categoryColor.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PDFView(
              filePath: localPdfPath!,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              onViewCreated: (PDFViewController pdfViewController) {
                this.pdfViewController = pdfViewController;
              },
              onRender: (pages) {
                setState(() {
                  totalPages = pages ?? 0;
                });
              },
              onPageChanged: (page, total) {
                setState(() {
                  currentPage = page ?? 0;
                  totalPages = total ?? 0;
                });
              },
              onError: (error) {
                print('خطأ في عرض PDF: $error');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPDF() {
    return Center(
      child: AppAnimations.bounceIn(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAnimations.spin(
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.categoryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  size: 60,
                  color: widget.categoryColor,
                ),
              ),
              duration: Duration(seconds: 2),
              infinite: true,
            ),
            Gap(20),
            CustomText(
              'جاري تحميل القصة...',
              fontSize: 16,
              color: widget.categoryColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
            Gap(10),
            Container(
              width: 150,
              height: 4,
              decoration: BoxDecoration(
                color: widget.categoryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: AppAnimations.slideInRight(
                Container(
                  width: 75,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.categoryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                duration: Duration(seconds: 2),
                delay: Duration(milliseconds: 500),
              ),
            ),
          ],
        ),
        delay: Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildAudioControlPanel(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInUp(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.categoryColor.withOpacity(0.1),
              widget.categoryColor.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress Bar
            _buildProgressBar(),
            Gap(isTablet ? 16 : 12),

            // Control Buttons
            _buildControlButtons(),
            Gap(isTablet ? 12 : 8),

            // Additional Controls
            _buildAdditionalControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final isTablet = context.isTablet;

    return Column(
      children: [
        // Time Display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              _formatDuration(currentPosition),
              fontSize: isTablet ? 14 : 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            CustomText(
              _formatDuration(totalDuration),
              fontSize: isTablet ? 14 : 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Gap(8),

        // Progress Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.categoryColor,
            inactiveTrackColor: widget.categoryColor.withOpacity(0.3),
            thumbColor: widget.categoryColor,
            overlayColor: widget.categoryColor.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: totalDuration.inMilliseconds > 0
                ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
                : 0.0,
            onChanged: (value) {
              final position = Duration(
                milliseconds: (value * totalDuration.inMilliseconds).round(),
              );
              _seekTo(position);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    final isTablet = context.isTablet;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Backward 15s
        _buildControlButton(
          icon: Icons.replay_10,
          onTap: () => _seekBackward(Duration(seconds: 15)),
          size: isTablet ? 40 : 35,
        ),

        // Previous Page
        _buildControlButton(
          icon: Icons.skip_previous,
          onTap: _previousPage,
          size: isTablet ? 45 : 40,
        ),

        // Play/Pause
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            padding: EdgeInsets.all(isTablet ? 16 : 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.categoryColor,
                  widget.categoryColor.withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.categoryColor.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: isLoading
                ? SizedBox(
                    width: isTablet ? 32 : 28,
                    height: isTablet ? 32 : 28,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 3,
                    ),
                  )
                : isPlaying
                ? AppAnimations.pulse(
                    Icon(
                      Icons.pause,
                      color: AppColors.white,
                      size: isTablet ? 32 : 28,
                    ),
                    infinite: true,
                    duration: Duration(milliseconds: 1000),
                  )
                : Icon(
                    Icons.play_arrow,
                    color: AppColors.white,
                    size: isTablet ? 32 : 28,
                  ),
          ),
        ),

        // Next Page
        _buildControlButton(
          icon: Icons.skip_next,
          onTap: _nextPage,
          size: isTablet ? 45 : 40,
        ),

        // Forward 15s
        _buildControlButton(
          icon: Icons.forward_5,
          onTap: () => _seekForward(Duration(seconds: 15)),
          size: isTablet ? 40 : 35,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.categoryColor.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.categoryColor.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Icon(icon, color: widget.categoryColor, size: size),
      ),
    );
  }

  Widget _buildAdditionalControls() {
    final isTablet = context.isTablet;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Speed Control
        GestureDetector(
          onTap: _showSpeedDialog,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 10,
              vertical: isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: widget.categoryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.categoryColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.speed,
                  color: widget.categoryColor,
                  size: isTablet ? 18 : 16,
                ),
                Gap(4),
                CustomText(
                  '${playbackSpeed}x',
                  fontSize: isTablet ? 14 : 12,
                  color: widget.categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),

        // Volume Control
        GestureDetector(
          onTap: _showVolumeDialog,
          child: Container(
            padding: EdgeInsets.all(isTablet ? 10 : 8),
            decoration: BoxDecoration(
              color: widget.categoryColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.categoryColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Icon(
              volume > 0.5
                  ? Icons.volume_up
                  : volume > 0
                  ? Icons.volume_down
                  : Icons.volume_off,
              color: widget.categoryColor,
              size: isTablet ? 20 : 18,
            ),
          ),
        ),

        // Restart Story
        GestureDetector(
          onTap: _restartStory,
          child: Container(
            padding: EdgeInsets.all(isTablet ? 10 : 8),
            decoration: BoxDecoration(
              color: widget.categoryColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.categoryColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.restart_alt,
              color: widget.categoryColor,
              size: isTablet ? 20 : 18,
            ),
          ),
        ),
      ],
    );
  }

  // Audio Control Methods
  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.resume();
      }
    } catch (e) {
      print('خطأ في تشغيل/إيقاف الصوت: $e');
    }
  }

  Future<void> _seekTo(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e) {
      print('خطأ في الانتقال إلى الموقع: $e');
    }
  }

  Future<void> _seekForward(Duration duration) async {
    final newPosition = currentPosition + duration;
    if (newPosition < totalDuration) {
      await _seekTo(newPosition);
    }
  }

  Future<void> _seekBackward(Duration duration) async {
    final newPosition = currentPosition - duration;
    if (newPosition > Duration.zero) {
      await _seekTo(newPosition);
    } else {
      await _seekTo(Duration.zero);
    }
  }

  Future<void> _restartStory() async {
    await _seekTo(Duration.zero);
    if (pdfViewController != null) {
      await pdfViewController!.setPage(0);
    }
  }

  // PDF Control Methods
  Future<void> _nextPage() async {
    if (pdfViewController != null && currentPage < totalPages - 1) {
      await pdfViewController!.setPage(currentPage + 1);
    }
  }

  Future<void> _previousPage() async {
    if (pdfViewController != null && currentPage > 0) {
      await pdfViewController!.setPage(currentPage - 1);
    }
  }

  // Dialog Methods
  void _showSpeedDialog() {
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
                    groupValue: playbackSpeed,
                    activeColor: widget.categoryColor,
                    onChanged: (value) {
                      setState(() {
                        playbackSpeed = value!;
                      });
                      audioPlayer.setPlaybackRate(playbackSpeed);
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

  void _showVolumeDialog() {
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
                  activeTrackColor: widget.categoryColor,
                  thumbColor: widget.categoryColor,
                ),
                child: Slider(
                  value: volume,
                  onChanged: (value) {
                    setStateDialog(() {
                      volume = value;
                    });
                    setState(() {
                      volume = value;
                    });
                    audioPlayer.setVolume(volume);
                  },
                ),
              ),
              Gap(10),
              CustomText(
                '${(volume * 100).round()}%',
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
            child: CustomText('تم', fontSize: 16, color: widget.categoryColor),
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
