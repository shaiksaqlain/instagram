// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/resourse/auth_methods.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  loginUser() async {
    isloading = true;
    setState(() {});
    String res = await AuthMethods().loginUser(
        userName: emailController.text, password: passwordController.text);
    if (res == "Success") {
      showSnackbar(res, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
    showSnackbar(res, context);
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                //SVG Logo
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  height: 64,
                  color: primaryColor,
                ),
                const SizedBox(height: 64),
                //Input textfield for username

                TextFieldInput(
                    textEditingController: emailController,
                    hintText: "Enter your Email",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(height: 24),
                //Input textfield for Password

                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.visiblePassword,
                  isPass: true,
                ),
                const SizedBox(height: 24),

                // button for login

                InkWell(
                  onTap: () {
                    loginUser();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        color: blueColor),
                    child: isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Log in"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Don't have an account?"),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SignupScreen()));
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          " Sign up.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
