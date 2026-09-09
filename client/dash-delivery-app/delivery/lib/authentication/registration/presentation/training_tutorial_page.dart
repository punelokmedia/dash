import 'package:delivary_partner/authentication/registration/domain/registration_step.dart';
import 'package:delivary_partner/authentication/registration/presentation/documentRequired_page.dart';
import 'package:delivary_partner/authentication/registration/shared/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:video_player/video_player.dart';

// ─── Provider ─────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────
// STATE
// ─────────────────────────────────────────────
class VideoPlayerState {
  final bool isPlaying;
  final bool isInitialized;
  final bool isBuffering;
  final Duration position;
  final Duration duration;

  const VideoPlayerState({
    this.isPlaying = false,
    this.isInitialized = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  VideoPlayerState copyWith({
    bool? isPlaying,
    bool? isInitialized,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
  }) => VideoPlayerState(
    isPlaying: isPlaying ?? this.isPlaying,
    isInitialized: isInitialized ?? this.isInitialized,
    isBuffering: isBuffering ?? this.isBuffering,
    position: position ?? this.position,
    duration: duration ?? this.duration,
  );
}

// ─────────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────────
class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerController? _controller;

  VideoPlayerNotifier() : super(const VideoPlayerState());

  Future<void> init(VideoPlayerController controller) async {
    _controller = controller;
    await controller.initialize();
    state = state.copyWith(
      isInitialized: true,
      duration: controller.value.duration,
    );
    controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    final c = _controller;
    if (c == null) return;
    state = state.copyWith(
      isPlaying: c.value.isPlaying,
      isBuffering: c.value.isBuffering,
      position: c.value.position,
      duration: c.value.duration,
    );
  }

  void togglePlay() {
    final c = _controller;
    if (c == null) return;
    c.value.isPlaying ? c.pause() : c.play();
  }

  void seekTo(Duration position) => _controller?.seekTo(position);

  void rewind10() {
    final c = _controller;
    if (c == null) return;
    final target = c.value.position - const Duration(seconds: 10);
    c.seekTo(target < Duration.zero ? Duration.zero : target);
  }

  void forward10() {
    final c = _controller;
    if (c == null) return;
    final target = c.value.position + const Duration(seconds: 10);
    final dur = c.value.duration;
    c.seekTo(target > dur ? dur : target);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────
final videoPlayerProvider =
    StateNotifierProvider.autoDispose<VideoPlayerNotifier, VideoPlayerState>(
      (ref) => VideoPlayerNotifier(),
    );

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────
String _formatDuration(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class TrainingTutorialPage extends HookConsumerWidget {
  final String videoUrl;
  final bool isAsset;
  final VoidCallback? onSkip;

  const TrainingTutorialPage({
    super.key,
    required this.videoUrl,
    this.isAsset = false,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(videoPlayerProvider.notifier);
    final state = ref.watch(videoPlayerProvider);

    useEffect(() {
      final controller = isAsset
          ? VideoPlayerController.asset(videoUrl)
          : VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      notifier.init(controller);
      return null;
    }, const []);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (onSkip != null) {
              onSkip!();
            } else {
              final currentStep = ref.read(registrationProgressProvider).step;
              if (currentStep == RegistrationStep.kyc) {
                // Brand-new user — start from KYC documents
                await ref
                    .read(registrationProgressProvider.notifier)
                    .advance(RegistrationStep.documentRequiredpage);
              }

              // context.goNamed(AppRoutesName.documetnRequiredPageName);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => documentsRequiredPage()),
              );
            }
          },
          backgroundColor: const Color(0xFF6DBD2E),
          child: const Text('Skip', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ── App Bar (fixed) ───────────────────────────────────
              _TopBar(),
              SizedBox(height: 30.h),

              // ── Video Player (fixed, does NOT scroll) ─────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _VideoCard(state: state, notifier: notifier),
              ),

              SizedBox(height: 20.h),

              // ── Scrollable content below ──────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionBlock(
                        title: 'New Here ?',
                        body:
                            'Simple tutorial to help you get started.\n\nLearn how to create your account and set your location.',
                      ),
                      SizedBox(height: 20.h),
                      _SectionBlock(
                        title: 'Still need help ?',
                        body: 'Visit our help Center or contact support.',
                      ),
                      SizedBox(height: 40.h),
                      // _SkipButton(onTap: onSkip ?? () {}),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.chevron_left,
                size: 28.sp,
                color: const Color(0xFF6DBD2E),
              ),
            ),
          ),
          Text(
            'Training Tutorial',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6DBD2E),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VIDEO CARD
// ─────────────────────────────────────────────
class _VideoCard extends HookConsumerWidget {
  final VideoPlayerState state;
  final VideoPlayerNotifier notifier;

  const _VideoCard({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showControls = useState(true);

    useEffect(() {
      if (state.isPlaying) {
        Future.delayed(const Duration(seconds: 3), () {
          if (state.isPlaying) showControls.value = false;
        });
      } else {
        showControls.value = true;
      }
      return null;
    }, [state.isPlaying]);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () => showControls.value = !showControls.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Video / placeholder ───────────────────────────────
              state.isInitialized
                  ? _VideoView()
                  : Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFF6DBD2E),
                          strokeWidth: 2.w,
                        ),
                      ),
                    ),

              // ── Buffering spinner ─────────────────────────────────
              if (state.isBuffering && state.isInitialized)
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.w,
                ),

              // ── Controls overlay ──────────────────────────────────
              AnimatedOpacity(
                opacity: showControls.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: _ControlsOverlay(state: state, notifier: notifier),
              ),

              // ── Progress bar (always visible) ─────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _ProgressBar(state: state, notifier: notifier),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VIDEO VIEW
// ─────────────────────────────────────────────
class _VideoView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(videoPlayerProvider.notifier)._controller;
    if (controller == null) return const SizedBox.shrink();
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CONTROLS OVERLAY
// ─────────────────────────────────────────────
class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerState state;
  final VideoPlayerNotifier notifier;

  const _ControlsOverlay({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.15),
            Colors.black.withOpacity(0.50),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ControlBtn(icon: Icons.replay_10_rounded, onTap: notifier.rewind10),
          SizedBox(width: 24.w),
          GestureDetector(
            onTap: notifier.togglePlay,
            child: Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Icon(
                state.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 32.sp,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 24.w),
          _ControlBtn(
            icon: Icons.forward_10_rounded,
            onTap: notifier.forward10,
          ),
        ],
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 30.sp, color: Colors.white),
    );
  }
}

// ─────────────────────────────────────────────
// PROGRESS BAR
// ─────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final VideoPlayerState state;
  final VideoPlayerNotifier notifier;

  const _ProgressBar({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final total = state.duration.inMilliseconds.toDouble();
    final current = state.position.inMilliseconds.toDouble().clamp(
      0.0,
      total == 0 ? 1.0 : total,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 10.w, right: 10.w),
      child: Row(
        children: [
          Text(
            _formatDuration(state.position),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2.5.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                activeTrackColor: const Color(0xFF6DBD2E),
                inactiveTrackColor: Colors.white38,
                thumbColor: const Color(0xFF6DBD2E),
                overlayColor: const Color(0xFF6DBD2E).withOpacity(0.2),
              ),
              child: Slider(
                value: current,
                min: 0,
                max: total == 0 ? 1 : total,
                onChanged: (v) =>
                    notifier.seekTo(Duration(milliseconds: v.toInt())),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            _formatDuration(state.duration),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION BLOCK
// ─────────────────────────────────────────────
class _SectionBlock extends StatelessWidget {
  final String title;
  final String body;

  const _SectionBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          body,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF555555),
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SKIP BUTTON
// ─────────────────────────────────────────────
class _SkipButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
