import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String email;
  final String id;
  final bool isEmailVerified;
  const AuthUser(
      {required this.id, required this.email, required this.isEmailVerified});
  //taking one object to another
  //here firebase object is passed to authuser
  factory AuthUser.fromFirebase(User user) => AuthUser(
      id: user.uid, email: user.email!, isEmailVerified: user.emailVerified);
}
