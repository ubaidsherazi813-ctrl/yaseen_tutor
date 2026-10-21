import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../providers/audio_provider.dart';
import '../widgets/common.dart';
import '../widgets/gardan_modal.dart';
import 'bookmarks_screen.dart';
import 'create_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _toLogin(BuildContext context, AppState app) {
    context.read<AudioProvider>().stop();
    final next = app.users.isEmpty ? const CreateProfileScreen(firstRun: true) : const LoginScreen();
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => next), (_) => false);
  }

  Future<void> _changePin(BuildContext context, AppState app) async {
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('PIN badlein'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in [(oldC, 'Purana PIN'), (newC, 'Naya 4-digit PIN')])
              TextField(
                controller: e.$1,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: e.$2),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Badlein')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    if (newC.text.length != 4) {
      snack(context, 'Naya PIN 4 digit ka hona chahiye');
      return;
    }
    final done = await app.changePin(oldC.text, newC.text);
    if (!context.mounted) return;
    snack(context, done ? 'PIN badal diya gaya' : 'Purana PIN galat hai');
  }

  Future<void> _delete(BuildContext context, AppState app) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Profile delete karein?'),
        content: const Text('Is profile ke bookmarks, progress aur quiz scores mit jayenge.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Nahi')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Haan, delete')),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    await app.deleteCurrentUser();
    if (!context.mounted) return;
    _toLogin(context, app);
  }

  void _chooseAvatar(BuildContext context, AppState app) {
    if (app.user == null || app.user!.isGuest) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Avatar Muntakhab Karein'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: avatars.map((av) {
              final sel = av == app.user?.avatar;
              return InkWell(
                onTap: () {
                  app.updateAvatar(av);
                  Navigator.pop(ctx);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: sel
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: sel ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(av, style: const TextStyle(fontSize: 32)),
                      Text(
                        (avatarLabels[av] ?? '').split(' ').first,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Band Karein')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final audio = context.watch<AudioProvider>();
    final p = Pal.of(context);
    final u = app.user;

    return Column(
      children: [
        const GradientHeader(title: 'Profile', subtitle: 'Settings aur theme'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              AppCard(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _chooseAvatar(context, app),
                      borderRadius: BorderRadius.circular(25),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: p.bg,
                              shape: BoxShape.circle,
                              border: Border.all(color: p.gold, width: 2),
                            ),
                            child: Text(u?.avatar ?? '👦',
                                style: const TextStyle(fontSize: 36)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: p.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.edit,
                                size: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u?.name ?? '',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          if (u != null && u.email.isNotEmpty)
                            Text(u.email,
                                style: TextStyle(color: p.primary, fontSize: 12)),
                          Text(u?.isGuest == true ? 'Guest mode' : 'Local profile · offline',
                              style: TextStyle(color: p.text2, fontSize: 11)),
                        ],
                      ),
                    ),
                    if (u != null && !u.isGuest)
                      IconButton(
                        tooltip: 'Avatar Badlein',
                        icon: Icon(Icons.face_retouching_natural, color: p.primary),
                        onPressed: () => _chooseAvatar(context, app),
                      ),
                  ],
                ),
              ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                        ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                        ButtonSegment(value: ThemeMode.system, label: Text('System')),
                      ],
                      selected: {app.themeMode},
                      onSelectionChanged: (s) => app.setThemeMode(s.first),
                    ),
                    const SizedBox(height: 14),
                    Text('Arabic font size: ${app.arabicSize.round()}'),
                    Slider(
                        min: 22, max: 44, value: app.arabicSize, onChanged: app.setArabicSize),
                    Text('Urdu font size: ${app.urduSize.round()}'),
                    Slider(min: 14, max: 26, value: app.urduSize, onChanged: app.setUrduSize),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Urdu tarjuma dikhayein'),
                      value: app.showTranslation,
                      onChanged: app.setShowTranslation,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Lafz ka matlab dikhayein'),
                      value: app.showMeaning,
                      onChanged: app.setShowMeaning,
                    ),
                  ],
                ),
              ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Audio', style: TextStyle(fontWeight: FontWeight.w600)),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Agli ayat khud chalayein'),
                      value: audio.autoNext,
                      onChanged: audio.setAutoNext,
                    ),
                    Row(
                      children: [
                        const Text('Raftaar'),
                        const SizedBox(width: 12),
                        for (final s in [0.75, 1.0, 1.25])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('${s}x'),
                              selected: audio.speed == s,
                              onSelected: (_) => audio.setSpeed(s),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.menu_book, color: Color(0xFF0B6E4F)),
                      title: const Text('14 Sighon ki Gardan (Sarf Explorer)'),
                      subtitle: const Text('خَلَقَ، قَالَ، جَعَلَ، عَلِمَ وغیرہ کی گردانیں'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => showGardanModal(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.bookmark),
                      title: const Text('Bookmarks'),
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const BookmarksScreen())),
                    ),
                    if (u != null && !u.isGuest)
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('PIN badlein'),
                        onTap: () => _changePin(context, app),
                      ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About aur credits'),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'Yaseen Tutor',
                        applicationVersion: '1.0.0',
                        children: const [
                          Text('Offline Surah Yaseen learning app.\n\n'
                              'Credits (apne data ke mutabiq yahan likhein):\n'
                              '• Quran text: Tanzil.net\n'
                              '• Grammar: Quranic Arabic Corpus\n'
                              '• Audio: EveryAyah.com / qaari ka naam\n'
                              '• Tarjuma: mutarjim ka naam\n\n'
                              'Developer: (apna naam)\nSupervisor: (ustad ka naam)'),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        app.logout();
                        _toLogin(context, app);
                      },
                    ),
                    if (u != null && !u.isGuest)
                      ListTile(
                        leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                        title: const Text('Profile delete karein'),
                        onTap: () => _delete(context, app),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
