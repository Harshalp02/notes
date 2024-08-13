import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);
  //taking one object to another 
  //here firebase object is passed to authuser 
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
