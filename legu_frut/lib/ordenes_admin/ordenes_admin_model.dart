import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ordenes_admin_widget.dart' show OrdenesAdminWidget;
import 'package:flutter/material.dart';

class OrdenesAdminModel extends FlutterFlowModel<OrdenesAdminWidget> {
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
