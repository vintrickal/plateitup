import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _tempHideWidget = prefs.getBool('ff_tempHideWidget') ?? _tempHideWidget;
    });
    _safeInit(() {
      _hasPartner = prefs.getBool('ff_hasPartner') ?? _hasPartner;
    });
    _safeInit(() {
      _pairedUserCollection = prefs.getString('ff_pairedUserCollection')?.ref ??
          _pairedUserCollection;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  int _stepsCount = 0;
  int get stepsCount => _stepsCount;
  set stepsCount(int _value) {
    _stepsCount = _value;
  }

  bool _isBannerUploaded = false;
  bool get isBannerUploaded => _isBannerUploaded;
  set isBannerUploaded(bool _value) {
    _isBannerUploaded = _value;
  }

  bool _isIngredientBannerUploaded = false;
  bool get isIngredientBannerUploaded => _isIngredientBannerUploaded;
  set isIngredientBannerUploaded(bool _value) {
    _isIngredientBannerUploaded = _value;
  }

  bool _isIngredientListNotEmpty = false;
  bool get isIngredientListNotEmpty => _isIngredientListNotEmpty;
  set isIngredientListNotEmpty(bool _value) {
    _isIngredientListNotEmpty = _value;
  }

  List<dynamic> _ingredientList = [];
  List<dynamic> get ingredientList => _ingredientList;
  set ingredientList(List<dynamic> _value) {
    _ingredientList = _value;
  }

  void addToIngredientList(dynamic _value) {
    _ingredientList.add(_value);
  }

  void removeFromIngredientList(dynamic _value) {
    _ingredientList.remove(_value);
  }

  void removeAtIndexFromIngredientList(int _index) {
    _ingredientList.removeAt(_index);
  }

  void updateIngredientListAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _ingredientList[_index] = updateFn(_ingredientList[_index]);
  }

  void insertAtIndexInIngredientList(int _index, dynamic _value) {
    _ingredientList.insert(_index, _value);
  }

  dynamic _ingredientJson;
  dynamic get ingredientJson => _ingredientJson;
  set ingredientJson(dynamic _value) {
    _ingredientJson = _value;
  }

  bool _addIsBasicRecipeInfoAdded = false;
  bool get addIsBasicRecipeInfoAdded => _addIsBasicRecipeInfoAdded;
  set addIsBasicRecipeInfoAdded(bool _value) {
    _addIsBasicRecipeInfoAdded = _value;
  }

  String _addVideoLink = '';
  String get addVideoLink => _addVideoLink;
  set addVideoLink(String _value) {
    _addVideoLink = _value;
  }

  List<dynamic> _stepsList = [];
  List<dynamic> get stepsList => _stepsList;
  set stepsList(List<dynamic> _value) {
    _stepsList = _value;
  }

  void addToStepsList(dynamic _value) {
    _stepsList.add(_value);
  }

  void removeFromStepsList(dynamic _value) {
    _stepsList.remove(_value);
  }

  void removeAtIndexFromStepsList(int _index) {
    _stepsList.removeAt(_index);
  }

  void updateStepsListAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _stepsList[_index] = updateFn(_stepsList[_index]);
  }

  void insertAtIndexInStepsList(int _index, dynamic _value) {
    _stepsList.insert(_index, _value);
  }

  dynamic _stepsJson;
  dynamic get stepsJson => _stepsJson;
  set stepsJson(dynamic _value) {
    _stepsJson = _value;
  }

  String _ingredientBanner = 'https://fakeimg.pl/52x52/cccccc/cccccc';
  String get ingredientBanner => _ingredientBanner;
  set ingredientBanner(String _value) {
    _ingredientBanner = _value;
  }

  bool _tempHideWidget = true;
  bool get tempHideWidget => _tempHideWidget;
  set tempHideWidget(bool _value) {
    _tempHideWidget = _value;
    prefs.setBool('ff_tempHideWidget', _value);
  }

  String _defaultAvatar =
      'https://t4.ftcdn.net/jpg/03/32/59/65/360_F_332596535_lAdLhf6KzbW6PWXBWeIFTovTii1drkbT.jpg';
  String get defaultAvatar => _defaultAvatar;
  set defaultAvatar(String _value) {
    _defaultAvatar = _value;
  }

  List<DocumentReference> _savedRecipeList = [];
  List<DocumentReference> get savedRecipeList => _savedRecipeList;
  set savedRecipeList(List<DocumentReference> _value) {
    _savedRecipeList = _value;
  }

  void addToSavedRecipeList(DocumentReference _value) {
    _savedRecipeList.add(_value);
  }

  void removeFromSavedRecipeList(DocumentReference _value) {
    _savedRecipeList.remove(_value);
  }

  void removeAtIndexFromSavedRecipeList(int _index) {
    _savedRecipeList.removeAt(_index);
  }

  void updateSavedRecipeListAtIndex(
    int _index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    _savedRecipeList[_index] = updateFn(_savedRecipeList[_index]);
  }

  void insertAtIndexInSavedRecipeList(int _index, DocumentReference _value) {
    _savedRecipeList.insert(_index, _value);
  }

  bool _isShowFullList = true;
  bool get isShowFullList => _isShowFullList;
  set isShowFullList(bool _value) {
    _isShowFullList = _value;
  }

  bool _signupWasTapped = false;
  bool get signupWasTapped => _signupWasTapped;
  set signupWasTapped(bool _value) {
    _signupWasTapped = _value;
  }

  bool _hasPartner = false;
  bool get hasPartner => _hasPartner;
  set hasPartner(bool _value) {
    _hasPartner = _value;
    prefs.setBool('ff_hasPartner', _value);
  }

  DocumentReference? _PartnerUID;
  DocumentReference? get PartnerUID => _PartnerUID;
  set PartnerUID(DocumentReference? _value) {
    _PartnerUID = _value;
  }

  bool _isAddRecipeContentDeleted = false;
  bool get isAddRecipeContentDeleted => _isAddRecipeContentDeleted;
  set isAddRecipeContentDeleted(bool _value) {
    _isAddRecipeContentDeleted = _value;
  }

  bool _isEditRecipeContentDeleted = false;
  bool get isEditRecipeContentDeleted => _isEditRecipeContentDeleted;
  set isEditRecipeContentDeleted(bool _value) {
    _isEditRecipeContentDeleted = _value;
  }

  bool _yesPleaseBtnPressed = false;
  bool get yesPleaseBtnPressed => _yesPleaseBtnPressed;
  set yesPleaseBtnPressed(bool _value) {
    _yesPleaseBtnPressed = _value;
  }

  bool _mealRequestedCollectionEmpty = false;
  bool get mealRequestedCollectionEmpty => _mealRequestedCollectionEmpty;
  set mealRequestedCollectionEmpty(bool _value) {
    _mealRequestedCollectionEmpty = _value;
  }

  bool _yesImSureButtonPressed = false;
  bool get yesImSureButtonPressed => _yesImSureButtonPressed;
  set yesImSureButtonPressed(bool _value) {
    _yesImSureButtonPressed = _value;
  }

  bool _isUserDoneWithAddRecipe = false;
  bool get isUserDoneWithAddRecipe => _isUserDoneWithAddRecipe;
  set isUserDoneWithAddRecipe(bool _value) {
    _isUserDoneWithAddRecipe = _value;
  }

  bool _isUserDoneWithEditRecipe = false;
  bool get isUserDoneWithEditRecipe => _isUserDoneWithEditRecipe;
  set isUserDoneWithEditRecipe(bool _value) {
    _isUserDoneWithEditRecipe = _value;
  }

  DocumentReference? _pairedUserCollection;
  DocumentReference? get pairedUserCollection => _pairedUserCollection;
  set pairedUserCollection(DocumentReference? _value) {
    _pairedUserCollection = _value;
    _value != null
        ? prefs.setString('ff_pairedUserCollection', _value.path)
        : prefs.remove('ff_pairedUserCollection');
  }

  DateTime? _estimatedTimeSpinner =
      DateTime.fromMillisecondsSinceEpoch(1714665600000);
  DateTime? get estimatedTimeSpinner => _estimatedTimeSpinner;
  set estimatedTimeSpinner(DateTime? _value) {
    _estimatedTimeSpinner = _value;
  }

  int _counterBtnClicked = 0;
  int get counterBtnClicked => _counterBtnClicked;
  set counterBtnClicked(int _value) {
    _counterBtnClicked = _value;
  }

  IngredientStruct _ingredientInfoEdited = IngredientStruct.fromSerializableMap(
      jsonDecode(
          '{\"ingr_name\":\"\'\'\",\"ingr_quantity\":\"\'\'\",\"ingr_unit\":\"\'\'\"}'));
  IngredientStruct get ingredientInfoEdited => _ingredientInfoEdited;
  set ingredientInfoEdited(IngredientStruct _value) {
    _ingredientInfoEdited = _value;
  }

  void updateIngredientInfoEditedStruct(Function(IngredientStruct) updateFn) {
    updateFn(_ingredientInfoEdited);
  }

  bool _isIngredientInfoToBeEdited = false;
  bool get isIngredientInfoToBeEdited => _isIngredientInfoToBeEdited;
  set isIngredientInfoToBeEdited(bool _value) {
    _isIngredientInfoToBeEdited = _value;
  }

  List<ProcedureStruct> _procedureList = [];
  List<ProcedureStruct> get procedureList => _procedureList;
  set procedureList(List<ProcedureStruct> _value) {
    _procedureList = _value;
  }

  void addToProcedureList(ProcedureStruct _value) {
    _procedureList.add(_value);
  }

  void removeFromProcedureList(ProcedureStruct _value) {
    _procedureList.remove(_value);
  }

  void removeAtIndexFromProcedureList(int _index) {
    _procedureList.removeAt(_index);
  }

  void updateProcedureListAtIndex(
    int _index,
    ProcedureStruct Function(ProcedureStruct) updateFn,
  ) {
    _procedureList[_index] = updateFn(_procedureList[_index]);
  }

  void insertAtIndexInProcedureList(int _index, ProcedureStruct _value) {
    _procedureList.insert(_index, _value);
  }

  ProcedureStruct _procedureJson =
      ProcedureStruct.fromSerializableMap(jsonDecode('{\"steps\":\"\"}'));
  ProcedureStruct get procedureJson => _procedureJson;
  set procedureJson(ProcedureStruct _value) {
    _procedureJson = _value;
  }

  void updateProcedureJsonStruct(Function(ProcedureStruct) updateFn) {
    updateFn(_procedureJson);
  }

  bool _isProcedureItemEdited = false;
  bool get isProcedureItemEdited => _isProcedureItemEdited;
  set isProcedureItemEdited(bool _value) {
    _isProcedureItemEdited = _value;
  }

  bool _wasProcedureListReordered = false;
  bool get wasProcedureListReordered => _wasProcedureListReordered;
  set wasProcedureListReordered(bool _value) {
    _wasProcedureListReordered = _value;
  }

  List<IngredientStruct> _ingredientNewList = [];
  List<IngredientStruct> get ingredientNewList => _ingredientNewList;
  set ingredientNewList(List<IngredientStruct> _value) {
    _ingredientNewList = _value;
  }

  void addToIngredientNewList(IngredientStruct _value) {
    _ingredientNewList.add(_value);
  }

  void removeFromIngredientNewList(IngredientStruct _value) {
    _ingredientNewList.remove(_value);
  }

  void removeAtIndexFromIngredientNewList(int _index) {
    _ingredientNewList.removeAt(_index);
  }

  void updateIngredientNewListAtIndex(
    int _index,
    IngredientStruct Function(IngredientStruct) updateFn,
  ) {
    _ingredientNewList[_index] = updateFn(_ingredientNewList[_index]);
  }

  void insertAtIndexInIngredientNewList(int _index, IngredientStruct _value) {
    _ingredientNewList.insert(_index, _value);
  }

  bool _wasIngredientListReordered = false;
  bool get wasIngredientListReordered => _wasIngredientListReordered;
  set wasIngredientListReordered(bool _value) {
    _wasIngredientListReordered = _value;
  }

  List<String> _recipeCategories = [
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
    'Vegetarian'
  ];
  List<String> get recipeCategories => _recipeCategories;
  set recipeCategories(List<String> _value) {
    _recipeCategories = _value;
  }

  void addToRecipeCategories(String _value) {
    _recipeCategories.add(_value);
  }

  void removeFromRecipeCategories(String _value) {
    _recipeCategories.remove(_value);
  }

  void removeAtIndexFromRecipeCategories(int _index) {
    _recipeCategories.removeAt(_index);
  }

  void updateRecipeCategoriesAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _recipeCategories[_index] = updateFn(_recipeCategories[_index]);
  }

  void insertAtIndexInRecipeCategories(int _index, String _value) {
    _recipeCategories.insert(_index, _value);
  }

  List<String> _chosenRecipeCategory = [];
  List<String> get chosenRecipeCategory => _chosenRecipeCategory;
  set chosenRecipeCategory(List<String> _value) {
    _chosenRecipeCategory = _value;
  }

  void addToChosenRecipeCategory(String _value) {
    _chosenRecipeCategory.add(_value);
  }

  void removeFromChosenRecipeCategory(String _value) {
    _chosenRecipeCategory.remove(_value);
  }

  void removeAtIndexFromChosenRecipeCategory(int _index) {
    _chosenRecipeCategory.removeAt(_index);
  }

  void updateChosenRecipeCategoryAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _chosenRecipeCategory[_index] = updateFn(_chosenRecipeCategory[_index]);
  }

  void insertAtIndexInChosenRecipeCategory(int _index, String _value) {
    _chosenRecipeCategory.insert(_index, _value);
  }

  List<String> _staticStringList = [' '];
  List<String> get staticStringList => _staticStringList;
  set staticStringList(List<String> _value) {
    _staticStringList = _value;
  }

  void addToStaticStringList(String _value) {
    _staticStringList.add(_value);
  }

  void removeFromStaticStringList(String _value) {
    _staticStringList.remove(_value);
  }

  void removeAtIndexFromStaticStringList(int _index) {
    _staticStringList.removeAt(_index);
  }

  void updateStaticStringListAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _staticStringList[_index] = updateFn(_staticStringList[_index]);
  }

  void insertAtIndexInStaticStringList(int _index, String _value) {
    _staticStringList.insert(_index, _value);
  }

  List<String> _recipeCategoryFromFirebase = [];
  List<String> get recipeCategoryFromFirebase => _recipeCategoryFromFirebase;
  set recipeCategoryFromFirebase(List<String> _value) {
    _recipeCategoryFromFirebase = _value;
  }

  void addToRecipeCategoryFromFirebase(String _value) {
    _recipeCategoryFromFirebase.add(_value);
  }

  void removeFromRecipeCategoryFromFirebase(String _value) {
    _recipeCategoryFromFirebase.remove(_value);
  }

  void removeAtIndexFromRecipeCategoryFromFirebase(int _index) {
    _recipeCategoryFromFirebase.removeAt(_index);
  }

  void updateRecipeCategoryFromFirebaseAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _recipeCategoryFromFirebase[_index] =
        updateFn(_recipeCategoryFromFirebase[_index]);
  }

  void insertAtIndexInRecipeCategoryFromFirebase(int _index, String _value) {
    _recipeCategoryFromFirebase.insert(_index, _value);
  }

  String _attributionTemp = '';
  String get attributionTemp => _attributionTemp;
  set attributionTemp(String _value) {
    _attributionTemp = _value;
  }

  List<String> _homeRecipeCategory = [
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
    'Vegetarian'
  ];
  List<String> get homeRecipeCategory => _homeRecipeCategory;
  set homeRecipeCategory(List<String> _value) {
    _homeRecipeCategory = _value;
  }

  void addToHomeRecipeCategory(String _value) {
    _homeRecipeCategory.add(_value);
  }

  void removeFromHomeRecipeCategory(String _value) {
    _homeRecipeCategory.remove(_value);
  }

  void removeAtIndexFromHomeRecipeCategory(int _index) {
    _homeRecipeCategory.removeAt(_index);
  }

  void updateHomeRecipeCategoryAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _homeRecipeCategory[_index] = updateFn(_homeRecipeCategory[_index]);
  }

  void insertAtIndexInHomeRecipeCategory(int _index, String _value) {
    _homeRecipeCategory.insert(_index, _value);
  }

  bool _isMealFilteredByCategory = false;
  bool get isMealFilteredByCategory => _isMealFilteredByCategory;
  set isMealFilteredByCategory(bool _value) {
    _isMealFilteredByCategory = _value;
  }

  List<String> _metricAndImperial = [
    'pc/s',
    'tsp',
    'tbsp',
    'cup',
    'ml',
    'liter',
    'g',
    'kg'
  ];
  List<String> get metricAndImperial => _metricAndImperial;
  set metricAndImperial(List<String> _value) {
    _metricAndImperial = _value;
  }

  void addToMetricAndImperial(String _value) {
    _metricAndImperial.add(_value);
  }

  void removeFromMetricAndImperial(String _value) {
    _metricAndImperial.remove(_value);
  }

  void removeAtIndexFromMetricAndImperial(int _index) {
    _metricAndImperial.removeAt(_index);
  }

  void updateMetricAndImperialAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _metricAndImperial[_index] = updateFn(_metricAndImperial[_index]);
  }

  void insertAtIndexInMetricAndImperial(int _index, String _value) {
    _metricAndImperial.insert(_index, _value);
  }

  bool _doesThisEmailExist = false;
  bool get doesThisEmailExist => _doesThisEmailExist;
  set doesThisEmailExist(bool _value) {
    _doesThisEmailExist = _value;
  }

  bool _isSearchEmailBtnClicked = false;
  bool get isSearchEmailBtnClicked => _isSearchEmailBtnClicked;
  set isSearchEmailBtnClicked(bool _value) {
    _isSearchEmailBtnClicked = _value;
  }

  List<DocumentReference> _inboxNotification = [];
  List<DocumentReference> get inboxNotification => _inboxNotification;
  set inboxNotification(List<DocumentReference> _value) {
    _inboxNotification = _value;
  }

  void addToInboxNotification(DocumentReference _value) {
    _inboxNotification.add(_value);
  }

  void removeFromInboxNotification(DocumentReference _value) {
    _inboxNotification.remove(_value);
  }

  void removeAtIndexFromInboxNotification(int _index) {
    _inboxNotification.removeAt(_index);
  }

  void updateInboxNotificationAtIndex(
    int _index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    _inboxNotification[_index] = updateFn(_inboxNotification[_index]);
  }

  void insertAtIndexInInboxNotification(int _index, DocumentReference _value) {
    _inboxNotification.insert(_index, _value);
  }

  List<String> _tappedCategoryName = [];
  List<String> get tappedCategoryName => _tappedCategoryName;
  set tappedCategoryName(List<String> _value) {
    _tappedCategoryName = _value;
  }

  void addToTappedCategoryName(String _value) {
    _tappedCategoryName.add(_value);
  }

  void removeFromTappedCategoryName(String _value) {
    _tappedCategoryName.remove(_value);
  }

  void removeAtIndexFromTappedCategoryName(int _index) {
    _tappedCategoryName.removeAt(_index);
  }

  void updateTappedCategoryNameAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _tappedCategoryName[_index] = updateFn(_tappedCategoryName[_index]);
  }

  void insertAtIndexInTappedCategoryName(int _index, String _value) {
    _tappedCategoryName.insert(_index, _value);
  }

  bool _receiverNotificationDisplayed = false;
  bool get receiverNotificationDisplayed => _receiverNotificationDisplayed;
  set receiverNotificationDisplayed(bool _value) {
    _receiverNotificationDisplayed = _value;
  }

  bool _senderNotificationDisplayed = false;
  bool get senderNotificationDisplayed => _senderNotificationDisplayed;
  set senderNotificationDisplayed(bool _value) {
    _senderNotificationDisplayed = _value;
  }

  bool _noMoreNotification = false;
  bool get noMoreNotification => _noMoreNotification;
  set noMoreNotification(bool _value) {
    _noMoreNotification = _value;
  }

  bool _yesPublishToPublic = false;
  bool get yesPublishToPublic => _yesPublishToPublic;
  set yesPublishToPublic(bool _value) {
    _yesPublishToPublic = _value;
  }

  bool _yesFinishRecipeLater = false;
  bool get yesFinishRecipeLater => _yesFinishRecipeLater;
  set yesFinishRecipeLater(bool _value) {
    _yesFinishRecipeLater = _value;
  }

  bool _yesDeleteAction = false;
  bool get yesDeleteAction => _yesDeleteAction;
  set yesDeleteAction(bool _value) {
    _yesDeleteAction = _value;
  }

  bool _isChangeEmailBtnTapped = false;
  bool get isChangeEmailBtnTapped => _isChangeEmailBtnTapped;
  set isChangeEmailBtnTapped(bool _value) {
    _isChangeEmailBtnTapped = _value;
  }

  bool _noMoreMealRecipe = false;
  bool get noMoreMealRecipe => _noMoreMealRecipe;
  set noMoreMealRecipe(bool _value) {
    _noMoreMealRecipe = _value;
  }

  bool _noMoreSavedRecipe = false;
  bool get noMoreSavedRecipe => _noMoreSavedRecipe;
  set noMoreSavedRecipe(bool _value) {
    _noMoreSavedRecipe = _value;
  }

  bool _isPasswordValidated = true;
  bool get isPasswordValidated => _isPasswordValidated;
  set isPasswordValidated(bool _value) {
    _isPasswordValidated = _value;
  }

  bool _isChangePasswordBtnClicked = false;
  bool get isChangePasswordBtnClicked => _isChangePasswordBtnClicked;
  set isChangePasswordBtnClicked(bool _value) {
    _isChangePasswordBtnClicked = _value;
  }

  dynamic _feedbackJson;
  dynamic get feedbackJson => _feedbackJson;
  set feedbackJson(dynamic _value) {
    _feedbackJson = _value;
  }

  bool _isReviewExist = false;
  bool get isReviewExist => _isReviewExist;
  set isReviewExist(bool _value) {
    _isReviewExist = _value;
  }

  bool _isReviewTabEmpty = true;
  bool get isReviewTabEmpty => _isReviewTabEmpty;
  set isReviewTabEmpty(bool _value) {
    _isReviewTabEmpty = _value;
  }

  int _accumulatedStar = 0;
  int get accumulatedStar => _accumulatedStar;
  set accumulatedStar(int _value) {
    _accumulatedStar = _value;
  }

  int _onloadCounter = 0;
  int get onloadCounter => _onloadCounter;
  set onloadCounter(int _value) {
    _onloadCounter = _value;
  }

  bool _isNotificationEnabled = false;
  bool get isNotificationEnabled => _isNotificationEnabled;
  set isNotificationEnabled(bool _value) {
    _isNotificationEnabled = _value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
