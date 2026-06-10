import 'package:equatable/equatable.dart';

/// State for [AddRecipeScreenWidget].
///
/// Most of the page's "state" actually lives in widget-local controllers
/// (text fields, scrolls, focus nodes, dropdown form controllers). The
/// cubit owns the two toggles that drive top-level UI branching:
///   * [publishToPublic] — the "switch_status" pill. When true the back
///     button runs the publishing guards (title required, attribution
///     required, etc.) before allowing exit.
///   * [isOriginalRecipe] — the checkbox under attribution. Clears the
///     attribution text when ticked.
class AddRecipeState extends Equatable {
  const AddRecipeState({
    this.publishToPublic = false,
    this.isOriginalRecipe = false,
    this.lastEventId = 0,
  });

  final bool publishToPublic;
  final bool isOriginalRecipe;
  final int lastEventId;

  AddRecipeState copyWith({
    bool? publishToPublic,
    bool? isOriginalRecipe,
    int? lastEventId,
  }) {
    return AddRecipeState(
      publishToPublic: publishToPublic ?? this.publishToPublic,
      isOriginalRecipe: isOriginalRecipe ?? this.isOriginalRecipe,
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [publishToPublic, isOriginalRecipe, lastEventId];
}
