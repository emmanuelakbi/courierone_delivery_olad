import 'package:courieronedelivery/Authentication/AuthRepo/auth_repository.dart';
import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_event.dart';
import 'package:courieronedelivery/BottomNavigation/Account/UpdateProfileBloc/update_profile_state.dart';
import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateUserMeState> {
  UpdateProfileBloc() : super(InitialUpdateUserMeState());

  AuthRepo repo = AuthRepo();

  @override
  Stream<UpdateUserMeState> mapEventToState(UpdateProfileEvent event) async* {
    if (event is PutUpdateProfileEvent) {
      yield* _mapPutUpdateProfileEventToState(event.name, event.imageUrl);
    }
  }

  Stream<UpdateUserMeState> _mapPutUpdateProfileEventToState(
      String name, String imageUrl) async* {
    yield LoadingUpdateUserMeState();
    try {
      UserInformation updatedUser =
          await repo.updateUser({"name": name, "image_url": imageUrl});
      yield SuccessUpdateUserMeState(updatedUser);
    } catch (e) {
      yield FailureUpdateUserMeState(e);
    }
  }
}
