import 'dart:async';
import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/BottomNavigation/map_repository.dart';
import 'package:courieronedelivery/models/DeliveryRequest/Get/delivery_profile.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'map_event.dart';
import 'map_state.dart';

class DeliveryProfileBloc
    extends Bloc<DeliveryProfileEvent, DeliveryProfileState> {
  AuthRepo _authRepository = AuthRepo();
  MapRepository _mapRepository = MapRepository();
  StreamSubscription _locationSubscription;
  DeliveryProfile _deliveryProfileLatest;

  DeliveryProfileBloc() : super(DeliveryProfileInitialState());

  @override
  Stream<DeliveryProfileState> mapEventToState(
      DeliveryProfileEvent event) async* {
    switch (event.runtimeType) {
      case RefreshProfileEvent:
        yield* _mapFetchProfileEvent();
        break;
      case ProfileToggleOnlineEvent:
        yield* _mapToggleProfileEvent();
        break;
      case LogoutEvent:
        yield* _mapLogoutEvent();
        break;
    }
  }

  Stream<DeliveryProfileState> _mapLogoutEvent() async* {
    yield DeliveryProfileLoadingState();
    try {
      if (_deliveryProfileLatest == null)
        _deliveryProfileLatest = await Helper().getProfileMe();
      if (_deliveryProfileLatest != null) {
        DeliveryProfile deliveryProfile = await _authRepository
            .setDeliveryUser(_deliveryProfileLatest.id, {"is_online": "0"});
        await onProfileInit(deliveryProfile);
        yield RefreshedProfileState(deliveryProfile);
      }
      await _authRepository.logout();
    } catch (e) {
      print("_mapLogoutEvent: $e");
    }
    yield DeliveryProfileLoggedOutState();
  }

  Stream<DeliveryProfileState> _mapFetchProfileEvent() async* {
    try {
      DeliveryProfile deliveryProfile =
          await _authRepository.getDeliveryUserByToken();
      yield RefreshedProfileState(deliveryProfile);
      DeliveryProfile deliveryProfileFreshCheck = await Helper().getProfileMe();
      bool freshProfile = deliveryProfileFreshCheck == null ||
          deliveryProfileFreshCheck.isFresh == true;
      if (freshProfile) {
        deliveryProfile = await _authRepository
            .setDeliveryUser(deliveryProfile.id, {"is_online": "1"});
        await onProfileInit(deliveryProfile);
        yield RefreshedProfileState(deliveryProfile);
      } else {
        await onProfileInit(deliveryProfile);
      }
    } catch (e) {
      //check for 401 and logout
      print(e);
      yield DeliveryProfileErrorState(
          "Something went wrong", "something_wrong");
    }
  }

  Stream<DeliveryProfileState> _mapToggleProfileEvent() async* {
    yield DeliveryProfileLoadingState();
    try {
      DeliveryProfile deliveryProfile = await Helper().getProfileMe();
      deliveryProfile = await _authRepository.setDeliveryUser(
          deliveryProfile.id,
          {"is_online": deliveryProfile.isOnline == 1 ? "0" : "1"});
      await onProfileInit(deliveryProfile);
      yield RefreshedProfileState(deliveryProfile);
    } catch (e) {
      print(e);
      yield DeliveryProfileErrorState(
          "Something went wrong", "something_wrong");
    }
  }

  onProfileInit(DeliveryProfile deliveryProfile) async {
    _deliveryProfileLatest = deliveryProfile;
    await Helper().saveProfileMe(deliveryProfile);
    if (deliveryProfile.isOnline == 1) {
      if (_locationSubscription == null) {
        _locationSubscription =
            _mapRepository.getCurrentLocation().listen((position) async {
          DeliveryProfile deliveryProfileUpDated =
              await _authRepository.setDeliveryUser(_deliveryProfileLatest.id, {
            "latitude": position.latitude.toString(),
            "longitude": position.longitude.toString(),
            // "latitude": "28.7041",
            // "longitude": "77.1025",
          });
          await _authRepository
              .updateDeliveryLocation(_deliveryProfileLatest.id, {
            "latitude": position.latitude.toString(),
            "longitude": position.longitude.toString(),
            // "latitude": "28.7041",
            // "longitude": "77.1025",
          });
          await Helper().saveProfileMe(deliveryProfileUpDated);
        });
      }
    } else {
      if (_locationSubscription != null) {
        await _locationSubscription.cancel();
        _locationSubscription = null;
      }
    }
  }

  @override
  Future<void> close() {
    if (_locationSubscription != null) {
      _locationSubscription
          .cancel()
          .then((value) => _locationSubscription = null);
    }
    return super.close();
  }
}
