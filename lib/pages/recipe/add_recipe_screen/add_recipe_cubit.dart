import 'package:bloc/bloc.dart';

import 'add_recipe_state.dart';

/// Drives [AddRecipeScreenWidget].
///
/// Tiny cubit — most of the page's complexity is widget-local text/scroll
/// controllers and Firestore writes performed inline in button handlers.
/// The cubit owns the two top-level toggles that affect what the back
/// button validates and whether the attribution field is editable.
class AddRecipeCubit extends Cubit<AddRecipeState> {
  AddRecipeCubit() : super(const AddRecipeState());

  void setPublishToPublic(bool v) =>
      emit(state.copyWith(publishToPublic: v));

  void setIsOriginalRecipe(bool v) =>
      emit(state.copyWith(isOriginalRecipe: v));
}
