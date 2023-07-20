import 'package:currency_app/app/app.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class HomePageController extends GetxController {
  final AppRouter _router = Get.find();
  final IExchangedService _exchangedService = Get.find();
  final IAppSettingsService _settingsService = Get.find();

  Stream<List<ExchangedRatesModelPair>> get currencyRatePairsToShow$ =>
      CombineLatestStream.combine3(
          _exchangedService.currencyRatePairs$,
          _settingsService.currencyIdToShow$,
          _settingsService.order$, (pairs, abbrs, order) {
        // filter
        final list = pairs.where((pair) => abbrs.contains(pair.abbr)).toList();

        // sort
        list.sort((a, b) {
          final aIndex = order.indexOf(a.abbr);
          final bIndex = order.indexOf(b.abbr);
          return aIndex.compareTo(bIndex);
        });

        return list;
      });

  void goToSettings() {
    _router.push(const SettingsRoute());
  }
}
