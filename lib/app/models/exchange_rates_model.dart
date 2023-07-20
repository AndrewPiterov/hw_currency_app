import 'package:date_time/date_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/date_converter.dart';

part 'exchange_rates_model.freezed.dart';
part 'exchange_rates_model.g.dart';

@freezed
class ExchangedRatesModel with _$ExchangedRatesModel {
  factory ExchangedRatesModel({
    @JsonKey(name: 'Cur_ID') required int id,
    @JsonKey(name: 'Cur_Name') required String currency,
    @JsonKey(name: 'Cur_Abbreviation') required String abbr,
    @JsonKey(name: 'Cur_OfficialRate') required double rates,
    @JsonKey(name: 'Cur_Scale') required int scale,
    @JsonKey(name: 'Date') @DateConverter() required Date date,
  }) = _ExchangedRatesModel;

  factory ExchangedRatesModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangedRatesModelFromJson(json);
}
