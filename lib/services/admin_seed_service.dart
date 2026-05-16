import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSeedService {
  AdminSeedService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> ensureWorkspaceSeed({
    required String organizationId,
    required String organizationName,
    required String requestedBy,
  }) async {
    final batch = _firestore.batch();

    await _createIfMissing(
      batch: batch,
      reference: _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('appConfig')
          .doc('general'),
      data: {
        'appName': 'Lumina',
        'organizationId': organizationId,
        'organizationName': organizationName,
        'activeCycleId': 'fy2026-q1',
        'createdBy': requestedBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('cycles')
          .doc('fy2026-q1'),
      data: {
        'name': 'FY 2026 Q1',
        'status': 'draft',
        'startsAt': Timestamp.fromDate(DateTime.utc(2026, 4, 1)),
        'endsAt': Timestamp.fromDate(DateTime.utc(2026, 6, 30)),
        'createdBy': requestedBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .doc('engineering'),
      data: {
        'name': 'Engineering',
        'code': 'ENG',
        'isActive': true,
        'createdBy': requestedBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('departments')
          .doc('human-resources'),
      data: {
        'name': 'Human Resources',
        'code': 'HR',
        'isActive': true,
        'createdBy': requestedBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore
          .collection('organizations')
          .doc(organizationId)
          .collection('seedStatus')
          .doc('base'),
      data: {
        'version': 1,
        'description': 'Base workspace documents for Lumina.',
        'createdBy': requestedBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  Future<void> _createIfMissing({
    required WriteBatch batch,
    required DocumentReference<Map<String, dynamic>> reference,
    required Map<String, dynamic> data,
  }) async {
    final snapshot = await reference.get();

    if (snapshot.exists) {
      return;
    }

    batch.set(reference, data);
  }
}
