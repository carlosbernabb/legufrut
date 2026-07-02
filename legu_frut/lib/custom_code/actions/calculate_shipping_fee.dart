// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

/// Calcula el costo de envío desde la Central de Abastos (punto de origen)
/// hasta la dirección [destination] del cliente.
///
/// Usa la distancia de MANEJO real que da Google (Distance Matrix). Si esa
/// llamada fallara por cualquier motivo, usa distancia en línea recta como
/// respaldo para que el checkout nunca se trabe.
///
/// El origen, el precio por km y el mínimo se leen de `app_config`
/// (`origin_lat`, `origin_lng`, `price_per_km`, `min_shipping_fee`) para que
/// se puedan ajustar desde Firebase sin tocar la app. Si no existen, usa los
/// valores por defecto de Legufrut.
///
/// Devuelve una lista `[km, costo]` (ambos doubles).
Future<List<double>> calculateShippingFee(LatLng destination) async {
  // Valores por defecto (Central de Abastos de León - Blvd. Hermanos Aldama).
  double originLat = 21.0716592;
  double originLng = -101.6841543;
  double pricePerKm = 7.0;
  double minFee = 30.0;
  const apiKey = 'AIzaSyBvYou4n_t6ORKOrDHRPsnHD7mWC6iFVTw';

  // Lee la configuración editable desde Firebase.
  try {
    final snap = await FirebaseFirestore.instance
        .collection('app_config')
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) {
      final d = snap.docs.first.data();
      originLat = (d['origin_lat'] as num?)?.toDouble() ?? originLat;
      originLng = (d['origin_lng'] as num?)?.toDouble() ?? originLng;
      pricePerKm = (d['price_per_km'] as num?)?.toDouble() ?? pricePerKm;
      minFee = (d['min_shipping_fee'] as num?)?.toDouble() ?? minFee;
    }
  } catch (_) {}

  double? meters;

  // 1) Distancia de manejo real (Google Distance Matrix).
  try {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json'
      '?origins=$originLat,$originLng'
      '&destinations=${destination.latitude},${destination.longitude}'
      '&mode=driving&units=metric&key=$apiKey',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      if (data['status'] == 'OK') {
        final rows = data['rows'] as List?;
        final elements = (rows != null && rows.isNotEmpty)
            ? rows[0]['elements'] as List?
            : null;
        final element =
            (elements != null && elements.isNotEmpty) ? elements[0] : null;
        if (element != null && element['status'] == 'OK') {
          meters = (element['distance']?['value'] as num?)?.toDouble();
        }
      }
    }
  } catch (_) {}

  // 2) Respaldo: distancia en línea recta (sin red / API).
  meters ??= Geolocator.distanceBetween(
    originLat,
    originLng,
    destination.latitude,
    destination.longitude,
  );

  final km = meters / 1000.0;
  double fee = (km * pricePerKm).roundToDouble();
  if (fee < minFee) {
    fee = minFee;
  }

  return [double.parse(km.toStringAsFixed(2)), fee];
}
