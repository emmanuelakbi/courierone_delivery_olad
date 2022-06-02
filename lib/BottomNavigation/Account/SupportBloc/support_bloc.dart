import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/BottomNavigation/Account/SupportBloc/support_event.dart';
import 'package:courieronedelivery/BottomNavigation/Account/SupportBloc/support_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  AuthRepo _repository = AuthRepo();

  SupportBloc() : super(InitialSupportState());

  @override
  Stream<SupportState> mapEventToState(SupportEvent event) async* {
    if (event is SupportEvent) {
      yield* _mapPostSupportToState(event.message);
    }
  }

  Stream<SupportState> _mapPostSupportToState(String message) async* {
    yield LoadingSupportState();
    try {
      await _repository.support(message);
      yield SuccessSupportState();
    } catch (e) {
      throw FailureSupportState(e);
    }
  }
}
