// MVP mode: no Firebase Storage. Image-upload call sites get back a
// placeholder URL so the upstream "successfully uploaded" UX still runs.
// In a real build you'd replace this with a real storage backend.

import 'dart:typed_data';

Future<String?> uploadData(String path, Uint8List data) async {
  // path is something like "users/UID/profile/abc.png" — keep the basename
  // visible in the URL so it's easier to tell different uploads apart.
  final filename = path.split('/').last;
  return 'https://placehold.co/512x512/png?text=${Uri.encodeComponent(filename)}';
}
