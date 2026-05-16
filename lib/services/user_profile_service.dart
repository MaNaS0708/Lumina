import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<AppUser?> watchUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return null;
      }

      return AppUser.fromFirestore(snapshot.id, data);
    });
  }
}
