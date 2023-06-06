import 'package:atm_app/enum.dart';
import 'package:atm_app/models/transaction_info.dart';

extension CalculateBalance on List<TransactionInfo> {
  double get getBalance {
    double balance = 0;
    for (TransactionInfo transaction in this) {
      switch (transaction.type) {
        case TransactionType.fund:
          balance += transaction.amount;
          break;
        case TransactionType.withdraw:
          balance -= transaction.amount;
          break;
      }
    }
    return balance;
  }
}
