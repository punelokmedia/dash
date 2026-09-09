import 'package:flutter/material.dart';


extension BoxDecorationExtension on BuildContext {
  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(this).cardColor,
    );
  }

  BoxDecoration dialogeboxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(this).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Theme.of(this).dialogTheme.shadowColor ?? Colors.black,
        ),
      ],
    );
  }
}
