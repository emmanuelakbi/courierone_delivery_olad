import 'package:equatable/equatable.dart';

class MyProfileEvent extends Equatable{
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchMyProfileEvent extends MyProfileEvent{}