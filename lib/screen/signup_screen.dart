import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/data/firebase_service/firebase_auth.dart';
import 'package:instagram/screen/home.dart';
import 'package:instagram/util/dialog.dart';
import 'package:instagram/util/exeption.dart';
import 'package:instagram/util/imagepicker.dart';
import 'package:instagram/widgets/navigation.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  File? _imageFile;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    passwordConfirme.dispose();
    username.dispose();
    bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(width: 96.w, height: 10.h),
            Center(
              child: Text("Snapgram", style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Malaya'

              ),),
            ),
            SizedBox(width: 96.w, height: 40.h),
            InkWell(
              onTap: () async {
                File imagefilee = await ImagePickerr().uploadImage('gallery');
                setState(() {
                  _imageFile = imagefilee;
                });
              },
              child: CircleAvatar(
                radius: 36.r,
                backgroundColor: Colors.grey,
                child:
                    _imageFile == null
                        ? CircleAvatar(
                          radius: 34.r,
                          child: Icon(Icons.photo),
                          // backgroundImage: const AssetImage(
                          //   'images/person.png',
                          // ),
                          // backgroundColor: Colors.grey.shade200,
                        )
                        : CircleAvatar(
                          radius: 34.r,
                          backgroundImage:
                              Image.file(_imageFile!, fit: BoxFit.cover).image,
                          backgroundColor: Colors.grey.shade200,
                        ),
              ),
            ),
            SizedBox(height: 40.h),
            Textfild(email, email_F, 'Email', Icons.email),
            SizedBox(height: 15.h),
            Textfild(username, username_F, 'username', Icons.person),
            SizedBox(height: 15.h),
            Textfild(bio, bio_F, 'bio', Icons.abc),
            SizedBox(height: 15.h),
            Textfild(password, password_F, 'Password', Icons.lock),
            SizedBox(height: 15.h),
            Textfild(
              passwordConfirme,
              passwordConfirme_F,
              'PasswordConfirme',
              Icons.lock,
            ),
            SizedBox(height: 15.h),
            Signup(),
            SizedBox(height: 15.h),
            Have(),
          ],
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Do you have account?  ",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Login ",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Signup() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          // Check for empty fields
          if (_imageFile == null ||
              email.text.isEmpty ||
              username.text.isEmpty ||
              bio.text.isEmpty ||
              password.text.isEmpty ||
              passwordConfirme.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("All fields are required."),
                backgroundColor: Colors.green,
              ),
            );
            return;
          }

          // Password match check
          if (password.text != passwordConfirme.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Passwords do not match."),
                backgroundColor: Colors.green,
              ),
            );
            return;
          }

          try {
            await Authentication().Signup(
              email: email.text,
              password: password.text,
              passwordConfirme: passwordConfirme.text,
              username: username.text,
              bio: bio.text,
              profile: _imageFile!,
            );

            // Navigate to home and replace login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Navigations_Screen()),
            );
          } on exceptions catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Unexpected error occurred."),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Sign up',
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Padding Textfild(
    TextEditingController controll,
    FocusNode focusNode,
    String typename,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controll,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: typename,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 15.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(width: 2.w, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(width: 2.w, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
