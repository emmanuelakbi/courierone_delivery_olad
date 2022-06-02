import 'package:equatable/equatable.dart';

abstract class DeliveryProfileEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LogoutEvent extends DeliveryProfileEvent {}

class RefreshProfileEvent extends DeliveryProfileEvent {}

class ProfileToggleOnlineEvent extends DeliveryProfileEvent {}

abstract class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchOrdersActiveEvent extends OrdersEvent {
  final int page;

  FetchOrdersActiveEvent(this.page);

  @override
  List<Object> get props => [page];
}

class FetchOrdersPastEvent extends OrdersEvent {
  final int page;

  FetchOrdersPastEvent(this.page);

  @override
  List<Object> get props => [page];
}
