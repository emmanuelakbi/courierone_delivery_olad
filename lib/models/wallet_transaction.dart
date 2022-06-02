import 'package:courieronedelivery/models/wallet_transaction_meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:courieronedelivery/models/Auth/Responses/user_info.dart';

part 'wallet_transaction.g.dart';

@JsonSerializable()
class WalletTransaction {
  final int id;
  final double amount;
  final String type; //withdraw or deposit
  final WalletTransactionMeta meta;
  final UserInformation user;
  final String created_at;

  WalletTransaction(
      this.id, this.amount, this.type, this.meta, this.user, this.created_at);

  static walletTransactionLabel(String label) =>
      WalletTransaction(-1, 0, label, null, null, null);

  /// A necessary factory constructor for creating a new WalletTransaction instance
  /// from a map. Pass the map to the generated `_$WalletTransactionFromJson()` constructor.
  /// The constructor is named after the source class, in this case, WalletTransaction.
  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$WalletTransactionToJson`.
  Map<String, dynamic> toJson() => _$WalletTransactionToJson(this);
}
