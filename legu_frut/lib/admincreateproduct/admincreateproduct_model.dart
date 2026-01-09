import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'admincreateproduct_widget.dart' show AdmincreateproductWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdmincreateproductModel
    extends FlutterFlowModel<AdmincreateproductWidget> {
  ///  Local state fields for this page.

  double? precio;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  String? _textController1Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter product name is required';
    }

    return null;
  }

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for DropDownsele widget.
  String? dropDownseleValue;
  FormFieldController<String>? dropDownseleValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  bool isDataUploading_uploadData5lk = false;
  FFUploadedFile uploadedLocalFile_uploadData5lk =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData5lk = '';

  // State field(s) for TextFieldprecio widget.
  FocusNode? textFieldprecioFocusNode;
  TextEditingController? textFieldprecioTextController;
  String? Function(BuildContext, String?)?
      textFieldprecioTextControllerValidator;
  String? _textFieldprecioTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '0.00 is required';
    }

    return null;
  }

  // State field(s) for TextFieldFru widget.
  FocusNode? textFieldFruFocusNode;
  TextEditingController? textFieldFruTextController;
  String? Function(BuildContext, String?)? textFieldFruTextControllerValidator;
  // State field(s) for TextFieldVer widget.
  FocusNode? textFieldVerFocusNode;
  TextEditingController? textFieldVerTextController;
  String? Function(BuildContext, String?)? textFieldVerTextControllerValidator;
  // State field(s) for TextFieldAbarr widget.
  FocusNode? textFieldAbarrFocusNode;
  TextEditingController? textFieldAbarrTextController;
  String? Function(BuildContext, String?)?
      textFieldAbarrTextControllerValidator;
  // State field(s) for TextFieldChiles widget.
  FocusNode? textFieldChilesFocusNode;
  TextEditingController? textFieldChilesTextController;
  String? Function(BuildContext, String?)?
      textFieldChilesTextControllerValidator;

  @override
  void initState(BuildContext context) {
    textController1Validator = _textController1Validator;
    textFieldprecioTextControllerValidator =
        _textFieldprecioTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldprecioFocusNode?.dispose();
    textFieldprecioTextController?.dispose();

    textFieldFruFocusNode?.dispose();
    textFieldFruTextController?.dispose();

    textFieldVerFocusNode?.dispose();
    textFieldVerTextController?.dispose();

    textFieldAbarrFocusNode?.dispose();
    textFieldAbarrTextController?.dispose();

    textFieldChilesFocusNode?.dispose();
    textFieldChilesTextController?.dispose();
  }
}
