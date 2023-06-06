import 'package:atm_app/enum.dart';
import 'package:atm_app/models/account_info.dart';
import 'package:atm_app/screens/admin_home_screen.dart';
import 'package:atm_app/screens/customer_home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SignInScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String route_name = "sign-in-screen";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Account number",
                ),
                onChanged: (String text) {
                  if (int.tryParse(text[text.length - 1]) == null) {
                    emailController.text =
                        emailController.text.substring(0, text.length - 1);
                    emailController.selection = TextSelection.fromPosition(
                        TextPosition(offset: emailController.text.length));
                    setState(() {});
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
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
                    pinCodeController.text =
                        pinCodeController.text.substring(0, text.length - 1);
                    pinCodeController.selection = TextSelection.fromPosition(
                        TextPosition(offset: pinCodeController.text.length));
                    setState(() {});
                  }
                },
              ),
            ),
            const SizedBox(height: 100),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    var box = Hive.box<AccountInfo>("accounts");
                    for (int i = 0; i < box.length; i++) {
                      if (emailController.text == box.getAt(i)!.id &&
                          pinCodeController.text == box.getAt(i)!.pinCode) {
                        if (box.getAt(i)!.type == UserType.admin) {
                          Navigator.of(context).pushNamed(
                              AdminHomeScreen.route_name,
                              arguments: box.getAt(i)!);
                          return;
                        } else {
                          Navigator.of(context).pushNamed(
                              CustomerHomeScreen.route_name,
                              arguments: box.getAt(i)!);
                          return;
                        }
                      }
                    }
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Account not found")));
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log in",
                        style: TextStyle(color: Color.fromRGBO(11, 32, 45, 1)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
