import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//! Fade & Scale Transition
// class PageTransition extends CustomTransitionPage {
//   PageTransition({required super.child})
//     : super(
//         transitionDuration: const Duration(milliseconds: 400),
//         reverseTransitionDuration: const Duration(milliseconds: 300),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           final curvedAnimation = CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeInOut,
//           );

//           return FadeTransition(
//             opacity: curvedAnimation,
//             child: ScaleTransition(
//               scale: Tween<double>(begin: 0.98, end: 1.0).animate(curvedAnimation),
//               child: child,
//             ),
//           );
//         },
//       );
// }

// !Left to Right Slide Transition

class PageTransition extends CustomTransitionPage {
  PageTransition({required super.child})
    : super(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // from right
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      );
}

// //! Native-like slide transition
// class PageTransition extends CustomTransitionPage {
//   PageTransition({required super.child})
//     : super(
//         transitionDuration: const Duration(milliseconds: 350),
//         reverseTransitionDuration: const Duration(milliseconds: 300),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           final primary = CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeOutCubic,
//             reverseCurve: Curves.easeInCubic,
//           );

//           final secondary = CurvedAnimation(
//             parent: secondaryAnimation,
//             curve: Curves.easeOutCubic,
//             reverseCurve: Curves.easeInCubic,
//           );

//           return Stack(
//             children: [
//               SlideTransition(
//                 position: Tween<Offset>(
//                   begin: Offset.zero,
//                   end: const Offset(-0.3, 0.0),
//                 ).animate(secondary),
//                 child: Container(),
//               ),
//               SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(primary),
//                 child: child,
//               ),
//             ],
//           );
//         },
//       );
 
