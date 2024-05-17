import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserReviewLikesRecord extends FirestoreRecord {
  UserReviewLikesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "review_subcollection_ref" field.
  DocumentReference? _reviewSubcollectionRef;
  DocumentReference? get reviewSubcollectionRef => _reviewSubcollectionRef;
  bool hasReviewSubcollectionRef() => _reviewSubcollectionRef != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  void _initializeFields() {
    _reviewSubcollectionRef =
        snapshotData['review_subcollection_ref'] as DocumentReference?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('user-review-likes');

  static Stream<UserReviewLikesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserReviewLikesRecord.fromSnapshot(s));

  static Future<UserReviewLikesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserReviewLikesRecord.fromSnapshot(s));

  static UserReviewLikesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserReviewLikesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserReviewLikesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserReviewLikesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserReviewLikesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserReviewLikesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserReviewLikesRecordData({
  DocumentReference? reviewSubcollectionRef,
  DocumentReference? userRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'review_subcollection_ref': reviewSubcollectionRef,
      'user_ref': userRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserReviewLikesRecordDocumentEquality
    implements Equality<UserReviewLikesRecord> {
  const UserReviewLikesRecordDocumentEquality();

  @override
  bool equals(UserReviewLikesRecord? e1, UserReviewLikesRecord? e2) {
    return e1?.reviewSubcollectionRef == e2?.reviewSubcollectionRef &&
        e1?.userRef == e2?.userRef;
  }

  @override
  int hash(UserReviewLikesRecord? e) =>
      const ListEquality().hash([e?.reviewSubcollectionRef, e?.userRef]);

  @override
  bool isValidKey(Object? o) => o is UserReviewLikesRecord;
}
