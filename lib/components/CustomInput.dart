import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final bool? obsecureText;
  final String? Function(String?)? validator;
  const CustomInput(
      {Key? key,
      required this.prefixIcon,
      required this.label,
      this.obsecureText,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.white),
      child: TextFormField(
        validator: validator,
        obscureText: obsecureText ?? false,
        maxLines: 1,
        decoration: InputDecoration(
          fillColor: Colors.white,
          label: Text(
            label,
            style: const TextStyle(fontFamily: "montserrat"),
          ),
          // hintText: 'اسم المستخدم',
          prefixIcon: Icon(prefixIcon),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
          ),
        ),
      ),
    );
  }
}
