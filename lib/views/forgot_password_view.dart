import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/authentication_text_field.dart';
import '../utilities/dialogs/error_dialog.dart';
import '../utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();

            await showPasswordResetSentDialog(context);
          }

          if (state.exception is InvalidEmailAuthException) {
            if (mounted) {
              await showErrorDialog(
                context,
                'Invalid email',
              );
            }
          } else if (state.exception is WrongCredentialsAuthException) {
            if (mounted) {
              await showErrorDialog(
                context,
                'Cannot find a user with the entered credentials',
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'LvL Up',
            style: GoogleFonts.notoSans(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10.0),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 6.0,
              ),
              child: Text(
                'Forgot password',
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                30.0,
                40.0,
                30.0,
                20.0,
              ),
              child: Text(
                'Enter your email and a password reset link will be sent',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AuthenticationTextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              isPassword: false,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
              ),
              child: TextButton(
                onPressed: () {
                  final email = _controller.text;

                  context.read<AuthBloc>().add(
                        AuthEventForgotPassword(
                          email: email,
                        ),
                      );
                },
                child: const Text('Send password reset link'),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
