import 'package:currency_app/app/app.dart';
import 'package:get/get.dart';

enum RateDatesMode {
  yesterday,
  tomorrow,
}

class HomePageController extends GetxController {
  final AppRouter _router = Get.find();
  final IExchangedService _exchangedService = Get.find();

  Stream<List<ExchangedRatesModelPair>> get currencyRatePairsToShow$ =>
      _exchangedService.currencyRatePairsToShow$;

  final _datesMode = RateDatesMode.tomorrow.obs;
  RateDatesMode get datesMode => _datesMode.value;

  @override
  Future onReady() async {
    super.onReady();

    final list = await _exchangedService.currencyRatePairsToShow$.first;
    final hasNotTomorrow = list.any((e) => e.tomorrow == null);
    _datesMode.value =
        hasNotTomorrow ? RateDatesMode.yesterday : RateDatesMode.tomorrow;
  }

  void goToSettings() {
    _router.push(const SettingsRoute());
  }

  void changeRateDatesMode() {
    _datesMode.value = _datesMode.value == RateDatesMode.tomorrow
        ? RateDatesMode.yesterday
        : RateDatesMode.tomorrow;
  }
}
