import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SavedRecipeRecord extends FirestoreRecord {
  SavedRecipeRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "saved_meal_recipe_id" field.
  List<DocumentReference>? _savedMealRecipeId;
  List<DocumentReference> get savedMealRecipeId =>
      _savedMealRecipeId ?? const [];
  bool hasSavedMealRecipeId() => _savedMealRecipeId != null;

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  void _initializeFields() {
    _savedMealRecipeId = getDataList(snapshotData['saved_meal_recipe_id']);
    _userId = snapshotData['user_id'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('saved-recipe');

  static Stream<SavedRecipeRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SavedRecipeRecord.fromSnapshot(s));

  static Future<SavedRecipeRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SavedRecipeRecord.fromSnapshot(s));

  static SavedRecipeRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SavedRecipeRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SavedRecipeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SavedRecipeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SavedRecipeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SavedRecipeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSavedRecipeRecordData({
  DocumentReference? userId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
    }.withoutNulls,
  );

  return firestoreData;
}

class SavedRecipeRecordDocumentEquality implements Equality<SavedRecipeRecord> {
  const SavedRecipeRecordDocumentEquality();

  @override
  bool equals(SavedRecipeRecord? e1, SavedRecipeRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.savedMealRecipeId, e2?.savedMealRecipeId) &&
        e1?.userId == e2?.userId;
  }

  @override
  int hash(SavedRecipeRecord? e) =>
      const ListEquality().hash([e?.savedMealRecipeId, e?.userId]);

  @override
  bool isValidKey(Object? o) => o is SavedRecipeRecord;
}
