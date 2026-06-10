import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';

import '/auth/base_auth_user_provider.dart';

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  // MVP mode: no splash. The demo user is seeded synchronously in main(),
  // so there's nothing to wait for. Kept as a field (not removed) because
  // `stopShowingSplashImage()` is still called from elsewhere.
  bool showSplashImage = false;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      // MVP mode: the demo user is always "signed in", so every route falls
      // back to HomeWidget instead of LoginScreen.
      errorBuilder: (context, state) => HomeWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => HomeWidget(),
        ),
        FFRoute(
          name: 'home',
          path: '/home',
          requireAuth: true,
          builder: (context, params) => HomeWidget(),
        ),
        FFRoute(
          name: 'details_screen',
          path: '/detailsScreen',
          requireAuth: true,
          builder: (context, params) => DetailsScreenWidget(
            mealRef: params.getParam(
              'mealRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['meal-recipe'],
            ),
            savedRecipeDoc: params.getParam(
              'savedRecipeDoc',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['saved-recipe'],
            ),
          ),
        ),
        FFRoute(
          name: 'add_recipe_screen',
          path: '/addRecipeScreen',
          requireAuth: true,
          builder: (context, params) => AddRecipeScreenWidget(
            userRef: params.getParam(
              'userRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
            mealRef: params.getParam(
              'mealRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['meal-recipe'],
            ),
          ),
        ),
        FFRoute(
          name: 'profile_screen',
          path: '/profileScreen',
          requireAuth: true,
          builder: (context, params) => ProfileScreenWidget(
            userDocRef: params.getParam(
              'userDocRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
            partnerRef: params.getParam(
              'partnerRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
            tabIndex: params.getParam(
              'tabIndex',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'pairing_screen',
          path: '/pairingScreen',
          requireAuth: true,
          builder: (context, params) => PairingScreenWidget(
            uniqueCode: params.getParam(
              'uniqueCode',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'profile_settings_screen',
          path: '/profileSettingsScreen',
          requireAuth: true,
          builder: (context, params) => ProfileSettingsScreenWidget(
            userRef: params.getParam(
              'userRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
          ),
        ),
        FFRoute(
          name: 'edit_recipe_screen',
          path: '/editRecipeScreen',
          requireAuth: true,
          builder: (context, params) => EditRecipeScreenWidget(
            mealRef: params.getParam(
              'mealRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['meal-recipe'],
            ),
            ingredientList: params.getParam<IngredientStruct>(
              'ingredientList',
              ParamType.DataStruct,
              isList: true,
              structBuilder: IngredientStruct.fromSerializableMap,
            ),
            procedureList: params.getParam<ProcedureStruct>(
              'procedureList',
              ParamType.DataStruct,
              isList: true,
              structBuilder: ProcedureStruct.fromSerializableMap,
            ),
            recipeCategoryList: params.getParam<String>(
              'recipeCategoryList',
              ParamType.String,
              isList: true,
            ),
          ),
        ),
        FFRoute(
          name: 'edit_profile_screen',
          path: '/editProfileScreen',
          requireAuth: true,
          builder: (context, params) => EditProfileScreenWidget(
            userDocRef: params.getParam(
              'userDocRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
          ),
        ),
        FFRoute(
          name: 'login_screen',
          path: '/loginScreen',
          builder: (context, params) => LoginScreenWidget(),
        ),
        FFRoute(
          name: 'forgot_password_screen',
          path: '/forgotPasswordScreen',
          builder: (context, params) => ForgotPasswordScreenWidget(),
        ),
        FFRoute(
          name: 'meal_request_notification_screen',
          path: '/mealRequestNotificationScreen',
          requireAuth: true,
          builder: (context, params) => MealRequestNotificationScreenWidget(
            pairedUserRef: params.getParam(
              'pairedUserRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['paired-user'],
            ),
          ),
        ),
        FFRoute(
          name: 'admin_home',
          path: '/adminHome',
          requireAuth: true,
          builder: (context, params) => AdminHomeWidget(),
        ),
        FFRoute(
          name: 'profile_deletion_survey_screen',
          path: '/profileDeletionSurveyScreen',
          requireAuth: true,
          builder: (context, params) => ProfileDeletionSurveyScreenWidget(),
        ),
        FFRoute(
          name: 'sign_up_screen',
          path: '/signUpScreen',
          builder: (context, params) => SignUpScreenWidget(),
        ),
        FFRoute(
          name: 'terms_of_service_screen',
          path: '/termsOfServiceScreen',
          builder: (context, params) => TermsOfServiceScreenWidget(),
        ),
        FFRoute(
          name: 'privacy_policy_screen',
          path: '/privacyPolicyScreen',
          builder: (context, params) => PrivacyPolicyScreenWidget(),
        ),
        FFRoute(
          name: 'notification_settings_screen',
          path: '/notificationSettingsScreen',
          requireAuth: true,
          builder: (context, params) => NotificationSettingsScreenWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.setRedirectLocationIfUnset(location);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          // Don't make redirect decisions before auth has resolved — the
          // splash page-builder is already showing, and a premature
          // `loggedIn == false` read here would bounce a logged-in user
          // to `/loginScreen` while their session is still loading.
          if (appStateNotifier.loading) {
            return null;
          }
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/loginScreen';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          // MVP mode: no splash. The demo user is already seeded, so render
          // the page immediately.
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
