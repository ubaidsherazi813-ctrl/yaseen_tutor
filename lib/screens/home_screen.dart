import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import '../widgets/gardan_modal.dart';
import 'bookmarks_screen.dart';
import 'topics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Pal.of(context);
    final total = app.ayaat.length;
    final read = app.readIds.length;
    final progress = total == 0 ? 0.0 : read / total;
    final weekly = app.weekly;
    final maxV = weekly.fold<int>(1, (m, v) => v > m ? v : m);
    const dayNames = ['Pir', 'Mangal', 'Budh', 'Jumeraat', 'Jumma', 'Hafta', 'Itwaar'];

    return Column(
      children: [
        GradientHeader(
          title: 'Assalamu Alaikum, ${app.user?.name ?? ''}',
          subtitle: 'Aaj ki tilawat shuru karein',
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GoldBadge('🔥 ${app.streak} din'),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              AppCard(
                child: Row(
                  children: [
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 84,
                            height: 84,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 9,
                              backgroundColor: p.divider,
                              color: p.primary,
                            ),
                          ),
                          Text('$read/$total',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Aapki progress',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('$read ayaat parh li gayin',
                              style: TextStyle(color: p.text2, fontSize: 12)),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: total == 0
                                ? null
                                : () => app.goTab(1, ayat: app.continueAyat),
                            child: Text('Continue: Ayat ${app.continueAyat}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.25,
                children: [
                  _tile(context, Icons.menu_book, 'Ayaat', () => app.goTab(1)),
                  _tile(context, Icons.extension, 'Grammar', () => app.goTab(2)),
                  _tile(context, Icons.table_chart_rounded, '14 Gardan', () => showGardanModal(context)),
                  _tile(context, Icons.quiz, 'Quiz', () => app.goTab(3)),
                  _tile(context, Icons.lightbulb, 'Mauzoobaat', () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const TopicsScreen()));
                  }),
                  _tile(context, Icons.bookmark, 'Bookmarks', () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const BookmarksScreen()));
                  }),
                ],
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Is hafte ki reading',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var i = 0; i < 7; i++)
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    height: 6 + 70.0 * weekly[i] / maxV,
                                    decoration: BoxDecoration(
                                      color: weekly[i] == 0 ? p.divider : p.primary,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dayNames[DateTime.now()
                                            .subtract(Duration(days: 6 - i))
                                            .weekday -
                                        1],
                                    style: TextStyle(fontSize: 9, color: p.text2),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (app.bookmarks.isNotEmpty)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bookmarks', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final id in (app.bookmarks.toList()..sort()))
                            ActionChip(
                              label: Text('Ayat $id'),
                              onPressed: () => app.goTab(1, ayat: id),
                            ),
                        ],
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

  Widget _tile(BuildContext c, IconData icon, String label, VoidCallback onTap) {
    final p = Pal.of(c);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: p.primary, size: 26),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
