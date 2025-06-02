import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LoadingWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'asset/loader.json',
        width: width ?? 50,
        height: height ?? 50,
        fit: BoxFit.contain,
      ),
    );
  }
} 