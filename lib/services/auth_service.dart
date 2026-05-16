import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'organization_service.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    OrganizationService? organizationService,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _organizationService = organizationService ?? OrganizationService();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final OrganizationService _organizationService;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String organizationName,
    required AppRole role,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanOrganization = organizationName.trim();

    if (cleanName.length < 2) {
      throw const AuthFailure('Please enter your full name.');
    }

    if (!cleanEmail.contains('@')) {
      throw const AuthFailure('Please enter a valid email address.');
    }

    if (password.length < 8) {
      throw const AuthFailure('Password must be at least 8 characters.');
    }

    if (cleanOrganization.length < 2) {
      throw const AuthFailure('Please enter or select your company.');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AuthFailure('Could not create account. Please try again.');
      }

      await user.updateDisplayName(cleanName);

      final organization = await _organizationService
          .resolveOrganizationForSignup(
            role: role,
            organizationName: cleanOrganization,
            uid: user.uid,
          );

      await _createUserDocumentIfMissing(
        uid: user.uid,
        name: cleanName,
        email: cleanEmail,
        role: role,
        organizationId: organization.id,
        organizationName: organization.name,
      );

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageForFirebaseAuthError(error));
    } on OrganizationFailure catch (error) {
      throw AuthFailure(error.message);
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AuthFailure('Could not sign in. Please try again.');
      }

      await user.reload();

      final refreshedUser = _auth.currentUser;

      if (refreshedUser == null) {
        throw const AuthFailure('Could not refresh account. Please try again.');
      }

      if (!refreshedUser.emailVerified) {
        await refreshedUser.sendEmailVerification();
        throw const AuthFailure(
          'Please verify your email first. We sent a new verification email.',
        );
      }

      await _markEmailVerified(refreshedUser.uid);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageForFirebaseAuthError(error));
    }
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw const AuthFailure('Please sign in before requesting verification.');
    }

    await user.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();

    if (!cleanEmail.contains('@')) {
      throw const AuthFailure('Please enter a valid email address.');
    }

    try {
      await _auth.sendPasswordResetEmail(email: cleanEmail);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageForFirebaseAuthError(error));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _createUserDocumentIfMissing({
    required String uid,
    required String name,
    required String email,
    required AppRole role,
    required String organizationId,
    required String organizationName,
  }) async {
    final reference = _firestore.collection('users').doc(uid);
    final snapshot = await reference.get();

    if (snapshot.exists) {
      return;
    }

    await reference.set({
      'uid': uid,
      'displayName': name,
      'email': email,
      'emailVerified': false,
      'role': role.firestoreValue,
      'status': role == AppRole.admin ? 'active' : 'pending',
      'departmentId': null,
      'departmentName': 'Unassigned',
      'managerId': null,
      'managerName': 'Unassigned',
      'organizationId': organizationId,
      'organizationName': organizationName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _markEmailVerified(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'emailVerified': true,
      'status': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _messageForFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
