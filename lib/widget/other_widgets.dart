import 'package:flutter/material.dart';

class BigTitle extends StatelessWidget {
  final String text;
  const BigTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final Color color, shadowColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double width;
  final void Function()? onTap;
  const AppButton({
    Key? key,
    required this.text,
    this.textColor,
    required this.color,
    required this.shadowColor,
    required this.onTap,
    this.textStyle,
    this.width = 220,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(text, style: textStyle ?? TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          elevation: 2,

          shadowColor: shadowColor,
          shape: const StadiumBorder(),
         
          backgroundColor: color,
        ),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;

  const ImagePlaceholder(
      {Key? key, required this.size, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Colors.grey[400]!, style: BorderStyle.solid),
        ),
        child:  Icon(Icons.add, color: Colors.grey[400]!, size: size / 2),
      ),
    );
  }
}
