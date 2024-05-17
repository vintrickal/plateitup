import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MealRequestedNotificationRecord extends FirestoreRecord {
  MealRequestedNotificationRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "paired_user_id" field.
  DocumentReference? _pairedUserId;
  DocumentReference? get pairedUserId => _pairedUserId;
  bool hasPairedUserId() => _pairedUserId != null;

  // "date_requested" field.
  DateTime? _dateRequested;
  DateTime? get dateRequested => _dateRequested;
  bool hasDateRequested() => _dateRequested != null;

  // "requested_meal_id" field.
  DocumentReference? _requestedMealId;
  DocumentReference? get requestedMealId => _requestedMealId;
  bool hasRequestedMealId() => _requestedMealId != null;

  // "content_was_tapped" field.
  bool? _contentWasTapped;
  bool get contentWasTapped => _contentWasTapped ?? false;
  bool hasContentWasTapped() => _contentWasTapped != null;

  // "content_status" field.
  String? _contentStatus;
  String get contentStatus => _contentStatus ?? '';
  bool hasContentStatus() => _contentStatus != null;

  // "date_action_taken" field.
  DateTime? _dateActionTaken;
  DateTime? get dateActionTaken => _dateActionTaken;
  bool hasDateActionTaken() => _dateActionTaken != null;

  // "reviewed" field.
  bool? _reviewed;
  bool get reviewed => _reviewed ?? false;
  bool hasReviewed() => _reviewed != null;

  void _initializeFields() {
    _pairedUserId = snapshotData['paired_user_id'] as DocumentReference?;
    _dateRequested = snapshotData['date_requested'] as DateTime?;
    _requestedMealId = snapshotData['requested_meal_id'] as DocumentReference?;
    _contentWasTapped = snapshotData['content_was_tapped'] as bool?;
    _contentStatus = snapshotData['content_status'] as String?;
    _dateActionTaken = snapshotData['date_action_taken'] as DateTime?;
    _reviewed = snapshotData['reviewed'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('meal-requested-notification');

  static Stream<MealRequestedNotificationRecord> getDocument(
          DocumentReference ref) =>
      ref
          .snapshots()
          .map((s) => MealRequestedNotificationRecord.fromSnapshot(s));

  static Future<MealRequestedNotificationRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => MealRequestedNotificationRecord.fromSnapshot(s));

  static MealRequestedNotificationRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      MealRequestedNotificationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MealRequestedNotificationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MealRequestedNotificationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MealRequestedNotificationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MealRequestedNotificationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMealRequestedNotificationRecordData({
  DocumentReference? pairedUserId,
  DateTime? dateRequested,
  DocumentReference? requestedMealId,
  bool? contentWasTapped,
  String? contentStatus,
  DateTime? dateActionTaken,
  bool? reviewed,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'paired_user_id': pairedUserId,
      'date_requested': dateRequested,
      'requested_meal_id': requestedMealId,
      'content_was_tapped': contentWasTapped,
      'content_status': contentStatus,
      'date_action_taken': dateActionTaken,
      'reviewed': reviewed,
    }.withoutNulls,
  );

  return firestoreData;
}

class MealRequestedNotificationRecordDocumentEquality
    implements Equality<MealRequestedNotificationRecord> {
  const MealRequestedNotificationRecordDocumentEquality();

  @override
  bool equals(MealRequestedNotificationRecord? e1,
      MealRequestedNotificationRecord? e2) {
    return e1?.pairedUserId == e2?.pairedUserId &&
        e1?.dateRequested == e2?.dateRequested &&
        e1?.requestedMealId == e2?.requestedMealId &&
        e1?.contentWasTapped == e2?.contentWasTapped &&
        e1?.contentStatus == e2?.contentStatus &&
        e1?.dateActionTaken == e2?.dateActionTaken &&
        e1?.reviewed == e2?.reviewed;
  }

  @override
  int hash(MealRequestedNotificationRecord? e) => const ListEquality().hash([
        e?.pairedUserId,
        e?.dateRequested,
        e?.requestedMealId,
        e?.contentWasTapped,
        e?.contentStatus,
        e?.dateActionTaken,
        e?.reviewed
      ]);

  @override
  bool isValidKey(Object? o) => o is MealRequestedNotificationRecord;
}
