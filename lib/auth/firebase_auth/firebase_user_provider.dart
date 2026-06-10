// MVP mode: no Firebase Auth. The "user" is a hardcoded `_DemoAuthUser` whose
// `loggedIn` is always true and whose `uid` matches the demo user seeded in
// `lib/mock/mock_firestore.dart`. Everything downstream (`AppStateNotifier`,
// `AuthCubit`, `currentUserReference`) sees a normal `BaseAuthUser`.

import 'dart:async';

import '../base_auth_user_provider.dart';
import '/mock/sample_data.dart';

export '../base_auth_user_provider.dart';

class PlateitupFirebaseUser extends BaseAuthUser {
  PlateitupFirebaseUser([dynamic _]);

  @override
  bool get loggedIn => true;

  @override
  AuthUserInfo get authUserInfo => const AuthUserInfo(
        uid: demoUserUid,
        email: 'demo@plateitup.app',
        displayName: 'Demo User',
        photoUrl:
            'https://res.cloudinary.com/hz3gmuqw6/image/upload/c_fill,q_auto,w_512/f_auto/plating-food-phpsUAQLM',
        phoneNumber: '',
      );

  @override
  Future? delete() async {/* no-op in MVP */}

  @override
  Future? updateEmail(String email) async {/* no-op in MVP */}

  @override
  Future? sendEmailVerification() async {/* no-op in MVP */}

  @override
  bool get emailVerified => true;

  @override
  Future refreshUser() async {/* no-op in MVP */}

  // Kept for source-compatibility with call sites in AuthCubit that used
  // `PlateitupFirebaseUser.fromUserCredential(cred)`.
  static BaseAuthUser fromUserCredential(dynamic _) =>
      PlateitupFirebaseUser();

  static BaseAuthUser fromFirebaseUser(dynamic _) =>
      PlateitupFirebaseUser();
}

/// Stream that emits a logged-in demo user immediately, then never again.
/// Replaces the Firebase auth-state stream that used to drive the splash
/// and the redirect machinery.
Stream<BaseAuthUser> plateitupFirebaseUserStream() {
  final user = PlateitupFirebaseUser();
  currentUser = user;
  return Stream.value(user);
}
