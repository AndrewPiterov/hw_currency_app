import 'package:rxdart/subjects.dart';
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
    _currenciesToShow.add(['USD', 'EUR', 'RUB']);
    _order.add(['USD', 'EUR', 'RUB']);
  }

  @override
  Future saveSelectedCurrencies(List<String> list) async {
    _currenciesToShow.add(list);
    // TODO: cache
  }

  @override
  Future saveOrder(List<String> list) async {
    _order.add(list);
    // TODO: cache
  }
}
