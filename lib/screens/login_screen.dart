import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import 'create_profile_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pin = '';
  String? message;
  int shake = 0;
  AppUser? selected;

  @override
  void initState() {
    super.initState();
    selected = context.read<AppState>().lastUser;
  }

  Future<void> _key(String k) async {
    final app = context.read<AppState>();
    if (app.lockSecondsLeft > 0) {
      setState(() => message = '${app.lockSecondsLeft} second baad dobara koshish karein');
      return;
    }
    setState(() {
      if (k == '<') {
        if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
      } else if (pin.length < 4) {
        pin += k;
      }
      message = null;
    });
    if (pin.length == 4 && selected != null) {
      final ok = await app.login(selected!, pin);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
      } else {
        setState(() {
          pin = '';
          shake++;
          message = app.lockSecondsLeft > 0
              ? 'Bohat ghalat koshishein. 30 second intezar karein'
              : 'PIN galat hai, dobara koshish karein';
        });
      }
    }
  }

  Future<void> _guest() async {
    await context.read<AppState>().loginAsGuest();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  void _switchProfile() {
    final app = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final u in app.users)
              ListTile(
                leading: Text(u.avatar, style: const TextStyle(fontSize: 26)),
                title: Text(u.name),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    selected = u;
                    pin = '';
                    message = null;
                  });
                },
              ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Naya profile banayein'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const CreateProfileScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B84A);
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(selected?.avatar ?? '🌙', style: const TextStyle(fontSize: 54)),
                Text('Welcome back, ${selected?.name ?? ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                const Text('Apna 4-digit PIN daalein', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 18),
                TweenAnimationBuilder<double>(
                  key: ValueKey(shake),
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 350),
                  builder: (_, v, child) =>
                      Transform.translate(offset: Offset(sin(v * pi * 4) * 10 * (1 - v), 0), child: child),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < pin.length ? gold : Colors.transparent,
                          border: Border.all(color: gold, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(message ?? '',
                        style: const TextStyle(color: Color(0xFFFFB4AB), fontSize: 13)),
                  ),
                ),
                _keypad(),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: _switchProfile,
                    child: const Text('Profile badlein / naya banayein', style: TextStyle(color: gold))),
                TextButton(
                    onPressed: _guest,
                    child: const Text('Guest ke tor par continue karein', style: TextStyle(color: gold))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _keypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '<'];
    return SizedBox(
      width: 260,
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        alignment: WrapAlignment.center,
        children: [
          for (final k in keys)
            SizedBox(
              width: 72,
              height: 72,
              child: k.isEmpty
                  ? const SizedBox.shrink()
                  : Material(
                      color: const Color(0x24FFFFFF),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _key(k),
                        child: Center(
                          child: k == '<'
                              ? const Icon(Icons.backspace_outlined, color: Colors.white)
                              : Text(k, style: const TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
