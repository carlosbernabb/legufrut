import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'driver_panel_widget.dart' show DriverPanelWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DriverPanelModel extends FlutterFlowModel<DriverPanelWidget> {
  ///  Local state fields for this page.

  String selectedDriver = 'Driver #1';

  List<LatLng> driverPoints = [];
  void addToDriverPoints(LatLng item) => driverPoints.add(item);
  void removeFromDriverPoints(LatLng item) => driverPoints.remove(item);
  void removeAtIndexFromDriverPoints(int index) => driverPoints.removeAt(index);
  void insertAtIndexInDriverPoints(int index, LatLng item) =>
      driverPoints.insert(index, item);
  void updateDriverPointsAtIndex(int index, Function(LatLng) updateFn) =>
      driverPoints[index] = updateFn(driverPoints[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in DriverPanel widget.
  List<OrdersRecord>? queryAction1;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Firestore Query - Query a collection] action in Tab widget.
  List<OrdersRecord>? actionDriver1;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter1;
  final googleMapsController1 = Completer<GoogleMapController>();
  // Stores action output result for [Firestore Query - Query a collection] action in Tab widget.
  List<OrdersRecord>? actionDriver2;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter2;
  final googleMapsController2 = Completer<GoogleMapController>();
  // Stores action output result for [Firestore Query - Query a collection] action in Tab widget.
  List<OrdersRecord>? actionDriver3;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter3;
  final googleMapsController3 = Completer<GoogleMapController>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
