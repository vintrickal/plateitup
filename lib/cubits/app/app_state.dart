import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/backend/schema/structs/index.dart';

/// Immutable global app state.
///
/// All fields are final; mutations go through [AppCubit] which emits a new
/// [AppState] via [copyWith]. Equatable is used so [BlocBuilder] only rebuilds
/// when a watched field actually changes.
class AppState extends Equatable {
  const AppState({
    this.stepsCount = 0,
    this.isBannerUploaded = false,
    this.isIngredientBannerUploaded = false,
    this.isIngredientListNotEmpty = false,
    this.ingredientList = const [],
    this.ingredientJson,
    this.addIsBasicRecipeInfoAdded = false,
    this.addVideoLink = '',
    this.stepsList = const [],
    this.stepsJson,
    this.ingredientBanner = 'https://fakeimg.pl/52x52/cccccc/cccccc',
    this.tempHideWidget = true,
    this.defaultAvatar =
        'https://t4.ftcdn.net/jpg/03/32/59/65/360_F_332596535_lAdLhf6KzbW6PWXBWeIFTovTii1drkbT.jpg',
    this.savedRecipeList = const [],
    this.isShowFullList = true,
    this.signupWasTapped = false,
    this.hasPartner = false,
    this.partnerUid,
    this.isAddRecipeContentDeleted = false,
    this.isEditRecipeContentDeleted = false,
    this.yesPleaseBtnPressed = false,
    this.mealRequestedCollectionEmpty = false,
    this.yesImSureButtonPressed = false,
    this.isUserDoneWithAddRecipe = false,
    this.isUserDoneWithEditRecipe = false,
    this.pairedUserCollection,
    this.estimatedTimeSpinner,
    this.counterBtnClicked = 0,
    this.ingredientInfoEdited,
    this.isIngredientInfoToBeEdited = false,
    this.procedureList = const [],
    this.procedureJson,
    this.isProcedureItemEdited = false,
    this.wasProcedureListReordered = false,
    this.ingredientNewList = const [],
    this.wasIngredientListReordered = false,
    this.recipeCategories = const [
      'Breakfast',
      'Lunch',
      'Dinner',
      'Appetizer',
      'Salad',
      'Main-course',
      'Side-dish',
      'Baked-goods',
      'Dessert',
      'Snack',
      'Soup',
      'Holiday',
      'Vegetarian',
    ],
    this.chosenRecipeCategory = const [],
    this.staticStringList = const [' '],
    this.recipeCategoryFromFirebase = const [],
    this.attributionTemp = '',
    this.homeRecipeCategory = const [
      'All',
      'Appetizer',
      'Salad',
      'Main-course',
      'Side-dish',
      'Breakfast',
      'Lunch',
      'Dinner',
      'Baked-goods',
      'Dessert',
      'Snack',
      'Soup',
      'Holiday',
      'Vegetarian',
    ],
    this.isMealFilteredByCategory = false,
    this.metricAndImperial = const [
      'pc/s',
      'tsp',
      'tbsp',
      'cup',
      'ml',
      'liter',
      'g',
      'kg',
    ],
    this.doesThisEmailExist = false,
    this.isSearchEmailBtnClicked = false,
    this.inboxNotification = const [],
    this.tappedCategoryName = const [],
    this.receiverNotificationDisplayed = false,
    this.senderNotificationDisplayed = false,
    this.noMoreNotification = false,
    this.yesPublishToPublic = false,
    this.yesFinishRecipeLater = false,
    this.yesDeleteAction = false,
    this.isChangeEmailBtnTapped = false,
    this.noMoreMealRecipe = false,
    this.noMoreSavedRecipe = false,
    this.isPasswordValidated = true,
    this.isChangePasswordBtnClicked = false,
    this.feedbackJson,
    this.isReviewExist = false,
    this.isReviewTabEmpty = true,
    this.accumulatedStar = 0,
    this.onloadCounter = 0,
    this.isNotificationEnabled = false,
  });

  // Recipe authoring
  final int stepsCount;
  final bool isBannerUploaded;
  final bool isIngredientBannerUploaded;
  final bool isIngredientListNotEmpty;
  final List<dynamic> ingredientList;
  final dynamic ingredientJson;
  final bool addIsBasicRecipeInfoAdded;
  final String addVideoLink;
  final List<dynamic> stepsList;
  final dynamic stepsJson;
  final String ingredientBanner;

  // Persisted across launches via SharedPreferences (see AppCubit.init).
  final bool tempHideWidget;

  final String defaultAvatar;
  final List<DocumentReference> savedRecipeList;
  final bool isShowFullList;
  final bool signupWasTapped;

  // Persisted.
  final bool hasPartner;

  final DocumentReference? partnerUid;
  final bool isAddRecipeContentDeleted;
  final bool isEditRecipeContentDeleted;
  final bool yesPleaseBtnPressed;
  final bool mealRequestedCollectionEmpty;
  final bool yesImSureButtonPressed;
  final bool isUserDoneWithAddRecipe;
  final bool isUserDoneWithEditRecipe;

  // Persisted.
  final DocumentReference? pairedUserCollection;

  final DateTime? estimatedTimeSpinner;
  final int counterBtnClicked;
  final IngredientStruct? ingredientInfoEdited;
  final bool isIngredientInfoToBeEdited;
  final List<ProcedureStruct> procedureList;
  final ProcedureStruct? procedureJson;
  final bool isProcedureItemEdited;
  final bool wasProcedureListReordered;
  final List<IngredientStruct> ingredientNewList;
  final bool wasIngredientListReordered;
  final List<String> recipeCategories;
  final List<String> chosenRecipeCategory;
  final List<String> staticStringList;
  final List<String> recipeCategoryFromFirebase;
  final String attributionTemp;
  final List<String> homeRecipeCategory;
  final bool isMealFilteredByCategory;
  final List<String> metricAndImperial;
  final bool doesThisEmailExist;
  final bool isSearchEmailBtnClicked;
  final List<DocumentReference> inboxNotification;
  final List<String> tappedCategoryName;
  final bool receiverNotificationDisplayed;
  final bool senderNotificationDisplayed;
  final bool noMoreNotification;
  final bool yesPublishToPublic;
  final bool yesFinishRecipeLater;
  final bool yesDeleteAction;
  final bool isChangeEmailBtnTapped;
  final bool noMoreMealRecipe;
  final bool noMoreSavedRecipe;
  final bool isPasswordValidated;
  final bool isChangePasswordBtnClicked;
  final dynamic feedbackJson;
  final bool isReviewExist;
  final bool isReviewTabEmpty;
  final int accumulatedStar;
  final int onloadCounter;
  final bool isNotificationEnabled;

  AppState copyWith({
    int? stepsCount,
    bool? isBannerUploaded,
    bool? isIngredientBannerUploaded,
    bool? isIngredientListNotEmpty,
    List<dynamic>? ingredientList,
    Object? ingredientJson = _noChange,
    bool? addIsBasicRecipeInfoAdded,
    String? addVideoLink,
    List<dynamic>? stepsList,
    Object? stepsJson = _noChange,
    String? ingredientBanner,
    bool? tempHideWidget,
    String? defaultAvatar,
    List<DocumentReference>? savedRecipeList,
    bool? isShowFullList,
    bool? signupWasTapped,
    bool? hasPartner,
    Object? partnerUid = _noChange,
    bool? isAddRecipeContentDeleted,
    bool? isEditRecipeContentDeleted,
    bool? yesPleaseBtnPressed,
    bool? mealRequestedCollectionEmpty,
    bool? yesImSureButtonPressed,
    bool? isUserDoneWithAddRecipe,
    bool? isUserDoneWithEditRecipe,
    Object? pairedUserCollection = _noChange,
    Object? estimatedTimeSpinner = _noChange,
    int? counterBtnClicked,
    Object? ingredientInfoEdited = _noChange,
    bool? isIngredientInfoToBeEdited,
    List<ProcedureStruct>? procedureList,
    Object? procedureJson = _noChange,
    bool? isProcedureItemEdited,
    bool? wasProcedureListReordered,
    List<IngredientStruct>? ingredientNewList,
    bool? wasIngredientListReordered,
    List<String>? recipeCategories,
    List<String>? chosenRecipeCategory,
    List<String>? staticStringList,
    List<String>? recipeCategoryFromFirebase,
    String? attributionTemp,
    List<String>? homeRecipeCategory,
    bool? isMealFilteredByCategory,
    List<String>? metricAndImperial,
    bool? doesThisEmailExist,
    bool? isSearchEmailBtnClicked,
    List<DocumentReference>? inboxNotification,
    List<String>? tappedCategoryName,
    bool? receiverNotificationDisplayed,
    bool? senderNotificationDisplayed,
    bool? noMoreNotification,
    bool? yesPublishToPublic,
    bool? yesFinishRecipeLater,
    bool? yesDeleteAction,
    bool? isChangeEmailBtnTapped,
    bool? noMoreMealRecipe,
    bool? noMoreSavedRecipe,
    bool? isPasswordValidated,
    bool? isChangePasswordBtnClicked,
    Object? feedbackJson = _noChange,
    bool? isReviewExist,
    bool? isReviewTabEmpty,
    int? accumulatedStar,
    int? onloadCounter,
    bool? isNotificationEnabled,
  }) {
    return AppState(
      stepsCount: stepsCount ?? this.stepsCount,
      isBannerUploaded: isBannerUploaded ?? this.isBannerUploaded,
      isIngredientBannerUploaded:
          isIngredientBannerUploaded ?? this.isIngredientBannerUploaded,
      isIngredientListNotEmpty:
          isIngredientListNotEmpty ?? this.isIngredientListNotEmpty,
      ingredientList: ingredientList ?? this.ingredientList,
      ingredientJson: identical(ingredientJson, _noChange)
          ? this.ingredientJson
          : ingredientJson,
      addIsBasicRecipeInfoAdded:
          addIsBasicRecipeInfoAdded ?? this.addIsBasicRecipeInfoAdded,
      addVideoLink: addVideoLink ?? this.addVideoLink,
      stepsList: stepsList ?? this.stepsList,
      stepsJson:
          identical(stepsJson, _noChange) ? this.stepsJson : stepsJson,
      ingredientBanner: ingredientBanner ?? this.ingredientBanner,
      tempHideWidget: tempHideWidget ?? this.tempHideWidget,
      defaultAvatar: defaultAvatar ?? this.defaultAvatar,
      savedRecipeList: savedRecipeList ?? this.savedRecipeList,
      isShowFullList: isShowFullList ?? this.isShowFullList,
      signupWasTapped: signupWasTapped ?? this.signupWasTapped,
      hasPartner: hasPartner ?? this.hasPartner,
      partnerUid: identical(partnerUid, _noChange)
          ? this.partnerUid
          : partnerUid as DocumentReference?,
      isAddRecipeContentDeleted:
          isAddRecipeContentDeleted ?? this.isAddRecipeContentDeleted,
      isEditRecipeContentDeleted:
          isEditRecipeContentDeleted ?? this.isEditRecipeContentDeleted,
      yesPleaseBtnPressed: yesPleaseBtnPressed ?? this.yesPleaseBtnPressed,
      mealRequestedCollectionEmpty:
          mealRequestedCollectionEmpty ?? this.mealRequestedCollectionEmpty,
      yesImSureButtonPressed:
          yesImSureButtonPressed ?? this.yesImSureButtonPressed,
      isUserDoneWithAddRecipe:
          isUserDoneWithAddRecipe ?? this.isUserDoneWithAddRecipe,
      isUserDoneWithEditRecipe:
          isUserDoneWithEditRecipe ?? this.isUserDoneWithEditRecipe,
      pairedUserCollection: identical(pairedUserCollection, _noChange)
          ? this.pairedUserCollection
          : pairedUserCollection as DocumentReference?,
      estimatedTimeSpinner: identical(estimatedTimeSpinner, _noChange)
          ? this.estimatedTimeSpinner
          : estimatedTimeSpinner as DateTime?,
      counterBtnClicked: counterBtnClicked ?? this.counterBtnClicked,
      ingredientInfoEdited: identical(ingredientInfoEdited, _noChange)
          ? this.ingredientInfoEdited
          : ingredientInfoEdited as IngredientStruct?,
      isIngredientInfoToBeEdited:
          isIngredientInfoToBeEdited ?? this.isIngredientInfoToBeEdited,
      procedureList: procedureList ?? this.procedureList,
      procedureJson: identical(procedureJson, _noChange)
          ? this.procedureJson
          : procedureJson as ProcedureStruct?,
      isProcedureItemEdited:
          isProcedureItemEdited ?? this.isProcedureItemEdited,
      wasProcedureListReordered:
          wasProcedureListReordered ?? this.wasProcedureListReordered,
      ingredientNewList: ingredientNewList ?? this.ingredientNewList,
      wasIngredientListReordered:
          wasIngredientListReordered ?? this.wasIngredientListReordered,
      recipeCategories: recipeCategories ?? this.recipeCategories,
      chosenRecipeCategory: chosenRecipeCategory ?? this.chosenRecipeCategory,
      staticStringList: staticStringList ?? this.staticStringList,
      recipeCategoryFromFirebase:
          recipeCategoryFromFirebase ?? this.recipeCategoryFromFirebase,
      attributionTemp: attributionTemp ?? this.attributionTemp,
      homeRecipeCategory: homeRecipeCategory ?? this.homeRecipeCategory,
      isMealFilteredByCategory:
          isMealFilteredByCategory ?? this.isMealFilteredByCategory,
      metricAndImperial: metricAndImperial ?? this.metricAndImperial,
      doesThisEmailExist: doesThisEmailExist ?? this.doesThisEmailExist,
      isSearchEmailBtnClicked:
          isSearchEmailBtnClicked ?? this.isSearchEmailBtnClicked,
      inboxNotification: inboxNotification ?? this.inboxNotification,
      tappedCategoryName: tappedCategoryName ?? this.tappedCategoryName,
      receiverNotificationDisplayed:
          receiverNotificationDisplayed ?? this.receiverNotificationDisplayed,
      senderNotificationDisplayed:
          senderNotificationDisplayed ?? this.senderNotificationDisplayed,
      noMoreNotification: noMoreNotification ?? this.noMoreNotification,
      yesPublishToPublic: yesPublishToPublic ?? this.yesPublishToPublic,
      yesFinishRecipeLater: yesFinishRecipeLater ?? this.yesFinishRecipeLater,
      yesDeleteAction: yesDeleteAction ?? this.yesDeleteAction,
      isChangeEmailBtnTapped:
          isChangeEmailBtnTapped ?? this.isChangeEmailBtnTapped,
      noMoreMealRecipe: noMoreMealRecipe ?? this.noMoreMealRecipe,
      noMoreSavedRecipe: noMoreSavedRecipe ?? this.noMoreSavedRecipe,
      isPasswordValidated: isPasswordValidated ?? this.isPasswordValidated,
      isChangePasswordBtnClicked:
          isChangePasswordBtnClicked ?? this.isChangePasswordBtnClicked,
      feedbackJson:
          identical(feedbackJson, _noChange) ? this.feedbackJson : feedbackJson,
      isReviewExist: isReviewExist ?? this.isReviewExist,
      isReviewTabEmpty: isReviewTabEmpty ?? this.isReviewTabEmpty,
      accumulatedStar: accumulatedStar ?? this.accumulatedStar,
      onloadCounter: onloadCounter ?? this.onloadCounter,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }

  @override
  List<Object?> get props => [
        stepsCount,
        isBannerUploaded,
        isIngredientBannerUploaded,
        isIngredientListNotEmpty,
        ingredientList,
        ingredientJson,
        addIsBasicRecipeInfoAdded,
        addVideoLink,
        stepsList,
        stepsJson,
        ingredientBanner,
        tempHideWidget,
        defaultAvatar,
        savedRecipeList,
        isShowFullList,
        signupWasTapped,
        hasPartner,
        partnerUid,
        isAddRecipeContentDeleted,
        isEditRecipeContentDeleted,
        yesPleaseBtnPressed,
        mealRequestedCollectionEmpty,
        yesImSureButtonPressed,
        isUserDoneWithAddRecipe,
        isUserDoneWithEditRecipe,
        pairedUserCollection,
        estimatedTimeSpinner,
        counterBtnClicked,
        ingredientInfoEdited,
        isIngredientInfoToBeEdited,
        procedureList,
        procedureJson,
        isProcedureItemEdited,
        wasProcedureListReordered,
        ingredientNewList,
        wasIngredientListReordered,
        recipeCategories,
        chosenRecipeCategory,
        staticStringList,
        recipeCategoryFromFirebase,
        attributionTemp,
        homeRecipeCategory,
        isMealFilteredByCategory,
        metricAndImperial,
        doesThisEmailExist,
        isSearchEmailBtnClicked,
        inboxNotification,
        tappedCategoryName,
        receiverNotificationDisplayed,
        senderNotificationDisplayed,
        noMoreNotification,
        yesPublishToPublic,
        yesFinishRecipeLater,
        yesDeleteAction,
        isChangeEmailBtnTapped,
        noMoreMealRecipe,
        noMoreSavedRecipe,
        isPasswordValidated,
        isChangePasswordBtnClicked,
        feedbackJson,
        isReviewExist,
        isReviewTabEmpty,
        accumulatedStar,
        onloadCounter,
        isNotificationEnabled,
      ];
}

/// Sentinel used by [AppState.copyWith] to distinguish "not provided" from
/// "set to null" for nullable fields. Without this an explicit `null` would
/// look identical to "no change" with the standard `?? this.field` pattern.
const _noChange = Object();
