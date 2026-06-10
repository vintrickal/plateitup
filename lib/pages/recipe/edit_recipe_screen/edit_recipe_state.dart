import 'package:equatable/equatable.dart';

/// State for [EditRecipeScreenWidget].
///
/// Mirrors the slimmer of the two FlutterFlow recipe pages — same structure
/// as add-recipe, just operating on an existing meal. The cubit owns the
/// two toggles that gate the back-button publish guard; everything else
/// lives in widget-local controllers because TextEditingController + focus
/// nodes don't compose with immutable state.
class EditRecipeState extends Equatable {
  const EditRecipeState({
    this.publishToPublic = false,
    this.isOriginalRecipe = false,
    this.lastEventId = 0,
  });

  final bool publishToPublic;
  final bool isOriginalRecipe;
  final int lastEventId;

  EditRecipeState copyWith({
    bool? publishToPublic,
    bool? isOriginalRecipe,
    int? lastEventId,
  }) {
    return EditRecipeState(
      publishToPublic: publishToPublic ?? this.publishToPublic,
      isOriginalRecipe: isOriginalRecipe ?? this.isOriginalRecipe,
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [publishToPublic, isOriginalRecipe, lastEventId];
}
