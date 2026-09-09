import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends HookConsumerWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => MobileScannerController());
    final torchOn = useState(false);
    final scanned = useState(false);

    // Animated scan line
    final animCtrl = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    final scanLineAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animCtrl, curve: Curves.linear));

    useEffect(() => controller.dispose, []);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Camera feed ────────────────────────────────────
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (scanned.value) return;
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  scanned.value = true;
                  controller.stop();
                  Navigator.pop(context, barcode.rawValue);
                  break;
                }
              }
            },
          ),

          // ── Dark overlay with cutout ───────────────────────
          CustomPaint(painter: _ScannerOverlayPainter(), child: Container()),

          // ── Animated scan line inside cutout ──────────────
          Center(
            child: SizedBox(
              width: 240.w,
              height: 240.w,
              child: AnimatedBuilder(
                animation: scanLineAnim,
                builder: (_, _) => Stack(
                  children: [
                    // Corner brackets
                    CustomPaint(
                      painter: _CornerBracketPainter(),
                      size: Size(240.w, 240.w),
                    ),
                    // Scan line
                    Positioned(
                      top: scanLineAnim.value * 220.w,
                      left: 10.w,
                      right: 10.w,
                      child: Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withOpacity(0.8),
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Top bar ────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  // Close
                  _IconBtn(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  // Torch
                  _IconBtn(
                    icon: torchOn.value
                        ? Icons.flashlight_on
                        : Icons.flashlight_off,
                    onTap: () {
                      torchOn.value = !torchOn.value;
                      controller.toggleTorch();
                    },
                  ),
                  SizedBox(width: 8.w),
                  // Expand
                  _IconBtn(icon: Icons.fullscreen, onTap: () {}),
                  SizedBox(width: 8.w),
                  // More
                  _IconBtn(icon: Icons.more_vert, onTap: () {}),
                ],
              ),
            ),
          ),

          // ── Bottom bar ─────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Upload from gallery button
                    GestureDetector(
                      onTap: () {
                        // Implement gallery QR picker
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Upload from Gallery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Scan by any QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'STATE BANK OF INDIA',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Icon button for scanner toolbar ──────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}

// ── Overlay painter — dark bg with transparent square cutout ──
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);
    final cutW = 240.0;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: cutW,
      height: cutW,
    );

    // Full background minus the cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Corner bracket painter ────────────────────────────────────
class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.scannerBorder
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 24.0;
    const r = 10.0;

    // Top-left
    canvas.drawPath(
      _cornerPath(Offset(r, 0), Offset(0, r), len, false, false),
      paint,
    );
    // Top-right
    canvas.drawPath(
      _cornerPath(
        Offset(size.width - r, 0),
        Offset(size.width, r),
        len,
        true,
        false,
      ),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      _cornerPath(
        Offset(r, size.height),
        Offset(0, size.height - r),
        len,
        false,
        true,
      ),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      _cornerPath(
        Offset(size.width - r, size.height),
        Offset(size.width, size.height - r),
        len,
        true,
        true,
      ),
      paint,
    );
  }

  Path _cornerPath(
    Offset hStart,
    Offset vStart,
    double len,
    bool flipH,
    bool flipV,
  ) {
    final path = Path();
    final hDir = flipH ? -1.0 : 1.0;
    final vDir = flipV ? -1.0 : 1.0;
    path.moveTo(hStart.dx + len * hDir, hStart.dy);
    path.lineTo(hStart.dx, hStart.dy);
    path.lineTo(vStart.dx, vStart.dy + len * vDir);
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
