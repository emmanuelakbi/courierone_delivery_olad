import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:equatable/equatable.dart';

abstract class CheckVerifyState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UnknownVerifyState extends CheckVerifyState {}

class LoadingVerifyState extends CheckVerifyState {}

class VerifiedState extends CheckVerifyState {
  final DeliveryProfile deliveryProfile;

  VerifiedState(this.deliveryProfile);

  @override
  List<Object> get props => [deliveryProfile];
}

class NotVerifiedState extends CheckVerifyState {
  final DeliveryProfile deliveryProfile;

  NotVerifiedState(this.deliveryProfile);

  @override
  List<Object> get props => [deliveryProfile];
}

class FailureVerifyState extends CheckVerifyState {
  final e;

  FailureVerifyState(this.e);

  @override
  List<Object> get props => [e];
}
