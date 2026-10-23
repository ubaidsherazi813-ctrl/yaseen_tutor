import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import 'google_logo.dart';

/// Official-style Google Sign-In button widget
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool loading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.label = 'Google کے ساتھ جاری رکھیں (Continue with Google)',
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF3C4043),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFDADCE0),
          width: 1.2,
        ),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GoogleLogo(size: 22),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF3C4043),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}

/// Native-styled Google Account Picker Bottom Sheet
class GoogleSignInSheet extends StatefulWidget {
  final Function(String name, String email, String avatar) onSelected;

  const GoogleSignInSheet({super.key, required this.onSelected});

  @override
  State<GoogleSignInSheet> createState() => _GoogleSignInSheetState();
}

class _GoogleSignInSheetState extends State<GoogleSignInSheet> {
  final _nameController = TextEditingController(text: 'Muhammad');
  final _emailController = TextEditingController(text: 'user@gmail.com');
  String _chosenAvatar = '👦';
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    final last = context.read<AppState>().lastUser;
    if (last != null && last.email.isNotEmpty && !last.isGuest) {
      _nameController.text = last.name;
      _emailController.text = last.email;
      _chosenAvatar = last.avatar;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lastUser = context.read<AppState>().lastUser;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: Google Logo + Title
            Row(
              children: [
                const GoogleLogo(size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Google Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Text(
                        'Yaseen Tutor mein shamil hone ke liye account chunein',
                        style: TextStyle(fontSize: 12, color: p.text2),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Returning user 1-Tap card (if exists)
            if (lastUser != null && lastUser.email.isNotEmpty && !lastUser.isGuest) ...[
              _accountCard(
                title: lastUser.name,
                subtitle: lastUser.email,
                avatar: lastUser.avatar,
                badge: 'Pichla Account (Saved)',
                onTap: () {
                  widget.onSelected(lastUser.name, lastUser.email, lastUser.avatar);
                },
                p: p,
              ),
              const SizedBox(height: 12),
            ],

            // 1-Tap Fast Google Sign-in Card
            _accountCard(
              title: 'Muhammad (Google Profile)',
              subtitle: 'muhammad.tutor@gmail.com',
              avatar: '👦',
              badge: '1-Tap Fast Sign In',
              onTap: () {
                widget.onSelected('Muhammad', 'muhammad.tutor@gmail.com', '👦');
              },
              p: p,
            ),
            const SizedBox(height: 12),

            // Option to enter custom Gmail
            if (!_showCustomInput) ...[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: p.text,
                  side: BorderSide(color: p.divider),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text('Apna Gmail Account darj karein (Add your Gmail)'),
                onPressed: () => setState(() => _showCustomInput = true),
              ),
            ] else ...[
              // Custom Gmail Form
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: p.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: p.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Apni Google Maloomaat Darj Karein:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: p.text),
                    ),
                    const SizedBox(height: 10),

                    // Name
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Apna Naam (Name)',
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        filled: true,
                        fillColor: p.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Gmail
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Google Email (Gmail)',
                        hintText: 'example@gmail.com',
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        filled: true,
                        fillColor: p.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Quick domain chips
                    Wrap(
                      spacing: 6,
                      children: ['@gmail.com', '@yahoo.com', '@outlook.com'].map((domain) {
                        return ActionChip(
                          label: Text(domain, style: const TextStyle(fontSize: 11)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            var current = _emailController.text.trim();
                            if (current.contains('@')) {
                              current = current.split('@').first;
                            }
                            if (current.isEmpty) current = 'user';
                            _emailController.text = '$current$domain';
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // Submit button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        final name = _nameController.text.trim().isEmpty
                            ? 'Google User'
                            : _nameController.text.trim();
                        var email = _emailController.text.trim();
                        if (email.isEmpty) email = 'user@gmail.com';
                        if (!email.contains('@')) email = '$email@gmail.com';

                        widget.onSelected(name, email, _chosenAvatar);
                      },
                      child: const Text(
                        'Is Google Account se Jari Rakhein',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 14, color: p.text2),
                const SizedBox(width: 6),
                Text(
                  '100% Mehfooz aur Offline. Password ki zaroorat nahi.',
                  style: TextStyle(fontSize: 11, color: p.text2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountCard({
    required String title,
    required String subtitle,
    required String avatar,
    required String badge,
    required VoidCallback onTap,
    required Pal p,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.divider, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.bg,
                shape: BoxShape.circle,
                border: Border.all(color: p.gold, width: 2),
              ),
              child: Text(avatar, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: p.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: p.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: p.text2),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: p.text2),
          ],
        ),
      ),
    );
  }
}
