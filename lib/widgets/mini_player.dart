import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final a = context.watch<AudioProvider>();
    if (a.current == null) return const SizedBox.shrink();
    const gold = Color(0xFFE0B84A);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF064E38),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                a.error ?? 'Ayat ${a.current} chal rahi hai',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          IconButton(
              color: gold,
              icon: const Icon(Icons.skip_previous),
              onPressed: a.previous),
          IconButton(
              color: gold,
              icon: Icon(a.playing ? Icons.pause : Icons.play_arrow),
              onPressed: a.toggle),
          IconButton(color: gold, icon: const Icon(Icons.skip_next), onPressed: a.next),
          IconButton(color: Colors.white70, icon: const Icon(Icons.close), onPressed: a.stop),
        ],
      ),
    );
  }
}
