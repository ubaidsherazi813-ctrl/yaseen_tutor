import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  final int initialTabIndex; // 0 = Login, 1 = Sign Up
  const LoginScreen({super.key, this.initialTabIndex = 0});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Login controllers
  final _loginEmail = TextEditingController();
  final _loginPass = TextEditingController();
  bool _loginPassObscure = true;
  String? _loginError;

  // Sign Up controllers
  final _regName = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPass = TextEditingController();
  final _regConfirmPass = TextEditingController();
  bool _regPassObscure = true;
  String _selectedAvatar = '👦'; // Default to Boy as requested!
  String? _regError;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // Pre-fill last user email if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final last = context.read<AppState>().lastUser;
      if (last != null && last.email.isNotEmpty) {
        _loginEmail.text = last.email;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmail.dispose();
    _loginPass.dispose();
    _regName.dispose();
    _regEmail.dispose();
    _regPass.dispose();
    _regConfirmPass.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _loginEmail.text.trim();
    final pass = _loginPass.text;

    if (email.isEmpty) {
      setState(() => _loginError = 'Baraye meherbani Email darj karein');
      return;
    }
    if (pass.isEmpty) {
      setState(() => _loginError = 'Baraye meherbani Password darj karein');
      return;
    }

    setState(() {
      _loading = true;
      _loginError = null;
    });

    try {
      final app = context.read<AppState>();
      final err = await app.loginWithEmail(email, pass).timeout(const Duration(seconds: 8));

      if (!mounted) return;

      if (err == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      } else {
        setState(() => _loginError = err);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loginError = 'Login error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    final name = _regName.text.trim();
    final email = _regEmail.text.trim();
    final pass = _regPass.text;
    final confirm = _regConfirmPass.text;

    if (name.isEmpty) {
      setState(() => _regError = 'Baraye meherbani apna Naam likhein');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _regError = 'Sahi Email address darj karein (e.g. name@example.com)');
      return;
    }
    if (pass.length < 4) {
      setState(() => _regError = 'Password kam az kam 4 characters ka hona chahiye');
      return;
    }
    if (pass != confirm) {
      setState(() => _regError = 'Dono passwords match nahi karte');
      return;
    }

    setState(() {
      _loading = true;
      _regError = null;
    });

    try {
      final app = context.read<AppState>();

      // Check if email already registered safely
      final cleanEmail = email.toLowerCase();
      final already = app.users.any((u) {
        final ue = u.email.trim().toLowerCase();
        return ue.isNotEmpty && ue == cleanEmail;
      });

      if (already) {
        setState(() {
          _loading = false;
          _regError = 'Yeh email pehle se registered hai! Login tab mein jayen.';
        });
        return;
      }

      await app.registerWithEmail(
        name: name,
        email: email,
        password: pass,
        avatar: _selectedAvatar,
      ).timeout(const Duration(seconds: 8));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } catch (e, st) {
      debugPrint('Registration error: $e\n$st');
      if (mounted) {
        setState(() {
          _regError = 'Account banane mein masla aaya: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _handleGuest() async {
    await context.read<AppState>().loginAsGuest();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Islamic Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B6E4F), Color(0xFF064E38)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'يس',
                      style: TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 64,
                        color: Color(0xFFE0B84A),
                        height: 1.2,
                      ),
                    ),
                    const Text(
                      'Yaseen Tutor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Qalb-ul-Quran ko samjhein aur seekhein',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 18),

                    // Tab Selector Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: const Color(0xFFE0B84A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: const Color(0xFF064E38),
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        unselectedLabelColor: Colors.white,
                        tabs: const [
                          Tab(text: 'لاگ ان (Login)'),
                          Tab(text: 'نیا اکاؤنٹ (Sign Up)'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Form Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (ctx, _) {
                    return _tabController.index == 0
                        ? _buildLoginForm(p)
                        : _buildRegisterForm(p);
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(Pal p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'خوش آمدید (Welcome Back)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: p.text),
        ),
        const SizedBox(height: 4),
        Text(
          'Apne email aur password se login karein',
          style: TextStyle(fontSize: 13, color: p.text2),
        ),
        const SizedBox(height: 16),

        if (_loginError != null) _errorBox(_loginError!),

        // Email Field
        TextFormField(
          controller: _loginEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDec(
            p,
            label: 'Email Address',
            hint: 'name@example.com',
            icon: Icons.email_outlined,
          ),
        ),
        const SizedBox(height: 14),

        // Password Field
        TextFormField(
          controller: _loginPass,
          obscureText: _loginPassObscure,
          decoration: _inputDec(
            p,
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
            suffix: IconButton(
              icon: Icon(
                _loginPassObscure ? Icons.visibility_off : Icons.visibility,
                color: p.text2,
                size: 20,
              ),
              onPressed: () => setState(() => _loginPassObscure = !_loginPassObscure),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Login Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: p.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          onPressed: _loading ? null : _handleLogin,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'لاگ ان کریں (Login)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
        ),

        const SizedBox(height: 12),

        // Switch to Sign Up
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Account nahi hai? ', style: TextStyle(color: p.text2, fontSize: 13)),
            GestureDetector(
              onTap: () => setState(() => _tabController.animateTo(1)),
              child: Text(
                'Naya Account Banayein',
                style: TextStyle(
                  color: p.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),

        // Guest Mode Button
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: p.text,
            side: BorderSide(color: p.divider),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.person_outline, size: 18),
          label: const Text('مہمان موڈ میں جاری رکھیں (Guest Mode)'),
          onPressed: _loading ? null : _handleGuest,
        ),
      ],
    );
  }

  Widget _buildRegisterForm(Pal p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          'پروفائل بنائیں (Create Profile)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: p.text),
        ),
        const SizedBox(height: 4),
        Text(
          'Apna naam, email aur pasandeeda avatar muntakhab karein',
          style: TextStyle(fontSize: 13, color: p.text2),
        ),
        const SizedBox(height: 14),

        if (_regError != null) _errorBox(_regError!),

        // Avatar Selection Section
        Text(
          'Profile Picture (Avatar) Choose Karein:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.text),
        ),
        const SizedBox(height: 8),

        // Avatar Row/Grid
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: p.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: p.divider),
          ),
          child: Column(
            children: [
              // Current Selected Avatar Display
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: p.gold, width: 2.5),
                    ),
                    child: Text(_selectedAvatar, style: const TextStyle(fontSize: 30)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Muntakhab Avatar: ${avatarLabels[_selectedAvatar] ?? _selectedAvatar}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          'Aap boy (👦), man (👨), ya kisi bhi avatar ko choose kar sakte hain',
                          style: TextStyle(fontSize: 11, color: p.text2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Horizontal list of avatars with labels
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: avatars.map((av) {
                    final sel = av == _selectedAvatar;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => setState(() => _selectedAvatar = av),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: sel ? p.primary.withValues(alpha: 0.15) : p.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel ? p.primary : p.divider,
                              width: sel ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(av, style: const TextStyle(fontSize: 26)),
                              const SizedBox(height: 2),
                              Text(
                                (avatarLabels[av] ?? '').split(' ').first,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                                  color: sel ? p.primary : p.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Name Field
        TextFormField(
          controller: _regName,
          decoration: _inputDec(
            p,
            label: 'Apna Naam (Name)',
            hint: 'e.g. Ubaid',
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(height: 12),

        // Email Field
        TextFormField(
          controller: _regEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDec(
            p,
            label: 'Email Address',
            hint: 'ubaid@example.com',
            icon: Icons.email_outlined,
          ),
        ),
        const SizedBox(height: 12),

        // Password Field
        TextFormField(
          controller: _regPass,
          obscureText: _regPassObscure,
          decoration: _inputDec(
            p,
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
            suffix: IconButton(
              icon: Icon(
                _regPassObscure ? Icons.visibility_off : Icons.visibility,
                color: p.text2,
                size: 20,
              ),
              onPressed: () => setState(() => _regPassObscure = !_regPassObscure),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Confirm Password Field
        TextFormField(
          controller: _regConfirmPass,
          obscureText: _regPassObscure,
          decoration: _inputDec(
            p,
            label: 'Confirm Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
          ),
        ),
        const SizedBox(height: 20),

        // Register Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: p.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          onPressed: _loading ? null : _handleRegister,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'اکاؤنٹ بنائیں (Create Account)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pehle se account hai? ', style: TextStyle(color: p.text2, fontSize: 13)),
            GestureDetector(
              onTap: () => setState(() => _tabController.animateTo(0)),
              child: Text(
                'Login Karein',
                style: TextStyle(
                  color: p.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _errorBox(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB3261E).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB3261E)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFB3261E), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFB3261E), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(
    Pal p, {
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: p.primary, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: p.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
