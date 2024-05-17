import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DeleteAccountRequestRecord extends FirestoreRecord {
  DeleteAccountRequestRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "reason" field.
  String? _reason;
  String get reason => _reason ?? '';
  bool hasReason() => _reason != null;

  // "other_reason" field.
  String? _otherReason;
  String get otherReason => _otherReason ?? '';
  bool hasOtherReason() => _otherReason != null;

  // "date_requested" field.
  DateTime? _dateRequested;
  DateTime? get dateRequested => _dateRequested;
  bool hasDateRequested() => _dateRequested != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as DocumentReference?;
    _reason = snapshotData['reason'] as String?;
    _otherReason = snapshotData['other_reason'] as String?;
    _dateRequested = snapshotData['date_requested'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('delete_account_request');

  static Stream<DeleteAccountRequestRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => DeleteAccountRequestRecord.fromSnapshot(s));

  static Future<DeleteAccountRequestRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => DeleteAccountRequestRecord.fromSnapshot(s));

  static DeleteAccountRequestRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DeleteAccountRequestRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DeleteAccountRequestRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DeleteAccountRequestRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DeleteAccountRequestRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DeleteAccountRequestRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDeleteAccountRequestRecordData({
  DocumentReference? userId,
  String? reason,
  String? otherReason,
  DateTime? dateRequested,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'reason': reason,
      'other_reason': otherReason,
      'date_requested': dateRequested,
    }.withoutNulls,
  );

  return firestoreData;
}

class DeleteAccountRequestRecordDocumentEquality
    implements Equality<DeleteAccountRequestRecord> {
  const DeleteAccountRequestRecordDocumentEquality();

  @override
  bool equals(DeleteAccountRequestRecord? e1, DeleteAccountRequestRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.reason == e2?.reason &&
        e1?.otherReason == e2?.otherReason &&
        e1?.dateRequested == e2?.dateRequested;
  }

  @override
  int hash(DeleteAccountRequestRecord? e) => const ListEquality()
      .hash([e?.userId, e?.reason, e?.otherReason, e?.dateRequested]);

  @override
  bool isValidKey(Object? o) => o is DeleteAccountRequestRecord;
}
