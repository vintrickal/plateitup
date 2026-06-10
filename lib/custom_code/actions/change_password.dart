// MVP mode: no Firebase Auth. Password change is a no-op that returns the
// same success string the UI flow expects.

Future<String> changePassword(
  String currentPassword,
  String newPassword,
  String email,
) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return 'Password changed successfully.';
}
