import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/mini_player.dart';
import 'ayaat_screen.dart';
import 'grammar_guide_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'quiz_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      body: IndexedStack(
        index: app.tab,
        children: const [
          HomeScreen(),
          AyaatScreen(),
          GrammarGuideScreen(),
          QuizScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          NavigationBar(
            selectedIndex: app.tab,
            onDestinationSelected: (i) => app.goTab(i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Ayaat'),
              NavigationDestination(icon: Icon(Icons.extension_outlined), selectedIcon: Icon(Icons.extension), label: 'Grammar'),
              NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'Quiz'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ],
      ),
    );
  }
}
