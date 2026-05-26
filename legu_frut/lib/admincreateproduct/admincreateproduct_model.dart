import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'admincreateproduct_widget.dart' show AdmincreateproductWidget;
import 'package:flutter/material.dart';

class AdmincreateproductModel
    extends FlutterFlowModel<AdmincreateproductWidget> {
  // ── New-product form ─────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  bool isNewProductExpanded = false;
  bool isSaving = false;

  TextEditingController? nameController;
  FocusNode? nameFocusNode;

  TextEditingController? descController;
  FocusNode? descFocusNode;

  TextEditingController? priceController;
  FocusNode? priceFocusNode;

  String? categoryValue;
  String? saleTypeValue;

  // Image upload
  bool isDataUploading = false;
  SelectedFile? uploadedLocalFile;
  String uploadedFileUrl = '';

  // ── Search ───────────────────────────────────────────────────
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  String searchQuery = '';

  // ── Category expansion ───────────────────────────────────────
  Set<String> expandedCategories = {};

  // ── Inline price editing ─────────────────────────────────────
  String? editingProductId;
  TextEditingController? editingPriceController;
  FocusNode? editingPriceFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameController?.dispose();
    nameFocusNode?.dispose();
    descController?.dispose();
    descFocusNode?.dispose();
    priceController?.dispose();
    priceFocusNode?.dispose();
    searchController?.dispose();
    searchFocusNode?.dispose();
    editingPriceController?.dispose();
    editingPriceFocusNode?.dispose();
  }
}
