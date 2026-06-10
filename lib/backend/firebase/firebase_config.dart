// MVP mode: no real Firebase. `initFirebase()` now seeds the in-memory
// `mockFirestore` instead of calling `Firebase.initializeApp()`. Every
// `XRecord.collection` getter in `lib/backend/schema/*_record.dart` reads
// from that mock instance. See `lib/mock/mock_firestore.dart` for the seed.

import '../../mock/mock_firestore.dart';

Future<void> initFirebase() => seedMockData();
