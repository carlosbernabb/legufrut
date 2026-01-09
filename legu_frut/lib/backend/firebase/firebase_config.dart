import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCR-Y51_I-jVxai97nvXuAkIugNkAmRvWY",
            authDomain: "legufrut-71350.firebaseapp.com",
            projectId: "legufrut-71350",
            storageBucket: "legufrut-71350.firebasestorage.app",
            messagingSenderId: "951790695087",
            appId: "1:951790695087:web:07c1f3c6875d6f3d4a9a5a",
            measurementId: "G-4TR0MK4PX3"));
  } else {
    await Firebase.initializeApp();
  }
}
