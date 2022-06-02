import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class FetchWalletEvent extends WalletEvent {
  final int pageNum;

  FetchWalletEvent(this.pageNum);

  @override
  List<Object> get props => [pageNum];
}

class CancelWalletEvent extends WalletEvent {
  @override
  List<Object> get props => [];
}
