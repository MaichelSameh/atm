import 'package:atm_app/ex/calculate_balance_ex.dart';
import 'package:atm_app/models/transaction_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/account_info.dart';

class TransactionsDetailsScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String route_name = "transactions-details-screen";
  const TransactionsDetailsScreen({super.key});

  @override
  State<TransactionsDetailsScreen> createState() =>
      _TransactionsDetailsScreenState();
}

class _TransactionsDetailsScreenState extends State<TransactionsDetailsScreen> {
  List<TransactionInfo> transactions = <TransactionInfo>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final account = ModalRoute.of(context)!.settings.arguments as AccountInfo;
    transactions = Hive.box<TransactionInfo>("transactions")
        .valuesBetween(startKey: 0)
        .where((element) => element.creatorId == account.id)
        .toList();
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Text("Your current balance is: ${transactions.getBalance} EGP"),
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 100 / 350,
                crossAxisSpacing: 15,
                mainAxisExtent: 100,
                mainAxisSpacing: 15,
              ),
              children: <Widget>[
                for (TransactionInfo transaction in transactions)
                  SelectableRegion(
                    focusNode: FocusNode(),
                    selectionControls: DesktopTextSelectionControls(),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color.fromRGBO(0, 00, 0, 0.25),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Operation type: ${transaction.type.name}"),
                          Text("Amount: ${transaction.amount} EGP"),
                          Text(
                              "Date: ${DateFormat.yMMMMEEEEd().format(transaction.createdAt)}"),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
