// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resourse/auth_methods.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = false;
  Uint8List? image;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

// method to pick the image form gallary
  void selectImage() async {
    Uint8List imagePicked = await picImage(ImageSource.gallery, context);
    setState(() {
      image = imagePicked;
    });
  }

// method calling for authenticate  the user
  signupUser() async {
    isLoading = true;
    setState(() {});
    if (emailController.text.isNotEmpty ||
        passwordController.text.isNotEmpty ||
        usernameController.text.isNotEmpty ||
        bioController.text.isNotEmpty ||
        image != null) {
      String res = await authMethods.signUpMethod(
          email: emailController.text,
          password: passwordController.text,
          bio: bioController.text,
          userName: usernameController.text,
          file: image!);
      showSnackbar(res, context);

      isLoading = false;
      setState(() {});
      res == "success"
          ? Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  )))
          : showSnackbar(res, context);
    } else {
      isLoading = false;
      showSnackbar("all fields needed", context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                //SVG Logo
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  height: 64,
                  color: primaryColor,
                ),
                const SizedBox(height: 30),
                Stack(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(image!))
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(Icons.add_a_photo)))
                  ],
                ),
                const SizedBox(height: 20),

                //Input textfield for Username

                TextFieldInput(
                    textEditingController: usernameController,
                    hintText: "Enter your username",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(height: 20),

                //Input textfield for email

                TextFieldInput(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(height: 20),

                //Input textfield for Password

                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.visiblePassword,
                  isPass: true,
                ),
                const SizedBox(height: 20),

                //Input textfield for BIO

                TextFieldInput(
                    textEditingController: bioController,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(height: 20),

                // button for login

                InkWell(
                  onTap: () {
                    signupUser();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: blueColor),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Sign up"),
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
                      child: const Text("Already have an account?"),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen()));
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          " Sign in.",
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
