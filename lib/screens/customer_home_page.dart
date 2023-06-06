import 'package:atm_app/enum.dart';
import 'package:atm_app/ex/calculate_balance_ex.dart';
import 'package:atm_app/id_generator.dart';
import 'package:atm_app/models/transaction_info.dart';
import 'package:atm_app/screens/transactions_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/account_info.dart';

class CustomerHomeScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String route_name = "customer-home-screen";
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  bool hadResetPin = false;

  final TextEditingController pinCodeController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ModalRoute.of(context)!.settings.arguments as AccountInfo;
    return Scaffold(
      body: account.pinCode.isEmpty && !hadResetPin
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        controller: pinCodeController,
                        decoration: const InputDecoration(
                          hintText: "Your pin code",
                        ),
                        onChanged: (String text) {
                          if (int.tryParse(text[text.length - 1]) == null ||
                              text.length > 4) {
                            pinCodeController.text = pinCodeController.text
                                .substring(0, text.length - 1);
                            pinCodeController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: pinCodeController.text.length));
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          if (pinCodeController.text.length == 4) {
                            var box = Hive.box<AccountInfo>("accounts");
                            for (int i = 0; i < box.length; i++) {
                              if (account.id == box.getAt(i)!.id) {
                                box.putAt(
                                    i,
                                    account.copyWith(
                                        pinCode: pinCodeController.text));
                              }
                            }
                            hadResetPin = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Account PIN reset successfully")));
                            setState(() {});
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Set PIN",
                                style: TextStyle(
                                    color: Color.fromRGBO(11, 32, 45, 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              final TextEditingController amountController =
                                  TextEditingController();
                              return Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: SelectableRegion(
                                  focusNode: FocusNode(),
                                  selectionControls:
                                      DesktopTextSelectionControls(),
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 25),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(height: 24),
                                          Text(
                                            "Enter the amount you want to withdraw",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 300),
                                            child: TextFormField(
                                              controller: amountController,
                                              decoration: const InputDecoration(
                                                hintText: "Amount",
                                              ),
                                              onChanged: (String text) {
                                                if (int.tryParse(text[
                                                        text.length - 1]) ==
                                                    null) {
                                                  pinCodeController.text =
                                                      pinCodeController.text
                                                          .substring(0,
                                                              text.length - 1);
                                                  pinCodeController.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  pinCodeController
                                                                      .text
                                                                      .length));
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed: () {
                                              if ((int.tryParse(amountController
                                                          .text) ??
                                                      0) >
                                                  0) {
                                                var box =
                                                    Hive.box<TransactionInfo>(
                                                        "transactions");
                                                var transactions = box
                                                    .valuesBetween(startKey: 0)
                                                    .where((element) =>
                                                        element.id ==
                                                        account.id);
                                                if (int.parse(
                                                        amountController.text) >
                                                    transactions
                                                        .toList()
                                                        .getBalance) {
                                                  ScaffoldMessenger.of(_)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Account balance insufficient"),
                                                    ),
                                                  );
                                                  return;
                                                } else {
                                                  box.add(
                                                    TransactionInfo(
                                                      id: idGenerator(),
                                                      createdAt: DateTime.now(),
                                                      amount: double.parse(
                                                          amountController
                                                              .text),
                                                      creatorId: account.id,
                                                      type: TransactionType
                                                          .withdraw,
                                                    ),
                                                  );
                                                }
                                                Navigator.of(_).pop();
                                              } else {
                                                Navigator.of(_).pop();
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 50),
                                              child: Text(
                                                "Okay",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                textScaleFactor: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Withdraw",
                                style: TextStyle(
                                    color: Color.fromRGBO(11, 32, 45, 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              final TextEditingController amountController =
                                  TextEditingController();
                              return Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: SelectableRegion(
                                  focusNode: FocusNode(),
                                  selectionControls:
                                      DesktopTextSelectionControls(),
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 25),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(height: 24),
                                          Text(
                                            "Enter the amount you want to withdraw",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 300),
                                            child: TextFormField(
                                              controller: amountController,
                                              decoration: const InputDecoration(
                                                hintText: "Amount",
                                              ),
                                              onChanged: (String text) {
                                                if (int.tryParse(text[
                                                        text.length - 1]) ==
                                                    null) {
                                                  pinCodeController.text =
                                                      pinCodeController.text
                                                          .substring(0,
                                                              text.length - 1);
                                                  pinCodeController.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  pinCodeController
                                                                      .text
                                                                      .length));
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed: () {
                                              if ((int.tryParse(amountController
                                                          .text) ??
                                                      0) >
                                                  0) {
                                                var box =
                                                    Hive.box<TransactionInfo>(
                                                        "transactions");
                                                box.add(
                                                  TransactionInfo(
                                                    id: idGenerator(),
                                                    createdAt: DateTime.now(),
                                                    amount: double.parse(
                                                        amountController.text),
                                                    creatorId: account.id,
                                                    type: TransactionType.fund,
                                                  ),
                                                );
                                                Navigator.of(_).pop();
                                              } else {
                                                Navigator.of(_).pop();
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 50),
                                              child: Text(
                                                "Okay",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                textScaleFactor: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Fund",
                                style: TextStyle(
                                    color: Color.fromRGBO(11, 32, 45, 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          var box = Hive.box<TransactionInfo>("transactions");
                          var transactions = box
                              .valuesBetween(startKey: 0)
                              .where(
                                  (element) => element.creatorId == account.id);
                          showDialog(
                            context: context,
                            builder: (_) => SelectableRegion(
                              focusNode: FocusNode(),
                              selectionControls: DesktopTextSelectionControls(),
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 25),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 24),
                                      Text(
                                        "Account Information",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Your account balance is: ${transactions.toList().getBalance} EGP",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(_).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 50),
                                          child: Text(
                                            "Okay",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(_).pop();
                                          Navigator.of(context).pushNamed(
                                            TransactionsDetailsScreen
                                                .route_name,
                                            arguments: account,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Text(
                                            "View transactions",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Info",
                                style: TextStyle(
                                    color: Color.fromRGBO(11, 32, 45, 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
