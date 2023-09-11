import 'package:flutter/material.dart';

class AuthenticationTextField extends StatefulWidget {
  const AuthenticationTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    required this.isPassword,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool isPassword;

  @override
  State<AuthenticationTextField> createState() =>
      _AuthenticationTextFieldState();
}

class _AuthenticationTextFieldState extends State<AuthenticationTextField> {
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscureText : false,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: widget.keyboardType,
      textAlignVertical: widget.isPassword ? TextAlignVertical.center : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.only(
          left: 8.0,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                icon: const Icon(Icons.remove_red_eye),
              )
            : null,
      ),
    );
  }
}
