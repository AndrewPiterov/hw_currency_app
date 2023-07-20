import 'package:auto_route/annotations.dart';
import 'package:currency_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppRouter _router = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _router.replaceAll([const HomeRoute()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: UI.spinner,
    );
  }
}
