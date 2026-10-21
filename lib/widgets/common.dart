import 'package:flutter/material.dart';
import '../core/theme.dart';

class GradientHeader extends StatelessWidget {
  final String title, subtitle;
  final List<Widget> actions;
  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle = '',
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18, MediaQuery.of(context).padding.top + 14, 8, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B6E4F), Color(0xFF064E38)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600)),
                if (subtitle.isNotEmpty)
                  Text(subtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final bool highlight;
  final EdgeInsets padding;
  const AppCard({
    super.key,
    required this.child,
    this.highlight = false,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding,
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: highlight ? p.gold : p.divider, width: highlight ? 2 : 1),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: child,
    );
  }
}

class GoldBadge extends StatelessWidget {
  final String text;
  const GoldBadge(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Pal.of(context).gold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Color(0xFF1F2933), fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

void snack(BuildContext c, String msg) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}
