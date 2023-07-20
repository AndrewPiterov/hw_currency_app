import 'package:currency_app/app/api/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_up_get/speed_up_get.dart';

import '../app.dart';

export './app_settings_service.dart';
export 'currencies_service.dart';

Future initAsync() async {
  final pref = await SharedPreferences.getInstance();
  Get.put(pref);
  Get.put<IEventBus>(EventBus());
  Get.put(AppRouter());
  Get.put(Dio());
  Get.put(RestClient(Get.find<Dio>()));
  await registerServiceAsync<IAppSettingsService>(AppSettingsService());
  Get.put<ICurrenciesService>(CurrenciesService());
}
