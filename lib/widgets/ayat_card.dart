import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../providers/audio_provider.dart';
import 'common.dart';
import 'grammar_sheet.dart';

class AyatCard extends StatelessWidget {
  final Ayat ayat;
  const AyatCard({super.key, required this.ayat});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final audio = context.watch<AudioProvider>();
    final p = Pal.of(context);
    final isCurrent = audio.current == ayat.id;
    final isPlaying = isCurrent && audio.playing;

    return AppCard(
      highlight: isCurrent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              GoldBadge('${ayat.id}'),
              const Spacer(),
              IconButton(
                tooltip: 'Ayat ${ayat.id} sunein',
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, color: p.primary),
                onPressed: () {
                  if (isCurrent) {
                    audio.toggle();
                  } else {
                    audio.play(ayat.id, totalAyaat: app.ayaat.length);
                  }
                },
              ),
              IconButton(
                tooltip: 'Parh li',
                icon: Icon(
                  app.isRead(ayat.id) ? Icons.check_circle : Icons.check_circle_outline,
                  color: app.isRead(ayat.id) ? p.primary : p.text2,
                ),
                onPressed: () => app.toggleRead(ayat.id),
              ),
              IconButton(
                tooltip: 'Bookmark',
                icon: Icon(
                  app.isBookmarked(ayat.id) ? Icons.bookmark : Icons.bookmark_border,
                  color: app.isBookmarked(ayat.id) ? p.gold : p.text2,
                ),
                onPressed: () => app.toggleBookmark(ayat.id),
              ),
            ],
          ),
          // Arabic lafz-ba-lafz chips (RTL). Chip par tap = grammar sheet.
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              textDirection: TextDirection.rtl,
              spacing: 10,
              runSpacing: 2,
              children: [
                for (var i = 0; i < ayat.words.length; i++) _chip(context, app, p, i),
              ],
            ),
          ),
          if (ayat.words.isEmpty)
            Text(ayat.arabic,
                textDirection: TextDirection.rtl,
                style: arabicStyle(app.arabicSize, color: p.text)),
          if (app.showTranslation)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: p.divider))),
              child: Text(ayat.urdu,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: urduStyle(app.urduSize, color: p.text2)),
            ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, AppState app, Pal p, int i) {
    final w = ayat.words[i];
    final main = w.mainSegment;
    final color = main == null ? p.divider : kindColor(main.kind);
    return GestureDetector(
      onTap: () => showGrammarSheet(context, ayat, i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: color, width: 3))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(w.arabic,
                textDirection: TextDirection.rtl,
                style: arabicStyle(app.arabicSize, color: p.text)),
            if (app.showMeaning && w.meaning != null && w.meaning!.isNotEmpty)
              Text(w.meaning!, style: TextStyle(fontSize: 10, color: p.text2)),
          ],
        ),
      ),
    );
  }
}
