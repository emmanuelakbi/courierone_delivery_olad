import 'package:bloc/bloc.dart';
import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/BottomNavigation/Account/AccountBloc/account_event.dart';
import 'package:courieronedelivery/BottomNavigation/Account/AccountBloc/account_state.dart';
import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:courieronedelivery/utils/helper.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {

  AccountBloc() : super(LoadingState());

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is FetchEvent) {
      yield* _mapFetchDataToState();
    }
  }

  Stream<AccountState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      UserInformation userInfo = await Helper().getUserMe();
      yield SuccessState(userInfo);
    } catch (e) {
      yield FailureState(e);
    }
  }
}
