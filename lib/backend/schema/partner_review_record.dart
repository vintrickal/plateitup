import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PartnerReviewRecord extends FirestoreRecord {
  PartnerReviewRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "paired_user_ref" field.
  DocumentReference? _pairedUserRef;
  DocumentReference? get pairedUserRef => _pairedUserRef;
  bool hasPairedUserRef() => _pairedUserRef != null;

  // "date_created" field.
  DateTime? _dateCreated;
  DateTime? get dateCreated => _dateCreated;
  bool hasDateCreated() => _dateCreated != null;

  // "star" field.
  int? _star;
  int get star => _star ?? 0;
  bool hasStar() => _star != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "meal_recipe_ref" field.
  DocumentReference? _mealRecipeRef;
  DocumentReference? get mealRecipeRef => _mealRecipeRef;
  bool hasMealRecipeRef() => _mealRecipeRef != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _pairedUserRef = snapshotData['paired_user_ref'] as DocumentReference?;
    _dateCreated = snapshotData['date_created'] as DateTime?;
    _star = castToType<int>(snapshotData['star']);
    _description = snapshotData['description'] as String?;
    _mealRecipeRef = snapshotData['meal_recipe_ref'] as DocumentReference?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('partner-review')
          : FirebaseFirestore.instance.collectionGroup('partner-review');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('partner-review').doc(id);

  static Stream<PartnerReviewRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PartnerReviewRecord.fromSnapshot(s));

  static Future<PartnerReviewRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PartnerReviewRecord.fromSnapshot(s));

  static PartnerReviewRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PartnerReviewRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PartnerReviewRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PartnerReviewRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PartnerReviewRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PartnerReviewRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPartnerReviewRecordData({
  DocumentReference? pairedUserRef,
  DateTime? dateCreated,
  int? star,
  String? description,
  DocumentReference? mealRecipeRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'paired_user_ref': pairedUserRef,
      'date_created': dateCreated,
      'star': star,
      'description': description,
      'meal_recipe_ref': mealRecipeRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class PartnerReviewRecordDocumentEquality
    implements Equality<PartnerReviewRecord> {
  const PartnerReviewRecordDocumentEquality();

  @override
  bool equals(PartnerReviewRecord? e1, PartnerReviewRecord? e2) {
    return e1?.pairedUserRef == e2?.pairedUserRef &&
        e1?.dateCreated == e2?.dateCreated &&
        e1?.star == e2?.star &&
        e1?.description == e2?.description &&
        e1?.mealRecipeRef == e2?.mealRecipeRef;
  }

  @override
  int hash(PartnerReviewRecord? e) => const ListEquality().hash([
        e?.pairedUserRef,
        e?.dateCreated,
        e?.star,
        e?.description,
        e?.mealRecipeRef
      ]);

  @override
  bool isValidKey(Object? o) => o is PartnerReviewRecord;
}
