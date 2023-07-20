import 'package:event_bus_plus/event_bus_plus.dart';

class SuccessFetchingEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class FailFetchingEvent extends AppEvent {
  const FailFetchingEvent(this.reason);
  final String reason;
  @override
  List<Object?> get props => [reason];
}
