import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PairedUserRecord extends FirestoreRecord {
  PairedUserRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "recipient" field.
  DocumentReference? _recipient;
  DocumentReference? get recipient => _recipient;
  bool hasRecipient() => _recipient != null;

  // "sender" field.
  DocumentReference? _sender;
  DocumentReference? get sender => _sender;
  bool hasSender() => _sender != null;

  // "recipient_name" field.
  String? _recipientName;
  String get recipientName => _recipientName ?? '';
  bool hasRecipientName() => _recipientName != null;

  // "sender_name" field.
  String? _senderName;
  String get senderName => _senderName ?? '';
  bool hasSenderName() => _senderName != null;

  // "recipient_photo_url" field.
  String? _recipientPhotoUrl;
  String get recipientPhotoUrl => _recipientPhotoUrl ?? '';
  bool hasRecipientPhotoUrl() => _recipientPhotoUrl != null;

  // "sender_photo_url" field.
  String? _senderPhotoUrl;
  String get senderPhotoUrl => _senderPhotoUrl ?? '';
  bool hasSenderPhotoUrl() => _senderPhotoUrl != null;

  void _initializeFields() {
    _recipient = snapshotData['recipient'] as DocumentReference?;
    _sender = snapshotData['sender'] as DocumentReference?;
    _recipientName = snapshotData['recipient_name'] as String?;
    _senderName = snapshotData['sender_name'] as String?;
    _recipientPhotoUrl = snapshotData['recipient_photo_url'] as String?;
    _senderPhotoUrl = snapshotData['sender_photo_url'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('paired-user');

  static Stream<PairedUserRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PairedUserRecord.fromSnapshot(s));

  static Future<PairedUserRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PairedUserRecord.fromSnapshot(s));

  static PairedUserRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PairedUserRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PairedUserRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PairedUserRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PairedUserRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PairedUserRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPairedUserRecordData({
  DocumentReference? recipient,
  DocumentReference? sender,
  String? recipientName,
  String? senderName,
  String? recipientPhotoUrl,
  String? senderPhotoUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'recipient': recipient,
      'sender': sender,
      'recipient_name': recipientName,
      'sender_name': senderName,
      'recipient_photo_url': recipientPhotoUrl,
      'sender_photo_url': senderPhotoUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class PairedUserRecordDocumentEquality implements Equality<PairedUserRecord> {
  const PairedUserRecordDocumentEquality();

  @override
  bool equals(PairedUserRecord? e1, PairedUserRecord? e2) {
    return e1?.recipient == e2?.recipient &&
        e1?.sender == e2?.sender &&
        e1?.recipientName == e2?.recipientName &&
        e1?.senderName == e2?.senderName &&
        e1?.recipientPhotoUrl == e2?.recipientPhotoUrl &&
        e1?.senderPhotoUrl == e2?.senderPhotoUrl;
  }

  @override
  int hash(PairedUserRecord? e) => const ListEquality().hash([
        e?.recipient,
        e?.sender,
        e?.recipientName,
        e?.senderName,
        e?.recipientPhotoUrl,
        e?.senderPhotoUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is PairedUserRecord;
}
