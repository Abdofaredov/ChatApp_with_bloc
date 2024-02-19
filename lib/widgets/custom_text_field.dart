import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({
    super.key,
    this.hintText,
    this.onChanged,
    this.isPassword = false,
    this.suffix,
    this.prefix,
    this.suffixPressed,
  });
  Function(String)? onChanged;
  String? hintText;
  IconData? suffix;
  IconData? prefix;
  Function? Function()? suffixPressed;

  bool? isPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'field is required';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        prefix: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
