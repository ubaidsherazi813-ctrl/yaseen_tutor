import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../core/gardan_data.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import 'gardan_modal.dart';

/// Kisi lafz par tap karne se yeh sheet khulti hai.
void showGrammarSheet(BuildContext context, Ayat ayat, int wordIndex) {
  context.read<AppState>().markRead(ayat.id);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => GrammarSheet(ayat: ayat, startIndex: wordIndex),
  );
}

class GrammarSheet extends StatefulWidget {
  final Ayat ayat;
  final int startIndex;
  const GrammarSheet({super.key, required this.ayat, required this.startIndex});

  @override
  State<GrammarSheet> createState() => _GrammarSheetState();
}

class _GrammarSheetState extends State<GrammarSheet> {
  late int idx = widget.startIndex;

  List<MapEntry<String, String>> _rows(Segment s) {
    final r = <MapEntry<String, String>>[];
    void add(String k, String? v) {
      if (v != null && v.trim().isNotEmpty) r.add(MapEntry(k, v));
    }

    add('Fe’l ka zamana', s.tense);
    add('I’rab (halat)', s.i3rab);
    add('Mabni / Mu’rab', s.mabni);
    add('Jins', s.gender);
    add('Adad', s.number);
    add('Purush', s.person);
    add('Zameer ki qism', s.pronType);
    add('Note', s.note);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final words = widget.ayat.words;
    final w = words[idx];

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (ctx, controller) => Container(
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                    color: p.divider, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 8),
            Text('Ayat ${widget.ayat.id} · Lafz ${idx + 1}/${words.length}',
                textAlign: TextAlign.center,
                style: TextStyle(color: p.text2, fontSize: 12)),
            Text(w.arabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: arabicStyle(44, color: p.text)),
            if (w.meaning != null && w.meaning!.isNotEmpty)
              Text('“${w.meaning}”',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: p.text2, fontSize: 15)),
            if (w.root != null && w.root!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Jad (root): ${w.root}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: p.text2, fontSize: 12)),
              ),
            const SizedBox(height: 8),
            // Gardan Button
            Builder(
              builder: (ctx) {
                final isVerb = w.segments.any((s) => s.kind == 'fil') ||
                    w.mainSegment?.kind == 'fil';
                final gardan = findGardanForWord(w.arabic, w.root);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isVerb ? const Color(0xFF0B6E4F) : p.bg,
                      foregroundColor: isVerb ? Colors.white : p.text,
                      elevation: isVerb ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: isVerb ? Colors.transparent : p.divider),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                    ),
                    icon: Icon(
                      isVerb ? Icons.menu_book_rounded : Icons.table_chart_outlined,
                      size: 18,
                      color: isVerb ? const Color(0xFFE0B84A) : p.primary,
                    ),
                    label: Text(
                      isVerb && gardan != null
                          ? '📖 "${gardan.name}" ki 14 Sighon ki Gardan'
                          : isVerb
                              ? '📖 Is Fe’l ki 14 Sighon ki Gardan'
                              : '14 Sighon ki Gardan (Sarf Explorer)',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    onPressed: () =>
                        showGardanModal(context, initialGardan: gardan),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            if (w.segments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Is lafz ki grammar abhi database mein nahi hai.',
                    textAlign: TextAlign.center, style: TextStyle(color: p.text2)),
              ),
            for (final s in w.segments) _segmentCard(s, p),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: idx > 0 ? () => setState(() => idx--) : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Pichla lafz'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: idx < words.length - 1 ? () => setState(() => idx++) : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Agla lafz'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _segmentCard(Segment s, Pal p) {
    final color = kindColor(s.kind);
    final rows = _rows(s);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(s.arabic, textDirection: TextDirection.rtl, style: arabicStyle(26, color: p.text)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                child: Text(kindLabel(s.kind),
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          ),
          if (s.label != null)
            Text(s.label!, style: const TextStyle(fontWeight: FontWeight.w600)),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(r.key, style: TextStyle(color: p.text2, fontSize: 12)),
                  ),
                  Expanded(child: Text(r.value, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
