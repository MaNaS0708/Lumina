import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/lumina_app.dart';
import 'controllers/navigation_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(LuminaApp(navigationController: NavigationController()));
}
