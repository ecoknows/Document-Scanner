import 'package:flutter/material.dart';

class BaseListTile extends StatelessWidget {
  final Widget? trailing;
  final MainAxisAlignment mainAxisAlignment;

  const BaseListTile({
    super.key,
    required this.trailing,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (trailing != null) trailing!,
      ],
    );
  }
}
