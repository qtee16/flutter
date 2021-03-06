import 'package:flutter_project/service/auth/auth_provider.dart';
import 'package:flutter_project/service/auth/auth_user.dart';
import 'package:flutter_project/service/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider authProvider;

  AuthService(this.authProvider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => authProvider.initialize();

  @override
  Future<AuthUser> createUser({required String email, required String password})
  => authProvider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password})
  => authProvider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => authProvider.logOut();

  @override
  Future<void> sendVerifiedEmail() => authProvider.sendVerifiedEmail();
}