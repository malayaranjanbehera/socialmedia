import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_service.dart';

class DeletePostDialog extends StatelessWidget {
  final String postId;

  const DeletePostDialog({required this.postId, Key? key}) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Do you want to delete this post ?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                  text: "Yes, delete",
                  onPressed: () async {
                    await PostService().deletePost(postId);
                    Navigator.pop(context); // Close dialog
                  },
                ),
                SimpleBtn1(
                  text: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  invertedColors: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;

  const SimpleBtn1({
    required this.text,
    required this.onPressed,
    this.invertedColors = false,
    Key? key,
  }) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        alignment: Alignment.center,
        side: MaterialStateProperty.all(
          BorderSide(width: 1, color: primaryColor),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0),
        ),
        backgroundColor: MaterialStateProperty.all(
          invertedColors ? accentColor : primaryColor,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: invertedColors ? primaryColor : accentColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
