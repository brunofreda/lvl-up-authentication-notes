import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();

      test(
        'Should not be initialized to begin with',
        () {
          expect(
            provider.isInitialized,
            false,
          );
        },
      );

      test(
        'Cannot log out if not initialized',
        () {
          expect(
            provider.logOut(),
            throwsA(const TypeMatcher<NotInitializedException>()),
          );
        },
      );

      test(
        'Should be able to initialize',
        () async {
          await provider.initialize();

          expect(
            provider.isInitialized,
            true,
          );
        },
      );

      test(
        'User should be null after initialization',
        () {
          expect(
            provider.currentUser,
            null,
          );
        },
      );

      test(
        'Should be able to initialize in less that 2 seconds',
        () async {
          await provider.initialize();

          expect(
            provider.isInitialized,
            true,
          );
        },
        timeout: const Timeout(Duration(seconds: 2)),
      );

      test(
        'Register should accept a valid email and password',
        () {
          final emailAlreadyInUseUser = provider.register(
            email: 'emailalready@inuse.com',
            password: 'anypassword',
          );

          expect(
            emailAlreadyInUseUser,
            throwsA(const TypeMatcher<EmailAlreadyInUseAuthException>()),
          );

          final invalidEmailUser = provider.register(
            email: 'invalidemail.com',
            password: 'anypassword',
          );

          expect(
            invalidEmailUser,
            throwsA(const TypeMatcher<InvalidEmailAuthException>()),
          );

          final weakPasswordUser = provider.register(
            email: 'any@email.com',
            password: 'wea',
          );

          expect(
            weakPasswordUser,
            throwsA(const TypeMatcher<WeakPasswordAuthException>()),
          );
        },
      );

      test(
        'Register should delegate to logIn function',
        () async {
          final unregisteredEmailUser = provider.register(
            email: 'unregistered@email.com',
            password: 'anypassword',
          );

          expect(
            unregisteredEmailUser,
            throwsA(const TypeMatcher<WrongCredentialsAuthException>()),
          );

          final wrongPasswordUser = provider.register(
            email: 'any@email.com',
            password: 'wrongpassword',
          );

          expect(
            wrongPasswordUser,
            throwsA(const TypeMatcher<WrongCredentialsAuthException>()),
          );

          final user = await provider.register(
            email: 'any@email.com',
            password: 'anypassword',
          );

          expect(
            provider.currentUser,
            user,
          );

          expect(
            user.email,
            provider.currentUser?.email,
          );

          expect(
            user.isEmailVerified,
            false,
          );
        },
      );

      test(
        'Logged user should be able to get verified',
        () {
          provider.sendEmailVerification();

          final user = provider.currentUser;

          expect(
            user,
            isNotNull,
          );

          expect(
            user!.isEmailVerified,
            true,
          );
        },
      );

      test(
        'Should be able to log out and log in again',
        () async {
          await provider.logOut();
          await provider.logIn(
            email: 'any@email.com',
            password: 'anypassword',
          );

          final user = provider.currentUser;

          expect(
            user,
            isNotNull,
          );
        },
      );
    },
  );
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));

    _isInitialized = true;
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'unregistered@email.com') {
      throw WrongCredentialsAuthException();
    }
    if (password == 'wrongpassword') throw WrongCredentialsAuthException();

    const user = AuthUser(
      id: 'anyId',
      email: 'any@email.com',
      isEmailVerified: false,
    );

    _user = user;

    return Future.value(user);
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'emailalready@inuse.com') {
      throw EmailAlreadyInUseAuthException();
    }
    if (email == 'invalidemail.com') throw InvalidEmailAuthException();
    if (password.length < 4) throw WeakPasswordAuthException();

    await Future.delayed(const Duration(seconds: 1));

    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw WrongCredentialsAuthException();

    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();

    final user = _user;

    if (user == null) throw WrongCredentialsAuthException();

    const newUser = AuthUser(
      id: 'anyId',
      email: 'any@email.com',
      isEmailVerified: true,
    );

    _user = newUser;
  }

  @override
  Future<AuthUser> sendPasswordReset({required String toEmail}) async {
    throw UnimplementedError();
  }
}
