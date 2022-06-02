import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/config/app_config.dart';
import 'package:courieronedelivery/config/one_signal_config.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepo _userRepository = AuthRepo();

  AuthBloc() : super(Uninitialized());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AuthChanged) {
      if (event.clearAuth ?? false) await _userRepository.logout();
      // if (event.restart ?? false)
      //   yield RestartState();
      // else
      yield* _yieldAuthenticationState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    bool initialised = await Helper().init();
    if (initialised) {
      await _userRepository.getSettings();
      if (!(await Helper().isLanguageSelectionPromted()) &&
          AppConfig.isDemoMode) {
        await Helper().setLanguageSelectionPromted();
        yield Initialized();
      } else {
        yield* _yieldAuthenticationState();
      }
    } else {
      print("something went wrong");
      yield Uninitialized();
    }
  }

  Stream<AuthState> _yieldAuthenticationState() async* {
    if (await Helper().getUserMe() != null) {
      yield Authenticated();
      registerOneSignalPlayerId();
    } else {
      yield Unauthenticated();
    }
  }

  registerOneSignalPlayerId() async {
    String playerId = await OneSignalConfig.getPlayerId();
    if (playerId != null) {
      try {
        await _userRepository.updateUserNotification(playerId);
      } catch (e) {
        print(e);
      }
    }
  }
}
