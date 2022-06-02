import 'package:courieronedelivery/models/User/my_profile_response.dart';
import 'package:equatable/equatable.dart';

class MyProfileState extends Equatable{
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingMyProfileState extends MyProfileState{}

class SuccessMyProfileState extends MyProfileState{
    final MyProfileResponse myProfile;

  SuccessMyProfileState(this.myProfile);
  @override
  List<Object> get props => [myProfile];
}

class FailureMyProfileState extends MyProfileState{
  final e;

  FailureMyProfileState(this.e);

  @override
  List<Object> get props => [e];
}