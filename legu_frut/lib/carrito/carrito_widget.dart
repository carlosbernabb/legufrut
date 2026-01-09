import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'carrito_model.dart';
export 'carrito_model.dart';

class CarritoWidget extends StatefulWidget {
  const CarritoWidget({super.key});

  static String routeName = 'Carrito';
  static String routePath = '/carrito';

  @override
  State<CarritoWidget> createState() => _CarritoWidgetState();
}

class _CarritoWidgetState extends State<CarritoWidget>
    with TickerProviderStateMixin {
  late CarritoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarritoModel());

    _model.calleTextController ??= TextEditingController();
    _model.calleFocusNode ??= FocusNode();

    _model.numeroTextController ??= TextEditingController();
    _model.numeroFocusNode ??= FocusNode();

    _model.postalcodeTextController ??= TextEditingController();
    _model.postalcodeFocusNode ??= FocusNode();

    _model.coloniaTextController ??= TextEditingController();
    _model.coloniaFocusNode ??= FocusNode();

    _model.referenciaTextController ??= TextEditingController();
    _model.referenciaFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(3.0, 3.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(-100.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 30.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
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
    return StreamBuilder<List<CartRecord>>(
      stream: queryCartRecord(
        queryBuilder: (cartRecord) => cartRecord.where(
          'userRef',
          isEqualTo: currentUserReference,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
        List<CartRecord> carritoCartRecordList = snapshot.data!;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              buttonSize: 46.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 25.0,
              ),
              onPressed: () async {
                context.pushNamed(HomePageWidget.routeName);
              },
            ),
            actions: [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (carritoCartRecordList.length > 0)
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 4.0, 16.0, 16.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 770.0,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x33000000),
                                      offset: Offset(
                                        0.0,
                                        2.0,
                                      ),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tu Carrito',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 12.0),
                                        child: Text(
                                          'Aquí verás tu productos agregados',
                                          style: FlutterFlowTheme.of(context)
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
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 12.0),
                                        child: Builder(
                                          builder: (context) {
                                            final cartitem =
                                                carritoCartRecordList.toList();

                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: cartitem.length,
                                              itemBuilder:
                                                  (context, cartitemIndex) {
                                                final cartitemItem =
                                                    cartitem[cartitemIndex];
                                                return Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 12.0),
                                                  child: Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 0.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                          offset: Offset(
                                                            0.0,
                                                            1.0,
                                                          ),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            1.0,
                                                                            1.0,
                                                                            1.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                  child: Image
                                                                      .network(
                                                                    cartitemItem
                                                                        .coverimage,
                                                                    width: 70.0,
                                                                    height:
                                                                        70.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/error_image.jpg',
                                                                      width:
                                                                          70.0,
                                                                      height:
                                                                          70.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        cartitemItem
                                                                            .productName,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .override(
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
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  formatNumber(
                                                                    cartitemItem
                                                                        .unitPrice,
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .periodDecimal,
                                                                    currency:
                                                                        '\$',
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            15.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: 196.49,
                                                                height: 40.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    FlutterFlowIconButton(
                                                                      borderRadius:
                                                                          8.0,
                                                                      buttonSize:
                                                                          40.0,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .remove_rounded,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        if (cartitemItem.grams >
                                                                            0.0) {
                                                                          if (cartitemItem.unitType ==
                                                                              'Gramos') {
                                                                            await cartitemItem.reference.update({
                                                                              ...createCartRecordData(
                                                                                unitPrice: functions.recalcularPrecio(cartitemItem.unitPrice, cartitemItem.grams, -100.0),
                                                                              ),
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'grams': FieldValue.increment(-(100.0)),
                                                                                },
                                                                              ),
                                                                            });
                                                                          } else {
                                                                            await cartitemItem.reference.update({
                                                                              ...createCartRecordData(
                                                                                unitPrice: functions.recalcularPrecio(cartitemItem.unitPrice, cartitemItem.grams, -1.0),
                                                                              ),
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'grams': FieldValue.increment(-(1.0)),
                                                                                },
                                                                              ),
                                                                            });
                                                                          }
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'Usa el ícono basura para eliminar el producto',
                                                                                style: TextStyle(
                                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                                ),
                                                                              ),
                                                                              duration: Duration(milliseconds: 4000),
                                                                              backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                    Text(
                                                                      formatNumber(
                                                                        cartitemItem
                                                                            .grams,
                                                                        formatType:
                                                                            FormatType.decimal,
                                                                        decimalType:
                                                                            DecimalType.periodDecimal,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                    FlutterFlowIconButton(
                                                                      borderRadius:
                                                                          8.0,
                                                                      buttonSize:
                                                                          45.39,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .add_rounded,
                                                                        color: Color(
                                                                            0xFF39D2C0),
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        if (cartitemItem.unitType ==
                                                                            'Gramos') {
                                                                          await cartitemItem
                                                                              .reference
                                                                              .update({
                                                                            ...createCartRecordData(
                                                                              unitPrice: functions.recalcularPrecio(cartitemItem.unitPrice, cartitemItem.grams, 100.0),
                                                                            ),
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'grams': FieldValue.increment(100.0),
                                                                              },
                                                                            ),
                                                                          });
                                                                        } else {
                                                                          await cartitemItem
                                                                              .reference
                                                                              .update({
                                                                            ...createCartRecordData(
                                                                              unitPrice: functions.recalcularPrecio(cartitemItem.unitPrice, cartitemItem.grams, 1.0),
                                                                            ),
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'grams': FieldValue.increment(1.0),
                                                                              },
                                                                            ),
                                                                          });
                                                                        }
                                                                      },
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        cartitemItem.unitType == 'Gramos' ? 'grs' : 'pzas',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
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
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  await cartitemItem
                                                                      .reference
                                                                      .delete();
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Resumen de orden',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleLarge
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleLarge
                                                              .fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                'Desgloce de pedido',
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
                                              ),
                                            ),
                                            Divider(
                                              height: 32.0,
                                              thickness: 2.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Precio base',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        Text(
                                                          formatNumber(
                                                            (List<double>
                                                                subtotal) {
                                                              return subtotal
                                                                  .reduce((a,
                                                                          b) =>
                                                                      a + b);
                                                            }(carritoCartRecordList
                                                                .map((e) =>
                                                                    e.unitPrice)
                                                                .toList()),
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .periodDecimal,
                                                            currency: '\$',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Envío',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        Text(
                                                          '\$50.00',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 8.0,
                                                                0.0, 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Total',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            FlutterFlowIconButton(
                                                              borderColor: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  30.0,
                                                              borderWidth: 1.0,
                                                              buttonSize: 36.0,
                                                              icon: Icon(
                                                                Icons
                                                                    .info_outlined,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 18.0,
                                                              ),
                                                              onPressed: () {
                                                                print(
                                                                    'IconButton pressed ...');
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          formatNumber(
                                                            (List<double>
                                                                subtotal) {
                                                              return subtotal
                                                                      .reduce((a,
                                                                              b) =>
                                                                          a +
                                                                          b) +
                                                                  50;
                                                            }(carritoCartRecordList
                                                                .map((e) =>
                                                                    e.unitPrice)
                                                                .toList()),
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .periodDecimal,
                                                            currency: '\$',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                          Form(
                            key: _model.formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dirección de envío',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                  TextFormField(
                                    controller: _model.calleTextController,
                                    focusNode: _model.calleFocusNode,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Calle',
                                      hintStyle: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 14.0, 16.0, 14.0),
                                    ),
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
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                                    cursorColor:
                                        FlutterFlowTheme.of(context).success,
                                    validator: _model
                                        .calleTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              _model.numeroTextController,
                                          focusNode: _model.numeroFocusNode,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Número',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 14.0, 16.0, 14.0),
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
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
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .success,
                                          validator: _model
                                              .numeroTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              _model.postalcodeTextController,
                                          focusNode: _model.postalcodeFocusNode,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Código Postal',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
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
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 14.0, 16.0, 14.0),
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
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
                                          keyboardType: TextInputType.number,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .success,
                                          validator: _model
                                              .postalcodeTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                  TextFormField(
                                    controller: _model.coloniaTextController,
                                    focusNode: _model.coloniaFocusNode,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Colonia',
                                      hintStyle: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 14.0, 16.0, 14.0),
                                    ),
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
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                                    cursorColor:
                                        FlutterFlowTheme.of(context).success,
                                    validator: _model
                                        .coloniaTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  TextFormField(
                                    controller: _model.referenciaTextController,
                                    focusNode: _model.referenciaFocusNode,
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Referencia Visible',
                                      hintStyle: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 14.0, 16.0, 14.0),
                                    ),
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
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                                    maxLines: 2,
                                    cursorColor:
                                        FlutterFlowTheme.of(context).success,
                                    validator: _model
                                        .referenciaTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 16.0, 32.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 12.0,
                                              color: Color(0x26000000),
                                              offset: Offset(
                                                0.0,
                                                -4.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'Total estimado a pagar',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        'El precio puede variar por los gramos',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    formatNumber(
                                                      (List<double> subtotal) {
                                                        return subtotal.reduce(
                                                                (a, b) =>
                                                                    a + b) +
                                                            50;
                                                      }(carritoCartRecordList
                                                          .map((e) =>
                                                              e.unitPrice)
                                                          .toList()),
                                                      formatType:
                                                          FormatType.decimal,
                                                      decimalType: DecimalType
                                                          .periodDecimal,
                                                      currency: '\$',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
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
                                                          color:
                                                              Color(0xFF249689),
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
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  if (_model.formKey
                                                              .currentState ==
                                                          null ||
                                                      !_model
                                                          .formKey.currentState!
                                                          .validate()) {
                                                    return;
                                                  }
                                                  _model.geoAction =
                                                      await actions
                                                          .geocodeAddress(
                                                    _model.calleTextController
                                                        .text,
                                                    _model.numeroTextController
                                                        .text,
                                                    _model.coloniaTextController
                                                        .text,
                                                    _model
                                                        .postalcodeTextController
                                                        .text,
                                                  );
                                                  if (_model.geoAction ==
                                                      null) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Dirección Inválida o mal escrita.',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                fontSize: 15.0,
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
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 3550),
                                                        backgroundColor:
                                                            Color(0xFFCBE4FC),
                                                      ),
                                                    );
                                                  } else {
                                                    _model.orderLocation =
                                                        _model.geoAction;
                                                    safeSetState(() {});

                                                    var ordersRecordReference =
                                                        OrdersRecord.collection
                                                            .doc();
                                                    await ordersRecordReference
                                                        .set(
                                                            createOrdersRecordData(
                                                      userRef:
                                                          currentUserReference,
                                                      createdAt:
                                                          getCurrentTimestamp,
                                                      status: 'Pendiente',
                                                      street: _model
                                                          .calleTextController
                                                          .text,
                                                      number: _model
                                                          .numeroTextController
                                                          .text,
                                                      postalCode: _model
                                                          .postalcodeTextController
                                                          .text,
                                                      neighborhood: _model
                                                          .coloniaTextController
                                                          .text,
                                                      referenceNote: _model
                                                          .referenciaTextController
                                                          .text,
                                                      shippingFee: 50.0,
                                                      subtotal: (List<double>
                                                          subtotal) {
                                                        return subtotal.reduce(
                                                            (a, b) => a + b);
                                                      }(carritoCartRecordList
                                                          .map((e) =>
                                                              e.unitPrice)
                                                          .toList()),
                                                      total: (List<double>
                                                          subtotal) {
                                                        return subtotal.reduce(
                                                                (a, b) =>
                                                                    a + b) +
                                                            50;
                                                      }(carritoCartRecordList
                                                          .map((e) =>
                                                              e.unitPrice)
                                                          .toList()),
                                                      location:
                                                          _model.orderLocation,
                                                      nombrecliente:
                                                          currentUserDisplayName,
                                                    ));
                                                    _model.orderAdress = OrdersRecord
                                                        .getDocumentFromData(
                                                            createOrdersRecordData(
                                                              userRef:
                                                                  currentUserReference,
                                                              createdAt:
                                                                  getCurrentTimestamp,
                                                              status:
                                                                  'Pendiente',
                                                              street: _model
                                                                  .calleTextController
                                                                  .text,
                                                              number: _model
                                                                  .numeroTextController
                                                                  .text,
                                                              postalCode: _model
                                                                  .postalcodeTextController
                                                                  .text,
                                                              neighborhood: _model
                                                                  .coloniaTextController
                                                                  .text,
                                                              referenceNote: _model
                                                                  .referenciaTextController
                                                                  .text,
                                                              shippingFee: 50.0,
                                                              subtotal: (List<
                                                                      double>
                                                                  subtotal) {
                                                                return subtotal
                                                                    .reduce((a,
                                                                            b) =>
                                                                        a + b);
                                                              }(carritoCartRecordList
                                                                  .map((e) => e
                                                                      .unitPrice)
                                                                  .toList()),
                                                              total: (List<
                                                                      double>
                                                                  subtotal) {
                                                                return subtotal.reduce(
                                                                        (a, b) =>
                                                                            a +
                                                                            b) +
                                                                    50;
                                                              }(carritoCartRecordList
                                                                  .map((e) => e
                                                                      .unitPrice)
                                                                  .toList()),
                                                              location: _model
                                                                  .orderLocation,
                                                              nombrecliente:
                                                                  currentUserDisplayName,
                                                            ),
                                                            ordersRecordReference);
                                                    for (int loop1Index = 0;
                                                        loop1Index <
                                                            carritoCartRecordList
                                                                .map((e) => e)
                                                                .toList()
                                                                .length;
                                                        loop1Index++) {
                                                      final currentLoop1Item =
                                                          carritoCartRecordList
                                                                  .map((e) => e)
                                                                  .toList()[
                                                              loop1Index];

                                                      await OrdersitemsRecord
                                                              .createDoc(_model
                                                                  .orderAdress!
                                                                  .reference)
                                                          .set(
                                                              createOrdersitemsRecordData(
                                                        productRef:
                                                            currentLoop1Item
                                                                .productRef,
                                                        productName:
                                                            currentLoop1Item
                                                                .productName,
                                                        unitType:
                                                            currentLoop1Item
                                                                .unitType,
                                                        pricePerKg:
                                                            currentLoop1Item
                                                                .pricePerKg,
                                                        grams: currentLoop1Item
                                                            .grams,
                                                        unitPrice:
                                                            currentLoop1Item
                                                                .unitPrice,
                                                        coverimage:
                                                            currentLoop1Item
                                                                .coverimage,
                                                      ));
                                                    }
                                                    for (int loop2Index = 0;
                                                        loop2Index <
                                                            carritoCartRecordList
                                                                .length;
                                                        loop2Index++) {
                                                      final currentLoop2Item =
                                                          carritoCartRecordList[
                                                              loop2Index];
                                                      await currentLoop2Item
                                                          .reference
                                                          .delete();
                                                    }

                                                    context.goNamed(
                                                        ComprahechaWidget
                                                            .routeName);

                                                    triggerPushNotification(
                                                      notificationTitle:
                                                          '🛒 Pedido recibido',
                                                      notificationText:
                                                          'Tu pedido fue creado correctamente y ya lo estamos preparando.',
                                                      notificationSound:
                                                          'default',
                                                      userRefs: [
                                                        currentUserReference!
                                                      ],
                                                      initialPageName:
                                                          'Notificaciones',
                                                      parameterData: {},
                                                    );
                                                  }

                                                  safeSetState(() {});
                                                },
                                                text: 'Procesar Orden',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 56.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .success,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleLarge
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 16.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (carritoCartRecordList.length == 0)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 696.58,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).primaryBackground,
                                FlutterFlowTheme.of(context).tertiary,
                                FlutterFlowTheme.of(context).primary,
                                Colors.blue
                              ],
                              stops: [0.0, 0.5, 1.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                          ),
                          child: Container(
                            width: 100.0,
                            height: 254.69,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0x00FFFFFF),
                                  FlutterFlowTheme.of(context)
                                      .secondaryBackground
                                ],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1594488518065-832318c2405b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw0fHxjYXJ0fGVufDB8fHx8MTc2MzA1MTY0NXww&ixlib=rb-4.1.0&q=80&w=1080',
                                      width: 332.38,
                                      height: 358.9,
                                      fit: BoxFit.cover,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'imageOnPageLoadAnimation']!),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      44.0, 16.0, 44.0, 0.0),
                                  child: Text(
                                    'Dejaste solo a tu carrito ',
                                    textAlign: TextAlign.center,
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
                                  ).animateOnPageLoad(animationsMap[
                                      'textOnPageLoadAnimation1']!),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 15.0, 0.0, 0.0),
                                  child: Text(
                                    '¡Nos vemos pronto!',
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
                                  ).animateOnPageLoad(animationsMap[
                                      'textOnPageLoadAnimation2']!),
                                ),
                              ],
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation']!),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
