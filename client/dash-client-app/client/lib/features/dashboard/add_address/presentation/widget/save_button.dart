import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ── Green save button ─────────────────────────────────────────────────────────
class SaveButton extends StatelessWidget {
  final bool         isSaving;
  final VoidCallback onTap;
  final String       label;

  const SaveButton({
    super.key,
    required this.isSaving,
    required this.onTap,
    this.label = 'Save Address',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isSaving ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:         AppColors.lemon,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          elevation: 0,
        ),
        child: isSaving
            ? SizedBox(
                width: 22.r, height: 22.r,
                child: const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize:   16.sp,
                  fontWeight: FontWeight.w700,
                  color:      Colors.white,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                ),
              ),
      ),
    );
  }
}

// ── Collapsible JSON payload preview ─────────────────────────────────────────
class PayloadPreview extends StatefulWidget {
  final Map<String, dynamic> payload;
  const PayloadPreview({super.key, required this.payload});

  @override
  State<PayloadPreview> createState() => _PayloadPreviewState();
}

class _PayloadPreviewState extends State<PayloadPreview> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final json = widget.payload.entries
        .map((e) => '  "${e.key}": "${e.value}"')
        .join(',\n');

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        width:   double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color:        Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10.r),
          border:       Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, size: 14.r, color: Colors.grey.shade500),
                SizedBox(width: 6.w),
                Text(
                  'Payload preview  (tap to ${_expanded ? "collapse" : "expand"})',
                  style: TextStyle(
                    fontSize:   11.sp,
                    color:      Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              SizedBox(height: 8.h),
              Text(
                '{\n$json\n}',
                style: TextStyle(
                  fontSize:   11.sp,
                  color:      Colors.black87,
                  fontFamily: 'monospace',
                  height:     1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}