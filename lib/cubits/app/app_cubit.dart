import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'app_state.dart';

/// Global app-state cubit. Single instance per app, accessible from
/// non-widget code via [AppCubit.instance] and from widgets via
/// `context.read<AppCubit>()` / `BlocBuilder<AppCubit, AppState>`.
///
/// State is immutable ([AppState] + [Equatable]) so widgets rebuild only
/// when the fields they actually watch change. Mutations go through the
/// `set*` / `addTo*` / `removeFrom*` / `updateXAtIndex` methods below;
/// each one emits a new [AppState] via `copyWith`.
class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  /// Singleton for non-widget callers (other cubits, helpers, custom code).
  /// Widgets should prefer `context.read<AppCubit>()` for testability.
  static final AppCubit instance = AppCubit();

  SharedPreferences? _prefs;

  /// Rehydrate the persisted fields. Call once at startup, before [runApp].
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final prefs = _prefs!;
    emit(state.copyWith(
      tempHideWidget: prefs.getBool('ff_tempHideWidget') ?? state.tempHideWidget,
      hasPartner: prefs.getBool('ff_hasPartner') ?? state.hasPartner,
      pairedUserCollection:
          prefs.getString('ff_pairedUserCollection')?.ref ??
              state.pairedUserCollection,
    ));
  }

  // ---------------------------------------------------------------------------
  // Simple setters. Named [set*] (not just the field name) so callsites read
  // like commands rather than assignments — matches Bloc conventions.
  // ---------------------------------------------------------------------------

  void setStepsCount(int v) => emit(state.copyWith(stepsCount: v));
  void setIsBannerUploaded(bool v) =>
      emit(state.copyWith(isBannerUploaded: v));
  void setIsIngredientBannerUploaded(bool v) =>
      emit(state.copyWith(isIngredientBannerUploaded: v));
  void setIsIngredientListNotEmpty(bool v) =>
      emit(state.copyWith(isIngredientListNotEmpty: v));
  void setIngredientList(List<dynamic> v) =>
      emit(state.copyWith(ingredientList: List.of(v)));
  void setIngredientJson(dynamic v) =>
      emit(state.copyWith(ingredientJson: v));
  void setAddIsBasicRecipeInfoAdded(bool v) =>
      emit(state.copyWith(addIsBasicRecipeInfoAdded: v));
  void setAddVideoLink(String v) => emit(state.copyWith(addVideoLink: v));
  void setStepsList(List<dynamic> v) =>
      emit(state.copyWith(stepsList: List.of(v)));
  void setStepsJson(dynamic v) => emit(state.copyWith(stepsJson: v));
  void setIngredientBanner(String v) =>
      emit(state.copyWith(ingredientBanner: v));

  void setTempHideWidget(bool v) {
    emit(state.copyWith(tempHideWidget: v));
    _prefs?.setBool('ff_tempHideWidget', v);
  }

  void setDefaultAvatar(String v) => emit(state.copyWith(defaultAvatar: v));
  void setSavedRecipeList(List<DocumentReference> v) =>
      emit(state.copyWith(savedRecipeList: List.of(v)));
  void setIsShowFullList(bool v) =>
      emit(state.copyWith(isShowFullList: v));
  void setSignupWasTapped(bool v) =>
      emit(state.copyWith(signupWasTapped: v));

  void setHasPartner(bool v) {
    emit(state.copyWith(hasPartner: v));
    _prefs?.setBool('ff_hasPartner', v);
  }

  void setPartnerUid(DocumentReference? v) =>
      emit(state.copyWith(partnerUid: v));
  void setIsAddRecipeContentDeleted(bool v) =>
      emit(state.copyWith(isAddRecipeContentDeleted: v));
  void setIsEditRecipeContentDeleted(bool v) =>
      emit(state.copyWith(isEditRecipeContentDeleted: v));
  void setYesPleaseBtnPressed(bool v) =>
      emit(state.copyWith(yesPleaseBtnPressed: v));
  void setMealRequestedCollectionEmpty(bool v) =>
      emit(state.copyWith(mealRequestedCollectionEmpty: v));
  void setYesImSureButtonPressed(bool v) =>
      emit(state.copyWith(yesImSureButtonPressed: v));
  void setIsUserDoneWithAddRecipe(bool v) =>
      emit(state.copyWith(isUserDoneWithAddRecipe: v));
  void setIsUserDoneWithEditRecipe(bool v) =>
      emit(state.copyWith(isUserDoneWithEditRecipe: v));

  void setPairedUserCollection(DocumentReference? v) {
    emit(state.copyWith(pairedUserCollection: v));
    if (v != null) {
      _prefs?.setString('ff_pairedUserCollection', v.path);
    } else {
      _prefs?.remove('ff_pairedUserCollection');
    }
  }

  void setEstimatedTimeSpinner(DateTime? v) =>
      emit(state.copyWith(estimatedTimeSpinner: v));
  void setCounterBtnClicked(int v) =>
      emit(state.copyWith(counterBtnClicked: v));
  void setIngredientInfoEdited(IngredientStruct? v) =>
      emit(state.copyWith(ingredientInfoEdited: v));
  void setIsIngredientInfoToBeEdited(bool v) =>
      emit(state.copyWith(isIngredientInfoToBeEdited: v));
  void setProcedureList(List<ProcedureStruct> v) =>
      emit(state.copyWith(procedureList: List.of(v)));
  void setProcedureJson(ProcedureStruct? v) =>
      emit(state.copyWith(procedureJson: v));
  void setIsProcedureItemEdited(bool v) =>
      emit(state.copyWith(isProcedureItemEdited: v));
  void setWasProcedureListReordered(bool v) =>
      emit(state.copyWith(wasProcedureListReordered: v));
  void setIngredientNewList(List<IngredientStruct> v) =>
      emit(state.copyWith(ingredientNewList: List.of(v)));
  void setWasIngredientListReordered(bool v) =>
      emit(state.copyWith(wasIngredientListReordered: v));
  void setRecipeCategories(List<String> v) =>
      emit(state.copyWith(recipeCategories: List.of(v)));
  void setChosenRecipeCategory(List<String> v) =>
      emit(state.copyWith(chosenRecipeCategory: List.of(v)));
  void setStaticStringList(List<String> v) =>
      emit(state.copyWith(staticStringList: List.of(v)));
  void setRecipeCategoryFromFirebase(List<String> v) =>
      emit(state.copyWith(recipeCategoryFromFirebase: List.of(v)));
  void setAttributionTemp(String v) =>
      emit(state.copyWith(attributionTemp: v));
  void setHomeRecipeCategory(List<String> v) =>
      emit(state.copyWith(homeRecipeCategory: List.of(v)));
  void setIsMealFilteredByCategory(bool v) =>
      emit(state.copyWith(isMealFilteredByCategory: v));
  void setMetricAndImperial(List<String> v) =>
      emit(state.copyWith(metricAndImperial: List.of(v)));
  void setDoesThisEmailExist(bool v) =>
      emit(state.copyWith(doesThisEmailExist: v));
  void setIsSearchEmailBtnClicked(bool v) =>
      emit(state.copyWith(isSearchEmailBtnClicked: v));
  void setInboxNotification(List<DocumentReference> v) =>
      emit(state.copyWith(inboxNotification: List.of(v)));
  void setTappedCategoryName(List<String> v) =>
      emit(state.copyWith(tappedCategoryName: List.of(v)));
  void setReceiverNotificationDisplayed(bool v) =>
      emit(state.copyWith(receiverNotificationDisplayed: v));
  void setSenderNotificationDisplayed(bool v) =>
      emit(state.copyWith(senderNotificationDisplayed: v));
  void setNoMoreNotification(bool v) =>
      emit(state.copyWith(noMoreNotification: v));
  void setYesPublishToPublic(bool v) =>
      emit(state.copyWith(yesPublishToPublic: v));
  void setYesFinishRecipeLater(bool v) =>
      emit(state.copyWith(yesFinishRecipeLater: v));
  void setYesDeleteAction(bool v) =>
      emit(state.copyWith(yesDeleteAction: v));
  void setIsChangeEmailBtnTapped(bool v) =>
      emit(state.copyWith(isChangeEmailBtnTapped: v));
  void setNoMoreMealRecipe(bool v) =>
      emit(state.copyWith(noMoreMealRecipe: v));
  void setNoMoreSavedRecipe(bool v) =>
      emit(state.copyWith(noMoreSavedRecipe: v));
  void setIsPasswordValidated(bool v) =>
      emit(state.copyWith(isPasswordValidated: v));
  void setIsChangePasswordBtnClicked(bool v) =>
      emit(state.copyWith(isChangePasswordBtnClicked: v));
  void setFeedbackJson(dynamic v) => emit(state.copyWith(feedbackJson: v));
  void setIsReviewExist(bool v) => emit(state.copyWith(isReviewExist: v));
  void setIsReviewTabEmpty(bool v) =>
      emit(state.copyWith(isReviewTabEmpty: v));
  void setAccumulatedStar(int v) =>
      emit(state.copyWith(accumulatedStar: v));
  void setOnloadCounter(int v) => emit(state.copyWith(onloadCounter: v));
  void setIsNotificationEnabled(bool v) =>
      emit(state.copyWith(isNotificationEnabled: v));

  // ---------------------------------------------------------------------------
  // List helpers. Each emits a fresh List so Equatable detects the change —
  // mutating the existing list in place would not produce a new state.
  // ---------------------------------------------------------------------------

  void addToIngredientList(dynamic v) =>
      setIngredientList([...state.ingredientList, v]);
  void removeFromIngredientList(dynamic v) =>
      setIngredientList([...state.ingredientList]..remove(v));
  void removeAtIndexFromIngredientList(int i) =>
      setIngredientList([...state.ingredientList]..removeAt(i));
  void updateIngredientListAtIndex(
          int i, dynamic Function(dynamic) update) =>
      setIngredientList([...state.ingredientList]..[i] =
          update(state.ingredientList[i]));
  void insertAtIndexInIngredientList(int i, dynamic v) =>
      setIngredientList([...state.ingredientList]..insert(i, v));

  void addToStepsList(dynamic v) => setStepsList([...state.stepsList, v]);
  void removeFromStepsList(dynamic v) =>
      setStepsList([...state.stepsList]..remove(v));
  void removeAtIndexFromStepsList(int i) =>
      setStepsList([...state.stepsList]..removeAt(i));
  void updateStepsListAtIndex(int i, dynamic Function(dynamic) update) =>
      setStepsList([...state.stepsList]..[i] = update(state.stepsList[i]));
  void insertAtIndexInStepsList(int i, dynamic v) =>
      setStepsList([...state.stepsList]..insert(i, v));

  void addToSavedRecipeList(DocumentReference v) =>
      setSavedRecipeList([...state.savedRecipeList, v]);
  void removeFromSavedRecipeList(DocumentReference v) =>
      setSavedRecipeList([...state.savedRecipeList]..remove(v));
  void removeAtIndexFromSavedRecipeList(int i) =>
      setSavedRecipeList([...state.savedRecipeList]..removeAt(i));
  void updateSavedRecipeListAtIndex(
          int i, DocumentReference Function(DocumentReference) update) =>
      setSavedRecipeList([...state.savedRecipeList]..[i] =
          update(state.savedRecipeList[i]));
  void insertAtIndexInSavedRecipeList(int i, DocumentReference v) =>
      setSavedRecipeList([...state.savedRecipeList]..insert(i, v));

  void addToProcedureList(ProcedureStruct v) =>
      setProcedureList([...state.procedureList, v]);
  void removeFromProcedureList(ProcedureStruct v) =>
      setProcedureList([...state.procedureList]..remove(v));
  void removeAtIndexFromProcedureList(int i) =>
      setProcedureList([...state.procedureList]..removeAt(i));
  void updateProcedureListAtIndex(
          int i, ProcedureStruct Function(ProcedureStruct) update) =>
      setProcedureList([...state.procedureList]..[i] =
          update(state.procedureList[i]));
  void insertAtIndexInProcedureList(int i, ProcedureStruct v) =>
      setProcedureList([...state.procedureList]..insert(i, v));

  void addToIngredientNewList(IngredientStruct v) =>
      setIngredientNewList([...state.ingredientNewList, v]);
  void removeFromIngredientNewList(IngredientStruct v) =>
      setIngredientNewList([...state.ingredientNewList]..remove(v));
  void removeAtIndexFromIngredientNewList(int i) =>
      setIngredientNewList([...state.ingredientNewList]..removeAt(i));
  void updateIngredientNewListAtIndex(
          int i, IngredientStruct Function(IngredientStruct) update) =>
      setIngredientNewList([...state.ingredientNewList]..[i] =
          update(state.ingredientNewList[i]));
  void insertAtIndexInIngredientNewList(int i, IngredientStruct v) =>
      setIngredientNewList([...state.ingredientNewList]..insert(i, v));

  void addToRecipeCategories(String v) =>
      setRecipeCategories([...state.recipeCategories, v]);
  void removeFromRecipeCategories(String v) =>
      setRecipeCategories([...state.recipeCategories]..remove(v));
  void removeAtIndexFromRecipeCategories(int i) =>
      setRecipeCategories([...state.recipeCategories]..removeAt(i));
  void updateRecipeCategoriesAtIndex(int i, String Function(String) update) =>
      setRecipeCategories([...state.recipeCategories]..[i] =
          update(state.recipeCategories[i]));
  void insertAtIndexInRecipeCategories(int i, String v) =>
      setRecipeCategories([...state.recipeCategories]..insert(i, v));

  void addToChosenRecipeCategory(String v) =>
      setChosenRecipeCategory([...state.chosenRecipeCategory, v]);
  void removeFromChosenRecipeCategory(String v) =>
      setChosenRecipeCategory([...state.chosenRecipeCategory]..remove(v));
  void removeAtIndexFromChosenRecipeCategory(int i) =>
      setChosenRecipeCategory([...state.chosenRecipeCategory]..removeAt(i));
  void updateChosenRecipeCategoryAtIndex(
          int i, String Function(String) update) =>
      setChosenRecipeCategory([...state.chosenRecipeCategory]..[i] =
          update(state.chosenRecipeCategory[i]));
  void insertAtIndexInChosenRecipeCategory(int i, String v) =>
      setChosenRecipeCategory([...state.chosenRecipeCategory]..insert(i, v));

  void addToStaticStringList(String v) =>
      setStaticStringList([...state.staticStringList, v]);
  void removeFromStaticStringList(String v) =>
      setStaticStringList([...state.staticStringList]..remove(v));
  void removeAtIndexFromStaticStringList(int i) =>
      setStaticStringList([...state.staticStringList]..removeAt(i));
  void updateStaticStringListAtIndex(int i, String Function(String) update) =>
      setStaticStringList([...state.staticStringList]..[i] =
          update(state.staticStringList[i]));
  void insertAtIndexInStaticStringList(int i, String v) =>
      setStaticStringList([...state.staticStringList]..insert(i, v));

  void addToRecipeCategoryFromFirebase(String v) =>
      setRecipeCategoryFromFirebase([...state.recipeCategoryFromFirebase, v]);
  void removeFromRecipeCategoryFromFirebase(String v) =>
      setRecipeCategoryFromFirebase(
          [...state.recipeCategoryFromFirebase]..remove(v));
  void removeAtIndexFromRecipeCategoryFromFirebase(int i) =>
      setRecipeCategoryFromFirebase(
          [...state.recipeCategoryFromFirebase]..removeAt(i));
  void updateRecipeCategoryFromFirebaseAtIndex(
          int i, String Function(String) update) =>
      setRecipeCategoryFromFirebase([...state.recipeCategoryFromFirebase]
        ..[i] = update(state.recipeCategoryFromFirebase[i]));
  void insertAtIndexInRecipeCategoryFromFirebase(int i, String v) =>
      setRecipeCategoryFromFirebase(
          [...state.recipeCategoryFromFirebase]..insert(i, v));

  void addToHomeRecipeCategory(String v) =>
      setHomeRecipeCategory([...state.homeRecipeCategory, v]);
  void removeFromHomeRecipeCategory(String v) =>
      setHomeRecipeCategory([...state.homeRecipeCategory]..remove(v));
  void removeAtIndexFromHomeRecipeCategory(int i) =>
      setHomeRecipeCategory([...state.homeRecipeCategory]..removeAt(i));
  void updateHomeRecipeCategoryAtIndex(
          int i, String Function(String) update) =>
      setHomeRecipeCategory([...state.homeRecipeCategory]..[i] =
          update(state.homeRecipeCategory[i]));
  void insertAtIndexInHomeRecipeCategory(int i, String v) =>
      setHomeRecipeCategory([...state.homeRecipeCategory]..insert(i, v));

  void addToMetricAndImperial(String v) =>
      setMetricAndImperial([...state.metricAndImperial, v]);
  void removeFromMetricAndImperial(String v) =>
      setMetricAndImperial([...state.metricAndImperial]..remove(v));
  void removeAtIndexFromMetricAndImperial(int i) =>
      setMetricAndImperial([...state.metricAndImperial]..removeAt(i));
  void updateMetricAndImperialAtIndex(
          int i, String Function(String) update) =>
      setMetricAndImperial([...state.metricAndImperial]..[i] =
          update(state.metricAndImperial[i]));
  void insertAtIndexInMetricAndImperial(int i, String v) =>
      setMetricAndImperial([...state.metricAndImperial]..insert(i, v));

  void addToInboxNotification(DocumentReference v) =>
      setInboxNotification([...state.inboxNotification, v]);
  void removeFromInboxNotification(DocumentReference v) =>
      setInboxNotification([...state.inboxNotification]..remove(v));
  void removeAtIndexFromInboxNotification(int i) =>
      setInboxNotification([...state.inboxNotification]..removeAt(i));
  void updateInboxNotificationAtIndex(
          int i, DocumentReference Function(DocumentReference) update) =>
      setInboxNotification([...state.inboxNotification]..[i] =
          update(state.inboxNotification[i]));
  void insertAtIndexInInboxNotification(int i, DocumentReference v) =>
      setInboxNotification([...state.inboxNotification]..insert(i, v));

  void addToTappedCategoryName(String v) =>
      setTappedCategoryName([...state.tappedCategoryName, v]);
  void removeFromTappedCategoryName(String v) =>
      setTappedCategoryName([...state.tappedCategoryName]..remove(v));
  void removeAtIndexFromTappedCategoryName(int i) =>
      setTappedCategoryName([...state.tappedCategoryName]..removeAt(i));
  void updateTappedCategoryNameAtIndex(
          int i, String Function(String) update) =>
      setTappedCategoryName([...state.tappedCategoryName]..[i] =
          update(state.tappedCategoryName[i]));
  void insertAtIndexInTappedCategoryName(int i, String v) =>
      setTappedCategoryName([...state.tappedCategoryName]..insert(i, v));

  // ---------------------------------------------------------------------------
  // Struct helpers — mutate a *copy* so Equatable sees the change.
  // ---------------------------------------------------------------------------

  void updateIngredientInfoEditedStruct(
      void Function(IngredientStruct) update) {
    final current = state.ingredientInfoEdited ?? IngredientStruct();
    update(current);
    emit(state.copyWith(ingredientInfoEdited: current));
  }

  void updateProcedureJsonStruct(void Function(ProcedureStruct) update) {
    final current = state.procedureJson ?? ProcedureStruct();
    update(current);
    emit(state.copyWith(procedureJson: current));
  }
}
