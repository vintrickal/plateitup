// MVP mode: the `currentUser*` globals point at the seeded demo user.
// Widgets call `currentUserReference`, `currentUserUid`, `currentUserEmail`
// etc. — these still work, they just resolve to the demo user in
// `mockFirestore` instead of the real Firebase signed-in user.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../base_auth_user_provider.dart';
import '/backend/backend.dart';
import '/mock/sample_data.dart';

export '../base_auth_user_provider.dart';

String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.email ?? 'demo@plateitup.app';

String get currentUserUid => currentUser?.uid ?? demoUserUid;

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.displayName ?? 'Demo User';

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ?? currentUser?.photoUrl ?? '';

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.phoneNumber ?? '';

/// JWT token isn't used at runtime in MVP mode — return an empty string so
/// any callsite that expects a non-null doesn't crash. The single subscription
/// in `main.dart` to `jwtTokenStream` becomes a no-op.
String get currentJwtToken => '';

bool get currentUserEmailVerified => true;

final jwtTokenStream = const Stream<String?>.empty().asBroadcastStream();

DocumentReference? get currentUserReference =>
    UsersRecord.collection.doc(currentUser?.uid ?? demoUserUid);

UsersRecord? currentUserDocument;

/// Lazily resolves the demo user's UsersRecord on first access. Watched by
/// widgets via `StreamBuilder`s that read `currentUserDocument` mid-frame.
final authenticatedUserStream = UsersRecord.collection
    .doc(demoUserUid)
    .snapshots()
    .map<UsersRecord?>((s) {
  if (!s.exists) return null;
  currentUserDocument = UsersRecord.fromSnapshot(s);
  return currentUserDocument;
}).asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.builder})
      : super(key: key);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}
