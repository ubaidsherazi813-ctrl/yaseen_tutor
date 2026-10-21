import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

class CreateProfileScreen extends StatefulWidget {
  final bool firstRun;
  const CreateProfileScreen({super.key, this.firstRun = false});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final name = TextEditingController();
  final pin = TextEditingController();
  final pin2 = TextEditingController();
  String avatar = avatars.first;
  String? error;

  @override
  void dispose() {
    name.dispose();
    pin.dispose();
    pin2.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (name.text.trim().isEmpty) {
      setState(() => error = 'Apna naam likhein');
      return;
    }
    if (pin.text.length != 4) {
      setState(() => error = 'PIN 4 digit ka hona chahiye');
      return;
    }
    if (pin.text != pin2.text) {
      setState(() => error = 'Dono PIN mel nahi khate');
      return;
    }
    final app = context.read<AppState>();
    final u = await app.createUser(name.text, avatar, pin.text);
    await app.login(u, pin.text);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
  }

  Future<void> _guest() async {
    await context.read<AppState>().loginAsGuest();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            title: 'Profile banayein',
            subtitle: 'Yeh profile sirf is phone par rehti hai (offline)',
            actions: [
              if (!widget.firstRun)
                IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Avatar chunein'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: [
                    for (final a in avatars)
                      ChoiceChip(
                        label: Text(a, style: const TextStyle(fontSize: 24)),
                        selected: avatar == a,
                        onSelected: (_) => setState(() => avatar = a),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      labelText: 'Naam', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: pin,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      labelText: '4-digit PIN', border: OutlineInputBorder()),
                ),
                TextField(
                  controller: pin2,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      labelText: 'PIN dobara likhein', border: OutlineInputBorder()),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(error!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                FilledButton(onPressed: _create, child: const Text('Profile banayein')),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: _guest,
                    child: const Text('Abhi nahi, Guest ke tor par shuru karein')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
