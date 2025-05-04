import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/auth/auth_screen.dart';

import '../widgets/navigation.dart';
 // Or your login/signup screen

class StayLoginPage extends StatelessWidget {
  const StayLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If user is logged in, go to home
    if (user != null) {
      return Navigations_Screen();
    } else {
      return AuthScreen(); // or a combined login/signup page
    }
  }
}
