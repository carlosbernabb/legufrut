import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'universal_product_card_widget.dart' show UniversalProductCardWidget;
import 'package:flutter/material.dart';

class UniversalProductCardModel
    extends FlutterFlowModel<UniversalProductCardWidget> {
  // '' = not yet initialized; will be set on first render based on saleType
  String selectedUnit = '';
  double quantity = 1.0;
  bool isAddingToCart = false;

  // Stores existing cart item for update logic
  CartRecord? existingItem;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
