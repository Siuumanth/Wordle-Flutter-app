import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
//import 'package:wordle/constants/theme.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/screens/login/SignUp.dart';
//import 'package:wordle/screens/login/SignUp.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'package:wordle/wrapper.dart';
import 'package:wordle/util/ShowNoti.dart';
import 'forgotPass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  // late TextEditingController nameController = TextEditingController();
  late TextEditingController mailController = TextEditingController();
  late TextEditingController passController = TextEditingController();
  String verify = "Verify";

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passController.dispose();
    //   nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    Color textColor = Theme.of(context).textTheme.titleMedium!.color!;
    return Scaffold(
      appBar: loginAppBar(context),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                const SizedBox(
                  height: 30,
                ),
                textFieldLogin(
                    mailController,
                    Icon(
                      Icons.mail,
                      color: textColor,
                      size: 30,
                    ),
                    "Enter your email",
                    0,
                    TextInputType.emailAddress,
                    false,
                    context),
                const SizedBox(
                  height: 30,
                ),
                textFieldLogin(
                    passController,
                    Icon(
                      Icons.lock,
                      color: textColor,
                      size: 30,
                    ),
                    "Password",
                    0,
                    TextInputType.visiblePassword,
                    true,
                    context),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: Text(
                        "Forgot password     ",
                        style:
                            TextStyle(color: textColor, fontSize: screenH / 50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dont have an account?',
                        style: TextStyle(fontSize: 17, color: textColor),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUp()));
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Theme.of(context).unselectedWidgetColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).unselectedWidgetColor,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.only(left: 20, right: 20)),
                    onPressed: () {
                      try {
                        loginuser();
                      } catch (e) {
                        showTopMessage(
                            context, "Invalid email format", red, white);
                      }
                    },
                    child: const Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    goToHome(context);
                  },
                  child: Text(
                    "Continue as guest",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).unselectedWidgetColor,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).unselectedWidgetColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginuser() async {
    final user = await _auth.loginUserWithEmailPassword(
      mailController.text,
      passController.text,
    );

    if (user != null) {
      print("User logged in successfully");
      showTopMessage(context, "Successfully logged in", darktheme, white);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Wrapper()),
        (Route<dynamic> route) => false, // Removes all previous routes
      );
      showTopMessage(context, "Successfully logged in", darkertheme, white);
    }
  }
}

void goToHome(context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
    (Route<dynamic> route) => false, // Removes all previous routes
  );
}

AppBar loginAppBar(BuildContext context) {
  return AppBar(
    iconTheme: Theme.of(context).iconTheme,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: const Row(
      children: [
        Text(
          ' ',
          style: TextStyle(
              fontWeight: FontWeight.w400, color: black, fontSize: 24),
        ),
      ],
    ),
  );
}

Widget textFieldLogin(TextEditingController contr, Widget icon, String hintext,
    int max, TextInputType inputType, bool isPassword, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: theme, width: 2),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 25),
    child: TextField(
      cursorHeight: 30,

      style: TextStyle(
        fontSize: screenHeight / 45,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).textTheme.titleMedium!.color
            : const Color.fromARGB(210, 225, 225, 225),
      ),
      controller: contr,
      obscureText: isPassword, // Hides text for password fields
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(bottom: -2, left: 15, right: 30, top: 10),
        border: InputBorder.none,
        hintText: hintext,
        hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).textTheme.titleMedium!.color
                : const Color.fromARGB(211, 212, 212, 212)),
        prefixIcon: icon,
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 15, minWidth: 50),
      ),
      maxLength: hintext == "Username" ? 10 : null,
      keyboardType: isPassword ? TextInputType.visiblePassword : inputType,
    ),
  );
}
