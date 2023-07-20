import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_up_get/speed_up_get.dart';

abstract class IAppSettingsService implements IAsyncInitService {
  List<String> get currencyIdToShow;
  Stream<List<String>> get currencyIdToShow$;

  List<String> get order;
  Stream<List<String>> get order$;

  Future saveSelectedCurrencies(List<String> list);
  Future saveOrder(List<String> list);
}

class AppSettingsService implements IAppSettingsService {
  final SharedPreferences _pref = Get.find();

  static const _keySelectedCurrencies = 'selected_currencies';
  static const _keyCurrenciesOrder = 'currencies_order';

  final _currenciesToShow = BehaviorSubject<List<String>>();
  @override
  List<String> get currencyIdToShow => _currenciesToShow.valueOrNull ?? [];
  @override
  Stream<List<String>> get currencyIdToShow$ =>
      _currenciesToShow.asBroadcastStream();

  final _order = BehaviorSubject<List<String>>();
  @override
  List<String> get order => _order.valueOrNull ?? [];
  @override
  Stream<List<String>> get order$ => _order.asBroadcastStream();

  @override
  Future initAsync([IAsyncInitServiceParams? params]) async {
    // get Selected from cache
    final selectedCurrencies = _pref.getString(_keySelectedCurrencies);
    final selectedList =
        selectedCurrencies?.split(',') ?? ['USD', 'EUR', 'RUB'];
    _currenciesToShow.add(selectedList);

    // get Order from cache
    final order = _pref.getString(_keyCurrenciesOrder);
    final orderList = order?.split(',') ?? [];
    _order.add(orderList);
  }

  @override
  Future saveSelectedCurrencies(List<String> list) async {
    _currenciesToShow.add(list);
    // cache
    await _pref.setString(_keySelectedCurrencies, list.join(','));
  }

  @override
  Future saveOrder(List<String> list) async {
    _order.add(list);
    // cache
    await _pref.setString(_keyCurrenciesOrder, list.join(','));
  }
}
