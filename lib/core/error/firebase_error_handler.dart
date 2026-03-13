import 'package:firebase_auth/firebase_auth.dart';
import '../../core/utils/logger.dart';

class FirebaseErrorHandler {
  static String getMessage(Object error) {
    AppLogger.e('Error handled: $error');

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'This email is already registered. Try logging in.';
        case 'invalid-email':
          return 'The email format is incorrect.';
        case 'weak-password':
          return 'Your password is too weak. Use at least 6 characters.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'No internet connection. Please check your network.';
        case 'invalid-credential':
          return 'Invalid login details. Please check and try again.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'Check your internet connection and try again.';
    }

    if (errorString.contains('permission-denied')) {
      return 'You do not have permission to perform this action.';
    }

    if (errorString.contains('not-found')) {
      return 'The requested information was not found.';
    }

    if (errorString.contains('deadline-exceeded') ||
        errorString.contains('timeout')) {
      return 'The request timed out. Please try again.';
    }

    return 'Something went wrong. Please try again later.';
  }
}
