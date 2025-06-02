import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Lottie.asset(
            'asset/loader.json',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void showError(String message) {
    // For now, we'll just show a snackbar with the error message
    // You can customize this to show a more sophisticated error UI if needed
    if (_overlayEntry != null) {
      dismiss();
    }
    // Note: This requires a BuildContext, so you'll need to pass it as a parameter
    // or use a different approach to show errors
  }
} 