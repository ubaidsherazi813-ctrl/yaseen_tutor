import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/app_state.dart';
import 'providers/audio_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = AppState();
  try {
    await app.init().timeout(const Duration(seconds: 4));
  } catch (e, st) {
    debugPrint('App init warning: $e\n$st');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: app),
        ChangeNotifierProvider<AudioProvider>(create: (_) => AudioProvider()),
      ],
      child: const YaseenApp(),
    ),
  );
}

class YaseenApp extends StatelessWidget {
  const YaseenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.select<AppState, ThemeMode>((a) => a.themeMode);
    return MaterialApp(
      title: 'Yaseen Tutor',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: mode,
      home: const SplashScreen(),
    );
  }
}
