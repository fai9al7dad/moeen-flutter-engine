import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final bool? obsecureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String?)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? autoFocus;
  final Function(String)? onChanged;
  const CustomInput(
      {Key? key,
      required this.prefixIcon,
      required this.controller,
      required this.label,
      this.textInputAction,
      this.onFieldSubmitted,
      this.obsecureText,
      this.keyboardType,
      this.maxLines,
      this.minLines,
      this.maxLength,
      this.autoFocus,
      this.onChanged,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(7)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        validator: validator,
        autofocus: autoFocus ?? false,
        onChanged: onChanged,
        obscureText: obsecureText ?? false,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.background,
          label: Text(
            label,
          ),
          // hintText: 'اسم المستخدم',
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2.0),
          ),
        ),
      ),
    );
  }
}
