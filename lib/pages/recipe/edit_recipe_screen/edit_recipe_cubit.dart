import 'package:bloc/bloc.dart';

import 'edit_recipe_state.dart';

/// Drives [EditRecipeScreenWidget]. Two toggles plus a placeholder for any
/// future page-load orchestration (e.g. seeding ingredient/procedure lists
/// from the meal record — currently done inline in the widget's initState).
class EditRecipeCubit extends Cubit<EditRecipeState> {
  EditRecipeCubit() : super(const EditRecipeState());

  void setPublishToPublic(bool v) =>
      emit(state.copyWith(publishToPublic: v));

  void setIsOriginalRecipe(bool v) =>
      emit(state.copyWith(isOriginalRecipe: v));
}
