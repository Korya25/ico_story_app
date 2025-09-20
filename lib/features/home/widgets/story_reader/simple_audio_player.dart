import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';

class SimpleAudioPlayer extends StatefulWidget {
  final String audioPath;
  final VoidCallback? onPlayPause;

  const SimpleAudioPlayer({
    super.key,
    required this.audioPath,
    this.onPlayPause,
  });

  @override
  State<SimpleAudioPlayer> createState() => _SimpleAudioPlayerState();
}

class _SimpleAudioPlayerState extends State<SimpleAudioPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Stream subscriptions
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;

  bool isPlaying = false;
  bool isLoading = true;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource(widget.audioPath));

      _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
        if (mounted) {
          setState(() {
            totalDuration = duration;
            isLoading = false;
          });
        }
      });

      _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
        if (mounted) {
          setState(() {
            currentPosition = position;
          });
        }
      });

      _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state == PlayerState.playing;
          });
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions first
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _stateSubscription?.cancel();

    // Then dispose the audio player
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
      widget.onPlayPause?.call();
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause Button
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Progress Bar
          SizedBox(
            width: 200,
            child: Slider(
              value: totalDuration.inMilliseconds > 0
                  ? currentPosition.inMilliseconds /
                        totalDuration.inMilliseconds
                  : 0.0,
              onChanged: (value) {
                final position = Duration(
                  milliseconds: (value * totalDuration.inMilliseconds).round(),
                );
                _audioPlayer.seek(position);
              },
              activeColor: AppColors.white,
              inactiveColor: AppColors.white.withOpacity(0.3),
            ),
          ),
          // Time Display
          Text(
            '${_formatTime(currentPosition)} / ${_formatTime(totalDuration)}',
            style: const TextStyle(color: AppColors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
