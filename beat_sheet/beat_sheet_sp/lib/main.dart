import 'package:beat_sheet/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'MainPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(MyApp());
}

