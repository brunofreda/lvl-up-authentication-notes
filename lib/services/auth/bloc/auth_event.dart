import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventRegister extends AuthEvent {
  const AuthEventRegister(
    this.email,
    this.password,
  );

  final String email;
  final String password;
}

class AuthEventLogIn extends AuthEvent {
  const AuthEventLogIn(
    this.email,
    this.password,
  );

  final String email;
  final String password;
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventForgotPassword extends AuthEvent {
  const AuthEventForgotPassword({this.email});

  final String? email;
}
