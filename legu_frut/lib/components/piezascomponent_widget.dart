import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'piezascomponent_model.dart';
export 'piezascomponent_model.dart';

class PiezascomponentWidget extends StatefulWidget {
  const PiezascomponentWidget({
    super.key,
    this.coverimage,
    this.productname,
    this.parameter3,
    required this.parameter4,
    this.parameter5,
    required this.parameter6,
    this.parameter7,
  });

  final String? coverimage;
  final String? productname;
  final double? parameter3;
  final int? parameter4;
  final DocumentReference? parameter5;
  final double? parameter6;
  final DocumentReference? parameter7;

  @override
  State<PiezascomponentWidget> createState() => _PiezascomponentWidgetState();
}

class _PiezascomponentWidgetState extends State<PiezascomponentWidget>
    with TickerProviderStateMixin {
  late PiezascomponentModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PiezascomponentModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
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
            begin: Offset(60.0, 0.0),
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
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 0.0, 0.0),
      child: Container(
        width: 210.4,
        height: 321.5,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Color(0x230F1113),
              offset: Offset(
                0.0,
                4.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryBackground,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                widget!.coverimage!,
                width: double.infinity,
                height: 117.2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/error_image.jpg',
                  width: double.infinity,
                  height: 117.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 35.0, 16.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 15.0),
                        child: Text(
                          widget!.productname!,
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryText,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 0.0, 2.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 5.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      formatNumber(
                                        (widget!.parameter3!) *
                                            (_model.pieces!),
                                        formatType: FormatType.decimal,
                                        decimalType: DecimalType.periodDecimal,
                                        currency: '\$',
                                      ),
                                      '\$',
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
                                              .secondaryBackground,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 120.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: FlutterFlowCountController(
                                decrementIconBuilder: (enabled) => Icon(
                                  Icons.remove_rounded,
                                  color: enabled
                                      ? Color(0xFF006701)
                                      : Color(0xFFFF0000),
                                  size: 15.0,
                                ),
                                incrementIconBuilder: (enabled) => Icon(
                                  Icons.add_rounded,
                                  color: enabled
                                      ? Color(0xFF006701)
                                      : Color(0xFFFF0000),
                                  size: 15.0,
                                ),
                                countBuilder: (count) => Text(
                                  count.toString(),
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
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                ),
                                count: _model.countControlPiecesValue ??=
                                    _model.pieces!,
                                updateCount: (count) async {
                                  safeSetState(() =>
                                      _model.countControlPiecesValue = count);
                                  _model.pieces =
                                      _model.countControlPiecesValue;
                                  safeSetState(() {});
                                },
                                stepSize: 1,
                                minimum: 0,
                                maximum: 1000,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 4.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(),
                              ),
                            ),
                            Text(
                              'Piezas',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 15.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          _model.existingItem = await queryCartRecordOnce(
                            queryBuilder: (cartRecord) => cartRecord
                                .where(
                                  'productRef',
                                  isEqualTo: widget!.parameter5,
                                )
                                .where(
                                  'userRef',
                                  isEqualTo: currentUserReference,
                                ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          if (_model.existingItem?.reference != null) {
                            await _model.existingItem!.reference
                                .update(createCartRecordData(
                              grams: _model.existingItem!.grams +
                                  _model.pieces!.toDouble(),
                              unitPrice: (widget!.parameter3!) *
                                  (_model.existingItem!.grams +
                                      _model.pieces!.toDouble()),
                            ));
                          } else {
                            await CartRecord.collection
                                .doc()
                                .set(createCartRecordData(
                                  productRef: widget!.parameter5,
                                  productName: widget!.productname,
                                  createdAt: getCurrentTimestamp,
                                  coverimage: widget!.coverimage,
                                  grams: _model.pieces?.toDouble(),
                                  unitPrice: (widget!.parameter3!) *
                                      _model.pieces!.toDouble(),
                                  userRef: currentUserReference,
                                  unitType: 'Piezas',
                                ));
                          }

                          _model.pieces = 1;
                          safeSetState(() {});
                          safeSetState(() {
                            _model.countControlPiecesValue = 1;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Agregado al Carrito',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(milliseconds: 3550),
                              backgroundColor: Color(0xFFCBE4FC),
                            ),
                          );

                          safeSetState(() {});
                        },
                        text: 'Agregar al carrito',
                        options: FFButtonOptions(
                          height: 31.2,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryText,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}
