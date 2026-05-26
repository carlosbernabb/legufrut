import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'driver_panel_widget.dart' show DriverPanelWidget;

class DriverPanelModel extends FlutterFlowModel<DriverPanelWidget> {
  List<LatLng> driver1Points = [];
  List<LatLng> driver2Points = [];
  List<LatLng> driver3Points = [];

  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  LatLng? googleMapsCenter1;
  final googleMapsController1 = Completer<GoogleMapController>();
  LatLng? googleMapsCenter2;
  final googleMapsController2 = Completer<GoogleMapController>();
  LatLng? googleMapsCenter3;
  final googleMapsController3 = Completer<GoogleMapController>();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
