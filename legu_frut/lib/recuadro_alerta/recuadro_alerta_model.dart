import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'recuadro_alerta_widget.dart' show RecuadroAlertaWidget;
import 'package:flutter/material.dart';

class RecuadroAlertaModel extends FlutterFlowModel<RecuadroAlertaWidget> {
  final formKey = GlobalKey<FormState>();

  FocusNode? titulotextFocusNode;
  TextEditingController? titulotextTextController;

  FocusNode? description1FocusNode;
  TextEditingController? description1TextController;

  FocusNode? description2FocusNode;
  TextEditingController? description2TextController;

  bool isSaving = false;

  @override
  void initState(BuildContext context) {}

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
