import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Pal.of(context);
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(
            title: 'Mauzoobaat',
            subtitle: 'Surat ke main topics',
            actions: [
              IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                for (final t in app.topics)
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pop(context);
                      app.goTab(1, ayat: t.startAyat);
                    },
                    child: AppCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: p.primary,
                              child: Text('${t.id}', style: const TextStyle(color: Colors.white))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text('Ayat ${t.startAyat} - ${t.endAyat}',
                                    style: TextStyle(color: p.text2, fontSize: 12)),
                                if (t.description != null)
                                  Text(t.description!, style: TextStyle(color: p.text2, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                Text('Ayat ki hadein taqreeban hain, ustad se confirm karein.',
                    style: TextStyle(fontSize: 11, color: p.text2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
