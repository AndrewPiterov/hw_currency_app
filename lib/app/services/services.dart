import 'package:currency_app/app/api/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:speed_up_get/speed_up_get.dart';

import '../app.dart';

export './app_settings_service.dart';
export './exchanged_service.dart';

Future initAsync() async {
  Get.put(AppRouter());
  Get.put(Dio());
  Get.put(RestClient(Get.find<Dio>()));
  Get.put<IExchangedService>(ExchangedService());
  await registerServiceAsync<IAppSettingsService>(AppSettingsService());
}
