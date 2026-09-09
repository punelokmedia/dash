import 'dart:math' as math;

import 'package:delivary_partner/authentication/registration/shared/bank_details_provider.dart';
import 'package:delivary_partner/core/constant/my_colors.dart';
import 'package:delivary_partner/core/extentions/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../authentication/registration/widgets/common_widgets.dart';
import 'qr_scanner_screen.dart';
import '../../../authentication/registration/presentation/process_completed_screen.dart';

class UpiPaymentPage extends HookConsumerWidget {
  const UpiPaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bankDetailsProvider);
    final notifier = ref.read(bankDetailsProvider.notifier);

    // UPI string for QR (standard format)
    final upiString =
        'upi://pay?pa=${state.upiId ?? "user@upi"}&pn=${Uri.encodeComponent(state.holderName ?? "User")}&mc=0000&tid=&tr=&tn=Pay&am=&cu=INR&url=';

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () => Navigator.maybePop(context),
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 24.sp,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Upi Payment',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(20, 174, 92, 1),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      height: 583.h,
                      width: 350.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(169, 169, 169, 0.35),
                        borderRadius: BorderRadius.circular(39.r),
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _UserHeader(
                            name: state.holderName ?? 'Account Holder',
                          ),
                          SizedBox(height: 24.h),
                          _QrCard(upiString: upiString),
                          SizedBox(height: 16.h),
                          Text(
                            'Scan to pay with any UPI app',
                            style: context.headlineMedium.copyWith(
                              fontSize: 18.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _BankInfoRow(
                            bankName: state.bankNameDisplay ?? state.bankName,
                            accountNumber:
                                state.accountNumberDisplay ??
                                state.accountNumber,
                          ),
                          SizedBox(height: 16.h),
                          _UpiIdRow(upiId: state.upiId ?? ''),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            // ── Bottom action bar ──────────────────────────────
            _BottomActionBar(
              onScan: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerPage()),
              ),
              onShare: () => _showShareSheet(context, upiString),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareSheet(BuildContext context, String upiString) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareBottomSheet(upiString: upiString),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────

class _UserHeader extends StatelessWidget {
  final String name;
  const _UserHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.primary.withOpacity(0.15),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'M',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _QrCard extends StatelessWidget {
  final String upiString;
  const _QrCard({required this.upiString});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 297.h,
      width: 291.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── QR Code ──────────────────────────────
          QrImageView(
            data: upiString,
            version: QrVersions.auto,
            size: 250.w,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xFF1A1A1A),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color(0xFF1A1A1A),
            ),
          ),

          // ── Blue corner brackets overlay ─────────
          Positioned.fill(
            child: CustomPaint(
              painter: _ScannerCornerPainter(
                color: const Color(0xFF2196F3),
                cornerLength: 24.w,
                strokeWidth: 3.w,
                radius: 6.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCANNER CORNER PAINTER
// ─────────────────────────────────────────────

class _ScannerCornerPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double strokeWidth;
  final double radius;

  const _ScannerCornerPainter({
    required this.color,
    required this.cornerLength,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final cl = cornerLength;
    final r = radius;

    // ── Top-left ──────────────────────────────
    // vertical arm
    canvas.drawLine(Offset(0, cl), Offset(0, r), paint);
    // arc: center (r, r), from 180° sweep +90°
    canvas.drawArc(
      Rect.fromCircle(center: Offset(r, r), radius: r),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );
    // horizontal arm
    canvas.drawLine(Offset(r, 0), Offset(cl, 0), paint);

    // ── Top-right ─────────────────────────────
    // horizontal arm
    canvas.drawLine(Offset(w - cl, 0), Offset(w - r, 0), paint);
    // arc: center (w-r, r), from 270° sweep +90°
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w - r, r), radius: r),
      3 * math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );
    // vertical arm
    canvas.drawLine(Offset(w, r), Offset(w, cl), paint);

    // ── Bottom-left ───────────────────────────
    // vertical arm
    canvas.drawLine(Offset(0, h - cl), Offset(0, h - r), paint);
    // arc: center (r, h-r), from 180° sweep -90°
    canvas.drawArc(
      Rect.fromCircle(center: Offset(r, h - r), radius: r),
      math.pi,
      -math.pi / 2,
      false,
      paint,
    );
    // horizontal arm
    canvas.drawLine(Offset(r, h), Offset(cl, h), paint);

    // ── Bottom-right ──────────────────────────
    // horizontal arm
    canvas.drawLine(Offset(w - cl, h), Offset(w - r, h), paint);
    // arc: center (w-r, h-r), from 0° sweep +90°
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w - r, h - r), radius: r),
      0,
      math.pi / 2,
      false,
      paint,
    );
    // vertical arm
    canvas.drawLine(Offset(w, h - r), Offset(w, h - cl), paint);
  }

  @override
  bool shouldRepaint(_ScannerCornerPainter old) =>
      old.color != color ||
      old.cornerLength != cornerLength ||
      old.strokeWidth != strokeWidth ||
      old.radius != radius;
}

class _BankInfoRow extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  const _BankInfoRow({required this.bankName, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    // Show last 4 digits only
    final masked = accountNumber.length > 4
        ? '${accountNumber.substring(0, accountNumber.length - 4).replaceAll(RegExp(r'.'), '*')}${accountNumber.substring(accountNumber.length - 4)}'
        : accountNumber;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, size: 14.sp, color: AppColors.textMedium),
        SizedBox(width: 4.w),
        Text(
          '$bankName $masked',
          style: context.headlineMedium.copyWith(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _UpiIdRow extends StatelessWidget {
  final String upiId;
  const _UpiIdRow({required this.upiId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UPI ID',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textLight),
              ),
              SizedBox(height: 2.h),
              Text(
                upiId.isEmpty ? '_' : upiId,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: upiId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('UPI ID copied'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            },
            child: Icon(
              Icons.copy_outlined,
              size: 18.sp,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onScan;
  final VoidCallback onShare;

  const _BottomActionBar({required this.onScan, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
       
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlineButton(
              label: 'Open Scanner',
              prefixIcon: Icon(
                Icons.qr_code_scanner,
                size: 18.sp,
                color: AppColors.textMedium,
              ),
              borderColor: AppColors.border,
              textColor: AppColors.textMedium,
              onTap: onScan,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GreenButton(
              label: 'Share QR Code',
              prefixIcon: Icon(
                Icons.share_outlined,
                size: 16.sp,
                color: Colors.white,
              ),
              onTap: onShare,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARE BOTTOM SHEET
// ─────────────────────────────────────────────
class _ShareBottomSheet extends HookConsumerWidget {
  final String upiString;
  const _ShareBottomSheet({required this.upiString});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bankDetailsProvider);
    final notifier = ref.read(bankDetailsProvider.notifier);

    final shareOptions = [
      (
        icon: Icons.share_outlined,
        label: 'Share QR Code',
        color: AppColors.primary,
      ),
      (
        icon: Icons.wifi_tethering,
        label: 'Share via " Nearby Share "',
        color: AppColors.primary,
      ),
      (
        icon: Icons.phone_android,
        label: 'Share via "Mobile share"',
        color: AppColors.primary,
      ),
    ];

    final apps = [
      (icon: Icons.message, color: const Color(0xFF25D366), label: 'WhatsApp'),
      (icon: Icons.chat, color: const Color(0xFF2979FF), label: 'Messages'),
      (
        icon: Icons.camera_alt,
        color: const Color(0xFFE91E63),
        label: 'Instagram',
      ),
      (icon: Icons.mail, color: const Color(0xFFEA4335), label: 'Gmail'),
      (
        icon: Icons.smart_toy_outlined,
        color: const Color(0xFF1A1A1A),
        label: 'More',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Share options list
          ...shareOptions.map(
            (o) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(o.icon, color: o.color, size: 20.sp),
              ),
              title: Text(
                o.label,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                // Trigger native share here
              },
            ),
          ),

          Divider(height: 24.h),

          // App icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: apps
                .take(4)
                .map(
                  (a) => _AppIcon(
                    icon: a.icon,
                    color: a.color,
                    label: a.label,
                    onTap: () => Navigator.pop(context),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: apps
                .skip(4)
                .map(
                  (a) => _AppIcon(
                    icon: a.icon,
                    color: a.color,
                    label: a.label,
                    onTap: () => Navigator.pop(context),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 16.h),

          // Confirm + complete
          GreenButton(
            label: 'Confirm & Continue',
            isLoading: state.isSubmitting,
            onTap: () async {
              Navigator.pop(context);
              final ok = await notifier.confirmAndComplete();
              if (ok && context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProcessCompletedScreen(),
                  ),
                  (r) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _AppIcon({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}
