import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<Organization?> findBySlug(String slug) async {
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

  Future<Organization> createIfMissing({
    required String name,
    required String createdBy,
  }) async {
    final slug = organizationSlugFromName(name);

    if (slug.length < 2) {
      throw const OrganizationFailure('Enter a valid company name.');
    }

    final reference = _firestore.collection('organizations').doc(slug);
    final snapshot = await reference.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      return Organization.fromFirestore(snapshot.id, data);
    }

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
