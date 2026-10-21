import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'create_profile_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final app = context.read<AppState>();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) =>
            app.users.isEmpty ? const CreateProfileScreen(firstRun: true) : const LoginScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B6E4F), Color(0xFF064E38)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('يس',
                style: TextStyle(
                    fontFamily: 'AmiriQuran', fontSize: 84, color: Color(0xFFE0B84A), height: 1.4)),
            Text('Yaseen Tutor',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text('Qalb-ul-Quran ko samjho', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
