import 'package:currency_app/app/app.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final AppRouter _router = Get.find();
  final IExchangedService _exchangedService = Get.find();

  Stream<List<ExchangedRatesModelPair>> get currencyRatePairsToShow$ =>
      _exchangedService.currencyRatePairsToShow$;

  void goToSettings() {
    _router.push(const SettingsRoute());
  }
}
