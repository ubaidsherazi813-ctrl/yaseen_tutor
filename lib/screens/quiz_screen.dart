import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';

class _Q {
  final String word;
  final String answer; // ism | fil | harf
  _Q(this.word, this.answer);
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<_Q> questions = [];
  int index = 0, score = 0;
  String? picked;
  bool running = false, finished = false;

  void _start(AppState app) {
    // Database ke stem tukdon se sawalat banao (zameer bhi ism ki qism hai).
    final seen = <String>{};
    final pool = <_Q>[];
    for (final a in app.ayaat) {
      for (final w in a.words) {
        final s = w.mainSegment;
        if (s == null) continue;
        final kind = s.kind == 'zameer' ? 'ism' : s.kind;
        if (seen.add('${s.arabic}|$kind')) pool.add(_Q(s.arabic, kind));
      }
    }
    pool.shuffle(Random());
    setState(() {
      questions = pool.take(10).toList();
      index = 0;
      score = 0;
      picked = null;
      finished = questions.isEmpty;
      running = questions.isNotEmpty;
    });
  }

  Future<void> _answer(AppState app, String option) async {
    if (picked != null) return;
    setState(() {
      picked = option;
      if (option == questions[index].answer) score++;
    });
  }

  Future<void> _next(AppState app) async {
    if (index + 1 >= questions.length) {
      await app.saveQuiz(score, questions.length);
      setState(() {
        running = false;
        finished = true;
      });
    } else {
      setState(() {
        index++;
        picked = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Pal.of(context);

    Widget body;
    if (running) {
      final q = questions[index];
      body = ListView(
        padding: const EdgeInsets.all(14),
        children: [
          LinearProgressIndicator(value: (index + 1) / questions.length),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              children: [
                Text('Sawal ${index + 1}/${questions.length}', style: TextStyle(color: p.text2, fontSize: 12)),
                const SizedBox(height: 6),
                const Text('Is lafz ki qism kya hai?'),
                Text(q.word,
                    textDirection: TextDirection.rtl,
                    style: arabicStyle(46, color: p.text)),
                for (final o in ['ism', 'fil', 'harf']) _option(app, q, o, p),
                if (picked != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    picked == q.answer
                        ? 'Sahi jawab!'
                        : 'Sahi jawab: ${kindLabel(q.answer)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: picked == q.answer ? kindColor('fil') : kindColor('harf')),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => _next(app),
                    child: Text(index + 1 >= questions.length ? 'Result dekhein' : 'Agla sawal'),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    } else if (finished && questions.isNotEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            Text('Score: $score / ${questions.length}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            FilledButton(onPressed: () => _start(app), child: const Text('Dobara koshish karein')),
            TextButton(
                onPressed: () => setState(() => finished = false),
                child: const Text('Wapas')),
          ],
        ),
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.all(14),
        children: [
          AppCard(
            child: Column(
              children: [
                const Text('Grammar Quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('Lafz dekh kar batayein: Ism, Fe’l ya Harf?', style: TextStyle(color: p.text2)),
                const SizedBox(height: 12),
                FilledButton(
                    onPressed: app.ayaat.isEmpty ? null : () => _start(app),
                    child: const Text('Quiz shuru karein')),
              ],
            ),
          ),
          if (app.quizzes.isNotEmpty)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pichle scores', style: TextStyle(fontWeight: FontWeight.w600)),
                  for (final r in app.quizzes.take(5))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                          '${(r['taken_at'] as String).substring(0, 10)}   ·   ${r['score']}/${r['total']}'),
                    ),
                ],
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        const GradientHeader(title: 'Quiz', subtitle: 'Apni grammar parkhein'),
        Expanded(child: body),
      ],
    );
  }

  Widget _option(AppState app, _Q q, String o, Pal p) {
    Color? bg;
    Color? fg;
    if (picked != null) {
      if (o == q.answer) {
        bg = kindColor('fil');
        fg = Colors.white;
      } else if (o == picked) {
        bg = kindColor('harf');
        fg = Colors.white;
      }
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg ?? p.text,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => _answer(app, o),
        child: Text(kindLabel(o)),
      ),
    );
  }
}
