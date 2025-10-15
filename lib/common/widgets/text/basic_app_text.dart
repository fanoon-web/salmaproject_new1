import 'package:flutter/material.dart';

class BasicAppText extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final TextAlign textAlign;
  final Widget? content;
  final TextOverflow? overflow;

  const BasicAppText({
    Key? key,
    this.title,
    this.style,
    this.textAlign = TextAlign.center,
    this.content, this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return content ??
        Text(
          title ?? '',
          textAlign: textAlign,
          style: style ??
              const TextStyle(
                fontFamily: 'Roboto', // 👈 الخط الرسمي المقترح
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 0.3,
              ),
        );
  }
}
