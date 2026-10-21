import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/ayat_card.dart';
import '../widgets/common.dart';

class AyaatScreen extends StatefulWidget {
  const AyaatScreen({super.key});

  @override
  State<AyaatScreen> createState() => _AyaatScreenState();
}

class _AyaatScreenState extends State<AyaatScreen> {
  final Map<int, GlobalKey> _keys = {};

  void _scrollTo(int n) {
    final ctx = _keys[n]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 400), alignment: 0.05);
    }
  }

  Future<void> _ask() async {
    final c = TextEditingController();
    final n = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ayat number par jayein'),
        content: TextField(
          controller: c,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(hintText: 'jaise 12'),
          onSubmitted: (v) => Navigator.pop(ctx, int.tryParse(v)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, int.tryParse(c.text)),
              child: const Text('Jayein')),
        ],
      ),
    );
    if (n == null || !mounted) return;
    if (_keys.containsKey(n)) {
      _scrollTo(n);
    } else {
      snack(context, 'Ayat $n maujood nahi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Pal.of(context);

    final jump = app.jumpAyat;
    if (jump != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        app.jumpAyat = null;
        _scrollTo(jump);
      });
    }

    return Column(
      children: [
        GradientHeader(
          title: 'Surah Yaseen',
          subtitle: '${app.ayaat.length} ayaat · Makki · Para 22-23',
          actions: [
            IconButton(
              color: Colors.white,
              tooltip: 'Tarjuma show/hide',
              icon: Icon(app.showTranslation ? Icons.translate : Icons.translate_outlined),
              onPressed: () => app.setShowTranslation(!app.showTranslation),
            ),
            IconButton(
              color: Colors.white,
              tooltip: 'Ayat par jayein',
              icon: const Icon(Icons.search),
              onPressed: _ask,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          child: Wrap(
            spacing: 12,
            children: [
              for (final k in ['ism', 'fil', 'harf', 'zameer'])
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 10, height: 10, color: kindColor(k)),
                  const SizedBox(width: 4),
                  Text(kindLabel(k), style: TextStyle(fontSize: 11, color: p.text2)),
                ]),
            ],
          ),
        ),
        Expanded(
          child: app.ayaat.isEmpty
              ? const Center(child: Text('Database mein ayaat nahi mili'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      for (final a in app.ayaat)
                        KeyedSubtree(
                          key: _keys.putIfAbsent(a.id, () => GlobalKey()),
                          child: AyatCard(ayat: a),
                        ),
                      Text('Kisi bhi lafz par tap karein: grammar khul jayegi',
                          style: TextStyle(color: p.text2, fontSize: 11)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
