import 'package:flutter/material.dart';

class RegisterPageAnimations {
  final AnimationController controller;

  late final Animation<Offset> logoAnimation;
  late final Animation<Offset> truckAnimation;
  late final Animation<Offset> cardAnimation;

  RegisterPageAnimations(this.controller) {
    /// LOGO ANIMATION (Top → Down)
    logoAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    /// TRUCK ANIMATION (Right → Left)
    truckAnimation =
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    /// CARD ANIMATION (Bottom → Up)
    cardAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }
}