import 'package:auto_route/auto_route.dart';
import 'package:currency_app/ui/pages/settings/settings_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';

@RoutePage()
class SettingsPage extends GetView<SettingsPageController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsPageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка валют'),
        actions: [
          IconButton(
            onPressed: c.save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
