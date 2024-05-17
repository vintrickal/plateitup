import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MealRecipeRecord extends FirestoreRecord {
  MealRecipeRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "banner" field.
  String? _banner;
  String get banner => _banner ?? '';
  bool hasBanner() => _banner != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "duration" field.
  String? _duration;
  String get duration => _duration ?? '';
  bool hasDuration() => _duration != null;

  // "ingredient" field.
  List<IngredientStruct>? _ingredient;
  List<IngredientStruct> get ingredient => _ingredient ?? const [];
  bool hasIngredient() => _ingredient != null;

  // "procedure" field.
  List<ProcedureStruct>? _procedure;
  List<ProcedureStruct> get procedure => _procedure ?? const [];
  bool hasProcedure() => _procedure != null;

  // "videolink" field.
  String? _videolink;
  String get videolink => _videolink ?? '';
  bool hasVideolink() => _videolink != null;

  // "author" field.
  DocumentReference? _author;
  DocumentReference? get author => _author;
  bool hasAuthor() => _author != null;

  // "isPublic" field.
  bool? _isPublic;
  bool get isPublic => _isPublic ?? false;
  bool hasIsPublic() => _isPublic != null;

  // "dateCreated" field.
  DateTime? _dateCreated;
  DateTime? get dateCreated => _dateCreated;
  bool hasDateCreated() => _dateCreated != null;

  // "isReady" field.
  bool? _isReady;
  bool get isReady => _isReady ?? false;
  bool hasIsReady() => _isReady != null;

  // "prep_time" field.
  DateTime? _prepTime;
  DateTime? get prepTime => _prepTime;
  bool hasPrepTime() => _prepTime != null;

  // "category" field.
  List<String>? _category;
  List<String> get category => _category ?? const [];
  bool hasCategory() => _category != null;

  // "attribution" field.
  String? _attribution;
  String get attribution => _attribution ?? '';
  bool hasAttribution() => _attribution != null;

  // "meal_recipe_id" field.
  String? _mealRecipeId;
  String get mealRecipeId => _mealRecipeId ?? '';
  bool hasMealRecipeId() => _mealRecipeId != null;

  // "admin_approved" field.
  bool? _adminApproved;
  bool get adminApproved => _adminApproved ?? false;
  bool hasAdminApproved() => _adminApproved != null;

  void _initializeFields() {
    _banner = snapshotData['banner'] as String?;
    _title = snapshotData['title'] as String?;
    _duration = snapshotData['duration'] as String?;
    _ingredient = getStructList(
      snapshotData['ingredient'],
      IngredientStruct.fromMap,
    );
    _procedure = getStructList(
      snapshotData['procedure'],
      ProcedureStruct.fromMap,
    );
    _videolink = snapshotData['videolink'] as String?;
    _author = snapshotData['author'] as DocumentReference?;
    _isPublic = snapshotData['isPublic'] as bool?;
    _dateCreated = snapshotData['dateCreated'] as DateTime?;
    _isReady = snapshotData['isReady'] as bool?;
    _prepTime = snapshotData['prep_time'] as DateTime?;
    _category = getDataList(snapshotData['category']);
    _attribution = snapshotData['attribution'] as String?;
    _mealRecipeId = snapshotData['meal_recipe_id'] as String?;
    _adminApproved = snapshotData['admin_approved'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('meal-recipe');

  static Stream<MealRecipeRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MealRecipeRecord.fromSnapshot(s));

  static Future<MealRecipeRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MealRecipeRecord.fromSnapshot(s));

  static MealRecipeRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MealRecipeRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MealRecipeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MealRecipeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MealRecipeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MealRecipeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMealRecipeRecordData({
  String? banner,
  String? title,
  String? duration,
  String? videolink,
  DocumentReference? author,
  bool? isPublic,
  DateTime? dateCreated,
  bool? isReady,
  DateTime? prepTime,
  String? attribution,
  String? mealRecipeId,
  bool? adminApproved,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'banner': banner,
      'title': title,
      'duration': duration,
      'videolink': videolink,
      'author': author,
      'isPublic': isPublic,
      'dateCreated': dateCreated,
      'isReady': isReady,
      'prep_time': prepTime,
      'attribution': attribution,
      'meal_recipe_id': mealRecipeId,
      'admin_approved': adminApproved,
    }.withoutNulls,
  );

  return firestoreData;
}

class MealRecipeRecordDocumentEquality implements Equality<MealRecipeRecord> {
  const MealRecipeRecordDocumentEquality();

  @override
  bool equals(MealRecipeRecord? e1, MealRecipeRecord? e2) {
    const listEquality = ListEquality();
    return e1?.banner == e2?.banner &&
        e1?.title == e2?.title &&
        e1?.duration == e2?.duration &&
        listEquality.equals(e1?.ingredient, e2?.ingredient) &&
        listEquality.equals(e1?.procedure, e2?.procedure) &&
        e1?.videolink == e2?.videolink &&
        e1?.author == e2?.author &&
        e1?.isPublic == e2?.isPublic &&
        e1?.dateCreated == e2?.dateCreated &&
        e1?.isReady == e2?.isReady &&
        e1?.prepTime == e2?.prepTime &&
        listEquality.equals(e1?.category, e2?.category) &&
        e1?.attribution == e2?.attribution &&
        e1?.mealRecipeId == e2?.mealRecipeId &&
        e1?.adminApproved == e2?.adminApproved;
  }

  @override
  int hash(MealRecipeRecord? e) => const ListEquality().hash([
        e?.banner,
        e?.title,
        e?.duration,
        e?.ingredient,
        e?.procedure,
        e?.videolink,
        e?.author,
        e?.isPublic,
        e?.dateCreated,
        e?.isReady,
        e?.prepTime,
        e?.category,
        e?.attribution,
        e?.mealRecipeId,
        e?.adminApproved
      ]);

  @override
  bool isValidKey(Object? o) => o is MealRecipeRecord;
}
