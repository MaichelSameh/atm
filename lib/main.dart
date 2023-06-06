import 'package:atm_app/adaptors/account_adaptor.dart';
import 'package:atm_app/adaptors/transaction_adaptor.dart';
import 'package:atm_app/enum.dart';
import 'package:atm_app/models/account_info.dart';
import 'package:atm_app/models/transaction_info.dart';
import 'package:atm_app/screens/admin_home_screen.dart';
import 'package:atm_app/screens/customer_home_page.dart';
import 'package:atm_app/screens/home_screen.dart';
import 'package:atm_app/screens/sign_in_screen.dart';
import 'package:atm_app/screens/splash_screen.dart';
import 'package:atm_app/screens/transactions_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'id_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await path_provider.getApplicationSupportDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(AccountAdaptor());
  Hive.registerAdapter(TransactionAdaptor());
  await Hive.openBox<AccountInfo>("accounts").then((box) async {
    if (box.isEmpty) {
      box.add(
        AccountInfo(
          email: "maichelsameh622@gmail.com",
          id: idGenerator(),
          name: "Maichel Sameh",
          personalIdUrl: "",
          phoneCode: "+20",
          pinCode: "1234",
          phoneNumber: "1226233678",
          profileUrl: "",
          type: UserType.admin,
          createdAt: DateTime.now(),
          creatorId: "",
        ),
      );
    }
    for (int i = 0; i < box.length; i++) {
      print(box.getAt(i));
    }
  });
  await Hive.openBox<TransactionInfo>("transactions");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        SplashScreen.route_name: (_) => const SplashScreen(),
        HomeScreen.route_name: (_) => const HomeScreen(),
        SignInScreen.route_name: (_) => const SignInScreen(),
        CustomerHomeScreen.route_name: (_) => const CustomerHomeScreen(),
        AdminHomeScreen.route_name: (_) => const AdminHomeScreen(),
        TransactionsDetailsScreen.route_name: (_) =>
            const TransactionsDetailsScreen(),
      },
      initialRoute: SplashScreen.route_name,
    );
  }
}
