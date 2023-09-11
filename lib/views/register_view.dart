import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/authentication_text_field.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmationPassword;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
    _confirmationPassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _email.dispose();
    _password.dispose();
    _confirmationPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'Weak Password',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'Email already in use',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid email',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Failed to register',
            );
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
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                'Register',
                style: GoogleFonts.notoSans(color: Colors.white),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                0.0,
                30.0,
                0.0,
                15.0,
              ),
              child: Text(
                'Type an email and password to register',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            AuthenticationTextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              isPassword: false,
            ),
            AuthenticationTextField(
              controller: _password,
              keyboardType: TextInputType.text,
              hintText: 'Password',
              isPassword: true,
            ),
            AuthenticationTextField(
              controller: _confirmationPassword,
              keyboardType: TextInputType.text,
              hintText: 'Confirm password',
              isPassword: true,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                final confirmationPassword = _confirmationPassword.text;

                if (password != confirmationPassword) {
                  if (mounted) {
                    await showErrorDialog(
                      context,
                      "The passwords don't match",
                    );
                  }
                } else {
                  context.read<AuthBloc>().add(
                        AuthEventRegister(
                          email,
                          password,
                        ),
                      );
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  top: 15,
                ),
                child: Text('Register'),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
