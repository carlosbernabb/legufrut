import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'recuadro_alerta_widget.dart' show RecuadroAlertaWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecuadroAlertaModel extends FlutterFlowModel<RecuadroAlertaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Titulotext widget.
  FocusNode? titulotextFocusNode;
  TextEditingController? titulotextTextController;
  String? Function(BuildContext, String?)? titulotextTextControllerValidator;
  String? _titulotextTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Titulo es necesario';
    }

    return null;
  }

  // State field(s) for description1 widget.
  FocusNode? description1FocusNode;
  TextEditingController? description1TextController;
  String? Function(BuildContext, String?)? description1TextControllerValidator;
  String? _description1TextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '1ra Descripción es necesario';
    }

    return null;
  }

  // State field(s) for description2 widget.
  FocusNode? description2FocusNode;
  TextEditingController? description2TextController;
  String? Function(BuildContext, String?)? description2TextControllerValidator;
  String? _description2TextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '2da Descripción es necesario';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    titulotextTextControllerValidator = _titulotextTextControllerValidator;
    description1TextControllerValidator = _description1TextControllerValidator;
    description2TextControllerValidator = _description2TextControllerValidator;
  }

  @override
  void dispose() {
    titulotextFocusNode?.dispose();
    titulotextTextController?.dispose();

    description1FocusNode?.dispose();
    description1TextController?.dispose();

    description2FocusNode?.dispose();
    description2TextController?.dispose();
  }
}
