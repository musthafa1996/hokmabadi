import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/app_module.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  runApp(ModularApp(
    module: AppModule(),
    child: const App(),
  ));
}
