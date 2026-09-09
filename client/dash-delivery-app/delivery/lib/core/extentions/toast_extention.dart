
import 'package:delivary_partner/core/extentions/text_style.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
ToastificationType getType(Color color) {
  return switch (color) {
    Colors.green => ToastificationType.success,
    Colors.red => ToastificationType.error,
    Colors.orange => ToastificationType.warning,
    _ => ToastificationType.info,
  };
}

IconData getIcon(Color color) {
  return switch (color) {
    Colors.green => Icons.check_circle,
    Colors.red => Icons.error,
    Colors.orange => Icons.warning,
    _ => Icons.info,
  };
}

extension BuildContextExtensions on BuildContext {
  void successToast(String title, Color color, [String? description]) async {
    // final isSuccess = color == Colors.green;
    toastification.show(
      context: this,
      type: getType(color),
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: FittedBox(
        child: Text(
          title.isNotEmpty ? title : 'Success',
          style: headlineSmall.copyWith(color: Colors.white),
        ),
      ),
      description: description != null
          ? Text(description, style: bodySmall.copyWith(color: Colors.white))
          : null,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 500),
      icon: Icon(getIcon(color), color: Colors.white),
      primaryColor: color,
      backgroundColor: color,
      foregroundColor: Colors.white,
      showIcon: true,
      closeOnClick: true,
      progressBarTheme: const ProgressIndicatorThemeData(color: Colors.white),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: const Color(0x07000000),
          blurRadius: 16,
          offset: const Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.onHover,
        buttonBuilder: (context, onClose) =>
            const Icon(Icons.close, color: Colors.white),
      ),
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
