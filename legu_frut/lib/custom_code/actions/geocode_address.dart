// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Convierte una dirección escrita en coordenadas LatLng reales.
/// SOLO acepta direcciones dentro de León, Guanajuato
/// usando validación por CÓDIGO POSTAL.
/// Fuera de León → retorna null.
Future<LatLng?> geocodeAddress(
  String street,
  String number,
  String neighborhood,
  String postalCode,
) async {
  try {
    // 🔒 RANGO DE CP VÁLIDO PARA LEÓN
    const int cpMin = 37000;
    const int cpMax = 37999;

    // Dirección SIN forzar ciudad
    final fullAddress = '$street $number, $neighborhood, $postalCode, México';

    final apiKey = 'AIzaSyBvYou4n_t6ORKOrDHRPsnHD7mWC6iFVTw';

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeComponent(fullAddress)}'
      '&components=country:MX'
      '&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['status'] != 'OK' ||
        data['results'] == null ||
        data['results'].isEmpty) {
      return null;
    }

    final result = data['results'][0];
    final components = (result['address_components'] as List?) ?? [];

    int? resolvedPostalCode;

    // 🔍 Buscar postal_code REAL
    for (final component in components) {
      final types = (component['types'] as List?)?.cast<String>() ?? [];

      if (types.contains('postal_code')) {
        final cpString = component['long_name']?.toString();
        if (cpString != null) {
          resolvedPostalCode = int.tryParse(cpString);
        }
      }
    }

    // ❌ No se pudo obtener CP
    if (resolvedPostalCode == null) return null;

    // ❌ CP fuera de León
    if (resolvedPostalCode < cpMin || resolvedPostalCode > cpMax) {
      return null;
    }

    // 📍 Coordenadas válidas
    final location = result['geometry']?['location'];
    if (location == null) return null;

    final lat = location['lat'];
    final lng = location['lng'];

    if (lat == null || lng == null) return null;

    return LatLng(lat, lng);
  } catch (e) {
    return null;
  }
}
