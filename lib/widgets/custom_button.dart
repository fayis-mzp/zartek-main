import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final String? label;
  final Color? backGroundColor;
  final Widget? icon;
  final Function()? onTap;
  const CustomButton(
      {super.key,
      this.icon,
      this.label,
      this.backGroundColor,
      this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        iconAlignment: IconAlignment.start,
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: backGroundColor,
          minimumSize: Size(MediaQuery.of(context).size.width, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: icon,
        onPressed: onTap,
        label: Align(
            alignment: Alignment.center,
            child: isLoading
                ? CupertinoActivityIndicator(radius: 13, color: Colors.white)
                : Text(
                    label!,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  )));
  }
}
