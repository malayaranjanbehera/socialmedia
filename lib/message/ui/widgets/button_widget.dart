
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/message/core/constants/colors.dart';
import 'package:instagram/message/core/constants/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.text, this.onPressed, this.loading = false});

  final void Function()? onPressed;
  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 40.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primary),
          onPressed: onPressed,
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Text(text, style: body.copyWith(color: white))),
    );
  }
}
