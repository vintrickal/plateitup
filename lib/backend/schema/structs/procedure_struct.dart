// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProcedureStruct extends FFFirebaseStruct {
  ProcedureStruct({
    String? steps,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _steps = steps,
        super(firestoreUtilData);

  // "steps" field.
  String? _steps;
  String get steps => _steps ?? '';
  set steps(String? val) => _steps = val;
  bool hasSteps() => _steps != null;

  static ProcedureStruct fromMap(Map<String, dynamic> data) => ProcedureStruct(
        steps: data['steps'] as String?,
      );

  static ProcedureStruct? maybeFromMap(dynamic data) => data is Map
      ? ProcedureStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'steps': _steps,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'steps': serializeParam(
          _steps,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProcedureStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProcedureStruct(
        steps: deserializeParam(
          data['steps'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProcedureStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProcedureStruct && steps == other.steps;
  }

  @override
  int get hashCode => const ListEquality().hash([steps]);
}

ProcedureStruct createProcedureStruct({
  String? steps,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProcedureStruct(
      steps: steps,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ProcedureStruct? updateProcedureStruct(
  ProcedureStruct? procedure, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    procedure
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addProcedureStructData(
  Map<String, dynamic> firestoreData,
  ProcedureStruct? procedure,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (procedure == null) {
    return;
  }
  if (procedure.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && procedure.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final procedureData = getProcedureFirestoreData(procedure, forFieldValue);
  final nestedData = procedureData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = procedure.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getProcedureFirestoreData(
  ProcedureStruct? procedure, [
  bool forFieldValue = false,
]) {
  if (procedure == null) {
    return {};
  }
  final firestoreData = mapToFirestore(procedure.toMap());

  // Add any Firestore field values
  procedure.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getProcedureListFirestoreData(
  List<ProcedureStruct>? procedures,
) =>
    procedures?.map((e) => getProcedureFirestoreData(e, true)).toList() ?? [];
