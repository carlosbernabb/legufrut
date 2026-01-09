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
import 'carrito_widget.dart' show CarritoWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CarritoModel extends FlutterFlowModel<CarritoWidget> {
  ///  Local state fields for this page.

  bool carritoVacio = false;

  LatLng? orderLocation;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Calle widget.
  FocusNode? calleFocusNode;
  TextEditingController? calleTextController;
  String? Function(BuildContext, String?)? calleTextControllerValidator;
  String? _calleTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Calle is required';
    }

    return null;
  }

  // State field(s) for Numero widget.
  FocusNode? numeroFocusNode;
  TextEditingController? numeroTextController;
  String? Function(BuildContext, String?)? numeroTextControllerValidator;
  String? _numeroTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Número is required';
    }

    return null;
  }

  // State field(s) for Postalcode widget.
  FocusNode? postalcodeFocusNode;
  TextEditingController? postalcodeTextController;
  String? Function(BuildContext, String?)? postalcodeTextControllerValidator;
  String? _postalcodeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Código Postal is required';
    }

    return null;
  }

  // State field(s) for Colonia widget.
  FocusNode? coloniaFocusNode;
  TextEditingController? coloniaTextController;
  String? Function(BuildContext, String?)? coloniaTextControllerValidator;
  String? _coloniaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Colonia is required';
    }

    return null;
  }

  // State field(s) for referencia widget.
  FocusNode? referenciaFocusNode;
  TextEditingController? referenciaTextController;
  String? Function(BuildContext, String?)? referenciaTextControllerValidator;
  String? _referenciaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Referencia Visible is required';
    }

    return null;
  }

  // Stores action output result for [Custom Action - geocodeAddress] action in Button widget.
  LatLng? geoAction;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  OrdersRecord? orderAdress;

  @override
  void initState(BuildContext context) {
    calleTextControllerValidator = _calleTextControllerValidator;
    numeroTextControllerValidator = _numeroTextControllerValidator;
    postalcodeTextControllerValidator = _postalcodeTextControllerValidator;
    coloniaTextControllerValidator = _coloniaTextControllerValidator;
    referenciaTextControllerValidator = _referenciaTextControllerValidator;
  }

  @override
  void dispose() {
    calleFocusNode?.dispose();
    calleTextController?.dispose();

    numeroFocusNode?.dispose();
    numeroTextController?.dispose();

    postalcodeFocusNode?.dispose();
    postalcodeTextController?.dispose();

    coloniaFocusNode?.dispose();
    coloniaTextController?.dispose();

    referenciaFocusNode?.dispose();
    referenciaTextController?.dispose();
  }
}
