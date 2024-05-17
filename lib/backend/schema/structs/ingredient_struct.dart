// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class IngredientStruct extends FFFirebaseStruct {
  IngredientStruct({
    String? ingrName,
    String? ingrQuantity,
    String? ingrUnit,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _ingrName = ingrName,
        _ingrQuantity = ingrQuantity,
        _ingrUnit = ingrUnit,
        super(firestoreUtilData);

  // "ingr_name" field.
  String? _ingrName;
  String get ingrName => _ingrName ?? '';
  set ingrName(String? val) => _ingrName = val;
  bool hasIngrName() => _ingrName != null;

  // "ingr_quantity" field.
  String? _ingrQuantity;
  String get ingrQuantity => _ingrQuantity ?? '';
  set ingrQuantity(String? val) => _ingrQuantity = val;
  bool hasIngrQuantity() => _ingrQuantity != null;

  // "ingr_unit" field.
  String? _ingrUnit;
  String get ingrUnit => _ingrUnit ?? '';
  set ingrUnit(String? val) => _ingrUnit = val;
  bool hasIngrUnit() => _ingrUnit != null;

  static IngredientStruct fromMap(Map<String, dynamic> data) =>
      IngredientStruct(
        ingrName: data['ingr_name'] as String?,
        ingrQuantity: data['ingr_quantity'] as String?,
        ingrUnit: data['ingr_unit'] as String?,
      );

  static IngredientStruct? maybeFromMap(dynamic data) => data is Map
      ? IngredientStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ingr_name': _ingrName,
        'ingr_quantity': _ingrQuantity,
        'ingr_unit': _ingrUnit,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ingr_name': serializeParam(
          _ingrName,
          ParamType.String,
        ),
        'ingr_quantity': serializeParam(
          _ingrQuantity,
          ParamType.String,
        ),
        'ingr_unit': serializeParam(
          _ingrUnit,
          ParamType.String,
        ),
      }.withoutNulls;

  static IngredientStruct fromSerializableMap(Map<String, dynamic> data) =>
      IngredientStruct(
        ingrName: deserializeParam(
          data['ingr_name'],
          ParamType.String,
          false,
        ),
        ingrQuantity: deserializeParam(
          data['ingr_quantity'],
          ParamType.String,
          false,
        ),
        ingrUnit: deserializeParam(
          data['ingr_unit'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'IngredientStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is IngredientStruct &&
        ingrName == other.ingrName &&
        ingrQuantity == other.ingrQuantity &&
        ingrUnit == other.ingrUnit;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([ingrName, ingrQuantity, ingrUnit]);
}

IngredientStruct createIngredientStruct({
  String? ingrName,
  String? ingrQuantity,
  String? ingrUnit,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    IngredientStruct(
      ingrName: ingrName,
      ingrQuantity: ingrQuantity,
      ingrUnit: ingrUnit,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

IngredientStruct? updateIngredientStruct(
  IngredientStruct? ingredient, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ingredient
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addIngredientStructData(
  Map<String, dynamic> firestoreData,
  IngredientStruct? ingredient,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ingredient == null) {
    return;
  }
  if (ingredient.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && ingredient.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ingredientData = getIngredientFirestoreData(ingredient, forFieldValue);
  final nestedData = ingredientData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ingredient.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getIngredientFirestoreData(
  IngredientStruct? ingredient, [
  bool forFieldValue = false,
]) {
  if (ingredient == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ingredient.toMap());

  // Add any Firestore field values
  ingredient.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getIngredientListFirestoreData(
  List<IngredientStruct>? ingredients,
) =>
    ingredients?.map((e) => getIngredientFirestoreData(e, true)).toList() ?? [];
