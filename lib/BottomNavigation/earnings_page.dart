import 'package:courieronedelivery/Locale/locales.dart';
import 'package:courieronedelivery/Theme/style.dart';
import 'package:courieronedelivery/components/error_final_widget.dart';
import 'package:courieronedelivery/models/wallet_transaction.dart';
import 'package:courieronedelivery/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courieronedelivery/BottomNavigation/Account/WalletBloc/wallet_bloc.dart';
import 'package:courieronedelivery/BottomNavigation/Account/WalletBloc/wallet_event.dart';
import 'package:courieronedelivery/BottomNavigation/Account/WalletBloc/wallet_state.dart';

class EarningsPage extends StatelessWidget {
  final GlobalKey<EarningsBodyState> earningsBodyKey;

  EarningsPage(this.earningsBodyKey);

  @override
  Widget build(BuildContext context) => BlocProvider<WalletBloc>(
      create: (context) => WalletBloc()..add(FetchWalletEvent(1)),
      child: EarningsBody(earningsBodyKey));
}

class EarningsBody extends StatefulWidget {
  EarningsBody(Key key) : super(key: key);

  @override
  EarningsBodyState createState() => EarningsBodyState();
}

class EarningsBodyState extends State<EarningsBody> {
  List<WalletTransaction> _transactions = [];
  String _balance = "0.00";
  int _currentPage = 1;
  bool _isLoading = true;
  bool _allDone = false;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    var currencyIcon = Helper().getSettingValue("currency_icon");

    _balance = "$currencyIcon 0";

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is SuccessWalletBalanceState) {
          _balance =
              "$currencyIcon ${state.walletBalance.balance.toStringAsFixed(2)}";
        }
        _isLoading = state is LoadingWalletState;
        if (state is SuccessWalletTransactionsState) {
          _currentPage = state.walletTransactions.meta.current_page;
          _allDone = state.walletTransactions.meta.current_page ==
              state.walletTransactions.meta.last_page;
          if (state.walletTransactions.meta.current_page == 1) {
            _transactions = state.walletTransactions.data;
            _transactions.insert(
                0, WalletTransaction.walletTransactionLabel("recentTrans"));
          } else {
            _transactions.addAll(state.walletTransactions.data);
          }
        }
        setState(() {});
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                locale.wallet,
                textAlign: TextAlign.center,
                style: theme.textTheme.headline5,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _balance,
                textAlign: TextAlign.center,
                style: theme.textTheme.headline4.copyWith(
                    color: theme.backgroundColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  height: mediaQuery.size.height * 0.67,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: borderRadius,
                  ),
                  child: _transactions != null && _transactions.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          shrinkWrap: true,
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            if (_transactions.isNotEmpty &&
                                index == _transactions.length - 1) {
                              if (!_allDone && !_isLoading) {
                                BlocProvider.of<WalletBloc>(context)
                                  ..add(FetchWalletEvent(_currentPage + 1));
                              }
                            }
                            var _trans = _transactions[index];
                            return _trans.id < 0
                                ? Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      locale.getTranslationOf(_trans.type),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [boxShadow],
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: theme.backgroundColor,
                                    ),
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: Image.asset(
                                              _trans.meta?.source_meta_courier_type !=
                                                      null
                                                  ? _trans.meta
                                                              .source_meta_courier_type ==
                                                          'grocery'
                                                      ? 'images/home3.png'
                                                      : _trans.meta
                                                                  .source_meta_courier_type ==
                                                              'food'
                                                          ? 'images/home2.png'
                                                          : 'images/home1.png'
                                                  : 'images/home1.png',
                                              scale: 4.2),
                                        ),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: _transactions[index]
                                                      .meta
                                                      .description +
                                                  '\n',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: locale.getTranslationOf(
                                                      "transaction") +
                                                  " #${_transactions[index].id}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: theme.hintColor),
                                            ),
                                          ]),
                                        ),
                                        Spacer(),
                                        RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  "$currencyIcon${(_transactions[index].meta.source_amount == null ? "0" : _transactions[index].meta.source_amount.toStringAsFixed(2))}\n",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: theme.hintColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: _transactions[index]
                                                  .meta
                                                  .source_payment_type,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        )
                      : _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.yellow[600]),
                              ),
                            )
                          : ErrorFinalWidget.errorWithRetry(
                              context,
                              AppLocalizations.of(context)
                                  .getTranslationOf("empty_transactions"),
                              AppLocalizations.of(context)
                                  .getTranslationOf("refresh"),
                              (context) => refreshWallet(),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refreshWallet() {
    _isLoading = true;
    _allDone = false;
    BlocProvider.of<WalletBloc>(context)..add(FetchWalletEvent(1));
  }

  void cancelRequests() {
    BlocProvider.of<WalletBloc>(context)..add(CancelWalletEvent());
  }
}
