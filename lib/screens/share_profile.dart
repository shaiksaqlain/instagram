// ignore_for_file: avoid_print, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/qr_code_generator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ShareProfile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userName;
  const ShareProfile({Key? key, required this.userName}) : super(key: key);

  @override
  State<ShareProfile> createState() => _ShareProfileState();
}

class _ShareProfileState extends State<ShareProfile> {
  bool isQrScanner = false;
  final qrKey = GlobalKey(debugLabel: 'qr');

  @override
  void initState() {
    qrData = qrData + widget.userName;
    print(qrData);
    super.initState();
  }

  String qrData = "https://www.instagram.com/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.userName.toString().toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            QR().qrGenerator(qrData),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Scan this QR Code to view my profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
