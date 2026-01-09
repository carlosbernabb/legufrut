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
import 'home_page_widget.dart' show HomePageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  double tmpGrams = 100.0;

  int piezas = 1;

  String? searchText = '\"\"';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<ProductsRecord> simpleSearchResults = [];
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> productcardModels1;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> productcardModels2;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> productcardModels3;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> productcardModels4;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> piezascomponentModels1;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> piezascomponentModels2;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> productcardModels5;
  // Models for UniversalProductCard dynamic component.
  late FlutterFlowDynamicModels<UniversalProductCardModel> productcardModels6;

  @override
  void initState(BuildContext context) {
    productcardModels1 = FlutterFlowDynamicModels(() => UniversalProductCardModel());
    productcardModels2 = FlutterFlowDynamicModels(() => UniversalProductCardModel());
    productcardModels3 = FlutterFlowDynamicModels(() => UniversalProductCardModel());
    productcardModels4 = FlutterFlowDynamicModels(() => UniversalProductCardModel());
    piezascomponentModels1 =
        FlutterFlowDynamicModels(() => UniversalProductCardModel());
    piezascomponentModels2 =
        FlutterFlowDynamicModels(() => UniversalProductCardModel());
    productcardModels5 = FlutterFlowDynamicModels(() => UniversalProductCardModel());
    productcardModels6 = FlutterFlowDynamicModels(() => UniversalProductCardModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    productcardModels1.dispose();
    productcardModels2.dispose();
    productcardModels3.dispose();
    productcardModels4.dispose();
    piezascomponentModels1.dispose();
    piezascomponentModels2.dispose();
    productcardModels5.dispose();
    productcardModels6.dispose();
  }
}
