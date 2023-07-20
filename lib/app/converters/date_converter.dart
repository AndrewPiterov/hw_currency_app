import 'package:date_time/date_time.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class DateConverter implements JsonConverter<Date, String> {
  const DateConverter();

  static final _formatter = DateFormat('yyyy-MM-dd');

  @override
  Date fromJson(String timestamp) {
    return DateTime.parse(timestamp).date;
  }

  @override
  String toJson(Date date) {
    return _formatter.format(date.asDateTime);
  }
}
