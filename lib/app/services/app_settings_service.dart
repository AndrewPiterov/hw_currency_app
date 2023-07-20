import 'package:rxdart/subjects.dart';
import 'package:speed_up_get/speed_up_get.dart';

abstract class IAppSettingsService implements IAsyncInitService {
  List<String> get currencyIdToShow;
  Stream<List<String>> get currencyIdToShow$;
}

class AppSettingsService implements IAppSettingsService {
  final _currenciesToShow = BehaviorSubject<List<String>>();
  @override
  List<String> get currencyIdToShow => _currenciesToShow.valueOrNull ?? [];
  @override
  Stream<List<String>> get currencyIdToShow$ => _currenciesToShow.stream;

  @override
  Future initAsync([IAsyncInitServiceParams? params]) async {
    _currenciesToShow.add(['USD', 'EUR', 'RUB']);
  }
}
