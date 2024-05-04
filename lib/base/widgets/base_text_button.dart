import 'package:flutter/material.dart';

class BaseTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final ButtonStyle? style;

  const BaseTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: style,
      child: Text(
        text,
      ),
    );
  }
}
