import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/organization.dart';

class OrganizationService {
  OrganizationService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<Organization>> watchOrganizations() {
    return _firestore
        .collection('organizations')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Organization.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<Organization> resolveOrganizationForSignup({
    required AppRole role,
    required String organizationName,
    required String uid,
  }) async {
    final slug = organizationSlugFromName(organizationName);

    if (slug.length < 2) {
      throw const OrganizationFailure('Enter a valid company name.');
    }

    final existing = await _findBySlug(slug);

    if (existing != null) {
      return existing;
    }

    if (role != AppRole.admin) {
      throw const OrganizationFailure(
        'Only an admin can create a new company. Please select an existing company.',
      );
    }

    return _createOrganization(
      slug: slug,
      name: organizationName,
      createdBy: uid,
    );
  }

  Future<Organization?> _findBySlug(String slug) async {
    final snapshot = await _firestore
        .collection('organizations')
        .doc(slug)
        .get();
    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      return null;
    }

    return Organization.fromFirestore(snapshot.id, data);
  }

  Future<Organization> _createOrganization({
    required String slug,
    required String name,
    required String createdBy,
  }) async {
    final reference = _firestore.collection('organizations').doc(slug);

    await reference.set({
      'name': name.trim(),
      'slug': slug,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return Organization(
      id: slug,
      name: name.trim(),
      slug: slug,
      createdBy: createdBy,
    );
  }
}

class OrganizationFailure implements Exception {
  const OrganizationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
