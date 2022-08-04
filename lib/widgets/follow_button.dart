import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  const FollowButton(
      {Key? key,
      this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor})
      : super(key: key);
  final Function()? function;
  final Color backgroundColor;
  final String text;
  final Color borderColor;
  final Color textColor;
  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2,left: 15),
      child: TextButton(
          onPressed: () {},
          child: Container(
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(color: widget.borderColor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            width: 250,
            height: 27,
            child: Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          )),
    );
  }
}
