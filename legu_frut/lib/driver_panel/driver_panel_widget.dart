import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'driver_panel_model.dart';
export 'driver_panel_model.dart';

class DriverPanelWidget extends StatefulWidget {
  const DriverPanelWidget({super.key});

  static String routeName = 'DriverPanel';
  static String routePath = '/driverPanel';

  @override
  State<DriverPanelWidget> createState() => _DriverPanelWidgetState();
}

class _DriverPanelWidgetState extends State<DriverPanelWidget>
    with TickerProviderStateMixin {
  late DriverPanelModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DriverPanelModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.driverPoints = [];
      safeSetState(() {});
      _model.queryAction1 = await queryOrdersRecordOnce(
        queryBuilder: (ordersRecord) => ordersRecord
            .where(
              'status',
              isEqualTo: 'Reparto',
            )
            .where(
              'driverTag',
              isEqualTo: _model.selectedDriver,
            ),
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(-40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
            ))
              Container(
                width: 270.0,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.0,
                      color: FlutterFlowTheme.of(context).alternate,
                      offset: Offset(
                        1.0,
                        0.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            boxShadow: [
                              BoxShadow(
                                color: FlutterFlowTheme.of(context).accent1,
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 24.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.add_task_rounded,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 32.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'check.io',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 20.0, 16.0, 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 44.0,
                                      height: 44.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                Duration(milliseconds: 500),
                                            fadeOutDuration:
                                                Duration(milliseconds: 500),
                                            imageUrl:
                                                'https://images.unsplash.com/photo-1624561172888-ac93c696e10c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjJ8fHVzZXJzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                                            width: 44.0,
                                            height: 44.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Andrew D.',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                'admin@gmail.com',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelSmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.notifications_none,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 28.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 12.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 12.0, 12.0),
                                  child: Container(
                                    width: 4.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).info,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.stacked_bar_chart_rounded,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 28.0,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Dashboard',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 12.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 12.0, 12.0),
                                  child: Container(
                                    width: 4.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.attach_money_rounded,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 28.0,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Transactions',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 12.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 12.0, 12.0),
                                  child: Container(
                                    width: 4.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.folder_open,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 28.0,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Projects',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 12.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 12.0, 12.0),
                                  child: Container(
                                    width: 4.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.groups,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 28.0,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'Users',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                height: 12.0,
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).accent1,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 12.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if ((Theme.of(context).brightness ==
                                            Brightness.light) ==
                                        true) {
                                      setDarkModeSetting(
                                          context, ThemeMode.dark);
                                      if (animationsMap[
                                              'containerOnActionTriggerAnimation'] !=
                                          null) {
                                        animationsMap[
                                                'containerOnActionTriggerAnimation']!
                                            .controller
                                            .forward(from: 0.0);
                                      }
                                    } else {
                                      setDarkModeSetting(
                                          context, ThemeMode.light);
                                      if (animationsMap[
                                              'containerOnActionTriggerAnimation'] !=
                                          null) {
                                        animationsMap[
                                                'containerOnActionTriggerAnimation']!
                                            .controller
                                            .reverse();
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 80.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-0.9, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(6.0, 0.0, 0.0, 0.0),
                                              child: Icon(
                                                Icons.wb_sunny_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 6.0, 0.0),
                                              child: Icon(
                                                Icons.mode_night_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(1.0, 0.0),
                                            child: Container(
                                              width: 36.0,
                                              height: 36.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4.0,
                                                    color: Color(0x430B0D0F),
                                                    offset: Offset(
                                                      0.0,
                                                      2.0,
                                                    ),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                shape: BoxShape.rectangle,
                                              ),
                                            ).animateOnActionTrigger(
                                              animationsMap[
                                                  'containerOnActionTriggerAnimation']!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 12.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 900.0,
                    ),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 10.0, 0.0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 30.0,
                                          borderWidth: 1.0,
                                          buttonSize: 50.0,
                                          icon: Icon(
                                            Icons.arrow_back_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 30.0,
                                          ),
                                          onPressed: () async {
                                            context.pushNamed(
                                                HomePageWidget.routeName);
                                          },
                                        ),
                                      ),
                                      Text(
                                        'Repartos',
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .displaySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displaySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(-1.0, 0),
                                  child: FlutterFlowButtonTabBar(
                                    useToggleButtonStyle: false,
                                    isScrollable: true,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                    unselectedLabelStyle:
                                        FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                    labelColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    unselectedLabelColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).accent1,
                                    unselectedBackgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderColor:
                                        FlutterFlowTheme.of(context).primary,
                                    borderWidth: 2.0,
                                    borderRadius: 12.0,
                                    elevation: 0.0,
                                    labelPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    buttonMargin:
                                        EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 16.0, 0.0),
                                    tabs: [
                                      Tab(
                                        text: 'Driver #1',
                                      ),
                                      Tab(
                                        text: 'Driver #2',
                                      ),
                                      Tab(
                                        text: 'Driver #3',
                                      ),
                                    ],
                                    controller: _model.tabBarController,
                                    onTap: (i) async {
                                      [
                                        () async {
                                          _model.selectedDriver = 'Driver #1';
                                          safeSetState(() {});
                                          _model.driverPoints = [];
                                          safeSetState(() {});
                                          _model.actionDriver1 =
                                              await queryOrdersRecordOnce(
                                            queryBuilder: (ordersRecord) =>
                                                ordersRecord
                                                    .where(
                                                      'status',
                                                      isEqualTo: 'Reparto',
                                                    )
                                                    .where(
                                                      'driverTag',
                                                      isEqualTo:
                                                          _model.selectedDriver,
                                                    ),
                                          );
                                          for (int loop1Index = 0;
                                              loop1Index <
                                                  _model.actionDriver1!.length;
                                              loop1Index++) {
                                            final currentLoop1Item = _model
                                                .actionDriver1![loop1Index];
                                            if (currentLoop1Item.location !=
                                                null) {
                                              _model.addToDriverPoints(
                                                  currentLoop1Item.location!);
                                              safeSetState(() {});
                                            }
                                          }

                                          safeSetState(() {});
                                        },
                                        () async {
                                          _model.selectedDriver = 'Driver #2';
                                          safeSetState(() {});
                                          _model.driverPoints = [];
                                          safeSetState(() {});
                                          _model.actionDriver2 =
                                              await queryOrdersRecordOnce(
                                            queryBuilder: (ordersRecord) =>
                                                ordersRecord
                                                    .where(
                                                      'status',
                                                      isEqualTo: 'Reparto',
                                                    )
                                                    .where(
                                                      'driverTag',
                                                      isEqualTo:
                                                          _model.selectedDriver,
                                                    ),
                                          );
                                          for (int loop1Index = 0;
                                              loop1Index <
                                                  _model.actionDriver2!.length;
                                              loop1Index++) {
                                            final currentLoop1Item = _model
                                                .actionDriver2![loop1Index];
                                            if (currentLoop1Item.location !=
                                                null) {
                                              _model.addToDriverPoints(
                                                  currentLoop1Item.location!);
                                              safeSetState(() {});
                                            }
                                          }

                                          safeSetState(() {});
                                        },
                                        () async {
                                          _model.selectedDriver = 'Driver #3';
                                          safeSetState(() {});
                                          _model.driverPoints = [];
                                          safeSetState(() {});
                                          _model.actionDriver3 =
                                              await queryOrdersRecordOnce(
                                            queryBuilder: (ordersRecord) =>
                                                ordersRecord
                                                    .where(
                                                      'status',
                                                      isEqualTo: 'Reparto',
                                                    )
                                                    .where(
                                                      'driverTag',
                                                      isEqualTo:
                                                          _model.selectedDriver,
                                                    ),
                                          );
                                          for (int loop1Index = 0;
                                              loop1Index <
                                                  _model.actionDriver3!.length;
                                              loop1Index++) {
                                            final currentLoop1Item = _model
                                                .actionDriver3![loop1Index];
                                            if (currentLoop1Item.location !=
                                                null) {
                                              _model.addToDriverPoints(
                                                  currentLoop1Item.location!);
                                              safeSetState(() {});
                                            }
                                          }

                                          safeSetState(() {});
                                        }
                                      ][i]();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 5.0,
                                                                15.0, 5.0),
                                                    child: Container(
                                                      width: 100.0,
                                                      height: 280.6,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFFFE0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x33000000),
                                                            offset: Offset(
                                                              2.0,
                                                              2.0,
                                                            ),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  15.0),
                                                        ),
                                                      ),
                                                      child:
                                                          FlutterFlowGoogleMap(
                                                        controller: _model
                                                            .googleMapsController1,
                                                        onCameraIdle: (latLng) =>
                                                            _model.googleMapsCenter1 =
                                                                latLng,
                                                        initialLocation: _model
                                                                .googleMapsCenter1 ??=
                                                            LatLng(21.07364,
                                                                -101.68435),
                                                        markers:
                                                            _model.driverPoints
                                                                .map(
                                                                  (marker) =>
                                                                      FlutterFlowMarker(
                                                                    marker
                                                                        .serialize(),
                                                                    marker,
                                                                  ),
                                                                )
                                                                .toList(),
                                                        markerColor:
                                                            GoogleMarkerColor
                                                                .violet,
                                                        mapType: MapType.normal,
                                                        style: GoogleMapStyle
                                                            .standard,
                                                        initialZoom: 10.0,
                                                        allowInteraction: true,
                                                        allowZoom: true,
                                                        showZoomControls: true,
                                                        showLocation: true,
                                                        showCompass: false,
                                                        showMapToolbar: false,
                                                        showTraffic: false,
                                                        centerMapOnMarkerTap:
                                                            true,
                                                        mapTakesGesturePreference:
                                                            true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 24.0),
                                              child: StreamBuilder<
                                                  List<OrdersRecord>>(
                                                stream: queryOrdersRecord(
                                                  queryBuilder:
                                                      (ordersRecord) =>
                                                          ordersRecord
                                                              .where(
                                                                'driverTag',
                                                                isEqualTo:
                                                                    'Driver #1',
                                                              )
                                                              .orderBy(
                                                                  'createdAt',
                                                                  descending:
                                                                      true),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<OrdersRecord>
                                                      listViewOrdersRecordList =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewOrdersRecordList
                                                            .length,
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewOrdersRecord =
                                                          listViewOrdersRecordList[
                                                              listViewIndex];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 570.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        12.0,
                                                                        16.0,
                                                                        12.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            RichText(
                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: 'Orden #: ',
                                                                                    style: TextStyle(),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: listViewOrdersRecord.reference.id,
                                                                                    style: TextStyle(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                dateTimeFormat("M/d H:mm", listViewOrdersRecord.createdAt!),
                                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    formatNumber(
                                                                                      listViewOrdersRecord.subtotal,
                                                                                      formatType: FormatType.decimal,
                                                                                      decimalType: DecimalType.periodDecimal,
                                                                                      currency: '\$',
                                                                                    ),
                                                                                    textAlign: TextAlign.end,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 0.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (listViewOrdersRecord.showorder == false) {
                                                                                          await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                            showorder: true,
                                                                                          ));
                                                                                        } else {
                                                                                          await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                            showorder: false,
                                                                                          ));
                                                                                        }
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.remove_red_eye_outlined,
                                                                                        color: Color(0xFF003176),
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'Pedido asignado a:${listViewOrdersRecord.driverTag}',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                          ),
                                                                                          fontSize: 12.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 4.0,
                                                                                          color: Color(0x33000000),
                                                                                          offset: Offset(
                                                                                            2.0,
                                                                                            2.0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                          driverStatusText: 'En camino',
                                                                                        ));
                                                                                        triggerPushNotification(
                                                                                          notificationTitle: '🚚 Tu pedido va en camino',
                                                                                          notificationText: 'El repartidor ya salió rumbo a tu domicilio.',
                                                                                          notificationSound: 'default',
                                                                                          userRefs: [
                                                                                            listViewOrdersRecord.userRef!
                                                                                          ],
                                                                                          initialPageName: 'Notificaciones',
                                                                                          parameterData: {},
                                                                                        );
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              'Se le avisó al Cliente sobre su pedido',
                                                                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                                                    font: GoogleFonts.interTight(
                                                                                                      fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                                    ),
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    fontSize: 15.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                                  ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            duration: Duration(milliseconds: 3550),
                                                                                            backgroundColor: Color(0xFFCBE4FC),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      text: 'Reparto',
                                                                                      options: FFButtonOptions(
                                                                                        width: 100.0,
                                                                                        height: 33.6,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        color: Color(0xFF0F731D),
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0.0,
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 4.0,
                                                                                          color: Color(0x33000000),
                                                                                          offset: Offset(
                                                                                            2.0,
                                                                                            2.0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                          driverStatusText: 'Su pedido ha llegado',
                                                                                        ));
                                                                                        triggerPushNotification(
                                                                                          notificationTitle: '📍 Tu pedido llegó',
                                                                                          notificationText: 'El repartidor ya se encuentra en tu domicilio.',
                                                                                          notificationSound: 'default',
                                                                                          userRefs: [
                                                                                            listViewOrdersRecord.userRef!
                                                                                          ],
                                                                                          initialPageName: 'Notificaciones',
                                                                                          parameterData: {},
                                                                                        );
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              'Se le avisó al Cliente',
                                                                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                                                                    font: GoogleFonts.interTight(
                                                                                                      fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                                    ),
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    fontSize: 15.0,
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                                                  ),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                            duration: Duration(milliseconds: 3550),
                                                                                            backgroundColor: Color(0xFFCBE4FC),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      text: 'Destino',
                                                                                      options: FFButtonOptions(
                                                                                        width: 100.0,
                                                                                        height: 33.6,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        color: Color(0xFF0F731D),
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0.0,
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  if (listViewOrdersRecord
                                                                          .showorder ==
                                                                      true)
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              194.49,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFFF6F6DA),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4.0,
                                                                                color: Color(0x33000000),
                                                                                offset: Offset(
                                                                                  2.0,
                                                                                  2.0,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Calle:    ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.street,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Número:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.number,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Colónia:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.neighborhood,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'CP:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.postalCode,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Referencia: ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                width: 300.0,
                                                                                                height: 56.6,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      blurRadius: 4.0,
                                                                                                      color: Color(0x33000000),
                                                                                                      offset: Offset(
                                                                                                        2.0,
                                                                                                        2.0,
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                  borderRadius: BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(10.0),
                                                                                                    bottomRight: Radius.circular(10.0),
                                                                                                    topLeft: Radius.circular(10.0),
                                                                                                    topRight: Radius.circular(10.0),
                                                                                                  ),
                                                                                                ),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 3.0, 4.0, 4.0),
                                                                                                        child: AutoSizeText(
                                                                                                          listViewOrdersRecord.referenceNote,
                                                                                                          textAlign: TextAlign.start,
                                                                                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                              StreamBuilder<
                                                                  List<
                                                                      OrdersitemsRecord>>(
                                                                stream:
                                                                    queryOrdersitemsRecord(
                                                                  parent: listViewOrdersRecord
                                                                      .reference,
                                                                ),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  List<OrdersitemsRecord>
                                                                      listViewOrdersitemsRecordList =
                                                                      snapshot
                                                                          .data!;

                                                                  return ListView
                                                                      .builder(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    primary:
                                                                        false,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount:
                                                                        listViewOrdersitemsRecordList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            listViewIndex) {
                                                                      final listViewOrdersitemsRecord =
                                                                          listViewOrdersitemsRecordList[
                                                                              listViewIndex];
                                                                      return Visibility(
                                                                        visible:
                                                                            listViewOrdersRecord.showorder ==
                                                                                true,
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  width: 339.8,
                                                                                  height: 76.9,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xFFFFFFC9),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        blurRadius: 4.0,
                                                                                        color: Color(0x33000000),
                                                                                        offset: Offset(
                                                                                          2.0,
                                                                                          2.0,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                    borderRadius: BorderRadius.only(
                                                                                      bottomLeft: Radius.circular(15.0),
                                                                                      bottomRight: Radius.circular(15.0),
                                                                                      topLeft: Radius.circular(15.0),
                                                                                      topRight: Radius.circular(15.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 1.0, 1.0, 1.0),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                              child: Image.network(
                                                                                                listViewOrdersitemsRecord.coverimage,
                                                                                                width: 70.0,
                                                                                                height: 70.0,
                                                                                                fit: BoxFit.cover,
                                                                                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                                  'assets/images/error_image.jpg',
                                                                                                  width: 70.0,
                                                                                                  height: 70.0,
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          flex: 3,
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 4.0, 0.0),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          listViewOrdersitemsRecord.productName,
                                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          formatNumber(
                                                                                                            listViewOrdersitemsRecord.unitPrice,
                                                                                                            formatType: FormatType.decimal,
                                                                                                            decimalType: DecimalType.periodDecimal,
                                                                                                            currency: '\$',
                                                                                                          ),
                                                                                                          textAlign: TextAlign.end,
                                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                                          child: RichText(
                                                                                                            textScaler: MediaQuery.of(context).textScaler,
                                                                                                            text: TextSpan(
                                                                                                              children: [
                                                                                                                TextSpan(
                                                                                                                  text: listViewOrdersitemsRecord.unitType == 'Gramos' ? 'Gramos: ' : 'Piezas: ',
                                                                                                                  style: TextStyle(),
                                                                                                                ),
                                                                                                                TextSpan(
                                                                                                                  text: formatNumber(
                                                                                                                    listViewOrdersitemsRecord.grams,
                                                                                                                    formatType: FormatType.decimal,
                                                                                                                    decimalType: DecimalType.periodDecimal,
                                                                                                                  ),
                                                                                                                  style: TextStyle(),
                                                                                                                )
                                                                                                              ],
                                                                                                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                    font: GoogleFonts.inter(
                                                                                                                      fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                    ),
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(35.0, 0.0, 0.0, 0.0),
                                                                                                          child: Text(
                                                                                                            '\$/kg',
                                                                                                            textAlign: TextAlign.end,
                                                                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                  font: GoogleFonts.inter(
                                                                                                                    fontWeight: FontWeight.normal,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                  ),
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          formatNumber(
                                                                                                            listViewOrdersitemsRecord.pricePerKg,
                                                                                                            formatType: FormatType.decimal,
                                                                                                            decimalType: DecimalType.periodDecimal,
                                                                                                            currency: '\$',
                                                                                                          ),
                                                                                                          textAlign: TextAlign.end,
                                                                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                font: GoogleFonts.inter(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                ),
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        primary: false,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 5.0,
                                                                15.0, 5.0),
                                                    child: Container(
                                                      width: 100.0,
                                                      height: 280.6,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFFFE0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x33000000),
                                                            offset: Offset(
                                                              2.0,
                                                              2.0,
                                                            ),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  15.0),
                                                        ),
                                                      ),
                                                      child:
                                                          FlutterFlowGoogleMap(
                                                        controller: _model
                                                            .googleMapsController2,
                                                        onCameraIdle: (latLng) =>
                                                            _model.googleMapsCenter2 =
                                                                latLng,
                                                        initialLocation: _model
                                                                .googleMapsCenter2 ??=
                                                            LatLng(21.07364,
                                                                -101.68435),
                                                        markers:
                                                            _model.driverPoints
                                                                .map(
                                                                  (marker) =>
                                                                      FlutterFlowMarker(
                                                                    marker
                                                                        .serialize(),
                                                                    marker,
                                                                  ),
                                                                )
                                                                .toList(),
                                                        markerColor:
                                                            GoogleMarkerColor
                                                                .violet,
                                                        mapType: MapType.normal,
                                                        style: GoogleMapStyle
                                                            .standard,
                                                        initialZoom: 10.0,
                                                        allowInteraction: true,
                                                        allowZoom: true,
                                                        showZoomControls: true,
                                                        showLocation: true,
                                                        showCompass: false,
                                                        showMapToolbar: false,
                                                        showTraffic: false,
                                                        centerMapOnMarkerTap:
                                                            true,
                                                        mapTakesGesturePreference:
                                                            true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 24.0),
                                              child: StreamBuilder<
                                                  List<OrdersRecord>>(
                                                stream: queryOrdersRecord(
                                                  queryBuilder:
                                                      (ordersRecord) =>
                                                          ordersRecord
                                                              .where(
                                                                'driverTag',
                                                                isEqualTo:
                                                                    'Driver #2',
                                                              )
                                                              .orderBy(
                                                                  'createdAt',
                                                                  descending:
                                                                      true),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<OrdersRecord>
                                                      listViewOrdersRecordList =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewOrdersRecordList
                                                            .length,
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewOrdersRecord =
                                                          listViewOrdersRecordList[
                                                              listViewIndex];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 570.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        12.0,
                                                                        16.0,
                                                                        12.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            RichText(
                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: 'Orden #: ',
                                                                                    style: TextStyle(),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: listViewOrdersRecord.reference.id,
                                                                                    style: TextStyle(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                dateTimeFormat("M/d H:mm", listViewOrdersRecord.createdAt!),
                                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    formatNumber(
                                                                                      listViewOrdersRecord.subtotal,
                                                                                      formatType: FormatType.decimal,
                                                                                      decimalType: DecimalType.periodDecimal,
                                                                                      currency: '\$',
                                                                                    ),
                                                                                    textAlign: TextAlign.end,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 0.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (listViewOrdersRecord.showorder == false) {
                                                                                          await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                            showorder: true,
                                                                                          ));
                                                                                        } else {
                                                                                          await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                            showorder: false,
                                                                                          ));
                                                                                        }
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.remove_red_eye_outlined,
                                                                                        color: Color(0xFF003176),
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'Pedido asignado a:${listViewOrdersRecord.driverTag}',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                          ),
                                                                                          fontSize: 12.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 4.0,
                                                                                          color: Color(0x33000000),
                                                                                          offset: Offset(
                                                                                            2.0,
                                                                                            2.0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                          driverStatusText: 'En camino',
                                                                                        ));
                                                                                        triggerPushNotification(
                                                                                          notificationTitle: '🚚 Tu pedido va en camino',
                                                                                          notificationText: 'El repartidor ya salió rumbo a tu domicilio.',
                                                                                          notificationSound: 'default',
                                                                                          userRefs: [
                                                                                            listViewOrdersRecord.userRef!
                                                                                          ],
                                                                                          initialPageName: 'Notificaciones',
                                                                                          parameterData: {},
                                                                                        );
                                                                                      },
                                                                                      text: 'Reparto',
                                                                                      options: FFButtonOptions(
                                                                                        width: 100.0,
                                                                                        height: 33.6,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        color: Color(0xFF0F731D),
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0.0,
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 4.0,
                                                                                          color: Color(0x33000000),
                                                                                          offset: Offset(
                                                                                            2.0,
                                                                                            2.0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                          driverStatusText: 'Su pedido ha llegado',
                                                                                        ));
                                                                                        triggerPushNotification(
                                                                                          notificationTitle: '📍 Tu pedido llegó',
                                                                                          notificationText: 'El repartidor ya se encuentra en tu domicilio.',
                                                                                          notificationSound: 'default',
                                                                                          userRefs: [
                                                                                            listViewOrdersRecord.userRef!
                                                                                          ],
                                                                                          initialPageName: 'Notificaciones',
                                                                                          parameterData: {},
                                                                                        );
                                                                                      },
                                                                                      text: 'Destino',
                                                                                      options: FFButtonOptions(
                                                                                        width: 100.0,
                                                                                        height: 33.6,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        color: Color(0xFF0F731D),
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0.0,
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  if (listViewOrdersRecord
                                                                          .showorder ==
                                                                      true)
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              194.49,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFFF6F6DA),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4.0,
                                                                                color: Color(0x33000000),
                                                                                offset: Offset(
                                                                                  2.0,
                                                                                  2.0,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Calle:    ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.street,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Número:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.number,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Colónia:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.neighborhood,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'CP:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.postalCode,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Referencia: ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                width: 300.0,
                                                                                                height: 56.6,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      blurRadius: 4.0,
                                                                                                      color: Color(0x33000000),
                                                                                                      offset: Offset(
                                                                                                        2.0,
                                                                                                        2.0,
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                  borderRadius: BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(10.0),
                                                                                                    bottomRight: Radius.circular(10.0),
                                                                                                    topLeft: Radius.circular(10.0),
                                                                                                    topRight: Radius.circular(10.0),
                                                                                                  ),
                                                                                                ),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 3.0, 4.0, 4.0),
                                                                                                        child: AutoSizeText(
                                                                                                          listViewOrdersRecord.referenceNote,
                                                                                                          textAlign: TextAlign.start,
                                                                                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                              StreamBuilder<
                                                                  List<
                                                                      OrdersitemsRecord>>(
                                                                stream:
                                                                    queryOrdersitemsRecord(
                                                                  parent: listViewOrdersRecord
                                                                      .reference,
                                                                ),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  List<OrdersitemsRecord>
                                                                      listViewOrdersitemsRecordList =
                                                                      snapshot
                                                                          .data!;

                                                                  return ListView
                                                                      .builder(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    primary:
                                                                        false,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount:
                                                                        listViewOrdersitemsRecordList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            listViewIndex) {
                                                                      final listViewOrdersitemsRecord =
                                                                          listViewOrdersitemsRecordList[
                                                                              listViewIndex];
                                                                      return Visibility(
                                                                        visible:
                                                                            listViewOrdersRecord.showorder ==
                                                                                true,
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  width: 339.8,
                                                                                  height: 76.9,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xFFFFFFC9),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        blurRadius: 4.0,
                                                                                        color: Color(0x33000000),
                                                                                        offset: Offset(
                                                                                          2.0,
                                                                                          2.0,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                    borderRadius: BorderRadius.only(
                                                                                      bottomLeft: Radius.circular(15.0),
                                                                                      bottomRight: Radius.circular(15.0),
                                                                                      topLeft: Radius.circular(15.0),
                                                                                      topRight: Radius.circular(15.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 1.0, 1.0, 1.0),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                              child: Image.network(
                                                                                                listViewOrdersitemsRecord.coverimage,
                                                                                                width: 70.0,
                                                                                                height: 70.0,
                                                                                                fit: BoxFit.cover,
                                                                                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                                  'assets/images/error_image.jpg',
                                                                                                  width: 70.0,
                                                                                                  height: 70.0,
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          flex: 3,
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 4.0, 0.0),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          listViewOrdersitemsRecord.productName,
                                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          formatNumber(
                                                                                                            listViewOrdersitemsRecord.unitPrice,
                                                                                                            formatType: FormatType.decimal,
                                                                                                            decimalType: DecimalType.periodDecimal,
                                                                                                            currency: '\$',
                                                                                                          ),
                                                                                                          textAlign: TextAlign.end,
                                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                                          child: RichText(
                                                                                                            textScaler: MediaQuery.of(context).textScaler,
                                                                                                            text: TextSpan(
                                                                                                              children: [
                                                                                                                TextSpan(
                                                                                                                  text: listViewOrdersitemsRecord.unitType == 'Gramos' ? 'Gramos: ' : 'Piezas: ',
                                                                                                                  style: TextStyle(),
                                                                                                                ),
                                                                                                                TextSpan(
                                                                                                                  text: formatNumber(
                                                                                                                    listViewOrdersitemsRecord.grams,
                                                                                                                    formatType: FormatType.decimal,
                                                                                                                    decimalType: DecimalType.periodDecimal,
                                                                                                                  ),
                                                                                                                  style: TextStyle(),
                                                                                                                )
                                                                                                              ],
                                                                                                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                    font: GoogleFonts.inter(
                                                                                                                      fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                    ),
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(35.0, 0.0, 0.0, 0.0),
                                                                                                          child: Text(
                                                                                                            '\$/kg',
                                                                                                            textAlign: TextAlign.end,
                                                                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                  font: GoogleFonts.inter(
                                                                                                                    fontWeight: FontWeight.normal,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                  ),
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          formatNumber(
                                                                                                            listViewOrdersitemsRecord.pricePerKg,
                                                                                                            formatType: FormatType.decimal,
                                                                                                            decimalType: DecimalType.periodDecimal,
                                                                                                            currency: '\$',
                                                                                                          ),
                                                                                                          textAlign: TextAlign.end,
                                                                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                font: GoogleFonts.inter(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                ),
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        primary: false,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 5.0,
                                                                15.0, 5.0),
                                                    child: Container(
                                                      width: 100.0,
                                                      height: 280.6,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFFFE0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4.0,
                                                            color: Color(
                                                                0x33000000),
                                                            offset: Offset(
                                                              2.0,
                                                              2.0,
                                                            ),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  15.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  15.0),
                                                        ),
                                                      ),
                                                      child:
                                                          FlutterFlowGoogleMap(
                                                        controller: _model
                                                            .googleMapsController3,
                                                        onCameraIdle: (latLng) =>
                                                            _model.googleMapsCenter3 =
                                                                latLng,
                                                        initialLocation: _model
                                                                .googleMapsCenter3 ??=
                                                            LatLng(21.07364,
                                                                -101.68435),
                                                        markers:
                                                            _model.driverPoints
                                                                .map(
                                                                  (marker) =>
                                                                      FlutterFlowMarker(
                                                                    marker
                                                                        .serialize(),
                                                                    marker,
                                                                  ),
                                                                )
                                                                .toList(),
                                                        markerColor:
                                                            GoogleMarkerColor
                                                                .violet,
                                                        mapType: MapType.normal,
                                                        style: GoogleMapStyle
                                                            .standard,
                                                        initialZoom: 10.0,
                                                        allowInteraction: true,
                                                        allowZoom: true,
                                                        showZoomControls: true,
                                                        showLocation: true,
                                                        showCompass: false,
                                                        showMapToolbar: false,
                                                        showTraffic: false,
                                                        centerMapOnMarkerTap:
                                                            true,
                                                        mapTakesGesturePreference:
                                                            true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 24.0),
                                              child: StreamBuilder<
                                                  List<OrdersRecord>>(
                                                stream: queryOrdersRecord(
                                                  queryBuilder:
                                                      (ordersRecord) =>
                                                          ordersRecord
                                                              .where(
                                                                'driverTag',
                                                                isEqualTo:
                                                                    'Driver #3',
                                                              )
                                                              .orderBy(
                                                                  'createdAt',
                                                                  descending:
                                                                      true),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<OrdersRecord>
                                                      listViewOrdersRecordList =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewOrdersRecordList
                                                            .length,
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewOrdersRecord =
                                                          listViewOrdersRecordList[
                                                              listViewIndex];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    0.0,
                                                                    16.0,
                                                                    0.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 570.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        12.0,
                                                                        16.0,
                                                                        12.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            RichText(
                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: 'Orden #: ',
                                                                                    style: TextStyle(),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: listViewOrdersRecord.reference.id,
                                                                                    style: TextStyle(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                dateTimeFormat("M/d H:mm", listViewOrdersRecord.createdAt!),
                                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                      font: GoogleFonts.inter(
                                                                                        fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    formatNumber(
                                                                                      listViewOrdersRecord.subtotal,
                                                                                      formatType: FormatType.decimal,
                                                                                      decimalType: DecimalType.periodDecimal,
                                                                                      currency: '\$',
                                                                                    ),
                                                                                    textAlign: TextAlign.end,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                          ),
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 0.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (listViewOrdersRecord.showorder == false) {
                                                                                          await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                            showorder: true,
                                                                                          ));
                                                                                        } else {
                                                                                          await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                            showorder: false,
                                                                                          ));
                                                                                        }
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.remove_red_eye_outlined,
                                                                                        color: Color(0xFF003176),
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'Pedido asignado a:${listViewOrdersRecord.driverTag}',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                          ),
                                                                                          fontSize: 12.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 4.0,
                                                                                          color: Color(0x33000000),
                                                                                          offset: Offset(
                                                                                            2.0,
                                                                                            2.0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                          driverStatusText: 'En camino',
                                                                                        ));
                                                                                        triggerPushNotification(
                                                                                          notificationTitle: '🚚 Tu pedido va en camino',
                                                                                          notificationText: 'El repartidor ya salió rumbo a tu domicilio.',
                                                                                          notificationSound: 'default',
                                                                                          userRefs: [
                                                                                            listViewOrdersRecord.userRef!
                                                                                          ],
                                                                                          initialPageName: 'Notificaciones',
                                                                                          parameterData: {},
                                                                                        );
                                                                                      },
                                                                                      text: 'Reparto',
                                                                                      options: FFButtonOptions(
                                                                                        width: 100.0,
                                                                                        height: 33.6,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        color: Color(0xFF0F731D),
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0.0,
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          blurRadius: 4.0,
                                                                                          color: Color(0x33000000),
                                                                                          offset: Offset(
                                                                                            2.0,
                                                                                            2.0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    child: FFButtonWidget(
                                                                                      onPressed: () async {
                                                                                        await listViewOrdersRecord.reference.update(createOrdersRecordData(
                                                                                          driverStatusText: 'Su pedido ha llegado',
                                                                                        ));
                                                                                        triggerPushNotification(
                                                                                          notificationTitle: '📍 Tu pedido llegó',
                                                                                          notificationText: 'El repartidor ya se encuentra en tu domicilio.',
                                                                                          notificationSound: 'default',
                                                                                          userRefs: [
                                                                                            listViewOrdersRecord.userRef!
                                                                                          ],
                                                                                          initialPageName: 'Notificaciones',
                                                                                          parameterData: {},
                                                                                        );
                                                                                      },
                                                                                      text: 'Destino',
                                                                                      options: FFButtonOptions(
                                                                                        width: 100.0,
                                                                                        height: 33.6,
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                        color: Color(0xFF0F731D),
                                                                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                              font: GoogleFonts.interTight(
                                                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                              ),
                                                                                              color: Colors.white,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                            ),
                                                                                        elevation: 0.0,
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  if (listViewOrdersRecord
                                                                          .showorder ==
                                                                      true)
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              194.49,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(0xFFF6F6DA),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                blurRadius: 4.0,
                                                                                color: Color(0x33000000),
                                                                                offset: Offset(
                                                                                  2.0,
                                                                                  2.0,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Calle:    ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.street,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Número:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.number,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Colónia:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.neighborhood,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'CP:',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                                              child: AutoSizeText(
                                                                                                listViewOrdersRecord.postalCode,
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Text(
                                                                                              'Referencia: ',
                                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                    font: GoogleFonts.inter(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                                    letterSpacing: 0.0,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                width: 300.0,
                                                                                                height: 56.6,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                  boxShadow: [
                                                                                                    BoxShadow(
                                                                                                      blurRadius: 4.0,
                                                                                                      color: Color(0x33000000),
                                                                                                      offset: Offset(
                                                                                                        2.0,
                                                                                                        2.0,
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                  borderRadius: BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(10.0),
                                                                                                    bottomRight: Radius.circular(10.0),
                                                                                                    topLeft: Radius.circular(10.0),
                                                                                                    topRight: Radius.circular(10.0),
                                                                                                  ),
                                                                                                ),
                                                                                                child: Column(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 3.0, 4.0, 4.0),
                                                                                                        child: AutoSizeText(
                                                                                                          listViewOrdersRecord.referenceNote,
                                                                                                          textAlign: TextAlign.start,
                                                                                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.normal,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                              StreamBuilder<
                                                                  List<
                                                                      OrdersitemsRecord>>(
                                                                stream:
                                                                    queryOrdersitemsRecord(
                                                                  parent: listViewOrdersRecord
                                                                      .reference,
                                                                ),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  List<OrdersitemsRecord>
                                                                      listViewOrdersitemsRecordList =
                                                                      snapshot
                                                                          .data!;

                                                                  return ListView
                                                                      .builder(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    primary:
                                                                        false,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount:
                                                                        listViewOrdersitemsRecordList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            listViewIndex) {
                                                                      final listViewOrdersitemsRecord =
                                                                          listViewOrdersitemsRecordList[
                                                                              listViewIndex];
                                                                      return Visibility(
                                                                        visible:
                                                                            listViewOrdersRecord.showorder ==
                                                                                true,
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              8.0,
                                                                              0.0,
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  width: 339.8,
                                                                                  height: 76.9,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xFFFFFFC9),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        blurRadius: 4.0,
                                                                                        color: Color(0x33000000),
                                                                                        offset: Offset(
                                                                                          2.0,
                                                                                          2.0,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                    borderRadius: BorderRadius.only(
                                                                                      bottomLeft: Radius.circular(15.0),
                                                                                      bottomRight: Radius.circular(15.0),
                                                                                      topLeft: Radius.circular(15.0),
                                                                                      topRight: Radius.circular(15.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 12.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 1.0, 1.0, 1.0),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                                              child: Image.network(
                                                                                                listViewOrdersitemsRecord.coverimage,
                                                                                                width: 70.0,
                                                                                                height: 70.0,
                                                                                                fit: BoxFit.cover,
                                                                                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                                  'assets/images/error_image.jpg',
                                                                                                  width: 70.0,
                                                                                                  height: 70.0,
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          flex: 3,
                                                                                          child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 4.0, 0.0),
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          listViewOrdersitemsRecord.productName,
                                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          formatNumber(
                                                                                                            listViewOrdersitemsRecord.unitPrice,
                                                                                                            formatType: FormatType.decimal,
                                                                                                            decimalType: DecimalType.periodDecimal,
                                                                                                            currency: '\$',
                                                                                                          ),
                                                                                                          textAlign: TextAlign.end,
                                                                                                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                                                font: GoogleFonts.interTight(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 15.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                                          child: RichText(
                                                                                                            textScaler: MediaQuery.of(context).textScaler,
                                                                                                            text: TextSpan(
                                                                                                              children: [
                                                                                                                TextSpan(
                                                                                                                  text: listViewOrdersitemsRecord.unitType == 'Gramos' ? 'Gramos: ' : 'Piezas: ',
                                                                                                                  style: TextStyle(),
                                                                                                                ),
                                                                                                                TextSpan(
                                                                                                                  text: formatNumber(
                                                                                                                    listViewOrdersitemsRecord.grams,
                                                                                                                    formatType: FormatType.decimal,
                                                                                                                    decimalType: DecimalType.periodDecimal,
                                                                                                                  ),
                                                                                                                  style: TextStyle(),
                                                                                                                )
                                                                                                              ],
                                                                                                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                    font: GoogleFonts.inter(
                                                                                                                      fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                      fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                    ),
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                  ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsetsDirectional.fromSTEB(35.0, 0.0, 0.0, 0.0),
                                                                                                          child: Text(
                                                                                                            '\$/kg',
                                                                                                            textAlign: TextAlign.end,
                                                                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                  font: GoogleFonts.inter(
                                                                                                                    fontWeight: FontWeight.normal,
                                                                                                                    fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                  ),
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          formatNumber(
                                                                                                            listViewOrdersitemsRecord.pricePerKg,
                                                                                                            formatType: FormatType.decimal,
                                                                                                            decimalType: DecimalType.periodDecimal,
                                                                                                            currency: '\$',
                                                                                                          ),
                                                                                                          textAlign: TextAlign.end,
                                                                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                                                font: GoogleFonts.inter(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                                ),
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // This is an amazing side panel, we need to make sure we know how it works =)
            if (responsiveVisibility(
              context: context,
              phone: false,
              tablet: false,
              tabletLandscape: false,
            ))
              Semantics(
                label:
                    'This side panel appears on the right of the screen and it houses the information of the viewed task.',
                child: Container(
                  width: 430.0,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          1.0,
                        ),
                      )
                    ],
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Channels / Task / Task #4234',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Icon(
                                Icons.more_vert_sharp,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.motion_photos_on_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 12.0),
                          child: Text(
                            'Update our command Palette to be more usable.',
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 4.0),
                                  child: Text(
                                    'Subtasks',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  '0 tasks',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 4.0),
                                  child: Text(
                                    'Created',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  'Created',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 4.0),
                                  child: Text(
                                    'Due Date',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  '10 Jan, 2023',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 24.0, 4.0),
                                child: Text(
                                  'Categories',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                child: Container(
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Text(
                                      'Design System',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                child: Container(
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent2,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Text(
                                      'Product',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 24.0, 4.0),
                          child: Text(
                            'Description',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Leave a note here...',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            maxLines: 8,
                            minLines: 4,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              text: 'Post Note',
                              options: FFButtonOptions(
                                width: 130.0,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 2.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                hoverColor: Color(0xFF2B16ED),
                                hoverTextColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
