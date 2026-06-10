import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/cubits/app/app_cubit.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import 'home_state.dart';

/// Drives [HomeWidget]. Owns the page-load side-effects (paired-user check,
/// notification loops, notification permission request), search, category
/// filter, and the "create empty meal recipe" FAB action.
///
/// The widget keeps text controllers, focus nodes, and the
/// `ExpandableController` (Flutter handles those imperatively) — the cubit
/// owns everything else that used to live in [HomeModel].
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({AppCubit? appCubit})
      : _app = appCubit ?? AppCubit.instance,
        super(const HomeState());

  final AppCubit _app;

  /// Signal the long-running paired-user / notification chain that the next
  /// awaited Firestore round-trip can resume. The original code used a
  /// completer with a [waitForFirestoreRequestCompleted] poll loop; we keep
  /// the same shape so the timing relative to other on-page-load actions
  /// (e.g. notification permission prompt) doesn't change.
  Completer<int>? _firestoreRequestCompleter;

  /// Page-load action: the giant async block from the original initState's
  /// post-frame callback. Splitting it into smaller methods would change
  /// behaviour (the notification-display flags read by sibling pages depend
  /// on the exact ordering), so it stays as one method but lives in the
  /// cubit instead of the widget.
  Future<void> onPageLoad() async {
    final pairedUserChecker = await queryPairedUserRecordCount();
    if (pairedUserChecker == 0) {
      _app.setHasPartner(false);
      _resetNotificationFlags();
      await actions.requestNotificationPermissions();
      return;
    }

    final pairedUserCollectionReceiver = await queryPairedUserRecordOnce(
      queryBuilder: (q) =>
          q.where('recipient', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    if (pairedUserCollectionReceiver == null) {
      _app.setHasPartner(false);
      _resetNotificationFlags();
      await actions.requestNotificationPermissions();
      return;
    }

    _app
      ..setHasPartner(true)
      ..setPairedUserCollection(pairedUserCollectionReceiver.reference);

    // FlutterFlow uses a completer here to allow other concurrent on-load
    // actions to settle before kicking off the notification display loop.
    _firestoreRequestCompleter = null;
    await _waitForFirestoreRequestCompleted(minWait: 500);

    final receiverCount = await queryReceiverNotificationRecordCount(
      queryBuilder: (q) => q
          .where('user_id', isEqualTo: currentUserReference)
          .where('is_shown_to_user', isEqualTo: false),
    );

    if (receiverCount == 0) {
      final senderCount = await querySenderNotificationRecordCount(
        queryBuilder: (q) => q
            .where('user_id', isEqualTo: currentUserReference)
            .where('is_shown_to_user', isEqualTo: false),
      );
      if (senderCount == 0) {
        _app.setCounterBtnClicked(0);
        await actions.requestNotificationPermissions();
      } else {
        await _drainSenderNotifications();
      }
    } else {
      await _drainReceiverNotifications();
    }

    _resetNotificationFlags();
    await actions.requestNotificationPermissions();
  }

  void _resetNotificationFlags() {
    _app
      ..setCounterBtnClicked(0)
      ..setSenderNotificationDisplayed(false)
      ..setReceiverNotificationDisplayed(false);
  }

  Future<void> _drainSenderNotifications() async {
    while (!_app.state.senderNotificationDisplayed) {
      final senderDetails = await querySenderNotificationRecordOnce(
        queryBuilder: (q) => q
            .where('user_id', isEqualTo: currentUserReference)
            .where('is_shown_to_user', isEqualTo: false),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if (senderDetails == null) {
        _app.setSenderNotificationDisplayed(true);
        return;
      }
      await actions.localNotification(
        senderDetails.mealTitle,
        senderDetails.mealStatusMessage,
      );
      await senderDetails.reference.update(
          createSenderNotificationRecordData(isShownToUser: true));

      final remaining = await querySenderNotificationRecordCount(
        queryBuilder: (q) => q
            .where('user_id', isEqualTo: currentUserReference)
            .where('is_shown_to_user', isEqualTo: false),
      );
      _app.setSenderNotificationDisplayed(remaining == 0);
    }
  }

  Future<void> _drainReceiverNotifications() async {
    while (!_app.state.receiverNotificationDisplayed) {
      final receiverDetails = await queryReceiverNotificationRecordOnce(
        queryBuilder: (q) => q
            .where('user_id', isEqualTo: currentUserReference)
            .where('is_shown_to_user', isEqualTo: false),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if (receiverDetails == null) {
        _app.setReceiverNotificationDisplayed(true);
        return;
      }
      await actions.localNotification(
        receiverDetails.mealTitle,
        receiverDetails.mealStatusMessage,
      );
      await receiverDetails.reference.update(
          createReceiverNotificationRecordData(isShownToUser: true));

      final remaining = await queryReceiverNotificationRecordCount(
        queryBuilder: (q) => q
            .where('user_id', isEqualTo: currentUserReference)
            .where('is_shown_to_user', isEqualTo: false),
      );
      _app.setReceiverNotificationDisplayed(remaining == 0);
    }
  }

  Future<void> _waitForFirestoreRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final sw = Stopwatch()..start();
    while (true) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final t = sw.elapsedMilliseconds;
      final done = _firestoreRequestCompleter?.isCompleted ?? false;
      if (t > maxWait || (done && t > minWait)) break;
    }
  }

  /// Triggered by the refresh icon in the AppBar. Re-runs the paired-user
  /// lookup and updates the global flag/ref. Kept separate from [onPageLoad]
  /// because the original UI rebinds it to the refresh icon's tap callback.
  Future<void> refreshPairedUser() async {
    final paired = await queryPairedUserRecordOnce(
      queryBuilder: (q) =>
          q.where('recipient', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);
    _app
      ..setHasPartner(paired != null)
      ..setPairedUserCollection(paired?.reference);
  }

  /// In-page search: run a TextSearch on a snapshot of the meal list.
  /// Returns the matches via [HomeState.searchResults] instead of inline
  /// `setState` mutation — `simpleSearchResults` in the model.
  void setSearchResults(List<MealRecipeRecord> results) {
    emit(state.copyWith(
      searchResults: List.of(results),
      lastEventId: state.lastEventId + 1,
    ));
  }

  /// Re-runs the public-recipe query restricted to the given categories
  /// (matches the FlutterFlow `whereArrayContainsAny` query). Emits the
  /// result into [HomeState.mealFilteredByCategory] for the grid to render.
  ///
  /// The set of selected categories lives in `AppState.tappedCategoryName`
  /// (it's read by several other pages). The widget's tap handler updates
  /// that list first, then calls this with the new list.
  Future<void> applyCategoryFilter(List<String> categories) async {
    final meals = await queryMealRecipeRecordOnce(
      queryBuilder: (q) => q
          .whereArrayContainsAny('category', categories)
          .where('isPublic', isEqualTo: true)
          .where('isReady', isEqualTo: true)
          .where('admin_approved', isEqualTo: true),
    );
    emit(state.copyWith(
      mealFilteredByCategory: meals,
      lastEventId: state.lastEventId + 1,
    ));
    _app.setIsMealFilteredByCategory(true);
  }

  void clearCategoryFilter() {
    emit(state.copyWith(
      clearMealFiltered: true,
      lastEventId: state.lastEventId + 1,
    ));
    _app.setIsMealFilteredByCategory(false);
  }

  /// FAB action: bootstrap a blank meal-recipe doc and return its reference
  /// so the widget can navigate to the add-recipe screen. We don't navigate
  /// from inside the cubit so the cubit stays UI-framework agnostic.
  Future<DocumentReference?> createBlankMealRecipe() async {
    // Original code looped on `counterBtnClicked` to avoid double-creates
    // from a quick double-tap. Replicate exactly.
    while (_app.state.counterBtnClicked == 0) {
      _app.setCounterBtnClicked(_app.state.counterBtnClicked + 1);

      final ref = MealRecipeRecord.collection.doc();
      final payload = {
        ...createMealRecipeRecordData(
          title: '',
          duration: '',
          banner:
              'https://fakeimg.pl/600x150/cccccc/ffffff?text=Temp+Image',
          videolink: '',
          author: currentUserReference,
          isPublic: true,
          isReady: false,
          prepTime: _app.state.estimatedTimeSpinner,
          adminApproved: true,
          isRecipeReported: false,
        ),
        ...mapToFirestore({
          'ingredient': getIngredientListFirestoreData(
            _app.state.ingredientList
                .map((e) => IngredientStruct.maybeFromMap(e))
                .withoutNulls
                .toList(),
          ),
          'procedure': getProcedureListFirestoreData(
            _app.state.stepsList
                .map((e) => ProcedureStruct.maybeFromMap(e))
                .withoutNulls
                .toList(),
          ),
          'dateCreated': FieldValue.serverTimestamp(),
        }),
      };
      await ref.set(payload);

      await ref.update(createMealRecipeRecordData(mealRecipeId: ref.id));
      _app.setAddIsBasicRecipeInfoAdded(true);

      return ref;
    }
    return null;
  }

  /// Avatar-tap action: look up the paired-user record once, push the
  /// partner uid into [AppCubit] so the profile page can read it, return
  /// the partner ref (or null) to the widget for the navigation.
  Future<DocumentReference?> resolvePartnerForProfileNav() async {
    final paired = await queryPairedUserRecordOnce(
      queryBuilder: (q) =>
          q.where('recipient', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);
    if (paired?.sender != null) {
      _app.setPartnerUid(paired!.sender);
      return paired.sender;
    }
    return null;
  }
}

extension on List? {
  // ignore: unused_element
  T? firstOrNullSafe<T>() => null;
}
