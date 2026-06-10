import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/cubits/app/app_cubit.dart';
import '/cubits/app/app_state.dart' as app;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Toggles whether the device receives meal-request push notifications.
/// Reads the OS-level Android notification permission on load and mirrors it
/// into `AppCubit.state.isNotificationEnabled` / the Switch.
class NotificationSettingsScreenWidget extends StatefulWidget {
  const NotificationSettingsScreenWidget({super.key});

  @override
  State<NotificationSettingsScreenWidget> createState() =>
      _NotificationSettingsScreenWidgetState();
}

class _NotificationSettingsScreenWidgetState
    extends State<NotificationSettingsScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _unfocusNode = FocusNode();
  bool? _notificationSwitchValue;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final enabled = await actions.areNotificationsEnabledOnAndroid();
      if (!mounted) return;
      AppCubit.instance.setIsNotificationEnabled(enabled ?? false);
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, app.AppState>(
      builder: (context, appState) {
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).success,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 54.0,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Text(
                'Notification Settings',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                    ),
              ),
              actions: const [],
              centerTitle: true,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Notifications',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Switch.adaptive(
                            value: _notificationSwitchValue ??=
                                appState.isNotificationEnabled,
                            onChanged: (newValue) async {
                              setState(() =>
                                  _notificationSwitchValue = newValue);
                              if (newValue) {
                                AppCubit.instance.setIsNotificationEnabled(true);
                                await actions.requestNotificationPermissions();
                              } else {
                                AppCubit.instance.setIsNotificationEnabled(false);
                                await actions.disableNotification();
                              }
                            },
                            activeColor: FlutterFlowTheme.of(context).success,
                            activeTrackColor:
                                FlutterFlowTheme.of(context).accent1,
                            inactiveTrackColor:
                                FlutterFlowTheme.of(context).alternate,
                            inactiveThumbColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme.of(context).lineColor,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      child: Text(
                        'Enabling notification will help you receive meal recipe notification with your partner',
                        style:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                      ),
                    ),
                  ]
                      .divide(const SizedBox(height: 4.0))
                      .addToStart(const SizedBox(height: 16.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
