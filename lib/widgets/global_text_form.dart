import 'package:flutter/material.dart';

class GlobalTextForm extends StatelessWidget {
  const GlobalTextForm({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.validator,
  });

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9).withOpacity(0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFFEF9F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.03),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(
            color: Color(0xFFFEF9F1),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
        ),
        style: const TextStyle(
          color: Color(0xFFFEF9F1),
        ),
        validator: validator,
      ),
    );
  }
}
