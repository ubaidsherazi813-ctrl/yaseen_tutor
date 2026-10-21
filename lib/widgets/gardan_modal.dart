import 'package:flutter/material.dart';
import '../core/gardan_data.dart';
import '../core/theme.dart';

void showGardanModal(BuildContext context, {VerbGardan? initialGardan}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => GardanModalSheet(initialGardan: initialGardan ?? khalakaGardan),
  );
}

class GardanModalSheet extends StatefulWidget {
  final VerbGardan initialGardan;
  const GardanModalSheet({super.key, required this.initialGardan});

  @override
  State<GardanModalSheet> createState() => _GardanModalSheetState();
}

class _GardanModalSheetState extends State<GardanModalSheet>
    with SingleTickerProviderStateMixin {
  late VerbGardan _current;
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _current = widget.initialGardan;
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (ctx, scroll) => Container(
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: p.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header with Verb selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: p.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.menu_book_rounded, color: p.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '14 Sighon ki Gardan (عربی گردان)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${_current.name} · ${_current.baab}',
                          style: TextStyle(color: p.text2, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Dropdown to switch verb
                  DropdownButton<VerbGardan>(
                    value: _current,
                    underline: const SizedBox(),
                    icon: Icon(Icons.arrow_drop_down_circle, color: p.primary),
                    items: allGardans.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text(
                          g.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _current = val);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Tab bar for Tenses
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: p.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabs,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: p.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: p.text2,
                tabs: const [
                  Tab(text: 'ماضی (14)'),
                  Tab(text: 'مضارع (14)'),
                  Tab(text: 'امر و نہی'),
                  Tab(text: 'ضمائر (14)'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _buildGardanList(_current.madhi, p, scroll, 'فعل ماضی (Past Tense)'),
                  _buildGardanList(_current.mudare, p, scroll, 'فعل مضارع (Present / Future Tense)'),
                  _buildAmrNahiList(_current, p, scroll),
                  _buildPronounsList(p, scroll),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGardanList(
    List<GardanEntry> entries,
    Pal p,
    ScrollController scroll,
    String title,
  ) {
    return ListView.builder(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: entries.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: p.primary,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  'Root: ${_current.root}',
                  style: TextStyle(fontSize: 12, color: p.text2),
                ),
              ],
            ),
          );
        }

        final e = entries[i - 1];
        final pronoun = pronounNames14[i - 1];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: p.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: p.divider.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              // Sigha index
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$i',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: p.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Details (Sigha + Meaning)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.sigha,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.urdu,
                      style: TextStyle(
                        fontSize: 12,
                        color: p.text2,
                      ),
                    ),
                    Text(
                      'ضمیر: $pronoun',
                      style: TextStyle(
                        fontSize: 11,
                        color: p.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Arabic Word
              Text(
                e.arabic,
                textDirection: TextDirection.rtl,
                style: arabicStyle(24, color: p.text),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmrNahiList(VerbGardan g, Pal p, ScrollController scroll) {
    return ListView(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        // Amr Section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'فعل امر (حکم دینا - Imperative / Commands)',
            style: TextStyle(fontWeight: FontWeight.bold, color: p.primary),
          ),
        ),
        for (int i = 0; i < g.amr.length; i++)
          _singleCard(g.amr[i], i + 1, p, const Color(0xFF1E9E5A)),

        const SizedBox(height: 16),

        // Nahi Section
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'فعل نہی (کسی کام سے منع کرنا - Prohibition)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD64545)),
          ),
        ),
        for (int i = 0; i < g.nahi.length; i++)
          _singleCard(g.nahi[i], i + 1, p, const Color(0xFFD64545)),
      ],
    );
  }

  Widget _singleCard(GardanEntry e, int idx, Pal p, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$idx',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.sigha, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(e.urdu, style: TextStyle(fontSize: 12, color: p.text2)),
              ],
            ),
          ),
          Text(
            e.arabic,
            textDirection: TextDirection.rtl,
            style: arabicStyle(22, color: p.text),
          ),
        ],
      ),
    );
  }

  Widget _buildPronounsList(Pal p, ScrollController scroll) {
    return ListView(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '14 ضمائر منفصلہ (Detached Pronouns Chart)',
            style: TextStyle(fontWeight: FontWeight.bold, color: p.primary),
          ),
        ),
        for (int i = 0; i < pronounNames14.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: p.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: p.divider.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE58A1F).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFFE58A1F),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sighaNames14[i],
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Text(
                        pronounNames14[i].split('(').last.replaceAll(')', ''),
                        style: TextStyle(fontSize: 12, color: p.text2),
                      ),
                    ],
                  ),
                ),
                Text(
                  pronounNames14[i].split('(').first.trim(),
                  textDirection: TextDirection.rtl,
                  style: arabicStyle(22, color: const Color(0xFFE58A1F)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
