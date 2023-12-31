import 'package:currency_app/app/app.dart';
import 'package:date_time/date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:fluent_result/fluent_result.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:speed_up/speed_up.dart';

import '../api/rest_client.dart';

class ExchangedRatesModelPair extends Equatable {
  const ExchangedRatesModelPair({
    this.yesterday,
    this.today,
    this.tomorrow,
  });

  final ExchangedRatesModel? yesterday;
  final ExchangedRatesModel? today;
  final ExchangedRatesModel? tomorrow;

  ExchangedRatesModel get curr => (yesterday ?? today ?? tomorrow)!;

  String get currency => (yesterday ?? today ?? tomorrow)!.currency;
  String get abbr => (yesterday ?? today ?? tomorrow)!.abbr;
  int get scale => (yesterday ?? today ?? tomorrow)!.scale;

  @override
  List<Object?> get props => [yesterday, today, tomorrow];
}

abstract class ICurrenciesService {
  List<ExchangedRatesModel> get yesterdayCurrencyRates;
  List<ExchangedRatesModel> get todayCurrencyRates;
  List<ExchangedRatesModel> get tomorrowCurrencyRates;
  Stream<List<ExchangedRatesModelPair>> get currencyRatePairs$;
  Stream<List<ExchangedRatesModelPair>> get currencyRatePairsToShow$;

  Future<ResultOf<List<ExchangedRatesModel>?>> getCurrencyRates({
    required DateTime date,
  });

  Future<Result> refresh();
}

class CurrenciesService extends GetxService implements ICurrenciesService {
  final RestClient _rest = Get.find();
  final IAppSettingsService _settingsService = Get.find();
  final IEventBus _eventBus = Get.find();

  static final _formatter = DateFormat('yyyy-MM-dd');

  final _yesterdaySubject = BehaviorSubject<List<ExchangedRatesModel>>();
  final _todaySubject = BehaviorSubject<List<ExchangedRatesModel>>();
  final _tomorrowSubject = BehaviorSubject<List<ExchangedRatesModel>>();

  @override
  List<ExchangedRatesModel> get todayCurrencyRates =>
      _yesterdaySubject.valueOrNull ?? [];

  @override
  List<ExchangedRatesModel> get yesterdayCurrencyRates =>
      _todaySubject.valueOrNull ?? [];

  @override
  List<ExchangedRatesModel> get tomorrowCurrencyRates =>
      _tomorrowSubject.valueOrNull ?? [];

  int _fetchCount = 0;

  @override
  Future onReady() async {
    super.onReady();
    await refresh();
  }

  @override
  Future<ResultOf<List<ExchangedRatesModel>?>> getCurrencyRates({
    required DateTime date,
  }) async {
    return ResultOf.tryAsync(() async {
      final res = await _rest.getCurrencyRates(date: _formatter.format(date));
      return successWith(res);
    });
  }

  @override
  Stream<List<ExchangedRatesModelPair>> get currencyRatePairs$ =>
      CombineLatestStream.combine4(
          _yesterdaySubject,
          _todaySubject,
          _tomorrowSubject,
          _settingsService.order$, (yestarday, today, tomorrow, order) {
        final list = [
          ...yesterdayCurrencyRates,
          ...todayCurrencyRates,
          ...tomorrowCurrencyRates
        ];

        final pairs = <ExchangedRatesModelPair>[];

        final groupByCurrency =
            list.groupBy<int, ExchangedRatesModel>((x) => x.id);
        for (final g in groupByCurrency.entries) {
          final dates = g.value.toList();
          pairs.add(ExchangedRatesModelPair(
            yesterday: dates.firstOrNull((x) => x.date == Date.yesterday()),
            today: g.value.firstOrNull((x) => x.date == Date.today()),
            tomorrow: g.value.firstOrNull((x) => x.date == Date.tomorrow()),
          ));
        }

        // sort
        pairs.sort((a, b) {
          final aIndex = order.indexOf(a.abbr);
          final bIndex = order.indexOf(b.abbr);
          return aIndex.compareTo(bIndex);
        });

        return pairs;
      });

  @override
  Stream<List<ExchangedRatesModelPair>> get currencyRatePairsToShow$ =>
      CombineLatestStream.combine3(
          currencyRatePairs$,
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

  @override
  Future<Result> refresh() async {
    // ! only for testing
    _fetchCount++;
    if (_fetchCount % 3 == 0) {
      _eventBus.fire(const FailFetchingEvent('Test error'));
      return fail('Test error');
    }

    // get yesterday
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayRates = await getCurrencyRates(date: yesterday);
    if (yesterdayRates.isFail) {
      _eventBus.fire(FailFetchingEvent(yesterdayRates.errorMessage));
      return yesterdayRates;
    }
    _yesterdaySubject.add(yesterdayRates.value ?? []);

    // get today
    final today = DateTime.now();
    final todayRates = await getCurrencyRates(date: today);
    if (todayRates.isFail) {
      _eventBus.fire(FailFetchingEvent(todayRates.errorMessage));
      return todayRates;
    }
    _todaySubject.add(todayRates.value ?? []);

    // get tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowRates = await getCurrencyRates(date: tomorrow);
    if (tomorrowRates.isFail) {
      _eventBus.fire(FailFetchingEvent(tomorrowRates.errorMessage));
      return tomorrowRates;
    }
    _tomorrowSubject.add(tomorrowRates.value ?? []);

    // result
    _eventBus.fire(SuccessFetchingEvent());
    return success();
  }
}
