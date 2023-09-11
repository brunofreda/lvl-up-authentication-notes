import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final user = AuthService.firebase().currentUser;
  bool _isVerificationClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Verify email',
              style: GoogleFonts.notoSans(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
            ),
            child: Text(
              'A verification email has been sent to ${user?.email}',
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Before being able to log in you need to verify your email.\nIf '
              "you haven't received a verification link after some time you can"
              ' click the button below to send it.',
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );

              setState(() {
                _isVerificationClicked = true;
              });
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Go back')),
          Visibility(
            visible: _isVerificationClicked,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Verification link sent to ${user?.email}! Check your email.',
                style: TextStyle(
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
