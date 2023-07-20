import 'package:currency_app/app/services/exchanged_service.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final IExchangedService _exchangedService = Get.find();

  Stream<List<ExchangedRatesModelPair>> get pairs$ =>
      _exchangedService.currencyRatePairs$;
}
