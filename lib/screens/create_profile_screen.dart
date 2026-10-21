import 'package:flutter/material.dart';
import 'login_screen.dart';

class CreateProfileScreen extends StatelessWidget {
  final bool firstRun;
  const CreateProfileScreen({super.key, this.firstRun = false});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(initialTabIndex: 1);
  }
}
