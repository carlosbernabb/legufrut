import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/universal_product_card_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    animationsMap.addAll({
      'textFieldOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.95, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.95, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(-33.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(30.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'productcardOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          TiltEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 820.0.ms,
            begin: Offset(0.436, -0.175),
            end: Offset(0, 0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(30.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(30.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(30.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: Offset(100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 350.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 350.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 350.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 30.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation8': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 350.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 350.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 350.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 30.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation9': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 350.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 350.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 350.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 30.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<ProductsRecord>>(
      stream: queryProductsRecord(),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ProductsRecord> homePageProductsRecordList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      height: 500.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.05, -1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1610832958506-aa56368176cf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxmcnVpdHN8ZW58MHx8fHwxNzYxNzU4NzA1fDA&ixlib=rb-4.1.0&q=80&w=1080',
                                width: double.infinity,
                                height: 500.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 500.0,
                            decoration: BoxDecoration(
                              color: Color(0x8D090F13),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 25.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      FlutterFlowIconButton(
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        icon: Icon(
                                          Icons.clear_rounded,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          FFAppState().buscador = false;
                                          safeSetState(() {});
                                          safeSetState(() {
                                            _model.textController?.clear();
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: _model.textController,
                                          focusNode: _model.textFieldFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.textController',
                                            Duration(milliseconds: 2000),
                                            () async {
                                              safeSetState(() {
                                                _model.simpleSearchResults =
                                                    TextSearch(
                                                  homePageProductsRecordList
                                                      .map(
                                                        (record) =>
                                                            TextSearchItem
                                                                .fromTerms(
                                                                    record, [
                                                          record.name!,
                                                          record.category!
                                                        ]),
                                                      )
                                                      .toList(),
                                                )
                                                        .search(_model
                                                            .textController
                                                            .text)
                                                        .map((r) => r.object)
                                                        .toList();
                                                ;
                                              });
                                              FFAppState().buscador = true;
                                              safeSetState(() {});
                                            },
                                          ),
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                            hintText:
                                                'Frutas, verduras, semillas, abarrotes...',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 16.0,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
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
                                          validator: _model
                                              .textControllerValidator
                                              .asValidator(context),
                                        ).animateOnPageLoad(animationsMap[
                                            'textFieldOnPageLoadAnimation']!),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 24.0, 16.0, 0.0),
                                            child: Text(
                                              'Explora entre variedad y frescura',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .fontStyle,
                                                    ),
                                                    color: Colors.white,
                                                    fontSize: 25.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displaySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displaySmall
                                                            .fontStyle,
                                                  ),
                                            ).animateOnPageLoad(animationsMap[
                                                'textOnPageLoadAnimation1']!),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      15.0, 5.0, 0.0, 0.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  GoRouter.of(context)
                                                      .prepareAuthEvent();
                                                  await authManager.signOut();
                                                  GoRouter.of(context)
                                                      .clearRedirectLocation();

                                                  context.goNamedAuth(
                                                      LogginWidget.routeName,
                                                      context.mounted);
                                                },
                                                text: 'Salir',
                                                icon: Icon(
                                                  Icons.person_off,
                                                  size: 15.0,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 26.53,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFF73034),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ).animateOnPageLoad(animationsMap[
                                                  'buttonOnPageLoadAnimation']!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100.0,
                                      child: VerticalDivider(
                                        thickness: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: FlutterFlowIconButton(
                                            borderRadius: 8.0,
                                            buttonSize: 40.0,
                                            fillColor: Color(0xFFAC4213),
                                            icon: Icon(
                                              Icons.shopping_cart,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              context.pushNamed(
                                                  CarritoWidget.routeName);
                                            },
                                          ),
                                        ),
                                        if (valueOrDefault<bool>(
                                                currentUserDocument?.isadmin,
                                                false) ==
                                            true)
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 10.0, 0.0),
                                            child: AuthUserStreamWidget(
                                              builder: (context) =>
                                                  FlutterFlowIconButton(
                                                borderRadius: 8.0,
                                                buttonSize: 40.0,
                                                fillColor: Color(0xFFAC4213),
                                                icon: Icon(
                                                  Icons.edit_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .info,
                                                  size: 24.0,
                                                ),
                                                onPressed: () async {
                                                  context.pushNamed(
                                                      AdmincreateproductWidget
                                                          .routeName);
                                                },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ).animateOnPageLoad(animationsMap[
                                        'columnOnPageLoadAnimation1']!),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 15.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 5.0, 0.0, 0.0),
                                            child: FlutterFlowIconButton(
                                              borderRadius: 8.0,
                                              buttonSize: 40.0,
                                              fillColor: Color(0xFFAC4213),
                                              icon: Icon(
                                                Icons.notifications_outlined,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 24.0,
                                              ),
                                              onPressed: () async {
                                                context.pushNamed(
                                                    NotificacionesWidget
                                                        .routeName);
                                              },
                                            ),
                                          ),
                                          if ((valueOrDefault<bool>(
                                                      currentUserDocument
                                                          ?.isDriver,
                                                      false) ==
                                                  true) ||
                                              (valueOrDefault<bool>(
                                                      currentUserDocument
                                                          ?.isadmin,
                                                      false) ==
                                                  true))
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 5.0, 0.0, 0.0),
                                              child: AuthUserStreamWidget(
                                                builder: (context) =>
                                                    FlutterFlowIconButton(
                                                  borderRadius: 8.0,
                                                  buttonSize: 40.0,
                                                  fillColor: Color(0xFFAC4213),
                                                  icon: Icon(
                                                    Icons
                                                        .sports_motorsports_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    context.pushNamed(
                                                        DriverPanelWidget
                                                            .routeName);
                                                  },
                                                ),
                                              ),
                                            ),
                                        ],
                                      ).animateOnPageLoad(animationsMap[
                                          'columnOnPageLoadAnimation2']!),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 3.0,
                                  indent: 100.0,
                                  endIndent: 100.0,
                                  color: Color(0xFF99A2A2),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: 700.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0.0),
                                        bottomRight: Radius.circular(0.0),
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 24.0),
                                      child: SingleChildScrollView(
                                        primary: false,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Builder(
                                              builder: (context) {
                                                if (FFAppState().buscador &&
                                                    _model.simpleSearchResults
                                                        .where((e) =>
                                                            e.category ==
                                                            'Frutas')
                                                        .isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return Column(
                                                  children: [
                                                    Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(16.0, 16.0,
                                                          16.0, 0.0),
                                                  child: Text(
                                                    'Frutas',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                                  ).animateOnPageLoad(animationsMap[
                                                      'textOnPageLoadAnimation2']!),
                                                ),
                                              ],
                                            ).animateOnPageLoad(animationsMap[
                                                'rowOnPageLoadAnimation']!),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 415.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 415.0,
                                                  child: Stack(
                                                    children: [
                                                      if (FFAppState()
                                                              .buscador ==
                                                          true)
                                                        Builder(
                                                          builder: (context) {
                                                            final frutasItem =
                                                                _model
                                                                    .simpleSearchResults
                                                                    .map((e) =>
                                                                        e)
                                                                    .map((e) =>
                                                                        e)
                                                                    .toList()
                                                                    .where((e) =>
                                                                        e.category ==
                                                                        'Frutas')
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  frutasItem
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  frutasItemIndex) {
                                                                final frutasItemItem =
                                                                    frutasItem[
                                                                        frutasItemIndex];
                                                                return wrapWithModel(
                                                                  model: _model
                                                                      .productcardModels1
                                                                      .getModel(
                                                                    frutasItemItem
                                                                        .reference
                                                                        .id,
                                                                    frutasItemIndex,
                                                                  ),
                                                                  updateCallback: () =>
                                                                      safeSetState(
                                                                          () {}),
                                                                  child:
                                                                      UniversalProductCardWidget(
                                                                    key: Key(
                                                                      'Key2xg_${frutasItemItem.reference.id}',
                                                                    ),
                                                                    coverimage:
                                                                        frutasItemItem
                                                                            .coverImage,
                                                                    productname:
                                                                        frutasItemItem
                                                                            .name,
                                                                    price:
                                                                        frutasItemItem
                                                                            .price,
                                                                    productRef:
                                                                        frutasItemItem
                                                                            .reference,
                                                                    saleType: 
                                                                        frutasItemItem
                                                                            .saleType,
                                                                  ),
                                                                ).animateOnPageLoad(
                                                                    animationsMap[
                                                                        'productcardOnPageLoadAnimation']!);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      if (FFAppState()
                                                              .buscador ==
                                                          false)
                                                        Builder(
                                                          builder: (context) {
                                                            final frutasItem =
                                                                homePageProductsRecordList
                                                                    .where((e) =>
                                                                        e.category ==
                                                                        'Frutas')
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  frutasItem
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  frutasItemIndex) {
                                                                final frutasItemItem =
                                                                    frutasItem[
                                                                        frutasItemIndex];
                                                                return wrapWithModel(
                                                                  model: _model
                                                                      .productcardModels2
                                                                      .getModel(
                                                                    frutasItemItem
                                                                        .reference
                                                                        .id,
                                                                    frutasItemIndex,
                                                                  ),
                                                                  updateCallback: () =>
                                                                      safeSetState(
                                                                          () {}),
                                                                  child:
                                                                      UniversalProductCardWidget(
                                                                    key: Key(
                                                                      'Keytnv_${frutasItemItem.reference.id}',
                                                                    ),
                                                                    coverimage:
                                                                        frutasItemItem
                                                                            .coverImage,
                                                                    productname:
                                                                        frutasItemItem
                                                                            .name,
                                                                    price:
                                                                        frutasItemItem
                                                                            .price,
                                                                    productRef:
                                                                        frutasItemItem
                                                                            .reference,
                                                                    saleType: 
                                                                        frutasItemItem
                                                                            .saleType,
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Builder(
                                              builder: (context) {
                                                if (FFAppState().buscador &&
                                                    _model.simpleSearchResults
                                                        .where((e) =>
                                                            e.category ==
                                                            'Verduras')
                                                        .isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return Column(
                                                  children: [
                                                    Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(16.0, 16.0,
                                                          16.0, 0.0),
                                                  child: Text(
                                                    'Verduras',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineMedium
                                                                  .fontStyle,
                                                        ),
                                                  ).animateOnPageLoad(animationsMap[
                                                      'textOnPageLoadAnimation3']!),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 415.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Container(
                                                  height: 415.0,
                                                  child: Stack(
                                                    children: [
                                                      if (FFAppState()
                                                              .buscador ==
                                                          false)
                                                        Builder(
                                                          builder: (context) {
                                                            final verdurastem =
                                                                homePageProductsRecordList
                                                                    .where((e) =>
                                                                        e.category ==
                                                                        'Verduras')
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  verdurastem
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  verdurastemIndex) {
                                                                final verdurastemItem =
                                                                    verdurastem[
                                                                        verdurastemIndex];
                                                                return wrapWithModel(
                                                                  model: _model
                                                                      .productcardModels3
                                                                      .getModel(
                                                                    verdurastemItem
                                                                        .reference
                                                                        .id,
                                                                    verdurastemIndex,
                                                                  ),
                                                                  updateCallback: () =>
                                                                      safeSetState(
                                                                          () {}),
                                                                  child:
                                                                      UniversalProductCardWidget(
                                                                    key: Key(
                                                                      'Keylzu_${verdurastemItem.reference.id}',
                                                                    ),
                                                                    coverimage:
                                                                        verdurastemItem
                                                                            .coverImage,
                                                                    productname:
                                                                        verdurastemItem
                                                                            .name,
                                                                    price:
                                                                        verdurastemItem
                                                                            .price,
                                                                    productRef:
                                                                        verdurastemItem
                                                                            .reference,
                                                                    saleType: 
                                                                        verdurastemItem
                                                                            .saleType,
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      if (FFAppState()
                                                              .buscador ==
                                                          true)
                                                        Builder(
                                                          builder: (context) {
                                                            final verdurastem =
                                                                _model
                                                                    .simpleSearchResults
                                                                    .map((e) =>
                                                                        e)
                                                                    .map((e) =>
                                                                        e)
                                                                    .toList()
                                                                    .where((e) =>
                                                                        e.category ==
                                                                        'Verduras')
                                                                    .toList();

                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  verdurastem
                                                                      .length,
                                                              itemBuilder: (context,
                                                                  verdurastemIndex) {
                                                                final verdurastemItem =
                                                                    verdurastem[
                                                                        verdurastemIndex];
                                                                return wrapWithModel(
                                                                  model: _model
                                                                      .productcardModels4
                                                                      .getModel(
                                                                    verdurastemItem
                                                                        .reference
                                                                        .id,
                                                                    verdurastemIndex,
                                                                  ),
                                                                  updateCallback: () =>
                                                                      safeSetState(
                                                                          () {}),
                                                                  child:
                                                                      UniversalProductCardWidget(
                                                                    key: Key(
                                                                      'Key5z2_${verdurastemItem.reference.id}',
                                                                    ),
                                                                    coverimage:
                                                                        verdurastemItem
                                                                            .coverImage,
                                                                    productname:
                                                                        verdurastemItem
                                                                            .name,
                                                                    price:
                                                                        verdurastemItem
                                                                            .price,
                                                                    productRef:
                                                                        verdurastemItem
                                                                            .reference,
                                                                    saleType: 
                                                                        verdurastemItem
                                                                            .saleType,
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Builder(
                                              builder: (context) {
                                                if (FFAppState().buscador &&
                                                    _model.simpleSearchResults
                                                        .where((e) =>
                                                            e.category ==
                                                            'Abarrotes')
                                                        .isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return Column(
                                                  children: [
                                                    Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 0.0),
                                                    child: Text(
                                                      'Abarrotes',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                              ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'textOnPageLoadAnimation4']!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 415.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    if (FFAppState().buscador ==
                                                        false)
                                                      Builder(
                                                        builder: (context) {
                                                          final abarrotesItem =
                                                              homePageProductsRecordList
                                                                  .where((e) =>
                                                                      e.category ==
                                                                      'Abarrotes')
                                                                  .toList();

                                                          return ListView
                                                              .builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            primary: false,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                abarrotesItem
                                                                    .length,
                                                            itemBuilder: (context,
                                                                abarrotesItemIndex) {
                                                              final abarrotesItemItem =
                                                                  abarrotesItem[
                                                                      abarrotesItemIndex];
                                                              return wrapWithModel(
                                                                model: _model
                                                                    .piezascomponentModels1
                                                                    .getModel(
                                                                  abarrotesItemItem
                                                                      .reference
                                                                      .id,
                                                                  abarrotesItemIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    UniversalProductCardWidget(
                                                                  key: Key(
                                                                    'Keyp3m_${abarrotesItemItem.reference.id}',
                                                                  ),
                                                                  coverimage:
                                                                      abarrotesItemItem
                                                                          .coverImage,
                                                                  productname:
                                                                      abarrotesItemItem
                                                                          .name,
                                                                  price:
                                                                      abarrotesItemItem
                                                                          .price,
                                                                  productRef:
                                                                      abarrotesItemItem
                                                                          .reference,
                                                                  saleType: 
                                                                      abarrotesItemItem
                                                                          .saleType,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    if (FFAppState().buscador ==
                                                        true)
                                                      Builder(
                                                        builder: (context) {
                                                          final abarrotesItem =
                                                              _model
                                                                  .simpleSearchResults
                                                                  .map((e) => e)
                                                                  .toList()
                                                                  .where((e) =>
                                                                      e.category ==
                                                                      'Abarrotes')
                                                                  .toList();

                                                          return ListView
                                                              .builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            primary: false,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                abarrotesItem
                                                                    .length,
                                                            itemBuilder: (context,
                                                                abarrotesItemIndex) {
                                                              final abarrotesItemItem =
                                                                  abarrotesItem[
                                                                      abarrotesItemIndex];
                                                              return wrapWithModel(
                                                                model: _model
                                                                    .piezascomponentModels2
                                                                    .getModel(
                                                                  abarrotesItemItem
                                                                      .reference
                                                                      .id,
                                                                  abarrotesItemIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    UniversalProductCardWidget(
                                                                  key: Key(
                                                                    'Keybp1_${abarrotesItemItem.reference.id}',
                                                                  ),
                                                                  coverimage:
                                                                      abarrotesItemItem
                                                                          .coverImage,
                                                                  productname:
                                                                      abarrotesItemItem
                                                                          .name,
                                                                  price:
                                                                      abarrotesItemItem
                                                                          .price,
                                                                  productRef:
                                                                      abarrotesItemItem
                                                                          .reference,
                                                                  saleType: 
                                                                      abarrotesItemItem
                                                                          .saleType,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Builder(
                                              builder: (context) {
                                                if (FFAppState().buscador &&
                                                    _model.simpleSearchResults
                                                        .where((e) =>
                                                            e.category ==
                                                            'Chiles–Semillas–Plantas')
                                                        .isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return Column(
                                                  children: [
                                                    Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16.0,
                                                                16.0,
                                                                16.0,
                                                                0.0),
                                                    child: Text(
                                                      'Chiles y Semillas',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineMedium
                                                                    .fontStyle,
                                                              ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'textOnPageLoadAnimation5']!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 415.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    if (FFAppState().buscador ==
                                                        false)
                                                      Builder(
                                                        builder: (context) {
                                                          final chilesSemillasPlantastem =
                                                              homePageProductsRecordList
                                                                  .where((e) =>
                                                                      e.category ==
                                                                      'Chiles–Semillas–Plantas')
                                                                  .toList();

                                                          return ListView
                                                              .builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            primary: false,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                chilesSemillasPlantastem
                                                                    .length,
                                                            itemBuilder: (context,
                                                                chilesSemillasPlantastemIndex) {
                                                              final chilesSemillasPlantastemItem =
                                                                  chilesSemillasPlantastem[
                                                                      chilesSemillasPlantastemIndex];
                                                              return wrapWithModel(
                                                                model: _model
                                                                    .productcardModels5
                                                                    .getModel(
                                                                  chilesSemillasPlantastemItem
                                                                      .reference
                                                                      .id,
                                                                  chilesSemillasPlantastemIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    UniversalProductCardWidget(
                                                                  key: Key(
                                                                    'Keybpe_${chilesSemillasPlantastemItem.reference.id}',
                                                                  ),
                                                                  coverimage:
                                                                      chilesSemillasPlantastemItem
                                                                          .coverImage,
                                                                  productname:
                                                                      chilesSemillasPlantastemItem
                                                                          .name,
                                                                  price:
                                                                      chilesSemillasPlantastemItem
                                                                          .price,
                                                                  productRef:
                                                                      chilesSemillasPlantastemItem
                                                                          .reference,
                                                                  saleType: 
                                                                      chilesSemillasPlantastemItem
                                                                          .saleType,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    if (FFAppState().buscador ==
                                                        true)
                                                      Builder(
                                                        builder: (context) {
                                                          final chilesSemillasPlantastem =
                                                              _model
                                                                  .simpleSearchResults
                                                                  .map((e) => e)
                                                                  .toList()
                                                                  .where((e) =>
                                                                      e.category ==
                                                                      'Chiles–Semillas–Plantas')
                                                                  .toList();

                                                          return ListView
                                                              .builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            primary: false,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                chilesSemillasPlantastem
                                                                    .length,
                                                            itemBuilder: (context,
                                                                chilesSemillasPlantastemIndex) {
                                                              final chilesSemillasPlantastemItem =
                                                                  chilesSemillasPlantastem[
                                                                      chilesSemillasPlantastemIndex];
                                                              return wrapWithModel(
                                                                model: _model
                                                                    .productcardModels6
                                                                    .getModel(
                                                                  chilesSemillasPlantastemItem
                                                                      .reference
                                                                      .id,
                                                                  chilesSemillasPlantastemIndex,
                                                                ),
                                                                updateCallback: () =>
                                                                    safeSetState(
                                                                        () {}),
                                                                child:
                                                                    UniversalProductCardWidget(
                                                                  key: Key(
                                                                    'Key245_${chilesSemillasPlantastemItem.reference.id}',
                                                                  ),
                                                                  coverimage:
                                                                      chilesSemillasPlantastemItem
                                                                          .coverImage,
                                                                  productname:
                                                                      chilesSemillasPlantastemItem
                                                                          .name,
                                                                  price:
                                                                      chilesSemillasPlantastemItem
                                                                          .price,
                                                                  productRef:
                                                                      chilesSemillasPlantastemItem
                                                                          .reference,
                                                                  saleType: 
                                                                      chilesSemillasPlantastemItem
                                                                          .saleType,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 4.0, 16.0, 0.0),
                                              child: Text(
                                                'Arma tu receta',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                              ).animateOnPageLoad(animationsMap[
                                                  'textOnPageLoadAnimation6']!),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (FFAppState().showPopup == true)
                            StreamBuilder<List<AppConfigRecord>>(
                              stream: queryAppConfigRecord(
                                singleRecord: true,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<AppConfigRecord>
                                    overlayAppConfigRecordList = snapshot.data!;
                                // Return an empty Container when the item does not exist.
                                if (snapshot.data!.isEmpty) {
                                  return Container();
                                }
                                final overlayAppConfigRecord =
                                    overlayAppConfigRecordList.isNotEmpty
                                        ? overlayAppConfigRecordList.first
                                        : null;

                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0x8D090F13),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 300.0,
                                        height: 270.8,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE4D8CC),
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
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 5.0, 5.0, 5.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 10.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        overlayAppConfigRecord
                                                            ?.popupTitle,
                                                        '¡ Aviso !',
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displayLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .displayLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .displayLarge
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 40.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displayLarge
                                                                    .fontStyle,
                                                              ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'textOnPageLoadAnimation7']!),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 10.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        overlayAppConfigRecord
                                                            ?.popupDesc1,
                                                        'Ordena hoy y resive lo más fresco mañana',
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .displaySmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .displaySmall
                                                                      .fontStyle,
                                                                ),
                                                                color: Color(
                                                                    0xFF3A27C6),
                                                                fontSize: 20.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                              ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'textOnPageLoadAnimation8']!),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      overlayAppConfigRecord
                                                          ?.popupDesc2,
                                                      'Pedidos realizados antes de las 12:00 del medio dia serán entregados ese mismo día',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                          color:
                                                              Color(0xFF3A27C6),
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                  ).animateOnPageLoad(animationsMap[
                                                      'textOnPageLoadAnimation9']!),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, -1.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FFAppState().showPopup =
                                                        false;
                                                    safeSetState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.cancel_presentation,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation']!),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
