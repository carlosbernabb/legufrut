import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'productcard_copy_widget.dart' show ProductcardCopyWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductcardCopyModel extends FlutterFlowModel<ProductcardCopyWidget> {
  ///  Local state fields for this component.

  double? grams = 0.0;

  int? gramsint = 0;

  int? kilosInt = 1;

  double? piezas;

  int? pieces;

  ///  State fields for stateful widgets in this component.

  // State field(s) for Kiloscounter widget.
  int? kiloscounterValue;
  // State field(s) for gramscounter widget.
  int? gramscounterValue;
  // State field(s) for CountControlPieces widget.
  int? countControlPiecesValue;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  CartRecord? existingItem;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
