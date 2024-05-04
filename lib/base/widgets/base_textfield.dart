import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BaseTextFieldType { number, text, textWithNoSymbols }

class BaseTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String? prefix;
  final BaseTextFieldType type;
  final bool obscureText;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const BaseTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.type,
    this.prefix,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      onChanged: onChanged,
      inputFormatters: type == BaseTextFieldType.text
          ? null
          : [
              if (type == BaseTextFieldType.number)
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*'))
              else if (type == BaseTextFieldType.textWithNoSymbols)
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
            ],
      decoration: InputDecoration(
        prefix: prefix != null
            ? Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Text(prefix!),
              )
            : null,
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        hintText: hint,
      ),
    );
  }
}
