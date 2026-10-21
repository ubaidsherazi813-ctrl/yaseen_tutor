import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Pal.of(context);
    final ids = app.bookmarks.toList()..sort();
    final items = app.ayaat.where((a) => ids.contains(a.id)).toList();

    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            title: 'Bookmarks',
            subtitle: '${items.length} ayaat',
            actions: [
              IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('Abhi koi bookmark nahi', style: TextStyle(color: p.text2)))
                : ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      for (final a in items)
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.pop(context);
                            app.goTab(1, ayat: a.id);
                          },
                          child: AppCard(
                            child: Row(
                              children: [
                                GoldBadge('${a.id}'),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(a.arabic,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: arabicStyle(22, color: p.text)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => app.toggleBookmark(a.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
