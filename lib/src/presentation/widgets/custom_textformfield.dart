import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hint;
  final String? label;
  final bool value;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final double height;
  final double hintFontSize;
  final FocusNode? focusnode;
  final bool? focus;
  String? Function(String?)? validator;
  final void Function(String)? onChanged;

  CustomTextFormField({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    required this.value,
    required this.suffixIcon,
    this.height = 40,
    this.hintFontSize = 14,
    this.onChanged,
    this.focusnode,
    this.validator,
    this.focus,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.value,
      autofocus: widget.focus!,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
          focusColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          fillColor: Colors.grey,
          hintText: widget.hint,
          //make hint text
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: widget.hintFontSize,
            fontWeight: FontWeight.w400,
          ),
          //create lable
          labelText: widget.label,
          //lable style
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: widget.suffixIcon),
    );
  }
}
