import 'package:atm_app/validators.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../enum.dart';
import '../id_generator.dart';
import '../models/account_info.dart';

class AdminHomeScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String route_name = "admin-home-screen";
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Country? country;

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
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Full name",
                    ),
                    validator: Validators.validateName,
                  ),
                ),
                const SizedBox(height: 50),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email-Address",
                    ),
                    validator: Validators.validateEmail,
                  ),
                ),
                const SizedBox(height: 50),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: "Mobile Number",
                    ),
                    onChanged: (String text) {
                      if (int.tryParse(text[text.length - 1]) == null) {
                        phoneController.text =
                            phoneController.text.substring(0, text.length - 1);
                        phoneController.selection = TextSelection.fromPosition(
                            TextPosition(offset: emailController.text.length));
                        setState(() {});
                      }
                    },
                    validator: Validators.validatePhoneNumber,
                  ),
                ),
                const SizedBox(height: 100),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        var box = Hive.box<AccountInfo>("accounts");
                        String accountNumber = idGenerator();
                        box.add(
                          AccountInfo(
                            email: emailController.text,
                            id: accountNumber,
                            name: nameController.text,
                            personalIdUrl: "",
                            phoneCode: "+20",
                            pinCode: "",
                            phoneNumber: phoneController.text.startsWith("0")
                                ? phoneController.text.substring(1)
                                : phoneController.text,
                            profileUrl: "",
                            type: UserType.customer,
                            createdAt: DateTime.now(),
                            creatorId: account.id,
                          ),
                        );
                        emailController.clear();
                        nameController.clear();
                        phoneController.clear();
                        showDialog(
                          context: context,
                          builder: (_) => SelectableRegion(
                            focusNode: FocusNode(),
                            selectionControls: DesktopTextSelectionControls(),
                            child: Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 25),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(height: 24),
                                    Text(
                                      "Account created",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "The customer account number is: $accountNumber",
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create account",
                            style:
                                TextStyle(color: Color.fromRGBO(11, 32, 45, 1)),
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
      ),
    );
  }
}
