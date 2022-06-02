import 'package:equatable/equatable.dart';

class UpdateProfileEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class PutUpdateProfileEvent extends UpdateProfileEvent {
  final String name, imageUrl;

  PutUpdateProfileEvent(this.name, this.imageUrl);

  @override
  List<Object> get props => [name, imageUrl];
}
