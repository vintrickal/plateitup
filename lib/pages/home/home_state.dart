import 'package:equatable/equatable.dart';

import '/backend/backend.dart';

/// State for [HomeWidget]. Equatable on the fields the UI actually reads;
/// transient action-results (per-query counts the original [HomeModel] kept
/// as fields) live here too so the cubit can sequence them, but the widget
/// only watches a handful via `buildWhen`.
class HomeState extends Equatable {
  const HomeState({
    this.searchResults = const [],
    this.mealFilteredByCategory,
    this.lastEventId = 0,
  });

  /// In-page search hits from `text_search` over the meal list. Empty when
  /// the search field is empty.
  final List<MealRecipeRecord> searchResults;

  /// Result of the category-tap Firestore query. Null when no category has
  /// been tapped this session (the screen falls back to the full list).
  final List<MealRecipeRecord>? mealFilteredByCategory;

  /// Bumped on every emit so `BlocListener` re-fires for repeated events.
  final int lastEventId;

  HomeState copyWith({
    List<MealRecipeRecord>? searchResults,
    List<MealRecipeRecord>? mealFilteredByCategory,
    bool clearMealFiltered = false,
    int? lastEventId,
  }) {
    return HomeState(
      searchResults: searchResults ?? this.searchResults,
      mealFilteredByCategory: clearMealFiltered
          ? null
          : (mealFilteredByCategory ?? this.mealFilteredByCategory),
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props =>
      [searchResults, mealFilteredByCategory, lastEventId];
}
