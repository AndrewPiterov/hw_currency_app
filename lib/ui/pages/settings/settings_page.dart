import 'package:auto_route/auto_route.dart';
import 'package:currency_app/ui/pages/settings/settings_page_controller.dart';
import 'package:currency_app/ui/widgets/widgets.dart';
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
      body: Obx(
        () => ReorderableListView.builder(
          itemCount: c.currencies.length,
          onReorder: (oldIndex, newIndex) {
            c.reorder(oldIndex, newIndex);
          },
          itemBuilder: (_, index) {
            final currency = c.currencies[index];
            final isSelected = c.selectedAbbrs.contains(currency.abbr);
            return CurrencySettingView(
              currency,
              key: ValueKey(currency.abbr),
              initialState: isSelected,
              onChanged: (isSelected) => c.toggle(currency.abbr, isSelected),
            );
          },
        ),
      ),
    );
  }
}
