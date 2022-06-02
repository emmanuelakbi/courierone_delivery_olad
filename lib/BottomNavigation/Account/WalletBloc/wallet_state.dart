import 'package:courieronedelivery/models/base_list_response.dart';
import 'package:courieronedelivery/models/wallet_balance.dart';
import 'package:courieronedelivery/models/wallet_transaction.dart';
import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class LoadingWalletState extends WalletState {}

class SuccessWalletBalanceState extends WalletState {
  final WalletBalance walletBalance;

  SuccessWalletBalanceState(this.walletBalance);

  @override
  List<Object> get props => [walletBalance];
}

class SuccessWalletTransactionsState extends WalletState {
  final BaseListResponse<WalletTransaction> walletTransactions;

  SuccessWalletTransactionsState(this.walletTransactions);

  @override
  List<Object> get props => [walletTransactions];
}

class FailureWalletState extends WalletState {
  final e;

  FailureWalletState(this.e);

  List<Object> get props => [e];
}
