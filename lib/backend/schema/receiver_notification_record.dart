import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReceiverNotificationRecord extends FirestoreRecord {
  ReceiverNotificationRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uid_receiver" field.
  String? _uidReceiver;
  String get uidReceiver => _uidReceiver ?? '';
  bool hasUidReceiver() => _uidReceiver != null;

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

  // "meal_id" field.
  DocumentReference? _mealId;
  DocumentReference? get mealId => _mealId;
  bool hasMealId() => _mealId != null;

  void _initializeFields() {
    _uidReceiver = snapshotData['uid_receiver'] as String?;
    _userId = snapshotData['user_id'] as DocumentReference?;
    _isShownToUser = snapshotData['is_shown_to_user'] as bool?;
    _mealTitle = snapshotData['meal_title'] as String?;
    _mealStatusMessage = snapshotData['meal_status_message'] as String?;
    _mealId = snapshotData['meal_id'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('receiver-notification');

  static Stream<ReceiverNotificationRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => ReceiverNotificationRecord.fromSnapshot(s));

  static Future<ReceiverNotificationRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ReceiverNotificationRecord.fromSnapshot(s));

  static ReceiverNotificationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReceiverNotificationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReceiverNotificationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReceiverNotificationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReceiverNotificationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReceiverNotificationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReceiverNotificationRecordData({
  String? uidReceiver,
  DocumentReference? userId,
  bool? isShownToUser,
  String? mealTitle,
  String? mealStatusMessage,
  DocumentReference? mealId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid_receiver': uidReceiver,
      'user_id': userId,
      'is_shown_to_user': isShownToUser,
      'meal_title': mealTitle,
      'meal_status_message': mealStatusMessage,
      'meal_id': mealId,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReceiverNotificationRecordDocumentEquality
    implements Equality<ReceiverNotificationRecord> {
  const ReceiverNotificationRecordDocumentEquality();

  @override
  bool equals(ReceiverNotificationRecord? e1, ReceiverNotificationRecord? e2) {
    return e1?.uidReceiver == e2?.uidReceiver &&
        e1?.userId == e2?.userId &&
        e1?.isShownToUser == e2?.isShownToUser &&
        e1?.mealTitle == e2?.mealTitle &&
        e1?.mealStatusMessage == e2?.mealStatusMessage &&
        e1?.mealId == e2?.mealId;
  }

  @override
  int hash(ReceiverNotificationRecord? e) => const ListEquality().hash([
        e?.uidReceiver,
        e?.userId,
        e?.isShownToUser,
        e?.mealTitle,
        e?.mealStatusMessage,
        e?.mealId
      ]);

  @override
  bool isValidKey(Object? o) => o is ReceiverNotificationRecord;
}
