import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gtaos/utils/colors.dart'; // Ensure Appcolors.primary2 is defined

// class GradientScaffold extends StatelessWidget {
//   final Widget child;
//   final bool resizeToAvoidBottomInset;
//   const GradientScaffold({
//     Key? key,
//     required this.child,
//     this.resizeToAvoidBottomInset = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: resizeToAvoidBottomInset,
//       body: Stack(
//         children: [
//           // Wave background
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: ClipPath(
//               clipper: WaveClipper(),
//               child: Container(
//                 height: 220,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                      Color(0xFF89c236),  // primary2
//     Color(0xFFa7d74f),  // light green
//     Color(0xFFc9f39f),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SafeArea(child: child),
//         ],
//       ),
//     );
//   }
// }

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final bool resizeToAvoidBottomInset;

  const GradientScaffold({
    Key? key,
    required this.child,
    this.resizeToAvoidBottomInset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          // 🌈 Fullscreen Gradient Background
          Container(
            // padding: EdgeInsets.fromLTRB(0, 10, 0, ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF89c236), // primary2
                  Color(0xFFa7d74f), // light green
                  Color(0xFFc9f39f),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
           child:  Image.asset(
                            'asset/Login-Screen-TOP.png',
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height /2.5,
                            fit: BoxFit.cover,
                          ),
          ),

          // 🧊 Glassmorphism effect
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          //   child: Container(
          //     color: Colors.white.withOpacity(0.05),
          //      // Adjust opacity for glass look
          //   ),
             
          // ),

          // 🔒 Safe content area
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.75);

    path.cubicTo(
      size.width * 0.25, size.height,
      size.width * 0.75, size.height * 0.5,
      size.width, size.height * 0.75,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class ClassicWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
