import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import '/custom_code/actions/index.dart' as actions;
import 'details_state.dart';

/// Drives [DetailsScreenWidget].
///
/// One entry point — [onPageLoad] — that runs the chunky FlutterFlow on-load
/// chain:
///   1. Look up the user's paired-user record (sender side).
///   2. Tally review count → set `AppCubit.isReviewTabEmpty`.
///   3. If reviews exist, iterate them via the custom `addingStar` /
///      `averageRating` actions and emit the average into [DetailsState].
///   4. Check whether the current user has already reviewed → set
///      `AppCubit.isReviewExist`.
///
/// Splitting these into separate methods would change ordering semantics
/// the original code relied on (the global counters get reset only at the
/// end), so they stay sequential here.
class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit({AppCubit? appCubit})
      : _app = appCubit ?? AppCubit.instance,
        super(const DetailsState());

  final AppCubit _app;

  Future<void> onPageLoad({required DocumentReference mealRef}) async {
    // Capture the user's sender-side paired-user record. The option-author /
    // option-not-author dialogs take it as a parameter.
    final paired = await queryPairedUserRecordOnce(
      queryBuilder: (q) => q.where('sender', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);
    emit(state.copyWith(
      pairedUserSenderRef: paired?.reference,
      lastEventId: state.lastEventId + 1,
    ));

    final reviewCount = await queryReviewRecordCount(parent: mealRef);
    if (reviewCount == 0) {
      _app.setIsReviewTabEmpty(true);
    } else {
      _app.setIsReviewTabEmpty(false);
      final reviews = await queryReviewRecordOnce(parent: mealRef);
      // Iterate exactly as the FlutterFlow loop did — accumulator + counter
      // live on AppState because the custom actions read them by name.
      while (_app.state.onloadCounter != reviews.length) {
        final accumulated = await actions.addingStar(
          _app.state.accumulatedStar,
          reviews[_app.state.onloadCounter].star,
        );
        if (accumulated != null) _app.setAccumulatedStar(accumulated);
        _app.setOnloadCounter(_app.state.onloadCounter + 1);
      }
      final average = await actions.averageRating(
        _app.state.accumulatedStar,
        _app.state.onloadCounter,
      );
      // Reset the global counters BEFORE emitting our local state so any
      // listener that re-runs onPageLoad starts from zero.
      _app
        ..setOnloadCounter(0)
        ..setAccumulatedStar(0);
      emit(state.copyWith(
        starAverage: average,
        lastEventId: state.lastEventId + 1,
      ));
    }

    final existing = await queryReviewRecordOnce(
      parent: mealRef,
      queryBuilder: (q) =>
          q.where('user_ref', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);
    _app.setIsReviewExist(existing != null);
  }
}
