import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _SignUpState();
}

class _SignUpState extends State<Login> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController mailController = TextEditingController();
  late TextEditingController passController = TextEditingController();
  String verify = "Verify";

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppBar(context),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField(
                  nameController,
                  const Icon(
                    Icons.account_circle_sharp,
                    color: grey,
                    size: 30,
                  ),
                  "Username",
                  0,
                  TextInputType.emailAddress),
              const SizedBox(
                height: 30,
              ),
              textField(
                  mailController,
                  const Icon(
                    Icons.mail,
                    color: grey,
                    size: 30,
                  ),
                  "Enter your email",
                  0,
                  TextInputType.emailAddress),
              const SizedBox(
                height: 30,
              ),
              textField(
                  passController,
                  const Icon(
                    Icons.lock,
                    color: grey,
                    size: 30,
                  ),
                  "Password",
                  0,
                  TextInputType.visiblePassword),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Already have an account? Login',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: darktheme,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.only(left: 45, right: 45)),
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      verify,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
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

AppBar loginAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: theme,
    title: const Row(
      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //    Text(""),
        Text(
          'Sign up  ',
          style: TextStyle(
              fontWeight: FontWeight.w400, color: black, fontSize: 24),
        ),
      ],
    ),
  );
}

Widget textField(TextEditingController contr, Widget icon, String hintext,
    int max, TextInputType inputType) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 60,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: theme),
    margin: const EdgeInsets.symmetric(horizontal: 25),
    child: TextField(
      cursorHeight: 30,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w400, color: grey),
      controller: contr,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(bottom: -2, left: 15, right: 30, top: 10),
        border: InputBorder.none,
        hintText: hintext,
        prefixIcon: icon,
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 15, minWidth: 50),
      ),
      maxLength: max > 0 ? max : null,
      keyboardType: inputType,
    ),
  );
}
