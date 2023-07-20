import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _router = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Currency App',
      routerConfig: _router.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
