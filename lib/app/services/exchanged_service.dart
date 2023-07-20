import 'package:date_time/date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_result/fluent_result.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:speed_up/speed_up.dart';

import '../api/rest_client.dart';
import '../models/models.dart';

class ExchangedRatesModelPair extends Equatable {
  const ExchangedRatesModelPair({
    this.yesterday,
    this.today,
    this.tomorrow,
  });

  final ExchangedRatesModel? yesterday;
  final ExchangedRatesModel? today;
  final ExchangedRatesModel? tomorrow;

  String get currency => (yesterday ?? today ?? tomorrow)!.currency;
  String get abbr => (yesterday ?? today ?? tomorrow)!.abbr;
  int get scale => (yesterday ?? today ?? tomorrow)!.scale;

  @override
  List<Object?> get props => [yesterday, today, tomorrow];
}

abstract class IExchangedService {
  List<ExchangedRatesModel> get yesterdayCurrencyRates;
  List<ExchangedRatesModel> get todayCurrencyRates;
  List<ExchangedRatesModel> get tomorrowCurrencyRates;

  Stream<List<ExchangedRatesModelPair>> get currencyRatePairs$;

  Future<ResultOf<List<ExchangedRatesModel>?>> getCurrencyRates({
    required DateTime date,
  });
}

class ExchangedService extends GetxService implements IExchangedService {
  final RestClient _rest = Get.find();

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

  @override
  Future onReady() async {
    super.onReady();

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayRates = await getCurrencyRates(date: yesterday);
    _yesterdaySubject.add(yesterdayRates.value ?? []);

    final today = DateTime.now();
    final todayRates = await getCurrencyRates(date: today);
    _todaySubject.add(todayRates.value ?? []);

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowRates = await getCurrencyRates(date: tomorrow);
    _tomorrowSubject.add(tomorrowRates.value ?? []);
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
      CombineLatestStream.combine3(
          _yesterdaySubject, _todaySubject, _tomorrowSubject,
          (yestarday, today, tomorrow) {
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

        return pairs;
      });
}
