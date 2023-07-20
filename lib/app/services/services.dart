import 'package:currency_app/app/api/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../app.dart';
import 'exchanged_service.dart';

Future initAsync() async {
  Get.put(AppRouter());
  Get.put(Dio());
  Get.put(RestClient(Get.find<Dio>()));
  Get.put<IExchangedService>(ExchangedService());
}
