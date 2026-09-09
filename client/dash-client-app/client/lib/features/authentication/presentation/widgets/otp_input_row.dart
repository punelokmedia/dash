
import 'package:dash_logistics/features/authentication/presentation/widgets/otpbox.dart';
import 'package:flutter/material.dart';

class OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpInputRow({
    super.key,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    final count = controllers.length.clamp(1, 6);

    return Row(
      // spaceBetween auto-distributes 6 boxes evenly — no overflow
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (i) {
        return OtpBox(
          controller: controllers[i],
          focusNode: focusNodes[i],
          onChanged: (val) {
            if (val.isNotEmpty && i < count - 1) {
              focusNodes[i + 1].requestFocus();
            }
            if (val.isEmpty && i > 0) {
              focusNodes[i - 1].requestFocus();
            }
          },
        );
      }),
    );
  }
}