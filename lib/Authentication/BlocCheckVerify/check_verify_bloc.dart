import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'check_verify_event.dart';
import 'check_verify_state.dart';

class CheckVerifyBloc extends Bloc<CheckVerifyEvent, CheckVerifyState> {
  CheckVerifyBloc() : super(UnknownVerifyState());

  AuthRepo _authRepository = AuthRepo();

  @override
  Stream<CheckVerifyState> mapEventToState(CheckVerifyEvent event) async* {
    if (event is GetProfileEvent) {
      yield* _mapGetProfileToState();
    }
  }

  Stream<CheckVerifyState> _mapGetProfileToState() async* {
    yield LoadingVerifyState();
    try {
      DeliveryProfile deliveryProfile =
          await _authRepository.getDeliveryUserByToken();
      await Helper().saveProfileMe(deliveryProfile);
      yield VerifiedState(deliveryProfile);

      ///If delivery profile contains some extra information that needs to be verified before entering the app, follow checkup in following manner.

      // if (deliveryProfile.meta != null) {
      //   await Helper().saveProfileMe(deliveryProfile);
      //   yield VerifiedState(deliveryProfile);
      // } else {
      //   yield NotVerifiedState(deliveryProfile);
      // }
    } catch (e) {
      yield FailureVerifyState(e);
    }
  }
}
