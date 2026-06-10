// Single source of truth for the in-memory Firestore used in MVP mode.
//
// Every `XRecord.collection` getter in `lib/backend/schema/*_record.dart`
// resolves to `mockFirestore.collection('name')` instead of the real
// `FirebaseFirestore.instance.collection('name')`. Same for
// `firestore_util.dart`'s `toRef`. Widgets see normal `CollectionReference` /
// `DocumentReference` objects with the standard `.snapshots()` / `.set()` /
// `.update()` / `.delete()` API — they don't care that the storage is in-RAM.
//
// `seedMockData()` is called from `lib/backend/firebase/firebase_config.dart`
// in place of `Firebase.initializeApp()`. Idempotent — second calls are a
// no-op so hot-restart doesn't double-seed.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'sample_data.dart';

/// Singleton fake Firestore instance — points all reads/writes at a single
/// in-memory store so writes from one widget are visible to another, just
/// like real Firestore would behave within a session.
final FirebaseFirestore mockFirestore = FakeFirebaseFirestore();

bool _seeded = false;

/// Populate `mockFirestore` with the demo users, paired-user link, and
/// recipe collection. Called once at app boot.
Future<void> seedMockData() async {
  if (_seeded) return;
  _seeded = true;

  // Users.
  final usersCol = mockFirestore.collection('users');
  await usersCol.doc(demoUserUid).set(demoUserDoc());
  await usersCol.doc(demoPartnerUid).set(demoPartnerDoc());

  final userRef = usersCol.doc(demoUserUid);
  final partnerRef = usersCol.doc(demoPartnerUid);

  // Paired-user link (demoUser <-> demoPartner). Field names match
  // PairedUserRecord's schema (recipient/sender + name/photo strings).
  await mockFirestore.collection('paired-user').add({
    'recipient': partnerRef,
    'sender': userRef,
    'recipient_name': 'Sample Partner',
    'sender_name': 'Demo User',
    'recipient_photo_url': demoPartnerDoc()['photo_url'],
    'sender_photo_url': demoUserDoc()['photo_url'],
    'is_active': true,
    'created_time': DateTime(2024, 6, 1),
  });

  // Recipes. Each recipe needs `author` as a DocumentReference; we materialise
  // that from the placeholder `author_path` string at seed time. Track the
  // resulting refs so we can seed a saved-recipe entry next.
  final recipeCol = mockFirestore.collection('meal-recipe');
  final recipeRefs = <DocumentReference>[];
  for (final raw in demoRecipes('users/$demoUserUid')) {
    final data = Map<String, dynamic>.from(raw);
    final authorPath = data.remove('author_path') as String;
    data['author'] = mockFirestore.doc(authorPath);
    final added = await recipeCol.add(data);
    recipeRefs.add(added);
  }

  // Saved-recipe entry for the demo user. The home page's outer
  // `StreamBuilder<List<SavedRecipeRecord>>` returns an empty container when
  // this is missing — without it the home screen renders blank. Seeding the
  // first three recipes as "saved" gives the saved-recipes tab some content.
  await mockFirestore.collection('saved-recipe').add({
    'user_id': userRef,
    'saved_meal_recipe_id': recipeRefs.take(3).toList(),
  });
}
