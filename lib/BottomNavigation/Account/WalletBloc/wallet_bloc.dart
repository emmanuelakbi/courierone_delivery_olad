import 'dart:async';
import 'package:courieronedelivery/BottomNavigation/HomeRepo/home_repository.dart';
import 'package:courieronedelivery/models/base_list_response.dart';
import 'package:courieronedelivery/models/wallet_balance.dart';
import 'package:courieronedelivery/models/wallet_transaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(LoadingWalletState());

  HomeRepository _repository = HomeRepository();
  CancelToken _cancelationToken;

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is FetchWalletEvent) {
      yield* _mapFetchWalletToState(event.pageNum);
    } else if (event is CancelWalletEvent) {
      if (_cancelationToken != null) {
        _cancelationToken.cancel("cancelled");
        _cancelationToken = null;
      }
    }
  }

  Stream<WalletState> _mapFetchWalletToState(int pageNum) async* {
    _cancelationToken = CancelToken();
    if (pageNum == null || pageNum == 1) {
      try {
        WalletBalance walletBalance =
            await _repository.getBalance(_cancelationToken);
        yield SuccessWalletBalanceState(walletBalance);
      } catch (e) {
        print(e);
        yield SuccessWalletBalanceState(WalletBalance(0));
      }
    }
    yield LoadingWalletState();
    try {
      BaseListResponse<WalletTransaction> walletTransactions =
          await _repository.walletTransactions(
              (pageNum != null && pageNum > 0) ? pageNum : 1,
              _cancelationToken);
      yield SuccessWalletTransactionsState(walletTransactions);
    } catch (e) {
      print(e);
      if (!(e is DioError && CancelToken.isCancel(e)))
        yield FailureWalletState(e);
    }
  }
}
