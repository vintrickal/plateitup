import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import 'profile_screen_state.dart';

/// Drives [ProfileScreenWidget]. Only side-effect right now is the page-load
/// paired-user check, which sets [AppCubit.setHasPartner] before the screen
/// finishes building.
class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({AppCubit? appCubit})
      : _app = appCubit ?? AppCubit.instance,
        super(const ProfileScreenState());

  final AppCubit _app;

  Future<void> onPageLoad() async {
    final paired = await queryPairedUserRecordOnce(
      queryBuilder: (q) =>
          q.where('recipient', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);
    _app.setHasPartner(paired != null);
    emit(state.copyWith(
      didCompletePageLoad: true,
      lastEventId: state.lastEventId + 1,
    ));
  }
}
