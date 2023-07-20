import 'package:currency_app/app.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAsync();
  runApp(MyApp());
}
