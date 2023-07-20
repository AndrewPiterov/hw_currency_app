import 'dart:developer';

import 'package:currency_app/app/app.dart';
import 'package:get/get.dart';

class SettingsPageController extends GetxController {
  final AppRouter _router = Get.find();
  final ICurrenciesService _exchangedService = Get.find();
  final IAppSettingsService _appSettingsService = Get.find();

  final _currencies = <ExchangedRatesModel>[].obs;
  List<ExchangedRatesModel> get currencies => _currencies.toList();

  final _selectedAbbrs = <String>[].obs;
  List<String> get selectedAbbrs => _selectedAbbrs.toList();

  @override
  Future onReady() async {
    super.onReady();
    final sorted = await _exchangedService.currencyRatePairs$.first;
    _currencies.addAll(sorted.map((e) => e.curr).toList());
    _selectedAbbrs.addAll(_appSettingsService.currencyIdToShow);
  }

  void toggle(String abbr, bool isSelected) {
    if (_selectedAbbrs.contains(abbr)) {
      _selectedAbbrs.remove(abbr);
    } else {
      _selectedAbbrs.add(abbr);
    }
  }

  void reorder(int oldIndex, int newIndex) {
    log('reorder $oldIndex $newIndex');
    final currency = _currencies.removeAt(oldIndex);
    _currencies.insert(newIndex, currency);
  }

  Future save() async {
    await _appSettingsService.saveSelectedCurrencies(_selectedAbbrs.toList());
    await _appSettingsService
        .saveOrder(_currencies.map((e) => e.abbr).toList());
    await _router.pop();
  }
}
