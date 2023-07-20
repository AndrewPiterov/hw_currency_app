import 'package:currency_app/app/app.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:speed_up_get/speed_up_get.dart';

enum RateDatesMode {
  yesterday,
  tomorrow,
}

class HomePageController extends GetxController with GetxSubscribing {
  final AppRouter _router = Get.find();
  final ICurrenciesService _exchangedService = Get.find();
  final IEventBus _eventBus = Get.find();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  Stream<List<ExchangedRatesModelPair>> get currencyRatePairsToShow$ =>
      _exchangedService.currencyRatePairsToShow$;

  final _datesMode = RateDatesMode.tomorrow.obs;
  RateDatesMode get datesMode => _datesMode.value;

  late BuildContext context;

  final _lastFailFetch = Rxn<DateTime>();
  DateTime? get lastFailFetch => _lastFailFetch.value;

  @override
  void onInit() {
    super.onInit();

    subscribe(_eventBus.last$, (value) {
      if (value is SuccessFetchingEvent) {
        _lastFailFetch.value = null;
      } else if (value is FailFetchingEvent) {
        // show alert dialog
        _lastFailFetch.value = DateTime.now();
        _dialogBuilder(value.reason);
      }
    });
  }

  Future _dialogBuilder(String errorMessage) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Failed to fetch data'),
          content: const Text('Не удалось получить курсы валют'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: _router.pop,
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

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

  Future onRefresh() async {
    final res = await _exchangedService.refresh();
    if (res.isFail) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }
}
