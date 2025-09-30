// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/managers/audio_manager.dart';

class AudioControls extends StatefulWidget {
  final AudioManager audioManager;
  final Color categoryColor;

  const AudioControls({
    super.key,
    required this.audioManager,
    required this.categoryColor,
  });

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls>
    with TickerProviderStateMixin {
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  bool _isSliderDragging = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    if (widget.audioManager.isPlaying) {
      _waveController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _updateAnimations() {
    if (widget.audioManager.isPlaying) {
      _waveController.repeat(reverse: true);
    } else {
      _waveController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    _updateAnimations();

    return AppAnimations.slideInUp(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.categoryColor.withOpacity(0.9),
              AppColors.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTablet ? 24 : 20),
            topRight: Radius.circular(isTablet ? 24 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.categoryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Title Section with Wave Animation
            _buildTitleSection(isTablet),
            Gap(isTablet ? 20 : 16),

            // Time Display
            _buildTimeDisplay(isTablet),
            Gap(isTablet ? 16 : 12),

            // Progress Slider
            _buildProgressSlider(isTablet),
            Gap(isTablet ? 20 : 16),

            // Control Buttons
            _buildControlButtons(isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(bool isTablet) {
    return Row(
      children: [
        // Audio Wave Indicator
        AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return Row(
              children: List.generate(3, (index) {
                final delay = index * 0.2;
                final animationValue = (_waveAnimation.value + delay) % 1.0;
                return Container(
                  width: 3,
                  height: 16 + (8 * animationValue),
                  margin: const EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    color: widget.audioManager.isPlaying
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            );
          },
        ),
        const Gap(12),
        Spacer(),
        // Volume Indicator
        Icon(
          widget.audioManager.isPlaying ? Icons.volume_up : Icons.volume_off,
          color: AppColors.textPrimary.withOpacity(0.8),
          size: isTablet ? 22 : 20,
        ),
      ],
    );
  }

  Widget _buildTimeDisplay(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeText(
            _formatDuration(
              _isSliderDragging
                  ? Duration(
                      milliseconds:
                          (_sliderValue *
                                  widget
                                      .audioManager
                                      .totalDuration
                                      .inMilliseconds)
                              .round(),
                    )
                  : widget.audioManager.currentPosition,
            ),
            isTablet,
            'الحالي',
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 8,
              vertical: isTablet ? 6 : 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
            ),
            child: Icon(
              Icons.headphones,
              color: Colors.white,
              size: isTablet ? 18 : 16,
            ),
          ),
          _buildTimeText(
            _formatDuration(widget.audioManager.totalDuration),
            isTablet,
            'الاجمالي',
          ),
        ],
      ),
    );
  }

  Widget _buildTimeText(String time, bool isTablet, String label) {
    return Column(
      children: [
        CustomText(
          time,
          fontSize: isTablet ? 18 : 16,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          label,
          fontSize: isTablet ? 12 : 10,
          color: Colors.white.withOpacity(0.7),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildProgressSlider(bool isTablet) {
    final progress = widget.audioManager.totalDuration.inMilliseconds > 0
        ? widget.audioManager.currentPosition.inMilliseconds /
              widget.audioManager.totalDuration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.1),
            trackHeight: isTablet ? 6 : 4,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: isTablet ? 12 : 10,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: isTablet ? 20 : 16,
            ),
          ),
          child: Slider(
            value: _isSliderDragging ? _sliderValue : progress,
            onChangeStart: (value) {
              setState(() {
                _isSliderDragging = true;
                _sliderValue = value;
              });
              HapticFeedback.lightImpact();
            },
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
            onChangeEnd: (value) {
              final position = Duration(
                milliseconds:
                    (value * widget.audioManager.totalDuration.inMilliseconds)
                        .round(),
              );
              widget.audioManager.seekTo(position);
              setState(() {
                _isSliderDragging = false;
              });
              HapticFeedback.selectionClick();
            },
          ),
        ),
        // Progress Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final dotProgress = (index + 1) / 5;
            final isActive = progress >= dotProgress;
            return Container(
              width: isTablet ? 8 : 6,
              height: isTablet ? 8 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildControlButtons(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Rewind Button
        _buildSecondaryButton(
          icon: Icons.replay_10,
          onTap: () {
            final newPosition =
                widget.audioManager.currentPosition -
                const Duration(seconds: 10);
            widget.audioManager.seekTo(newPosition);
            HapticFeedback.lightImpact();
          },
          isTablet: isTablet,
        ),

        // Main Play/Pause Button
        GestureDetector(
          onTapDown: (_) {
            _playButtonController.forward();
          },
          onTapUp: (_) {
            _playButtonController.reverse();
          },
          onTapCancel: () {
            _playButtonController.reverse();
          },
          onTap: () {
            widget.audioManager.togglePlayPause();
            HapticFeedback.mediumImpact();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: isTablet ? 70 : 60,
                  height: isTablet ? 70 : 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.audioManager.isLoading
                      ? Center(
                          child: SizedBox(
                            width: isTablet ? 28 : 24,
                            height: isTablet ? 28 : 24,
                            child: CircularProgressIndicator(
                              color: widget.categoryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : Icon(
                          widget.audioManager.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: widget.categoryColor,
                          size: isTablet ? 36 : 32,
                        ),
                ),
              );
            },
          ),
        ),

        // Forward Button
        _buildSecondaryButton(
          icon: Icons.forward_10,
          onTap: () {
            final newPosition =
                widget.audioManager.currentPosition +
                const Duration(seconds: 10);
            widget.audioManager.seekTo(newPosition);
            HapticFeedback.lightImpact();
          },
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTablet ? 50 : 44,
        height: isTablet ? 50 : 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: isTablet ? 24 : 22),
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
