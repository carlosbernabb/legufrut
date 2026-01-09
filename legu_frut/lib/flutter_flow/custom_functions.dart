import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

bool matchesSearch(
  String? productName,
  String? searchText,
) {
  // Si no hay nombre de producto, no coincide
  if (productName == null) {
    return false;
  }

  // Si el texto de búsqueda está vacío o nulo, mostramos todos los productos
  if (searchText == null || searchText.trim().isEmpty) {
    return true;
  }

  // Función interna para normalizar texto
  String normalize(String text) {
    var lower = text.toLowerCase();

    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';

    for (int i = 0; i < withAccents.length; i++) {
      lower = lower.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return lower.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  final normalizedProduct = normalize(productName);
  final normalizedSearch = normalize(searchText);

  // Coincidencia parcial
  return normalizedProduct.contains(normalizedSearch);
}

double recalcularPrecio(
  double precioTotalActual,
  double gramosActuales,
  double cambio,
) {
  // Evitar división por cero si es un producto nuevo
  if (gramosActuales == 0) {
    return 0.0;
  }

  // 1. Calculamos cuánto cuesta una unidad o gramo
  double precioUnitario = precioTotalActual / gramosActuales;

  // 2. Calculamos la nueva cantidad
  double nuevaCantidad = gramosActuales + cambio;

  // 3. Devolvemos el precio de esa nueva cantidad
  return precioUnitario * nuevaCantidad;
}
