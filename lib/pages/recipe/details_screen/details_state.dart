import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// State for [DetailsScreenWidget].
///
/// We track:
///   * [starAverage] — average rating shown in the header.
///   * [pairedUserSenderRef] — paired-user record where the viewer is the
///     *sender*. The option dialogs need it as a parameter. Null while the
///     page-load query is pending or if the viewer isn't paired.
class DetailsState extends Equatable {
  const DetailsState({
    this.starAverage,
    this.pairedUserSenderRef,
    this.lastEventId = 0,
  });

  final double? starAverage;
  final DocumentReference? pairedUserSenderRef;
  final int lastEventId;

  DetailsState copyWith({
    double? starAverage,
    DocumentReference? pairedUserSenderRef,
    bool clearPaired = false,
    int? lastEventId,
  }) {
    return DetailsState(
      starAverage: starAverage ?? this.starAverage,
      pairedUserSenderRef: clearPaired
          ? null
          : (pairedUserSenderRef ?? this.pairedUserSenderRef),
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [starAverage, pairedUserSenderRef, lastEventId];
}
