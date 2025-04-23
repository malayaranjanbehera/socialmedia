
import 'package:flutter/material.dart';
import 'package:instagram/Ai_chat/ai_main_section.dart';

class AiMain extends StatelessWidget {
  const AiMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AiMainSec(),
    );
  }
}
