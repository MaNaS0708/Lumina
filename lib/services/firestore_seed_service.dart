import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeedService {
  FirestoreSeedService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> ensureBaseDocuments() async {
    final batch = _firestore.batch();

    await _createIfMissing(
      batch: batch,
      reference: _firestore.collection('appConfig').doc('general'),
      data: {
        'appName': 'Lumina',
        'environment': 'production-preview',
        'activeCycleId': 'fy2026-q1',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore.collection('cycles').doc('fy2026-q1'),
      data: {
        'name': 'FY 2026 Q1',
        'status': 'draft',
        'startsAt': Timestamp.fromDate(DateTime.utc(2026, 4, 1)),
        'endsAt': Timestamp.fromDate(DateTime.utc(2026, 6, 30)),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore.collection('departments').doc('engineering'),
      data: {
        'name': 'Engineering',
        'code': 'ENG',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore.collection('departments').doc('human-resources'),
      data: {
        'name': 'Human Resources',
        'code': 'HR',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    await _createIfMissing(
      batch: batch,
      reference: _firestore.collection('seedStatus').doc('base'),
      data: {
        'version': 1,
        'description': 'Base workspace documents for Lumina.',
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
