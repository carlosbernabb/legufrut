// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/auth/firebase_auth/auth_util.dart';

/// Guarda de rol para páginas restringidas (admin / conductor).
///
/// Las rutas solo exigen sesión iniciada (`requireAuth`), así que cualquier
/// cliente logueado podría navegar directo a /adminHub, /ordenesAdmin, etc.
/// Llamar esto en el initState de cada página restringida saca al usuario a
/// Home si no tiene el rol requerido.
Future<void> enforceRole(
  BuildContext context, {
  bool allowAdmin = true,
  bool allowDriver = false,
}) async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final ref = currentUserReference;
      if (ref == null) return; // requireAuth ya cubre el no-logueado.
      final snap = await ref.get();
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final isAdmin = data['isadmin'] == true;
      final isDriver = data['isDriver'] == true;
      final allowed =
          (allowAdmin && isAdmin) || (allowDriver && isDriver) || isAdmin;
      if (allowed || !context.mounted) return;

      context.goNamed('HomePage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No tienes permiso para entrar a esa sección.'),
          backgroundColor: const Color(0xFFB71C1C),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (_) {}
  });
}
