import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/models.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://api.nbrb.by/exrates/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('rates')
  Future<List<ExchangedRatesModel>> getCurrencyRates({
    @Query('ondate') required String date,
    @Query('periodicity') int periodicity = 0,
  });
}
