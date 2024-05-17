import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SenderNotificationRecord extends FirestoreRecord {
  SenderNotificationRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "is_shown_to_user" field.
  bool? _isShownToUser;
  bool get isShownToUser => _isShownToUser ?? false;
  bool hasIsShownToUser() => _isShownToUser != null;

  // "meal_title" field.
  String? _mealTitle;
  String get mealTitle => _mealTitle ?? '';
  bool hasMealTitle() => _mealTitle != null;

  // "meal_status_message" field.
  String? _mealStatusMessage;
  String get mealStatusMessage => _mealStatusMessage ?? '';
  bool hasMealStatusMessage() => _mealStatusMessage != null;

  // "uid_sender" field.
  String? _uidSender;
  String get uidSender => _uidSender ?? '';
  bool hasUidSender() => _uidSender != null;

  // "meal_id" field.
  DocumentReference? _mealId;
  DocumentReference? get mealId => _mealId;
  bool hasMealId() => _mealId != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as DocumentReference?;
    _isShownToUser = snapshotData['is_shown_to_user'] as bool?;
    _mealTitle = snapshotData['meal_title'] as String?;
    _mealStatusMessage = snapshotData['meal_status_message'] as String?;
    _uidSender = snapshotData['uid_sender'] as String?;
    _mealId = snapshotData['meal_id'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sender-notification');

  static Stream<SenderNotificationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SenderNotificationRecord.fromSnapshot(s));

  static Future<SenderNotificationRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => SenderNotificationRecord.fromSnapshot(s));

  static SenderNotificationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SenderNotificationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SenderNotificationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SenderNotificationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SenderNotificationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SenderNotificationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSenderNotificationRecordData({
  DocumentReference? userId,
  bool? isShownToUser,
  String? mealTitle,
  String? mealStatusMessage,
  String? uidSender,
  DocumentReference? mealId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'is_shown_to_user': isShownToUser,
      'meal_title': mealTitle,
      'meal_status_message': mealStatusMessage,
      'uid_sender': uidSender,
      'meal_id': mealId,
    }.withoutNulls,
  );

  return firestoreData;
}

class SenderNotificationRecordDocumentEquality
    implements Equality<SenderNotificationRecord> {
  const SenderNotificationRecordDocumentEquality();

  @override
  bool equals(SenderNotificationRecord? e1, SenderNotificationRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.isShownToUser == e2?.isShownToUser &&
        e1?.mealTitle == e2?.mealTitle &&
        e1?.mealStatusMessage == e2?.mealStatusMessage &&
        e1?.uidSender == e2?.uidSender &&
        e1?.mealId == e2?.mealId;
  }

  @override
  int hash(SenderNotificationRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.isShownToUser,
        e?.mealTitle,
        e?.mealStatusMessage,
        e?.uidSender,
        e?.mealId
      ]);

  @override
  bool isValidKey(Object? o) => o is SenderNotificationRecord;
}
